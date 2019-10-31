Return-Path: <kernel-hardening-return-17208-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 51590EB651
	for <lists+kernel-hardening@lfdr.de>; Thu, 31 Oct 2019 18:42:47 +0100 (CET)
Received: (qmail 21753 invoked by uid 550); 31 Oct 2019 17:42:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 21733 invoked from network); 31 Oct 2019 17:42:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SpMt9swBFV/X7pJxY11yJxvoU/jl5TYZqkYEwxVo1zk=;
        b=vyAZGLuQJaP6UmPU/5OivZeIeCWgYHlNvqLsuh7U3yYJqNwBg3VduUAZbxG7Wh6UWt
         vR9hiusZOPdTKmpPzcbCdthcVtfAuVWCA/M8pStelbzfHpRETEdtgYoVIO74pLVcS5Aj
         PDux1c/zr+9UcdqYc/u8vkoVsM0YeYHd9+PtmsdPd6I9nLItOy76IJT1irNZ7ZvnLPOp
         Awz0G6XV3jDbzYKy0ICsWxla4idyK6XrPywrZoHibV+ewA3guRirwYmw7BYI3lR697k/
         6y0spqBrB465HxukOz7+BvekqO5c7tmGdGe9sOFhPb3/TuqkcTuslnkiueSXTjL7kZ2a
         Exew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SpMt9swBFV/X7pJxY11yJxvoU/jl5TYZqkYEwxVo1zk=;
        b=N+w/xkL/buQ4ZjVhW3uASrevT9jo/mg1hy1eRBI8QbwKjVZqTzX2/662WELpDI7NGs
         xSc1ZE859VNmFZmob3VyTfnqvoyoKtgRR9le05Ee534MuHl1s7ehefP1PGMHl5dPqJdz
         9dWPPQtz6pmSqyLD1nT7twW/K+Fy92y8QcADIysyV/jmRAiUbKuzd9DA2W0bdM/VpP08
         RWlulu90p/0cOwDmnNyqsd3LIv9G8JBxdsqmVI82lfCcrlVP/uhNlQ8yYWFYlMx3aM1X
         B+auxWkuOxJBD20J3iMmvrL+HTb3sb5AhqyvfGhHqWgw20SG0thaczs2ndE+wJFy2+oY
         EKpw==
X-Gm-Message-State: APjAAAXgQNotyNXYR4roeG8JZF7W6w4ZjZRbDrPFUrEz0njqelH/rs8t
	dTimm+030xtlFGQ0sC2nEtt8XjrNULfYVds013Ac5g==
X-Google-Smtp-Source: APXvYqw74Dsa5tbwvZVY6ubm3mq6Ol0GpZBf3HyKWvRWHEbC8fAxc8l0X7gBK5dChGcDSWL/yjwxE6D5ZDxmwT29ntI=
X-Received: by 2002:a67:ed8b:: with SMTP id d11mr3309159vsp.104.1572543748924;
 Thu, 31 Oct 2019 10:42:28 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191031164637.48901-1-samitolvanen@google.com> <20191031164637.48901-14-samitolvanen@google.com>
 <CAKwvOd=kcPS1CU=AUjOPr7SAipPFhs-v_mXi=AbqW5Vp9XUaiw@mail.gmail.com>
 <CABCJKudb2_OH5CRFm64rxv-VVnuOrO-ZOrXRHg8hR98Vj+BzVw@mail.gmail.com> <CAKwvOd=dO2QjiRWegjCtnMmVguaJ2YHacJRP3SbVVy9jhx-BWw@mail.gmail.com>
In-Reply-To: <CAKwvOd=dO2QjiRWegjCtnMmVguaJ2YHacJRP3SbVVy9jhx-BWw@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Thu, 31 Oct 2019 10:42:17 -0700
Message-ID: <CABCJKueVVJNV2MibRkQGPbmpenK_b007kkHOoxfBHf1Wen2ENw@mail.gmail.com>
Subject: Re: [PATCH v3 13/17] arm64: preserve x18 when CPU is suspended
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 31, 2019 at 10:35 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Thu, Oct 31, 2019 at 10:27 AM Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > On Thu, Oct 31, 2019 at 10:18 AM Nick Desaulniers
> > <ndesaulniers@google.com> wrote:
> > > > +#ifdef CONFIG_SHADOW_CALL_STACK
> > > > +       ldr     x18, [x0, #96]
> > > > +       str     xzr, [x0, #96]
> > >
> > > How come we zero out x0+#96, but not for other offsets? Is this str necessary?
> >
> > It clears the shadow stack pointer from the sleep state buffer, which
> > is not strictly speaking necessary, but leaves one fewer place to find
> > it.
>
> That sounds like a good idea.  Consider adding comments or to the
> commit message so that the str doesn't get removed accidentally in the
> future.

Sure, I'll add a comment in the next version.

Sami
