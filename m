Return-Path: <kernel-hardening-return-18264-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C1312195CA3
	for <lists+kernel-hardening@lfdr.de>; Fri, 27 Mar 2020 18:25:39 +0100 (CET)
Received: (qmail 24473 invoked by uid 550); 27 Mar 2020 17:24:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24273 invoked from network); 27 Mar 2020 17:24:19 -0000
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
Subject: [PATCH v10 8/9] proc: use human-readable values for hidehid
Date: Fri, 27 Mar 2020 18:23:30 +0100
Message-Id: <20200327172331.418878-9-gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200327172331.418878-1-gladkov.alexey@gmail.com>
References: <20200327172331.418878-1-gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Fri, 27 Mar 2020 17:24:02 +0000 (UTC)

The hidepid parameter values are becoming more and more and it becomes
difficult to remember what each new magic number means.

Suggested-by: Andy Lutomirski <luto@kernel.org>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
---
 Documentation/filesystems/proc.txt | 52 +++++++++++++++---------------
 fs/proc/inode.c                    | 13 +++++++-
 fs/proc/root.c                     | 36 +++++++++++++++++++--
 3 files changed, 71 insertions(+), 30 deletions(-)

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index bd0e0ab85048..af47672cb2cb 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -2025,28 +2025,28 @@ The following mount options are supported:
 	gid=		Set the group authorized to learn processes information.
 	subset=		Show only the specified subset of procfs.
 
