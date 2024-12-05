Return-Path: <kernel-hardening-return-21890-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 2D2EE9E5AF6
	for <lists+kernel-hardening@lfdr.de>; Thu,  5 Dec 2024 17:11:35 +0100 (CET)
Received: (qmail 11672 invoked by uid 550); 5 Dec 2024 16:10:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11631 invoked from network); 5 Dec 2024 16:10:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1733415000;
	bh=q3iLh0+RYBxCd48+szjuBjIcYn8usj2ORomMH4nDYxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gyVf2SmTbpZ4F0Fo3Tv2kKWTdUwLRWFx5sCpC+OgU8Ga0uwaNiL9rynsq0G+j9MXz
	 TcXCsp3n54VduA412Q6Tx8DlZGxUR9YJNk/s3MhGtZxosGn/JO1+ZTHdjMpLG3mX42
	 dUijeWWbx5fdtSyaWs0iinWMQ/8LulBIaFnzd9i4=
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Paul Moore <paul@paul-moore.com>,
	Serge Hallyn <serge@hallyn.com>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>,
	Alejandro Colomar <alx@kernel.org>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Christian Heimes <christian@python.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Elliott Hughes <enh@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Chiang <ericchiang@google.com>,
	Fan Wu <wufan@linux.microsoft.com>,
	Florian Weimer <fweimer@redhat.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	James Morris <jamorris@linux.microsoft.com>,
	Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Jordan R Abrahams <ajordanr@google.com>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Luca Boccassi <bluca@debian.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Matthew Wilcox <willy@infradead.org>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Roberto Sassu <roberto.sassu@huawei.com>,
	Scott Shell <scottsh@microsoft.com>,
	Shuah Khan <shuah@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	Xiaoming Ni <nixiaoming@huawei.com>,
	Yin Fengwei <fengwei.yin@intel.com>,
	kernel-hardening@lists.openwall.com,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: [PATCH v22 8/8] ima: instantiate the bprm_creds_for_exec() hook
Date: Thu,  5 Dec 2024 17:09:25 +0100
Message-ID: <20241205160925.230119-9-mic@digikod.net>
In-Reply-To: <20241205160925.230119-1-mic@digikod.net>
References: <20241205160925.230119-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Infomaniak-Routing: alpha

From: Mimi Zohar <zohar@linux.ibm.com>

Like direct file execution (e.g. ./script.sh), indirect file execution
(e.g. sh script.sh) needs to be measured and appraised.  Instantiate
the new security_bprm_creds_for_exec() hook to measure and verify the
indirect file's integrity.  Unlike direct file execution, indirect file
execution is optionally enforced by the interpreter.

Differentiate kernel and userspace enforced integrity audit messages.

Co-developed-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Link: https://lore.kernel.org/r/20241204192514.40308-1-zohar@linux.ibm.com
Reviewed-by: Mickaël Salaün <mic@digikod.net>
Signed-off-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/20241205160925.230119-9-mic@digikod.net
---

I added both a Reviewed-by and a Signed-off-by because I may not be the
committer.

Changes since v21:
* New patch cherry-picked from IMA's patch v3:
  https://lore.kernel.org/r/67b2e94f263bf9a0099efe74cce659d6acb16fe9.camel@linux.ibm.com
* Fix a typo in comment: s/execvat/execveat/ .
---
 include/uapi/linux/audit.h            |  1 +
 security/integrity/ima/ima_appraise.c | 27 +++++++++++++++++++++++--
 security/integrity/ima/ima_main.c     | 29 +++++++++++++++++++++++++++
 3 files changed, 55 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
index 75e21a135483..826337905466 100644
--- a/include/uapi/linux/audit.h
+++ b/include/uapi/linux/audit.h
@@ -161,6 +161,7 @@
 #define AUDIT_INTEGRITY_RULE	    1805 /* policy rule */
 #define AUDIT_INTEGRITY_EVM_XATTR   1806 /* New EVM-covered xattr */
 #define AUDIT_INTEGRITY_POLICY_RULE 1807 /* IMA policy rules */
+#define AUDIT_INTEGRITY_DATA_CHECK  1808 /* Userspace enforced data integrity */
 
 #define AUDIT_KERNEL		2000	/* Asynchronous audit record. NOT A REQUEST. */
 
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 884a3533f7af..998c46c769d8 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -8,6 +8,7 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/file.h>
+#include <linux/binfmts.h>
 #include <linux/fs.h>
 #include <linux/xattr.h>
 #include <linux/magic.h>
@@ -469,6 +470,17 @@ int ima_check_blacklist(struct ima_iint_cache *iint,
 	return rc;
 }
 
