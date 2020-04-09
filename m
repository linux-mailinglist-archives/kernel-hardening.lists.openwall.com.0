Return-Path: <kernel-hardening-return-18471-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id CE6A91A3439
	for <lists+kernel-hardening@lfdr.de>; Thu,  9 Apr 2020 14:39:49 +0200 (CEST)
Received: (qmail 30319 invoked by uid 550); 9 Apr 2020 12:38:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30210 invoked from network); 9 Apr 2020 12:38:55 -0000
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
Subject: [PATCH RESEND v11 4/8] proc: instantiate only pids that we can ptrace on 'hidepid=4' mount option
Date: Thu,  9 Apr 2020 14:37:48 +0200
Message-Id: <20200409123752.1070597-5-gladkov.alexey@gmail.com>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200409123752.1070597-1-gladkov.alexey@gmail.com>
References: <20200409123752.1070597-1-gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Thu, 09 Apr 2020 12:38:44 +0000 (UTC)

If "hidepid=4" mount option is set then do not instantiate pids that
we can not ptrace. "hidepid=4" means that procfs should only contain
pids that the caller can ptrace.

Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 fs/proc/base.c          | 15 +++++++++++++++
 fs/proc/root.c          | 13 ++++++++++---
 include/linux/proc_fs.h |  1 +
 3 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 43a28907baf9..1ebe9eba48ea 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -701,6 +701,14 @@ static bool has_pid_permissions(struct proc_fs_info *fs_info,
 				 struct task_struct *task,
 				 int hide_pid_min)
 {
+	/*
+	 * If 'hidpid' mount option is set force a ptrace check,
+	 * we indicate that we are using a filesystem syscall
+	 * by passing PTRACE_MODE_READ_FSCREDS
+	 */
+	if (fs_info->hide_pid == HIDEPID_NOT_PTRACEABLE)
+		return ptrace_may_access(task, PTRACE_MODE_READ_FSCREDS);
+
 	if (fs_info->hide_pid < hide_pid_min)
 		return true;
 	if (in_group_p(fs_info->pid_gid))
@@ -3319,7 +3327,14 @@ struct dentry *proc_pid_lookup(struct dentry *dentry, unsigned int flags)
 	if (!task)
 		goto out;
 
+	/* Limit procfs to only ptraceable tasks */
+	if (fs_info->hide_pid == HIDEPID_NOT_PTRACEABLE) {
+		if (!has_pid_permissions(fs_info, task, HIDEPID_NO_ACCESS))
+			goto out_put_task;
+	}
+
 	result = proc_pid_instantiate(dentry, task, NULL);
+out_put_task:
 	put_task_struct(task);
 out:
 	return result;
diff --git a/fs/proc/root.c b/fs/proc/root.c
index 616e8976185c..62eae22403d2 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -47,6 +47,14 @@ static const struct fs_parameter_spec proc_fs_parameters[] = {
 	{}
 };
 
+static inline int valid_hidepid(unsigned int value)
+{
+	return (value == HIDEPID_OFF ||
+		value == HIDEPID_NO_ACCESS ||
+		value == HIDEPID_INVISIBLE ||
+		value == HIDEPID_NOT_PTRACEABLE);
+}
+
 static int proc_parse_param(struct fs_context *fc, struct fs_parameter *param)
 {
 	struct proc_fs_context *ctx = fc->fs_private;
@@ -63,10 +71,9 @@ static int proc_parse_param(struct fs_context *fc, struct fs_parameter *param)
 		break;
 
 	case Opt_hidepid:
+		if (!valid_hidepid(result.uint_32))
+			return invalf(fc, "proc: unknown value of hidepid.\n");
 		ctx->hidepid = result.uint_32;
-		if (ctx->hidepid < HIDEPID_OFF ||
-		    ctx->hidepid > HIDEPID_INVISIBLE)
-			return invalfc(fc, "hidepid value must be between 0 and 2.\n");
 		break;
 
 	default:
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 7d852dbca253..21d19353fdc7 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -32,6 +32,7 @@ enum {
 	HIDEPID_OFF	  = 0,
 	HIDEPID_NO_ACCESS = 1,
 	HIDEPID_INVISIBLE = 2,
+	HIDEPID_NOT_PTRACEABLE = 4, /* Limit pids to only ptraceable pids */
 };
 
 struct proc_fs_info {
-- 
2.25.2

