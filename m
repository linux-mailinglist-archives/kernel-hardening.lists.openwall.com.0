Return-Path: <kernel-hardening-return-20074-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B324727F4EB
	for <lists+kernel-hardening@lfdr.de>; Thu,  1 Oct 2020 00:13:17 +0200 (CEST)
Received: (qmail 28560 invoked by uid 550); 30 Sep 2020 22:13:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28521 invoked from network); 30 Sep 2020 22:13:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/5JyINSMzWB8voXWZyV8ASlSh5pqRDmgZFl229b53xc=;
        b=vIRIWKYp7RTSUGB8ntUgtpTfuIX9PNECXrtz7OF4WuzjxaB6ucqKe+labxFFw91k3e
         QxLYAkxotsyYRcimIeAn7Z8xictu3hpLg464s+yhLPGoBBznroXq6KWSnvggTT+OKc+4
         aDiohWxi2bv6qcv/jsb8X6MLhFKoc5VlhLVAgI9mvRP+ESLwvXgjzFulM/aycHPXZ43C
         1PZWgQU//0UlvKQQQTsVxdhKKn2R1cZHSse1ucxAjFxlIjoTBB5mxWh5AjLIfsBpQ8Qr
         kwHSrW70qM469yHzjDZCiyJ6JH0YYN8N5o79By5EDLYjMuAR2Pr4Z/ShSwy2ytzZ+9o+
         xxNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/5JyINSMzWB8voXWZyV8ASlSh5pqRDmgZFl229b53xc=;
        b=BwwAXhk/QxEIlr6iHRvTGHuqi5Dd5fofiy1GT84wjxDj3tGNSoOWTKptrOegIgXTj9
         1aheFwfyMsEleua5D1ZbztUdCaqxzltY9b+ZmlNIrXTZs8Y5voTeKIF8NsCiuVM9IHQi
         u9KQ497g3SBOAaXYWqUUWs1MkvCMEayUFlBvEpZPIeYHpBYcC4Dy9CU7UxtI4pu/pFIF
         oEOq9ajy3i9yWZPgW1vN65/bBeI2CMh/76lxK+eH7aqxNQoYSt0L0qiqPd6/1W6cLSil
         7KHmLGBLah+3GeKziyjdkTHH3/+aNQx/Jic3BPuLzryb95LHyyOCrRCuhwn+/E3dfMJT
         LHvw==
X-Gm-Message-State: AOAM530jv2LAoYJNsqH6/t9CC4A0PRH/lW5rc0QEc7pO348Z5ro8tHoQ
	QQ4e5CYFwbMwlAJO7Duv/hwB+28rJLU2n8FLK/oOfg==
X-Google-Smtp-Source: ABdhPJzjWahTDCS64Nwdg2Qz+9IkGNUdbgNKy/rFx3FC7CVjfHrBmMTaxElMCOz9QatJ5KolJbRCcmnwy3926ope18M=
X-Received: by 2002:aa7:c0d3:: with SMTP id j19mr5304520edp.40.1601503980129;
 Wed, 30 Sep 2020 15:13:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200929214631.3516445-1-samitolvanen@google.com> <CAKwvOdnYBkUx9YpY9XLONbNYFD7JrOfGbRFQ8ZTf-sa2GTgQdQ@mail.gmail.com>
In-Reply-To: <CAKwvOdnYBkUx9YpY9XLONbNYFD7JrOfGbRFQ8ZTf-sa2GTgQdQ@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Wed, 30 Sep 2020 15:12:49 -0700
Message-ID: <CABCJKufUU=s6GcRCRcmuKnANtyyKEBNJVuaPw416C1OPNgywEQ@mail.gmail.com>
Subject: Re: [PATCH v4 00/29] Add support for Clang LTO
To: Nick Desaulniers <ndesaulniers@google.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Sep 30, 2020 at 2:58 PM Nick Desaulniers
<ndesaulniers@google.com> wrote:
>
> On Tue, Sep 29, 2020 at 2:46 PM Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > This patch series adds support for building x86_64 and arm64 kernels
> > with Clang's Link Time Optimization (LTO).
> >
> > In addition to performance, the primary motivation for LTO is
> > to allow Clang's Control-Flow Integrity (CFI) to be used in the
> > kernel. Google has shipped millions of Pixel devices running three
> > major kernel versions with LTO+CFI since 2018.
> >
> > Most of the patches are build system changes for handling LLVM
> > bitcode, which Clang produces with LTO instead of ELF object files,
> > postponing ELF processing until a later stage, and ensuring initcall
> > ordering.
>
> Sami, thanks for continuing to drive the series. I encourage you to
> keep resending with fixes accumulated or dropped on a weekly cadence.
>
> The series worked well for me on arm64, but for x86_64 on mainline I
> saw a stream of new objtool warnings:
[...]

Objtool normally won't print out these warnings when run on vmlinux.o,
but we can't pass --vmlinux to objtool as that also implies noinstr
validation right now. I think we'd have to split that from --vmlinux
to avoid these. I can include a patch to add a --noinstr flag in v5.
Peter, any thoughts about this?

> I think those should be resolved before I provide any kind of tested
> by tag.  My other piece of feedback was that I like the default
> ThinLTO, but I think the help text in the Kconfig which is visible
> during menuconfig could be improved by informing the user the
> tradeoffs.  For example, if CONFIG_THINLTO is disabled, it should be
> noted that full LTO will be used instead.  Also, that full LTO may
> produce slightly better optimized binaries than ThinLTO, at the cost
> of not utilizing multiple cores when linking and thus significantly
> slower to link.
>
> Maybe explaining that setting it to "n" implies a full LTO build,
> which will be much slower to link but possibly slightly faster would
> be good?  It's not visible unless LTO_CLANG and ARCH_SUPPORTS_THINLTO
> is enabled, so I don't think you need to explain that THINLTO without
> those is *not* full LTO.  I'll leave the precise wording to you. WDYT?

Sure, sounds good. I'll update the help text in the next version.

> Also, when I look at your treewide DISABLE_LTO patch, I think "does
> that need to be a part of this series, or is it a cleanup that can
> stand on its own?"  I think it may be the latter?  Maybe it would help
> shed one more patch than to have to carry it to just send it?  Or did
> I miss something as to why it should remain a part of this series?

I suppose it could be stand-alone, but as these patches are also
disabling LTO by filtering out flags in some of the same files,
removing the unused DISABLE_LTO flags first would reduce confusion.
But I'm fine with sending it separately too if that's preferred.

Sami
