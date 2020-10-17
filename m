Return-Path: <kernel-hardening-return-20218-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id AEB07290E84
	for <lists+kernel-hardening@lfdr.de>; Sat, 17 Oct 2020 03:47:28 +0200 (CEST)
Received: (qmail 3248 invoked by uid 550); 17 Oct 2020 01:47:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3207 invoked from network); 17 Oct 2020 01:47:18 -0000
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com 09H1kmXo014138
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
	s=dec2015msa; t=1602899208;
	bh=/0ovXshOhxLJmlzp2NpX2ArKIwhaV5c9daLvgg85jsg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=chx05RkX7GCKZyWpuSLuzUcaboKYmZoSKNbzGUJt0gBUdcrT2qa+LLPe9tQFy3cZ8
	 pl0jvQqfzdXtfaoOi6Wnzsewt5Q4fjtOQA7rvmShP8uoif8DXJBu5Vvc3SOgeM9D05
	 Hgd/aTo+tf1kqJ1bST0PafNHogLlTHwNpWOaAiKcJykTMfteinXCh4/xwgZpYB3dZl
	 F9SjcKuk1GdRlzIapbjzlO9Zm1VUXdGHDOTMhpClXmx6qHhoiLn+pehUdUrv7Z6SH7
	 5auxFgEVmi5TxHkwpq4AghUGA2JM+0nv5kKxxwSfd3yaHhjqm3G0B7iG7We6rQWzZ5
	 7HgZYEV/GgtOA==
X-Nifty-SrcIP: [209.85.216.50]
X-Gm-Message-State: AOAM533lAu9ero48euZbQOoE8KOk2jKRz/H26sA3+Jp9jRY7uuJYOD3q
	iCpN89/3Vigo+5piQPJ/lbhaEFlgi7Pw9ASjlUk=
X-Google-Smtp-Source: ABdhPJwnDvT6VOCCvby8Z+dRxKHlAcETSIANPUgxy4yeQxdCEUHUrDGlLwfVIqt5UgjHFKL6uGwJ8RIXqDyJ0U/afPU=
X-Received: by 2002:a17:90a:aa91:: with SMTP id l17mr6700984pjq.198.1602899207791;
 Fri, 16 Oct 2020 18:46:47 -0700 (PDT)
MIME-Version: 1.0
References: <20201013003203.4168817-1-samitolvanen@google.com>
 <20201013003203.4168817-8-samitolvanen@google.com> <202010141541.E689442E@keescook>
In-Reply-To: <202010141541.E689442E@keescook>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Sat, 17 Oct 2020 10:46:10 +0900
X-Gmail-Original-Message-ID: <CAK7LNASCaf2s94L1xYENYDYp07sTWxpnr4V_SKXfDFQKBB5drA@mail.gmail.com>
Message-ID: <CAK7LNASCaf2s94L1xYENYDYp07sTWxpnr4V_SKXfDFQKBB5drA@mail.gmail.com>
Subject: Re: [PATCH v6 07/25] treewide: remove DISABLE_LTO
To: Kees Cook <keescook@chromium.org>
Cc: Sami Tolvanen <samitolvanen@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 15, 2020 at 7:43 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Mon, Oct 12, 2020 at 05:31:45PM -0700, Sami Tolvanen wrote:
> > This change removes all instances of DISABLE_LTO from
> > Makefiles, as they are currently unused, and the preferred
> > method of disabling LTO is to filter out the flags instead.
> >
> > Suggested-by: Kees Cook <keescook@chromium.org>
> > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> > Reviewed-by: Kees Cook <keescook@chromium.org>
>
> Hi Masahiro,
>
> Since this is independent of anything else and could be seen as a
> general cleanup, can this patch be taken into your tree, just to
> separate it from the list of dependencies for this series?
>
> -Kees
>
> --
> Kees Cook



Yes, this is stale code because GCC LTO was not pulled.

Applied to linux-kbuild.

I added the following historical background.



Note added by Masahiro Yamada:
DISABLE_LTO was added as preparation for GCC LTO, but GCC LTO was
not pulled into the mainline. (https://lkml.org/lkml/2014/4/8/272)




-- 
Best Regards
Masahiro Yamada
