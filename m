Return-Path: <kernel-hardening-return-16123-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0CD35433D6
	for <lists+kernel-hardening@lfdr.de>; Thu, 13 Jun 2019 09:46:07 +0200 (CEST)
Received: (qmail 20410 invoked by uid 550); 13 Jun 2019 07:45:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 21615 invoked from network); 13 Jun 2019 07:27:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1560410843; x=1591946843;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=Laetec4ccSCBOw8YMZruaBJ+PWt1iLta0CpWlGDAXuM=;
  b=AGQI7+SWOEFKmWwYcSTzDUAf3i/voDjo3oIAI/+96UkKnzSMZrbT1sxe
   GhdeWILp7Ga/TWr3O8TkaAJkD5EBEzLqOyBksVFJXOHL7SZBiHg+f+B7C
   4O2WRdSFDE6JGzQeFYeczssYqa1SIjwpivWZoHyfGbnZweQGrAQ34GJNM
   g=;
X-IronPort-AV: E=Sophos;i="5.62,368,1554768000"; 
   d="scan'208";a="679674698"
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
To: Dave Hansen <dave.hansen@intel.com>, Marius Hillenbrand
	<mhillenb@amazon.de>, <kvm@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <kernel-hardening@lists.openwall.com>,
	<linux-mm@kvack.org>, Alexander Graf <graf@amazon.de>, David Woodhouse
	<dwmw@amazon.co.uk>, the arch/x86 maintainers <x86@kernel.org>, "Andy
 Lutomirski" <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
References: <20190612170834.14855-1-mhillenb@amazon.de>
 <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
From: Alexander Graf <graf@amazon.com>
Message-ID: <54a4d14c-b19b-339e-5a15-adb10297cb30@amazon.com>
Date: Thu, 13 Jun 2019 09:27:00 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <eecc856f-7f3f-ed11-3457-ea832351e963@intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.43.160.177]
X-ClientProxiedBy: EX13D01UWA003.ant.amazon.com (10.43.160.107) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)


On 12.06.19 21:55, Dave Hansen wrote:
> On 6/12/19 10:08 AM, Marius Hillenbrand wrote:
>> This patch series proposes to introduce a region for what we call
>> process-local memory into the kernel's virtual address space.
> It might be fun to cc some x86 folks on this series.  They might have
> some relevant opinions. ;)
>
> A few high-level questions:
>
> Why go to all this trouble to hide guest state like registers if all the
> guest data itself is still mapped?


(jumping in for Marius, he's offline today)

Glad you asked :). I hope this cover letter explains well how to achieve 
guest data not being mapped:

https://lkml.org/lkml/2019/1/31/933


> Where's the context-switching code?  Did I just miss it?


I'm not sure I understand the question. With this mechanism, the global 
linear map pages are just not present anymore, so there is no context 
switching needed. For the process local memory, the page table is 
already mm local, so we don't need to do anything special during context 
switch, no?


Alex

