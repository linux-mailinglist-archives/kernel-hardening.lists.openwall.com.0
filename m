Return-Path: <kernel-hardening-return-19221-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 034E9215EC4
	for <lists+kernel-hardening@lfdr.de>; Mon,  6 Jul 2020 20:39:51 +0200 (CEST)
Received: (qmail 27955 invoked by uid 550); 6 Jul 2020 18:39:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 27923 invoked from network); 6 Jul 2020 18:39:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594060773;
	bh=C73gOuGPht9dIixGPBoEUXES1WGxsODtcKpLKnFrDqc=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=DxcjcPLXo5KKl20GXi3gR8saz6u7T52XB2h7KY4zD+cFOdG6eQqu/eTW1KOIHVTH1
	 wju8yVd1Y7IK4dLVkNpXeViYSln0h7JZ5Y1n9IdBD6jdjIrKMxJo0PG6DWDkUmV68w
	 2PZAalihX+WlZ2m6xkVYthoCCWtQgQAL3RpYBP7s=
Date: Mon, 6 Jul 2020 11:39:33 -0700
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
Message-ID: <20200706183933.GE9247@paulmck-ThinkPad-P72>
References: <20200701114027.GO4800@hirez.programming.kicks-ass.net>
 <20200701140654.GL9247@paulmck-ThinkPad-P72>
 <20200701150512.GH4817@hirez.programming.kicks-ass.net>
 <20200701160338.GN9247@paulmck-ThinkPad-P72>
 <20200702082040.GB4781@hirez.programming.kicks-ass.net>
 <20200702175948.GV9247@paulmck-ThinkPad-P72>
 <20200703131330.GX4800@hirez.programming.kicks-ass.net>
 <20200703144228.GF9247@paulmck-ThinkPad-P72>
 <20200706162633.GA13288@paulmck-ThinkPad-P72>
 <20200706182926.GH4800@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706182926.GH4800@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Mon, Jul 06, 2020 at 08:29:26PM +0200, Peter Zijlstra wrote:
> On Mon, Jul 06, 2020 at 09:26:33AM -0700, Paul E. McKenney wrote:
> 
> > And perhaps more constructively, we do need to prioritize address and data
> > dependencies over control dependencies.  For one thing, there are a lot
> > more address/data dependencies in existing code than there are control
> > dependencies, and (sadly, perhaps more importantly) there are a lot more
> > people who are convinced that address/data dependencies are important.
> 
> If they do not consider their Linux OS running correctly :-)

Many of them really do not care at all.  In fact, some would consider
Linux failing to run as an added bonus.

> > For another (admittedly more theoretical) thing, the OOTA scenarios
> > stemming from control dependencies are a lot less annoying than those
> > from address/data dependencies.
> > 
> > And address/data dependencies are as far as I know vulnerable to things
> > like conditional-move instructions that can cause problems for control
> > dependencies.
> > 
> > Nevertheless, yes, control dependencies also need attention.
> 
> Today I added one more \o/

Just make sure you continually check to make sure that compilers
don't break it, along with the others you have added.  ;-)

							Thanx, Paul
