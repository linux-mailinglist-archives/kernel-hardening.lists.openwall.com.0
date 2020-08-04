Return-Path: <kernel-hardening-return-19556-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3CCEA23BD7F
	for <lists+kernel-hardening@lfdr.de>; Tue,  4 Aug 2020 17:47:02 +0200 (CEST)
Received: (qmail 9252 invoked by uid 550); 4 Aug 2020 15:46:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9223 invoked from network); 4 Aug 2020 15:46:54 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9B23A20B4908
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1596556002;
	bh=wHC31skMgFt/ebqHymj769kGPOKXA4hyoGb1xMjf0fI=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=EutcuYNAeGhOfkiO8T1sIvfJSLcvl24ddG2j+NfgLnwZCraC2VozjLawrJmUJlmea
	 uMTlKW22ne7ngBbcz+KuCNluoJpU8MvjXq4d9Zax32BecuA0bRhi+seD3ikjWvtxPt
	 m71EidTy92505Hg9DsZNgxuxfBJvroeKJTm5VwQk=
Subject: Re: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
To: Mark Rutland <mark.rutland@arm.com>
Cc: Andy Lutomirski <luto@kernel.org>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Linux API <linux-api@vger.kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>,
 linux-integrity <linux-integrity@vger.kernel.org>,
 LKML <linux-kernel@vger.kernel.org>,
 LSM List <linux-security-module@vger.kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, X86 ML <x86@kernel.org>
References: <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <CALCETrVy5OMuUx04-wWk9FJbSxkrT2vMfN_kANinudrDwC4Cig@mail.gmail.com>
 <6540b4b7-3f70-adbf-c922-43886599713a@linux.microsoft.com>
 <CALCETrWnNR5v3ZCLfBVQGYK8M0jAvQMaAc9uuO05kfZuh-4d6w@mail.gmail.com>
 <46a1adef-65f0-bd5e-0b17-54856fb7e7ee@linux.microsoft.com>
 <20200731183146.GD67415@C02TD0UTHF1T.local>
 <86625441-80f3-2909-2f56-e18e2b60957d@linux.microsoft.com>
 <20200804135558.GA7440@C02TD0UTHF1T.local>
From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <874ec700-405f-bad8-175f-884b4f6f66f2@linux.microsoft.com>
Date: Tue, 4 Aug 2020 10:46:40 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200804135558.GA7440@C02TD0UTHF1T.local>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US

Hey Mark,

I am working on putting together an improved definition of trampfd per
Andy's comment. I will try to address your comments in that improved
definition. Once I send that out, I will respond to your emails as well.

Thanks.

Madhavan

