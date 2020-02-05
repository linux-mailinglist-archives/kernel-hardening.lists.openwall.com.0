Return-Path: <kernel-hardening-return-17675-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 861F5153B1D
	for <lists+kernel-hardening@lfdr.de>; Wed,  5 Feb 2020 23:40:41 +0100 (CET)
Received: (qmail 9930 invoked by uid 550); 5 Feb 2020 22:39:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9832 invoked from network); 5 Feb 2020 22:39:53 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,407,1574150400"; 
   d="scan'208";a="225092448"
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
Subject: [RFC PATCH 05/11] x86: Makefile: Add build and config option for CONFIG_FG_KASLR
Date: Wed,  5 Feb 2020 14:39:44 -0800
Message-Id: <20200205223950.1212394-6-kristen@linux.intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200205223950.1212394-1-kristen@linux.intel.com>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow user to select CONFIG_FG_KASLR if dependencies are met. Change
the make file to build with -ffunction-sections if CONFIG_FG_KASLR

Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
---
 Makefile         |  4 ++++
 arch/x86/Kconfig | 13 +++++++++++++
 2 files changed, 17 insertions(+)

diff --git a/Makefile b/Makefile
index c50ef91f6136..41438a921666 100644
--- a/Makefile
+++ b/Makefile
@@ -846,6 +846,10 @@ ifdef CONFIG_LIVEPATCH
 KBUILD_CFLAGS += $(call cc-option, -flive-patching=inline-clone)
 endif
 
+ifdef CONFIG_FG_KASLR
+KBUILD_CFLAGS += -ffunction-sections
+endif
+
 # arch Makefile may override CC so keep this after arch Makefile is included
 NOSTDINC_FLAGS += -nostdinc -isystem $(shell $(CC) -print-file-name=include)
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5e8949953660..b4b1b17076a8 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2208,6 +2208,19 @@ config RANDOMIZE_BASE
 
 	  If unsure, say Y.
 
+config FG_KASLR
+	bool "Finer grained Kernel Address Space Layout Randomization"
+	depends on $(cc-option, -ffunction-sections)
+	depends on RANDOMIZE_BASE && X86_64
+	help
+	  This option improves the randomness of the kernel text
+	  over basic Kernel Address Space Layout Randomization (KASLR)
+	  by reordering the kernel text at boot time. This feature
+	  uses information generated at compile time to re-layout the
+	  kernel text section at boot time at function level granularity.
+
+	  If unsure, say N.
+
 # Relocation on x86 needs some additional build support
 config X86_NEED_RELOCS
 	def_bool y
-- 
2.24.1

