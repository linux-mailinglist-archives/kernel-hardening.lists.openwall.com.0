Return-Path: <kernel-hardening-return-18068-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C4720179E28
	for <lists+kernel-hardening@lfdr.de>; Thu,  5 Mar 2020 04:15:27 +0100 (CET)
Received: (qmail 31779 invoked by uid 550); 5 Mar 2020 03:15:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 31744 invoked from network); 5 Mar 2020 03:15:20 -0000
Subject: Re: [PATCH v3 4/6] powerpc/fsl_booke/64: do not clear the BSS for the
 second pass
To: Scott Wood <oss@buserror.net>, <mpe@ellerman.id.au>,
	<linuxppc-dev@lists.ozlabs.org>, <diana.craciun@nxp.com>,
	<christophe.leroy@c-s.fr>, <benh@kernel.crashing.org>, <paulus@samba.org>,
	<npiggin@gmail.com>, <keescook@chromium.org>,
	<kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <zhaohongjiang@huawei.com>
References: <20200206025825.22934-1-yanaijie@huawei.com>
 <20200206025825.22934-5-yanaijie@huawei.com>
 <feda5c76f134b415d2f43b99b8d6880b9b4b1750.camel@buserror.net>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <cc95e27e-fe40-9dfb-bed0-079ae38c1357@huawei.com>
Date: Thu, 5 Mar 2020 11:14:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <feda5c76f134b415d2f43b99b8d6880b9b4b1750.camel@buserror.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.221.195]
X-CFilter-Loop: Reflected



在 2020/3/5 5:49, Scott Wood 写道:
> On Thu, 2020-02-06 at 10:58 +0800, Jason Yan wrote:
>> The BSS section has already cleared out in the first pass. No need to
>> clear it again. This can save some time when booting with KASLR
>> enabled.
>>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> Cc: Scott Wood <oss@buserror.net>
>> Cc: Diana Craciun <diana.craciun@nxp.com>
>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Nicholas Piggin <npiggin@gmail.com>
>> Cc: Kees Cook <keescook@chromium.org>
>> ---
>>   arch/powerpc/kernel/head_64.S | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/arch/powerpc/kernel/head_64.S b/arch/powerpc/kernel/head_64.S
>> index 744624140fb8..8c644e7c3eaf 100644
>> --- a/arch/powerpc/kernel/head_64.S
>> +++ b/arch/powerpc/kernel/head_64.S
>> @@ -914,6 +914,13 @@ start_here_multiplatform:
>>   	bl      relative_toc
>>   	tovirt(r2,r2)
>>   
>> +	/* Do not clear the BSS for the second pass if randomized */
>> +	LOAD_REG_ADDR(r3, kernstart_virt_addr)
>> +	lwz     r3,0(r3)
>> +	LOAD_REG_IMMEDIATE(r4, KERNELBASE)
>> +	cmpw	r3,r4
>> +	bne	4f
> 
> These are 64-bit values.
> 

Oh yes, will fix. Thanks.

> -Scott
> 
> 
> 
> .
> 

