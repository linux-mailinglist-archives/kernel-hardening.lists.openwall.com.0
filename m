Return-Path: <kernel-hardening-return-16698-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 1A376811B8
	for <lists+kernel-hardening@lfdr.de>; Mon,  5 Aug 2019 07:40:57 +0200 (CEST)
Received: (qmail 17704 invoked by uid 550); 5 Aug 2019 05:40:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17672 invoked from network); 5 Aug 2019 05:40:49 -0000
Subject: Re: [PATCH v3 06/10] powerpc/fsl_booke/32: implement KASLR
 infrastructure
To: Diana Madalina Craciun <diana.craciun@nxp.com>, "mpe@ellerman.id.au"
	<mpe@ellerman.id.au>, "linuxppc-dev@lists.ozlabs.org"
	<linuxppc-dev@lists.ozlabs.org>, "christophe.leroy@c-s.fr"
	<christophe.leroy@c-s.fr>, "benh@kernel.crashing.org"
	<benh@kernel.crashing.org>, "paulus@samba.org" <paulus@samba.org>,
	"npiggin@gmail.com" <npiggin@gmail.com>, "keescook@chromium.org"
	<keescook@chromium.org>, "kernel-hardening@lists.openwall.com"
	<kernel-hardening@lists.openwall.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"wangkefeng.wang@huawei.com" <wangkefeng.wang@huawei.com>,
	"yebin10@huawei.com" <yebin10@huawei.com>, "thunder.leizhen@huawei.com"
	<thunder.leizhen@huawei.com>, "jingxiangfeng@huawei.com"
	<jingxiangfeng@huawei.com>, "fanchengyang@huawei.com"
	<fanchengyang@huawei.com>, "zhaohongjiang@huawei.com"
	<zhaohongjiang@huawei.com>
References: <20190731094318.26538-1-yanaijie@huawei.com>
 <20190731094318.26538-7-yanaijie@huawei.com>
 <VI1PR0401MB24637B79618C29684168D831FFD90@VI1PR0401MB2463.eurprd04.prod.outlook.com>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <356a9697-8208-3a63-8358-77422be482b2@huawei.com>
Date: Mon, 5 Aug 2019 13:40:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <VI1PR0401MB24637B79618C29684168D831FFD90@VI1PR0401MB2463.eurprd04.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.203]
X-CFilter-Loop: Reflected

Hi Diana,

On 2019/8/2 16:41, Diana Madalina Craciun wrote:
>> diff --git a/arch/powerpc/kernel/fsl_booke_entry_mapping.S b/arch/powerpc/kernel/fsl_booke_entry_mapping.S
>> index de0980945510..6d2967673ac7 100644
>> --- a/arch/powerpc/kernel/fsl_booke_entry_mapping.S
>> +++ b/arch/powerpc/kernel/fsl_booke_entry_mapping.S
>> @@ -161,17 +161,16 @@ skpinv:	addi	r6,r6,1				/* Increment */
>>   	lis	r6,(MAS1_VALID|MAS1_IPROT)@h
>>   	ori	r6,r6,(MAS1_TSIZE(BOOK3E_PAGESZ_64M))@l
>>   	mtspr	SPRN_MAS1,r6
>> -	lis	r6,MAS2_VAL(PAGE_OFFSET, BOOK3E_PAGESZ_64M, M_IF_NEEDED)@h
>> -	ori	r6,r6,MAS2_VAL(PAGE_OFFSET, BOOK3E_PAGESZ_64M, M_IF_NEEDED)@l
>> -	mtspr	SPRN_MAS2,r6
>> +	lis     r6,MAS2_EPN_MASK(BOOK3E_PAGESZ_64M)@h
>> +	ori     r6,r6,MAS2_EPN_MASK(BOOK3E_PAGESZ_64M)@l
>> +	and     r6,r6,r20
>> +	ori	r6,r6,M_IF_NEEDED@l
>> +	mtspr   SPRN_MAS2,r6
>>   	mtspr	SPRN_MAS3,r8
>>   	tlbwe
>>   
>>   /* 7. Jump to KERNELBASE mapping */
> The code has changed, but the comment reflects the old code (it no
> longer jumps to KERNELBASE, but to kimage_vaddr). This is true for step
> 6 as well.
> 

Good catch, I will update the comment.

Thanks,
Jason

