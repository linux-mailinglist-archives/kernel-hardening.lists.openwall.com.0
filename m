Return-Path: <kernel-hardening-return-18097-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0523C17B6F0
	for <lists+kernel-hardening@lfdr.de>; Fri,  6 Mar 2020 07:42:56 +0100 (CET)
Received: (qmail 24169 invoked by uid 550); 6 Mar 2020 06:42:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24043 invoked from network); 6 Mar 2020 06:42:15 -0000
From: Jason Yan <yanaijie@huawei.com>
To: <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>,
	<oss@buserror.net>
CC: <linux-kernel@vger.kernel.org>, <zhaohongjiang@huawei.com>,
	<dja@axtens.net>, Jason Yan <yanaijie@huawei.com>
Subject: [PATCH v4 6/6] powerpc/fsl_booke/kaslr: rename kaslr-booke32.rst to kaslr-booke.rst and add 64bit part
Date: Fri, 6 Mar 2020 14:40:33 +0800
Message-ID: <20200306064033.3398-7-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20200306064033.3398-1-yanaijie@huawei.com>
References: <20200306064033.3398-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected

Now we support both 32 and 64 bit KASLR for fsl booke. Add document for
64 bit part and rename kaslr-booke32.rst to kaslr-booke.rst.

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
 Documentation/powerpc/index.rst               |  2 +-
 .../{kaslr-booke32.rst => kaslr-booke.rst}    | 35 ++++++++++++++++---
 2 files changed, 32 insertions(+), 5 deletions(-)
 rename Documentation/powerpc/{kaslr-booke32.rst => kaslr-booke.rst} (59%)

diff --git a/Documentation/powerpc/index.rst b/Documentation/powerpc/index.rst
index 0d45f0fc8e57..3bad36943b22 100644
--- a/Documentation/powerpc/index.rst
+++ b/Documentation/powerpc/index.rst
@@ -20,7 +20,7 @@ powerpc
     hvcs
     imc
     isa-versions
-    kaslr-booke32
+    kaslr-booke
     mpc52xx
     papr_hcalls
     pci_iov_resource_on_powernv
diff --git a/Documentation/powerpc/kaslr-booke32.rst b/Documentation/powerpc/kaslr-booke.rst
similarity index 59%
rename from Documentation/powerpc/kaslr-booke32.rst
rename to Documentation/powerpc/kaslr-booke.rst
index 8b259fdfdf03..42121fed8249 100644
--- a/Documentation/powerpc/kaslr-booke32.rst
+++ b/Documentation/powerpc/kaslr-booke.rst
@@ -1,15 +1,18 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-===========================
-KASLR for Freescale BookE32
-===========================
+=========================
+KASLR for Freescale BookE
+=========================
 
 The word KASLR stands for Kernel Address Space Layout Randomization.
 
 This document tries to explain the implementation of the KASLR for
-Freescale BookE32. KASLR is a security feature that deters exploit
+Freescale BookE. KASLR is a security feature that deters exploit
 attempts relying on knowledge of the location of kernel internals.
 
+KASLR for Freescale BookE32
+-------------------------
+
 Since CONFIG_RELOCATABLE has already supported, what we need to do is
 map or copy kernel to a proper place and relocate. Freescale Book-E
 parts expect lowmem to be mapped by fixed TLB entries(TLB1). The TLB1
@@ -38,5 +41,29 @@ bit of the entropy to decide the index of the 64M zone. Then we chose a
 
                               kernstart_virt_addr
 
+
+KASLR for Freescale BookE64
+---------------------------
+
+The implementation for Freescale BookE64 is similar as BookE32. One
+difference is that Freescale BookE64 set up a TLB mapping of 1G during
+booting. Another difference is that ppc64 needs the kernel to be
+64K-aligned. So we can randomize the kernel in this 1G mapping and make
+it 64K-aligned. This can save some code to creat another TLB map at early
+boot. The disadvantage is that we only have about 1G/64K = 16384 slots to
+put the kernel in::
+
+    KERNELBASE
+
+          64K                     |--> kernel <--|
+           |                      |              |
+        +--+--+--+    +--+--+--+--+--+--+--+--+--+    +--+--+
+        |  |  |  |....|  |  |  |  |  |  |  |  |  |....|  |  |
+        +--+--+--+    +--+--+--+--+--+--+--+--+--+    +--+--+
+        |                         |                        1G
+        |----->   offset    <-----|
+
+                              kernstart_virt_addr
+
 To enable KASLR, set CONFIG_RANDOMIZE_BASE = y. If KASLR is enable and you
 want to disable it at runtime, add "nokaslr" to the kernel cmdline.
-- 
2.17.2

