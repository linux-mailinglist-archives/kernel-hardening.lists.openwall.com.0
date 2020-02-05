Return-Path: <kernel-hardening-return-17663-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C644E1524EA
	for <lists+kernel-hardening@lfdr.de>; Wed,  5 Feb 2020 03:57:12 +0100 (CET)
Received: (qmail 4045 invoked by uid 550); 5 Feb 2020 02:56:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3869 invoked from network); 5 Feb 2020 02:56:51 -0000
From: Jason Yan <yanaijie@huawei.com>
To: <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>,
	<oss@buserror.net>
CC: <linux-kernel@vger.kernel.org>, <zhaohongjiang@huawei.com>, Jason Yan
	<yanaijie@huawei.com>
Subject: [PATCH v2 3/6] powerpc/fsl_booke/64: implement KASLR for fsl_booke64
Date: Wed, 5 Feb 2020 10:55:24 +0800
Message-ID: <20200205025527.28640-4-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200205025527.28640-1-yanaijie@huawei.com>
References: <20200205025527.28640-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected

The implementation for Freescale BookE64 is similar as BookE32. One
difference is that Freescale BookE64 set up a TLB mapping of 1G during
booting. Another difference is that ppc64 needs the kernel to be
64K-aligned. So we can randomize the kernel in this 1G mapping and make
it 64K-aligned. This can save some code to creat another TLB map at
early boot. The disadvantage is that we only have about 1G/64K = 16384
slots to put the kernel in.

To support secondary cpu boot up, a variable __kaslr_offset was added in
first_256B section. This can help secondary cpu get the kaslr offset
before the 1:1 mapping has been setup.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
Cc: Scott Wood <oss@buserror.net>
Cc: Diana Craciun <diana.craciun@nxp.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
---
 arch/powerpc/Kconfig                 |  2 +-
 arch/powerpc/kernel/exceptions-64e.S |  8 +++++++
 arch/powerpc/kernel/head_64.S        |  7 ++++++
 arch/powerpc/kernel/setup_64.c       |  4 +++-
 arch/powerpc/mm/nohash/kaslr_booke.c | 33 +++++++++++++++++++++++++---
 5 files changed, 49 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index c150a9d49343..754aeb96bb1c 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -568,7 +568,7 @@ config RELOCATABLE
 
 config RANDOMIZE_BASE
 	bool "Randomize the address of the kernel image"
-	depends on (FSL_BOOKE && FLATMEM && PPC32)
+	depends on (PPC_FSL_BOOK3E && FLATMEM)
 	depends on RELOCATABLE
 	help
 	  Randomizes the virtual address at which the kernel image is
diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
index 1b9b174bee86..121daeaf573d 100644
--- a/arch/powerpc/kernel/exceptions-64e.S
+++ b/arch/powerpc/kernel/exceptions-64e.S
@@ -1378,6 +1378,7 @@ skpinv:	addi	r6,r6,1				/* Increment */
 1:	mflr	r6
 	addi	r6,r6,(2f - 1b)
 	tovirt(r6,r6)
+	add	r6,r6,r19
 	lis	r7,MSR_KERNEL@h
 	ori	r7,r7,MSR_KERNEL@l
 	mtspr	SPRN_SRR0,r6
@@ -1400,6 +1401,7 @@ skpinv:	addi	r6,r6,1				/* Increment */
 
 	/* We translate LR and return */
 	tovirt(r8,r8)
+	add	r8,r8,r19
 	mtlr	r8
 	blr
 
@@ -1528,6 +1530,7 @@ a2_tlbinit_code_end:
  */
 _GLOBAL(start_initialization_book3e)
 	mflr	r28
+	li	r19, 0
 
 	/* First, we need to setup some initial TLBs to map the kernel
 	 * text, data and bss at PAGE_OFFSET. We don't have a real mode
@@ -1570,6 +1573,10 @@ _GLOBAL(book3e_secondary_core_init)
 	cmplwi	r4,0
 	bne	2f
 
+	LOAD_REG_ADDR_PIC(r19, __kaslr_offset)
+	lwz	r19,0(r19)
+	rlwinm  r19,r19,0,0,5
+
 	/* Setup TLB for this core */
 	bl	initial_tlb_book3e
 
@@ -1602,6 +1609,7 @@ _GLOBAL(book3e_secondary_core_init)
 	lis	r3,PAGE_OFFSET@highest
 	sldi	r3,r3,32
 	or	r28,r28,r3
+	add	r28,r28,r19
 1:	mtlr	r28
 	blr
 
diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
index ad79fddb974d..b4ececc4323d 100644
--- a/arch/powerpc/kernel/head_64.S
+++ b/arch/powerpc/kernel/head_64.S
@@ -104,6 +104,13 @@ __secondary_hold_acknowledge:
 	.8byte	0x0
 
 #ifdef CONFIG_RELOCATABLE
