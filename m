Return-Path: <kernel-hardening-return-17375-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3D5D5FD87D
	for <lists+kernel-hardening@lfdr.de>; Fri, 15 Nov 2019 10:11:28 +0100 (CET)
Received: (qmail 20391 invoked by uid 550); 15 Nov 2019 09:11:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 20345 invoked from network); 15 Nov 2019 09:11:15 -0000
From: Jason Yan <yanaijie@huawei.com>
To: <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <oss@buserror.net>, Jason Yan
	<yanaijie@huawei.com>
Subject: [PATCH 0/6] implement KASLR for powerpc/fsl_booke/64
Date: Fri, 15 Nov 2019 17:32:03 +0800
Message-ID: <20191115093209.26434-1-yanaijie@huawei.com>
X-Mailer: git-send-email 2.17.2
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.124.28]
X-CFilter-Loop: Reflected

This is a try to implement KASLR for Freescale BookE64 which is based on
my earlier implementation for Freescale BookE32:
https://patchwork.ozlabs.org/project/linuxppc-dev/list/?series=131718

The implementation for Freescale BookE64 is similar as BookE32. One
difference is that Freescale BookE64 set up a TLB mapping of 1G during
booting. Another difference is that ppc64 needs the kernel to be
64K-aligned. So we can randomize the kernel in this 1G mapping and make
it 64K-aligned. This can save some code to creat another TLB map at
early boot. The disadvantage is that we only have about 1G/64K = 16384
slots to put the kernel in.

    KERNELBASE

          64K                     |--> kernel <--|
           |                      |              |
        +--+--+--+    +--+--+--+--+--+--+--+--+--+    +--+--+
        |  |  |  |....|  |  |  |  |  |  |  |  |  |....|  |  |
        +--+--+--+    +--+--+--+--+--+--+--+--+--+    +--+--+
        |                         |                        1G
        |----->   offset    <-----|

                              kernstart_virt_addr

I'm not sure if the slot numbers is enough or the design has any
defects. If you have some better ideas, I would be happy to hear that.

Thank you all.

Jason Yan (6):
  powerpc/fsl_booke/kaslr: refactor kaslr_legal_offset() and
    kaslr_early_init()
  powerpc/fsl_booke/64: introduce reloc_kernel_entry() helper
  powerpc/fsl_booke/64: implement KASLR for fsl_booke64
  powerpc/fsl_booke/64: do not clear the BSS for the second pass
  powerpc/fsl_booke/64: clear the original kernel if randomized
  powerpc/fsl_booke/kaslr: rename kaslr-booke32.rst to kaslr-booke.rst
    and add 64bit part

 .../{kaslr-booke32.rst => kaslr-booke.rst}    | 35 ++++++++--
 arch/powerpc/Kconfig                          |  2 +-
 arch/powerpc/kernel/exceptions-64e.S          | 13 ++++
 arch/powerpc/kernel/head_64.S                 |  7 ++
 arch/powerpc/kernel/setup_64.c                |  4 +-
 arch/powerpc/mm/mmu_decl.h                    |  3 +-
 arch/powerpc/mm/nohash/kaslr_booke.c          | 67 +++++++++++++------
 7 files changed, 104 insertions(+), 27 deletions(-)
 rename Documentation/powerpc/{kaslr-booke32.rst => kaslr-booke.rst} (59%)

-- 
2.17.2