+static bool is_bprm_creds_for_exec(enum ima_hooks func, struct file *file)
+{
+	struct linux_binprm *bprm;
+
+	if (func == BPRM_CHECK) {
+		bprm = container_of(&file, struct linux_binprm, file);
+		return bprm->is_check;
+	}
+	return false;
+}
+
 /*
  * ima_appraise_measurement - appraise file measurement
  *
@@ -483,6 +495,7 @@ int ima_appraise_measurement(enum ima_hooks func, struct ima_iint_cache *iint,
 			     int xattr_len, const struct modsig *modsig)
 {
 	static const char op[] = "appraise_data";
+	int audit_msgno = AUDIT_INTEGRITY_DATA;
 	const char *cause = "unknown";
 	struct dentry *dentry = file_dentry(file);
 	struct inode *inode = d_backing_inode(dentry);
@@ -494,6 +507,16 @@ int ima_appraise_measurement(enum ima_hooks func, struct ima_iint_cache *iint,
 	if (!(inode->i_opflags & IOP_XATTR) && !try_modsig)
 		return INTEGRITY_UNKNOWN;
 
+	/*
+	 * Unlike any of the other LSM hooks where the kernel enforces file
+	 * integrity, enforcing file integrity for the bprm_creds_for_exec()
+	 * LSM hook with the AT_EXECVE_CHECK flag is left up to the discretion
+	 * of the script interpreter(userspace). Differentiate kernel and
+	 * userspace enforced integrity audit messages.
+	 */
+	if (is_bprm_creds_for_exec(func, file))
+		audit_msgno = AUDIT_INTEGRITY_DATA_CHECK;
+
 	/* If reading the xattr failed and there's no modsig, error out. */
 	if (rc <= 0 && !try_modsig) {
 		if (rc && rc != -ENODATA)
@@ -569,7 +592,7 @@ int ima_appraise_measurement(enum ima_hooks func, struct ima_iint_cache *iint,
 	     (iint->flags & IMA_FAIL_UNVERIFIABLE_SIGS))) {
 		status = INTEGRITY_FAIL;
 		cause = "unverifiable-signature";
-		integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode, filename,
+		integrity_audit_msg(audit_msgno, inode, filename,
 				    op, cause, rc, 0);
 	} else if (status != INTEGRITY_PASS) {
 		/* Fix mode, but don't replace file signatures. */
@@ -589,7 +612,7 @@ int ima_appraise_measurement(enum ima_hooks func, struct ima_iint_cache *iint,
 			status = INTEGRITY_PASS;
 		}
 
-		integrity_audit_msg(AUDIT_INTEGRITY_DATA, inode, filename,
+		integrity_audit_msg(audit_msgno, inode, filename,
 				    op, cause, rc, 0);
 	} else {
 		ima_cache_flags(iint, func);
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index 9b87556b03a7..9f9897a7c217 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -554,6 +554,34 @@ static int ima_bprm_check(struct linux_binprm *bprm)
 				   MAY_EXEC, CREDS_CHECK);
 }
 
+/**
+ * ima_bprm_creds_for_exec - collect/store/appraise measurement.
+ * @bprm: contains the linux_binprm structure
+ *
+ * Based on the IMA policy and the execveat(2) AT_EXECVE_CHECK flag, measure
+ * and appraise the integrity of a file to be executed by script interpreters.
+ * Unlike any of the other LSM hooks where the kernel enforces file integrity,
+ * enforcing file integrity is left up to the discretion of the script
+ * interpreter (userspace).
+ *
+ * On success return 0.  On integrity appraisal error, assuming the file
+ * is in policy and IMA-appraisal is in enforcing mode, return -EACCES.
+ */
+static int ima_bprm_creds_for_exec(struct linux_binprm *bprm)
+{
+	/*
+	 * As security_bprm_check() is called multiple times, both
+	 * the script and the shebang interpreter are measured, appraised,
+	 * and audited. Limit usage of this LSM hook to just measuring,
+	 * appraising, and auditing the indirect script execution
+	 * (e.g. ./sh example.sh).
+	 */
+	if (!bprm->is_check)
+		return 0;
+
+	return ima_bprm_check(bprm);
+}
+
 /**
  * ima_file_check - based on policy, collect/store measurement.
  * @file: pointer to the file to be measured
@@ -1174,6 +1202,7 @@ static int __init init_ima(void)
 
 static struct security_hook_list ima_hooks[] __ro_after_init = {
 	LSM_HOOK_INIT(bprm_check_security, ima_bprm_check),
+	LSM_HOOK_INIT(bprm_creds_for_exec, ima_bprm_creds_for_exec),
 	LSM_HOOK_INIT(file_post_open, ima_file_check),
 	LSM_HOOK_INIT(inode_post_create_tmpfile, ima_post_create_tmpfile),
 	LSM_HOOK_INIT(file_release, ima_file_free),
-- 
2.47.1

