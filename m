Return-Path: <kernel-hardening-return-21523-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 04BFB48451F
	for <lists+kernel-hardening@lfdr.de>; Tue,  4 Jan 2022 16:45:46 +0100 (CET)
Received: (qmail 3133 invoked by uid 550); 4 Jan 2022 15:45:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3089 invoked from network); 4 Jan 2022 15:45:24 -0000
From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
To: Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Alejandro Colomar <alx.manpages@gmail.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Andy Lutomirski <luto@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Christian Heimes <christian@python.org>,
	Deven Bowers <deven.desai@linux.microsoft.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Chiang <ericchiang@google.com>,
	Florian Weimer <fweimer@redhat.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	James Morris <jmorris@namei.org>,
	Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Kees Cook <keescook@chromium.org>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Paul Moore <paul@paul-moore.com>,
	=?UTF-8?q?Philippe=20Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Shuah Khan <shuah@kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	Xiaoming Ni <nixiaoming@huawei.com>,
	Yin Fengwei <fengwei.yin@intel.com>,
	kernel-hardening@lists.openwall.com,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@linux.microsoft.com>
Subject: [PATCH v18 1/4] printk: Move back proc_dointvec_minmax_sysadmin() to sysctl.c
Date: Tue,  4 Jan 2022 16:50:21 +0100
Message-Id: <20220104155024.48023-2-mic@digikod.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220104155024.48023-1-mic@digikod.net>
References: <20220104155024.48023-1-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mickaël Salaün <mic@linux.microsoft.com>

The proc_dointvec_minmax_sysadmin() helper is useful for the
fs.trusted_for_policy sysctl brought by the next commit.

This partially revert commit 642fd23fb826 ("printk: move printk sysctl
to printk/sysctl.c") from Luis Chamberlain's 20211129-sysctl-cleanups
branch [1], to share the proc_dointvec_minmax_sysadmin() helper.  FYI,
this previous commit also got the buffer pointer an __user attribute.

Also remove the forgotten ten_thousand static variable (moved to
kernel/printk/sysctl.c).

Link: https://lkml.kernel.org/r/20211124231435.1445213-6-mcgrof@kernel.org [1]
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
Link: https://lore.kernel.org/r/20220104155024.48023-2-mic@digikod.net
---
 include/linux/sysctl.h | 2 ++
 kernel/printk/sysctl.c | 9 ---------
 kernel/sysctl.c        | 9 +++++++++
 3 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/include/linux/sysctl.h b/include/linux/sysctl.h
index 180adf7da785..cf1ba98aab50 100644
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -69,6 +69,8 @@ int proc_dobool(struct ctl_table *table, int write, void *buffer,
 int proc_dointvec(struct ctl_table *, int, void *, size_t *, loff_t *);
 int proc_douintvec(struct ctl_table *, int, void *, size_t *, loff_t *);
 int proc_dointvec_minmax(struct ctl_table *, int, void *, size_t *, loff_t *);
+int proc_dointvec_minmax_sysadmin(struct ctl_table *, int, void *, size_t *,
+		loff_t *);
 int proc_douintvec_minmax(struct ctl_table *table, int write, void *buffer,
 		size_t *lenp, loff_t *ppos);
 int proc_dou8vec_minmax(struct ctl_table *table, int write, void *buffer,
diff --git a/kernel/printk/sysctl.c b/kernel/printk/sysctl.c
index 653ae04aab7f..c7129428ee9b 100644
--- a/kernel/printk/sysctl.c
+++ b/kernel/printk/sysctl.c
@@ -11,15 +11,6 @@
 
 static const int ten_thousand = 10000;
 
-static int proc_dointvec_minmax_sysadmin(struct ctl_table *table, int write,
-				void __user *buffer, size_t *lenp, loff_t *ppos)
-{
-	if (write && !capable(CAP_SYS_ADMIN))
-		return -EPERM;
-
-	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
-}
-
 static struct ctl_table printk_sysctls[] = {
 	{
 		.procname	= "printk",
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 5ae443b2882e..2e2027e323fd 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -888,6 +888,15 @@ static int proc_taint(struct ctl_table *table, int write,
 	return err;
 }
 
+int proc_dointvec_minmax_sysadmin(struct ctl_table *table, int write,
+				void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	if (write && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	return proc_dointvec_minmax(table, write, buffer, lenp, ppos);
+}
+
 /**
  * struct do_proc_dointvec_minmax_conv_param - proc_dointvec_minmax() range checking structure
  * @min: pointer to minimum allowable value
-- 
2.34.1

