Return-Path: <kernel-hardening-return-19987-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 984CD275FEA
	for <lists+kernel-hardening@lfdr.de>; Wed, 23 Sep 2020 20:32:58 +0200 (CEST)
Received: (qmail 13317 invoked by uid 550); 23 Sep 2020 18:32:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 12270 invoked from network); 23 Sep 2020 18:32:52 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C2FCF20B7179
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1600885960;
	bh=eYamxZ/9KfLziSqDZDGqyg7y9XmLAhhecaK/mPCYbeo=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=IEKAOv4CAGnJC0ocS9BKbEqfbu3dCVuW/cFUdHjlI4t7pPCt2gifpPrQEZh/AH9+R
	 6V0pnvqh/QE35boMAi5/Gc9Y99hTzFFKdtBE5V31AAbiKRFLHnNCgM4e8sTkn1d/mq
	 KWb62hF+OUSGnVGFx0w0M2JxeTlKiQXTMnTJ7lkA=
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, oleg@redhat.com, x86@kernel.org,
 luto@kernel.org, David.Laight@ACULAB.COM, fweimer@redhat.com,
 mark.rutland@arm.com, mic@digikod.net
References: <210d7cd762d5307c2aa1676705b392bd445f1baa>
 <20200922215326.4603-1-madvenka@linux.microsoft.com>
 <20200923081426.GA30279@amd>
From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <8daf09c0-1651-143b-c57c-433c850605c3@linux.microsoft.com>
Date: Wed, 23 Sep 2020 13:32:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200923081426.GA30279@amd>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit

...
>> The W^X implementation today is not complete. There exist many user level
>> tricks that can be used to load and execute dynamic code. E.g.,
>>
>> - Load the code into a file and map the file with R-X.
>>
>> - Load the code in an RW- page. Change the permissions to R--. Then,
>>   change the permissions to R-X.
>>
>> - Load the code in an RW- page. Remap the page with R-X to get a separate
>>   mapping to the same underlying physical page.
>>
>> IMO, these are all security holes as an attacker can exploit them to inject
>> his own code.
> 
> IMO, you are smoking crack^H^H very seriously misunderstanding what
> W^X is supposed to protect from.
> 
> W^X is not supposed to protect you from attackers that can already do
> system calls. So loading code into a file then mapping the file as R-X
> is in no way security hole in W^X.
> 
> If you want to provide protection from attackers that _can_ do system
> calls, fine, but please don't talk about W^X and please specify what
> types of attacks you want to prevent and why that's good thing.
> 


There are two things here - the idea behind W^X and the current realization
of that idea in actual implementation. The idea behind W^X, as I understand,
is to prevent a user from loading arbitrary code into a page and getting it
to execute. If the user code contains a vulnerability, an attacker can 
exploit it to potentially inject his own code and get it to execute. This
cannot be denied.

From that perspective, all of the above tricks I have mentioned are tricks
that user code can use to load arbitrary code into a page and get it to
execute.

Now, I don't want the discussion to be stuck in a mere name. If what I am
suggesting needs a name other than "W^X" in the opinion of the reviewers,
that is fine with me. But I don't believe there is any disagreement that
the above user tricks are security holes.

Madhavan
