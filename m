Return-Path: <kernel-hardening-return-15895-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 31A5A16D4C
	for <lists+kernel-hardening@lfdr.de>; Tue,  7 May 2019 23:51:07 +0200 (CEST)
Received: (qmail 21764 invoked by uid 550); 7 May 2019 21:51:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 21743 invoked from network); 7 May 2019 21:51:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557265848;
	bh=zwUU7Cwiyys6DAoOpuq7iSsRZqfkjqn6hEoJovHAlwE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Rqnk5JzDrfY9glVqL1a7PcVtn6erwFFmSp9rNpcGHp4qUmLK6E1B00oWj5k0+NbNl
	 wZxhQXcg4F2SrSPKeFCoh46WsmySBgok6IaMTz7Qd8f4m+3Bzf61xkG03YhKehGAhe
	 1nPmbAaywKzyiSwXkobbL+yuNKnOChPtEKEzdhS4=
Date: Tue, 7 May 2019 14:50:46 -0700
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
Message-ID: <20190507215045.GA7528@sol.localdomain>
References: <20190507161321.34611-1-keescook@chromium.org>
 <20190507170039.GB1399@sol.localdomain>
 <CAGXu5jL7pWWXuJMinghn+3GjQLLBYguEtwNdZSQy++XGpGtsHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jL7pWWXuJMinghn+3GjQLLBYguEtwNdZSQy++XGpGtsHQ@mail.gmail.com>
User-Agent: Mutt/1.11.4 (2019-03-13)

On Tue, May 07, 2019 at 02:07:51PM -0700, Kees Cook wrote:
> On Tue, May 7, 2019 at 10:00 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > > Given the above, the current efforts to improve the Linux security,
> > > and the upcoming kernel support to compilers with CFI features, this
> > > creates macros to be used to build the needed function definitions,
> > > to be used in camellia, cast6, serpent, twofish, and aesni.
> >
> > So why not change the function prototypes to be compatible with common_glue_*_t
> > instead, rather than wrapping them with another layer of functions?  Is it
> > because indirect calls into asm code won't be allowed with CFI?
> 
> I don't know why they're not that way to begin with. But given that
> the casting was already happening, this is just moving it to a place
> where CFI won't be angry. :)
> 
> > >   crypto: x86/crypto: Use new glue function macros
> >
> > This one should be "x86/serpent", not "x86/crypto".
> 
> Oops, yes, that's my typo. I'll fix for v4. Do the conversions
> themselves look okay (the changes are pretty mechanical)? If so,
> Herbert, do you want a v4 with the typo fix, or do you want to fix
> that up yourself?
> 
> Thanks!
> 

I don't know yet.  It's difficult to read the code with 2 layers of macros.

Hence why I asked why you didn't just change the prototypes to be compatible.

- Eric
