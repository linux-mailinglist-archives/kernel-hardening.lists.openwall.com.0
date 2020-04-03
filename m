Return-Path: <kernel-hardening-return-18419-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id CB64E19DDCD
	for <lists+kernel-hardening@lfdr.de>; Fri,  3 Apr 2020 20:19:25 +0200 (CEST)
Received: (qmail 32243 invoked by uid 550); 3 Apr 2020 18:18:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32044 invoked from network); 3 Apr 2020 18:18:04 -0000
From: Alexey Gladkov <gladkov.alexey@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux API <linux-api@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Linux Security Module <linux-security-module@vger.kernel.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
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
	Oleg Nesterov <oleg@redhat.com>,
	David Howells <dhowells@redhat.com>
Subject: [PATCH v11 5/8] proc: add option to mount only a pids subset
Date: Fri,  3 Apr 2020 20:06:45 +0200
Message-Id: <20200403180648.721362-6-gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200403180648.721362-1-gladkov.alexey@gmail.com>
References: <20200403180648.721362-1-gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Fri, 03 Apr 2020 18:07:28 +0000 (UTC)

This allows to hide all files and directories in the procfs that are not
related to tasks.

Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 fs/proc/generic.c       |  9 +++++++++
 fs/proc/inode.c         |  6 ++++++
 fs/proc/root.c          | 33 +++++++++++++++++++++++++++++++++
 include/linux/proc_fs.h |  7 +++++++
 4 files changed, 55 insertions(+)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 3faed94e4b65..ee5b6482009c 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -269,6 +269,11 @@ struct dentry *proc_lookup_de(struct inode *dir, struct dentry *dentry,
 struct dentry *proc_lookup(struct inode *dir, struct dentry *dentry,
 		unsigned int flags)
 {
+	struct proc_fs_info *fs_info = proc_sb_info(dir->i_sb);
+
+	if (fs_info->pidonly == PROC_PIDONLY_ON)
+		return ERR_PTR(-ENOENT);
+
 	return proc_lookup_de(dir, dentry, PDE(dir));
 }
 
@@ -325,6 +330,10 @@ int proc_readdir_de(struct file *file, struct dir_context *ctx,
 int proc_readdir(struct file *file, struct dir_context *ctx)
 {
 	struct inode *inode = file_inode(file);
+	struct proc_fs_info *fs_info = proc_sb_info(inode->i_sb);
+
+	if (fs_info->pidonly == PROC_PIDONLY_ON)
+		return 1;
 
 	return proc_readdir_de(file, ctx, PDE(inode));
 }
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 91fe4896fa85..e6577ce6027b 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -173,6 +173,8 @@ static int proc_show_options(struct seq_file *seq, struct dentry *root)
 		seq_printf(seq, ",gid=%u", from_kgid_munged(&init_user_ns, fs_info->pid_gid));
 	if (fs_info->hide_pid != HIDEPID_OFF)
 		seq_printf(seq, ",hidepid=%u", fs_info->hide_pid);
+	if (fs_info->pidonly != PROC_PIDONLY_OFF)
+		seq_printf(seq, ",subset=pid");
 
 	return 0;
 }
@@ -393,12 +395,16 @@ proc_reg_get_unmapped_area(struct file *file, unsigned long orig_addr,
 
 static int proc_reg_open(struct inode *inode, struct file *file)
 {
+	struct proc_fs_info *fs_info = proc_sb_info(inode->i_sb);
 	struct proc_dir_entry *pde = PDE(inode);
 	int rv = 0;
 	typeof_member(struct proc_ops, proc_open) open;
 	typeof_member(struct proc_ops, proc_release) release;
 	struct pde_opener *pdeo;
 
+	if (fs_info->pidonly == PROC_PIDONLY_ON)
+		return -ENOENT;
+
 	/*
 	 * Ensure that
 	 * 1) PDE's ->release hook will be called no matter what
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 62eae22403d2..dbcd96f07c7a 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -34,16 +34,19 @@ struct proc_fs_context {
 	unsigned int		mask;
 	int			hidepid;
 	int			gid;
+	int			pidonly;
 };
 
 enum proc_param {
 	Opt_gid,
 	Opt_hidepid,
+	Opt_subset,
 };
 
 static const struct fs_parameter_spec proc_fs_parameters[] = {
 	fsparam_u32("gid",	Opt_gid),
 	fsparam_u32("hidepid",	Opt_hidepid),
+	fsparam_string("subset",	Opt_subset),
 	{}
 };
 
@@ -55,6 +58,29 @@ static inline int valid_hidepid(unsigned int value)
 		value == HIDEPID_NOT_PTRACEABLE);
 }
 
+static int proc_parse_subset_param(struct fs_context *fc, char *value)
+{
+	struct proc_fs_context *ctx = fc->fs_private;
+
+	while (value) {
+		char *ptr = strchr(value, ',');
+
+		if (ptr != NULL)
+			*ptr++ = '\0';
+
+		if (*value != '\0') {
+			if (!strcmp(value, "pid")) {
+				ctx->pidonly = PROC_PIDONLY_ON;
+			} else {
+				return invalf(fc, "proc: unsupported subset option - %s\n", value);
+			}
+		}
+		value = ptr;
+	}
+
+	return 0;
+}
+
 static int proc_parse_param(struct fs_context *fc, struct fs_parameter *param)
 {
 	struct proc_fs_context *ctx = fc->fs_private;
@@ -76,6 +102,11 @@ static int proc_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		ctx->hidepid = result.uint_32;
 		break;
 
+	case Opt_subset:
+		if (proc_parse_subset_param(fc, param->string) < 0)
+			return -EINVAL;
+		break;
+
 	default:
 		return -EINVAL;
 	}
@@ -95,6 +126,8 @@ static void proc_apply_options(struct super_block *s,
 		ctx->fs_info->pid_gid = make_kgid(user_ns, ctx->gid);
 	if (ctx->mask & (1 << Opt_hidepid))
 		ctx->fs_info->hide_pid = ctx->hidepid;
+	if (ctx->mask & (1 << Opt_subset))
+		ctx->fs_info->pidonly = ctx->pidonly;
 }
 
 static int proc_fill_super(struct super_block *s, struct fs_context *fc)
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 21d19353fdc7..afd38cae2339 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -35,12 +35,19 @@ enum {
 	HIDEPID_NOT_PTRACEABLE = 4, /* Limit pids to only ptraceable pids */
 };
 
+/* definitions for proc mount option pidonly */
+enum {
+	PROC_PIDONLY_OFF = 0,
+	PROC_PIDONLY_ON  = 1,
+};
+
 struct proc_fs_info {
 	struct pid_namespace *pid_ns;
 	struct dentry *proc_self;        /* For /proc/self */
 	struct dentry *proc_thread_self; /* For /proc/thread-self */
 	kgid_t pid_gid;
 	int hide_pid;
+	int pidonly;
 };
 
 static inline struct proc_fs_info *proc_sb_info(struct super_block *sb)
-- 
2.25.2