On 8/4/20 8:55 AM, Mark Rutland wrote:
> On Mon, Aug 03, 2020 at 12:58:04PM -0500, Madhavan T. Venkataraman wrote:
>> On 7/31/20 1:31 PM, Mark Rutland wrote:
>>> On Fri, Jul 31, 2020 at 12:13:49PM -0500, Madhavan T. Venkataraman wrote:
>>>> On 7/30/20 3:54 PM, Andy Lutomirski wrote:
>>>>> On Thu, Jul 30, 2020 at 7:24 AM Madhavan T. Venkataraman
>>>>> <madvenka@linux.microsoft.com> wrote:
>>>>> When the kernel generates the code for a trampoline, it can hard code data values
>>>> in the generated code itself so it does not need PC-relative data referencing.
>>>>
>>>> And, for ISAs that do support the large offset, we do have to implement and
>>>> maintain the code page stuff for different ISAs for each application and library
>>>> if we did not use trampfd.
>>> Trampoline code is architecture specific today, so I don't see that as a
>>> major issue. Common structural bits can probably be shared even if the
>>> specifid machine code cannot.
>> True. But an implementor may prefer a standard mechanism provided by
>> the kernel so all of his architectures can be supported easily with less
>> effort.
>>
>> If you look at the libffi reference patch I have included, the architecture
>> specific changes to use trampfd just involve a single C function call to
>> a common code function.
> Sure but in addition to that each architecture backend had to define a
> set of arguments to that. I view the C function is analagous to the
> "common structural bits".
>
> I appreciate that your patch is small today (and architectures seem to
> largely align on what they need), but I don't think it's necessarily
> true that things will remain so simple as architecture are extended and
> their calling conventions evolve, and I also don't think it's clear that
> this will work for more complex cases elsewhere.
>
> [...]
>
>>>> With the user level trampoline table approach, the data part of the trampoline table
>>>> can be hacked by an attacker if an application has a vulnerability. Specifically, the
>>>> target PC can be altered to some arbitrary location. Trampfd implements an
>>>> "Allowed PCS" context. In the libffi changes, I have created a read-only array of
>>>> all ABI handlers used in closures for each architecture. This read-only array
>>>> can be used to restrict the PC values for libffi trampolines to prevent hacking.
>>>>
>>>> To generalize, we can implement security rules/features if the trampoline
>>>> object is in the kernel.
>>> I don't follow this argument. If it's possible to statically define that
>>> in the kernel, it's also possible to do that in userspace without any
>>> new kernel support.
>> It is not statically defined in the kernel.
>>
>> Let us take the libffi example. In the 64-bit X86 arch code, there are 3
>> ABI handlers:
>>
>>     ffi_closure_unix64_sse
>>     ffi_closure_unix64
>>     ffi_closure_win64
>>
>> I could create an "Allowed PCs" context like this:
>>
>> struct my_allowed_pcs {
>>     struct trampfd_values    pcs;
>>     __u64                             pc_values[3];
>> };
>>
>> const struct my_allowed_pcs    my_allowed_pcs = {
>>     { 3, 0 },
>>     (uintptr_t) ffi_closure_unix64_sse,
>>     (uintptr_t) ffi_closure_unix64,
>>     (uintptr_t) ffi_closure_win64,
>> };
>>
>> I have created a read-only array of allowed ABI handlers that closures use.
>>
>> When I set up the context for a closure trampoline, I could do this:
>>
>>     pwrite(trampfd, &my_allowed_pcs, sizeof(my_allowed_pcs), TRAMPFD_ALLOWED_PCS_OFFSET);
>>    
>> This copies the array into the trampoline object in the kernel.
>> When the register context is set for the trampoline, the kernel checks
>> the PC register value against allowed PCs.
>>
>> Because my_allowed_pcs is read-only, a hacker cannot modify it. So, the only
>> permitted target PCs enforced by the kernel are the ABI handlers.
> Sorry, when I said "statically define" meant when you knew legitimate
> targets ahead of time when you create the trampoline (i.e. whether you
> could enumerate those and know they would not change dynamically).
>
> My point was that you can achieve the same in userspace if the
> trampoline and array of legitimate targets are in read-only memory,
> without having to trap to the kernel.
>
> I think the key point here is that an adversary must be prevented from
> altering a trampoline and any associated metadata, and I think that
> there are ways of achieving that without having to trap into the kernel,
> and without the kernel having to be intimately aware of the calling
> conventions used in userspace.
>
> [...]
>
>>>> Trampfd is a framework that can be used to implement multiple things. May be,
>>>> a few of those things can also be implemented in user land itself. But I think having
>>>> just one mechanism to execute dynamic code objects is preferable to having
>>>> multiple mechanisms not standardized across all applications.
>>> In abstract, having a common interface sounds nice, but in practice
>>> elements of this are always architecture-specific (e.g. interactiosn
>>> with HW CFI), and that common interface can result in more pain as it
>>> doesn't fit naturally into the context that ISAs were designed for (e.g. 
>>> where control-flow instructions are extended with new semantics).
>> In the case of trampfd, the code generation is indeed architecture
>> specific. But that is in the kernel. The application is not affected by it.
> As an ABI detail, applications are *definitely* affected by this, and it
> is wrong to suggest they are not even if you don't have a specific case
> in mind today. As this forms a contract between userspace and the kernel
> it's overly simplistic to say that it's the kernel's problem
>
> For example, in the case of BTI on arm64, what should the trampoline
> set PSTATE.BTYPE to? Different use-cases *will* want different values,
> and not necessarily the value of PSTATE at the instant the call to the
> trampoline was made. In the case of libffi specifically using the
> original value of PSTATE.BTYPE probably is sound, but other code
> sequences may need to restrict/broaden or entirely change that.
>
>> Again, referring to the libffi reference patch, I have defined wrapper
>> functions for trampfd in common code. The architecture specific code
>> in libffi only calls the set_context function defined in common code.
>> Even this is required only because register names are specific to each
>> architecture and the target PC (to the ABI handler) is specific to
>> each architecture-ABI combo.
>>
>>> It also meass that you can't share the rough approach across OSs which
>>> do not implement an identical mechanism, so for code abstracting by ISA
>>> first, then by platform/ABI, there isn't much saving.
>> Why can you not share the same approach across OSes? In fact,
>> I have tried to design it so that other OSes can use the same
>> mechanism.
> Sure, but where they *don't*, you must fall back to the existing
> purely-userspace mechanisms, and so a codebase now has the burden of
> maintaining two distinct mechanisms.
>
> Whereas if there's a way of doing this in userspace with (stronger)
> enforcement of memory permissions the trampoline code can be common for
> when this is present or absent, which is much easier for a codebase rto
> maintain, and could make use of weaker existing mechanisms to improve
> the situation on systems without the new functionality.
>
> Thanks,
> Mark.

