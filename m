Return-Path: <kernel-hardening-return-17712-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0F75815471E
	for <lists+kernel-hardening@lfdr.de>; Thu,  6 Feb 2020 16:10:23 +0100 (CET)
Received: (qmail 15973 invoked by uid 550); 6 Feb 2020 15:10:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15953 invoked from network); 6 Feb 2020 15:10:16 -0000
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=date:from:to
	:cc:subject:message-id:references:mime-version:content-type
	:in-reply-to; s=mail; bh=hCSZI3yFG5bI3FQ2aJZ88GjlsbQ=; b=wbteIZ8
	9JNF6qqVmEPpTWwRJW+dLN1smHNE8DAyaTIIIvea+fAlYw8LPoFdsEuOdcL/qTtv
	eZY0n6RAW2Ruh57HeFIIX3rXqWaT6hDmLZpoPKoRig4OKwatJM2S94nhKgmvq8ix
	ZNYFslxrtwwxQtLCEeE+3+noy0RQqTsij91uLugcLsqjmy7ML+GfHhtq/nV5k1AI
	xx6dhqDX7UQVfEo/81on552tZQhAR8BA6LXmhBsusb2DzIurkt+6GYl8K8JU/gF4
	izZk3MHJUYgu3KFYRh1injM9RwX5c9/UF5Dbo5yjSsAB7TuHYyZIyg65q2nzJaHW
	Ssvprkwr+/GhF9g==
Date: Thu, 6 Feb 2020 16:10:01 +0100
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
To: Kristen Carlson Accardi <kristen@linux.intel.com>,
	keescook@chromium.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, keescook@chromium.org,
	rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
	jeanphilippe.aumasson@gmail.com
Subject: Re: [RFC PATCH 04/11] x86/boot/KASLR: Introduce PRNG for faster
 shuffling
Message-ID: <20200206151001.GA280489@zx2c4.com>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-5-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200205223950.1212394-5-kristen@linux.intel.com>

Hey Kees,

On Wed, Feb 05, 2020 at 02:39:43PM -0800, Kristen Carlson Accardi wrote:
> +#define rot(x, k) (((x)<<(k))|((x)>>(64-(k))))
> +static u64 prng_u64(struct prng_state *x)
> +{
> +	u64 e;
> +
> +	e = x->a - rot(x->b, 7);
> +	x->a = x->b ^ rot(x->c, 13);
> +	x->b = x->c + rot(x->d, 37);
> +	x->c = x->d + e;
> +	x->d = e + x->a;
> +
> +	return x->d;
> +}

I haven't looked closely at where the original entropy sources are
coming from and how all this works, but on first glance, this prng
doesn't look like an especially cryptographically secure one. I realize
that isn't necessarily your intention (you're focused on speed), but
actually might this be sort of important? If I understand correctly, the
objective of this patch set is so that leaking the address of one
function doesn't leak the address of all other functions, as is the case
with fixed-offset kaslr. But if you leak the addresses of _some_ set of
functions, and your prng is bogus, might it be possible to figure out
the rest? For some prngs, if you give me the output stream of a few
numbers, I can predict the rest. For others, it's not this straight
forward, but there are some varieties of similar attacks. If any of that
set of concerns turns out to apply to your prng_u64 here, would that
undermine kaslr in similar ways as the current fixed-offset variety? Or
does it not matter because it's some kind of blinded fixed-size shuffle
with complex reasoning that makes this not a problem?

Jason
