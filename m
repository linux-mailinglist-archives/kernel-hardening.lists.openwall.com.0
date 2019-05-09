Return-Path: <kernel-hardening-return-15910-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E399918408
	for <lists+kernel-hardening@lfdr.de>; Thu,  9 May 2019 05:16:58 +0200 (CEST)
Received: (qmail 22463 invoked by uid 550); 9 May 2019 03:16:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22437 invoked from network); 9 May 2019 03:16:51 -0000
Date: Thu, 9 May 2019 11:16:25 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Joao Moreira <jmoreira@suse.de>
Cc: Eric Biggers <ebiggers@kernel.org>, Kees Cook <keescook@chromium.org>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH v3 0/7] crypto: x86: Fix indirect function call casts
Message-ID: <20190509031625.f6usxmqzfehrmx7r@gondor.apana.org.au>
References: <20190507161321.34611-1-keescook@chromium.org>
 <20190507170039.GB1399@sol.localdomain>
 <CAGXu5jL7pWWXuJMinghn+3GjQLLBYguEtwNdZSQy++XGpGtsHQ@mail.gmail.com>
 <20190507215045.GA7528@sol.localdomain>
 <20190508133606.nsrzthbad5kynavp@gondor.apana.org.au>
 <CAGXu5jKdsuzX6KF74zAYw3PpEf8DExS9P0Y_iJrJVS+goHFbcA@mail.gmail.com>
 <20190509020439.GB693@sol.localdomain>
 <8c9a53b9-12e6-3380-21c8-4fe85342f0ac@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c9a53b9-12e6-3380-21c8-4fe85342f0ac@suse.de>
User-Agent: NeoMutt/20170113 (1.7.2)

On Thu, May 09, 2019 at 12:12:54AM -0300, Joao Moreira wrote:
>
> This is how things were done in the original patch set, but some concerns
> were raised about this approach:
> 
> https://lkml.org/lkml/2018/4/16/74

No that's not what I'm suggesting at all.  Just get rid of those
wrapper functions and change the underlying asm functions to take
a void *.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
