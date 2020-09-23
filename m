Return-Path: <kernel-hardening-return-19996-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F15062764C4
	for <lists+kernel-hardening@lfdr.de>; Thu, 24 Sep 2020 01:53:40 +0200 (CEST)
Received: (qmail 15863 invoked by uid 550); 23 Sep 2020 23:53:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15819 invoked from network); 23 Sep 2020 23:53:34 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 035D320B7179
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1600905202;
	bh=stfW7VJ9ixikhAwpOM4Y5v+Co/aY6HnPcRI9MXRFn5o=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=XU8UVx4l9QT/FMwo8coMBjnSlLBVk+KBoR6KrO3k/zZ6+mnhEd9ikKjXqtLLVZvX8
	 6L4k3p2sXtnrt7iHN48ZKcWMojIdvdW6wCunGopAI4Vm339QmzKeUGR7hpZh3q8OSK
	 MOlqBqWNABhGiq2M7DKxely5hf7eFnDLY3+f4pu8=
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
To: Florian Weimer <fweimer@redhat.com>, Solar Designer <solar@openwall.com>
Cc: Pavel Machek <pavel@ucw.cz>, kernel-hardening@lists.openwall.com,
 linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
 oleg@redhat.com, x86@kernel.org, luto@kernel.org, David.Laight@ACULAB.COM,
 mark.rutland@arm.com, mic@digikod.net, Rich Felker <dalias@libc.org>
References: <20200922215326.4603-1-madvenka@linux.microsoft.com>
 <20200923081426.GA30279@amd> <20200923091456.GA6177@openwall.com>
 <87wo0ko8v0.fsf@oldenburg2.str.redhat.com>
From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <1a7c9989-fb98-20f7-c0d9-2261aa50d967@linux.microsoft.com>
Date: Wed, 23 Sep 2020 18:53:21 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87wo0ko8v0.fsf@oldenburg2.str.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit



On 9/23/20 9:39 AM, Florian Weimer wrote:
> * Solar Designer:
> 
>> While I share my opinion here, I don't mean that to block Madhavan's
>> work.  I'd rather defer to people more knowledgeable in current userland
>> and ABI issues/limitations and plans on dealing with those, especially
>> to Florian Weimer.  I haven't seen Florian say anything specific for or
>> against Madhavan's proposal, and I'd like to.  (Have I missed that?)
> 
> There was a previous discussion, where I provided feedback (not much
> different from the feedback here, given that the mechanism is mostly the
> same).
> 
> I think it's unnecessary for the libffi use case.  Precompiled code can
> be loaded from disk because the libffi trampolines are so regular.  On
> most architectures, it's not even the code that's patched, but some of
> the data driving it, which happens to be located on the same page due to
> a libffi quirk.
> 
> The libffi use case is a bit strange anyway: its trampolines are
> type-generic, and the per-call adjustment is data-driven.  This means
> that once you have libffi in the process, you have a generic
> data-to-function-call mechanism available that can be abused (it's even
> fully CET compatible in recent versions).  And then you need to look at
> the processes that use libffi.  A lot of them contain bytecode
> interpreters, and those enable data-driven arbitrary code execution as
> well.  I know that there are efforts under way to harden Python, but
> it's going to be tough to get to the point where things are still
> difficult for an attacker once they have the ability to make mprotect
> calls.
> 
> It was pointed out to me that libffi is doing things wrong, and the
> trampolines should not be type-generic, but generated so that they match
> the function being called.  That is, the marshal/unmarshal code would be
> open-coded in the trampoline, rather than using some generic mechanism
> plus run-time dispatch on data tables describing the function type.
> That is a very different design (and typically used by compilers (JIT or
> not JIT) to implement native calls).  Mapping some code page with a
> repeating pattern would no longer work to defeat anti-JIT measures
> because it's closer to real JIT.  I don't know if kernel support could
> make sense in this context, but it would be a completely different
> patch.
> 
> Thanks,
> Florian
> 
Hi Florian,

I am making myself familiar with anti-JIT measures before I can respond
to this comment. Bear with me. I will also respond to the above
libffi comment.

Madhavan
