Return-Path: <kernel-hardening-return-16899-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 091D4B8DB1
	for <lists+kernel-hardening@lfdr.de>; Fri, 20 Sep 2019 11:26:58 +0200 (CEST)
Received: (qmail 32167 invoked by uid 550); 20 Sep 2019 09:25:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 31981 invoked from network); 20 Sep 2019 09:25:42 -0000
From: Jason Yan <yanaijie@huawei.com>
To: <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<yebin10@huawei.com>, <thunder.leizhen@huawei.com>,
	<jingxiangfeng@huawei.com>, <zhaohongjiang@huawei.com>, <oss@buserror.net>,
	Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v7 07/12] powerpc/fsl_booke/32: randomize the kernel image offset
Date: Fri, 20 Sep 2019 17:45:41 +0800
Message-ID: <20190920094546.44948-8-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190920094546.44948-1-yanaijie@huawei.com>
References: <20190920094546.44948-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected

After we have the basic support of relocate the kernel in some
appropriate place, we can start to randomize the offset now.

Entropy is derived from the banner and timer, which will change every
build and boot. This not so much safe so additionally the bootloader may
pass entropy via the /chosen/kaslr-seed node in device tree.

We will use the first 512M of the low memory to randomize the kernel
image. The memory will be split in 64M zones. We will use the lower 8
bit of the entropy to decide the index of the 64M zone. Then we chose a
16K aligned offset inside the 64M zone to put the kernel in.

We also check if we will overlap with some areas like the dtb area, the
initrd area or the crashkernel area. If we cannot find a proper area,
kaslr will be disabled and boot from the original kernel.

Some pieces of code are derived from arch/x86/boot/compressed/kaslr.c or
arch/arm64/kernel/kaslr.c such as rotate_xor(). Credit goes to Kees and
Ard.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
Cc: Diana Craciun <diana.craciun@nxp.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Reviewed-by: Diana Craciun <diana.craciun@nxp.com>
Tested-by: Diana Craciun <diana.craciun@nxp.com>
Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
---
 arch/powerpc/mm/nohash/kaslr_booke.c | 325 ++++++++++++++++++++++++++-
 1 file changed, 323 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/mm/nohash/kaslr_booke.c b/arch/powerpc/mm/nohash/kaslr_booke.c
index 29c1567d8d40..7b238fc2c8a9 100644
--- a/arch/powerpc/mm/nohash/kaslr_booke.c
+++ b/arch/powerpc/mm/nohash/kaslr_booke.c
@@ -12,15 +12,336 @@
 #include <linux/init.h>
 #include <linux/delay.h>
 #include <linux/memblock.h>
+#include <linux/libfdt.h>
+#include <linux/crash_core.h>
 #include <asm/pgalloc.h>
 #include <asm/prom.h>
+#include <asm/kdump.h>
 #include <mm/mmu_decl.h>
