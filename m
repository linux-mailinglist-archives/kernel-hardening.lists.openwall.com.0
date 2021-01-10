Return-Path: <kernel-hardening-return-20628-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8B2FC2F08C5
	for <lists+kernel-hardening@lfdr.de>; Sun, 10 Jan 2021 18:35:42 +0100 (CET)
Received: (qmail 11651 invoked by uid 550); 10 Jan 2021 17:35:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11291 invoked from network); 10 Jan 2021 17:35:02 -0000
From: Alexey Gladkov <gladkov.alexey@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
	Linux Containers <containers@lists.linux-foundation.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Alexey Gladkov <legion@kernel.org>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Kees Cook <keescook@chromium.org>,
	Christian Brauner <christian@brauner.io>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [RFC PATCH v2 1/8] Use atomic type for ucounts reference counting
Date: Sun, 10 Jan 2021 18:33:40 +0100
Message-Id: <447547b12bba1894d3f1f79d6408dfc60b219b0c.1610299857.git.gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1610299857.git.gladkov.alexey@gmail.com>
References: <cover.1610299857.git.gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Sun, 10 Jan 2021 17:34:51 +0000 (UTC)

Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
---
 include/linux/user_namespace.h |  2 +-
 kernel/ucount.c                | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
index 64cf8ebdc4ec..84fefa9247c4 100644
--- a/include/linux/user_namespace.h
+++ b/include/linux/user_namespace.h
@@ -92,7 +92,7 @@ struct ucounts {
 	struct hlist_node node;
 	struct user_namespace *ns;
 	kuid_t uid;
-	int count;
+	atomic_t count;
 	atomic_t ucount[UCOUNT_COUNTS];
 };
 
diff --git a/kernel/ucount.c b/kernel/ucount.c
index 11b1596e2542..0f2c7c11df19 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -141,7 +141,8 @@ static struct ucounts *get_ucounts(struct user_namespace *ns, kuid_t uid)
 
 		new->ns = ns;
 		new->uid = uid;
-		new->count = 0;
+
+		atomic_set(&new->count, 0);
 
 		spin_lock_irq(&ucounts_lock);
 		ucounts = find_ucounts(ns, uid, hashent);
@@ -152,10 +153,10 @@ static struct ucounts *get_ucounts(struct user_namespace *ns, kuid_t uid)
 			ucounts = new;
 		}
 	}
-	if (ucounts->count == INT_MAX)
+	if (atomic_read(&ucounts->count) == INT_MAX)
 		ucounts = NULL;
 	else
-		ucounts->count += 1;
+		atomic_inc(&ucounts->count);
 	spin_unlock_irq(&ucounts_lock);
 	return ucounts;
 }
@@ -165,8 +166,7 @@ static void put_ucounts(struct ucounts *ucounts)
 	unsigned long flags;
 
 	spin_lock_irqsave(&ucounts_lock, flags);
-	ucounts->count -= 1;
-	if (!ucounts->count)
+	if (atomic_dec_and_test(&ucounts->count))
 		hlist_del_init(&ucounts->node);
 	else
 		ucounts = NULL;
-- 
2.29.2

