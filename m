Return-Path: <kernel-hardening-return-17442-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 248E410B502
	for <lists+kernel-hardening@lfdr.de>; Wed, 27 Nov 2019 19:01:45 +0100 (CET)
Received: (qmail 32282 invoked by uid 550); 27 Nov 2019 18:01:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32245 invoked from network); 27 Nov 2019 18:01:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1574877687;
	bh=DqpIVPpSNRYaQEY8qH901L06azIBYeg8eGVRD3v38ok=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HPN7uf5PWAbcDCgYiwF4fFKQrfACX9EBB8jN7v59ShMpiCDzuvyga3x4d/5ms0cFP
	 cvl8GIhLVQbEbnOlAoFDQZXuyPKOKoi7hI2Gd2IFXpvIRK9plXluFd5jLNelQp5PUr
	 rDpAsmZRnaRsh+DdSezcD+mg44xMbQYDDQ/5fk5w=
Date: Wed, 27 Nov 2019 10:01:25 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
	=?iso-8859-1?Q?Jo=E3o?= Moreira <joao.moreira@intel.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Stephan Mueller <smueller@chronox.de>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v7] crypto: x86: Regularize glue function prototypes
Message-ID: <20191127180125.GA49214@sol.localdomain>
References: <201911262205.FD985935F@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201911262205.FD985935F@keescook>
User-Agent: Mutt/1.12.2 (2019-09-21)

On Tue, Nov 26, 2019 at 10:08:02PM -0800, Kees Cook wrote:
> The crypto glue performed function prototype casting via macros to make
> indirect calls to assembly routines. Instead of performing casts at the
> call sites (which trips Control Flow Integrity prototype checking), switch
> each prototype to a common standard set of arguments which allows the
> removal of the existing macros. In order to keep pointer math unchanged,
> internal casting between u128 pointers and u8 pointers is added.
> 
> Co-developed-by: João Moreira <joao.moreira@intel.com>
> Signed-off-by: João Moreira <joao.moreira@intel.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Eric Biggers <ebiggers@kernel.org>

- Eric
