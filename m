Return-Path: <kernel-hardening-return-19566-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BB20B23DA34
	for <lists+kernel-hardening@lfdr.de>; Thu,  6 Aug 2020 14:11:30 +0200 (CEST)
Received: (qmail 30616 invoked by uid 550); 6 Aug 2020 12:11:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 17845 invoked from network); 5 Aug 2020 23:22:31 -0000
X-Authentication-Warning: gate.crashing.org: segher set sender to segher@kernel.crashing.org using -f
Date: Wed, 5 Aug 2020 18:22:08 -0500
From: Segher Boessenkool <segher@kernel.crashing.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Kees Cook <keescook@chromium.org>, Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com
Subject: Re: [RFC] saturate check_*_overflow() output?
Message-ID: <20200805232208.GT6753@gate.crashing.org>
References: <202008031118.36756FAD04@keescook> <f177a821-74a3-e868-81d3-55accfb5b161@rasmusvillemoes.dk> <202008041137.02D231B@keescook> <6d190601-68f1-c086-97ac-2ee1c08f5a34@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d190601-68f1-c086-97ac-2ee1c08f5a34@rasmusvillemoes.dk>
User-Agent: Mutt/1.4.2.3i

Hi Rasmus,

On Wed, Aug 05, 2020 at 01:38:58PM +0200, Rasmus Villemoes wrote:
> I'm guessing gcc has some internal very early simplification that
> replaces single-expression statement-exprs with just that expression,
> and the warn-unused-result triggers later. But as soon as the
> statement-expr becomes a little non-trivial (e.g. above), my guess is
> that the whole thing gets assigned to some internal "variable"
> representing the result, and that assignment then counts as a use of the
> return value from must_check_overflow() - cc'ing Segher, as he usually
> knows these details.

A statement expression is not a statement (it's an expression), which
turns half of the world upside down.  This GCC extension often has weird
(or at least non-intuitive) side effects, together with other extensions
(like attributes), etc.

This may be a convoluted way of saying "I don't know, look at c/c-decl.c
(and maybe c/c-parser.c) to see if you can find out" ;-)


> Anyway, we don't need to apply it to the last expression inside ({}), we
> can just pass the whole ({}) to must_check_overflow() as in

<snip>

Yes, much nicer :-)  Crisis averted, etc.


Segher
