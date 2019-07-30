Return-Path: <kernel-hardening-return-16625-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A8B7A7A234
	for <lists+kernel-hardening@lfdr.de>; Tue, 30 Jul 2019 09:26:30 +0200 (CEST)
Received: (qmail 16008 invoked by uid 550); 30 Jul 2019 07:25:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15731 invoked from network); 30 Jul 2019 07:25:47 -0000
From: Jason Yan <yanaijie@huawei.com>
To: <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<yebin10@huawei.com>, <thunder.leizhen@huawei.com>,
	<jingxiangfeng@huawei.com>, <fanchengyang@huawei.com>,
	<zhaohongjiang@huawei.com>, Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v2 02/10] powerpc: move memstart_addr and kernstart_addr to init-common.c
Date: Tue, 30 Jul 2019 15:42:17 +0800
Message-ID: <20190730074225.39544-3-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190730074225.39544-1-yanaijie@huawei.com>
References: <20190730074225.39544-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected

These two variables are both defined in init_32.c and init_64.c. Move
them to init-common.c.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
Cc: Diana Craciun <diana.craciun@nxp.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
---
 arch/powerpc/mm/init-common.c | 5 +++++
 arch/powerpc/mm/init_32.c     | 5 -----
 arch/powerpc/mm/init_64.c     | 5 -----
 3 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/mm/init-common.c b/arch/powerpc/mm/init-common.c
index a84da92920f7..152ae0d21435 100644
--- a/arch/powerpc/mm/init-common.c
+++ b/arch/powerpc/mm/init-common.c
@@ -21,6 +21,11 @@
 #include <asm/pgtable.h>
 #include <asm/kup.h>
 
+phys_addr_t memstart_addr = (phys_addr_t)~0ull;
+EXPORT_SYMBOL_GPL(memstart_addr);
+phys_addr_t kernstart_addr;
+EXPORT_SYMBOL_GPL(kernstart_addr);
+
 static bool disable_kuep = !IS_ENABLED(CONFIG_PPC_KUEP);
 static bool disable_kuap = !IS_ENABLED(CONFIG_PPC_KUAP);
 
diff --git a/arch/powerpc/mm/init_32.c b/arch/powerpc/mm/init_32.c
index b04896a88d79..872df48ae41b 100644
--- a/arch/powerpc/mm/init_32.c
+++ b/arch/powerpc/mm/init_32.c
@@ -56,11 +56,6 @@
 phys_addr_t total_memory;
 phys_addr_t total_lowmem;
 
-phys_addr_t memstart_addr = (phys_addr_t)~0ull;
-EXPORT_SYMBOL(memstart_addr);
-phys_addr_t kernstart_addr;
-EXPORT_SYMBOL(kernstart_addr);
-
 #ifdef CONFIG_RELOCATABLE
 /* Used in __va()/__pa() */
 long long virt_phys_offset;
diff --git a/arch/powerpc/mm/init_64.c b/arch/powerpc/mm/init_64.c
index a44f6281ca3a..c836f1269ee7 100644
--- a/arch/powerpc/mm/init_64.c
+++ b/arch/powerpc/mm/init_64.c
@@ -63,11 +63,6 @@
 
 #include <mm/mmu_decl.h>
 
-phys_addr_t memstart_addr = ~0;
-EXPORT_SYMBOL_GPL(memstart_addr);
-phys_addr_t kernstart_addr;
-EXPORT_SYMBOL_GPL(kernstart_addr);
-
 #ifdef CONFIG_SPARSEMEM_VMEMMAP
 /*
  * Given an address within the vmemmap, determine the pfn of the page that
-- 
2.17.2

