Return-Path: <kernel-hardening-return-19413-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BB86B229EF1
	for <lists+kernel-hardening@lfdr.de>; Wed, 22 Jul 2020 20:07:42 +0200 (CEST)
Received: (qmail 32700 invoked by uid 550); 22 Jul 2020 18:07:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32678 invoked from network); 22 Jul 2020 18:07:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FdyJ3zCjPfmLPOxt0EpbJoGI3z0Dst2ftnMjMBs721s=;
        b=VQOOnqg73U7x3eQrsDW5P6NHQpsRTrBV6mDqQ35Y7KbR5dxMVHVEhlOpBKgbC4YauI
         hKoPoQogS3yVaVz+cHKlmtCp41T1+KI57s1dNmREFvPgWO9LQa1Md2XUbvuoYp7xcDOD
         uJkxpr/ugST6O4YCQmPPrAz4f1LYvrnmu4TBkKKzuhd7zdw95+t6HeiJXKW9A6c8pPUy
         XRNlbkclQcCrxbPIAZrisC31UWn7W4GKg1hOvR+OFZqdAhucXRldSHGUkEO+NbUB9S9S
         XaVu2nmp3aY/+8g9/c/Kskh84nH4FtiosOyHuJCZKQY+DsufHyQlBrv/tBuyO6TpzdFa
         UM+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FdyJ3zCjPfmLPOxt0EpbJoGI3z0Dst2ftnMjMBs721s=;
        b=s9DS7kXq/T+fZJnPLruoVEi3i/ZfCfNEl3HJ8X3vseY6SCC/06O4OG28XTUHTTXCJV
         HAbmt/FKvBHiPgsc1VqiO++GZr2/YuIPeq+JXgZm/PU12Cp//DzZsLAEgZAvw1Bw3iSA
         lley8pFl+8e0SwnwEDLZ/0yATbevh4tI5Mw2/8A2qBBFUxoJEZUPLZ6JRcBLowQIf9RB
         DzLyFi7CZwayXVV5s8hZzuPJ+LCIY4/pBxftmcD8kr/wsjlCoInOilt47Ys/jShVWI1H
         HiMBrd4WqG3wLlgbB3iCts6y9A3GnB/7KGENNppo0XjkrZYE7DoqxNaxLfazXkB3P/4/
         VSJw==
X-Gm-Message-State: AOAM5303xYsrGN6hDDUa27kpK6vnI73DQdP9CzsIQSlLGXBDDdOL98t/
	UTFbMtLejHrnYR9YrgpkiQ0GaPZzzqt0sZTIxGf8ww==
X-Google-Smtp-Source: ABdhPJwcnL9bpNsR0ioOLFXQ9M3j8q0lz48Fhhhje9z+wnEe4/R/foPMYkXV+6IoYiAKnIEt8CMey3jrAzyf6UdUmaI=
X-Received: by 2002:a05:6402:542:: with SMTP id i2mr682149edx.318.1595441245286;
 Wed, 22 Jul 2020 11:07:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-5-samitolvanen@google.com> <20200624212737.GV4817@hirez.programming.kicks-ass.net>
 <20200624214530.GA120457@google.com> <20200625074530.GW4817@hirez.programming.kicks-ass.net>
 <20200625161503.GB173089@google.com> <20200625200235.GQ4781@hirez.programming.kicks-ass.net>
 <20200625224042.GA169781@google.com> <20200626112931.GF4817@hirez.programming.kicks-ass.net>
 <CABCJKucSM7gqWmUtiBPbr208wB0pc25afJXc6yBQzJDZf4LSWA@mail.gmail.com>
 <20200717133645.7816c0b6@oasis.local.home> <CABCJKuda0AFCZ-1J2NTLc-M0xax007a9u-fzOoxmU2z60jvzbA@mail.gmail.com>
 <20200717140545.6f008208@oasis.local.home> <CABCJKucDrS9wNZLjtmN5qMbZBTHLvB1Z7WqTwT3b11-K4kNcyg@mail.gmail.com>
 <20200722135829.7ca6fbc5@oasis.local.home>
In-Reply-To: <20200722135829.7ca6fbc5@oasis.local.home>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Wed, 22 Jul 2020 11:07:13 -0700
Message-ID: <CABCJKucn5o+PgMnKwHOGRnhTdVk9Dnd2QZwy54wXYwQYNUNjBw@mail.gmail.com>
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

On Wed, Jul 22, 2020 at 10:58 AM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Mon, 20 Jul 2020 09:52:37 -0700
> Sami Tolvanen <samitolvanen@google.com> wrote:
>
> > > Does x86 have a way to differentiate between the two that record mcount
> > > can check?
> >
> > I'm not sure if looking at the relocation alone is sufficient on x86,
> > we might also have to decode the instruction, which is what objtool
> > does. Did you have any thoughts on Peter's patch, or my initial
> > suggestion, which adds a __nomcount attribute to affected functions?
>
> There's a lot of code in this thread. Can you give me the message-id of
> Peter's patch in question.

Sure, I was referring to the objtool patch in this message:

https://lore.kernel.org/lkml/20200625200235.GQ4781@hirez.programming.kicks-ass.net/

Sami