+#ifdef CONFIG_PPC_BOOK3E
+	. = 0x58
+	.globl	__kaslr_offset
+__kaslr_offset:
+DEFINE_FIXED_SYMBOL(__kaslr_offset)
+	.long	0
+#endif
 	/* This flag is set to 1 by a loader if the kernel should run
 	 * at the loaded address instead of the linked address.  This
 	 * is used by kexec-tools to keep the the kdump kernel in the
diff --git a/arch/powerpc/kernel/setup_64.c b/arch/powerpc/kernel/setup_64.c
index 6104917a282d..a16b970a8d1a 100644
--- a/arch/powerpc/kernel/setup_64.c
+++ b/arch/powerpc/kernel/setup_64.c
@@ -66,7 +66,7 @@
 #include <asm/feature-fixups.h>
 #include <asm/kup.h>
 #include <asm/early_ioremap.h>
-
+#include <mm/mmu_decl.h>
 #include "setup.h"
 
 int spinning_secondaries;
@@ -300,6 +300,8 @@ void __init early_setup(unsigned long dt_ptr)
 	/* Enable early debugging if any specified (see udbg.h) */
 	udbg_early_init();
 
+	kaslr_early_init(__va(dt_ptr), 0);
+
 	udbg_printf(" -> %s(), dt_ptr: 0x%lx\n", __func__, dt_ptr);
 
 	/*
diff --git a/arch/powerpc/mm/nohash/kaslr_booke.c b/arch/powerpc/mm/nohash/kaslr_booke.c
index 07b036e98353..c6f5c1db1394 100644
--- a/arch/powerpc/mm/nohash/kaslr_booke.c
+++ b/arch/powerpc/mm/nohash/kaslr_booke.c
@@ -231,7 +231,7 @@ static __init unsigned long get_usable_address(const void *fdt,
 	unsigned long pa;
 	unsigned long pa_end;
 
-	for (pa = offset; (long)pa > (long)start; pa -= SZ_16K) {
+	for (pa = offset; (long)pa > (long)start; pa -= SZ_64K) {
 		pa_end = pa + regions.kernel_size;
 		if (overlaps_region(fdt, pa, pa_end))
 			continue;
@@ -265,14 +265,14 @@ static unsigned long __init kaslr_legal_offset(void *dt_ptr, unsigned long rando
 {
 	unsigned long koffset = 0;
 	unsigned long start;
-	unsigned long index;
 	unsigned long offset;
 
+#ifdef CONFIG_PPC32
 	/*
 	 * Decide which 64M we want to start
 	 * Only use the low 8 bits of the random seed
 	 */
-	index = random & 0xFF;
+	unsigned long index = random & 0xFF;
 	index %= regions.linear_sz / SZ_64M;
 
 	/* Decide offset inside 64M */
@@ -287,6 +287,15 @@ static unsigned long __init kaslr_legal_offset(void *dt_ptr, unsigned long rando
 			break;
 		index--;
 	}
+#else
+	/* Decide kernel offset inside 1G */
+	offset = random % (SZ_1G - regions.kernel_size);
+	offset = round_down(offset, SZ_64K);
+
+	start = memstart_addr;
+	offset = memstart_addr + offset;
+	koffset = get_usable_address(dt_ptr, start, offset);
+#endif
 
 	if (koffset != 0)
 		koffset -= memstart_addr;
@@ -325,6 +334,7 @@ static unsigned long __init kaslr_choose_location(void *dt_ptr, phys_addr_t size
 	else
 		pr_warn("KASLR: No safe seed for randomizing the kernel base.\n");
 
+#ifdef CONFIG_PPC32
 	ram = min_t(phys_addr_t, __max_low_memory, size);
 	ram = map_mem_in_cams(ram, CONFIG_LOWMEM_CAM_NUM, true);
 	linear_sz = min_t(unsigned long, ram, SZ_512M);
@@ -332,6 +342,7 @@ static unsigned long __init kaslr_choose_location(void *dt_ptr, phys_addr_t size
 	/* If the linear size is smaller than 64M, do not randmize */
 	if (linear_sz < SZ_64M)
 		return 0;
+#endif
 
 	/* check for a reserved-memory node and record its cell sizes */
 	regions.reserved_mem = fdt_path_offset(dt_ptr, "/reserved-memory");
@@ -363,6 +374,17 @@ notrace void __init kaslr_early_init(void *dt_ptr, phys_addr_t size)
 	unsigned long offset;
 	unsigned long kernel_sz;
 
+#ifdef CONFIG_PPC64
+	unsigned int *__kaslr_offset = (unsigned int *)(KERNELBASE + 0x58);
+	unsigned int *__run_at_load = (unsigned int *)(KERNELBASE + 0x5c);
+
+	if (*__run_at_load == 1)
+		return;
+
+	/* Setup flat device-tree pointer */
+	initial_boot_params = dt_ptr;
+#endif
+
 	kernel_sz = (unsigned long)_end - (unsigned long)_stext;
 
 	offset = kaslr_choose_location(dt_ptr, size, kernel_sz);
@@ -372,6 +394,7 @@ notrace void __init kaslr_early_init(void *dt_ptr, phys_addr_t size)
 	kernstart_virt_addr += offset;
 	kernstart_addr += offset;
 
+#ifdef CONFIG_PPC32
 	is_second_reloc = 1;
 
 	if (offset >= SZ_64M) {
@@ -381,6 +404,10 @@ notrace void __init kaslr_early_init(void *dt_ptr, phys_addr_t size)
 		/* Create kernel map to relocate in */
 		create_kaslr_tlb_entry(1, tlb_virt, tlb_phys);
 	}
+#else
+	*__kaslr_offset = kernstart_virt_addr - KERNELBASE;
+	*__run_at_load = 1;
+#endif
 
 	/* Copy the kernel to it's new location and run */
 	memcpy((void *)kernstart_virt_addr, (void *)_stext, kernel_sz);
-- 
2.17.2

