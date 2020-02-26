Return-Path: <kernel-hardening-return-17924-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id ABD1C16F580
	for <lists+kernel-hardening@lfdr.de>; Wed, 26 Feb 2020 03:11:48 +0100 (CET)
Received: (qmail 5935 invoked by uid 550); 26 Feb 2020 02:11:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5897 invoked from network); 26 Feb 2020 02:11:41 -0000
Subject: Re: [PATCH v3 1/6] powerpc/fsl_booke/kaslr: refactor
 kaslr_legal_offset() and kaslr_early_init()
To: Christophe Leroy <christophe.leroy@c-s.fr>, <mpe@ellerman.id.au>,
	<linuxppc-dev@lists.ozlabs.org>, <diana.craciun@nxp.com>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>,
	<oss@buserror.net>
CC: <linux-kernel@vger.kernel.org>, <zhaohongjiang@huawei.com>
References: <20200206025825.22934-1-yanaijie@huawei.com>
 <20200206025825.22934-2-yanaijie@huawei.com>
 <6c0b0720-6998-f43a-a2b6-0632d4df1126@c-s.fr>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <f80cce40-804e-12a3-7429-74923a3cb7f7@huawei.com>
Date: Wed, 26 Feb 2020 10:11:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <6c0b0720-6998-f43a-a2b6-0632d4df1126@c-s.fr>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.221.195]
X-CFilter-Loop: Reflected



在 2020/2/20 21:40, Christophe Leroy 写道:
> 
> 
> Le 06/02/2020 à 03:58, Jason Yan a écrit :
>> Some code refactor in kaslr_legal_offset() and kaslr_early_init(). No
>> functional change. This is a preparation for KASLR fsl_booke64.
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
>>   arch/powerpc/mm/nohash/kaslr_booke.c | 40 ++++++++++++++--------------
>>   1 file changed, 20 insertions(+), 20 deletions(-)
>>
>> diff --git a/arch/powerpc/mm/nohash/kaslr_booke.c 
>> b/arch/powerpc/mm/nohash/kaslr_booke.c
>> index 4a75f2d9bf0e..07b036e98353 100644
>> --- a/arch/powerpc/mm/nohash/kaslr_booke.c
>> +++ b/arch/powerpc/mm/nohash/kaslr_booke.c
>> @@ -25,6 +25,7 @@ struct regions {
>>       unsigned long pa_start;
>>       unsigned long pa_end;
>>       unsigned long kernel_size;
>> +    unsigned long linear_sz;
>>       unsigned long dtb_start;
>>       unsigned long dtb_end;
>>       unsigned long initrd_start;
>> @@ -260,11 +261,23 @@ static __init void get_cell_sizes(const void 
>> *fdt, int node, int *addr_cells,
>>           *size_cells = fdt32_to_cpu(*prop);
>>   }
>> -static unsigned long __init kaslr_legal_offset(void *dt_ptr, unsigned 
>> long index,
>> -                           unsigned long offset)
>> +static unsigned long __init kaslr_legal_offset(void *dt_ptr, unsigned 
>> long random)
>>   {
>>       unsigned long koffset = 0;
>>       unsigned long start;
>> +    unsigned long index;
>> +    unsigned long offset;
>> +
>> +    /*
>> +     * Decide which 64M we want to start
>> +     * Only use the low 8 bits of the random seed
>> +     */
>> +    index = random & 0xFF;
>> +    index %= regions.linear_sz / SZ_64M;
>> +
>> +    /* Decide offset inside 64M */
>> +    offset = random % (SZ_64M - regions.kernel_size);
>> +    offset = round_down(offset, SZ_16K);
>>       while ((long)index >= 0) {
>>           offset = memstart_addr + index * SZ_64M + offset;
>> @@ -289,10 +302,9 @@ static inline __init bool kaslr_disabled(void)
>>   static unsigned long __init kaslr_choose_location(void *dt_ptr, 
>> phys_addr_t size,
>>                             unsigned long kernel_sz)
>>   {
>> -    unsigned long offset, random;
>> +    unsigned long random;
>>       unsigned long ram, linear_sz;
>>       u64 seed;
>> -    unsigned long index;
>>       kaslr_get_cmdline(dt_ptr);
>>       if (kaslr_disabled())
>> @@ -333,22 +345,12 @@ static unsigned long __init 
>> kaslr_choose_location(void *dt_ptr, phys_addr_t size
>>       regions.dtb_start = __pa(dt_ptr);
>>       regions.dtb_end = __pa(dt_ptr) + fdt_totalsize(dt_ptr);
>>       regions.kernel_size = kernel_sz;
>> +    regions.linear_sz = linear_sz;
>>       get_initrd_range(dt_ptr);
>>       get_crash_kernel(dt_ptr, ram);
>> -    /*
>> -     * Decide which 64M we want to start
>> -     * Only use the low 8 bits of the random seed
>> -     */
>> -    index = random & 0xFF;
>> -    index %= linear_sz / SZ_64M;
>> -
>> -    /* Decide offset inside 64M */
>> -    offset = random % (SZ_64M - kernel_sz);
>> -    offset = round_down(offset, SZ_16K);
>> -
>> -    return kaslr_legal_offset(dt_ptr, index, offset);
>> +    return kaslr_legal_offset(dt_ptr, random);
>>   }
>>   /*
>> @@ -358,8 +360,6 @@ static unsigned long __init 
>> kaslr_choose_location(void *dt_ptr, phys_addr_t size
>>    */
>>   notrace void __init kaslr_early_init(void *dt_ptr, phys_addr_t size)
>>   {
>> -    unsigned long tlb_virt;
>> -    phys_addr_t tlb_phys;
>>       unsigned long offset;
>>       unsigned long kernel_sz;
>> @@ -375,8 +375,8 @@ notrace void __init kaslr_early_init(void *dt_ptr, 
>> phys_addr_t size)
>>       is_second_reloc = 1;
>>       if (offset >= SZ_64M) {
>> -        tlb_virt = round_down(kernstart_virt_addr, SZ_64M);
>> -        tlb_phys = round_down(kernstart_addr, SZ_64M);
>> +        unsigned long tlb_virt = round_down(kernstart_virt_addr, 
>> SZ_64M);
>> +        phys_addr_t tlb_phys = round_down(kernstart_addr, SZ_64M);
> 
> That looks like cleanup unrelated to the patch itself.

Hi, Christophe

These two variables is only for the booke32 code, so I moved the
definition here so that I can save a "#ifdef CONFIG_PPC32" for them.

Thanks,
Jason

> 
>>           /* Create kernel map to relocate in */
>>           create_kaslr_tlb_entry(1, tlb_virt, tlb_phys);
>>
> 
> Christophe
> 
> .

