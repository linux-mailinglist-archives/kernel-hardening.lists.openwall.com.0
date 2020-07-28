Return-Path: <kernel-hardening-return-19478-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7377E231082
	for <lists+kernel-hardening@lfdr.de>; Tue, 28 Jul 2020 19:09:07 +0200 (CEST)
Received: (qmail 28532 invoked by uid 550); 28 Jul 2020 17:09:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28509 invoked from network); 28 Jul 2020 17:09:01 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3CB1720B4908
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1595956129;
	bh=/7IJcSJkmnGhyvhTN0w/k6D0iSgWl3GbtIXdsg8Fv5A=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=ZuOaQbdU5uYtFJaEiOblvnFbeGROFNYKRjF3F43kJ1vUkhEErX0fbDaPkJowjRf06
	 4DasCLQblFzecv0eF8w7mUhf1hXAgudt5JEdU8ofWsRvm0zC9iTlBhH+fSyTWj70K7
	 RgZPV6XJ7g6uzFeyOC7P2FKqWtU5gXy/jZ/r8ZHI=
Subject: Re: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
To: James Morris <jmorris@namei.org>, Casey Schaufler <casey@schaufler-ca.com>
Cc: kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org, oleg@redhat.com, x86@kernel.org
References: <aefc85852ea518982e74b233e11e16d2e707bc32>
 <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <3fd22f92-7f45-1b0f-e4fe-857f3bceedd0@schaufler-ca.com>
 <alpine.LRH.2.21.2007290300400.31310@namei.org>
From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Message-ID: <a909e0b0-0d82-d869-fe49-cc974680ac23@linux.microsoft.com>
Date: Tue, 28 Jul 2020 12:08:48 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.2007290300400.31310@namei.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US



On 7/28/20 12:05 PM, James Morris wrote:
> On Tue, 28 Jul 2020, Casey Schaufler wrote:
>
>> You could make a separate LSM to do these checks instead of limiting
>> it to SELinux. Your use case, your call, of course.
> It's not limited to SELinux. This is hooked via the LSM API and 
> implementable by any LSM (similar to execmem, execstack etc.)

Yes. I have an implementation that I am testing right now that
defines the hook for exectramp and implements it for
SELinux. That is why I mentioned SELinux.

Madhavan
