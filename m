Return-Path: <kernel-hardening-return-16142-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 98B5B4544D
	for <lists+kernel-hardening@lfdr.de>; Fri, 14 Jun 2019 07:51:00 +0200 (CEST)
Received: (qmail 31870 invoked by uid 550); 14 Jun 2019 05:50:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 31807 invoked from network); 14 Jun 2019 05:50:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=russell.cc; h=
	from:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=fm2; bh=O1MGuxb4E3KY6lySswpapdh1f/
	wVb0DtMIWHPl2wjz4=; b=2EY4vCEfAFDSqr8oc+l9nO2hoQ+EeOdD8bhKbIRz7Y
	Gvd2HHhS7CDLPZl2cOm7t8AphOxPbZWJXd6Jz97EGHwfJsWZmG69rxOVBqwmxosw
	BnOEOPHSAZzJa8Wu+raFYhQOyWSfHjOkLrd3fKxU1t9X7X/KWb97GyTbXO9W60x8
	cinUgGTf7oD8y2Tm97jpc8V7a/dRNj2nHwlTZTCGpLNwyT8sHCTW7qCIw6ZMF8tn
	tDAXpu1U5Uj7h+9QVWKZAY/4uz+lyJEw5uZIT6dAaO8O8sv7Xrgr+La3STsFNi5G
	1OlhAXCsKHYTju6C7/rlItzmRRtZ/kyCccx9nixtZ+yg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:content-transfer-encoding:date:from
	:message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=O1MGuxb4E3KY6lySs
	wpapdh1f/wVb0DtMIWHPl2wjz4=; b=jNoiZEoMcROSEt8lwV3wGlX9EOzhRvP3s
	NQFiGkd/8kOJcRBZJUKRAaoKW4tJfcBgwVCOaVbJbeBS54ncsm6pQLrNzM+nYAcN
	BDf5WlWvflVindKCsscz8183MXZuHs8+w15fGx4gifE1myxXff4rZUfDGwNd0anr
	bPQ3nfkfkCNROfQ1iCPMq9UhuR3JeD7ugf3qIOc8nuzuC+5shhlJk6ctF0+cCcdB
	aGHMtzytmjd8kTrYpIDinUvuAadO+ePOB9iWiFfH5l3kVmiKMD2CgWbKYYM3oRFd
	OrjccBfjmdEfFq7vOBxeXTT4cOwz+tMz2JH0GQ3AfzxT394VyN8fg==
X-ME-Sender: <xms:sDUDXbp5E84MCO-YlEPLNL6zRjiAuxM3ZJ9Fsns4IGpSaY4OOAVHKA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeitddguddtudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enfghrlhcuvffnffculdduhedmnecujfgurhephffvufffkffoggfgsedtkeertdertddt
    necuhfhrohhmpeftuhhsshgvlhhlucevuhhrrhgvhicuoehruhhstghurhesrhhushhsvg
    hllhdrtggtqeenucfkphepuddvvddrleelrdekvddruddtnecurfgrrhgrmhepmhgrihhl
    fhhrohhmpehruhhstghurhesrhhushhsvghllhdrtggtnecuvehluhhsthgvrhfuihiivg
    eptd
X-ME-Proxy: <xmx:sDUDXTE2-hOYf4beXrAh3G07SBRCG3xDw7iR99u9ORj7Jersqq8RNw>
    <xmx:sDUDXYLUtd_z31qT6EgloMBz9adEZaVgYwNuLjN8r1JqrejPrakCxA>
    <xmx:sDUDXQjgdKui6t8vtyDAVT_Te4Pje-S5cRao_0uJjgvA1uRZ7hqCww>
    <xmx:sDUDXeU-nVxv6XQYIsOSx4y_HpI7WRNtEiZTTJP1ATTKTX5Kt9STgA>
From: Russell Currey <ruscur@russell.cc>
To: linuxppc-dev@lists.ozlabs.org
Cc: kernel-hardening@lists.openwall.com,
	Russell Currey <ruscur@russell.cc>,
	Christophe Leroy <christophe.leroy@c-s.fr>
