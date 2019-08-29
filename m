Return-Path: <kernel-hardening-return-16814-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 034E5A0F4F
	for <lists+kernel-hardening@lfdr.de>; Thu, 29 Aug 2019 03:57:51 +0200 (CEST)
Received: (qmail 24165 invoked by uid 550); 29 Aug 2019 01:57:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24129 invoked from network); 29 Aug 2019 01:57:43 -0000
Subject: Re: [PATCH v6 00/12] implement KASLR for powerpc/fsl_booke/32
To: Scott Wood <oss@buserror.net>, <mpe@ellerman.id.au>,
	<linuxppc-dev@lists.ozlabs.org>, <diana.craciun@nxp.com>,
	<christophe.leroy@c-s.fr>, <benh@kernel.crashing.org>, <paulus@samba.org>,
	<npiggin@gmail.com>, <keescook@chromium.org>,
	<kernel-hardening@lists.openwall.com>
CC: <wangkefeng.wang@huawei.com>, <linux-kernel@vger.kernel.org>,
	<jingxiangfeng@huawei.com>, <zhaohongjiang@huawei.com>,
	<thunder.leizhen@huawei.com>, <fanchengyang@huawei.com>, <yebin10@huawei.com>
References: <20190809100800.5426-1-yanaijie@huawei.com>
 <a39b81562bcdeda7ffe0c2c29a60ff08c77047a6.camel@buserror.net>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <923983fc-364d-440d-5c3a-3d3d6de60d14@huawei.com>
Date: Thu, 29 Aug 2019 09:57:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <a39b81562bcdeda7ffe0c2c29a60ff08c77047a6.camel@buserror.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.203]
X-CFilter-Loop: Reflected



On 2019/8/28 12:05, Scott Wood wrote:
> On Fri, 2019-08-09 at 18:07 +0800, Jason Yan wrote:
>> This series implements KASLR for powerpc/fsl_booke/32, as a security
>> feature that deters exploit attempts relying on knowledge of the location
>> of kernel internals.
>>
>> Since CONFIG_RELOCATABLE has already supported, what we need to do is
>> map or copy kernel to a proper place and relocate.
> 
> Have you tested this with a kernel that was loaded at a non-zero address?  I
> tried loading a kernel at 0x04000000 (by changing the address in the uImage,
> and setting bootm_low to 04000000 in U-Boot), and it works without
> CONFIG_RANDOMIZE and fails with.
> 

Not yet. I will test this kind of cases in the next days. Thank you so
much. If there are any other corner cases that have to be tested, please
let me know.

>>   Freescale Book-E
>> parts expect lowmem to be mapped by fixed TLB entries(TLB1). The TLB1
>> entries are not suitable to map the kernel directly in a randomized
>> region, so we chose to copy the kernel to a proper place and restart to
>> relocate.
>>
>> Entropy is derived from the banner and timer base, which will change every
>> build and boot. This not so much safe so additionally the bootloader may
>> pass entropy via the /chosen/kaslr-seed node in device tree.
> 
> How complicated would it be to directly access the HW RNG (if present) that
> early in the boot?  It'd be nice if a U-Boot update weren't required (and
> particularly concerning that KASLR would appear to work without a U-Boot
> update, but without decent entropy).
> 
> -Scott
> 
> 
> 
> .
> 

