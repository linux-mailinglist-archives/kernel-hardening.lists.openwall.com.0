Return-Path: <kernel-hardening-return-19615-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 971AA24394C
	for <lists+kernel-hardening@lfdr.de>; Thu, 13 Aug 2020 13:23:48 +0200 (CEST)
Received: (qmail 3423 invoked by uid 550); 13 Aug 2020 11:23:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3401 invoked from network); 13 Aug 2020 11:23:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bMRBGcKt+bU8uAPr5Wn9gP6oItYBvFq1FIEisxr/UUQ=; b=KZFE1eXd1CWdppiZQ3jh6dA+N/
	SImJmnPw5zL3u53vOECKyXOKHoCU0Im5fYnfmCdyg8cfXtRN7hfkQZCaWIWDHD2sj5EOKyAVlYE9m
	yaliy3/OfuiGAo5LJEDCwWt3BCjDlWPZhDE9d1enXhLTNBugDaGTITNUJz7kSxfj4lAcZFxhE60PI
	0xs1RGe4iD72L+B1/kwLa/Px7iO5dQzVrXidtr/LFR2BtVLUapF8a4z26vOqQmM+O9OF4DjLTf9Vz
	plec0ktW0KvsTntw4Qj8134GCWIF1ZcFumdkm7IhMh9dOvzR+zNtJt3UY9yqtmoR9sGPuY79HbP+8
	FE4fS7tQ==;
Date: Thu, 13 Aug 2020 12:23:27 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Kees Cook <keescook@chromium.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] overflow: Add __must_check attribute to check_*() helpers
Message-ID: <20200813112327.GF17456@casper.infradead.org>
References: <202008121450.405E4A3@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202008121450.405E4A3@keescook>

On Wed, Aug 12, 2020 at 02:51:52PM -0700, Kees Cook wrote:
> +/*
> + * Allows to effectively us apply __must_check to a macro so we can have
> + * both the type-agnostic benefits of the macros while also being able to
> + * enforce that the return value is, in fact, checked.
> + */
> +static inline bool __must_check __must_check_bool(bool condition)
> +{
> +	return unlikely(condition);
> +}

I'm fine with the concept, but this is a weirdly-generically-named
function that has a very specific unlikely() in it.  So I'd call
this __must_check_overflow() and then it's obvious that overflow is
unlikely(), whereas it's not obvious that __must_check_bool() is going
to be unlikely().

