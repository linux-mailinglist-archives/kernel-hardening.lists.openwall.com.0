Return-Path: <kernel-hardening-return-17357-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 16A37FB8E8
	for <lists+kernel-hardening@lfdr.de>; Wed, 13 Nov 2019 20:32:21 +0100 (CET)
Received: (qmail 17872 invoked by uid 550); 13 Nov 2019 19:32:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17826 invoked from network); 13 Nov 2019 19:32:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1573673522;
	bh=p2R66Qr9Knh83ZMoA5/z+qkNmGkrzoOC39Y7a8H0i/U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UEDj8O7AW9YYX8AsRmg107HuLbl3JLS4aW01z3Il0AZN+l09sb8H5pXI6iPgsShx7
	 yoK4b/zx7oa1t4wVtRNyObfMP913nO9LHxHEHCuZAjEtnJ6T48DKR6E7mbk0sATbab
	 4VbqvHwWYLqguOMzMbQEMHBZBrjTN1F8e8GqJdso=
Date: Wed, 13 Nov 2019 11:32:00 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	=?iso-8859-1?Q?Jo=E3o?= Moreira <joao.moreira@intel.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Stephan Mueller <smueller@chronox.de>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v5 6/8] crypto: x86/aesni: Remove glue function macro
 usage
Message-ID: <20191113193159.GA221701@gmail.com>
Mail-Followup-To: Kees Cook <keescook@chromium.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	=?iso-8859-1?Q?Jo=E3o?= Moreira <joao.moreira@intel.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Stephan Mueller <smueller@chronox.de>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
References: <20191113182516.13545-1-keescook@chromium.org>
 <20191113182516.13545-7-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113182516.13545-7-keescook@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Nov 13, 2019 at 10:25:14AM -0800, Kees Cook wrote:
> In order to remove the callsite function casts, regularize the function
> prototypes for helpers to avoid triggering Control-Flow Integrity checks
> during indirect function calls. Where needed, to avoid changes to
> pointer math, u8 pointers are internally cast back to u128 pointers.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/x86/crypto/aesni-intel_glue.c | 45 +++++++++++++-----------------
>  1 file changed, 19 insertions(+), 26 deletions(-)
> 
> diff --git a/arch/x86/crypto/aesni-intel_glue.c b/arch/x86/crypto/aesni-intel_glue.c
> index 3e707e81afdb..f47afa5ae8ca 100644
> --- a/arch/x86/crypto/aesni-intel_glue.c
> +++ b/arch/x86/crypto/aesni-intel_glue.c
> @@ -83,10 +83,8 @@ struct gcm_context_data {
>  
>  asmlinkage int aesni_set_key(struct crypto_aes_ctx *ctx, const u8 *in_key,
>  			     unsigned int key_len);
> -asmlinkage void aesni_enc(struct crypto_aes_ctx *ctx, u8 *out,
> -			  const u8 *in);
> -asmlinkage void aesni_dec(struct crypto_aes_ctx *ctx, u8 *out,
> -			  const u8 *in);
> +asmlinkage void aesni_enc(void *ctx, u8 *out, const u8 *in);
> +asmlinkage void aesni_dec(void *ctx, u8 *out, const u8 *in);
>  asmlinkage void aesni_ecb_enc(struct crypto_aes_ctx *ctx, u8 *out,
>  			      const u8 *in, unsigned int len);
>  asmlinkage void aesni_ecb_dec(struct crypto_aes_ctx *ctx, u8 *out,
> @@ -107,7 +105,7 @@ asmlinkage void aesni_ctr_enc(struct crypto_aes_ctx *ctx, u8 *out,
>  			      const u8 *in, unsigned int len, u8 *iv);
>  
>  asmlinkage void aesni_xts_crypt8(struct crypto_aes_ctx *ctx, u8 *out,
> -				 const u8 *in, bool enc, u8 *iv);
> +				 const u8 *in, bool enc, le128 *iv);

These functions in aesni-intel_asm.S have comments that show the function
prototypes.  Can you please keep them in sync?

> -static void aesni_xts_tweak(void *ctx, u8 *out, const u8 *in)
> +static void aesni_xts_enc(void *ctx, u8 *dst, const u8 *src, le128 *iv)
>  {
> -	aesni_enc(ctx, out, in);
> +	glue_xts_crypt_128bit_one(ctx, (u128 *)dst, (const u128 *)src, iv,
> +				  aesni_enc);
>  }

For the src and dst, how about making glue_xts_crypt_128bit_one() take u8
instead of u128?  That would avoid having to add these u8 => u128 casts to all
10 callers of glue_xts_crypt_128bit_one().

- Eric
