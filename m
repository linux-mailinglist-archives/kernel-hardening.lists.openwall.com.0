Return-Path: <kernel-hardening-return-17645-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C49B714E902
	for <lists+kernel-hardening@lfdr.de>; Fri, 31 Jan 2020 07:58:33 +0100 (CET)
Received: (qmail 4024 invoked by uid 550); 31 Jan 2020 06:58:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3990 invoked from network); 31 Jan 2020 06:58:28 -0000
Authentication-Results: localhost; dkim=pass
	reason="1024-bit key; insecure key"
	header.d=c-s.fr header.i=@c-s.fr header.b=jTZK3fEZ; dkim-adsp=pass;
	dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
	t=1580453895; bh=E/UTGg1s6b1EYySKa+amKSGPOfF0kUbXPz2zxvIF7cg=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=jTZK3fEZYE6QtuREWRsaTnslBL9ihw9XPwf4Edt2vBlM2x00xoUnbwKN4NDbsaxbY
	 wp3Dmd2jnsnWrHOYKD3qWZL/Q2l+IESBAsZJczmCo2kQY8GolXsCzlejesZFBXFn5q
	 i/drXngqIiYsyxR2Vzbe11BWcYLeUOEIwha/Z4SA=
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [PATCH] lkdtm: Test KUAP directional user access unlocks on
 powerpc
To: Russell Currey <ruscur@russell.cc>, keescook@chromium.org,
 mpe@ellerman.id.au
Cc: linux-kernel@vger.kernel.org, dja@axtens.net,
 kernel-hardening@lists.openwall.com, linuxppc-dev@lists.ozlabs.org
References: <20200131053157.22463-1-ruscur@russell.cc>
 <1b40cea6-0675-731a-58b1-bdc65f1e495e@c-s.fr>
 <0b016861756cbe27e66651b5c21229a06558cb57.camel@russell.cc>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <c05a4327-0c81-0e3e-d93a-9d62183b146c@c-s.fr>
Date: Fri, 31 Jan 2020 07:58:16 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <0b016861756cbe27e66651b5c21229a06558cb57.camel@russell.cc>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit



Le 31/01/2020 à 07:53, Russell Currey a écrit :
> On Fri, 2020-01-31 at 07:44 +0100, Christophe Leroy wrote:
>>
>> Le 31/01/2020 à 06:31, Russell Currey a écrit :
>>> +	pr_info("attempting bad read at %px with write allowed\n",
>>> ptr);
>>> +	tmp = *ptr;
>>> +	tmp += 0xc0dec0de;
>>> +	prevent_write_to_user(ptr, sizeof(unsigned long));
>>
>> Does it work ? I would have thought that if the read fails the
>> process
>> will die and the following test won't be performed.
> 
> Correct, the ACCESS_USERSPACE test does the same thing.  Splitting this
> into separate R and W tests makes sense, even if it is unlikely that
> one would be broken without the other.
> 

Or once we are using user_access_begin() stuff, we can use 
unsafe_put_user() and unsafe_get_user() which should return an error 
instead of killing the caller.

Christophe
