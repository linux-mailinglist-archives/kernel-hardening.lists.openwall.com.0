Return-Path: <kernel-hardening-return-20544-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 52DAA2D304E
	for <lists+kernel-hardening@lfdr.de>; Tue,  8 Dec 2020 17:56:49 +0100 (CET)
Received: (qmail 27932 invoked by uid 550); 8 Dec 2020 16:56:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 27906 invoked from network); 8 Dec 2020 16:56:43 -0000
X-Gm-Message-State: AOAM531dHQ2tmeJNvlorEObyGCHLRr9jiQktEr52uhn03wkv41hC15M5
	0mFi6lINsVt0EzJjtUjYoPh/VX3iUFDoyg+P97k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1607446591;
	bh=B1Ufsz/HjvgeN7kz3QDMw7S3GkByLm0NCuUVzAQn1Nk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rKCUm2Ck4ZHiGtV3Faw/xe/XwRxizs0Y1E8mPa2BPGo+iAQuGAACvB1lE17EvxzKg
	 sdJSkWu621PR6JmuUkZx6X8EHHlXlnOsdG0rDzeO7AVEOFzr87aOubmE2c7gzWt3aK
	 eNJx8xYeGVKWGGDahCTTMnavuRRk2BKfmjTZ/05LYvPKiXmaLW2bTmwopmaLfdSvc0
	 23Vwwr+wxXb8d34MTPd7sKBTslRqgRAlCPdSJcelZFlAj4eFwgUY33mKDeCsiWNeEd
	 r4UMsDp/eQJwFwFv7h6XQMlireK6JR/Smu8K5arF+Eg7NP6qod4JmTEKKPd5LR/6hD
	 7j/SxXQTXGltQ==
X-Google-Smtp-Source: ABdhPJxgNl1Gj/l80SMEy+MnjbFlb4NpqPf4LKadCXveKp8gHoY+X2lTRnRws8sedD5yQTo7/pGCxoCJogqbCbMdTLQ=
X-Received: by 2002:a9d:be1:: with SMTP id 88mr17705895oth.210.1607446590334;
 Tue, 08 Dec 2020 08:56:30 -0800 (PST)
MIME-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com>
 <CAK8P3a1WEAo2SEgKUEs3SB7n7QeeHa0=cx_nO==rDK0jjDArow@mail.gmail.com>
 <CAK8P3a0AyciKoHzrgtaLxP9boo8WqZCe8YfPBzGPQ14PW_2KgQ@mail.gmail.com> <CABCJKudbCD3s0RcSVzbnn4MV=DadKOxOxar3jfiPWucX4JGxCg@mail.gmail.com>
In-Reply-To: <CABCJKudbCD3s0RcSVzbnn4MV=DadKOxOxar3jfiPWucX4JGxCg@mail.gmail.com>
From: Arnd Bergmann <arnd@kernel.org>
Date: Tue, 8 Dec 2020 17:56:13 +0100
X-Gmail-Original-Message-ID: <CAK8P3a32HwzZYDK3i68fY0JLGCj18RH1iDMq70OZpTrsopyCcw@mail.gmail.com>
Message-ID: <CAK8P3a32HwzZYDK3i68fY0JLGCj18RH1iDMq70OZpTrsopyCcw@mail.gmail.com>
Subject: Re: [PATCH v8 00/16] Add support for Clang LTO
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Dec 8, 2020 at 5:53 PM 'Sami Tolvanen' via Clang Built Linux
<clang-built-linux@googlegroups.com> wrote:
>
> > A small update here: I see this behavior with every single module
> > build, including 'tinyconfig' with one module enabled, and 'defconfig'.
>
> The .o file here is a thin archive of the bitcode files for the
> module. We compile .lto.o from that before modpost, because we need an
> ELF binary to process, and then reuse the .lto.o file when linking the
> final module.
>
> At no point should we link the .o file again, especially not with
> .lto.o, because that would clearly cause every symbol to be
> duplicated, so I'm not sure what goes wrong here. Here's the relevant
> part of scripts/Makefile.modfinal:
>
> ifdef CONFIG_LTO_CLANG
> # With CONFIG_LTO_CLANG, reuse the object file we compiled for modpost to
> # avoid a second slow LTO link
> prelink-ext := .lto
> ...
> $(modules): %.ko: %$(prelink-ext).o %.mod.o scripts/module.lds FORCE
>         +$(call if_changed,ld_ko_o)

Ah, it's probably a local problem now, as I had a merge conflict against
linux-next in this Makefile and I must have resolved the conflict incorrectly.

        Arnd
