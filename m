Return-Path: <kernel-hardening-return-18284-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9AF0A19725B
	for <lists+kernel-hardening@lfdr.de>; Mon, 30 Mar 2020 04:22:57 +0200 (CEST)
Received: (qmail 20028 invoked by uid 550); 30 Mar 2020 02:22:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19948 invoked from network); 30 Mar 2020 02:22:41 -0000
From: Jason Yan <yanaijie@huawei.com>
To: <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>,
	<oss@buserror.net>
CC: <linux-kernel@vger.kernel.org>, <zhaohongjiang@huawei.com>,
	<dja@axtens.net>, Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v5 1/6] powerpc/fsl_booke/kaslr: refactor kaslr_legal_offset() and kaslr_early_init()
Date: Mon, 30 Mar 2020 10:20:18 +0800
Message-ID: <20200330022023.3691-2-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200330022023.3691-1-yanaijie@huawei.com>
References: <20200330022023.3691-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected

Some code refactor in kaslr_legal_offset() and kaslr_early_init(). No
functional change. This is a preparation for KASLR fsl_booke64.

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
 arch/powerpc/mm/nohash/kaslr_booke.c | 34 +++++++++++++++-------------
 1 file changed, 18 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/mm/nohash/kaslr_booke.c b/arch/powerpc/mm/nohash/kaslr_booke.c
index 4a75f2d9bf0e..6ebff31fefcc 100644
--- a/arch/powerpc/mm/nohash/kaslr_booke.c
+++ b/arch/powerpc/mm/nohash/kaslr_booke.c
@@ -25,6 +25,7 @@ struct regions {
 	unsigned long pa_start;
 	unsigned long pa_end;
 	unsigned long kernel_size;
+	unsigned long linear_sz;
 	unsigned long dtb_start;
 	unsigned long dtb_end;
 	unsigned long initrd_start;
@@ -260,11 +261,23 @@ static __init void get_cell_sizes(const void *fdt, int node, int *addr_cells,
 		*size_cells = fdt32_to_cpu(*prop);
 }
 
-static unsigned long __init kaslr_legal_offset(void *dt_ptr, unsigned long index,
-					       unsigned long offset)
+static unsigned long __init kaslr_legal_offset(void *dt_ptr, unsigned long random)
 {
 	unsigned long koffset = 0;
 	unsigned long start;
+	unsigned long index;
+	unsigned long offset;
+
+	/*
+	 * Decide which 64M we want to start
+	 * Only use the low 8 bits of the random seed
+	 */
+	index = random & 0xFF;
+	index %= regions.linear_sz / SZ_64M;
+
+	/* Decide offset inside 64M */
+	offset = random % (SZ_64M - regions.kernel_size);
+	offset = round_down(offset, SZ_16K);
 
 	while ((long)index >= 0) {
 		offset = memstart_addr + index * SZ_64M + offset;
@@ -289,10 +302,9 @@ static inline __init bool kaslr_disabled(void)
 static unsigned long __init kaslr_choose_location(void *dt_ptr, phys_addr_t size,
 						  unsigned long kernel_sz)
 {
-	unsigned long offset, random;
+	unsigned long random;
 	unsigned long ram, linear_sz;
 	u64 seed;
-	unsigned long index;
 
 	kaslr_get_cmdline(dt_ptr);
 	if (kaslr_disabled())
@@ -333,22 +345,12 @@ static unsigned long __init kaslr_choose_location(void *dt_ptr, phys_addr_t size
 	regions.dtb_start = __pa(dt_ptr);
 	regions.dtb_end = __pa(dt_ptr) + fdt_totalsize(dt_ptr);
 	regions.kernel_size = kernel_sz;
+	regions.linear_sz = linear_sz;
 
 	get_initrd_range(dt_ptr);
 	get_crash_kernel(dt_ptr, ram);
 
-	/*
-	 * Decide which 64M we want to start
-	 * Only use the low 8 bits of the random seed
-	 */
-	index = random & 0xFF;
-	index %= linear_sz / SZ_64M;
-
-	/* Decide offset inside 64M */
-	offset = random % (SZ_64M - kernel_sz);
-	offset = round_down(offset, SZ_16K);
-
-	return kaslr_legal_offset(dt_ptr, index, offset);
+	return kaslr_legal_offset(dt_ptr, random);
 }
 
 /*
-- 
2.17.2

