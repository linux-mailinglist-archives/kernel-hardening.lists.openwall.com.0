Return-Path: <kernel-hardening-return-19219-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6469F215BC1
	for <lists+kernel-hardening@lfdr.de>; Mon,  6 Jul 2020 18:26:54 +0200 (CEST)
Received: (qmail 5760 invoked by uid 550); 6 Jul 2020 16:26:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5722 invoked from network); 6 Jul 2020 16:26:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594052793;
	bh=ELC0Qf8GBOcW7d74k7xE/syM0cqkEfG1ZwnEhNH0Xwc=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=NWnqF8yNh1kmeojBtU/hvJnKQi+pZfEw8tRN6xyWsQTMlbnwqrlnw5lTOXvjlFbT7
	 B5rw2d8haDBAV5oFbA0B0HdNl5tN/Er570PuYfYx1NWaxj3XhsCuq3jsWx3nC14oRK
	 3IoGxJUeXAP3v3i6Usrl18oSx/B8BE0q7l0vU15Q=
Date: Mon, 6 Jul 2020 09:26:33 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Marco Elver <elver@google.com>,
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
	LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 00/22] add support for Clang LTO
Message-ID: <20200706162633.GA13288@paulmck-ThinkPad-P72>
References: <20200630203016.GI9247@paulmck-ThinkPad-P72>
 <CANpmjNP+7TtE0WPU=nX5zs3T2+4hPkkm08meUm2VDVY3RgsHDw@mail.gmail.com>
 <20200701114027.GO4800@hirez.programming.kicks-ass.net>
 <20200701140654.GL9247@paulmck-ThinkPad-P72>
 <20200701150512.GH4817@hirez.programming.kicks-ass.net>
 <20200701160338.GN9247@paulmck-ThinkPad-P72>
 <20200702082040.GB4781@hirez.programming.kicks-ass.net>
 <20200702175948.GV9247@paulmck-ThinkPad-P72>
 <20200703131330.GX4800@hirez.programming.kicks-ass.net>
 <20200703144228.GF9247@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200703144228.GF9247@paulmck-ThinkPad-P72>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Fri, Jul 03, 2020 at 07:42:28AM -0700, Paul E. McKenney wrote:
> On Fri, Jul 03, 2020 at 03:13:30PM +0200, Peter Zijlstra wrote:
> > On Thu, Jul 02, 2020 at 10:59:48AM -0700, Paul E. McKenney wrote:
> > > On Thu, Jul 02, 2020 at 10:20:40AM +0200, Peter Zijlstra wrote:
> > > > On Wed, Jul 01, 2020 at 09:03:38AM -0700, Paul E. McKenney wrote:

[ . . . ]

> > Also, if C goes and specifies load dependencies, in any form, is then
> > not the corrolary that they need to specify control dependencies? How
> > else can they exclude the transformation.
> 
> By requiring that any temporaries generated from variables that are
> marked _Dependent_ptr also be marked _Dependent_ptr.  This is of course
> one divergence of _Dependent_ptr from the volatile keyword.
> 
> > And of course, once we're there, can we get explicit support for control
> > dependencies too? :-) :-)
> 
> Keep talking like this and I am going to make sure that you attend a
> standards committee meeting.  If need be, by arranging for you to be
> physically dragged there.  ;-)
> 
> More seriously, for control dependencies, the variable that would need
> to be marked would be the program counter, which might require some
> additional syntax.

And perhaps more constructively, we do need to prioritize address and data
dependencies over control dependencies.  For one thing, there are a lot
more address/data dependencies in existing code than there are control
dependencies, and (sadly, perhaps more importantly) there are a lot more
people who are convinced that address/data dependencies are important.

For another (admittedly more theoretical) thing, the OOTA scenarios
stemming from control dependencies are a lot less annoying than those
from address/data dependencies.

And address/data dependencies are as far as I know vulnerable to things
like conditional-move instructions that can cause problems for control
dependencies.

Nevertheless, yes, control dependencies also need attention.

							Thanx, Paul
