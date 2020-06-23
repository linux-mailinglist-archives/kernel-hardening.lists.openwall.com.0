Return-Path: <kernel-hardening-return-19076-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2309E20588E
	for <lists+kernel-hardening@lfdr.de>; Tue, 23 Jun 2020 19:25:51 +0200 (CEST)
Received: (qmail 5997 invoked by uid 550); 23 Jun 2020 17:24:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5918 invoked from network); 23 Jun 2020 17:24:43 -0000
IronPort-SDR: Hw4UqSwsO5GOu2kXLBmGWJ+7MLrzZBuvYAp0+oFyzAj1S7tcgOZ9msmIfCI2IukTzgO3NzbzGa
 m2dmVJqjb0Zg==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="141645599"
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="141645599"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: PaPYECkHgeUaHkq7lCdP3ZCwMEDmqppl050a2yO2NE/0anFX160pq3w5j+HZVq7ZsApUZPE8Oq
 /vsOK4Gq1YYw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="423080114"
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: keescook@chromium.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>
Cc: arjan@linux.intel.com,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	rick.p.edgecombe@intel.com,
	Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: [PATCH v3 07/10] x86/boot/compressed: change definition of STATIC
Date: Tue, 23 Jun 2020 10:23:24 -0700
Message-Id: <20200623172327.5701-8-kristen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200623172327.5701-1-kristen@linux.intel.com>
References: <20200623172327.5701-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for changes to the upcoming fgkaslr commit, change misc.c
to not define STATIC as static, but instead set STATIC to "". This allows
memptr to become accessible to multiple files.

Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
---
 arch/x86/boot/compressed/kaslr.c | 4 ----
 arch/x86/boot/compressed/misc.c  | 7 ++++---
 arch/x86/boot/compressed/misc.h  | 6 ++++++
 3 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/boot/compressed/kaslr.c b/arch/x86/boot/compressed/kaslr.c
index d7408af55738..6f596bd5b6e5 100644
--- a/arch/x86/boot/compressed/kaslr.c
+++ b/arch/x86/boot/compressed/kaslr.c
@@ -39,10 +39,6 @@
 #include <generated/utsrelease.h>
 #include <asm/efi.h>
 
-/* Macros used by the included decompressor code below. */
-#define STATIC
-#include <linux/decompress/mm.h>
-
 #ifdef CONFIG_X86_5LEVEL
 unsigned int __pgtable_l5_enabled;
 unsigned int pgdir_shift __ro_after_init = 39;
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index 9652d5c2afda..a55a4ec48422 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -26,9 +26,6 @@
  * it is not safe to place pointers in static structures.
  */
 
-/* Macros used by the included decompressor code below. */
-#define STATIC		static
-
 /*
  * Use normal definitions of mem*() from string.c. There are already
  * included header files which expect a definition of memset() and by
@@ -49,6 +46,10 @@ struct boot_params *boot_params;
 
 memptr free_mem_ptr;
 memptr free_mem_end_ptr;
+#ifdef CONFIG_FG_KASLR
+unsigned long malloc_ptr;
+int malloc_count;
+#endif
 
 static char *vidmem;
 static int vidport;
diff --git a/arch/x86/boot/compressed/misc.h b/arch/x86/boot/compressed/misc.h
index 726e264410ff..d2ec7c745cfa 100644
--- a/arch/x86/boot/compressed/misc.h
+++ b/arch/x86/boot/compressed/misc.h
@@ -39,6 +39,12 @@
 /* misc.c */
 extern memptr free_mem_ptr;
 extern memptr free_mem_end_ptr;
+#define STATIC
+#ifdef CONFIG_FG_KASLR
+#define STATIC_RW_DATA extern
+#endif
+#include <linux/decompress/mm.h>
+
 extern struct boot_params *boot_params;
 void __putstr(const char *s);
 void __puthex(unsigned long value);
-- 
2.20.1

