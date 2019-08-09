Return-Path: <kernel-hardening-return-16771-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B28F2876BB
	for <lists+kernel-hardening@lfdr.de>; Fri,  9 Aug 2019 11:54:09 +0200 (CEST)
Received: (qmail 13928 invoked by uid 550); 9 Aug 2019 09:52:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13645 invoked from network); 9 Aug 2019 09:52:20 -0000
From: Jason Yan <yanaijie@huawei.com>
To: <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<yebin10@huawei.com>, <thunder.leizhen@huawei.com>,
	<jingxiangfeng@huawei.com>, <fanchengyang@huawei.com>,
	<zhaohongjiang@huawei.com>, Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v6 12/12] powerpc/fsl_booke/32: Document KASLR implementation
Date: Fri, 9 Aug 2019 18:08:00 +0800
Message-ID: <20190809100800.5426-13-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190809100800.5426-1-yanaijie@huawei.com>
References: <20190809100800.5426-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected

Add document to explain how we implement KASLR for fsl_booke32.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
Cc: Diana Craciun <diana.craciun@nxp.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
---
 Documentation/powerpc/kaslr-booke32.rst | 42 +++++++++++++++++++++++++
 1 file changed, 42 insertions(+)
 create mode 100644 Documentation/powerpc/kaslr-booke32.rst

diff --git a/Documentation/powerpc/kaslr-booke32.rst b/Documentation/powerpc/kaslr-booke32.rst
new file mode 100644
index 000000000000..8b259fdfdf03
--- /dev/null
+++ b/Documentation/powerpc/kaslr-booke32.rst
@@ -0,0 +1,42 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+===========================
+KASLR for Freescale BookE32
+===========================
+
+The word KASLR stands for Kernel Address Space Layout Randomization.
+
+This document tries to explain the implementation of the KASLR for
+Freescale BookE32. KASLR is a security feature that deters exploit
+attempts relying on knowledge of the location of kernel internals.
+
+Since CONFIG_RELOCATABLE has already supported, what we need to do is
+map or copy kernel to a proper place and relocate. Freescale Book-E
+parts expect lowmem to be mapped by fixed TLB entries(TLB1). The TLB1
+entries are not suitable to map the kernel directly in a randomized
+region, so we chose to copy the kernel to a proper place and restart to
+relocate.
+
+Entropy is derived from the banner and timer base, which will change every
+build and boot. This not so much safe so additionally the bootloader may
+pass entropy via the /chosen/kaslr-seed node in device tree.
+
+We will use the first 512M of the low memory to randomize the kernel
+image. The memory will be split in 64M zones. We will use the lower 8
+bit of the entropy to decide the index of the 64M zone. Then we chose a
+16K aligned offset inside the 64M zone to put the kernel in::
+
+    KERNELBASE
+
+        |-->   64M   <--|
+        |               |
+        +---------------+    +----------------+---------------+
+        |               |....|    |kernel|    |               |
+        +---------------+    +----------------+---------------+
+        |                         |
+        |----->   offset    <-----|
+
+                              kernstart_virt_addr
+
+To enable KASLR, set CONFIG_RANDOMIZE_BASE = y. If KASLR is enable and you
+want to disable it at runtime, add "nokaslr" to the kernel cmdline.
-- 
2.17.2

