Return-Path: <kernel-hardening-return-19201-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F0F7B211030
	for <lists+kernel-hardening@lfdr.de>; Wed,  1 Jul 2020 18:06:42 +0200 (CEST)
Received: (qmail 3784 invoked by uid 550); 1 Jul 2020 16:06:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3752 invoked from network); 1 Jul 2020 16:06:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593619584;
	bh=uLEdkNXwe0emaThTM6WspRamdEFQQiLIrC1p6usUuTA=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=z87UF224UxxlXMucR0NGnQxgFb2cvoaHdXpXRyuWYh2tIS3iEYGUR7Yq6H78+1F+h
	 iTddJwl2nXx4w/xHbGrpzSOey8jQOAcBknpR2TB9Udubo0O6qxBDZSvAph8+4l5p9J
	 c4o1AiJI72YTI3AKDSk0lyqyfYibOxqAny9XLHaw=
Date: Wed, 1 Jul 2020 09:06:24 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: David Laight <David.Laight@ACULAB.COM>
Cc: 'Peter Zijlstra' <peterz@infradead.org>, Marco Elver <elver@google.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kees Cook <keescook@chromium.org>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	"linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 00/22] add support for Clang LTO
Message-ID: <20200701160624.GO9247@paulmck-ThinkPad-P72>
References: <20200624211540.GS4817@hirez.programming.kicks-ass.net>
 <CAKwvOdmxz91c-M8egR9GdR1uOjeZv7-qoTP=pQ55nU8TCpkK6g@mail.gmail.com>
 <20200625080313.GY4817@hirez.programming.kicks-ass.net>
 <20200625082433.GC117543@hirez.programming.kicks-ass.net>
 <20200625085745.GD117543@hirez.programming.kicks-ass.net>
 <20200630191931.GA884155@elver.google.com>
 <20200630201243.GD4817@hirez.programming.kicks-ass.net>
 <20200630203016.GI9247@paulmck-ThinkPad-P72>
 <20200701091054.GW4781@hirez.programming.kicks-ass.net>
 <4427b0f825324da4b1640e32265b04bd@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4427b0f825324da4b1640e32265b04bd@AcuMS.aculab.com>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Wed, Jul 01, 2020 at 02:20:13PM +0000, David Laight wrote:
> From: Peter Zijlstra
> > Sent: 01 July 2020 10:11
> > On Tue, Jun 30, 2020 at 01:30:16PM -0700, Paul E. McKenney wrote:
> > > On Tue, Jun 30, 2020 at 10:12:43PM +0200, Peter Zijlstra wrote:
> > 
> > > > I'm not convinced C11 memory_order_consume would actually work for us,
> > > > even if it would work. That is, given:
> > > >
> > > >   https://lore.kernel.org/lkml/20150520005510.GA23559@linux.vnet.ibm.com/
> > > >
> > > > only pointers can have consume, but like I pointed out, we have code
> > > > that relies on dependent loads from integers.
> > >
> > > I agree that C11 memory_order_consume is not normally what we want,
> > > given that it is universally promoted to memory_order_acquire.
> > >
> > > However, dependent loads from integers are, if anything, more difficult
> > > to defend from the compiler than are control dependencies.  This applies
> > > doubly to integers that are used to index two-element arrays, in which
> > > case you are just asking the compiler to destroy your dependent loads
> > > by converting them into control dependencies.
> > 
> > Yes, I'm aware. However, as you might know, I'm firmly in the 'C is a
> > glorified assembler' camp (as I expect most actual OS people are, out of
> > necessity if nothing else) and if I wanted a control dependency I
> > would've bloody well written one.
> 
> I write in C because doing register tracking is hard :-)
> I've got an hdlc implementation in C that is carefully adjusted
> so that the worst case path is bounded.
> I probably know every one of the 1000 instructions in it.
> 
> Would an asm statement that uses the same 'register' for input and
> output but doesn't actually do anything help?
> It won't generate any code, but the compiler ought to assume that
> it might change the value - so can't do optimisations that track
> the value across the call.

It might replace the volatile load, but there are optimizations that
apply to the downstream code as well.

Or are you suggesting periodically pushing the dependent variable
through this asm?  That might work, but it would be easier and
more maintainable to just mark the variable.

> > I think an optimizing compiler is awesome, but only in so far as that
> > optimization is actually helpful -- and yes, I just stepped into a giant
> > twilight zone there. That is, any optimization that has _any_
> > controversy should be controllable (like -fno-strict-overflow
> > -fno-strict-aliasing) and I'd very much like the same here.
> 
> I'm fed up of gcc generating the code that uses SIMD instructions
> for the 'tail' loop at the end of a function that is already doing
> SIMD operations for the main part of the loop.
> And compilers that convert a byte copy loop to 'rep movsb'.
> If I'm copying 3 or 4 bytes I don't want a 40 clock overhead.

Agreed, compilers can often be all too "helpful".  :-(

							Thanx, Paul
