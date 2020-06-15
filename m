Return-Path: <kernel-hardening-return-18968-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A683F1F902E
	for <lists+kernel-hardening@lfdr.de>; Mon, 15 Jun 2020 09:43:48 +0200 (CEST)
Received: (qmail 32395 invoked by uid 550); 15 Jun 2020 07:43:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32361 invoked from network); 15 Jun 2020 07:43:34 -0000
Subject: Re: [PATCH] erofs: Eliminate usage of uninitialized_var() macro
To: Gao Xiang <hsiangkao@redhat.com>
CC: <xiang@kernel.org>, <chao@kernel.org>, <gregkh@linuxfoundation.org>,
	<linux-erofs@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>, Kees Cook
	<keescook@chromium.org>, <kernel-hardening@lists.openwall.com>
References: <20200615040141.3627746-1-yanaijie@huawei.com>
 <20200615072521.GA25317@xiangao.remote.csb>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <783fe4f9-fb1f-7f5e-c900-7e30d5c85222@huawei.com>
Date: Mon, 15 Jun 2020 15:43:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200615072521.GA25317@xiangao.remote.csb>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.166.213.7]
X-CFilter-Loop: Reflected



�� 2020/6/15 15:25, Gao Xiang д��:
> Hi Jason,
> 
> On Mon, Jun 15, 2020 at 12:01:41PM +0800, Jason Yan wrote:
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
>> Cc: Chao Yu <yuchao0@huawei.com>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> ---
> 
> I'm fine with the patch since "-Wmaybe-uninitialized" has been disabled and
> I've also asked Kees for it in private previously.
> 
> I still remembered that Kees sent out a treewide patch. Sorry about that
> I don't catch up it... But what is wrong with the original patchset?
> 

Yes, Kees has remind me of that and I will let him handle it. So you can 
ignore this patch.

Thanks,
Jason

> Thanks,
> Gao Xiang
> 
> 
> .
> 

