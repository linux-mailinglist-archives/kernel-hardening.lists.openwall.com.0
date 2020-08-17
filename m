Return-Path: <kernel-hardening-return-19642-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B9A3F24636D
	for <lists+kernel-hardening@lfdr.de>; Mon, 17 Aug 2020 11:33:31 +0200 (CEST)
Received: (qmail 11447 invoked by uid 550); 17 Aug 2020 09:33:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11417 invoked from network); 17 Aug 2020 09:33:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=1xQYs0Te2rfMJwjhbxsaCOgB/6GQdcnFRY7QjfAiQ3o=;
        b=ED64gzeg/M7EX+2k74ana8HeT9sotJMGEusKfdaM4E/ytYYzZ+v/Fol3t27iW5w8yC
         OsBfBZ3whC3TmnmJ2xz1oAkRx4zHI7FI3qxEs0pI58H6KD+RT3lzjA92C8sJz05/um2u
         i3rngDwyuqpTswvMcJIR3ZpfxudIAwLmfKLks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1xQYs0Te2rfMJwjhbxsaCOgB/6GQdcnFRY7QjfAiQ3o=;
        b=JdKB09AmdlMFaRPhQayIHWq2BVsPD+bTjLfMSLolbQUPRpYPZmZCtFsfoi1rFJOac5
         /xgri9H7RjmUew7R1BcbUZE+sxpfSidrwcKq8U8yB20b7+5twgnWagilAvg41Ax0p2I5
         usRQP9CeOWuugbpVkUaDvQ3nacoK8/hRgkpgcFtt8Q9dl3fDp/u4aA9sAznCG7txy7et
         n/Oa+f+zaNoUDe5ygdtPWUjb/6TV3rqkwYUNtfBOP1sqac4yKyPdhixPJOgtjtYdj2Zz
         GszV3RwKTv9TSw1evpss711QI98NUtKQAB80nH4Kp0hbeY3rsk9mDkFuejSw4oqEArrS
         CDpA==
X-Gm-Message-State: AOAM532QiSRiLCynSFBclnAQSrMqONYw4nbMD3OJojwzcJcWdiCRdNZw
	bv2Pa+qusz94OrTOk59D2TrwCMo+7lspR0mD
X-Google-Smtp-Source: ABdhPJxf00b006Rln3mYlmymeUaXVm7P/IAFcx4EI3zWi9TVRNkruBZ044jZhMqhfnV70FZ5TW4BLw==
X-Received: by 2002:aa7:c259:: with SMTP id y25mr13745873edo.130.1597656793769;
        Mon, 17 Aug 2020 02:33:13 -0700 (PDT)
Subject: Re: [PATCH v2] overflow: Add __must_check attribute to check_*()
 helpers
To: dsterba@suse.cz, Kees Cook <keescook@chromium.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
 kernel-hardening@lists.openwall.com
References: <202008151007.EF679DF@keescook>
 <20200817090854.GA2026@twin.jikos.cz>
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <5da1506d-1627-a882-724d-057641791ccb@rasmusvillemoes.dk>
Date: Mon, 17 Aug 2020 11:33:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200817090854.GA2026@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 17/08/2020 11.08, David Sterba wrote:
> On Sat, Aug 15, 2020 at 10:09:24AM -0700, Kees Cook wrote:
>>  
>> +/*
>> + * Allows for effectively applying __must_check to a macro so we can have
>> + * both the type-agnostic benefits of the macros while also being able to
>> + * enforce that the return value is, in fact, checked.
>> + */
>> +static inline bool __must_check __must_check_overflow(bool overflow)
>> +{
>> +	return unlikely(overflow);
> 
> How does the 'unlikely' hint propagate through return? It is in a static
> inline so compiler has complete information in order to use it, but I'm
> curious if it actually does.

I wondered the same thing, but as I noted in a reply in the v1 thread,
that pattern is used in kernel/sched/, and the scheduler is a far more
critical path than anywhere these might be used, so if it's good enough
for kernel/sched/, it should be good enough here. I have no idea how one
could write a piece of non-trivial code to see if the hint actually
makes a difference.

> 
> In case the hint gets dropped, the fix would probably be
> 
> #define check_add_overflow(a, b, d) unlikely(__must_check_overflow(({	\
>  	typeof(a) __a = (a);			\
>  	typeof(b) __b = (b);			\
>  	typeof(d) __d = (d);			\
>  	(void) (&__a == &__b);			\
>  	(void) (&__a == __d);			\
>  	__builtin_add_overflow(__a, __b, __d);	\
> })))
> 

Well, maybe, but I'd be a little worried that the !! that unlikely()
slabs on its argument may count as a use of that argument, hence
nullifying the __must_check which is the main point - the unlikely just
being something we can add for free while touching this code. Haven't
tested it, though.

Rasmus