Subject: [PATCH v2] powerpc/mm: Implement STRICT_MODULE_RWX
Date: Fri, 14 Jun 2019 15:50:13 +1000
Message-Id: <20190614055013.21014-1-ruscur@russell.cc>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Strict module RWX is just like strict kernel RWX, but for modules - so
loadable modules aren't marked both writable and executable at the same
time.  This is handled by the generic code in kernel/module.c, and
simply requires the architecture to implement the set_memory() set of
functions, declared with ARCH_HAS_SET_MEMORY.

There's nothing other than these functions required to turn
ARCH_HAS_STRICT_MODULE_RWX on, so turn that on too.

With STRICT_MODULE_RWX enabled, there are as many W+X pages at runtime
as there are with CONFIG_MODULES=n (none), so in Russel's testing it works
well on both Hash and Radix book3s64.

There's a TODO in the code for also applying the page permission changes
to the backing pages in the linear mapping: this is pretty simple for
Radix and (seemingly) a lot harder for Hash, so I've left it for now
since there's still a notable security benefit for the patch as-is.

Technically can be enabled without STRICT_KERNEL_RWX, but
that doesn't gets you a whole lot, so we should leave it off by default
until we can get STRICT_KERNEL_RWX to the point where it's enabled by
default.

Signed-off-by: Russell Currey <ruscur@russell.cc>
Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
Changes from v1 (sent by Christophe):
 - return if VM_FLUSH_RESET_PERMS is set

 arch/powerpc/Kconfig                  |  2 +
 arch/powerpc/include/asm/set_memory.h | 32 ++++++++++
 arch/powerpc/mm/Makefile              |  2 +-
 arch/powerpc/mm/pageattr.c            | 85 +++++++++++++++++++++++++++
 4 files changed, 120 insertions(+), 1 deletion(-)
 create mode 100644 arch/powerpc/include/asm/set_memory.h
 create mode 100644 arch/powerpc/mm/pageattr.c

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index 8c1c636308c8..3d98240ce965 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -131,7 +131,9 @@ config PPC
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_MEMBARRIER_CALLBACKS
 	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE && PPC64
+	select ARCH_HAS_SET_MEMORY
 	select ARCH_HAS_STRICT_KERNEL_RWX	if ((PPC_BOOK3S_64 || PPC32) && !RELOCATABLE && !HIBERNATION)
+	select ARCH_HAS_STRICT_MODULE_RWX	if PPC_BOOK3S_64 || PPC32
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UACCESS_FLUSHCACHE	if PPC64
 	select ARCH_HAS_UBSAN_SANITIZE_ALL
diff --git a/arch/powerpc/include/asm/set_memory.h b/arch/powerpc/include/asm/set_memory.h
new file mode 100644
index 000000000000..4b9683f3b3dd
--- /dev/null
+++ b/arch/powerpc/include/asm/set_memory.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0+ */
+#ifndef _ASM_POWERPC_SET_MEMORY_H
+#define _ASM_POWERPC_SET_MEMORY_H
+
+#define SET_MEMORY_RO	1
+#define SET_MEMORY_RW	2
+#define SET_MEMORY_NX	3
+#define SET_MEMORY_X	4
+
+int change_memory(unsigned long addr, int numpages, int action);
+
+static inline int set_memory_ro(unsigned long addr, int numpages)
+{
+	return change_memory(addr, numpages, SET_MEMORY_RO);
+}
+
+static inline int set_memory_rw(unsigned long addr, int numpages)
+{
+	return change_memory(addr, numpages, SET_MEMORY_RW);
+}
+
+static inline int set_memory_nx(unsigned long addr, int numpages)
+{
+	return change_memory(addr, numpages, SET_MEMORY_NX);
+}
+
+static inline int set_memory_x(unsigned long addr, int numpages)
+{
+	return change_memory(addr, numpages, SET_MEMORY_X);
+}
+
+#endif
diff --git a/arch/powerpc/mm/Makefile b/arch/powerpc/mm/Makefile
index 0f499db315d6..b683d1c311b3 100644
--- a/arch/powerpc/mm/Makefile
+++ b/arch/powerpc/mm/Makefile
@@ -7,7 +7,7 @@ ccflags-$(CONFIG_PPC64)	:= $(NO_MINIMAL_TOC)
 
 obj-y				:= fault.o mem.o pgtable.o mmap.o \
 				   init_$(BITS).o pgtable_$(BITS).o \
