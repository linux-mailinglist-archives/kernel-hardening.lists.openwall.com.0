Return-Path: <kernel-hardening-return-17852-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 754231655B7
	for <lists+kernel-hardening@lfdr.de>; Thu, 20 Feb 2020 04:33:42 +0100 (CET)
Received: (qmail 19525 invoked by uid 550); 20 Feb 2020 03:33:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19488 invoked from network); 20 Feb 2020 03:33:35 -0000
Subject: Re: [PATCH v3 0/6] implement KASLR for powerpc/fsl_booke/64
From: Jason Yan <yanaijie@huawei.com>
To: <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>,
	<oss@buserror.net>
CC: <linux-kernel@vger.kernel.org>, <zhaohongjiang@huawei.com>
References: <20200206025825.22934-1-yanaijie@huawei.com>
 <636f16fd-cc7b-ee2e-7496-c06bdc10c7af@huawei.com>
Message-ID: <c20b8e8b-5e70-4897-85c3-2d8d3c5454d7@huawei.com>
Date: Thu, 20 Feb 2020 11:33:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <636f16fd-cc7b-ee2e-7496-c06bdc10c7af@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.221.195]
X-CFilter-Loop: Reflected

ping...

on 2020/2/13 11:00, Jason Yan wrote:
> Hi everyone, any comments or suggestions?
> 
> Thanks,
> Jason
> 
> on 2020/2/6 10:58, Jason Yan wrote:
>> This is a try to implement KASLR for Freescale BookE64 which is based on
>> my earlier implementation for Freescale BookE32:
>> https://patchwork.ozlabs.org/project/linuxppc-dev/list/?series=131718
>>
>> The implementation for Freescale BookE64 is similar as BookE32. One
>> difference is that Freescale BookE64 set up a TLB mapping of 1G during
>> booting. Another difference is that ppc64 needs the kernel to be
>> 64K-aligned. So we can randomize the kernel in this 1G mapping and make
>> it 64K-aligned. This can save some code to creat another TLB map at
>> early boot. The disadvantage is that we only have about 1G/64K = 16384
>> slots to put the kernel in.
>>
>>      KERNELBASE
>>
>>            64K                     |--> kernel <--|
>>             |                      |              |
>>          +--+--+--+    +--+--+--+--+--+--+--+--+--+    +--+--+
>>          |  |  |  |....|  |  |  |  |  |  |  |  |  |....|  |  |
>>          +--+--+--+    +--+--+--+--+--+--+--+--+--+    +--+--+
>>          |                         |                        1G
>>          |----->   offset    <-----|
>>
>>                                kernstart_virt_addr
>>
>> I'm not sure if the slot numbers is enough or the design has any
>> defects. If you have some better ideas, I would be happy to hear that.
>>
>> Thank you all.
>>
>> v2->v3:
>>    Fix build error when KASLR is disabled.
>> v1->v2:
>>    Add __kaslr_offset for the secondary cpu boot up.
>>
>> Jason Yan (6):
>>    powerpc/fsl_booke/kaslr: refactor kaslr_legal_offset() and
>>      kaslr_early_init()
>>    powerpc/fsl_booke/64: introduce reloc_kernel_entry() helper
>>    powerpc/fsl_booke/64: implement KASLR for fsl_booke64
>>    powerpc/fsl_booke/64: do not clear the BSS for the second pass
>>    powerpc/fsl_booke/64: clear the original kernel if randomized
>>    powerpc/fsl_booke/kaslr: rename kaslr-booke32.rst to kaslr-booke.rst
>>      and add 64bit part
>>
>>   .../{kaslr-booke32.rst => kaslr-booke.rst}    | 35 +++++++--
>>   arch/powerpc/Kconfig                          |  2 +-
>>   arch/powerpc/kernel/exceptions-64e.S          | 23 ++++++
>>   arch/powerpc/kernel/head_64.S                 | 14 ++++
>>   arch/powerpc/kernel/setup_64.c                |  4 +-
>>   arch/powerpc/mm/mmu_decl.h                    | 19 ++---
>>   arch/powerpc/mm/nohash/kaslr_booke.c          | 71 +++++++++++++------
>>   7 files changed, 132 insertions(+), 36 deletions(-)
>>   rename Documentation/powerpc/{kaslr-booke32.rst => kaslr-booke.rst} 
>> (59%)
>>
> 
> 
> .

