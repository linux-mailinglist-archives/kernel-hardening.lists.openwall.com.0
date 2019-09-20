Return-Path: <kernel-hardening-return-16897-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B52C8B8DAD
	for <lists+kernel-hardening@lfdr.de>; Fri, 20 Sep 2019 11:26:37 +0200 (CEST)
Received: (qmail 32102 invoked by uid 550); 20 Sep 2019 09:25:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 31965 invoked from network); 20 Sep 2019 09:25:41 -0000
From: Jason Yan <yanaijie@huawei.com>
To: <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<yebin10@huawei.com>, <thunder.leizhen@huawei.com>,
	<jingxiangfeng@huawei.com>, <zhaohongjiang@huawei.com>, <oss@buserror.net>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v7 06/12] powerpc/fsl_booke/32: implement KASLR infrastructure
Date: Fri, 20 Sep 2019 17:45:40 +0800
Message-ID: <20190920094546.44948-7-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190920094546.44948-1-yanaijie@huawei.com>
References: <20190920094546.44948-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected

This patch add support to boot kernel from places other than KERNELBASE.
Since CONFIG_RELOCATABLE has already supported, what we need to do is
map or copy kernel to a proper place and relocate. Freescale Book-E
parts expect lowmem to be mapped by fixed TLB entries(TLB1). The TLB1
entries are not suitable to map the kernel directly in a randomized
region, so we chose to copy the kernel to a proper place and restart to
relocate.

The offset of the kernel was not randomized yet(a fixed 64M is set). We
will randomize it in the next patch.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
Cc: Diana Craciun <diana.craciun@nxp.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Tested-by: Diana Craciun <diana.craciun@nxp.com>
Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 arch/powerpc/Kconfig                          | 11 ++++
 arch/powerpc/include/asm/nohash/mmu-book3e.h  |  1 -
 arch/powerpc/kernel/early_32.c                |  5 +-
 arch/powerpc/kernel/fsl_booke_entry_mapping.S | 15 +++--
 arch/powerpc/kernel/head_fsl_booke.S          | 13 +++-
 arch/powerpc/mm/mmu_decl.h                    |  7 +++
 arch/powerpc/mm/nohash/Makefile               |  1 +
 arch/powerpc/mm/nohash/fsl_booke.c            |  7 ++-
 arch/powerpc/mm/nohash/kaslr_booke.c          | 62 +++++++++++++++++++
 9 files changed, 106 insertions(+), 16 deletions(-)
 create mode 100644 arch/powerpc/mm/nohash/kaslr_booke.c

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index d8dcd8820369..4845d572b00f 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -547,6 +547,17 @@ config RELOCATABLE
 	  setting can still be useful to bootwrappers that need to know the
 	  load address of the kernel (eg. u-boot/mkimage).
 
+config RANDOMIZE_BASE
+	bool "Randomize the address of the kernel image"
+	depends on (FSL_BOOKE && FLATMEM && PPC32)
+	depends on RELOCATABLE
+	help
+	  Randomizes the virtual address at which the kernel image is
+	  loaded, as a security feature that deters exploit attempts
+	  relying on knowledge of the location of kernel internals.
+
+	  If unsure, say Y.
+
 config RELOCATABLE_TEST
 	bool "Test relocatable kernel"
 	depends on (PPC64 && RELOCATABLE)
diff --git a/arch/powerpc/include/asm/nohash/mmu-book3e.h b/arch/powerpc/include/asm/nohash/mmu-book3e.h
index fa3efc2d310f..b41004664312 100644
--- a/arch/powerpc/include/asm/nohash/mmu-book3e.h
+++ b/arch/powerpc/include/asm/nohash/mmu-book3e.h
@@ -75,7 +75,6 @@
 #define MAS2_E			0x00000001
 #define MAS2_WIMGE_MASK		0x0000001f
 #define MAS2_EPN_MASK(size)		(~0 << (size + 10))
