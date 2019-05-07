Return-Path: <kernel-hardening-return-15893-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D215D168A0
	for <lists+kernel-hardening@lfdr.de>; Tue,  7 May 2019 19:01:01 +0200 (CEST)
Received: (qmail 32179 invoked by uid 550); 7 May 2019 17:00:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32153 invoked from network); 7 May 2019 17:00:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557248443;
	bh=G+qb4mTZZf1+K60slYyfU+u7qCcmQIGix5qa5oI84So=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=w8MinZXn3uyE4T4a8rqFyPszmf9okXiIhTuBUQIyeVHWtqh/KNbEZvZQXnWOtXcyJ
	 KM1VyZ9uKbx5Jz4uAoJ+pjB/6v+ON5dBLtJReyJ6CzD/gzfXV+TwnB1Br4o+YXhrAI
	 EM35u4+lXLDbn03vngyg40yRK5SxfUAqxUvFlOzQ=
Date: Tue, 7 May 2019 10:00:41 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	Joao Moreira <jmoreira@suse.de>, Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v3 0/7] crypto: x86: Fix indirect function call casts
Message-ID: <20190507170039.GB1399@sol.localdomain>
References: <20190507161321.34611-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507161321.34611-1-keescook@chromium.org>
User-Agent: Mutt/1.11.4 (2019-03-13)

On Tue, May 07, 2019 at 09:13:14AM -0700, Kees Cook wrote:
> It is possible to indirectly invoke functions with prototypes that do
> not match those of the respectively used function pointers by using void
> types or casts. This feature is frequently used as a way of relaxing
> function invocation, making it possible that different data structures
> are passed to different functions through the same pointer.
> 
> Despite the benefits, this can lead to a situation where functions with a
> given prototype are invoked by pointers with a different prototype. This
> is undesirable as it may prevent the use of heuristics such as prototype
> matching-based Control-Flow Integrity, which can be used to prevent
> ROP-based attacks.
> 
> One way of fixing this situation is through the use of inline helper
> functions with prototypes that match the one in the respective invoking
> pointer.
> 
> Given the above, the current efforts to improve the Linux security,
> and the upcoming kernel support to compilers with CFI features, this
> creates macros to be used to build the needed function definitions,
> to be used in camellia, cast6, serpent, twofish, and aesni.

So why not change the function prototypes to be compatible with common_glue_*_t
instead, rather than wrapping them with another layer of functions?  Is it
because indirect calls into asm code won't be allowed with CFI?

> 
> -Kees (and Joao)
> 
> v3:
> - no longer RFC
> - consolidate macros into glue_helper.h
> - include aesni which was using casts as well
> - remove XTS_TWEAK_CAST while we're at it
> 
> v2:
> - update cast macros for clarity
> 
> v1:
> - initial prototype
> 
> Joao Moreira (4):
>   crypto: x86/crypto: Use new glue function macros

This one should be "x86/serpent", not "x86/crypto".

>   crypto: x86/camellia: Use new glue function macros
>   crypto: x86/twofish: Use new glue function macros
>   crypto: x86/cast6: Use new glue function macros
> 
> Kees Cook (3):
>   crypto: x86/glue_helper: Add static inline function glue macros
>   crypto: x86/aesni: Use new glue function macros
>   crypto: x86/glue_helper: Remove function prototype cast helpers
> 
>  arch/x86/crypto/aesni-intel_glue.c         | 31 ++++-----
>  arch/x86/crypto/camellia_aesni_avx2_glue.c | 73 +++++++++-------------
>  arch/x86/crypto/camellia_aesni_avx_glue.c  | 63 +++++++------------
>  arch/x86/crypto/camellia_glue.c            | 21 +++----
>  arch/x86/crypto/cast6_avx_glue.c           | 65 +++++++++----------
>  arch/x86/crypto/serpent_avx2_glue.c        | 65 +++++++++----------
>  arch/x86/crypto/serpent_avx_glue.c         | 58 ++++++-----------
>  arch/x86/crypto/serpent_sse2_glue.c        | 27 +++++---
>  arch/x86/crypto/twofish_avx_glue.c         | 71 ++++++++-------------
>  arch/x86/crypto/twofish_glue_3way.c        | 28 ++++-----
>  arch/x86/include/asm/crypto/camellia.h     | 64 ++++++-------------
>  arch/x86/include/asm/crypto/glue_helper.h  | 34 ++++++++--
>  arch/x86/include/asm/crypto/serpent-avx.h  | 28 ++++-----
>  arch/x86/include/asm/crypto/twofish.h      | 22 ++++---
>  include/crypto/xts.h                       |  2 -
>  15 files changed, 283 insertions(+), 369 deletions(-)
> 
> -- 
> 2.17.1
> 
