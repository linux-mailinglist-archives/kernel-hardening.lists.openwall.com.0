Return-Path: <kernel-hardening-return-17433-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E838F105EE1
	for <lists+kernel-hardening@lfdr.de>; Fri, 22 Nov 2019 04:06:40 +0100 (CET)
Received: (qmail 7591 invoked by uid 550); 22 Nov 2019 03:06:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7551 invoked from network); 22 Nov 2019 03:06:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574391982;
	bh=WHOYATGBc/KhbUsY17Xhsk4+WhbvgQ0BBAtu736vu44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=wsysb1M4c5Of6auNnd9WrnuX1d02JpYy2mPEoQ+5gjPFolt9aOvDJ6cbTtK9uowg+
	 F3B/IcMPpFYJm+VI2Tz9NzrY3GG//ps0Q2UFi7UhjzC2A/93e1c3Oiee0q/7qX97qx
	 1QSYrvkYUwciXyAbQHhi2Wmon4dgqLNThqpvPjsc=
Date: Thu, 21 Nov 2019 19:06:20 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	=?iso-8859-1?Q?Jo=E3o?= Moreira <joao.moreira@intel.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Stephan Mueller <smueller@chronox.de>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v6 8/8] crypto, x86/sha: Eliminate casts on asm
 implementations
Message-ID: <20191122030620.GD32523@sol.localdomain>
References: <20191122010334.12081-1-keescook@chromium.org>
 <20191122010334.12081-9-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122010334.12081-9-keescook@chromium.org>
User-Agent: Mutt/1.12.2 (2019-09-21)

On Thu, Nov 21, 2019 at 05:03:34PM -0800, Kees Cook wrote:
> -asmlinkage void sha1_transform_ssse3(u32 *digest, const char *data,
> -				     unsigned int rounds);
> +asmlinkage void sha1_transform_ssse3(struct sha1_state *digest,
> +				     const u8 *data, int rounds);

Can you please use:

asmlinkage void sha1_transform_ssse3(struct sha1_state *state,
				     const u8 *data, int blocks);

I.e., rename 'digest' => 'state' and 'rounds' => 'blocks'.

(Or alternatively 'sst' instead of 'state' would be okay since that's what
sha{1,256,512}_block_fn uses, but 'state' seems much clearer to me.)

Similarly for the other sha{1,256,512}_transform_*() functions.

'digest' is confusing because it would typically be understood to mean the final
digest, or maybe also the hash chaining state (e.g. u32[5] for SHA-1) if it's
interpreted loosely.  I don't think it would typically be understand to also
include buffered data like struct sha1_state does.

'rounds' is confusing because the parameter is actually the number of blocks,
not the number of rounds -- the latter being fixed for each SHA-* algorithm.
Since sha{1,256,512}_block_fn already call it 'blocks' and this patch has to
update the type of this parameter anyway, let's use that.

>  #ifdef CONFIG_AS_AVX
> -asmlinkage void sha1_transform_avx(u32 *digest, const char *data,
> -				   unsigned int rounds);
> +asmlinkage void sha1_transform_avx(struct sha1_state *digest,
> +				   const u8 *data, int rounds);
>  

This patch is also still missing updates to the corresponding comments in the
assembly files:

	sha1_transform_avx()
	sha1_transform_avx2()
	sha256_transform_avx()
	sha256_transform_rorx()
	sha512_transform_ssse3() [references to D, M, and L remain]
	sha512_transform_avx()
	sha512_transform_rorx()

FWIW, this patch is also independent from 1-7, so it could be sent out
separately if it makes things any easier for you.

Thanks,

- Eric
