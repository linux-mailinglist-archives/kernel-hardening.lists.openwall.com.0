Return-Path: <kernel-hardening-return-16105-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 98F3D42D30
	for <lists+kernel-hardening@lfdr.de>; Wed, 12 Jun 2019 19:13:53 +0200 (CEST)
Received: (qmail 31832 invoked by uid 550); 12 Jun 2019 17:13:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 25715 invoked from network); 12 Jun 2019 17:10:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1560359416; x=1591895416;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RGV2nXv0tDBodUuIHbEss/S4uQOCZyMq1lOqu82Edzk=;
  b=DKI6eQ+WbRydYOCREGbNW1s2tTCnTjV53T5YIpUYcuElMK+F0C51F5w7
   ElykNde00L9zQsLxS361Q0mR3iVBO44J00ntC1LQRkPr2xe2MOJBs4GAd
   ScoffolJBX40ShPznx+aGWRxVE1bBr8OnEXMXFQLGCFS5bJ12/JLnDwPR
   I=;
X-IronPort-AV: E=Sophos;i="5.62,366,1554768000"; 
   d="scan'208";a="400444646"
From: Marius Hillenbrand <mhillenb@amazon.de>
To: kvm@vger.kernel.org
Cc: Marius Hillenbrand <mhillenb@amazon.de>, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com, linux-mm@kvack.org,
        Alexander Graf <graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>
Subject: [RFC 01/10] x86/mm/kaslr: refactor to use enum indices for regions
Date: Wed, 12 Jun 2019 19:08:26 +0200
Message-Id: <20190612170834.14855-2-mhillenb@amazon.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190612170834.14855-1-mhillenb@amazon.de>
References: <20190612170834.14855-1-mhillenb@amazon.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The KASLR randomization code currently refers to specific regions, such
as the vmalloc area, by literal indices into an array. When adding new
regions, we have to be careful to also change all indices that may
potentially change. Avoid that risk by introducing an enum used as
indices.

Signed-off-by: Marius Hillenbrand <mhillenb@amazon.de>
Cc: Alexander Graf <graf@amazon.de>
Cc: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/mm/kaslr.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/kaslr.c b/arch/x86/mm/kaslr.c
index 3f452ffed7e9..c455f1ffba29 100644
--- a/arch/x86/mm/kaslr.c
+++ b/arch/x86/mm/kaslr.c
@@ -41,6 +41,12 @@
  */
 static const unsigned long vaddr_end = CPU_ENTRY_AREA_BASE;
 
+enum {
+	PHYSMAP,
+	VMALLOC,
+	VMMEMMAP,
+};
+
 /*
  * Memory regions randomized by KASLR (except modules that use a separate logic
  * earlier during boot). The list is ordered based on virtual addresses. This
@@ -50,9 +56,9 @@ static __initdata struct kaslr_memory_region {
 	unsigned long *base;
 	unsigned long size_tb;
 } kaslr_regions[] = {
-	{ &page_offset_base, 0 },
-	{ &vmalloc_base, 0 },
-	{ &vmemmap_base, 1 },
+	[PHYSMAP] = { &page_offset_base, 0 },
+	[VMALLOC] = { &vmalloc_base, 0 },
+	[VMMEMMAP] = { &vmemmap_base, 1 },
 };
 
 /* Get size in bytes used by the memory region */
@@ -94,20 +100,20 @@ void __init kernel_randomize_memory(void)
 	if (!kaslr_memory_enabled())
 		return;
 
-	kaslr_regions[0].size_tb = 1 << (__PHYSICAL_MASK_SHIFT - TB_SHIFT);
-	kaslr_regions[1].size_tb = VMALLOC_SIZE_TB;
+	kaslr_regions[PHYSMAP].size_tb = 1 << (__PHYSICAL_MASK_SHIFT - TB_SHIFT);
+	kaslr_regions[VMALLOC].size_tb = VMALLOC_SIZE_TB;
 
 	/*
 	 * Update Physical memory mapping to available and
 	 * add padding if needed (especially for memory hotplug support).
 	 */
-	BUG_ON(kaslr_regions[0].base != &page_offset_base);
+	BUG_ON(kaslr_regions[PHYSMAP].base != &page_offset_base);
 	memory_tb = DIV_ROUND_UP(max_pfn << PAGE_SHIFT, 1UL << TB_SHIFT) +
 		CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING;
 
 	/* Adapt phyiscal memory region size based on available memory */
-	if (memory_tb < kaslr_regions[0].size_tb)
-		kaslr_regions[0].size_tb = memory_tb;
+	if (memory_tb < kaslr_regions[PHYSMAP].size_tb)
+		kaslr_regions[PHYSMAP].size_tb = memory_tb;
 
 	/* Calculate entropy available between regions */
 	remain_entropy = vaddr_end - vaddr_start;
-- 
2.21.0

