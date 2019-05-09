Return-Path: <kernel-hardening-return-15914-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8F90D18FC7
	for <lists+kernel-hardening@lfdr.de>; Thu,  9 May 2019 19:58:44 +0200 (CEST)
Received: (qmail 19726 invoked by uid 550); 9 May 2019 17:58:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19699 invoked from network); 9 May 2019 17:58:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557424705;
	bh=YiJk2tcPpKphUTjpD3Gqc+Ugt+DTuVzY4k6rDbHx4ik=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kLhYb3t9rHIfD5eNfgXKr9ZSLJTKa3rk6SclZMQQB3lM2zCM0vL9nE4oAc1cajvTV
	 PJ8k9vHRyJn24LkV6GhhVH3FNf/EoPLmMsykM3aksm+WQ9MuKJy3W8ZxLRyaW0DF4Q
	 7ScecLU+GXWKWbA+r+6GIzaspWZSDKK3nTgstZ0Y=
Date: Thu, 9 May 2019 10:58:23 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Kees Cook <keescook@chromium.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Joao Moreira <jmoreira@suse.de>, Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>,
	linux-crypto <linux-crypto@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH v3 0/7] crypto: x86: Fix indirect function call casts
Message-ID: <20190509175822.GB12602@gmail.com>
References: <20190507161321.34611-1-keescook@chromium.org>
 <20190507170039.GB1399@sol.localdomain>
 <CAGXu5jL7pWWXuJMinghn+3GjQLLBYguEtwNdZSQy++XGpGtsHQ@mail.gmail.com>
 <20190507215045.GA7528@sol.localdomain>
 <20190508133606.nsrzthbad5kynavp@gondor.apana.org.au>
 <CAGXu5jKdsuzX6KF74zAYw3PpEf8DExS9P0Y_iJrJVS+goHFbcA@mail.gmail.com>
 <20190509020439.GB693@sol.localdomain>
 <20190509153828.GA261205@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509153828.GA261205@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, May 09, 2019 at 08:38:28AM -0700, Sami Tolvanen wrote:
> On Wed, May 08, 2019 at 07:04:40PM -0700, Eric Biggers wrote:
> > And I also asked whether indirect calls to asm code are even allowed
> > with CFI. IIRC, the AOSP kernels have been patched to remove them from
> > arm64
> 
> At least with clang, indirect calls to stand-alone assembly functions
> trip CFI checks, which is why Android kernels use static inline stubs
> to convert these to direct calls instead.
> 
> Sami

Thanks Sami.  Is there any way to annotate assembly functions such that they
work directly with CFI?  Otherwise, we need the wrapper functions.

Kees and Joao, it would be helpful if you'd explain this in the patchset.

- Eric
