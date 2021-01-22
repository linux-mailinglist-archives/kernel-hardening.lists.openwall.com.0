Return-Path: <kernel-hardening-return-20696-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D5ECE3003A6
	for <lists+kernel-hardening@lfdr.de>; Fri, 22 Jan 2021 14:02:16 +0100 (CET)
Received: (qmail 11308 invoked by uid 550); 22 Jan 2021 13:01:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 10125 invoked from network); 22 Jan 2021 13:01:14 -0000
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
Subject: [PATCH v4 6/7] Move RLIMIT_NPROC check to the place where we increment the counter
Date: Fri, 22 Jan 2021 14:00:15 +0100
Message-Id: <f3d4035b4aee52ece0e90606bcb8243a1646c03b.1611320161.git.gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1611320161.git.gladkov.alexey@gmail.com>
References: <cover.1611320161.git.gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Fri, 22 Jan 2021 13:00:54 +0000 (UTC)

After calling set_user(), we always have to call commit_creds() to apply
new credentials upon the current task. There is no need to separate
limit check and counter incrementing.

Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
---
 kernel/cred.c | 22 +++++++++++++++++-----
 kernel/sys.c  | 13 -------------
 2 files changed, 17 insertions(+), 18 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index fdb40adc2ebd..334d2c9ae519 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -487,14 +487,26 @@ int commit_creds(struct cred *new)
 	if (!gid_eq(new->fsgid, old->fsgid))
 		key_fsgid_changed(new);
 
-	/* do it
-	 * RLIMIT_NPROC limits on user->processes have already been checked
-	 * in set_user().
-	 */
 	alter_cred_subscribers(new, 2);
 	if (new->user != old->user || new->user_ns != old->user_ns) {
+		bool overlimit;
+
 		set_cred_ucounts(new, new->user_ns, new->euid);
-		inc_rlimit_ucounts(new->ucounts, UCOUNT_RLIMIT_NPROC, 1);
+
+		overlimit = inc_rlimit_ucounts_and_test(new->ucounts, UCOUNT_RLIMIT_NPROC,
+				1, rlimit(RLIMIT_NPROC));
+
+		/*
+		 * We don't fail in case of NPROC limit excess here because too many
+		 * poorly written programs don't check set*uid() return code, assuming
+		 * it never fails if called by root.  We may still enforce NPROC limit
+		 * for programs doing set*uid()+execve() by harmlessly deferring the
+		 * failure to the execve() stage.
+		 */
+		if (overlimit && new->user != INIT_USER)
+			current->flags |= PF_NPROC_EXCEEDED;
+		else
+			current->flags &= ~PF_NPROC_EXCEEDED;
 	}
 	rcu_assign_pointer(task->real_cred, new);
 	rcu_assign_pointer(task->cred, new);
diff --git a/kernel/sys.c b/kernel/sys.c
index c2734ab9474e..180c4e06064f 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -467,19 +467,6 @@ static int set_user(struct cred *new)
 	if (!new_user)
 		return -EAGAIN;
 
-	/*
-	 * We don't fail in case of NPROC limit excess here because too many
-	 * poorly written programs don't check set*uid() return code, assuming
-	 * it never fails if called by root.  We may still enforce NPROC limit
-	 * for programs doing set*uid()+execve() by harmlessly deferring the
-	 * failure to the execve() stage.
-	 */
-	if (is_ucounts_overlimit(new->ucounts, UCOUNT_RLIMIT_NPROC, rlimit(RLIMIT_NPROC)) &&
-			new_user != INIT_USER)
-		current->flags |= PF_NPROC_EXCEEDED;
-	else
-		current->flags &= ~PF_NPROC_EXCEEDED;
-
 	free_uid(new->user);
 	new->user = new_user;
 	return 0;
-- 
2.29.2

