Return-Path: <kernel-hardening-return-16122-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0810C433D5
	for <lists+kernel-hardening@lfdr.de>; Thu, 13 Jun 2019 09:45:56 +0200 (CEST)
Received: (qmail 20068 invoked by uid 550); 13 Jun 2019 07:45:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 13653 invoked from network); 13 Jun 2019 07:20:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1560410459; x=1591946459;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=dhmXrepDAZcjXkpQs5VfxOBzitc3aINuYRH8cXmOgbc=;
  b=KWMoXJ2MuJEdpYKD7xUoakZN2kd99WuKht1vrcgdJlNRvh113bn+PEFS
   zxfRu2Pfo4L+/3qlGuYmjjDh1l75PMSNXMX/yZ53BTZmDvKkmk2HS0KyO
   9iwx+Koo5hYGHLVf4nlUEW/MUYW/oISn5apsbOG3x3feyj1eHxmCIq/tr
   Q=;
X-IronPort-AV: E=Sophos;i="5.62,368,1554768000"; 
   d="scan'208";a="737272759"
Subject: Re: [RFC 00/10] Process-local memory allocations for hiding KVM
 secrets
To: Sean Christopherson <sean.j.christopherson@intel.com>, Marius Hillenbrand
	<mhillenb@amazon.de>
CC: <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<kernel-hardening@lists.openwall.com>, <linux-mm@kvack.org>, Alexander Graf
	<graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>
References: <20190612170834.14855-1-mhillenb@amazon.de>
 <20190612182550.GI20308@linux.intel.com>
From: Alexander Graf <graf@amazon.com>
Message-ID: <7162182f-74e5-9be7-371d-48ee483206c2@amazon.com>
Date: Thu, 13 Jun 2019 09:20:40 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190612182550.GI20308@linux.intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.43.160.69]
X-ClientProxiedBy: EX13D22UWC001.ant.amazon.com (10.43.162.192) To
 EX13D20UWC001.ant.amazon.com (10.43.162.244)


On 12.06.19 20:25, Sean Christopherson wrote:
> On Wed, Jun 12, 2019 at 07:08:24PM +0200, Marius Hillenbrand wrote:
>> The Linux kernel has a global address space that is the same for any
>> kernel code. This address space becomes a liability in a world with
>> processor information leak vulnerabilities, such as L1TF. With the right
>> cache load gadget, an attacker-controlled hyperthread pair can leak
>> arbitrary data via L1TF. Disabling hyperthreading is one recommended
>> mitigation, but it comes with a large performance hit for a wide range
>> of workloads.
>>
>> An alternative mitigation is to not make certain data in the kernel
>> globally visible, but only when the kernel executes in the context of
>> the process where this data belongs to.
>>
>> This patch series proposes to introduce a region for what we call
>> process-local memory into the kernel's virtual address space. Page
>> tables and mappings in that region will be exclusive to one address
>> space, instead of implicitly shared between all kernel address spaces.
>> Any data placed in that region will be out of reach of cache load
>> gadgets that execute in different address spaces. To implement
>> process-local memory, we introduce a new interface kmalloc_proclocal() /
>> kfree_proclocal() that allocates and maps pages exclusively into the
>> current kernel address space. As a first use case, we move architectural
>> state of guest CPUs in KVM out of reach of other kernel address spaces.
> Can you briefly describe what types of attacks this is intended to
> mitigate?  E.g. guest-guest, userspace-guest, etc...  I don't want to
> make comments based on my potentially bad assumptions.


(quickly jumping in for Marius, he's offline today)

The main purpose of this is to protect from leakage of data from one 
guest into another guest using speculation gadgets on the host.

The same mechanism can be used to prevent leakage of secrets from one 
host process into another host process though, as host processes 
potentially have access to gadgets via the syscall interface.


Alex

