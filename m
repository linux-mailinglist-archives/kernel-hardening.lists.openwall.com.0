Return-Path: <kernel-hardening-return-19263-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 07D0B219703
	for <lists+kernel-hardening@lfdr.de>; Thu,  9 Jul 2020 06:01:48 +0200 (CEST)
Received: (qmail 25831 invoked by uid 550); 9 Jul 2020 04:01:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25740 invoked from network); 9 Jul 2020 04:01:22 -0000
From: "Christopher M. Riedl" <cmr@informatik.wtf>
To: linuxppc-dev@lists.ozlabs.org
Cc: kernel-hardening@lists.openwall.com
Subject: [PATCH v2 2/5] powerpc/lib: Initialize a temporary mm for code patching
Date: Wed,  8 Jul 2020 23:03:13 -0500
Message-Id: <20200709040316.12789-3-cmr@informatik.wtf>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200709040316.12789-1-cmr@informatik.wtf>
References: <20200709040316.12789-1-cmr@informatik.wtf>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP

When code patching a STRICT_KERNEL_RWX kernel the page containing the
address to be patched is temporarily mapped with permissive memory
protections. Currently, a per-cpu vmalloc patch area is used for this
purpose. While the patch area is per-cpu, the temporary page mapping is
inserted into the kernel page tables for the duration of the patching.
The mapping is exposed to CPUs other than the patching CPU - this is
undesirable from a hardening perspective.

Use the `poking_init` init hook to prepare a temporary mm and patching
address. Initialize the temporary mm by copying the init mm. Choose a
randomized patching address inside the temporary mm userspace address
portion. The next patch uses the temporary mm and patching address for
code patching.

Based on x86 implementation:

commit 4fc19708b165
("x86/alternatives: Initialize temporary mm for patching")

Signed-off-by: Christopher M. Riedl <cmr@informatik.wtf>
---
 arch/powerpc/lib/code-patching.c | 33 ++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/powerpc/lib/code-patching.c b/arch/powerpc/lib/code-patching.c
index 0a051dfeb177..8ae1a9e5fe6e 100644
--- a/arch/powerpc/lib/code-patching.c
+++ b/arch/powerpc/lib/code-patching.c
@@ -11,6 +11,8 @@
 #include <linux/cpuhotplug.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <linux/sched/task.h>
+#include <linux/random.h>
 
 #include <asm/tlbflush.h>
 #include <asm/page.h>
@@ -44,6 +46,37 @@ int raw_patch_instruction(struct ppc_inst *addr, struct ppc_inst instr)
 }
 
 #ifdef CONFIG_STRICT_KERNEL_RWX
+
+static struct mm_struct *patching_mm __ro_after_init;
+static unsigned long patching_addr __ro_after_init;
+
+void __init poking_init(void)
+{
+	spinlock_t *ptl; /* for protecting pte table */
+	pte_t *ptep;
+
+	/*
+	 * Some parts of the kernel (static keys for example) depend on
+	 * successful code patching. Code patching under STRICT_KERNEL_RWX
+	 * requires this setup - otherwise we cannot patch at all. We use
+	 * BUG_ON() here and later since an early failure is preferred to
+	 * buggy behavior and/or strange crashes later.
+	 */
+	patching_mm = copy_init_mm();
+	BUG_ON(!patching_mm);
+
+	/*
+	 * In hash we cannot go above DEFAULT_MAP_WINDOW easily.
+	 * XXX: Do we want additional bits of entropy for radix?
+	 */
+	patching_addr = (get_random_long() & PAGE_MASK) %
+		(DEFAULT_MAP_WINDOW - PAGE_SIZE);
+
+	ptep = get_locked_pte(patching_mm, patching_addr, &ptl);
+	BUG_ON(!ptep);
+	pte_unmap_unlock(ptep, ptl);
+}
+
 static DEFINE_PER_CPU(struct vm_struct *, text_poke_area);
 
 static int text_area_cpu_up(unsigned int cpu)
-- 
2.27.0

