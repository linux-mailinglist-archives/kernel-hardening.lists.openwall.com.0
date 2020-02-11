Return-Path: <kernel-hardening-return-17781-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 17841159AEE
	for <lists+kernel-hardening@lfdr.de>; Tue, 11 Feb 2020 22:07:14 +0100 (CET)
Received: (qmail 5966 invoked by uid 550); 11 Feb 2020 21:07:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5932 invoked from network); 11 Feb 2020 21:07:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581455215;
	bh=ial5lfm1joGz3c4sbCOYuWw3kSyd3YsJFbgXFfG8r/g=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=msfipC7T9DKYbMKWk/VLVW4IMh7VnAItA5wtAxaobNWwXfYmHZ/X/Ymmq8lsnLEGN
	 Wu+pQMJuctk58waK3nUpMbXZ4UDxTjq9yOcqf5kjKIuTY+pyZfL45ptaFYdIywNhS+
	 cyd182nfjlqDLv5IJ8aOb17XICywoddq/X6ljmcc=
Subject: Re: [PATCH v3 7/7] selftests/exec: Add READ_IMPLIES_EXEC tests
To: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>, Hector Marco-Gisbert <hecmargi@upv.es>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon
 <will.deacon@arm.com>, Jason Gunthorpe <jgg@mellanox.com>,
 Jann Horn <jannh@google.com>, Russell King <linux@armlinux.org.uk>,
 x86@kernel.org, kernel-hardening@lists.openwall.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200210193049.64362-1-keescook@chromium.org>
 <20200210193049.64362-8-keescook@chromium.org>
 <4f8a5036-dc2a-90ad-5fc8-69560a5dd78e@kernel.org>
 <202002111124.0A334167@keescook>
From: shuah <shuah@kernel.org>
Message-ID: <c09c345a-786f-25d2-1ee5-65f9cb23db6d@kernel.org>
Date: Tue, 11 Feb 2020 14:06:53 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <202002111124.0A334167@keescook>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 2/11/20 12:25 PM, Kees Cook wrote:
> On Tue, Feb 11, 2020 at 11:11:21AM -0700, shuah wrote:
>> On 2/10/20 12:30 PM, Kees Cook wrote:
>>> In order to check the matrix of possible states for handling
>>> READ_IMPLIES_EXEC across native, compat, and the state of PT_GNU_STACK,
>>> add tests for these execution conditions.
>>>
>>> Signed-off-by: Kees Cook <keescook@chromium.org>
>>
>> No issues for this to go through tip.
>>
>> A few problems to fix first. This fails to compile when 32-bit libraries
>> aren't installed. It should fail the 32-bit part and run other checks.
> 
> Do you mean the Makefile should detect the missing compat build deps and
> avoid building them? Testing compat is pretty important to this test, so
> it seems like missing the build deps causing the build to fail is the
> correct action here. This is likely true for the x86/ selftests too.
> 
> What would you like this to do?
> 

selftests/x86 does this already and runs the dependency check in 
x86/Makefile.


check_cc.sh:# check_cc.sh - Helper to test userspace compilation support
Makefile:CAN_BUILD_I386 := $(shell ./check_cc.sh $(CC) 
trivial_32bit_program.c -m32)
Makefile:CAN_BUILD_X86_64 := $(shell ./check_cc.sh $(CC) 
trivial_64bit_program.c)
Makefile:CAN_BUILD_WITH_NOPIE := $(shell ./check_cc.sh $(CC) 
trivial_program.c -no-pie)

Take a look and see if you can leverage this.

thanks,
-- Shuah