-				   pgtable-frag.o \
+				   pgtable-frag.o pageattr.o \
 				   init-common.o mmu_context.o drmem.o
 obj-$(CONFIG_PPC_MMU_NOHASH)	+= nohash/
 obj-$(CONFIG_PPC_BOOK3S_32)	+= book3s32/
diff --git a/arch/powerpc/mm/pageattr.c b/arch/powerpc/mm/pageattr.c
new file mode 100644
index 000000000000..41baf92f632b
--- /dev/null
+++ b/arch/powerpc/mm/pageattr.c
@@ -0,0 +1,85 @@
+// SPDX-License-Identifier: GPL-2.0+
+
+/*
+ * Page attribute and set_memory routines
+ *
+ * Derived from the arm64 implementation.
+ *
+ * Author: Russell Currey <ruscur@russell.cc>
+ *
+ * Copyright 2019, IBM Corporation.
+ *
+ */
+
+#include <linux/mm.h>
+#include <linux/set_memory.h>
+#include <linux/vmalloc.h>
+
+#include <asm/mmu.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+
+static int change_page_ro(pte_t *ptep, pgtable_t token, unsigned long addr, void *data)
+{
+	set_pte_at(&init_mm, addr, ptep, pte_wrprotect(READ_ONCE(*ptep)));
+	return 0;
+}
+
+static int change_page_rw(pte_t *ptep, pgtable_t token, unsigned long addr, void *data)
+{
+	set_pte_at(&init_mm, addr, ptep, pte_mkwrite(READ_ONCE(*ptep)));
+	return 0;
+}
+
+static int change_page_nx(pte_t *ptep, pgtable_t token, unsigned long addr, void *data)
+{
+	set_pte_at(&init_mm, addr, ptep, pte_exprotect(READ_ONCE(*ptep)));
+	return 0;
+}
+
+static int change_page_x(pte_t *ptep, pgtable_t token, unsigned long addr, void *data)
+{
+	set_pte_at(&init_mm, addr, ptep, pte_mkexec(READ_ONCE(*ptep)));
+	return 0;
+}
+
+int change_memory(unsigned long addr, int numpages, int action)
+{
+	unsigned long size = numpages * PAGE_SIZE;
+	unsigned long start = ALIGN_DOWN(addr, PAGE_SIZE);
+	unsigned long end = start + size;
+	struct vm_struct *area;
+	int ret;
+
+	if (!numpages)
+		return 0;
+
+	// only operate on VM areas for now
+	area = find_vm_area((void *)addr);
+	if (!area || end > (unsigned long)area->addr + area->size ||
+	    !(area->flags & VM_ALLOC) || (area->flags & VM_FLUSH_RESET_PERMS))
+		return -EINVAL;
+
+	// TODO: also apply change to the backing pages in the linear mapping
+
+	switch (action) {
+	case SET_MEMORY_RO:
+		ret = apply_to_page_range(&init_mm, start, size, change_page_ro, NULL);
+		break;
+	case SET_MEMORY_RW:
+		ret = apply_to_page_range(&init_mm, start, size, change_page_rw, NULL);
+		break;
+	case SET_MEMORY_NX:
+		ret = apply_to_page_range(&init_mm, start, size, change_page_nx, NULL);
+		break;
+	case SET_MEMORY_X:
+		ret = apply_to_page_range(&init_mm, start, size, change_page_x, NULL);
+		break;
+	default:
+		WARN_ON(true);
+		return -EINVAL;
+	}
+
+	flush_tlb_kernel_range(start, end);
+	return ret;
+}
-- 
2.22.0