-#define MAS2_VAL(addr, size, flags)	((addr) & MAS2_EPN_MASK(size) | (flags))
 
 #define MAS3_RPN		0xFFFFF000
 #define MAS3_U0			0x00000200
diff --git a/arch/powerpc/kernel/early_32.c b/arch/powerpc/kernel/early_32.c
index 3482118ffe76..6f8689d7ca7b 100644
--- a/arch/powerpc/kernel/early_32.c
+++ b/arch/powerpc/kernel/early_32.c
@@ -22,7 +22,8 @@ notrace unsigned long __init early_init(unsigned long dt_ptr)
 	unsigned long offset = reloc_offset();
 
 	/* First zero the BSS */
-	memset(PTRRELOC(&__bss_start), 0, __bss_stop - __bss_start);
+	if (kernstart_virt_addr == KERNELBASE)
+		memset(PTRRELOC(&__bss_start), 0, __bss_stop - __bss_start);
 
 	/*
 	 * Identify the CPU type and fix up code sections
@@ -32,5 +33,5 @@ notrace unsigned long __init early_init(unsigned long dt_ptr)
 
 	apply_feature_fixups();
 
-	return KERNELBASE + offset;
+	return kernstart_virt_addr + offset;
 }
diff --git a/arch/powerpc/kernel/fsl_booke_entry_mapping.S b/arch/powerpc/kernel/fsl_booke_entry_mapping.S
index f4d3eaae54a9..8bccce6544b5 100644
--- a/arch/powerpc/kernel/fsl_booke_entry_mapping.S
+++ b/arch/powerpc/kernel/fsl_booke_entry_mapping.S
@@ -155,23 +155,22 @@ skpinv:	addi	r6,r6,1				/* Increment */
 
 #if defined(ENTRY_MAPPING_BOOT_SETUP)
 
-/* 6. Setup KERNELBASE mapping in TLB1[0] */
+/* 6. Setup kernstart_virt_addr mapping in TLB1[0] */
 	lis	r6,0x1000		/* Set MAS0(TLBSEL) = TLB1(1), ESEL = 0 */
 	mtspr	SPRN_MAS0,r6
 	lis	r6,(MAS1_VALID|MAS1_IPROT)@h
 	ori	r6,r6,(MAS1_TSIZE(BOOK3E_PAGESZ_64M))@l
 	mtspr	SPRN_MAS1,r6
-	lis	r6,MAS2_VAL(PAGE_OFFSET, BOOK3E_PAGESZ_64M, MAS2_M_IF_NEEDED)@h
-	ori	r6,r6,MAS2_VAL(PAGE_OFFSET, BOOK3E_PAGESZ_64M, MAS2_M_IF_NEEDED)@l
+	lis	r6,MAS2_EPN_MASK(BOOK3E_PAGESZ_64M)@h
+	ori	r6,r6,MAS2_EPN_MASK(BOOK3E_PAGESZ_64M)@l
+	and	r6,r6,r20
+	ori	r6,r6,MAS2_M_IF_NEEDED@l
 	mtspr	SPRN_MAS2,r6
 	mtspr	SPRN_MAS3,r8
 	tlbwe
 
-/* 7. Jump to KERNELBASE mapping */
-	lis	r6,(KERNELBASE & ~0xfff)@h
-	ori	r6,r6,(KERNELBASE & ~0xfff)@l
-	rlwinm	r7,r25,0,0x03ffffff
-	add	r6,r7,r6
+/* 7. Jump to kernstart_virt_addr mapping */
+	mr	r6,r20
 
 #elif defined(ENTRY_MAPPING_KEXEC_SETUP)
 /*
diff --git a/arch/powerpc/kernel/head_fsl_booke.S b/arch/powerpc/kernel/head_fsl_booke.S
index d9f599b01ff1..838d9d4650c7 100644
--- a/arch/powerpc/kernel/head_fsl_booke.S
+++ b/arch/powerpc/kernel/head_fsl_booke.S
@@ -155,6 +155,8 @@ _ENTRY(_start);
  */
 
 _ENTRY(__early_start)
