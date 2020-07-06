Return-Path: <kernel-hardening-return-19220-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6F095215E54
	for <lists+kernel-hardening@lfdr.de>; Mon,  6 Jul 2020 20:30:02 +0200 (CEST)
Received: (qmail 23630 invoked by uid 550); 6 Jul 2020 18:29:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23598 invoked from network); 6 Jul 2020 18:29:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Do5ubF9fSscGPClrokRq/R+dJR1UND+xOUqU52LNcLY=; b=qbfi+0eUNgOUvrS/172K4oJy+c
	+6cvYoTiN6i7rxY2lKCxArxd7eY83amayJ59D8O1py/4d9s6P4RqhHn1YxV7zVXeTetbIlRbo28Ie
	gCd9otH5ECaPEhZ8Ge/IBJo3+RpoisW5Ms4DZ89U+kQmjoKqC/4gOLn1rpAjmh910g68gBREeN853
	D9OutRrJ3YidRcvHov/mXEAHK/teWgqK5dRcbklwPj7Zu+LAUPsEALJWfBtbZMLbt9OhdAf3SVyqB
	t12O6B1a3TCkvPr8cZa7kIvTauI0iVcGCIWrMpjaav/KQZRjPDPGe/rm2UlYyWtRnwA22XnbRhDgo
	CON822NQ==;
Date: Mon, 6 Jul 2020 20:29:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Paul E. McKenney" <paulmck@kernel.org>
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
Message-ID: <20200706182926.GH4800@hirez.programming.kicks-ass.net>
References: <CANpmjNP+7TtE0WPU=nX5zs3T2+4hPkkm08meUm2VDVY3RgsHDw@mail.gmail.com>
 <20200701114027.GO4800@hirez.programming.kicks-ass.net>
 <20200701140654.GL9247@paulmck-ThinkPad-P72>
 <20200701150512.GH4817@hirez.programming.kicks-ass.net>
 <20200701160338.GN9247@paulmck-ThinkPad-P72>
 <20200702082040.GB4781@hirez.programming.kicks-ass.net>
 <20200702175948.GV9247@paulmck-ThinkPad-P72>
 <20200703131330.GX4800@hirez.programming.kicks-ass.net>
 <20200703144228.GF9247@paulmck-ThinkPad-P72>
 <20200706162633.GA13288@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200706162633.GA13288@paulmck-ThinkPad-P72>

On Mon, Jul 06, 2020 at 09:26:33AM -0700, Paul E. McKenney wrote:

> And perhaps more constructively, we do need to prioritize address and data
> dependencies over control dependencies.  For one thing, there are a lot
> more address/data dependencies in existing code than there are control
> dependencies, and (sadly, perhaps more importantly) there are a lot more
> people who are convinced that address/data dependencies are important.

If they do not consider their Linux OS running correctly :-)

> For another (admittedly more theoretical) thing, the OOTA scenarios
> stemming from control dependencies are a lot less annoying than those
> from address/data dependencies.
> 
> And address/data dependencies are as far as I know vulnerable to things
> like conditional-move instructions that can cause problems for control
> dependencies.
> 
> Nevertheless, yes, control dependencies also need attention.

Today I added one more \o/
