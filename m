Return-Path: <kernel-hardening-return-19073-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F02D5205889
	for <lists+kernel-hardening@lfdr.de>; Tue, 23 Jun 2020 19:25:18 +0200 (CEST)
Received: (qmail 5804 invoked by uid 550); 23 Jun 2020 17:24:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5740 invoked from network); 23 Jun 2020 17:24:39 -0000
IronPort-SDR: XEhDXk1+Aflf3V/asuHWKPyt/E4uHctczl06HhK7PM/ByFGZE+5WRe3g5RKPMgnlkDszNWre9l
 DyZqauWnDKBg==
X-IronPort-AV: E=McAfee;i="6000,8403,9661"; a="141645582"
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="141645582"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: YI4pepBviYHOQzIhkqBYgYexGcacrD0mbKmC47qio85NV9rUDgee3rgg9SRCNUhXsw0UCZUY3t
 q/7b9SHv46cA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,272,1589266800"; 
   d="scan'208";a="423080063"
From: Kristen Carlson Accardi <kristen@linux.intel.com>
To: keescook@chromium.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Arnd Bergmann <arnd@arndb.de>
Cc: arjan@linux.intel.com,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	rick.p.edgecombe@intel.com,
	Kristen Carlson Accardi <kristen@linux.intel.com>,
	Tony Luck <tony.luck@intel.com>,
	linux-kbuild@vger.kernel.org,
	linux-arch@vger.kernel.org
Subject: [PATCH v3 04/10] x86: Makefile: Add build and config option for CONFIG_FG_KASLR
Date: Tue, 23 Jun 2020 10:23:21 -0700
Message-Id: <20200623172327.5701-5-kristen@linux.intel.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200623172327.5701-1-kristen@linux.intel.com>
References: <20200623172327.5701-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow user to select CONFIG_FG_KASLR if dependencies are met. Change
the make file to build with -ffunction-sections if CONFIG_FG_KASLR.

While the only architecture that supports CONFIG_FG_KASLR does not
currently enable HAVE_LD_DEAD_CODE_DATA_ELIMINATION, make sure these
2 features play nicely together for the future by ensuring that if
CONFIG_LD_DEAD_CODE_DATA_ELIMINATION is selected when used with
CONFIG_FG_KASLR the function sections will not be consolidated back
into .text. Thanks to Kees Cook for the dead code elimination changes.

Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Tony Luck <tony.luck@intel.com>
---
 Makefile                          |  6 +++++-
 arch/x86/Kconfig                  |  4 ++++
 include/asm-generic/vmlinux.lds.h | 16 ++++++++++++++--
 init/Kconfig                      | 14 ++++++++++++++
 4 files changed, 37 insertions(+), 3 deletions(-)

diff --git a/Makefile b/Makefile
index ac2c61c37a73..363f53798fca 100644
--- a/Makefile
+++ b/Makefile
@@ -872,7 +872,7 @@ KBUILD_CFLAGS += $(call cc-option, -fno-inline-functions-called-once)
 endif
 
 ifdef CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
-KBUILD_CFLAGS_KERNEL += -ffunction-sections -fdata-sections
+KBUILD_CFLAGS_KERNEL += -fdata-sections
 LDFLAGS_vmlinux += --gc-sections
 endif
 
@@ -880,6 +880,10 @@ ifdef CONFIG_LIVEPATCH
 KBUILD_CFLAGS += $(call cc-option, -flive-patching=inline-clone)
 endif
 
+ifneq ($(CONFIG_LD_DEAD_CODE_DATA_ELIMINATION)$(CONFIG_FG_KASLR),)
+KBUILD_CFLAGS += -ffunction-sections
+endif
+
 ifdef CONFIG_SHADOW_CALL_STACK
 CC_FLAGS_SCS	:= -fsanitize=shadow-call-stack
 KBUILD_CFLAGS	+= $(CC_FLAGS_SCS)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6a0cc524882d..932cbc327af0 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -372,6 +372,10 @@ config CC_HAS_SANE_STACKPROTECTOR
 	   We have to make sure stack protector is unconditionally disabled if
 	   the compiler produces broken code.
 
+config ARCH_HAS_FG_KASLR
+	def_bool y
+	depends on RANDOMIZE_BASE && X86_64
+
 menu "Processor type and features"
 
 config ZONE_DMA
diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index db600ef218d7..a5552cf28d5d 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -93,14 +93,12 @@
  * sections to be brought in with rodata.
  */
 #ifdef CONFIG_LD_DEAD_CODE_DATA_ELIMINATION
-#define TEXT_MAIN .text .text.[0-9a-zA-Z_]*
 #define DATA_MAIN .data .data.[0-9a-zA-Z_]* .data..LPBX*
 #define SDATA_MAIN .sdata .sdata.[0-9a-zA-Z_]*
 #define RODATA_MAIN .rodata .rodata.[0-9a-zA-Z_]*
 #define BSS_MAIN .bss .bss.[0-9a-zA-Z_]*
 #define SBSS_MAIN .sbss .sbss.[0-9a-zA-Z_]*
 #else
-#define TEXT_MAIN .text
 #define DATA_MAIN .data
 #define SDATA_MAIN .sdata
 #define RODATA_MAIN .rodata
@@ -108,6 +106,20 @@
 #define SBSS_MAIN .sbss
 #endif
 
+/*
+ * Both LD_DEAD_CODE_DATA_ELIMINATION and CONFIG_FG_KASLR options enable
+ * -ffunction-sections, which produces separately named .text sections. In
+ * the case of CONFIG_FG_KASLR, they need to stay distict so they can be
+ * separately randomized. Without CONFIG_FG_KASLR, the separate .text
+ * sections can be collected back into a common section, which makes the
+ * resulting image slightly smaller
+ */
+#if defined(CONFIG_LD_DEAD_CODE_DATA_ELIMINATION) && !defined(CONFIG_FG_KASLR)
+#define TEXT_MAIN .text .text.[0-9a-zA-Z_]*
+#else
+#define TEXT_MAIN .text
+#endif
+
 /*
  * Align to a 32 byte boundary equal to the
  * alignment gcc 4.5 uses for a struct
diff --git a/init/Kconfig b/init/Kconfig
index a46aa8f3174d..e29c032e4d66 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1990,6 +1990,20 @@ config PROFILING
 config TRACEPOINTS
 	bool
 
+config FG_KASLR
+	bool "Function Granular Kernel Address Space Layout Randomization"
+	depends on $(cc-option, -ffunction-sections)
+	depends on ARCH_HAS_FG_KASLR
+	default n
+	help
+	  This option improves the randomness of the kernel text
+	  over basic Kernel Address Space Layout Randomization (KASLR)
+	  by reordering the kernel text at boot time. This feature
+	  uses information generated at compile time to re-layout the
+	  kernel text section at boot time at function level granularity.
+
+	  If unsure, say N.
+
 endmenu		# General setup
 
 source "arch/Kconfig"
-- 
2.20.1