+	LOAD_REG_ADDR_PIC(r20, kernstart_virt_addr)
+	lwz     r20,0(r20)
 
 #define ENTRY_MAPPING_BOOT_SETUP
 #include "fsl_booke_entry_mapping.S"
@@ -277,8 +279,8 @@ set_ivor:
 	ori	r6, r6, swapper_pg_dir@l
 	lis	r5, abatron_pteptrs@h
 	ori	r5, r5, abatron_pteptrs@l
-	lis	r4, KERNELBASE@h
-	ori	r4, r4, KERNELBASE@l
+	lis     r3, kernstart_virt_addr@ha
+	lwz     r4, kernstart_virt_addr@l(r3)
 	stw	r5, 0(r4)	/* Save abatron_pteptrs at a fixed location */
 	stw	r6, 0(r5)
 
@@ -1067,7 +1069,12 @@ __secondary_start:
 	mr	r5,r25		/* phys kernel start */
 	rlwinm	r5,r5,0,~0x3ffffff	/* aligned 64M */
 	subf	r4,r5,r4	/* memstart_addr - phys kernel start */
-	li	r5,0		/* no device tree */
+	lis	r7,KERNELBASE@h
+	ori	r7,r7,KERNELBASE@l
+	cmpw	r20,r7		/* if kernstart_virt_addr != KERNELBASE, randomized */
+	beq	2f
+	li	r4,0
+2:	li	r5,0		/* no device tree */
 	li	r6,0		/* not boot cpu */
 	bl	restore_to_as0
 
diff --git a/arch/powerpc/mm/mmu_decl.h b/arch/powerpc/mm/mmu_decl.h
index 55e86a0bf562..a3a4937c0496 100644
--- a/arch/powerpc/mm/mmu_decl.h
+++ b/arch/powerpc/mm/mmu_decl.h
@@ -144,10 +144,17 @@ extern int switch_to_as1(void);
 extern void restore_to_as0(int esel, int offset, void *dt_ptr, int bootcpu);
 void create_kaslr_tlb_entry(int entry, unsigned long virt, phys_addr_t phys);
 void reloc_kernel_entry(void *fdt, int addr);
+extern int is_second_reloc;
 #endif
 extern void loadcam_entry(unsigned int index);
 extern void loadcam_multi(int first_idx, int num, int tmp_idx);
 
