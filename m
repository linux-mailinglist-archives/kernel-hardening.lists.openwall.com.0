Return-Path: <kernel-hardening-return-19187-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 763D720C915
	for <lists+kernel-hardening@lfdr.de>; Sun, 28 Jun 2020 18:57:38 +0200 (CEST)
Received: (qmail 9327 invoked by uid 550); 28 Jun 2020 16:57:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9292 invoked from network); 28 Jun 2020 16:57:27 -0000
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-06.nifty.com 05SGuus9025290
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
	s=dec2015msa; t=1593363417;
	bh=dzgWJCQRhelJ3hJ0whBHzpzDiUuuI9JauHMlySTBPIU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=pQVYjDhzrsJA6M7XpxbJqHnruHm5X7g3n1Kzkw5zIgfgjDRo+j3deI8xW2don1xHR
	 SO+SQYBUZEyFCUrGc50KFSaD6YGpHcgOKivDLJFzcFvMcZFDoPh826AnzwDJ/dTlcZ
	 XEHXkbH3vze9eTTjPhA7py9Zff0qRrVUxiwkXyF0tIgZ4rdkeQox0ibMhHZYMY/erK
	 zHU1NLw3Y18syCdL5Ik0bFu8+9v5P2RWmtIFa7ICyZ8tDEiHkIvajb/YAroj4VMm13
	 gNClWmaKr+LUcfv6+gze80dpCl/cxi0AKBoUjJ4gBkf7NT1SlwUhJRo1YxZ8+yAd8X
	 G4UFTF0GMf0Qw==
X-Nifty-SrcIP: [209.85.222.45]
X-Gm-Message-State: AOAM530DPMpmDXNrtyRflY3FmFiFpgdd0VgMl5wdzCafwY4KEFVcVNgr
	NZ82qPRdivdf59H2IKHE4fQ9coLHejNcRrAt7Ac=
X-Google-Smtp-Source: ABdhPJyMuCHcA0fUYMlHXkn2vrcpvctKNxRD41GXgGVOqeU3V4PpT9PTQAU55moKry8aIAY4mBAqmLgVOy+XRSWLbeg=
X-Received: by 2002:ab0:156d:: with SMTP id p42mr8396563uae.121.1593363415963;
 Sun, 28 Jun 2020 09:56:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
In-Reply-To: <20200624203200.78870-1-samitolvanen@google.com>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Mon, 29 Jun 2020 01:56:19 +0900
X-Gmail-Original-Message-ID: <CAK7LNASvb0UDJ0U5wkYYRzTAdnEs64HjXpEUL7d=V0CXiAXcNw@mail.gmail.com>
Message-ID: <CAK7LNASvb0UDJ0U5wkYYRzTAdnEs64HjXpEUL7d=V0CXiAXcNw@mail.gmail.com>
Subject: Re: [PATCH 00/22] add support for Clang LTO
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>,
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
        linux-pci@vger.kernel.org, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Jun 25, 2020 at 5:32 AM 'Sami Tolvanen' via Clang Built Linux
<clang-built-linux@googlegroups.com> wrote:
>
> This patch series adds support for building x86_64 and arm64 kernels
> with Clang's Link Time Optimization (LTO).
>
> In addition to performance, the primary motivation for LTO is to allow
> Clang's Control-Flow Integrity (CFI) to be used in the kernel. Google's
> Pixel devices have shipped with LTO+CFI kernels since 2018.
>
> Most of the patches are build system changes for handling LLVM bitcode,
> which Clang produces with LTO instead of ELF object files, postponing
> ELF processing until a later stage, and ensuring initcall ordering.
>
> Note that first objtool patch in the series is already in linux-next,
> but as it's needed with LTO, I'm including it also here to make testing
> easier.


I put this series on a testing branch,
and 0-day bot started reporting some issues.

(but 0-day bot is quieter than I expected.
Perhaps, 0-day bot does not turn on LLVM=1 ?)



I also got an error for
ARCH=arm64 allyesconfig + CONFIG_LTO_CLANG=y



