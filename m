Return-Path: <kernel-hardening-return-20430-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E27AB2BA775
	for <lists+kernel-hardening@lfdr.de>; Fri, 20 Nov 2020 11:30:24 +0100 (CET)
Received: (qmail 28582 invoked by uid 550); 20 Nov 2020 10:30:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28558 invoked from network); 20 Nov 2020 10:30:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1605868203;
	bh=R4qqlo9ybQQpHALTqDaShX23td1huHrJiPzN69McErc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=SnR3qKLySWFRIruzomBuZDnTaQEnQH9LMLNVTjpAvibM5jn/7i4Q1X3bOV7n8tXdM
	 bjQaV/OejDfDwwpl6TmQyCOukPReHlqO0/lbbLOb0E+eO8nW5oen1R0XvyX9QjTMqN
	 RD7mocgp9rrIxbpEyyku8nBmtb5VHSscycd3UnPI=
X-Gm-Message-State: AOAM532iq1bDxDS8e+Kvz9P5MW+HfWvW+WR2oCyTdK0VDrkwuWnwTdGZ
	cRtds9wf3SqTwVEtu/kt5lQaGX5m/jmaUxdVRok=
X-Google-Smtp-Source: ABdhPJyo1od5y8s3UXvXlpGDBDC/YwS8pW+UvtOnS5PYbG7GW+X/slcudfLbqeiD8uskrebS5/XeZyMUfAreexCHPzg=
X-Received: by 2002:a05:6830:214c:: with SMTP id r12mr12560072otd.90.1605868202443;
 Fri, 20 Nov 2020 02:30:02 -0800 (PST)
MIME-Version: 1.0
References: <20201118220731.925424-1-samitolvanen@google.com> <CAKwvOd=5PhCTZ-yHr08gPYNEsGEjZa=rDY0-unhkhofjXhqwLQ@mail.gmail.com>
In-Reply-To: <CAKwvOd=5PhCTZ-yHr08gPYNEsGEjZa=rDY0-unhkhofjXhqwLQ@mail.gmail.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 20 Nov 2020 11:29:51 +0100
X-Gmail-Original-Message-ID: <CAMj1kXEVzDi5=uteUAzG5E=j+aTCHEbMxwDfor-s=DthpREpyw@mail.gmail.com>
Message-ID: <CAMj1kXEVzDi5=uteUAzG5E=j+aTCHEbMxwDfor-s=DthpREpyw@mail.gmail.com>
Subject: Re: [PATCH v7 00/17] Add support for Clang LTO
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 19 Nov 2020 at 00:42, Nick Desaulniers <ndesaulniers@google.com> wrote:
>
> On Wed, Nov 18, 2020 at 2:07 PM Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > This patch series adds support for building the kernel with Clang's
> > Link Time Optimization (LTO). In addition to performance, the primary
> > motivation for LTO is to allow Clang's Control-Flow Integrity (CFI) to
> > be used in the kernel. Google has shipped millions of Pixel devices
> > running three major kernel versions with LTO+CFI since 2018.
> >
> > Most of the patches are build system changes for handling LLVM bitcode,
> > which Clang produces with LTO instead of ELF object files, postponing
> > ELF processing until a later stage, and ensuring initcall ordering.
> >
> > Note that v7 brings back arm64 support as Will has now staged the
> > prerequisite memory ordering patches [1], and drops x86_64 while we work
> > on fixing the remaining objtool warnings [2].
> >
> > [1] https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/log/?h=for-next/lto
> > [2] https://lore.kernel.org/lkml/20201114004911.aip52eimk6c2uxd4@treble/
> >
> > You can also pull this series from
> >
> >   https://github.com/samitolvanen/linux.git lto-v7
>
> Thanks for continuing to drive this series Sami.  For the series,
>
> Tested-by: Nick Desaulniers <ndesaulniers@google.com>
>
> I did virtualized boot tests with the series applied to aarch64
> defconfig without CONFIG_LTO, with CONFIG_LTO_CLANG, and a third time
> with CONFIG_THINLTO.  If you make changes to the series in follow ups,
> please drop my tested by tag from the modified patches and I'll help
> re-test.  Some minor feedback on the Kconfig change, but I'll post it
> off of that patch.
>

When you say 'virtualized" do you mean QEMU on x86? Or actual
virtualization on an AArch64 KVM host?

The distinction is important here, given the potential impact of LTO
on things that QEMU simply does not model when it runs in TCG mode on
a foreign host architecture.

