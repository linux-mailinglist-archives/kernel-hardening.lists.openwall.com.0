Return-Path: <kernel-hardening-return-20371-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BBFC82AC997
	for <lists+kernel-hardening@lfdr.de>; Tue, 10 Nov 2020 01:09:48 +0100 (CET)
Received: (qmail 9920 invoked by uid 550); 10 Nov 2020 00:09:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9885 invoked from network); 10 Nov 2020 00:09:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=rzp6w6LtmUWYCvcLAbZq+3lrgpo1QeVmRmbMbPfRlA4=; b=PeY6e3zOfq5yS87w5dYJX/bGHU
	0REP48EkwsDG5m7klT2SuoL4SXj5mtINLieWT2kOXu6cJloGAgN8NfBRdfXPfJqI5on3Z93hqhNLG
	XoP6pB92jSfHtSjTjpPb76VEkGhBctEK9wofFyjmKDJnCHfNagS3jkiK1fwvrZZ8wGNG6t0QsaTDA
	KqLwapDqkD41gHfNybnPHfi+o+7N+deUWW6Chv5AtCJWsLeNvmhYgiGwo85CsY+y70Gc8ZLGGpqjs
	MQhX9+BMCIWGJVFDn7WLAyysztTMmp4xiRl47fTxGBLkvqUJc+WwFvh5xHcgA05u0wQsR/RLk1xY0
	vs2Wj6Qw==;
Subject: Re: [PATCH v2 7/8] Documentation: Add documentation for the Brute LSM
To: John Wood <john.wood@gmx.com>, Kees Cook <keescook@chromium.org>,
 Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>, James Morris <jmorris@namei.org>,
 "Serge E. Hallyn" <serge@hallyn.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
 kernel-hardening@lists.openwall.com
References: <20201025134540.3770-1-john.wood@gmx.com>
 <20201025134540.3770-8-john.wood@gmx.com>
 <2ab35578-832a-6b92-ca9b-2f7d42bc0792@infradead.org>
 <20201109182348.GA3110@ubuntu>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <e6e04af7-5445-bda9-6665-b52c72735b63@infradead.org>
Date: Mon, 9 Nov 2020 16:09:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201109182348.GA3110@ubuntu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 11/9/20 10:23 AM, John Wood wrote:
> Hi,
> Thanks for the typos corrections. Will be corrected in the next patch
> version.
> 
> On Sun, Nov 08, 2020 at 08:31:13PM -0800, Randy Dunlap wrote:
>>
>> So an app could read crash_period_threshold and just do a new fork every
>> threshold + 1 time units, right? and not be caught?
> 
> Yes, you are right. But we must set a crash_period_threshold that does not
> make an attack feasible. For example, with the default value of 30000 ms,
> an attacker can break the app only once every 30 seconds. So, to guess
> canaries or break ASLR, the attack needs a big amount of time. But it is
> possible.
> 
> So, I think that to avoid this scenario we can add a maximum number of
> faults per fork hierarchy. Then, the mitigation will be triggered if the
> application crash period falls under the period threshold or if the number
> of faults exceed the maximum commented.
> 
> This way, if an attack is of long duration, it will also be detected and
> mitigated.
> 
> What do you think?

Hi,
That sounds reasonable to me.

thanks.
-- 
~Randy

