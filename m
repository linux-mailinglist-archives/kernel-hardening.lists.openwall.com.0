Return-Path: <kernel-hardening-return-15908-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 09C1D1838E
	for <lists+kernel-hardening@lfdr.de>; Thu,  9 May 2019 04:05:00 +0200 (CEST)
Received: (qmail 32393 invoked by uid 550); 9 May 2019 02:04:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32366 invoked from network); 9 May 2019 02:04:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557367482;
	bh=znO1N4UgeT7juzLezaDsDsXDpIojNyGSb5KuszeYBLQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i5x4EIRcwWtIsiVqkXftBLit52Wbl8qQng+6DxaLqgqGo3HVH5jYxAQnjXD7tEzLp
	 aGnEDrHBvbtPTpWVxfAueOYlQHRMAQYzYmAEXut5cCjJky3KXbe0iW81rTzOb14ort
	 g5M50eldEf4Ytahb1Sn4R428dxR3h1Sb34Vh+WYQ=
Date: Wed, 8 May 2019 19:04:40 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Joao Moreira <jmoreira@suse.de>, Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH v3 0/7] crypto: x86: Fix indirect function call casts
Message-ID: <20190509020439.GB693@sol.localdomain>
References: <20190507161321.34611-1-keescook@chromium.org>
 <20190507170039.GB1399@sol.localdomain>
 <CAGXu5jL7pWWXuJMinghn+3GjQLLBYguEtwNdZSQy++XGpGtsHQ@mail.gmail.com>
 <20190507215045.GA7528@sol.localdomain>
 <20190508133606.nsrzthbad5kynavp@gondor.apana.org.au>
 <CAGXu5jKdsuzX6KF74zAYw3PpEf8DExS9P0Y_iJrJVS+goHFbcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKdsuzX6KF74zAYw3PpEf8DExS9P0Y_iJrJVS+goHFbcA@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)

On Wed, May 08, 2019 at 02:08:25PM -0700, Kees Cook wrote:
> On Wed, May 8, 2019 at 6:36 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > On Tue, May 07, 2019 at 02:50:46PM -0700, Eric Biggers wrote:
> > >
> > > I don't know yet.  It's difficult to read the code with 2 layers of macros.
> > >
> > > Hence why I asked why you didn't just change the prototypes to be compatible.
> >
> > I agree.  Kees, since you're changing this anyway please make it
> > look better not worse.
> 
> Do you mean I should use the typedefs in the new macros? I'm not aware
> of a way to use a typedef to declare a function body, so I had to
> repeat them. I'm open to suggestions!
> 
> As far as "fixing the prototypes", the API is agnostic of the context
> type, and uses void *. And also it provides a way to call the same
> function with different pointer types on the other arguments:
> 
> For example, quoting the existing code:
> 
> asmlinkage void twofish_dec_blk(struct twofish_ctx *ctx, u8 *dst,
>                                 const u8 *src);
> 
> Which is used for ecb and cbc:
> 
> #define GLUE_FUNC_CAST(fn) ((common_glue_func_t)(fn))
> #define GLUE_CBC_FUNC_CAST(fn) ((common_glue_cbc_func_t)(fn))
> ...
> static const struct common_glue_ctx twofish_dec = {
> ...
>                 .fn_u = { .ecb = GLUE_FUNC_CAST(twofish_dec_blk) }
> 
> static const struct common_glue_ctx twofish_dec_cbc = {
> ...
>                 .fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_dec_blk) }
> 
> which have different prototypes:
> 
> typedef void (*common_glue_func_t)(void *ctx, u8 *dst, const u8 *src);
> typedef void (*common_glue_cbc_func_t)(void *ctx, u128 *dst, const u128 *src);
> ...
> struct common_glue_func_entry {
>         unsigned int num_blocks; /* number of blocks that @fn will process */
>         union {
>                 common_glue_func_t ecb;
>                 common_glue_cbc_func_t cbc;
>                 common_glue_ctr_func_t ctr;
>                 common_glue_xts_func_t xts;
>         } fn_u;
> };
> 

As Herbert said, the ctx parameters could be made 'void *'.

And I also asked whether indirect calls to asm code are even allowed with CFI.
IIRC, the AOSP kernels have been patched to remove them from arm64.  It would be
helpful if you would answer that question, since it would inform the best
approach here.

As for the "ecb" functions taking 'u8 *' but the "cbc" ones taking 'u128 *' and
the same function being used in the blocks==1 case, you could just pick one of
the types to use for both.  'u8 *' probably makes more sense since both ecb and
cbc operate on blocks of 16 bytes but don't interpret them as 128-bit integers.

- Eric