$ make ARCH=arm64 LLVM=1 LLVM_IAS=1
CROSS_COMPILE=~/tools/aarch64-linaro-7.5/bin/aarch64-linux-gnu-
-j24

  ...

  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  AR      init/built-in.a
  GEN     .tmp_initcalls.lds
  GEN     .tmp_symversions.lds
  LTO     vmlinux.o
  MODPOST vmlinux.symvers
  MODINFO modules.builtin.modinfo
  GEN     modules.builtin
  LD      .tmp_vmlinux.kallsyms1
ld.lld: error: undefined symbol: __compiletime_assert_905
>>> referenced by irqbypass.c
>>>               vmlinux.o:(jeq_imm)
make: *** [Makefile:1161: vmlinux] Error 1








> Sami Tolvanen (22):
>   objtool: use sh_info to find the base for .rela sections
>   kbuild: add support for Clang LTO
>   kbuild: lto: fix module versioning
>   kbuild: lto: fix recordmcount
>   kbuild: lto: postpone objtool
>   kbuild: lto: limit inlining
>   kbuild: lto: merge module sections
>   kbuild: lto: remove duplicate dependencies from .mod files
>   init: lto: ensure initcall ordering
>   init: lto: fix PREL32 relocations
>   pci: lto: fix PREL32 relocations
>   modpost: lto: strip .lto from module names
>   scripts/mod: disable LTO for empty.c
>   efi/libstub: disable LTO
>   drivers/misc/lkdtm: disable LTO for rodata.o
>   arm64: export CC_USING_PATCHABLE_FUNCTION_ENTRY
>   arm64: vdso: disable LTO
>   arm64: allow LTO_CLANG and THINLTO to be selected
>   x86, vdso: disable LTO only for vDSO
>   x86, ftrace: disable recordmcount for ftrace_make_nop
>   x86, relocs: Ignore L4_PAGE_OFFSET relocations
>   x86, build: allow LTO_CLANG and THINLTO to be selected
>
>  .gitignore                            |   1 +
>  Makefile                              |  27 ++-
>  arch/Kconfig                          |  65 +++++++
>  arch/arm64/Kconfig                    |   2 +
>  arch/arm64/Makefile                   |   1 +
>  arch/arm64/kernel/vdso/Makefile       |   4 +-
>  arch/x86/Kconfig                      |   2 +
>  arch/x86/Makefile                     |   5 +
>  arch/x86/entry/vdso/Makefile          |   5 +-
>  arch/x86/kernel/ftrace.c              |   1 +
>  arch/x86/tools/relocs.c               |   1 +
>  drivers/firmware/efi/libstub/Makefile |   2 +
>  drivers/misc/lkdtm/Makefile           |   1 +
>  include/asm-generic/vmlinux.lds.h     |  12 +-
>  include/linux/compiler-clang.h        |   4 +
>  include/linux/compiler.h              |   2 +-
>  include/linux/compiler_types.h        |   4 +
>  include/linux/init.h                  |  78 +++++++-
>  include/linux/pci.h                   |  15 +-
>  kernel/trace/ftrace.c                 |   1 +
>  lib/Kconfig.debug                     |   2 +-
>  scripts/Makefile.build                |  55 +++++-
>  scripts/Makefile.lib                  |   6 +-
>  scripts/Makefile.modfinal             |  40 +++-
>  scripts/Makefile.modpost              |  26 ++-
>  scripts/generate_initcall_order.pl    | 270 ++++++++++++++++++++++++++
>  scripts/link-vmlinux.sh               | 100 +++++++++-
>  scripts/mod/Makefile                  |   1 +
>  scripts/mod/modpost.c                 |  16 +-
>  scripts/mod/modpost.h                 |   9 +
>  scripts/mod/sumversion.c              |   6 +-
>  scripts/module-lto.lds                |  26 +++
>  scripts/recordmcount.c                |   3 +-
>  tools/objtool/elf.c                   |   2 +-
>  34 files changed, 737 insertions(+), 58 deletions(-)
>  create mode 100755 scripts/generate_initcall_order.pl
>  create mode 100644 scripts/module-lto.lds
>
>
> base-commit: 26e122e97a3d0390ebec389347f64f3730fdf48f
> --
> 2.27.0.212.ge8ba1cc988-goog
>
> --
> You received this message because you are subscribed to the Google Groups "Clang Built Linux" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to clang-built-linux+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/clang-built-linux/20200624203200.78870-1-samitolvanen%40google.com.



--
Best Regards
Masahiro Yamada
