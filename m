Return-Path: <kernel-hardening-return-19388-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 60F2C224281
	for <lists+kernel-hardening@lfdr.de>; Fri, 17 Jul 2020 19:48:20 +0200 (CEST)
Received: (qmail 13757 invoked by uid 550); 17 Jul 2020 17:48:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13730 invoked from network); 17 Jul 2020 17:48:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ouPoIbaznwUvpvUZ+d9Lmd0+7ZlkFrw9Vubc0luuMm4=;
        b=T6HKmBM9wpL/nF5N2IowQkS/pBz5KcI4emAgAF/8bejb3Rhx2qwrGgob1UjZiG3w7S
         sV6mfszfROVCaEu8RGIpZ4VkI2TfV76l3kRAt5KhIYLORviINuEzJTcBZun0PPQ+17yC
         sL7ngdlkBSr0haa/a+I8w89hJ7YH96WrmJqjEEQ0IghXlJVhpi5weKEIajlkG6ys7hyd
         bZmMEpFCkEu4wbXN27ODtK768/E5FhwvDDArao/vNYiIfxrf2lW3myBzMBQ5v233gbff
         d1eBjiTWMO6Gs1QkbbmCsFdWavwcujwbbYY4NlsshvUcQAPvgs23KuSHpFcZHhwd9zi3
         jBBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ouPoIbaznwUvpvUZ+d9Lmd0+7ZlkFrw9Vubc0luuMm4=;
        b=LqZcmNqMVNwWllGy8LhYFSGLTqHuVGW4ADPZBx1+2NMgNNDcnmjb2mUx6ZHSFSJsLE
         s9Z8AUCJ7vge53PJq0Zp1qLMYDJoCTYkq4El9wH+3wO+B34kvjBSgXPy3pX5H9zMaKp8
         8Kn0LVWQdLgY+SMtl1ZcD65DciSBRWZbsw6GoLm4p1DvyU9DY5Kvev+dLCbpvAZRHoT8
         6i6veId5ctGMu+8UlP4cfunp2jcXfi8RbMU+NpOSIp4DJ5BKYygINZSGZ5xFZA5vWb02
         ZiT0Yb8z9X8V2H35zWmdkvfQalGugiRujUnuAxqI7UY/NJVyP7GWZwSqPgn+ZCpHWf2Z
         Uh4g==
X-Gm-Message-State: AOAM531XUXXT+HiNG3S0gYt0RdVipRlh3cSruGCYhVJIFihJV9yO+tgp
	b04V0H+0NDg3Luzpfuu20V5gjX3N7hnvd7+LySDpNw==
X-Google-Smtp-Source: ABdhPJxAkNoEdvBMsNoiwT/xtC3KzAJM3mngqfnMyotl0K4+5QQM9nsSc91iJTIh6/lQ8mnSCUp3b+j2mW212gFA81Q=
X-Received: by 2002:a17:906:6959:: with SMTP id c25mr9393908ejs.375.1595008082575;
 Fri, 17 Jul 2020 10:48:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-5-samitolvanen@google.com> <20200624212737.GV4817@hirez.programming.kicks-ass.net>
 <20200624214530.GA120457@google.com> <20200625074530.GW4817@hirez.programming.kicks-ass.net>
 <20200625161503.GB173089@google.com> <20200625200235.GQ4781@hirez.programming.kicks-ass.net>
 <20200625224042.GA169781@google.com> <20200626112931.GF4817@hirez.programming.kicks-ass.net>
 <CABCJKucSM7gqWmUtiBPbr208wB0pc25afJXc6yBQzJDZf4LSWA@mail.gmail.com> <20200717133645.7816c0b6@oasis.local.home>
In-Reply-To: <20200717133645.7816c0b6@oasis.local.home>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 17 Jul 2020 10:47:51 -0700
Message-ID: <CABCJKuda0AFCZ-1J2NTLc-M0xax007a9u-fzOoxmU2z60jvzbA@mail.gmail.com>
Subject: Re: [RFC][PATCH] objtool,x86_64: Replace recordmcount with objtool
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Will Deacon <will@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org, X86 ML <x86@kernel.org>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Matt Helsley <mhelsley@vmware.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Jul 17, 2020 at 10:36 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Fri, 17 Jul 2020 10:28:13 -0700
> Sami Tolvanen <samitolvanen@google.com> wrote:
>
> > On Fri, Jun 26, 2020 at 4:29 AM Peter Zijlstra <peterz@infradead.org> wrote:
> > >
> > > On Thu, Jun 25, 2020 at 03:40:42PM -0700, Sami Tolvanen wrote:
> > >
> > > > > Not boot tested, but it generates the required sections and they look
> > > > > more or less as expected, ymmv.
> > >
> > > > > diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> > > > > index a291823f3f26..189575c12434 100644
> > > > > --- a/arch/x86/Kconfig
> > > > > +++ b/arch/x86/Kconfig
> > > > > @@ -174,7 +174,6 @@ config X86
> > > > >     select HAVE_EXIT_THREAD
> > > > >     select HAVE_FAST_GUP
> > > > >     select HAVE_FENTRY                      if X86_64 || DYNAMIC_FTRACE
> > > > > -   select HAVE_FTRACE_MCOUNT_RECORD
> > > > >     select HAVE_FUNCTION_GRAPH_TRACER
> > > > >     select HAVE_FUNCTION_TRACER
> > > > >     select HAVE_GCC_PLUGINS
> > > >
> > > > This breaks DYNAMIC_FTRACE according to kernel/trace/ftrace.c:
> > > >
> > > >   #ifndef CONFIG_FTRACE_MCOUNT_RECORD
> > > >   # error Dynamic ftrace depends on MCOUNT_RECORD
> > > >   #endif
> > > >
> > > > And the build errors after that seem to confirm this. It looks like we might
> > > > need another flag to skip recordmcount.
> > >
> > > Hurm, Steve, how you want to do that?
> >
> > Steven, did you have any thoughts about this? Moving recordmcount to
> > an objtool pass that knows about call sites feels like a much cleaner
> > solution than annotating kernel code to avoid unwanted relocations.
> >
>
> Bah, I started to reply to this then went to look for details, got
> distracted, forgot about it, my laptop crashed (due to a zoom call),
> and I lost the email I was writing (haven't looked in the drafts
> folder, but my idea about this has changed since anyway).
>
> So the problem is that we process mcount references in other areas and
> that confuses the ftrace modification portion?

Correct.

> Someone just submitted a patch for arm64 for this:
>
> https://lore.kernel.org/r/20200717143338.19302-1-gregory.herrero@oracle.com
>
> Is that what you want?

That looks like the same issue, but we need to fix this on x86 instead.

Sami
