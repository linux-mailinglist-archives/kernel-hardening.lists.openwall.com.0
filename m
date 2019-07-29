Return-Path: <kernel-hardening-return-16611-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A858078CF3
	for <lists+kernel-hardening@lfdr.de>; Mon, 29 Jul 2019 15:35:53 +0200 (CEST)
Received: (qmail 15536 invoked by uid 550); 29 Jul 2019 13:35:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15497 invoked from network); 29 Jul 2019 13:35:47 -0000
Subject: Re: [RFC PATCH 05/10] powerpc/fsl_booke/32: introduce
 reloc_kernel_entry() helper
To: Christophe Leroy <christophe.leroy@c-s.fr>, <mpe@ellerman.id.au>,
	<linuxppc-dev@lists.ozlabs.org>, <diana.craciun@nxp.com>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<yebin10@huawei.com>, <thunder.leizhen@huawei.com>,
	<jingxiangfeng@huawei.com>, <fanchengyang@huawei.com>
References: <20190717080621.40424-1-yanaijie@huawei.com>
 <20190717080621.40424-6-yanaijie@huawei.com>
 <e4ccd015-a9c4-b0a6-e3ca-d37a04e29ec6@c-s.fr>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <60238fe3-a6ec-3537-d56d-29ebeb38f5fd@huawei.com>
Date: Mon, 29 Jul 2019 21:35:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <e4ccd015-a9c4-b0a6-e3ca-d37a04e29ec6@c-s.fr>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.177.96.203]
X-CFilter-Loop: Reflected


On 2019/7/29 19:08, Christophe Leroy wrote:
> 
> 
> Le 17/07/2019 à 10:06, Jason Yan a écrit :
>> Add a new helper reloc_kernel_entry() to jump back to the start of the
>> new kernel. After we put the new kernel in a randomized place we can use
>> this new helper to enter the kernel and begin to relocate again.
>>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> Cc: Diana Craciun <diana.craciun@nxp.com>
>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Nicholas Piggin <npiggin@gmail.com>
>> Cc: Kees Cook <keescook@chromium.org>
>> ---
>>   arch/powerpc/kernel/head_fsl_booke.S | 16 ++++++++++++++++
>>   arch/powerpc/mm/mmu_decl.h           |  1 +
>>   2 files changed, 17 insertions(+)
>>
>> diff --git a/arch/powerpc/kernel/head_fsl_booke.S 
>> b/arch/powerpc/kernel/head_fsl_booke.S
>> index a57d44638031..ce40f96dae20 100644
>> --- a/arch/powerpc/kernel/head_fsl_booke.S
>> +++ b/arch/powerpc/kernel/head_fsl_booke.S
>> @@ -1144,6 +1144,22 @@ _GLOBAL(create_tlb_entry)
>>       sync
>>       blr
>> +/*
>> + * Return to the start of the relocated kernel and run again
>> + * r3 - virtual address of fdt
>> + * r4 - entry of the kernel
>> + */
>> +_GLOBAL(reloc_kernel_entry)
>> +    mfmsr    r7
>> +    li    r8,(MSR_IS | MSR_DS)
>> +    andc    r7,r7,r8
> 
> Instead of the li/andc, what about the following:
> 
> rlwinm r7, r7, 0, ~(MSR_IS | MSR_DS)
> 

Good idea.

>> +
>> +    mtspr    SPRN_SRR0,r4
>> +    mtspr    SPRN_SRR1,r7
>> +    isync
>> +    sync
>> +    rfi
> 
> Are the isync/sync really necessary ? AFAIK, rfi is context synchronising.
> 

I see some code with sync before rfi so I'm not sure. I will check this
and drop the isync/sync if it's true.

Thanks.

>> +
>>   /*
>>    * Create a tlb entry with the same effective and physical address as
>>    * the tlb entry used by the current running code. But set the TS to 1.
>> diff --git a/arch/powerpc/mm/mmu_decl.h b/arch/powerpc/mm/mmu_decl.h
>> index d7737cf97cee..dae8e9177574 100644
>> --- a/arch/powerpc/mm/mmu_decl.h
>> +++ b/arch/powerpc/mm/mmu_decl.h
>> @@ -143,6 +143,7 @@ extern void adjust_total_lowmem(void);
>>   extern int switch_to_as1(void);
>>   extern void restore_to_as0(int esel, int offset, void *dt_ptr, int 
>> bootcpu);
>>   extern void create_tlb_entry(phys_addr_t phys, unsigned long virt, 
>> int entry);
>> +extern void reloc_kernel_entry(void *fdt, int addr);
> 
> No new 'extern' please, see 
> https://openpower.xyz/job/snowpatch/job/snowpatch-linux-checkpatch/8125//artifact/linux/checkpatch.log 
> 
> 
> 
>>   #endif
>>   extern void loadcam_entry(unsigned int index);
>>   extern void loadcam_multi(int first_idx, int num, int tmp_idx);
>>
> 
> Christophe
> 
> .
> 

