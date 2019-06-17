Return-Path: <kernel-hardening-return-16154-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 97AC347F13
	for <lists+kernel-hardening@lfdr.de>; Mon, 17 Jun 2019 12:03:41 +0200 (CEST)
Received: (qmail 30650 invoked by uid 550); 17 Jun 2019 10:03:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 3897 invoked from network); 17 Jun 2019 07:38:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1560757103; x=1592293103;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=8xZP6BRYVHqRBD1v3aCylovGhFA01FEft+IhJzUopnA=;
  b=msbheylMXzeMJvOyQxCsKkALp+1HMdTIhwzGZp3Lrf3hyqLwQFTVged3
   czSXrJ9TQX2rDoAl87zS/PsHikH0+aUw/158GrBVqg3lSjUtUZsDutQ1H
   EvaTUP8++hkWcRLuGT5vbKGPZMVvnWwa3k50zMcZJavkM0NSIp+8Ik9uS
   M=;
X-IronPort-AV: E=Sophos;i="5.62,384,1554768000"; 
   d="scan'208";a="737725018"
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
To: Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski
	<luto@amacapital.net>
CC: Dave Hansen <dave.hansen@intel.com>, Marius Hillenbrand
	<mhillenb@amazon.de>, <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel-hardening@lists.openwall.com>, <linux-mm@kvack.org>, Alexander Graf
	<graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>, "the arch/x86
 maintainers" <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, "Peter
 Zijlstra" <peterz@infradead.org>
References: <20190612170834.14855-1-mhillenb@amazon.de>
 <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
 <A542C98B-486C-4849-9DAC-2355F0F89A20@amacapital.net>
 <alpine.DEB.2.21.1906141618000.1722@nanos.tec.linutronix.de>
From: Alexander Graf <graf@amazon.com>
Message-ID: <58788f05-04c3-e71c-12c3-0123be55012c@amazon.com>
Date: Mon, 17 Jun 2019 09:38:00 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.21.1906141618000.1722@nanos.tec.linutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.43.160.69]
X-ClientProxiedBy: EX13D20UWC004.ant.amazon.com (10.43.162.41) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)


On 14.06.19 16:21, Thomas Gleixner wrote:
> On Wed, 12 Jun 2019, Andy Lutomirski wrote:
>>> On Jun 12, 2019, at 12:55 PM, Dave Hansen <dave.hansen@intel.com> wrote:
>>>
>>>> On 6/12/19 10:08 AM, Marius Hillenbrand wrote:
>>>> This patch series proposes to introduce a region for what we call
>>>> process-local memory into the kernel's virtual address space.
>>> It might be fun to cc some x86 folks on this series.  They might have
>>> some relevant opinions. ;)
>>>
>>> A few high-level questions:
>>>
>>> Why go to all this trouble to hide guest state like registers if all the
>>> guest data itself is still mapped?
>>>
>>> Where's the context-switching code?  Did I just miss it?
>>>
>>> We've discussed having per-cpu page tables where a given PGD is only in
>>> use from one CPU at a time.  I *think* this scheme still works in such a
>>> case, it just adds one more PGD entry that would have to context-switched.
>> Fair warning: Linus is on record as absolutely hating this idea. He might
>> change his mind, but it’s an uphill battle.
> Yes I know, but as a benefit we could get rid of all the GSBASE horrors in
> the entry code as we could just put the percpu space into the local PGD.


Would that mean that with Meltdown affected CPUs we open speculation 
attacks against the mmlocal memory from KVM user space?


Alex