> >
> > ---
> > Changes in v7:
> >
> >   - Rebased to master again.
> >
> >   - Added back arm64 patches as the prerequisites are now staged,
> >     and dropped x86_64 support until the remaining objtool issues
> >     are resolved.
> >
> >   - Dropped ifdefs from module.lds.S.
> >
> > Changes in v6:
> >
> >   - Added the missing --mcount flag to patch 5.
> >
> >   - Dropped the arm64 patches from this series and will repost them
> >     later.
> >
> > Changes in v5:
> >
> >   - Rebased on top of tip/master.
> >
> >   - Changed the command line for objtool to use --vmlinux --duplicate
> >     to disable warnings about retpoline thunks and to fix .orc_unwind
> >     generation for vmlinux.o.
> >
> >   - Added --noinstr flag to objtool, so we can use --vmlinux without
> >     also enabling noinstr validation.
> >
> >   - Disabled objtool's unreachable instruction warnings with LTO to
> >     disable false positives for the int3 padding in vmlinux.o.
> >
> >   - Added ANNOTATE_RETPOLINE_SAFE annotations to the indirect jumps
> >     in x86 assembly code to fix objtool warnings with retpoline.
> >
> >   - Fixed modpost warnings about missing version information with
> >     CONFIG_MODVERSIONS.
> >
> >   - Included Makefile.lib into Makefile.modpost for ld_flags. Thanks
> >     to Sedat for pointing this out.
> >
> >   - Updated the help text for ThinLTO to better explain the trade-offs.
> >
> >   - Updated commit messages with better explanations.
> >
> > Changes in v4:
> >
> >   - Fixed a typo in Makefile.lib to correctly pass --no-fp to objtool.
> >
> >   - Moved ftrace configs related to generating __mcount_loc to Kconfig,
> >     so they are available also in Makefile.modfinal.
> >
> >   - Dropped two prerequisite patches that were merged to Linus' tree.
> >
> > Changes in v3:
> >
> >   - Added a separate patch to remove the unused DISABLE_LTO treewide,
> >     as filtering out CC_FLAGS_LTO instead is preferred.
> >
> >   - Updated the Kconfig help to explain why LTO is behind a choice
> >     and disabled by default.
> >
> >   - Dropped CC_FLAGS_LTO_CLANG, compiler-specific LTO flags are now
> >     appended directly to CC_FLAGS_LTO.
> >
> >   - Updated $(AR) flags as KBUILD_ARFLAGS was removed earlier.
> >
> >   - Fixed ThinLTO cache handling for external module builds.
> >
> >   - Rebased on top of Masahiro's patch for preprocessing modules.lds,
> >     and moved the contents of module-lto.lds to modules.lds.S.
> >
> >   - Moved objtool_args to Makefile.lib to avoid duplication of the
> >     command line parameters in Makefile.modfinal.
> >
> >   - Clarified in the commit message for the initcall ordering patch
> >     that the initcall order remains the same as without LTO.
> >
> >   - Changed link-vmlinux.sh to use jobserver-exec to control the
> >     number of jobs started by generate_initcall_ordering.pl.
> >
> >   - Dropped the x86/relocs patch to whitelist L4_PAGE_OFFSET as it's
> >     no longer needed with ToT kernel.
> >
> >   - Disabled LTO for arch/x86/power/cpu.c to work around a Clang bug
> >     with stack protector attributes.
> >
> > Changes in v2:
> >
> >   - Fixed -Wmissing-prototypes warnings with W=1.
> >
> >   - Dropped cc-option from -fsplit-lto-unit and added .thinlto-cache
> >     scrubbing to make distclean.
> >
> >   - Added a comment about Clang >=11 being required.
> >
> >   - Added a patch to disable LTO for the arm64 KVM nVHE code.
> >
> >   - Disabled objtool's noinstr validation with LTO unless enabled.
> >
> >   - Included Peter's proposed objtool mcount patch in the series
> >     and replaced recordmcount with the objtool pass to avoid
> >     whitelisting relocations that are not calls.
> >
> >   - Updated several commit messages with better explanations.
> >
> >
> > Sami Tolvanen (17):
> >   tracing: move function tracer options to Kconfig
> >   kbuild: add support for Clang LTO
> >   kbuild: lto: fix module versioning
> >   kbuild: lto: limit inlining
> >   kbuild: lto: merge module sections
> >   kbuild: lto: remove duplicate dependencies from .mod files
> >   init: lto: ensure initcall ordering
> >   init: lto: fix PREL32 relocations
> >   PCI: Fix PREL32 relocations for LTO
> >   modpost: lto: strip .lto from module names
> >   scripts/mod: disable LTO for empty.c
> >   efi/libstub: disable LTO
> >   drivers/misc/lkdtm: disable LTO for rodata.o
> >   arm64: vdso: disable LTO
> >   KVM: arm64: disable LTO for the nVHE directory
> >   arm64: disable recordmcount with DYNAMIC_FTRACE_WITH_REGS
> >   arm64: allow LTO_CLANG and THINLTO to be selected
> >
> >  .gitignore                            |   1 +
> >  Makefile                              |  45 +++--
> >  arch/Kconfig                          |  74 +++++++
> >  arch/arm64/Kconfig                    |   4 +
> >  arch/arm64/kernel/vdso/Makefile       |   3 +-
> >  arch/arm64/kvm/hyp/nvhe/Makefile      |   4 +-
> >  drivers/firmware/efi/libstub/Makefile |   2 +
> >  drivers/misc/lkdtm/Makefile           |   1 +
> >  include/asm-generic/vmlinux.lds.h     |  11 +-
> >  include/linux/init.h                  |  79 +++++++-
> >  include/linux/pci.h                   |  19 +-
> >  kernel/trace/Kconfig                  |  16 ++
> >  scripts/Makefile.build                |  50 ++++-
> >  scripts/Makefile.lib                  |   6 +-
> >  scripts/Makefile.modfinal             |   9 +-
> >  scripts/Makefile.modpost              |  25 ++-
> >  scripts/generate_initcall_order.pl    | 270 ++++++++++++++++++++++++++
> >  scripts/link-vmlinux.sh               |  70 ++++++-
> >  scripts/mod/Makefile                  |   1 +
> >  scripts/mod/modpost.c                 |  16 +-
> >  scripts/mod/modpost.h                 |   9 +
> >  scripts/mod/sumversion.c              |   6 +-
> >  scripts/module.lds.S                  |  24 +++
> >  23 files changed, 677 insertions(+), 68 deletions(-)
> >  create mode 100755 scripts/generate_initcall_order.pl
> >
> >
> > base-commit: 0fa8ee0d9ab95c9350b8b84574824d9a384a9f7d
> > --
> > 2.29.2.299.gdc1121823c-goog
> >
>
>
> --
> Thanks,
> ~Nick Desaulniers
