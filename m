Return-Path: <kernel-hardening-return-17418-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 45D5F105CD0
	for <lists+kernel-hardening@lfdr.de>; Thu, 21 Nov 2019 23:45:48 +0100 (CET)
Received: (qmail 9680 invoked by uid 550); 21 Nov 2019 22:45:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9640 invoked from network); 21 Nov 2019 22:45:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NLz8kBduJ9FRPrkOWrULO0u5MGm5tgSgst04YXoyCPU=;
        b=P11PcsYdx77RuFgGyC06CQKzVX3DdP56J5tlxf5wdv/z+QSa459zis/2f+GGQHGH1x
         IPGvcZrqGPYLTpz3rfeaHfVWa+NmRjJ6QW2ejIDIzFBxNblRFQ0F1x0Qb+FWw98haQCb
         fPhMWZuOulCfCaWchT4nNn3P+yDhGa/cfqmKc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NLz8kBduJ9FRPrkOWrULO0u5MGm5tgSgst04YXoyCPU=;
        b=IAhaMbsxvojtnm7wAYVqKom0VrerUvioDm8cANPRtTC1yUKpKpUY5RRiStiJLI4E9L
         oGQ+t5I09qYOcAFYuUhwqOmfgDxSgRKp9Da3+wjinpmXmiLuS/2n6nLnPaVp/K5LUOX/
         G2NX7PtqVE20xVfWsn4Dbh0CQCbxkqStn6DJ3yqJCguMSTUUf002MLxdsfZfQ4SOnj9x
         Ab+fCzPxV2g9pIOipSQ7qldkUTV5Em5NQVVkCIpiGqpqLLv0poRB5WFHBihp1HyMPgN6
         wLwrYMlSeYahDaa969OykNPH7zkq863AbqZzPicOL8xeFsYV3HLPxSjvXc/1cV6Sbc9k
         826Q==
X-Gm-Message-State: APjAAAWnp+rJGdaO3dhFBrNENYrlsEx1R93c47p5RWpGWr980C3E2kdT
	W8SgyF2aDFxaGV8/cvXgHFu3aw==
X-Google-Smtp-Source: APXvYqwqJs9lM/zsQjIHM1WnY03LC1E54t3cRzzuRCm7DgdRYqBOI/BlaHjhl3bUoQBbqAUojSgk1g==
X-Received: by 2002:a17:90a:ba89:: with SMTP id t9mr14885631pjr.29.1574376329072;
        Thu, 21 Nov 2019 14:45:29 -0800 (PST)
Date: Thu, 21 Nov 2019 14:45:26 -0800
From: Kees Cook <keescook@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	=?iso-8859-1?Q?Jo=E3o?= Moreira <joao.moreira@intel.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Stephan Mueller <smueller@chronox.de>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v5 2/8] crypto: x86/serpent: Remove glue function macros
 usage
Message-ID: <201911211444.01B61BEB7@keescook>
References: <20191113182516.13545-1-keescook@chromium.org>
 <20191113182516.13545-3-keescook@chromium.org>
 <20191113193428.GB221701@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191113193428.GB221701@gmail.com>

On Wed, Nov 13, 2019 at 11:34:29AM -0800, Eric Biggers wrote:
> On Wed, Nov 13, 2019 at 10:25:10AM -0800, Kees Cook wrote:
> > diff --git a/arch/x86/include/asm/crypto/serpent-sse2.h b/arch/x86/include/asm/crypto/serpent-sse2.h
> > index 1a345e8a7496..491a5a7d4e15 100644
> > --- a/arch/x86/include/asm/crypto/serpent-sse2.h
> > +++ b/arch/x86/include/asm/crypto/serpent-sse2.h
> > @@ -41,8 +41,7 @@ asmlinkage void __serpent_enc_blk_8way(struct serpent_ctx *ctx, u8 *dst,
> >  asmlinkage void serpent_dec_blk_8way(struct serpent_ctx *ctx, u8 *dst,
> >  				     const u8 *src);
> >  
> > -static inline void serpent_enc_blk_xway(struct serpent_ctx *ctx, u8 *dst,
> > -				   const u8 *src)
> > +static inline void serpent_enc_blk_xway(void *ctx, u8 *dst, const u8 *src)
> >  {
> >  	__serpent_enc_blk_8way(ctx, dst, src, false);
> >  }
> > @@ -53,8 +52,7 @@ static inline void serpent_enc_blk_xway_xor(struct serpent_ctx *ctx, u8 *dst,
> >  	__serpent_enc_blk_8way(ctx, dst, src, true);
> >  }
> >  
> > -static inline void serpent_dec_blk_xway(struct serpent_ctx *ctx, u8 *dst,
> > -				   const u8 *src)
> > +static inline void serpent_dec_blk_xway(void *ctx, u8 *dst, const u8 *src)
> >  {
> >  	serpent_dec_blk_8way(ctx, dst, src);
> >  }
> 
> Please read this whole file --- these functions are also defined under an #ifdef
> CONFIG_X86_32 block, so that part needs to be updated too.

Whoops, yes, thank you! I'll add a 32-bit build to my allmodconfig test.
:)

-- 
Kees Cook
