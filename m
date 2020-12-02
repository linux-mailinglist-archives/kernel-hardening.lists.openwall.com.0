Return-Path: <kernel-hardening-return-20508-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C60192CB302
	for <lists+kernel-hardening@lfdr.de>; Wed,  2 Dec 2020 04:00:59 +0100 (CET)
Received: (qmail 15864 invoked by uid 550); 2 Dec 2020 03:00:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15844 invoked from network); 2 Dec 2020 03:00:51 -0000
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-02.nifty.com 0B230F5B008063
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
	s=dec2015msa; t=1606878015;
	bh=bae6OEGZccYsxihZZpKD9adLEYkbdiNBF+1eXUN2gTY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ucq+5afygNO9hVQg++YTDfIDVKEk9+zsLqE7JR393hi9krpQH7+bD0C8aAZMbFmbD
	 +OQ6i7CaMieOFlBqrS/SEBYvAqJ/sjzzA7xRxAnMD8SreXyM6oIIu95dQT2MpZC18o
	 /aL1rtTky94Z4HhsecQUfuTaFwt1lE5aXFKUMJk9+BuVy23J+24XI9rKKo704REfSC
	 ZwV31dws3Vzgm2VpY6w1pRGgf95MDOba6Pqu2Iaewf6pcIqiHur6dMHnyE05yF57ku
	 lCNFUdVMBhb2FZXQYnBu4ly7hRUR1xuEzi721w7dxVMmjU9ecGBkflNSyZ6BEnOHJZ
	 yxSDheoiBcWDQ==
X-Nifty-SrcIP: [209.85.214.178]
X-Gm-Message-State: AOAM533WB+T3xOa/AtPJOy37YV5t/iBlxK7KsLRdGPULGp+N/EyRDWaR
	GiGgOBApBQX3bDxo4re6/SyHwhtAxon/PPT1udA=
X-Google-Smtp-Source: ABdhPJxtoS2uIcM+4LbPLIZn8Kx+Yzfzjaw/Yg6CiGuVAmShSIC5gq9eCcR8svHa50umwklx7CPEGfnalqUCBoqVvvQ=
X-Received: by 2002:a17:902:bc86:b029:da:9da4:3092 with SMTP id
 bb6-20020a170902bc86b02900da9da43092mr549251plb.71.1606878014719; Tue, 01 Dec
 2020 19:00:14 -0800 (PST)
