Return-Path: <kernel-hardening-return-20124-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BC31B28774D
	for <lists+kernel-hardening@lfdr.de>; Thu,  8 Oct 2020 17:32:49 +0200 (CEST)
Received: (qmail 30149 invoked by uid 550); 8 Oct 2020 15:31:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30027 invoked from network); 8 Oct 2020 15:31:30 -0000
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: linux-kernel@vger.kernel.org,
	James Morris <jmorris@namei.org>,
	"Serge E . Hallyn" <serge@hallyn.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Richard Weinberger <richard@nod.at>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Andy Lutomirski <luto@amacapital.net>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Jann Horn <jannh@google.com>,
	Jeff Dike <jdike@addtoit.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kees Cook <keescook@chromium.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com,
	linux-api@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	x86@kernel.org,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>
Subject: [PATCH v21 06/12] fs,security: Add sb_delete hook
Date: Thu,  8 Oct 2020 17:30:57 +0200
Message-Id: <20201008153103.1155388-7-mic@digikod.net>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201008153103.1155388-1-mic@digikod.net>
References: <20201008153103.1155388-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mickaël Salaün <mic@linux.microsoft.com>

The sb_delete security hook is called when shutting down a superblock,
which may be useful to release kernel objects tied to the superblock's
lifetime (e.g. inodes).

This new hook is needed by Landlock to release (ephemerally) tagged
struct inodes.  This comes from the unprivileged nature of Landlock
described in the next commit.

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: James Morris <jmorris@namei.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
---

Changes since v17:
* Initial patch to replace the direct call to landlock_release_inodes()
  (requested by James Morris).
  https://lore.kernel.org/lkml/alpine.LRH.2.21.2005150536440.7929@namei.org/
---
 fs/super.c                    | 1 +
 include/linux/lsm_hook_defs.h | 1 +
 include/linux/lsm_hooks.h     | 2 ++
 include/linux/security.h      | 4 ++++
 security/security.c           | 5 +++++
 5 files changed, 13 insertions(+)

diff --git a/fs/super.c b/fs/super.c
index 904459b35119..d5517e49ccdf 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -454,6 +454,7 @@ void generic_shutdown_super(struct super_block *sb)
 		evict_inodes(sb);
 		/* only nonzero refcount inodes can have marks */
 		fsnotify_sb_delete(sb);
+		security_sb_delete(sb);
 
 		if (sb->s_dio_done_wq) {
 			destroy_workqueue(sb->s_dio_done_wq);
diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
index 2a8c74d99015..a512d4796409 100644
--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -59,6 +59,7 @@ LSM_HOOK(int, 0, fs_context_dup, struct fs_context *fc,
 LSM_HOOK(int, -ENOPARAM, fs_context_parse_param, struct fs_context *fc,
 	 struct fs_parameter *param)
 LSM_HOOK(int, 0, sb_alloc_security, struct super_block *sb)
+LSM_HOOK(void, LSM_RET_VOID, sb_delete, struct super_block *sb)
 LSM_HOOK(void, LSM_RET_VOID, sb_free_security, struct super_block *sb)
 LSM_HOOK(void, LSM_RET_VOID, sb_free_mnt_opts, void *mnt_opts)
 LSM_HOOK(int, 0, sb_eat_lsm_opts, char *orig, void **mnt_opts)
diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
index 29df5075b35d..81f21861651e 100644
--- a/include/linux/lsm_hooks.h
+++ b/include/linux/lsm_hooks.h
@@ -108,6 +108,8 @@
  *	allocated.
  *	@sb contains the super_block structure to be modified.
  *	Return 0 if operation was successful.
+ * @sb_delete:
+ *	Release objects tied to a superblock (e.g. inodes).
  * @sb_free_security:
  *	Deallocate and clear the sb->s_security field.
  *	@sb contains the super_block structure to be modified.
diff --git a/include/linux/security.h b/include/linux/security.h
index 0a0a03b36a3b..28b0ee6c7239 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -286,6 +286,7 @@ void security_bprm_committed_creds(struct linux_binprm *bprm);
 int security_fs_context_dup(struct fs_context *fc, struct fs_context *src_fc);
 int security_fs_context_parse_param(struct fs_context *fc, struct fs_parameter *param);
 int security_sb_alloc(struct super_block *sb);
+void security_sb_delete(struct super_block *sb);
 void security_sb_free(struct super_block *sb);
 void security_free_mnt_opts(void **mnt_opts);
 int security_sb_eat_lsm_opts(char *options, void **mnt_opts);
@@ -614,6 +615,9 @@ static inline int security_sb_alloc(struct super_block *sb)
 	return 0;
 }
 
+static inline void security_sb_delete(struct super_block *sb)
+{ }
+
 static inline void security_sb_free(struct super_block *sb)
 { }
 
diff --git a/security/security.c b/security/security.c
index d60aa835b670..9337b511306c 100644
--- a/security/security.c
+++ b/security/security.c
@@ -898,6 +898,11 @@ int security_sb_alloc(struct super_block *sb)
 	return rc;
 }
 
+void security_sb_delete(struct super_block *sb)
+{
+	call_void_hook(sb_delete, sb);
+}
+
 void security_sb_free(struct super_block *sb)
 {
 	call_void_hook(sb_free_security, sb);
-- 
2.28.0

