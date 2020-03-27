Return-Path: <kernel-hardening-return-18265-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BDB02195CA4
	for <lists+kernel-hardening@lfdr.de>; Fri, 27 Mar 2020 18:25:51 +0100 (CET)
Received: (qmail 24505 invoked by uid 550); 27 Mar 2020 17:24:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24374 invoked from network); 27 Mar 2020 17:24:20 -0000
From: Alexey Gladkov <gladkov.alexey@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux API <linux-api@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Linux Security Module <linux-security-module@vger.kernel.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Alexey Gladkov <legion@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Daniel Micay <danielmicay@gmail.com>,
	Djalal Harouni <tixxdz@gmail.com>,
	"Dmitry V . Levin" <ldv@altlinux.org>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@kernel.org>,
	"J . Bruce Fields" <bfields@fieldses.org>,
	Jeff Layton <jlayton@poochiereds.net>,
	Jonathan Corbet <corbet@lwn.net>,
	Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH v10 9/9] proc: use named enums for better readability
Date: Fri, 27 Mar 2020 18:23:31 +0100
Message-Id: <20200327172331.418878-10-gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200327172331.418878-1-gladkov.alexey@gmail.com>
References: <20200327172331.418878-1-gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Fri, 27 Mar 2020 17:24:02 +0000 (UTC)

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
---
 fs/proc/base.c               | 2 +-
 fs/proc/inode.c              | 2 +-
 fs/proc/root.c               | 4 ++--
 include/linux/proc_fs.h      | 6 +++---
 include/uapi/linux/proc_fs.h | 2 +-
 5 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 1ebe9eba48ea..2f2f7b36c947 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -699,7 +699,7 @@ int proc_setattr(struct dentry *dentry, struct iattr *attr)
  */
 static bool has_pid_permissions(struct proc_fs_info *fs_info,
 				 struct task_struct *task,
-				 int hide_pid_min)
+				 enum proc_hidepid hide_pid_min)
 {
 	/*
 	 * If 'hidpid' mount option is set force a ptrace check,
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index f01fb4bed75c..77128bc36a05 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -165,7 +165,7 @@ void proc_invalidate_siblings_dcache(struct hlist_head *inodes, spinlock_t *lock
 		deactivate_super(old_sb);
 }
 
-static inline const char *hidepid2str(int v)
+static inline const char *hidepid2str(enum proc_hidepid v)
 {
 	switch (v) {
 		case HIDEPID_OFF: return "off";
diff --git a/fs/proc/root.c b/fs/proc/root.c
index ba782d6e6197..00f75d8ef32f 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -32,9 +32,9 @@
 struct proc_fs_context {
 	struct proc_fs_info	*fs_info;
 	unsigned int		mask;
-	int			hidepid;
+	enum proc_hidepid	hidepid;
 	int			gid;
-	int			pidonly;
+	enum proc_pidonly	pidonly;
 };
 
 enum proc_param {
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index d259817ec913..b9f7ecd7f61f 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -29,7 +29,7 @@ struct proc_ops {
 };
 
 /* definitions for proc mount option pidonly */
-enum {
+enum proc_pidonly {
 	PROC_PIDONLY_OFF = 0,
 	PROC_PIDONLY_ON  = 1,
 };
@@ -39,8 +39,8 @@ struct proc_fs_info {
 	struct dentry *proc_self;        /* For /proc/self */
 	struct dentry *proc_thread_self; /* For /proc/thread-self */
 	kgid_t pid_gid;
-	int hide_pid;
-	int pidonly;
+	enum proc_hidepid hide_pid;
+	enum proc_pidonly pidonly;
 };
 
 static inline struct proc_fs_info *proc_sb_info(struct super_block *sb)
diff --git a/include/uapi/linux/proc_fs.h b/include/uapi/linux/proc_fs.h
index dc6d717aa6ec..f5fe0e8dcfe4 100644
--- a/include/uapi/linux/proc_fs.h
+++ b/include/uapi/linux/proc_fs.h
@@ -3,7 +3,7 @@
 #define _UAPI_PROC_FS_H
 
 /* definitions for hide_pid field */
-enum {
+enum proc_hidepid {
 	HIDEPID_OFF            = 0,
 	HIDEPID_NO_ACCESS      = 1,
 	HIDEPID_INVISIBLE      = 2,
-- 
2.25.2

