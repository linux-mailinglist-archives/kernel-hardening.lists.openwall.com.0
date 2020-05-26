Return-Path: <kernel-hardening-return-18371-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 513F719C11B
	for <lists+kernel-hardening@lfdr.de>; Thu,  2 Apr 2020 14:32:31 +0200 (CEST)
Received: (qmail 9698 invoked by uid 550); 2 Apr 2020 12:31:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9486 invoked from network); 2 Apr 2020 12:31:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=fm1; bh=yjcmaLzBRyLGb/UVy+RrtRJ3hQ
	/di28wqEBdPNLzpIE=; b=K03vOrFee41hcNqAPAx+fH/WykePx9J1pGe/o6xnv2
	1vWunHXeOEXAu0hYufd2tRpyimLtse/WYUpn8oJR+lM9kZ4srMgcc5DYHCF8ZFRd
	4e5+D3eEvI/nEJ2LJ9eQovEeWT4T2hcnJ7SmFSotHQo2YE3bIRlZJRtIey9h0rNE
	rLGjNBvk5jNHsLeOFUhO1m9xAGx3DHMgxTgAg086p34OuXAFR7Kf28Bzi1DWg8x/
	Y3sGW2XAUALu4d7vE/kdEwHKa/T824tVzdhe5dp2z35POmvqECzCeMqke57MTYdr
	Y1U0WvOcp9jW5Qi8wU2e22eJRYw6yh7PzX1pBbDsQRRQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=yjcmaLzBRyLGb/UVy
	+RrtRJ3hQ/di28wqEBdPNLzpIE=; b=t6G74PLKZnldYLWpgyCqT19uX7DMVLT5/
	HTwFHIKF9mYsH2hs2EYJMUG5kQkTwqUZjIyPEX7Kwi4W5Ek6CoeYpA0VAqkgceJ9
	fYQhmq2gdCpAQTkgjDDI0LGQ21fmaeGo8mEBj/OR42+0gARZ5UyCdbaXd3eaJq8V
	qhf0N3pBjxxYoyCxfrMSaiWFN1OyWFYARHtYXea29y3inNBPWHgk3yma3EgaFk0C
	omHv6kUMYyIMa9c0crNL5jE2/vJx4Tc8mtHciFriHZw9z/Y2kI54/mH8lEREjj2k
	Vcy+JqkiSurZKHiEpBfzlgOSiuLnn9bDqv2d2oXCxuGpgCBRa7x5g==
X-ME-Sender: <xms:KqWFXuctEOwvDSt-UoH4H3Z5iOTg54981S1bBhGBqifINuIAcbxxPQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtdeggddtgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculddutddmnecujfgurhephffvuf
    ffkffoggfgsedtkeertdertddtnecuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgvhicu
    oehruhhstghurhesrhhushhsvghllhdrtggtqeenucfkphepuddvuddrgeehrddvuddvrd
    dvfeelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhep
    rhhushgtuhhrsehruhhsshgvlhhlrdgttg
X-ME-Proxy: <xmx:KqWFXvB6NVOFSBLBLO3gHQp4Pzvm5VVa0oD7gQ4vxnzJIpMHceyZGg>
    <xmx:KqWFXoeOBs1pPM6QvmKCHhj-z0tzsPNnGwYDS82CzE5nlduDHL1sAA>
    <xmx:KqWFXuzETb7VrRieiwFGzMjAr3uzW_u8b2hHdqSFqhp9VL46siqE1g>
    <xmx:K6WFXo7HbtbG_3a79qyc8y3XXcy26azaqU40OpWSsvqcy-eWDgUXWw>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: Russell Currey <ruscur@russell.cc>,
	christophe.leroy@c-s.fr,
	mpe@ellerman.id.au,
	ajd@linux.ibm.com,
	dja@axtens.net,
	npiggin@gmail.com,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v8 1/7] powerpc/mm: Implement set_memory() routines
Date: Thu,  2 Apr 2020 19:40:46 +1100
Message-Id: <20200402084053.188537-1-ruscur@russell.cc>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The set_memory_{ro/rw/nx/x}() functions are required for STRICT_MODULE_RWX,
and are generally useful primitives to have.  This implementation is
designed to be completely generic across powerpc's many MMUs.

It's possible that this could be optimised to be faster for specific
MMUs, but the focus is on having a generic and safe implementation for
now.

This implementation does not handle cases where the caller is attempting
to change the mapping of the page it is executing from, or if another
CPU is concurrently using the page being altered.  These cases likely
shouldn't happen, but a more complex implementation with MMU-specific code
could safely handle them, so that is left as a TODO for now.

These functions do nothing if STRICT_KERNEL_RWX is not enabled.

Reviewed-by: Daniel Axtens <dja@axtens.net>
Signed-off-by: Russell Currey <ruscur@russell.cc>
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---

 arch/powerpc/Kconfig                  |  1 +
 arch/powerpc/include/asm/set_memory.h | 32 +++++++++++
 arch/powerpc/mm/Makefile              |  2 +-
 arch/powerpc/mm/pageattr.c            | 81 +++++++++++++++++++++++++++
 4 files changed, 115 insertions(+), 1 deletion(-)
 create mode 100644 arch/powerpc/include/asm/set_memory.h
 create mode 100644 arch/powerpc/mm/pageattr.c

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 6f40af294685..399a4de28ff0 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -129,6 +129,7 @@ config PPC
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_MEMBARRIER_CALLBACKS
 	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE && PPC_BOOK3S_64
