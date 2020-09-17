Return-Path: <kernel-hardening-return-19909-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 20A6C26E01B
	for <lists+kernel-hardening@lfdr.de>; Thu, 17 Sep 2020 17:57:41 +0200 (CEST)
Received: (qmail 7554 invoked by uid 550); 17 Sep 2020 15:57:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7532 invoked from network); 17 Sep 2020 15:57:33 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0C12120B7178
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1600358241;
	bh=gUfIqFqpkrN0miyEH74CDfja3bpQECkvCujVL/Nljqg=;
	h=Subject:From:To:Cc:References:Date:In-Reply-To:From;
	b=Bap21mAvyeJKL22S4sguYInURgSgiXufpOk5kqSzqijlzRcX3iHUIe82IA0u8e5iF
	 HUp6Jh7UtZquNUVfdaJKc5R07sTADe2RHBpUNCP9wEbiLC2OnHb/EKxDlG4YI6Xwcj
	 FLLh69Sze7efG1K6kw3QGbPypJvP6/2ulwQipahs=
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
To: Florian Weimer <fw@deneb.enyo.de>
Cc: kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, oleg@redhat.com, x86@kernel.org,
 libffi-discuss@sourceware.org
References: <20200916150826.5990-1-madvenka@linux.microsoft.com>
 <87v9gdz01h.fsf@mid.deneb.enyo.de>
 <96ea02df-4154-5888-1669-f3beeed60b33@linux.microsoft.com>
Message-ID: <d96b87ed-9869-c732-9938-a1c717a065f3@linux.microsoft.com>
Date: Thu, 17 Sep 2020 10:57:20 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <96ea02df-4154-5888-1669-f3beeed60b33@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit



On 9/17/20 10:36 AM, Madhavan T. Venkataraman wrote:
>>> libffi
>>> ======
>>>
>>> I have implemented my solution for libffi and provided the changes for
>>> X86 and ARM, 32-bit and 64-bit. Here is the reference patch:
>>>
>>> http://linux.microsoft.com/~madvenka/libffi/libffi.v2.txt
>> The URL does not appear to work, I get a 403 error.
> I apologize for that. That site is supposed to be accessible publicly.
> I will contact the administrator and get this resolved.
> 
> Sorry for the annoyance.
> 

Could you try the link again and confirm that you can access it?
Again, sorry for the trouble.

Madhavan
