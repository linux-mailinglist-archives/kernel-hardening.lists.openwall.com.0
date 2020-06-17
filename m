Return-Path: <kernel-hardening-return-19007-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9001F1FD8F2
	for <lists+kernel-hardening@lfdr.de>; Thu, 18 Jun 2020 00:36:49 +0200 (CEST)
Received: (qmail 15470 invoked by uid 550); 17 Jun 2020 22:36:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15438 invoked from network); 17 Jun 2020 22:36:43 -0000
Date: Wed, 17 Jun 2020 18:36:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Jann Horn <jannh@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
 Kees Cook <keescook@chromium.org>, Kernel Hardening
 <kernel-hardening@lists.openwall.com>, Oscar Carter <oscar.carter@gmx.com>,
 Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] tracing: Use linker magic instead of recasting
 ftrace_ops_list_func()
Message-ID: <20200617183628.3594271d@oasis.local.home>
In-Reply-To: <CAG48ez2pOns4vF9M_4ubMJ+p9YFY29udMaH0wm8UuCwGQ4ZZAQ@mail.gmail.com>
References: <20200617165616.52241bde@oasis.local.home>
	<CAG48ez2pOns4vF9M_4ubMJ+p9YFY29udMaH0wm8UuCwGQ4ZZAQ@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 17 Jun 2020 23:30:07 +0200
Jann Horn <jannh@google.com> wrote:
> [...]
> > +/* Defined by vmlinux.lds.h see the commment above arch_ftrace_ops_list_func for details */
> > +void ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip,
> > +                         struct ftrace_ops *op, struct pt_regs *regs);  
> [...]
> > +void arch_ftrace_ops_list_func(unsigned long ip, unsigned long parent_ip)
> >  {  
> 
> Well, it's not like the function cast itself is the part that's
> problematic for CFI; the problematic part is when you actually make a
> C function call (in particular an indirect one) where the destination
> is compiled with a prototype that is different from the prototype used
> at the call site. Doing this linker hackery isn't really any better
> than shutting up the compiler warning by piling on enough casts or
> whatever. (There should be some combination of casts that'll shut up
> this warning, right?)

It's not called by C, it's called by assembly.

> 
> IIUC the real issue here is that ftrace_func_t is defined as a fixed
> type, but actually has different types depending on the architecture?
> If so, it might be cleaner to define ftrace_func_t differently
> depending on architecture, or something like that?

There's functions that use this type.

When you register a function to be used by the function tracer (that
will have 4 parameters). If the arch supports it, it will call it
directly from the trampoline in assembly, but if it does not, then the
C code will only let assembly call the two parameter version, that will
call the 4 parameter function (adding NULLs to the extra two arguments). 

> 
> And if that's not feasible, I think it would be better to at least
> replace this linker trickery with straightforward
> shut-up-the-compiler-casts - it'd be much easier to understand what's
> actually going on that way.

OK, what's the way to shut up the compiler for it, and we can have that
instead.

-- Steve
