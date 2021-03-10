Return-Path: <kernel-hardening-return-20901-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D403E333BEB
	for <lists+kernel-hardening@lfdr.de>; Wed, 10 Mar 2021 13:02:33 +0100 (CET)
Received: (qmail 7459 invoked by uid 550); 10 Mar 2021 12:01:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7366 invoked from network); 10 Mar 2021 12:01:55 -0000
From: Alexey Gladkov <gladkov.alexey@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
	io-uring@vger.kernel.org,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux Containers <containers@lists.linux-foundation.org>,
	linux-mm@kvack.org
Cc: Alexey Gladkov <legion@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Jann Horn <jannh@google.com>,
	Jens Axboe <axboe@kernel.dk>,
	Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH v8 3/8] Use atomic_t for ucounts reference counting
Date: Wed, 10 Mar 2021 13:01:28 +0100
Message-Id: <59ee3289194cd97d70085cce701bc494bfcb4fd2.1615372955.git.gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1615372955.git.gladkov.alexey@gmail.com>
References: <cover.1615372955.git.gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.4 (raptor.unsafe.ru [0.0.0.0]); Wed, 10 Mar 2021 12:01:44 +0000 (UTC)

The current implementation of the ucounts reference counter requires the
use of spin_lock. We're going to use get_ucounts() in more performance
critical areas like a handling of RLIMIT_SIGPENDING.

Now we need to use spin_lock only if we want to change the hashtable.

Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
---
 include/linux/user_namespace.h |  4 +--
 kernel/ucount.c                | 60 +++++++++++++++-------------------
 2 files changed, 28 insertions(+), 36 deletions(-)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index f71b5a4a3e74..d84cc2c0b443 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -92,7 +92,7 @@ struct ucounts {
 	struct hlist_node node;
 	struct user_namespace *ns;
 	kuid_t uid;
-	int count;
+	atomic_t count;
 	atomic_long_t ucount[UCOUNT_COUNTS];
 };
 
@@ -104,7 +104,7 @@ void retire_userns_sysctls(struct user_namespace *ns);
 struct ucounts *inc_ucount(struct user_namespace *ns, kuid_t uid, enum ucount_type type);
 void dec_ucount(struct ucounts *ucounts, enum ucount_type type);
 struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid);
-struct ucounts *get_ucounts(struct ucounts *ucounts);
+struct ucounts * __must_check get_ucounts(struct ucounts *ucounts);
 void put_ucounts(struct ucounts *ucounts);
 
 #ifdef CONFIG_USER_NS
diff --git a/kernel/ucount.c b/kernel/ucount.c
index 50cc1dfb7d28..bb3203039b5e 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -11,7 +11,7 @@
 struct ucounts init_ucounts = {
 	.ns    = &init_user_ns,
 	.uid   = GLOBAL_ROOT_UID,
-	.count = 1,
+	.count = ATOMIC_INIT(1),
 };
 
 #define UCOUNTS_HASHTABLE_BITS 10
@@ -139,6 +139,22 @@ static void hlist_add_ucounts(struct ucounts *ucounts)
 	spin_unlock_irq(&ucounts_lock);
 }
 
+/* 127: arbitrary random number, small enough to assemble well */
+#define refcount_zero_or_close_to_overflow(ucounts) \
+	((unsigned int) atomic_read(&ucounts->count) + 127u <= 127u)
+
+struct ucounts *get_ucounts(struct ucounts *ucounts)
+{
+	if (ucounts) {
+		if (refcount_zero_or_close_to_overflow(ucounts)) {
+			WARN_ONCE(1, "ucounts: counter has reached its maximum value");
+			return NULL;
+		}
+		atomic_inc(&ucounts->count);
+	}
+	return ucounts;
+}
+
 struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid)
 {
 	struct hlist_head *hashent = ucounts_hashentry(ns, uid);
@@ -155,7 +171,7 @@ struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid)
 
 		new->ns = ns;
 		new->uid = uid;
-		new->count = 0;
+		atomic_set(&new->count, 1);
 
 		spin_lock_irq(&ucounts_lock);
 		ucounts = find_ucounts(ns, uid, hashent);
@@ -163,33 +179,12 @@ struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid)
 			kfree(new);
 		} else {
 			hlist_add_head(&new->node, hashent);
-			ucounts = new;
+			spin_unlock_irq(&ucounts_lock);
+			return new;
 		}
 	}
-	if (ucounts->count == INT_MAX)
-		ucounts = NULL;
-	else
-		ucounts->count += 1;
 	spin_unlock_irq(&ucounts_lock);
-	return ucounts;
-}
-
-struct ucounts *get_ucounts(struct ucounts *ucounts)
-{
-	unsigned long flags;
-
-	if (!ucounts)
-		return NULL;
-
-	spin_lock_irqsave(&ucounts_lock, flags);
-	if (ucounts->count == INT_MAX) {
-		WARN_ONCE(1, "ucounts: counter has reached its maximum value");
-		ucounts = NULL;
-	} else {
-		ucounts->count += 1;
-	}
-	spin_unlock_irqrestore(&ucounts_lock, flags);
-
+	ucounts = get_ucounts(ucounts);
 	return ucounts;
 }
 
@@ -197,15 +192,12 @@ void put_ucounts(struct ucounts *ucounts)
 {
 	unsigned long flags;
 
-	spin_lock_irqsave(&ucounts_lock, flags);
-	ucounts->count -= 1;
-	if (!ucounts->count)
+	if (atomic_dec_and_test(&ucounts->count)) {
+		spin_lock_irqsave(&ucounts_lock, flags);
 		hlist_del_init(&ucounts->node);
-	else
-		ucounts = NULL;
-	spin_unlock_irqrestore(&ucounts_lock, flags);
-
-	kfree(ucounts);
+		spin_unlock_irqrestore(&ucounts_lock, flags);
+		kfree(ucounts);
+	}
 }
 
 static inline bool atomic_long_inc_below(atomic_long_t *v, int u)
-- 
2.29.2

