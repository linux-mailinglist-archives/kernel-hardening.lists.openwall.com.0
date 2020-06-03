Return-Path: <kernel-hardening-return-18908-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8E5C01EC8A4
	for <lists+kernel-hardening@lfdr.de>; Wed,  3 Jun 2020 07:17:59 +0200 (CEST)
Received: (qmail 28466 invoked by uid 550); 3 Jun 2020 05:17:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28428 invoked from network); 3 Jun 2020 05:17:49 -0000
From: "Christopher M. Riedl" <cmr@informatik.wtf>
To: linuxppc-dev@lists.ozlabs.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH 0/5] Use per-CPU temporary mappings for patching
Date: Wed,  3 Jun 2020 00:19:07 -0500
Message-Id: <20200603051912.23296-1-cmr@informatik.wtf>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP

When compiled with CONFIG_STRICT_KERNEL_RWX, the kernel must create
temporary mappings when patching itself. These mappings temporarily
override the strict RWX text protections to permit a write. Currently,
powerpc allocates a per-CPU VM area for patching. Patching occurs as
follows:

	1. Map page of text to be patched to per-CPU VM area w/
	   PAGE_KERNEL protection
	2. Patch text
	3. Remove the temporary mapping

While the VM area is per-CPU, the mapping is actually inserted into the
kernel page tables. Presumably, this could allow another CPU to access
the normally write-protected text - either malicously or accidentally -
via this same mapping if the address of the VM area is known. Ideally,
the mapping should be kept local to the CPU doing the patching (or any
other sensitive operations requiring temporarily overriding memory
protections) [0].

x86 introduced "temporary mm" structs which allow the creation of
mappings local to a particular CPU [1]. This series intends to bring the
notion of a temporary mm to powerpc and harden powerpc by using such a
mapping for patching a kernel with strict RWX permissions.

The first patch introduces the temporary mm struct and API for powerpc
along with a new function to retrieve a current hw breakpoint.

The second patch uses the `poking_init` init hook added by the x86
patches to initialize a temporary mm and patching address. The patching
address is randomized between 0 and DEFAULT_MAP_WINDOW-PAGE_SIZE. The
upper limit is necessary due to how the hash MMU operates - by default
the space above DEFAULT_MAP_WINDOW is not available. For now, both hash
and radix randomize inside this range. The number of possible random
addresses is dependent on PAGE_SIZE and limited by DEFAULT_MAP_WINDOW.

Bits of entropy with 64K page size on BOOK3S_64:

	bits of entropy = log2(DEFAULT_MAP_WINDOW_USER64 / PAGE_SIZE)

	PAGE_SIZE=64K, DEFAULT_MAP_WINDOW_USER64=128TB
	bits of entropy = log2(128TB / 64K)
	bits of entropy = 31

Randomization occurs only once during initialization at boot.

The third patch replaces the VM area with the temporary mm in the
patching code. The page for patching has to be mapped PAGE_SHARED with
the hash MMU since hash prevents the kernel from accessing userspace
pages with PAGE_PRIVILEGED bit set. On the radix MMU the page is mapped with
PAGE_KERNEL which has the added benefit that we can skip KUAP. 

The fourth and fifth patches implement an LKDTM test "proof-of-concept" which
exploits the previous vulnerability (ie. the mapping during patching is exposed
in kernel page tables and accessible by other CPUS). The LKDTM test is somewhat
"rough" in that it uses a brute-force approach - I am open to any suggestions
and/or ideas to improve this. Currently, the LKDTM test passes with this series
on POWER8 (hash) and POWER9 (radix, hash) and fails without this series (ie.
the temporary mapping for patching is exposed to CPUs other than the patching
CPU).

The test can be applied to a tree without this new series by first
adding this in /arch/powerpc/lib/code-patching.c:

 #ifdef CONFIG_STRICT_KERNEL_RWX
 static DEFINE_PER_CPU(struct vm_struct *, text_poke_area);

+#ifdef CONFIG_LKDTM
+unsigned long read_cpu_patching_addr(unsigned int cpu)
+{
+       return (unsigned long)(per_cpu(text_poke_area, cpu))->addr;
+}
+#endif
+
 static int text_area_cpu_up(unsigned int cpu)
 {
        struct vm_struct *area;

And then applying the last patch of this series which adds the LKDTM test,
(powerpc: Add LKDTM test to hijack a patch mapping).

Tested on QEMU (POWER8, POWER9), POWER8 VM, and a Blackbird (8-core POWER9).

v1:	* Rebase on linuxppc/next (4336b9337824)
	* Save and restore second hw watchpoint
	* Use new ppc_inst_* functions for patching check and in LKDTM
	  test

rfc-v2:	* Many fixes and improvements mostly based on extensive feedback and
          testing by Christophe Leroy (thanks!).
	* Make patching_mm and patching_addr static and mode '__ro_after_init'
	  to after the variable name (more common in other parts of the kernel)
	* Use 'asm/debug.h' header instead of 'asm/hw_breakpoint.h' to fix
	  PPC64e compile
	* Add comment explaining why we use BUG_ON() during the init call to
	  setup for patching later
	* Move ptep into patch_mapping to avoid walking page tables a second
	  time when unmapping the temporary mapping
	* Use KUAP under non-radix, also manually dirty the PTE for patch
	  mapping on non-BOOK3S_64 platforms
	* Properly return any error from __patch_instruction
	* Do not use 'memcmp' where a simple comparison is appropriate
	* Simplify expression for patch address by removing pointer maths
	* Add LKDTM test


[0]: https://github.com/linuxppc/issues/issues/224
[1]: https://lore.kernel.org/kernel-hardening/20190426232303.28381-1-nadav.amit@gmail.com/


Christopher M. Riedl (5):
  powerpc/mm: Introduce temporary mm
  powerpc/lib: Initialize a temporary mm for code patching
  powerpc/lib: Use a temporary mm for code patching
  powerpc/lib: Add LKDTM accessor for patching addr
  powerpc: Add LKDTM test to hijack a patch mapping

 arch/powerpc/include/asm/debug.h       |   1 +
 arch/powerpc/include/asm/mmu_context.h |  64 +++++++++
 arch/powerpc/kernel/process.c          |   5 +
 arch/powerpc/lib/code-patching.c       | 172 +++++++++++++------------
 drivers/misc/lkdtm/core.c              |   1 +
 drivers/misc/lkdtm/lkdtm.h             |   1 +
 drivers/misc/lkdtm/perms.c             | 101 +++++++++++++++
 7 files changed, 260 insertions(+), 85 deletions(-)

-- 
2.26.2

