Return-Path: <kernel-hardening-return-19422-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E414E22A078
	for <lists+kernel-hardening@lfdr.de>; Wed, 22 Jul 2020 22:03:49 +0200 (CEST)
Received: (qmail 19857 invoked by uid 550); 22 Jul 2020 20:03:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19811 invoked from network); 22 Jul 2020 20:03:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q5uho8c111Sif1rjA6es7LKqax+bTf/baHAxUzEgiBs=;
        b=PPTfc7ofS2HU2+xEOjMWN0IYf6fcp270Om5s7QJSfrzzNXmADk8v71ZGdMdkkRTAax
         NVRK3DHJsdFwMwSaAys3u2BAf0La4VMtXlTOgADR6wEvMjklDRaoFIIB6Xum7WpF7uMQ
         ypktKp91IyG4RD00YrogGN1sYM6Y8KY9L91rR0XwVxsd0mRtoQ39Rx8npPbZlXihy3El
         gQYTvwonVqPerONvAG74ahVIgSQWcPvCwjduf5+9xHV+7YMEbE4BqNZBDUUsFY0g/lAi
         Fhhu/daQvEaSVXc8eCAcO9yxTSxiStt0pOyIX7T+9RbyWTUKOKqDIxXbNEB2Xr4GLpHV
         BD7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q5uho8c111Sif1rjA6es7LKqax+bTf/baHAxUzEgiBs=;
        b=VDrM0IYZRRe5GLIF+0ilJSZYQoJj66ZGk8dwXo3BC17DGwHiaf2Eh0PV1vHaClPWLF
         8fdIiH80KIlDt/wwv3jwF+xZj+4vmy1tQem0eekx9/fxGy82f8+MWZmd6q2CUXhduo1b
         eRKwzJfvVVK6HMNGiVCC1uN4VNzV7eGfRQxnmlDZXkWSQToT8aEDnkBP841lfwYKUBae
         oGhOVHnlarcYZX2k1hzaSADROWjeqsWqOudEYQOhuc0zMurktDAKfQcDiRpPorMr5j0G
         DGytj306Hu0Rw+kP6y/awyOjTy6fnCBbH9UAJdnQjVRFOtUaetwOb7fb+usaRGpZoYPZ
         P3HQ==
X-Gm-Message-State: AOAM531eRCWSLZIm2EN8qqR5kz0P3Jr/cApGD3TWJgmymD70LDh4E6pL
	cwHqfvXyfMq4tRf+n7GxwGLm8aWZhNtNk6TA/g7nxg==
X-Google-Smtp-Source: ABdhPJyF1/TvRtGDiGqtJCE9/ZaqS8MWqJmh/44/JnQk8HhLwq5VDQLuH1PjTPWAuAmpVNS/nDZZEqrEYVoucPXQbvA=
X-Received: by 2002:a17:906:6959:: with SMTP id c25mr1128516ejs.375.1595448203126;
 Wed, 22 Jul 2020 13:03:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-5-samitolvanen@google.com> <20200624212737.GV4817@hirez.programming.kicks-ass.net>
 <20200624214530.GA120457@google.com> <20200625074530.GW4817@hirez.programming.kicks-ass.net>
 <20200625161503.GB173089@google.com> <20200625200235.GQ4781@hirez.programming.kicks-ass.net>
 <20200625224042.GA169781@google.com> <20200626112931.GF4817@hirez.programming.kicks-ass.net>
 <20200722135542.41127cc4@oasis.local.home> <20200722184137.GP10769@hirez.programming.kicks-ass.net>
 <20200722150943.53046592@oasis.local.home>
In-Reply-To: <20200722150943.53046592@oasis.local.home>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Wed, 22 Jul 2020 13:03:12 -0700
Message-ID: <CABCJKufW8rYG-R7b=ad8E5oRd+1xrVknWcTd2VFuvE7=SPtoTA@mail.gmail.com>
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
	Josh Poimboeuf <jpoimboe@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jul 22, 2020 at 12:09 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 22 Jul 2020 20:41:37 +0200
> Peter Zijlstra <peterz@infradead.org> wrote:
>
> > > That said, Andi Kleen added an option to gcc called -mnop-mcount which
> > > will have gcc do both create the mcount section and convert the calls
> > > into nops. When doing so, it defines CC_USING_NOP_MCOUNT which will
> > > tell ftrace to expect the calls to already be converted.
> >
> > That seems like the much easier solution, then we can forget about
> > recordmcount / objtool entirely for this.
>
> Of course that was only for some gcc compilers, and I'm not sure if
> clang can do this.
>
> Or do you just see all compilers doing this in the future, and not
> worrying about record-mcount at all, and bothering with objtool?

Clang appears to only support -mrecord-mcount and -mnop-mcount for
s390, so we still need recordmcount / objtool for x86.

Sami
