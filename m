Return-Path: <kernel-hardening-return-17430-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 41753105E75
	for <lists+kernel-hardening@lfdr.de>; Fri, 22 Nov 2019 03:05:17 +0100 (CET)
Received: (qmail 17663 invoked by uid 550); 22 Nov 2019 02:05:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17629 invoked from network); 22 Nov 2019 02:05:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574388297;
	bh=gr/XBHOIomBO9YTccBT5tV/04vjrg4bPLRQHZ/upRIw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e4DCSNwQE+swxLteljdLwbIyHasX1yBVOhKXf1bGGYRpLbZNvN1cSP1sN9vgeuM//
	 bhCcCzrsH39igs2o1xic/+pPJSVI6+NrUX4D+VV6D1DFVBQK1uqNnu8tJJ/apgowpH
	 mE7eSmvoI7J/J558GFU7D9EWVv4tH0P4gH9sRMUk=
Date: Thu, 21 Nov 2019 18:04:55 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	=?iso-8859-1?Q?Jo=E3o?= Moreira <joao.moreira@intel.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Stephan Mueller <smueller@chronox.de>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v6 1/8] crypto: x86/glue_helper: Regularize function
 prototypes
Message-ID: <20191122020455.GA32523@sol.localdomain>
References: <20191122010334.12081-1-keescook@chromium.org>
 <20191122010334.12081-2-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191122010334.12081-2-keescook@chromium.org>
User-Agent: Mutt/1.12.2 (2019-09-21)

On Thu, Nov 21, 2019 at 05:03:27PM -0800, Kees Cook wrote:
> The crypto glue performed function prototype casting to make indirect
> calls to assembly routines. Instead of performing casts at the call
> sites (which trips Control Flow Integrity prototype checking), switch
> each prototype to a common standard set of arguments which allows the
> incremental removal of the existing macros. In order to keep pointer
> math unchanged, internal casting between u128 pointers and u8 pointers
> is added.
> 
> Co-developed-by: Jo�o Moreira <joao.moreira@intel.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Co-developers need their own Signed-off-by.  checkpatch.pl warns about this.

- Eric
