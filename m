Return-Path: <kernel-hardening-return-16753-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6935485892
	for <lists+kernel-hardening@lfdr.de>; Thu,  8 Aug 2019 05:32:32 +0200 (CEST)
Received: (qmail 28570 invoked by uid 550); 8 Aug 2019 03:32:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28538 invoked from network); 8 Aug 2019 03:32:25 -0000
Subject: Re: [PATCH v5 02/10] powerpc: move memstart_addr and kernstart_addr
 to init-common.c
To: Michael Ellerman <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<yebin10@huawei.com>, <thunder.leizhen@huawei.com>,
	<jingxiangfeng@huawei.com>, <fanchengyang@huawei.com>,
	<zhaohongjiang@huawei.com>
References: <20190807065706.11411-1-yanaijie@huawei.com>
 <20190807065706.11411-3-yanaijie@huawei.com>
 <874l2tuo0t.fsf@concordia.ellerman.id.au>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <d2e0d1e5-cf6d-1c82-bae6-60e34f651cc1@huawei.com>
Date: Thu, 8 Aug 2019 11:32:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <874l2tuo0t.fsf@concordia.ellerman.id.au>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.203]
X-CFilter-Loop: Reflected



On 2019/8/7 21:02, Michael Ellerman wrote:
> Jason Yan <yanaijie@huawei.com> writes:
>> These two variables are both defined in init_32.c and init_64.c. Move
>> them to init-common.c.
>>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> Cc: Diana Craciun <diana.craciun@nxp.com>
>> Cc: Michael Ellerman <mpe@ellerman.id.au>
>> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Nicholas Piggin <npiggin@gmail.com>
>> Cc: Kees Cook <keescook@chromium.org>
>> Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
>> Reviewed-by: Diana Craciun <diana.craciun@nxp.com>
>> Tested-by: Diana Craciun <diana.craciun@nxp.com>
>> ---
>>   arch/powerpc/mm/init-common.c | 5 +++++
>>   arch/powerpc/mm/init_32.c     | 5 -----
>>   arch/powerpc/mm/init_64.c     | 5 -----
>>   3 files changed, 5 insertions(+), 10 deletions(-)
>>
>> diff --git a/arch/powerpc/mm/init-common.c b/arch/powerpc/mm/init-common.c
>> index a84da92920f7..152ae0d21435 100644
>> --- a/arch/powerpc/mm/init-common.c
>> +++ b/arch/powerpc/mm/init-common.c
>> @@ -21,6 +21,11 @@
>>   #include <asm/pgtable.h>
>>   #include <asm/kup.h>
>>   
>> +phys_addr_t memstart_addr = (phys_addr_t)~0ull;
>> +EXPORT_SYMBOL_GPL(memstart_addr);
>> +phys_addr_t kernstart_addr;
>> +EXPORT_SYMBOL_GPL(kernstart_addr);
> 
> Would be nice if these can be __ro_after_init ?
> 

Good idea.

> cheers
> 
> .
> 

