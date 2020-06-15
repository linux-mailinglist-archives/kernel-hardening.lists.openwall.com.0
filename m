Return-Path: <kernel-hardening-return-18969-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9FB171F91A8
	for <lists+kernel-hardening@lfdr.de>; Mon, 15 Jun 2020 10:39:07 +0200 (CEST)
Received: (qmail 24033 invoked by uid 550); 15 Jun 2020 08:39:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23995 invoked from network); 15 Jun 2020 08:39:00 -0000
Subject: Re: [f2fs-dev] [PATCH] f2fs: Eliminate usage of uninitialized_var()
 macro
To: Chao Yu <yuchao0@huawei.com>, <jaegeuk@kernel.org>, <chao@kernel.org>,
	<linux-f2fs-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>
CC: Kees Cook <keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
References: <20200615040212.3681503-1-yanaijie@huawei.com>
 <d1562b04-125f-c112-7272-d99ed1e38549@huawei.com>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <f40aa2cc-5675-b8a2-b14f-10edf63d748a@huawei.com>
Date: Mon, 15 Jun 2020 16:38:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <d1562b04-125f-c112-7272-d99ed1e38549@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.166.213.7]
X-CFilter-Loop: Reflected


在 2020/6/15 16:26, Chao Yu 写道:
> On 2020/6/15 12:02, Jason Yan wrote:
>> This is an effort to eliminate the uninitialized_var() macro[1].
>>
>> The use of this macro is the wrong solution because it forces off ANY
>> analysis by the compiler for a given variable. It even masks "unused
>> variable" warnings.
>>
>> Quoted from Linus[2]:
>>
>> "It's a horrible thing to use, in that it adds extra cruft to the
>> source code, and then shuts up a compiler warning (even the _reliable_
>> warnings from gcc)."
>>
>> The gcc option "-Wmaybe-uninitialized" has been disabled and this change
>> will not produce any warnnings even with "make W=1".
>>
>> [1] https://github.com/KSPP/linux/issues/81
>> [2] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=yVJu65TpLgN_ybYNv0VEOKA@mail.gmail.com/
>>
>> Cc: Kees Cook <keescook@chromium.org>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> ---
>>   fs/f2fs/data.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
>> index 326c63879ddc..e6ec61274d76 100644
>> --- a/fs/f2fs/data.c
>> +++ b/fs/f2fs/data.c
>> @@ -2856,7 +2856,7 @@ static int f2fs_write_cache_pages(struct address_space *mapping,
>>   	};
>>   #endif
>>   	int nr_pages;
>> -	pgoff_t uninitialized_var(writeback_index);
>> +	pgoff_t writeback_index;
> 
> I suggest to delete this variable directly, as we did for mm in
> commit 28659cc8cc87 (mm/page-writeback.c: remove unused variable).
> 

Good suggestion, I will send v2.

Thanks,
Jason

> Thanks,
> 
>>   	pgoff_t index;
>>   	pgoff_t end;		/* Inclusive */
>>   	pgoff_t done_index;
>>
> 
> .
> 

