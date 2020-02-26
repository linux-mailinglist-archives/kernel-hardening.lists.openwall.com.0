Return-Path: <kernel-hardening-return-17926-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7E2F216F5BD
	for <lists+kernel-hardening@lfdr.de>; Wed, 26 Feb 2020 03:44:39 +0100 (CET)
Received: (qmail 18358 invoked by uid 550); 26 Feb 2020 02:44:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 18323 invoked from network); 26 Feb 2020 02:44:33 -0000
Subject: Re: [PATCH v3 5/6] powerpc/fsl_booke/64: clear the original kernel if
 randomized
To: Christophe Leroy <christophe.leroy@c-s.fr>, <mpe@ellerman.id.au>,
	<linuxppc-dev@lists.ozlabs.org>, <diana.craciun@nxp.com>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>,
	<oss@buserror.net>
CC: <linux-kernel@vger.kernel.org>, <zhaohongjiang@huawei.com>
References: <20200206025825.22934-1-yanaijie@huawei.com>
 <20200206025825.22934-6-yanaijie@huawei.com>
 <0f778e1c-5e29-e600-1cf0-aeb3e1a6fe08@c-s.fr>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <f7b10cd6-d610-2ac6-e80d-97c0f347aff8@huawei.com>
Date: Wed, 26 Feb 2020 10:44:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <0f778e1c-5e29-e600-1cf0-aeb3e1a6fe08@c-s.fr>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.221.195]
X-CFilter-Loop: Reflected



在 2020/2/20 21:49, Christophe Leroy 写道:
> 
> 
> Le 06/02/2020 à 03:58, Jason Yan a écrit :
>> The original kernel still exists in the memory, clear it now.
> 
> No such problem with PPC32 ? Or is that common ?
> 

PPC32 did this in relocate_init() in fsl_booke.c because PPC32 will not 
reach kaslr_early_init for the second pass after relocation.

Thanks,
Jason

> Christophe
> 
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
>>   arch/powerpc/mm/nohash/kaslr_booke.c | 4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/powerpc/mm/nohash/kaslr_booke.c 
>> b/arch/powerpc/mm/nohash/kaslr_booke.c
>> index c6f5c1db1394..ed1277059368 100644
>> --- a/arch/powerpc/mm/nohash/kaslr_booke.c
>> +++ b/arch/powerpc/mm/nohash/kaslr_booke.c
>> @@ -378,8 +378,10 @@ notrace void __init kaslr_early_init(void 
>> *dt_ptr, phys_addr_t size)
>>       unsigned int *__kaslr_offset = (unsigned int *)(KERNELBASE + 0x58);
>>       unsigned int *__run_at_load = (unsigned int *)(KERNELBASE + 0x5c);
>> -    if (*__run_at_load == 1)
>> +    if (*__run_at_load == 1) {
>> +        kaslr_late_init();
>>           return;
>> +    }
>>       /* Setup flat device-tree pointer */
>>       initial_boot_params = dt_ptr;
>>
> 
> .