+#ifdef CONFIG_RANDOMIZE_BASE
+void kaslr_early_init(void *dt_ptr, phys_addr_t size);
+#else
+static inline void kaslr_early_init(void *dt_ptr, phys_addr_t size) {}
+#endif
+
 struct tlbcam {
 	u32	MAS0;
 	u32	MAS1;
diff --git a/arch/powerpc/mm/nohash/Makefile b/arch/powerpc/mm/nohash/Makefile
index 33b6f6f29d3f..0424f6ce5bd8 100644
--- a/arch/powerpc/mm/nohash/Makefile
+++ b/arch/powerpc/mm/nohash/Makefile
@@ -8,6 +8,7 @@ obj-$(CONFIG_40x)		+= 40x.o
 obj-$(CONFIG_44x)		+= 44x.o
 obj-$(CONFIG_PPC_8xx)		+= 8xx.o
 obj-$(CONFIG_PPC_FSL_BOOK3E)	+= fsl_booke.o
+obj-$(CONFIG_RANDOMIZE_BASE)	+= kaslr_booke.o
 ifdef CONFIG_HUGETLB_PAGE
 obj-$(CONFIG_PPC_FSL_BOOK3E)	+= book3e_hugetlbpage.o
 endif
diff --git a/arch/powerpc/mm/nohash/fsl_booke.c b/arch/powerpc/mm/nohash/fsl_booke.c
index 556e3cd52a35..2dc27cf88add 100644
--- a/arch/powerpc/mm/nohash/fsl_booke.c
+++ b/arch/powerpc/mm/nohash/fsl_booke.c
@@ -263,7 +263,8 @@ void setup_initial_memory_limit(phys_addr_t first_memblock_base,
 int __initdata is_second_reloc;
 notrace void __init relocate_init(u64 dt_ptr, phys_addr_t start)
 {
-	unsigned long base = KERNELBASE;
+	unsigned long base = kernstart_virt_addr;
+	phys_addr_t size;
 
 	kernstart_addr = start;
 	if (is_second_reloc) {
@@ -291,7 +292,7 @@ notrace void __init relocate_init(u64 dt_ptr, phys_addr_t start)
 	start &= ~0x3ffffff;
 	base &= ~0x3ffffff;
 	virt_phys_offset = base - start;
-	early_get_first_memblock_info(__va(dt_ptr), NULL);
+	early_get_first_memblock_info(__va(dt_ptr), &size);
 	/*
 	 * We now get the memstart_addr, then we should check if this
 	 * address is the same as what the PAGE_OFFSET map to now. If
@@ -316,6 +317,8 @@ notrace void __init relocate_init(u64 dt_ptr, phys_addr_t start)
 		/* We should never reach here */
 		panic("Relocation error");
 	}
+
+	kaslr_early_init(__va(dt_ptr), size);
 }
 #endif
 #endif
diff --git a/arch/powerpc/mm/nohash/kaslr_booke.c b/arch/powerpc/mm/nohash/kaslr_booke.c
new file mode 100644
index 000000000000..29c1567d8d40
--- /dev/null
+++ b/arch/powerpc/mm/nohash/kaslr_booke.c
@@ -0,0 +1,62 @@
+// SPDX-License-Identifier: GPL-2.0-only
+//
+// Copyright (C) 2019 Jason Yan <yanaijie@huawei.com>
+
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/string.h>
+#include <linux/types.h>
+#include <linux/mm.h>
+#include <linux/swap.h>
+#include <linux/stddef.h>
+#include <linux/init.h>
+#include <linux/delay.h>
+#include <linux/memblock.h>
+#include <asm/pgalloc.h>
+#include <asm/prom.h>
+#include <mm/mmu_decl.h>
+
+static unsigned long __init kaslr_choose_location(void *dt_ptr, phys_addr_t size,
+						  unsigned long kernel_sz)
+{
+	/* return a fixed offset of 64M for now */
+	return SZ_64M;
+}
+
+/*
+ * To see if we need to relocate the kernel to a random offset
+ * void *dt_ptr - address of the device tree
+ * phys_addr_t size - size of the first memory block
+ */
+notrace void __init kaslr_early_init(void *dt_ptr, phys_addr_t size)
+{
+	unsigned long tlb_virt;
+	phys_addr_t tlb_phys;
+	unsigned long offset;
+	unsigned long kernel_sz;
+
+	kernel_sz = (unsigned long)_end - (unsigned long)_stext;
+
+	offset = kaslr_choose_location(dt_ptr, size, kernel_sz);
+	if (offset == 0)
+		return;
+
+	kernstart_virt_addr += offset;
+	kernstart_addr += offset;
+
+	is_second_reloc = 1;
+
+	if (offset >= SZ_64M) {
+		tlb_virt = round_down(kernstart_virt_addr, SZ_64M);
+		tlb_phys = round_down(kernstart_addr, SZ_64M);
+
+		/* Create kernel map to relocate in */
+		create_kaslr_tlb_entry(1, tlb_virt, tlb_phys);
+	}
+
+	/* Copy the kernel to it's new location and run */
+	memcpy((void *)kernstart_virt_addr, (void *)_stext, kernel_sz);
+	flush_icache_range(kernstart_virt_addr, kernstart_virt_addr + kernel_sz);
+
+	reloc_kernel_entry(dt_ptr, kernstart_virt_addr);
+}
-- 
2.17.2