-hidepid=0 means classic mode - everybody may access all /proc/<pid>/ directories
-(default).
-
-hidepid=1 means users may not access any /proc/<pid>/ directories but their
-own.  Sensitive files like cmdline, sched*, status are now protected against
-other users.  This makes it impossible to learn whether any user runs
-specific program (given the program doesn't reveal itself by its behaviour).
-As an additional bonus, as /proc/<pid>/cmdline is unaccessible for other users,
-poorly written programs passing sensitive information via program arguments are
-now protected against local eavesdroppers.
-
-hidepid=2 means hidepid=1 plus all /proc/<pid>/ will be fully invisible to other
-users.  It doesn't mean that it hides a fact whether a process with a specific
-pid value exists (it can be learned by other means, e.g. by "kill -0 $PID"),
-but it hides process' uid and gid, which may be learned by stat()'ing
-/proc/<pid>/ otherwise.  It greatly complicates an intruder's task of gathering
-information about running processes, whether some daemon runs with elevated
-privileges, whether other user runs some sensitive program, whether other users
-run any program at all, etc.
-
-hidepid=4 means that procfs should only contain /proc/<pid>/ directories
-that the caller can ptrace.
+hidepid=off or hidepid=0 means classic mode - everybody may access all
+/proc/<pid>/ directories (default).
+
+hidepid=noaccess or hidepid=1 means users may not access any /proc/<pid>/
+directories but their own.  Sensitive files like cmdline, sched*, status are now
+protected against other users.  This makes it impossible to learn whether any
+user runs specific program (given the program doesn't reveal itself by its
+behaviour).  As an additional bonus, as /proc/<pid>/cmdline is unaccessible for
+other users, poorly written programs passing sensitive information via program
+arguments are now protected against local eavesdroppers.
+
+hidepid=invisible or hidepid=2 means hidepid=noaccess plus all /proc/<pid>/ will
+be fully invisible to other users.  It doesn't mean that it hides a fact whether
+a process with a specific pid value exists (it can be learned by other means,
+e.g. by "kill -0 $PID"), but it hides process' uid and gid, which may be learned
+by stat()'ing /proc/<pid>/ otherwise.  It greatly complicates an intruder's task
+of gathering information about running processes, whether some daemon runs with
+elevated privileges, whether other user runs some sensitive program, whether
+other users run any program at all, etc.
+
+hidepid=ptraceable or hidepid=4 means that procfs should only contain
+/proc/<pid>/ directories that the caller can ptrace.
 
 gid= defines a group authorized to learn processes information otherwise
 prohibited by hidepid=.  If you use some daemon like identd which needs to learn
@@ -2093,8 +2093,8 @@ creates a new procfs instance. Mount options affect own procfs instance.
 It means that it became possible to have several procfs instances
 displaying tasks with different filtering options in one pid namespace.
 
-# mount -o hidepid=2 -t proc proc /proc
-# mount -o hidepid=1 -t proc proc /tmp/proc
+# mount -o hidepid=invisible -t proc proc /proc
+# mount -o hidepid=noaccess -t proc proc /tmp/proc
 # grep ^proc /proc/mounts
-proc /proc proc rw,relatime,hidepid=2 0 0
-proc /tmp/proc proc rw,relatime,hidepid=1 0 0
+proc /proc proc rw,relatime,hidepid=invisible 0 0
+proc /tmp/proc proc rw,relatime,hidepid=noaccess 0 0
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index e6577ce6027b..f01fb4bed75c 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -165,6 +165,17 @@ void proc_invalidate_siblings_dcache(struct hlist_head *inodes, spinlock_t *lock
 		deactivate_super(old_sb);
 }
 
+static inline const char *hidepid2str(int v)
+{
+	switch (v) {
+		case HIDEPID_OFF: return "off";
+		case HIDEPID_NO_ACCESS: return "noaccess";
+		case HIDEPID_INVISIBLE: return "invisible";
+		case HIDEPID_NOT_PTRACEABLE: return "ptraceable";
+	}
+	BUG();
+}
+
 static int proc_show_options(struct seq_file *seq, struct dentry *root)
 {
 	struct proc_fs_info *fs_info = proc_sb_info(root->d_sb);
@@ -172,7 +183,7 @@ static int proc_show_options(struct seq_file *seq, struct dentry *root)
 	if (!gid_eq(fs_info->pid_gid, GLOBAL_ROOT_GID))
 		seq_printf(seq, ",gid=%u", from_kgid_munged(&init_user_ns, fs_info->pid_gid));
 	if (fs_info->hide_pid != HIDEPID_OFF)
-		seq_printf(seq, ",hidepid=%u", fs_info->hide_pid);
+		seq_printf(seq, ",hidepid=%s", hidepid2str(fs_info->hide_pid));
 	if (fs_info->pidonly != PROC_PIDONLY_OFF)
 		seq_printf(seq, ",subset=pid");
 
diff --git a/fs/proc/root.c b/fs/proc/root.c
index dbcd96f07c7a..ba782d6e6197 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -45,7 +45,7 @@ enum proc_param {
 
 static const struct fs_parameter_spec proc_fs_parameters[] = {
 	fsparam_u32("gid",	Opt_gid),
-	fsparam_u32("hidepid",	Opt_hidepid),
+	fsparam_string("hidepid",	Opt_hidepid),
 	fsparam_string("subset",	Opt_subset),
 	{}
 };
@@ -58,6 +58,35 @@ static inline int valid_hidepid(unsigned int value)
 		value == HIDEPID_NOT_PTRACEABLE);
 }
 
+static int proc_parse_hidepid_param(struct fs_context *fc, struct fs_parameter *param)
+{
+	struct proc_fs_context *ctx = fc->fs_private;
+	struct fs_parameter_spec hidepid_u32_spec = fsparam_u32("hidepid", Opt_hidepid);
+	struct fs_parse_result result;
+	int base = (unsigned long)hidepid_u32_spec.data;
+
+	if (param->type != fs_value_is_string)
+		return invalf(fc, "proc: unexpected type of hidepid value\n");
+
+	if (!kstrtouint(param->string, base, &result.uint_32)) {
+		ctx->hidepid = result.uint_32;
+		return 0;
+	}
+
+	if (!strcmp(param->string, "off"))
+		ctx->hidepid = HIDEPID_OFF;
+	else if (!strcmp(param->string, "noaccess"))
+		ctx->hidepid = HIDEPID_NO_ACCESS;
+	else if (!strcmp(param->string, "invisible"))
+		ctx->hidepid = HIDEPID_INVISIBLE;
+	else if (!strcmp(param->string, "ptraceable"))
+		ctx->hidepid = HIDEPID_NOT_PTRACEABLE;
+	else
+		return invalf(fc, "proc: unknown value of hidepid - %s\n", param->string);
+
+	return 0;
+}
+
 static int proc_parse_subset_param(struct fs_context *fc, char *value)
 {
 	struct proc_fs_context *ctx = fc->fs_private;
@@ -97,9 +126,10 @@ static int proc_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		break;
 
 	case Opt_hidepid:
-		if (!valid_hidepid(result.uint_32))
+		if (proc_parse_hidepid_param(fc, param))
+			return -EINVAL;
+		if (!valid_hidepid(ctx->hidepid))
 			return invalf(fc, "proc: unknown value of hidepid.\n");
-		ctx->hidepid = result.uint_32;
 		break;
 
 	case Opt_subset:
-- 
2.25.2

