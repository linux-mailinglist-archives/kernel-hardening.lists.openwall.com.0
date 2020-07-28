Return-Path: <kernel-hardening-return-19483-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 259E3231203
	for <lists+kernel-hardening@lfdr.de>; Tue, 28 Jul 2020 20:52:23 +0200 (CEST)
Received: (qmail 16035 invoked by uid 550); 28 Jul 2020 18:52:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 16015 invoked from network); 28 Jul 2020 18:52:15 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D9CA720B4908
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1595962323;
	bh=4VqGIlTMQb0KmRbW1ECdJsuWGdo+ykQfeo4qSABGj8g=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=N5ASgrJbpo8ewcnejqNlOMHW1LlvWw6Pa2UCzET1NHRPpRnwTSki0Dk44+lBNhwyc
	 0Oczcbp+TB0JMzyxyK22fLDJcHQra90UOmtWziVf9oqC+T8MJc1Dn+vnJuvj0FVugv
	 h+6UG1h/10vIpOjMBqWpPTkZqsk7ZujJKLdE1AKo=
Subject: Re: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
To: Andy Lutomirski <luto@kernel.org>
Cc: David Laight <David.Laight@aculab.com>,
 "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
 "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-security-module@vger.kernel.org"
 <linux-security-module@vger.kernel.org>, "oleg@redhat.com"
 <oleg@redhat.com>, "x86@kernel.org" <x86@kernel.org>
References: <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <c23de6ec47614f489943e1a89a21dfa3@AcuMS.aculab.com>
 <f5cfd11b-04fe-9db7-9d67-7ee898636edb@linux.microsoft.com>
 <CALCETrUta5-0TLJ9-jfdehpTAp2Efmukk2npYadFzz9ozOrG2w@mail.gmail.com>
From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <59246260-e535-a9f1-d89e-4e953288b977@linux.microsoft.com>
Date: Tue, 28 Jul 2020 13:52:01 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CALCETrUta5-0TLJ9-jfdehpTAp2Efmukk2npYadFzz9ozOrG2w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US



On 7/28/20 12:16 PM, Andy Lutomirski wrote:
> On Tue, Jul 28, 2020 at 9:32 AM Madhavan T. Venkataraman
> <madvenka@linux.microsoft.com> wrote:
>> Thanks. See inline..
>>
>> On 7/28/20 10:13 AM, David Laight wrote:
>>> From:  madvenka@linux.microsoft.com
>>>> Sent: 28 July 2020 14:11
>>> ...
>>>> The kernel creates the trampoline mapping without any permissions. When
>>>> the trampoline is executed by user code, a page fault happens and the
>>>> kernel gets control. The kernel recognizes that this is a trampoline
>>>> invocation. It sets up the user registers based on the specified
>>>> register context, and/or pushes values on the user stack based on the
>>>> specified stack context, and sets the user PC to the requested target
>>>> PC. When the kernel returns, execution continues at the target PC.
>>>> So, the kernel does the work of the trampoline on behalf of the
>>>> application.
>>> Isn't the performance of this going to be horrid?
>> It takes about the same amount of time as getpid(). So, it is
>> one quick trip into the kernel. I expect that applications will
>> typically not care about this extra overhead as long as
>> they are able to run.
> What did you test this on?  A page fault on any modern x86_64 system
> is much, much, much, much slower than a syscall.

I sent a response to this. But the mail was returned to me.
I am resending.

I tested it in on a KVM guest running Ubuntu. So, when you say that a
page fault is much slower, do you mean a regular page fault that is handled
through the VM layer? Here is the relevant code in do_user_addr_fault():

        if (unlikely(access_error(hw_error_code, vma))) {
                /*                 
                 * If it is a user execute fault, it could be a trampoline
                 * invocation.
                 */
                if ((hw_error_code & tflags) == tflags &&
                     trampfd_fault(vma, regs)) {
                         up_read(&mm->mmap_sem);
                         return;
                 }
                 bad_area_access_error(regs, hw_error_code, address, vma);
                 return;
         }
         ...
         fault = handle_mm_fault(vma, address, flags);

trampfd faults are instruction faults that go through a different code path than
the one that calls handle_mm_fault(). Perhaps, it is the handle_mm_fault() that
is time consuming. Could you clarify?

Thanks.

Madhavan
