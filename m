Return-Path: <kernel-hardening-return-19411-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4EF9E229ECE
	for <lists+kernel-hardening@lfdr.de>; Wed, 22 Jul 2020 19:56:05 +0200 (CEST)
Received: (qmail 27832 invoked by uid 550); 22 Jul 2020 17:55:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 27812 invoked from network); 22 Jul 2020 17:55:57 -0000
Date: Wed, 22 Jul 2020 13:55:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, Masahiro Yamada
 <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, Kees
 Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>,
 clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com,
 linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-pci@vger.kernel.org, x86@kernel.org, Josh Poimboeuf
 <jpoimboe@redhat.com>, mhelsley@vmware.com
Subject: Re: [RFC][PATCH] objtool,x86_64: Replace recordmcount with objtool
Message-ID: <20200722135542.41127cc4@oasis.local.home>
In-Reply-To: <20200626112931.GF4817@hirez.programming.kicks-ass.net>
References: <20200624203200.78870-1-samitolvanen@google.com>
	<20200624203200.78870-5-samitolvanen@google.com>
	<20200624212737.GV4817@hirez.programming.kicks-ass.net>
	<20200624214530.GA120457@google.com>
	<20200625074530.GW4817@hirez.programming.kicks-ass.net>
	<20200625161503.GB173089@google.com>
	<20200625200235.GQ4781@hirez.programming.kicks-ass.net>
	<20200625224042.GA169781@google.com>
	<20200626112931.GF4817@hirez.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 26 Jun 2020 13:29:31 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Jun 25, 2020 at 03:40:42PM -0700, Sami Tolvanen wrote:
> 
> > > Not boot tested, but it generates the required sections and they look
> > > more or less as expected, ymmv.  
> 
> > > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > > index a291823f3f26..189575c12434 100644
> > > --- a/arch/x86/Kconfig
> > > +++ b/arch/x86/Kconfig
> > > @@ -174,7 +174,6 @@ config X86
> > >  	select HAVE_EXIT_THREAD
> > >  	select HAVE_FAST_GUP
> > >  	select HAVE_FENTRY			if X86_64 || DYNAMIC_FTRACE
> > > -	select HAVE_FTRACE_MCOUNT_RECORD
> > >  	select HAVE_FUNCTION_GRAPH_TRACER
> > >  	select HAVE_FUNCTION_TRACER
> > >  	select HAVE_GCC_PLUGINS  
> > 
> > This breaks DYNAMIC_FTRACE according to kernel/trace/ftrace.c:
> > 
> >   #ifndef CONFIG_FTRACE_MCOUNT_RECORD
> >   # error Dynamic ftrace depends on MCOUNT_RECORD
> >   #endif
> > 
> > And the build errors after that seem to confirm this. It looks like we might
> > need another flag to skip recordmcount.  
> 
> Hurm, Steve, how you want to do that?

That was added when we removed that dangerous daemon that did the
updates, and was added to make sure it didn't come back.

We can probably just get rid of it.


> 
> > Anyway, since objtool is run before recordmcount, I just left this unchanged
> > for testing and ignored the recordmcount warnings about __mcount_loc already
> > existing. Something is a bit off still though, I see this at boot:
> > 
> >   ------------[ ftrace bug ]------------
> >   ftrace failed to modify
> >   [<ffffffff81000660>] __tracepoint_iter_initcall_level+0x0/0x40
> >    actual:   0f:1f:44:00:00
> >   Initializing ftrace call sites
> >   ftrace record flags: 0
> >    (0)
> >    expected tramp: ffffffff81056500
> >   ------------[ cut here ]------------
> > 
> > Otherwise, this looks pretty good.  
> 
> Ha! it is trying to convert the "CALL __fentry__" into a NOP and not
> finding the CALL -- because objtool already made it a NOP...
> 
> Weird, I thought recordmcount would also write NOPs, it certainly has
> code for that. I suppose we can use CC_USING_NOP_MCOUNT to avoid those,
> but I'd rather Steve explain this before I wreck things further.

The reason for not having recordmcount insert all the nops, is because
x86 has more than one optimal nop which is determined by the machine it
runs on, and not at compile time. So we figured just updated it then.

We can change it to be a nop on boot, and just modify it if it's not
the optimal nop already. 

That said, Andi Kleen added an option to gcc called -mnop-mcount which
will have gcc do both create the mcount section and convert the calls
into nops. When doing so, it defines CC_USING_NOP_MCOUNT which will
tell ftrace to expect the calls to already be converted.

-- Steve
