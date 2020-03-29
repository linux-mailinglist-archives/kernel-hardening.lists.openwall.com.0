Return-Path: <kernel-hardening-return-18281-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 56B02196E0A
	for <lists+kernel-hardening@lfdr.de>; Sun, 29 Mar 2020 17:02:03 +0200 (CEST)
Received: (qmail 3366 invoked by uid 550); 29 Mar 2020 15:01:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 22066 invoked from network); 29 Mar 2020 14:14:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585491243;
	bh=4XpHVvC8TcjRHMXA07MsHC1KMbRM57UlVFxVOGGaVZQ=;
	h=From:To:Cc:Subject:Date:From;
	b=faOX4sSFauxZrAmlwYEdXcv9jA5gJ1oyD12Tkd2n7uqk4ze2vIMaI0GvBGeYgLOLA
	 Q0Kx9A6pErdgIP0IUF2D0F/q2cYf47TDuxHtUswHjSlbtHB3q5jgAQ5sXI91Hr8hhJ
	 KJmqJIY04zTZsNR/SGMsNjpGSe2IC8woM8oEyo+Q=
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Cc: kernel-hardening@lists.openwall.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	Ard Biesheuvel <ardb@kernel.org>
Subject: [RFC PATCH] arm64: remove CONFIG_DEBUG_ALIGN_RODATA feature
Date: Sun, 29 Mar 2020 16:12:58 +0200
Message-Id: <20200329141258.31172-1-ardb@kernel.org>
X-Mailer: git-send-email 2.17.1

When CONFIG_DEBUG_ALIGN_RODATA is enabled, kernel segments mapped with
different permissions (r-x for .text, r-- for .rodata, rw- for .data,
etc) are rounded up to 2 MiB so they can be mapped more efficiently.
In particular, it permits the segments to be mapped using level 2
block entries when using 4k pages, which is expected to result in less
TLB pressure.

However, the mappings for the bulk of the kernel will use level 2
entries anyway, and the misaligned fringes are organized such that they
can take advantage of the contiguous bit, and use far fewer level 3
entries than would be needed otherwise.

This makes the value of this feature dubious at best, and since it is not
enabled in defconfig or in the distro configs, it does not appear to be
in wide use either. So let's just remove it.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/Kconfig.debug                  | 13 -------------
 arch/arm64/include/asm/memory.h           | 12 +-----------
 drivers/firmware/efi/libstub/arm64-stub.c |  8 +++-----
 3 files changed, 4 insertions(+), 29 deletions(-)

diff --git a/arch/arm64/Kconfig.debug b/arch/arm64/Kconfig.debug
index 1c906d932d6b..a1efa246c9ed 100644
--- a/arch/arm64/Kconfig.debug
+++ b/arch/arm64/Kconfig.debug
@@ -52,19 +52,6 @@ config DEBUG_WX
 
 	  If in doubt, say "Y".
 
-config DEBUG_ALIGN_RODATA
-	depends on STRICT_KERNEL_RWX
-	bool "Align linker sections up to SECTION_SIZE"
-	help
-	  If this option is enabled, sections that may potentially be marked as
-	  read only or non-executable will be aligned up to the section size of
-	  the kernel. This prevents sections from being split into pages and
-	  avoids a potential TLB penalty. The downside is an increase in
-	  alignment and potentially wasted space. Turn on this option if
-	  performance is more important than memory pressure.
-
-	  If in doubt, say N.
-
 config DEBUG_EFI
 	depends on EFI && DEBUG_INFO
 	bool "UEFI debugging"
diff --git a/arch/arm64/include/asm/memory.h b/arch/arm64/include/asm/memory.h
index 4d94676e5a8b..3b34f7bde2f2 100644
--- a/arch/arm64/include/asm/memory.h
+++ b/arch/arm64/include/asm/memory.h
@@ -119,22 +119,12 @@
 
 /*
  * Alignment of kernel segments (e.g. .text, .data).
- */
-#if defined(CONFIG_DEBUG_ALIGN_RODATA)
-/*
- *  4 KB granule:   1 level 2 entry
- * 16 KB granule: 128 level 3 entries, with contiguous bit
- * 64 KB granule:  32 level 3 entries, with contiguous bit
- */
-#define SEGMENT_ALIGN		SZ_2M
-#else
-/*
+ *
  *  4 KB granule:  16 level 3 entries, with contiguous bit
  * 16 KB granule:   4 level 3 entries, without contiguous bit
  * 64 KB granule:   1 level 3 entry
  */
 #define SEGMENT_ALIGN		SZ_64K
-#endif
 
 /*
  * Memory types available.
diff --git a/drivers/firmware/efi/libstub/arm64-stub.c b/drivers/firmware/efi/libstub/arm64-stub.c
index db0c1a9c1699..fc9f8ab533a7 100644
--- a/drivers/firmware/efi/libstub/arm64-stub.c
+++ b/drivers/firmware/efi/libstub/arm64-stub.c
@@ -75,14 +75,12 @@ efi_status_t handle_kernel_image(unsigned long *image_addr,
 
 	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && phys_seed != 0) {
 		/*
-		 * If CONFIG_DEBUG_ALIGN_RODATA is not set, produce a
-		 * displacement in the interval [0, MIN_KIMG_ALIGN) that
-		 * doesn't violate this kernel's de-facto alignment
+		 * Produce a displacement in the interval [0, MIN_KIMG_ALIGN)
+		 * that doesn't violate this kernel's de-facto alignment
 		 * constraints.
 		 */
 		u32 mask = (MIN_KIMG_ALIGN - 1) & ~(EFI_KIMG_ALIGN - 1);
-		u32 offset = !IS_ENABLED(CONFIG_DEBUG_ALIGN_RODATA) ?
-			     (phys_seed >> 32) & mask : TEXT_OFFSET;
+		u32 offset = (phys_seed >> 32) & mask;
 
 		/*
 		 * With CONFIG_RANDOMIZE_TEXT_OFFSET=y, TEXT_OFFSET may not
-- 
2.17.1

