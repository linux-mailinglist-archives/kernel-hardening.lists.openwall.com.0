Return-Path: <kernel-hardening-return-19560-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D24D823C1F4
	for <lists+kernel-hardening@lfdr.de>; Wed,  5 Aug 2020 00:46:07 +0200 (CEST)
Received: (qmail 32499 invoked by uid 550); 4 Aug 2020 22:46:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32479 invoked from network); 4 Aug 2020 22:46:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UveKBYDbIZyIjh6ZPjOv5UQRCvtyfkU8x2EftZkViyE=; b=fFSpiFi/AMgkfAVlAg1gz8Lovv
	wknbgJJDGNkFpBxfe0qi+Ue73w6sgRM7wQaROnxaNYjc+aWAYlFcyrH07uLsKeMGuxhu9giRlAnyz
	aTVv6J41koFtbUaMem8UHjzBa0hJQeQQmpEy2So1FXEK8WiBx7n2wL7m+FCpn5kTFiTLr166/s1mG
	oF6c8p7cbV3KllUCY0toiT8PYBe66OAbufWPr9nVF16CUmVL8mYK9qada0Z3fMorh20eafrP0Gpdr
	1r1lS9WNOg6cCuLQ0XJkMWT40x1ZBVY1UsnLGyKglE66JM73d6Ruviw3Er7hFtvL4zHSXxYg4VoSP
	07JwMXGQ==;
Date: Tue, 4 Aug 2020 23:45:44 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Kees Cook <keescook@chromium.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [RFC] saturate check_*_overflow() output?
Message-ID: <20200804224544.GK23808@casper.infradead.org>
References: <202008031118.36756FAD04@keescook>
 <f177a821-74a3-e868-81d3-55accfb5b161@rasmusvillemoes.dk>
 <202008041137.02D231B@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202008041137.02D231B@keescook>

On Tue, Aug 04, 2020 at 12:23:03PM -0700, Kees Cook wrote:
> > What we might do, to deal with the "caller fails to check the result",
> > is to add a
> > 
> > static inline bool __must_check must_check_overflow(bool b) { return
> > unlikely(b); }
> > 
> > and wrap all the final "did it overflow" results in that one - perhaps
> > also for the __builtin_* cases, I don't know if those are automatically
> > equipped with that attribute. [I also don't know if gcc propagates
> > likely/unlikely out to the caller, but it shouldn't hurt to have it
> > there and might improve code gen if it does.]
> 
> (What is the formal name for the ({ ...; return_value; }) C construct?)

'Statement Exprs'.

A compound statement enclosed in parentheses may appear as an expression
in GNU C.  This allows you to use loops, switches, and local variables
within an expression.

