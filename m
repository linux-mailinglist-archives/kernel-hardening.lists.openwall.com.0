Return-Path: <kernel-hardening-return-19591-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E406F241B11
	for <lists+kernel-hardening@lfdr.de>; Tue, 11 Aug 2020 14:41:35 +0200 (CEST)
Received: (qmail 32376 invoked by uid 550); 11 Aug 2020 12:41:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32356 invoked from network); 11 Aug 2020 12:41:29 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7A2A120B4908
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1597149677;
	bh=/01YYim8UON1WnW57/jtTiKZ9zMxYZQ09Mw9cbuIu4A=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=PFQNuX5mWMquO2HGENEzafqUyJUE7/be/jyBGj5BPS+LLzBuKDCp8oxu/gpMGiuzS
	 6nmE9EJ+VCIZo4ZznNZO0l1rypST2o/WGeVSn+KjlmzrdKh1od3CFRwpGX0UIvppY1
	 +3sGwRwS/5aecpkyVSZ45vXgzNz/7thzHMTdnYOE=
Subject: Re: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
To: Pavel Machek <pavel@ucw.cz>
Cc: Mark Rutland <mark.rutland@arm.com>, kernel-hardening@lists.openwall.com,
 linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
 oleg@redhat.com, x86@kernel.org
References: <aefc85852ea518982e74b233e11e16d2e707bc32>
 <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <20200731180955.GC67415@C02TD0UTHF1T.local>
 <6236adf7-4bed-534e-0956-fddab4fd96b6@linux.microsoft.com>
 <20200804143018.GB7440@C02TD0UTHF1T.local>
 <b3368692-afe6-89b5-d634-12f4f0a601f8@linux.microsoft.com>
 <20200808221748.GA1020@bug>
From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <6cca8eac-f767-b891-dc92-eaa7504a0e8b@linux.microsoft.com>
Date: Tue, 11 Aug 2020 07:41:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200808221748.GA1020@bug>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit



On 8/8/20 5:17 PM, Pavel Machek wrote:
> Hi!
> 
>> Thanks for the lively discussion. I have tried to answer some of the
>> comments below.
> 
>>> There are options today, e.g.
>>>
>>> a) If the restriction is only per-alias, you can have distinct aliases
>>>    where one is writable and another is executable, and you can make it
>>>    hard to find the relationship between the two.
>>>
>>> b) If the restriction is only temporal, you can write instructions into
>>>    an RW- buffer, transition the buffer to R--, verify the buffer
>>>    contents, then transition it to --X.
>>>
>>> c) You can have two processes A and B where A generates instrucitons into
>>>    a buffer that (only) B can execute (where B may be restricted from
>>>    making syscalls like write, mprotect, etc).
>>
>> The general principle of the mitigation is W^X. I would argue that
>> the above options are violations of the W^X principle. If they are
>> allowed today, they must be fixed. And they will be. So, we cannot
>> rely on them.
> 
> Would you mind describing your threat model?
> 
> Because I believe you are using model different from everyone else.
> 
> In particular, I don't believe b) is a problem or should be fixed.

It is a problem because a kernel that implements W^X properly
will not allow it. It has no idea what has been done in userland.
It has no idea that the user has checked and verified the buffer
contents after transitioning the page to R--.


> 
> I'll add d), application mmaps a file(R--), and uses write syscall to change
> trampolines in it.
> 

No matter how you do it, these are all user-level methods that can be
hacked. The kernel cannot be sure that an attacker's code has
not found its way into the file.

>> b) This is again a violation. The kernel should refuse to give execute
>> ???????? permission to a page that was writeable in the past and refuse to
>> ???????? give write permission to a page that was executable in the past.
> 
> Why?

I don't know about the latter part. I guess I need to think about it.
But the former is valid. When a page is RW-, a hacker could hack the
page. Then it does not matter that the page is transitioned to R--.
Again, the kernel cannot be sure that the user has verified the contents
after R--.

IMO, W^X needs to be enforced temporally as well.

Madhavan
