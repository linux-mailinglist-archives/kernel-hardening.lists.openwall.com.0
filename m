Return-Path: <kernel-hardening-return-17679-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id EC353153B27
	for <lists+kernel-hardening@lfdr.de>; Wed,  5 Feb 2020 23:41:28 +0100 (CET)
Received: (qmail 10132 invoked by uid 550); 5 Feb 2020 22:39:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 10060 invoked from network); 5 Feb 2020 22:39:58 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,407,1574150400"; 
   d="scan'208";a="225092462"
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	arjan@linux.intel.com,
	keescook@chromium.org
Cc: rick.p.edgecombe@intel.com,
	x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: [RFC PATCH 09/11] kallsyms: hide layout and expose seed
Date: Wed,  5 Feb 2020 14:39:48 -0800
Message-Id: <20200205223950.1212394-10-kristen@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200205223950.1212394-1-kristen@linux.intel.com>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To support finer grained kaslr (fgkaslr), we need to make a couple changes
to kallsyms. Firstly, we need to hide our sorted list of symbols, since
this will give away our new layout. Secondly, we will export the seed used
for randomizing the layout so that it can be used to make a particular
layout persist across boots for debug purposes.

Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
---
 kernel/kallsyms.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 136ce049c4ad..432b13a3a033 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -698,6 +698,21 @@ const char *kdb_walk_kallsyms(loff_t *pos)
 }
 #endif	/* CONFIG_KGDB_KDB */
 
+#ifdef CONFIG_FG_KASLR
+extern const u64 fgkaslr_seed[] __weak;
+
+static int proc_fgkaslr_show(struct seq_file *m, void *v)
+{
+	seq_printf(m, "%llx\n", fgkaslr_seed[0]);
+	seq_printf(m, "%llx\n", fgkaslr_seed[1]);
+	seq_printf(m, "%llx\n", fgkaslr_seed[2]);
+	seq_printf(m, "%llx\n", fgkaslr_seed[3]);
+	return 0;
+}
+#else
+static inline int proc_fgkaslr_show(struct seq_file *m, void *v) { return 0; }
+#endif
+
 static const struct file_operations kallsyms_operations = {
 	.open = kallsyms_open,
 	.read = seq_read,
@@ -707,7 +722,20 @@ static const struct file_operations kallsyms_operations = {
 
 static int __init kallsyms_init(void)
 {
-	proc_create("kallsyms", 0444, NULL, &kallsyms_operations);
+	/*
+	 * When fine grained kaslr is enabled, we don't want to
+	 * print out the symbols even with zero pointers because
+	 * this reveals the randomization order. If fg kaslr is
+	 * enabled, make kallsyms available only to privileged
+	 * users.
+	 */
+	if (!IS_ENABLED(CONFIG_FG_KASLR))
+		proc_create("kallsyms", 0444, NULL, &kallsyms_operations);
+	else {
+		proc_create_single("fgkaslr_seed", 0400, NULL,
+					proc_fgkaslr_show);
+		proc_create("kallsyms", 0400, NULL, &kallsyms_operations);
+	}
 	return 0;
 }
 device_initcall(kallsyms_init);
-- 
2.24.1

