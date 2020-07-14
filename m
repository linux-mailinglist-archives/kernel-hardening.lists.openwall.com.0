Return-Path: <kernel-hardening-return-19317-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8675421F91D
	for <lists+kernel-hardening@lfdr.de>; Tue, 14 Jul 2020 20:18:22 +0200 (CEST)
Received: (qmail 3790 invoked by uid 550); 14 Jul 2020 18:17:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3721 invoked from network); 14 Jul 2020 18:17:09 -0000
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Christian Heimes <christian@python.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	James Morris <jmorris@namei.org>,
	Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kees Cook <keescook@chromium.org>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
	Mimi Zohar <zohar@linux.ibm.com>,
	=?UTF-8?q?Philippe=20Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Shuah Khan <shuah@kernel.org>,
	Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com,
	linux-api@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v6 7/7] ima: add policy support for the new file open MAY_OPENEXEC flag
Date: Tue, 14 Jul 2020 20:16:38 +0200
Message-Id: <20200714181638.45751-8-mic@digikod.net>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200714181638.45751-1-mic@digikod.net>
References: <20200714181638.45751-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000

From: Mimi Zohar <zohar@linux.ibm.com>

The kernel has no way of differentiating between a file containing data
or code being opened by an interpreter.  The proposed O_MAYEXEC
openat2(2) flag bridges this gap by defining and enabling the
MAY_OPENEXEC flag.

This patch adds IMA policy support for the new MAY_OPENEXEC flag.

Example:
measure func=FILE_CHECK mask=^MAY_OPENEXEC
appraise func=FILE_CHECK appraise_type=imasig mask=^MAY_OPENEXEC

Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Reviewed-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
Acked-by: Mickaël Salaün <mic@digikod.net>
Link: https://lore.kernel.org/r/1588167523-7866-3-git-send-email-zohar@linux.ibm.com
---
 Documentation/ABI/testing/ima_policy |  2 +-
 security/integrity/ima/ima_main.c    |  3 ++-
 security/integrity/ima/ima_policy.c  | 15 +++++++++++----
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/Documentation/ABI/testing/ima_policy b/Documentation/ABI/testing/ima_policy
index cd572912c593..caca46125fe0 100644
--- a/Documentation/ABI/testing/ima_policy
+++ b/Documentation/ABI/testing/ima_policy
@@ -31,7 +31,7 @@ Description:
 				[KEXEC_KERNEL_CHECK] [KEXEC_INITRAMFS_CHECK]
 				[KEXEC_CMDLINE] [KEY_CHECK]
 			mask:= [[^]MAY_READ] [[^]MAY_WRITE] [[^]MAY_APPEND]
-			       [[^]MAY_EXEC]
+			       [[^]MAY_EXEC] [[^]MAY_OPENEXEC]
 			fsmagic:= hex value
 			fsuuid:= file system UUID (e.g 8bcbe394-4f13-4144-be8e-5aa9ea2ce2f6)
 			uid:= decimal value
diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
index c1583d98c5e5..59fd1658a203 100644
--- a/security/integrity/ima/ima_main.c
+++ b/security/integrity/ima/ima_main.c
@@ -490,7 +490,8 @@ int ima_file_check(struct file *file, int mask)
 
 	security_task_getsecid(current, &secid);
 	return process_measurement(file, current_cred(), secid, NULL, 0,
-				   mask & (MAY_READ | MAY_WRITE | MAY_EXEC |
+				   mask & (MAY_READ | MAY_WRITE |
+					   MAY_EXEC | MAY_OPENEXEC |
 					   MAY_APPEND), FILE_CHECK);
 }
 EXPORT_SYMBOL_GPL(ima_file_check);
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index e493063a3c34..6487f0b2afdd 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -406,7 +406,8 @@ static bool ima_match_keyring(struct ima_rule_entry *rule,
  * @cred: a pointer to a credentials structure for user validation
  * @secid: the secid of the task to be validated
  * @func: LIM hook identifier
- * @mask: requested action (MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)
+ * @mask: requested action (MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC |
+ *			    MAY_OPENEXEC)
  * @keyring: keyring name to check in policy for KEY_CHECK func
  *
  * Returns true on rule match, false on failure.
@@ -527,7 +528,8 @@ static int get_subaction(struct ima_rule_entry *rule, enum ima_hooks func)
  *        being made
  * @secid: LSM secid of the task to be validated
  * @func: IMA hook identifier
- * @mask: requested action (MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC)
+ * @mask: requested action (MAY_READ | MAY_WRITE | MAY_APPEND | MAY_EXEC |
+ *			    MAY_OPENEXEC)
  * @pcr: set the pcr to extend
  * @template_desc: the template that should be used for this rule
  * @keyring: the keyring name, if given, to be used to check in the policy.
@@ -1091,6 +1093,8 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 				entry->mask = MAY_READ;
 			else if (strcmp(from, "MAY_APPEND") == 0)
 				entry->mask = MAY_APPEND;
+			else if (strcmp(from, "MAY_OPENEXEC") == 0)
+				entry->mask = MAY_OPENEXEC;
 			else
 				result = -EINVAL;
 			if (!result)
@@ -1422,14 +1426,15 @@ const char *const func_tokens[] = {
 
 #ifdef	CONFIG_IMA_READ_POLICY
 enum {
-	mask_exec = 0, mask_write, mask_read, mask_append
+	mask_exec = 0, mask_write, mask_read, mask_append, mask_openexec
 };
 
 static const char *const mask_tokens[] = {
 	"^MAY_EXEC",
 	"^MAY_WRITE",
 	"^MAY_READ",
-	"^MAY_APPEND"
+	"^MAY_APPEND",
+	"^MAY_OPENEXEC"
 };
 
 void *ima_policy_start(struct seq_file *m, loff_t *pos)
@@ -1518,6 +1523,8 @@ int ima_policy_show(struct seq_file *m, void *v)
 			seq_printf(m, pt(Opt_mask), mt(mask_read) + offset);
 		if (entry->mask & MAY_APPEND)
 			seq_printf(m, pt(Opt_mask), mt(mask_append) + offset);
+		if (entry->mask & MAY_OPENEXEC)
+			seq_printf(m, pt(Opt_mask), mt(mask_openexec) + offset);
 		seq_puts(m, " ");
 	}
 
-- 
2.27.0

