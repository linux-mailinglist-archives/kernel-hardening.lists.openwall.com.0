Return-Path: <kernel-hardening-return-16757-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id DE63E85CAD
	for <lists+kernel-hardening@lfdr.de>; Thu,  8 Aug 2019 10:20:22 +0200 (CEST)
Received: (qmail 7239 invoked by uid 550); 8 Aug 2019 08:20:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7200 invoked from network); 8 Aug 2019 08:20:15 -0000
Subject: Re: [PATCH v5 09/10] powerpc/fsl_booke/kaslr: support nokaslr cmdline
 parameter
To: Michael Ellerman <mpe@ellerman.id.au>, <linuxppc-dev@lists.ozlabs.org>,
	<diana.craciun@nxp.com>, <christophe.leroy@c-s.fr>,
	<benh@kernel.crashing.org>, <paulus@samba.org>, <npiggin@gmail.com>,
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
CC: <linux-kernel@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<yebin10@huawei.com>, <thunder.leizhen@huawei.com>,
	<jingxiangfeng@huawei.com>, <fanchengyang@huawei.com>,
	<zhaohongjiang@huawei.com>
References: <20190807065706.11411-1-yanaijie@huawei.com>
 <20190807065706.11411-10-yanaijie@huawei.com>
 <87y305t9dv.fsf@concordia.ellerman.id.au>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <7218f89b-8724-55f3-e834-5dc4722fdb8f@huawei.com>
Date: Thu, 8 Aug 2019 16:19:48 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <87y305t9dv.fsf@concordia.ellerman.id.au>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.96.203]
X-CFilter-Loop: Reflected



On 2019/8/7 21:03, Michael Ellerman wrote:
> Jason Yan <yanaijie@huawei.com> writes:
>> diff --git a/arch/powerpc/kernel/kaslr_booke.c b/arch/powerpc/kernel/kaslr_booke.c
>> index c6b326424b54..436f9a03f385 100644
>> --- a/arch/powerpc/kernel/kaslr_booke.c
>> +++ b/arch/powerpc/kernel/kaslr_booke.c
>> @@ -361,6 +361,18 @@ static unsigned long __init kaslr_choose_location(void *dt_ptr, phys_addr_t size
>>   	return kaslr_offset;
>>   }
>>   
>> +static inline __init bool kaslr_disabled(void)
>> +{
>> +	char *str;
>> +
>> +	str = strstr(boot_command_line, "nokaslr");
>> +	if (str == boot_command_line ||
>> +	    (str > boot_command_line && *(str - 1) == ' '))
>> +		return true;
> 
> This extra logic doesn't work for "nokaslrfoo". Is it worth it?
> 

Seems nobody likes this logic. Maybe I can delete this logic for now and
see if anyone has any objections.

> cheers
> 
> .
> 