+#include <generated/compile.h>
+#include <generated/utsrelease.h>
+
+struct regions {
+	unsigned long pa_start;
+	unsigned long pa_end;
+	unsigned long kernel_size;
+	unsigned long dtb_start;
+	unsigned long dtb_end;
+	unsigned long initrd_start;
+	unsigned long initrd_end;
+	unsigned long crash_start;
+	unsigned long crash_end;
+	int reserved_mem;
+	int reserved_mem_addr_cells;
+	int reserved_mem_size_cells;
+};
+
+/* Simplified build-specific string for starting entropy. */
+static const char build_str[] = UTS_RELEASE " (" LINUX_COMPILE_BY "@"
+		LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION;
+
+struct regions __initdata regions;
+
+static __init void kaslr_get_cmdline(void *fdt)
+{
+	int node = fdt_path_offset(fdt, "/chosen");
+
+	early_init_dt_scan_chosen(node, "chosen", 1, boot_command_line);
+}
+
+static unsigned long __init rotate_xor(unsigned long hash, const void *area,
+				       size_t size)
+{
+	size_t i;
+	const unsigned long *ptr = area;
+
+	for (i = 0; i < size / sizeof(hash); i++) {
+		/* Rotate by odd number of bits and XOR. */
+		hash = (hash << ((sizeof(hash) * 8) - 7)) | (hash >> 7);
+		hash ^= ptr[i];
+	}
+
+	return hash;
+}
+
+/* Attempt to create a simple starting entropy. This can make it defferent for
+ * every build but it is still not enough. Stronger entropy should
+ * be added to make it change for every boot.
+ */
+static unsigned long __init get_boot_seed(void *fdt)
+{
+	unsigned long hash = 0;
+
+	hash = rotate_xor(hash, build_str, sizeof(build_str));
+	hash = rotate_xor(hash, fdt, fdt_totalsize(fdt));
+
+	return hash;
+}
+
+static __init u64 get_kaslr_seed(void *fdt)
+{
+	int node, len;
+	fdt64_t *prop;
+	u64 ret;
+
+	node = fdt_path_offset(fdt, "/chosen");
+	if (node < 0)
+		return 0;
+
+	prop = fdt_getprop_w(fdt, node, "kaslr-seed", &len);
+	if (!prop || len != sizeof(u64))
+		return 0;
+
+	ret = fdt64_to_cpu(*prop);
+	*prop = 0;
+	return ret;
+}
+
+static __init bool regions_overlap(u32 s1, u32 e1, u32 s2, u32 e2)
+{
+	return e1 >= s2 && e2 >= s1;
+}
+
+static __init bool overlaps_reserved_region(const void *fdt, u32 start,
+					    u32 end)
+{
+	int subnode, len, i;
+	u64 base, size;
+
+	/* check for overlap with /memreserve/ entries */
+	for (i = 0; i < fdt_num_mem_rsv(fdt); i++) {
+		if (fdt_get_mem_rsv(fdt, i, &base, &size) < 0)
+			continue;
+		if (regions_overlap(start, end, base, base + size))
+			return true;
+	}
+
+	if (regions.reserved_mem < 0)
+		return false;
+
+	/* check for overlap with static reservations in /reserved-memory */
+	for (subnode = fdt_first_subnode(fdt, regions.reserved_mem);
+	     subnode >= 0;
+	     subnode = fdt_next_subnode(fdt, subnode)) {
+		const fdt32_t *reg;
+		u64 rsv_end;
+
+		len = 0;
+		reg = fdt_getprop(fdt, subnode, "reg", &len);
+		while (len >= (regions.reserved_mem_addr_cells +
+			       regions.reserved_mem_size_cells)) {
+			base = fdt32_to_cpu(reg[0]);
+			if (regions.reserved_mem_addr_cells == 2)
+				base = (base << 32) | fdt32_to_cpu(reg[1]);
+
+			reg += regions.reserved_mem_addr_cells;
+			len -= 4 * regions.reserved_mem_addr_cells;
+
+			size = fdt32_to_cpu(reg[0]);
+			if (regions.reserved_mem_size_cells == 2)
+				size = (size << 32) | fdt32_to_cpu(reg[1]);
+
+			reg += regions.reserved_mem_size_cells;
+			len -= 4 * regions.reserved_mem_size_cells;
+
+			if (base >= regions.pa_end)
+				continue;
+
+			rsv_end = min(base + size, (u64)U32_MAX);
+
+			if (regions_overlap(start, end, base, rsv_end))
+				return true;
+		}
+	}
+	return false;
+}
+
+static __init bool overlaps_region(const void *fdt, u32 start,
+				   u32 end)
+{
+	if (regions_overlap(start, end, __pa(_stext), __pa(_end)))
+		return true;
+
+	if (regions_overlap(start, end, regions.dtb_start,
+			    regions.dtb_end))
+		return true;
+
+	if (regions_overlap(start, end, regions.initrd_start,
+			    regions.initrd_end))
+		return true;
+
+	if (regions_overlap(start, end, regions.crash_start,
+			    regions.crash_end))
+		return true;
+
+	return overlaps_reserved_region(fdt, start, end);
+}
+
+static void __init get_crash_kernel(void *fdt, unsigned long size)
+{
+#ifdef CONFIG_CRASH_CORE
+	unsigned long long crash_size, crash_base;
+	int ret;
+
+	ret = parse_crashkernel(boot_command_line, size, &crash_size,
+				&crash_base);
+	if (ret != 0 || crash_size == 0)
+		return;
+	if (crash_base == 0)
+		crash_base = KDUMP_KERNELBASE;
+
+	regions.crash_start = (unsigned long)crash_base;
+	regions.crash_end = (unsigned long)(crash_base + crash_size);
+
+	pr_debug("crash_base=0x%llx crash_size=0x%llx\n", crash_base, crash_size);
+#endif
+}
+
+static void __init get_initrd_range(void *fdt)
+{
+	u64 start, end;
+	int node, len;
+	const __be32 *prop;
+
+	node = fdt_path_offset(fdt, "/chosen");
+	if (node < 0)
+		return;
+
+	prop = fdt_getprop(fdt, node, "linux,initrd-start", &len);
+	if (!prop)
+		return;
+	start = of_read_number(prop, len / 4);
+
+	prop = fdt_getprop(fdt, node, "linux,initrd-end", &len);
+	if (!prop)
+		return;
+	end = of_read_number(prop, len / 4);
+
+	regions.initrd_start = (unsigned long)start;
+	regions.initrd_end = (unsigned long)end;
+
+	pr_debug("initrd_start=0x%llx  initrd_end=0x%llx\n", start, end);
+}
+
+static __init unsigned long get_usable_address(const void *fdt,
+					       unsigned long start,
+					       unsigned long offset)
+{
+	unsigned long pa;
+	unsigned long pa_end;
+
+	for (pa = offset; (long)pa > (long)start; pa -= SZ_16K) {
+		pa_end = pa + regions.kernel_size;
+		if (overlaps_region(fdt, pa, pa_end))
+			continue;
+
+		return pa;
+	}
+	return 0;
+}
+
+static __init void get_cell_sizes(const void *fdt, int node, int *addr_cells,
+				  int *size_cells)
+{
+	const int *prop;
+	int len;
+
+	/*
+	 * Retrieve the #address-cells and #size-cells properties
+	 * from the 'node', or use the default if not provided.
+	 */
+	*addr_cells = *size_cells = 1;
+
+	prop = fdt_getprop(fdt, node, "#address-cells", &len);
+	if (len == 4)
+		*addr_cells = fdt32_to_cpu(*prop);
+	prop = fdt_getprop(fdt, node, "#size-cells", &len);
+	if (len == 4)
+		*size_cells = fdt32_to_cpu(*prop);
+}
+
+static unsigned long __init kaslr_legal_offset(void *dt_ptr, unsigned long index,
+					       unsigned long offset)
+{
+	unsigned long koffset = 0;
+	unsigned long start;
+
+	while ((long)index >= 0) {
+		offset = memstart_addr + index * SZ_64M + offset;
+		start = memstart_addr + index * SZ_64M;
+		koffset = get_usable_address(dt_ptr, start, offset);
+		if (koffset)
+			break;
+		index--;
+	}
+
+	if (koffset != 0)
+		koffset -= memstart_addr;
+
+	return koffset;
+}
 
 static unsigned long __init kaslr_choose_location(void *dt_ptr, phys_addr_t size,
 						  unsigned long kernel_sz)
 {
-	/* return a fixed offset of 64M for now */
-	return SZ_64M;
+	unsigned long offset, random;
+	unsigned long ram, linear_sz;
+	u64 seed;
+	unsigned long index;
+
+	kaslr_get_cmdline(dt_ptr);
+
+	random = get_boot_seed(dt_ptr);
+
+	seed = get_tb() << 32;
+	seed ^= get_tb();
+	random = rotate_xor(random, &seed, sizeof(seed));
+
+	/*
+	 * Retrieve (and wipe) the seed from the FDT
+	 */
+	seed = get_kaslr_seed(dt_ptr);
+	if (seed)
+		random = rotate_xor(random, &seed, sizeof(seed));
+	else
+		pr_warn("KASLR: No safe seed for randomizing the kernel base.\n");
+
+	ram = min_t(phys_addr_t, __max_low_memory, size);
+	ram = map_mem_in_cams(ram, CONFIG_LOWMEM_CAM_NUM, true);
+	linear_sz = min_t(unsigned long, ram, SZ_512M);
+
+	/* If the linear size is smaller than 64M, do not randmize */
+	if (linear_sz < SZ_64M)
+		return 0;
+
+	/* check for a reserved-memory node and record its cell sizes */
+	regions.reserved_mem = fdt_path_offset(dt_ptr, "/reserved-memory");
+	if (regions.reserved_mem >= 0)
+		get_cell_sizes(dt_ptr, regions.reserved_mem,
+			       &regions.reserved_mem_addr_cells,
+			       &regions.reserved_mem_size_cells);
+
+	regions.pa_start = memstart_addr;
+	regions.pa_end = memstart_addr + linear_sz;
+	regions.dtb_start = __pa(dt_ptr);
+	regions.dtb_end = __pa(dt_ptr) + fdt_totalsize(dt_ptr);
+	regions.kernel_size = kernel_sz;
+
+	get_initrd_range(dt_ptr);
+	get_crash_kernel(dt_ptr, ram);
+
+	/*
+	 * Decide which 64M we want to start
+	 * Only use the low 8 bits of the random seed
+	 */
+	index = random & 0xFF;
+	index %= linear_sz / SZ_64M;
+
+	/* Decide offset inside 64M */
+	offset = random % (SZ_64M - kernel_sz);
+	offset = round_down(offset, SZ_16K);
+
+	return kaslr_legal_offset(dt_ptr, index, offset);
 }
 
 /*
-- 
2.17.2

