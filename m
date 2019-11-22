Return-Path: <kernel-hardening-return-17432-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3BE93105E95
	for <lists+kernel-hardening@lfdr.de>; Fri, 22 Nov 2019 03:21:24 +0100 (CET)
Received: (qmail 25694 invoked by uid 550); 22 Nov 2019 02:21:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25657 invoked from network); 22 Nov 2019 02:21:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574389266;
	bh=Bmw3dilrhOSB2KEzqqUzCdnYmuPbOsPuYjwQA42dvLs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GaABxv3D3oik8n+/v9lZqt6E0icOZlfY85tHCu1TWZXx+4L5ip4bIu2QQ+QSHcYfg
	 zazTIZgOJ85ifILklKnReN1XMXFOsXuuy+ISetvz5c+eV5i1225W/tDfBbWZBfBEsh
	 mImvl7ntrBZvFtvTN6E9TRvzCgtr8MXAGTUj+bAY=
Date: Thu, 21 Nov 2019 18:21:04 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	=?iso-8859-1?Q?Jo=E3o?= Moreira <joao.moreira@intel.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Stephan Mueller <smueller@chronox.de>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v6 0/8] crypto: x86: Fix indirect function call casts
Message-ID: <20191122022104.GC32523@sol.localdomain>
References: <20191122010334.12081-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191122010334.12081-1-keescook@chromium.org>
User-Agent: Mutt/1.12.2 (2019-09-21)

On Thu, Nov 21, 2019 at 05:03:26PM -0800, Kees Cook wrote:
> v6:
> - minimize need for various internal casts (ebiggers)
> - clarify comments (ebiggers)
> - switch all context pointers to const (ebiggers)
> v5: https://lore.kernel.org/lkml/20191113182516.13545-1-keescook@chromium.org
> v4: https://lore.kernel.org/lkml/20191111214552.36717-1-keescook@chromium.org
> v3: https://lore.kernel.org/lkml/20190507161321.34611-1-keescook@chromium.org
> 
> Hi,
> 
> Now that Clang's CFI has been fixed to do the right thing with extern
> asm functions, this patch series is much simplified. Repeating patch
> 1's commit log here:
> 
>     The crypto glue performed function prototype casting to make indirect
>     calls to assembly routines. Instead of performing casts at the call
>     sites (which trips Control Flow Integrity prototype checking), switch
>     each prototype to a common standard set of arguments which allows the
>     incremental removal of the existing macros. In order to keep pointer
>     math unchanged, internal casting between u128 pointers and u8 pointers
>     is added.
> 
> With this series (and the Clang LTO+CFI series) I am able to boot x86
> with all crytpo selftests enabled without tripping any CFI checks.
> 
> Thanks!
> 
> -Kees
> 
> Kees Cook (8):
>   crypto: x86/glue_helper: Regularize function prototypes
>   crypto: x86/serpent: Remove glue function macros usage
>   crypto: x86/camellia: Remove glue function macro usage
>   crypto: x86/twofish: Remove glue function macro usage
>   crypto: x86/cast6: Remove glue function macro usage
>   crypto: x86/aesni: Remove glue function macro usage
>   crypto: x86/glue_helper: Remove function prototype cast helpers
>   crypto, x86/sha: Eliminate casts on asm implementations

This patchset doesn't actually compile until patch 6/8, due to
-Werror=incompatible-pointer-types in the kernel's top-level Makefile.  It's
generally expected that every kernel commit compiles, and I'm not sure it's a
good idea to allow any exceptions.

The easiest solution would be to just squash the first 6 patches together into
one big patch.

Alternatively, 'ccflags-y := -Wno-error=incompatible-pointer-types' could be
added to arch/x86/crypto/Makefile in patch 1 and removed in patch 7.

- Eric
