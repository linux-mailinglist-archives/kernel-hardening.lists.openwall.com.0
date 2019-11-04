Return-Path: <kernel-hardening-return-17278-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E2206EECBA
	for <lists+kernel-hardening@lfdr.de>; Mon,  4 Nov 2019 23:00:05 +0100 (CET)
Received: (qmail 1988 invoked by uid 550); 4 Nov 2019 22:00:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1968 invoked from network); 4 Nov 2019 21:59:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IymmwTl8Rrj9gY6nJ0vlwI8rMdE1BEoC3iBejCXtH+A=;
        b=MY8yAdahkSPgp2X7tfA/R8Kp3qQsk/vpyfIVoGibvQOAOpVG7dWCO1ps9OFVU/PeQ2
         xmCUqqZrBtMEkwUoAmhBOgtmsVlFUtt4OCkf9ato/mDIOtSnxyqBXmTQtUkeV2KN/cEu
         uLETcMkI4O4qIzY5Y306Ex+gLpUkIXvuSs9qEm5UsJ2LEV2IVanDbiKUASuI1nY+mtL5
         XBusqd+MqXtDJwvZY1fBBNTUs+KQ7gO7X40sMOLNuGkgG37V0sUUbLmt3BbeSAjcbBGt
         o5VvFFqzfhhGpTqKArM+xBeJCSm357VSXiFQchB69JrVAYDNCWNBhQSCeFCDVo42elwW
         9clQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IymmwTl8Rrj9gY6nJ0vlwI8rMdE1BEoC3iBejCXtH+A=;
        b=Z5qoWUUUP03tE1pZMe1C4KeEODmpdl0iL82vHRj9wtVxyZwl0hsVnUuQWaeGSJMRl9
         F8M9KJo3xs+aagiuSWoHeUeiRHml5OIYTwuGVrQQfWAtKIia3FMXnPLf0i1XezBI3RQf
         MNeDLhNhR7KyIbvVx9JJBrFOY/YodniWXKBAobE0tGu4BQKQWemq/UV60nw6pqSMWKQQ
         OxKodFaB0iWjC/qoWXv3L/Mf35LXQyAq5t5L++Hq9qsy8GELo0DH7Oo2GAb0DxGfkcvd
         c3qSRSjeulKXHJq+jDZxw0pc2qPdLCViKDV4DogMhIzztcwjF3ECyc6swbjzIChs0WjI
         3T3Q==
X-Gm-Message-State: APjAAAWPWTz27yslmR6mOKSX3xnePz38KGLlu1xYh6HUOuULQF6skjbj
	KHuJGJofGg0QpZXKqxACZzmo4GIFRE6pHw4hvyTZxA==
X-Google-Smtp-Source: APXvYqyvfbe4Rk74BEZhEbgv9KmXI2oczxNxkswGRQ3YxahRRLStSKtwQ3PlZ387iT14X5dnJ3JmqJ53a+0shRWL1lM=
X-Received: by 2002:a17:902:9b83:: with SMTP id y3mr29178135plp.179.1572904786995;
 Mon, 04 Nov 2019 13:59:46 -0800 (PST)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191101221150.116536-1-samitolvanen@google.com> <20191101221150.116536-14-samitolvanen@google.com>
 <02c56a5273f94e9d832182f1b3cb5097@www.loen.fr> <CABCJKucVON6uUMH6hVP7RODqH8u63AP3SgTCBWirrS30yDOmdA@mail.gmail.com>
In-Reply-To: <CABCJKucVON6uUMH6hVP7RODqH8u63AP3SgTCBWirrS30yDOmdA@mail.gmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 4 Nov 2019 13:59:35 -0800
Message-ID: <CAKwvOdkDbX4zLChH_DKrnOah1sJjTA-e3uZOXUP6nUs-EaJreg@mail.gmail.com>
Subject: Re: [PATCH v4 13/17] arm64: preserve x18 when CPU is suspended
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>, 
	Catalin Marinas <catalin.marinas@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Dave Martin <dave.martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, Nov 4, 2019 at 1:38 PM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> On Mon, Nov 4, 2019 at 5:20 AM Marc Zyngier <maz@kernel.org> wrote:
> > >  ENTRY(cpu_do_suspend)
> > >       mrs     x2, tpidr_el0
> > > @@ -73,6 +75,9 @@ alternative_endif
> > >       stp     x8, x9, [x0, #48]
> > >       stp     x10, x11, [x0, #64]
> > >       stp     x12, x13, [x0, #80]
> > > +#ifdef CONFIG_SHADOW_CALL_STACK
> > > +     str     x18, [x0, #96]
> > > +#endif
> >
> > Do we need the #ifdefery here? We didn't add that to the KVM path,
> > and I'd feel better having a single behaviour, specially when
> > NR_CTX_REGS is unconditionally sized to hold 13 regs.
>
> I'm fine with dropping the ifdefs here in v5 unless someone objects to this.

Oh, yeah I guess it would be good to be consistent.  Rather than drop
the ifdefs, would you (Marc) be ok with conditionally setting
NR_CTX_REGS based on CONFIG_SHADOW_CALL_STACK, and doing so in KVM?
(So 3 ifdefs, rather than 0)?

Without any conditionals or comments, it's not clear why x18 is being
saved and restored (unless git blame survives, or a comment is added
in place of the ifdefs in v6).
-- 
Thanks,
~Nick Desaulniers