+	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_STRICT_KERNEL_RWX	if ((PPC_BOOK3S_64 || PPC32) && !HIBERNATION)
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UACCESS_FLUSHCACHE
diff --git a/arch/powerpc/include/asm/set_memory.h b/arch/powerpc/include/asm/set_memory.h
new file mode 100644
index 000000000000..64011ea444b4
--- /dev/null
+++ b/arch/powerpc/include/asm/set_memory.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_POWERPC_SET_MEMORY_H
+#define _ASM_POWERPC_SET_MEMORY_H
+
+#define SET_MEMORY_RO	0
+#define SET_MEMORY_RW	1
+#define SET_MEMORY_NX	2
+#define SET_MEMORY_X	3
+
+int change_memory_attr(unsigned long addr, int numpages, long action);
+
+static inline int set_memory_ro(unsigned long addr, int numpages)
+{
+	return change_memory_attr(addr, numpages, SET_MEMORY_RO);
+}
+
+static inline int set_memory_rw(unsigned long addr, int numpages)
+{
+	return change_memory_attr(addr, numpages, SET_MEMORY_RW);
+}
+
+static inline int set_memory_nx(unsigned long addr, int numpages)
+{
+	return change_memory_attr(addr, numpages, SET_MEMORY_NX);
+}
+
+static inline int set_memory_x(unsigned long addr, int numpages)
+{
+	return change_memory_attr(addr, numpages, SET_MEMORY_X);
+}
+
+#endif
diff --git a/arch/powerpc/mm/Makefile b/arch/powerpc/mm/Makefile
index 5e147986400d..a998fdac52f9 100644
--- a/arch/powerpc/mm/Makefile
+++ b/arch/powerpc/mm/Makefile
@@ -5,7 +5,7 @@
 
 ccflags-$(CONFIG_PPC64)	:= $(NO_MINIMAL_TOC)
 
-obj-y				:= fault.o mem.o pgtable.o mmap.o \
+obj-y				:= fault.o mem.o pgtable.o mmap.o pageattr.o \
 				   init_$(BITS).o pgtable_$(BITS).o \
 				   pgtable-frag.o ioremap.o ioremap_$(BITS).o \
 				   init-common.o mmu_context.o drmem.o
diff --git a/arch/powerpc/mm/pageattr.c b/arch/powerpc/mm/pageattr.c
new file mode 100644
index 000000000000..2da3fbab6ff7
--- /dev/null
+++ b/arch/powerpc/mm/pageattr.c
@@ -0,0 +1,81 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * MMU-generic set_memory implementation for powerpc
+ *
+ * Copyright 2019, IBM Corporation.
+ */
+
+#include <linux/mm.h>
+#include <linux/set_memory.h>
+
+#include <asm/mmu.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+
+
+/*
+ * Updates the attributes of a page in three steps:
+ *
+ * 1. invalidate the page table entry
+ * 2. flush the TLB
+ * 3. install the new entry with the updated attributes
+ *
+ * This is unsafe if the caller is attempting to change the mapping of the
+ * page it is executing from, or if another CPU is concurrently using the
+ * page being altered.
+ *
+ * TODO make the implementation resistant to this.
+ *
+ * NOTE: can be dangerous to call without STRICT_KERNEL_RWX
+ */
+static int change_page_attr(pte_t *ptep, unsigned long addr, void *data)
+{
+	long action = (long)data;
+	pte_t pte;
+
+	spin_lock(&init_mm.page_table_lock);
+
+	/* invalidate the PTE so it's safe to modify */
+	pte = ptep_get_and_clear(&init_mm, addr, ptep);
+	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
+
+	/* modify the PTE bits as desired, then apply */
+	switch (action) {
+	case SET_MEMORY_RO:
+		pte = pte_wrprotect(pte);
+		break;
+	case SET_MEMORY_RW:
+		pte = pte_mkwrite(pte);
+		break;
+	case SET_MEMORY_NX:
+		pte = pte_exprotect(pte);
+		break;
+	case SET_MEMORY_X:
+		pte = pte_mkexec(pte);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
+	}
+
+	set_pte_at(&init_mm, addr, ptep, pte);
+	spin_unlock(&init_mm.page_table_lock);
+
+	return 0;
+}
+
+int change_memory_attr(unsigned long addr, int numpages, long action)
+{
+	unsigned long start = ALIGN_DOWN(addr, PAGE_SIZE);
+	unsigned long sz = numpages * PAGE_SIZE;
+
+	if (!IS_ENABLED(CONFIG_STRICT_KERNEL_RWX))
+		return 0;
+
+	if (numpages <= 0)
+		return 0;
+
+	return apply_to_existing_page_range(&init_mm, start, sz,
+					    change_page_attr, (void *)action);
+}
-- 
2.26.0