MIME-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com> <20201201213707.541432-3-samitolvanen@google.com>
In-Reply-To: <20201201213707.541432-3-samitolvanen@google.com>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Wed, 2 Dec 2020 11:59:37 +0900
X-Gmail-Original-Message-ID: <CAK7LNASMh1KysAB4+gU7_iuTW+5GT2_yMDevwpLwx0iqjxwmWw@mail.gmail.com>
Message-ID: <CAK7LNASMh1KysAB4+gU7_iuTW+5GT2_yMDevwpLwx0iqjxwmWw@mail.gmail.com>
Subject: Re: [PATCH v8 02/16] kbuild: add support for Clang LTO
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, Dec 2, 2020 at 6:37 AM 'Sami Tolvanen' via Clang Built Linux
<clang-built-linux@googlegroups.com> wrote:
>
> This change adds build system support for Clang's Link Time
> Optimization (LTO). With -flto, instead of ELF object files, Clang
> produces LLVM bitcode, which is compiled into native code at link
> time, allowing the final binary to be optimized globally. For more
> details, see:
>
>   https://llvm.org/docs/LinkTimeOptimization.html
>
> The Kconfig option CONFIG_LTO_CLANG is implemented as a choice,
> which defaults to LTO being disabled. To use LTO, the architecture
> must select ARCH_SUPPORTS_LTO_CLANG and support:
>
>   - compiling with Clang,
>   - compiling inline assembly with Clang's integrated assembler,
>   - and linking with LLD.
>
> While using full LTO results in the best runtime performance, the
> compilation is not scalable in time or memory. CONFIG_THINLTO
> enables ThinLTO, which allows parallel optimization and faster
> incremental builds. ThinLTO is used by default if the architecture
> also selects ARCH_SUPPORTS_THINLTO:
>
>   https://clang.llvm.org/docs/ThinLTO.html
>
> To enable LTO, LLVM tools must be used to handle bitcode files. The
> easiest way is to pass the LLVM=1 option to make:
>
>   $ make LLVM=1 defconfig
>   $ scripts/config -e LTO_CLANG
>   $ make LLVM=1
>
> Alternatively, at least the following LLVM tools must be used:
>
>   CC=clang LD=ld.lld AR=llvm-ar NM=llvm-nm
>
> To prepare for LTO support with other compilers, common parts are
> gated behind the CONFIG_LTO option, and LTO can be disabled for
> specific files by filtering out CC_FLAGS_LTO.
>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> ---
>  Makefile                          | 19 ++++++-
>  arch/Kconfig                      | 88 +++++++++++++++++++++++++++++++
>  include/asm-generic/vmlinux.lds.h | 11 ++--
>  scripts/Makefile.build            |  9 +++-
>  scripts/Makefile.modfinal         |  9 +++-
>  scripts/Makefile.modpost          | 21 +++++++-
>  scripts/link-vmlinux.sh           | 32 ++++++++---
>  7 files changed, 171 insertions(+), 18 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index 16b7f0890e75..f5cac2428efc 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -891,6 +891,21 @@ KBUILD_CFLAGS      += $(CC_FLAGS_SCS)
>  export CC_FLAGS_SCS
>  endif
>
> +ifdef CONFIG_LTO_CLANG
> +ifdef CONFIG_LTO_CLANG_THIN
> +CC_FLAGS_LTO   += -flto=thin -fsplit-lto-unit
> +KBUILD_LDFLAGS += --thinlto-cache-dir=$(extmod-prefix).thinlto-cache
> +else
> +CC_FLAGS_LTO   += -flto
> +endif
> +CC_FLAGS_LTO   += -fvisibility=default
> +endif
> +
> +ifdef CONFIG_LTO
> +KBUILD_CFLAGS  += $(CC_FLAGS_LTO)
> +export CC_FLAGS_LTO
> +endif
> +
>  ifdef CONFIG_DEBUG_FORCE_FUNCTION_ALIGN_32B
>  KBUILD_CFLAGS += -falign-functions=32
>  endif
> @@ -1471,7 +1486,7 @@ MRPROPER_FILES += include/config include/generated          \
>                   *.spec
>
>  # Directories & files removed with 'make distclean'
> -DISTCLEAN_FILES += tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS
> +DISTCLEAN_FILES += tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS .thinlto-cache
>
>  # clean - Delete most, but leave enough to build external modules
>  #
> @@ -1717,7 +1732,7 @@ PHONY += compile_commands.json
>
>  clean-dirs := $(KBUILD_EXTMOD)
>  clean: rm-files := $(KBUILD_EXTMOD)/Module.symvers $(KBUILD_EXTMOD)/modules.nsdeps \
> -       $(KBUILD_EXTMOD)/compile_commands.json
> +       $(KBUILD_EXTMOD)/compile_commands.json $(KBUILD_EXTMOD)/.thinlto-cache
>
>  PHONY += help
>  help:
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 56b6ccc0e32d..30907b554451 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -598,6 +598,94 @@ config SHADOW_CALL_STACK
>           reading and writing arbitrary memory may be able to locate them
>           and hijack control flow by modifying the stacks.
>
> +config LTO
> +       bool
> +       help
> +         Selected if the kernel will be built using the compiler's LTO feature.
> +
> +config LTO_CLANG
> +       bool
> +       select LTO
> +       help
> +         Selected if the kernel will be built using Clang's LTO feature.
> +
> +config ARCH_SUPPORTS_LTO_CLANG
> +       bool
> +       help
> +         An architecture should select this option if it supports:
> +         - compiling with Clang,
> +         - compiling inline assembly with Clang's integrated assembler,
> +         - and linking with LLD.
> +
> +config ARCH_SUPPORTS_LTO_CLANG_THIN
> +       bool
> +       help
> +         An architecture should select this option if it can support Clang's
> +         ThinLTO mode.
> +
> +config HAS_LTO_CLANG
> +       def_bool y
> +       # Clang >= 11: https://github.com/ClangBuiltLinux/linux/issues/510
> +       depends on CC_IS_CLANG && CLANG_VERSION >= 110000 && LD_IS_LLD
> +       depends on $(success,$(NM) --help | head -n 1 | grep -qi llvm)
> +       depends on $(success,$(AR) --help | head -n 1 | grep -qi llvm)
> +       depends on ARCH_SUPPORTS_LTO_CLANG
> +       depends on !FTRACE_MCOUNT_USE_RECORDMCOUNT
> +       depends on !KASAN
> +       depends on !GCOV_KERNEL
> +       depends on !MODVERSIONS
> +       help
> +         The compiler and Kconfig options support building with Clang's
> +         LTO.
> +
> +choice
> +       prompt "Link Time Optimization (LTO)"
> +       default LTO_NONE
> +       help
> +         This option enables Link Time Optimization (LTO), which allows the
> +         compiler to optimize binaries globally.
> +
> +         If unsure, select LTO_NONE. Note that LTO is very resource-intensive
> +         so it's disabled by default.
> +
> +config LTO_NONE
> +       bool "None"
> +       help
> +         Build the kernel normally, without Link Time Optimization (LTO).
> +
> +config LTO_CLANG_FULL
> +       bool "Clang Full LTO (EXPERIMENTAL)"
> +       depends on HAS_LTO_CLANG
> +       select LTO_CLANG
> +       help
> +          This option enables Clang's full Link Time Optimization (LTO), which
> +          allows the compiler to optimize the kernel globally. If you enable
> +          this option, the compiler generates LLVM bitcode instead of ELF
> +          object files, and the actual compilation from bitcode happens at
> +          the LTO link step, which may take several minutes depending on the
> +          kernel configuration. More information can be found from LLVM's
> +          documentation:
> +
> +           https://llvm.org/docs/LinkTimeOptimization.html
> +

This help document is misleading.
People who read the document would misunderstand how great this feature would.

This should be added in the commit log and Kconfig help:

            In contrast to the example in the documentation, Clang LTO
            for the kernel cannot remove any unreachable function or data.
            In fact, this results in even bigger vmlinux and modules.




-- 
Best Regards
Masahiro Yamada
