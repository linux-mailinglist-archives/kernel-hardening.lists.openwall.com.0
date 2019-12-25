Return-Path: <kernel-hardening-return-17532-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 02C1712A7E6
	for <lists+kernel-hardening@lfdr.de>; Wed, 25 Dec 2019 13:54:13 +0100 (CET)
Received: (qmail 25807 invoked by uid 550); 25 Dec 2019 12:53:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25742 invoked from network); 25 Dec 2019 12:53:23 -0000
From: Alexey Gladkov <gladkov.alexey@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux API <linux-api@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Linux Security Module <linux-security-module@vger.kernel.org>
Cc: Akinobu Mita <akinobu.mita@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Alexey Gladkov <gladkov.alexey@gmail.com>,
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
	Oleg Nesterov <oleg@redhat.com>,
	Solar Designer <solar@openwall.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH v6 05/10] proc: add helpers to set and get proc hidepid and gid mount options
Date: Wed, 25 Dec 2019 13:51:46 +0100
Message-Id: <20191225125151.1950142-6-gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191225125151.1950142-1-gladkov.alexey@gmail.com>
References: <20191225125151.1950142-1-gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is a cleaning patch to add helpers to set and get proc mount
options instead of directly using them. This make it easy to track
what's happening and easy to update in future.

Cc: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
---
 fs/proc/base.c          |  6 +++---
 fs/proc/inode.c         | 11 +++++++----
 fs/proc/root.c          |  8 ++++----
 include/linux/proc_fs.h | 38 ++++++++++++++++++++++++++++++++++++++
 4 files changed, 52 insertions(+), 11 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index caca1929fee1..4ccb280a3e79 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -699,9 +699,9 @@ static bool has_pid_permissions(struct proc_fs_info *fs_info,
 				 struct task_struct *task,
 				 int hide_pid_min)
 {
-	if (fs_info->hide_pid < hide_pid_min)
+	if (proc_fs_hide_pid(fs_info) < hide_pid_min)
 		return true;
-	if (in_group_p(fs_info->pid_gid))
+	if (in_group_p(proc_fs_pid_gid(fs_info)))
 		return true;
 	return ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS);
 }
@@ -720,7 +720,7 @@ static int proc_pid_permission(struct inode *inode, int mask)
 	put_task_struct(task);
 
 	if (!has_perms) {
-		if (fs_info->hide_pid == HIDEPID_INVISIBLE) {
+		if (proc_fs_hide_pid(fs_info) == HIDEPID_INVISIBLE) {
 			/*
 			 * Let's make getdents(), stat(), and open()
 			 * consistent with each other.  If a process
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index b90c233e5968..70b722fb8811 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -105,11 +105,14 @@ void __init proc_init_kmemcache(void)
 static int proc_show_options(struct seq_file *seq, struct dentry *root)
 {
 	struct proc_fs_info *fs_info = proc_sb_info(root->d_sb);
+	int hidepid = proc_fs_hide_pid(fs_info);
+	kgid_t gid = proc_fs_pid_gid(fs_info);
 
-	if (!gid_eq(fs_info->pid_gid, GLOBAL_ROOT_GID))
-		seq_printf(seq, ",gid=%u", from_kgid_munged(&init_user_ns, fs_info->pid_gid));
-	if (fs_info->hide_pid != HIDEPID_OFF)
-		seq_printf(seq, ",hidepid=%u", fs_info->hide_pid);
+	if (!gid_eq(gid, GLOBAL_ROOT_GID))
+		seq_printf(seq, ",gid=%u", from_kgid_munged(&init_user_ns, gid));
+
+	if (hidepid != HIDEPID_OFF)
+		seq_printf(seq, ",hidepid=%u", hidepid);
 
 	return 0;
 }
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 1ca47d446aa4..efd76c004e86 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -91,14 +91,14 @@ static void proc_apply_options(struct super_block *s,
 
 	if (pid_ns->proc_mnt) {
 		struct proc_fs_info *fs_info = proc_sb_info(pid_ns->proc_mnt->mnt_sb);
-		ctx->fs_info->pid_gid = fs_info->pid_gid;
-		ctx->fs_info->hide_pid = fs_info->hide_pid;
+		proc_fs_set_pid_gid(ctx->fs_info, proc_fs_pid_gid(fs_info));
+		proc_fs_set_hide_pid(ctx->fs_info, proc_fs_hide_pid(fs_info));
 	}
 
 	if (ctx->mask & (1 << Opt_gid))
-		ctx->fs_info->pid_gid = make_kgid(user_ns, ctx->gid);
+		proc_fs_set_pid_gid(ctx->fs_info, make_kgid(user_ns, ctx->gid));
 	if (ctx->mask & (1 << Opt_hidepid))
-		ctx->fs_info->hide_pid = ctx->hidepid;
+		proc_fs_set_hide_pid(ctx->fs_info, ctx->hidepid);
 }
 
 static int proc_fill_super(struct super_block *s, struct fs_context *fc)
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 05ecf4e8923f..fd92bf38aa62 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -36,6 +36,26 @@ static inline struct proc_fs_info *proc_sb_info(struct super_block *sb)
 	return sb->s_fs_info;
 }
 
+static inline void proc_fs_set_hide_pid(struct proc_fs_info *fs_info, int hide_pid)
+{
+	fs_info->hide_pid = hide_pid;
+}
+
+static inline void proc_fs_set_pid_gid(struct proc_fs_info *fs_info, kgid_t gid)
+{
+	fs_info->pid_gid = gid;
+}
+
+static inline int proc_fs_hide_pid(struct proc_fs_info *fs_info)
+{
+	return fs_info->hide_pid;
+}
+
+static inline kgid_t proc_fs_pid_gid(struct proc_fs_info *fs_info)
+{
+	return fs_info->pid_gid;
+}
+
 extern void proc_root_init(void);
 extern void proc_flush_task(struct task_struct *);
 
@@ -111,6 +131,24 @@ static inline struct proc_fs_info *proc_sb_info(struct super_block *sb)
 	return NULL;
 }
 
+static inline void proc_fs_set_hide_pid(struct proc_fs_info *fs_info, int hide_pid)
+{
+}
+
+static inline void proc_fs_set_pid_gid(struct proc_info_fs *fs_info, kgid_t gid)
+{
+}
+
+static inline int proc_fs_hide_pid(struct proc_fs_info *fs_info)
+{
+	return 0;
+}
+
+extern kgid_t proc_fs_pid_gid(struct proc_fs_info *fs_info)
+{
+	return GLOBAL_ROOT_GID;
+}
+
 static inline void proc_root_init(void)
 {
 }
-- 
2.24.1

