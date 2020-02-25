Return-Path: <kernel-hardening-return-17905-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4A61216ECB0
	for <lists+kernel-hardening@lfdr.de>; Tue, 25 Feb 2020 18:40:00 +0100 (CET)
Received: (qmail 30662 invoked by uid 550); 25 Feb 2020 17:39:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30636 invoked from network); 25 Feb 2020 17:39:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=pTqCjcEa9EXisQdFRd13/e3ghlAPwJ8mGDn87xFJvf0=;
        b=Iz9ghN3tolwdp5o/gROA8qqHM/EG5oy+3huSTpvW3SyUMEdU6sXAB0OPK+CNnYW5ai
         7vZmndBglgl4PIYwGFR4TwVIL+97BgxiQXwlTPUFmdSBJhjTW6OKADsHKPsws7u399Up
         SktbQBTcmbNdUcejNfw49le8LmkmuFRvQPHR8AuVYBcicnfYfmsfpiKIl4GiLdvn/Bts
         odApA50lf5YI74HQjP9tnGgkyYi3UD1GrlhLkzrtFZKbk5Rt+HK3JTH+m32NFQzCnZfo
         w2EipiDKUKEYYXomNUOPbv7jypz24xq0XICYqZhNgrQI/RH9Rvk/1RK47Vrfrfv9DfLG
         dOzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=pTqCjcEa9EXisQdFRd13/e3ghlAPwJ8mGDn87xFJvf0=;
        b=TCW4/9cK+MhOFZ5LAuf4HZfcaTXRYNol2d76TuiWeYFOY0N7UUhThTy+hObPMaL/zl
         JL6XTKRIlGFru5chssqc50EtfC9OHi2uBGADEjycz8wHaXxfiqtB3gKMhuGa1SMr7Jga
         iH64rrxMwWfX5CDXGE/7cyxgEWhoNjObDvCePY1Q6vA+OfuOaVrifJi4JDMEb8SIeWrG
         dsp4Z2neuOlJ6pe61i3rYarv0Aykb9OCSzVoBVay3EruJ8dwuRbGgYsOBsS8ZZor11TN
         /aZtZ6MZ+FOIgsUyg4p3vc2ZO4PKLlVhCrjVQyM1zfRVCoiOLOie/jRSnCT7er6hzcWo
         bVrg==
X-Gm-Message-State: APjAAAW0ke4QSda0w2/NkcamEeHpv/0RZ/Ln9lBH0PJC3yPW4lFXkcAx
	kthQl6v8hecqWh7IuAxp+LbWXnYaXsVELSXjN5Y=
X-Google-Smtp-Source: APXvYqxfsb5uSBRkmS+LtsgGjkJGKKupkdhq2wlH8nbQMAAzyqD76e3X2yMODI2NRGhLtk2pWC/SchFrfB8a0n1TzJg=
X-Received: by 2002:a05:620a:1326:: with SMTP id p6mr36826889qkj.50.1582652379174;
 Tue, 25 Feb 2020 09:39:39 -0800 (PST)
Date: Tue, 25 Feb 2020 09:39:21 -0800
In-Reply-To: <20191018161033.261971-1-samitolvanen@google.com>
Message-Id: <20200225173933.74818-1-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH v9 00/12] add support for Clang's Shadow Call Stack
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	James Morse <james.morse@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Mark Rutland <mark.rutland@arm.com>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

This patch series adds support for Clang's Shadow Call Stack
(SCS) mitigation, which uses a separately allocated shadow stack
to protect against return address overwrites. More information
can be found here:

  https://clang.llvm.org/docs/ShadowCallStack.html

SCS provides better protection against traditional buffer
overflows than CONFIG_STACKPROTECTOR_*, but it should be noted
that SCS security guarantees in the kernel differ from the ones
documented for user space. The kernel must store addresses of
shadow stacks used by inactive tasks and interrupt handlers in
memory, which means an attacker capable reading and writing
arbitrary memory may be able to locate them and hijack control
flow by modifying shadow stacks that are not currently in use.

SCS is currently supported only on arm64, where the compiler
requires the x18 register to be reserved for holding the current
task's shadow stack pointer.

With -fsanitize=shadow-call-stack, the compiler injects
instructions to all non-leaf C functions to store the return
address to the shadow stack, and unconditionally load it again
before returning. As a result, SCS is currently incompatible
with features that rely on modifying function return addresses
in the kernel stack to alter control flow. A copy of the return
address is still kept in the kernel stack for compatibility with
stack unwinding, for example.

SCS has a minimal performance overhead, but allocating
shadow stacks increases kernel memory usage. The feature is
therefore mostly useful on hardware that lacks support for PAC
instructions.

Changes in v9:
 - Fixed grammar in the Kconfig help text.
 - Changed Kconfig to allow SCS to be selected with the patchable-
   function-entry graph tracer.
 - Changed the EFI stub patch to not filter out -ffixed-x18, only
   SCS flags.

Changes in v8:
 - Added __noscs to __hyp_text instead of filtering SCS flags from
   the entire arch/arm64/kvm/hyp directory.
 - Added a patch to filter out -ffixed-x18 and SCS flags from the
   EFI stub.

Changes in v7:
 - Changed irq_stack_entry/exit to store the shadow stack pointer
   in x24 instead of x20 as kernel_entry uses x20-x23 to store
   data that can be used later. Updated the comment as well.
 - Changed the Makefile in arch/arm64/kvm/hyp to also filter out
   -ffixed-x18.
 - Changed SHADOW_CALL_STACK to depend on !FUNCTION_GRAPH_TRACER
   instead of not selecting HAVE_FUNCTION_GRAPH_TRACER with SCS.
 - Removed ifdefs from the EFI wrapper and updated the comment to
   explain why we are restoring x18.
 - Rebased as Ard's x18 patches that were part of this series have
   already been merged.

Changes in v6:
 - Updated comment in the EFI RT wrapper to include the
   explanation from the commit message.
 - Fixed the SHADOW_CALL_STACK_VMAP config option and the
   compilation errors in scs_init_irq()
 - Updated the comment in entry.S to Mark's suggestion
 - Fixed the WARN_ON in scs_init() to trip only when the return
   value for cpuhp_setup_state() is < 0.
 - Removed ifdefs from the code in arch/arm64/kernel/scs.c and
   added separate shadow stacks for the SDEI handler

Changes in v5:
 - Updated the comment in __scs_base() to Mark's suggestion
 - Changed all instances of uintptr_t to unsigned long
 - Added allocation poisoning for KASAN to catch unintentional
   shadow stack accesses; moved set_set_magic before poisoning
   and switched scs_used() and scs_corrupted() to access the
   buffer using READ_ONCE_NOCHECK() instead
 - Changed scs_free() to check for NULL instead of zero
 - Renamed SCS_CACHE_SIZE to NR_CACHED_SCS
 - Added a warning if cpuhp_setup_state fails in scs_init()
 - Dropped patches disabling kretprobes after confirming there's
   no functional conflict with SCS instrumentation
 - Added an explanation to the commit message why function graph
   tracing and SCS are incompatible
 - Removed the ifdefs from arch/arm64/mm/proc.S and added
   comments explaining why we are saving and restoring x18
 - Updated scs_check_usage format to include process information

Changes in v4:
 - Fixed authorship for Ard's patches
 - Added missing commit messages
 - Commented code that clears SCS from thread_info
 - Added a comment about SCS_END_MAGIC being non-canonical

Changes in v3:
 - Switched to filter-out for removing SCS flags in Makefiles
 - Changed the __noscs attribute to use __no_sanitize__("...")
   instead of no_sanitize("...")
 - Cleaned up inline function definitions and moved task_scs()
   into a macro
 - Cleaned up scs_free() and scs_magic()
 - Moved SCS initialization into dup_task_struct() and removed
   the now unused scs_task_init()
 - Added comments to __scs_base() and scs_task_reset() to better
   document design choices
 - Changed copy_page to make the offset and bias explicit

Changes in v2:
 - Changed Ard's KVM patch to use x29 instead of x18 for the
   guest context, which makes restore_callee_saved_regs cleaner
 - Updated help text (and commit messages) to point out
   differences in security properties compared to user space SCS
 - Cleaned up config options: removed the ROP protection choice,
   replaced the CC_IS_CLANG dependency with an arch-specific
   cc-option test, and moved disabling of incompatible config
   options to an arch-specific Kconfig
 - Added CC_FLAGS_SCS, which are filtered out where needed
   instead of using DISABLE_SCS
 - Added a __has_feature guard around __noscs for older clang
   versions

Sami Tolvanen (12):
  add support for Clang's Shadow Call Stack (SCS)
  scs: add accounting
  scs: add support for stack usage debugging
  scs: disable when function graph tracing is enabled
  arm64: reserve x18 from general allocation with SCS
  arm64: preserve x18 when CPU is suspended
  arm64: efi: restore x18 if it was corrupted
  arm64: vdso: disable Shadow Call Stack
  arm64: disable SCS for hypervisor code
  arm64: implement Shadow Call Stack
  arm64: scs: add shadow stacks for SDEI
  efi/libstub: disable SCS

 Makefile                              |   6 +
 arch/Kconfig                          |  35 ++++
 arch/arm64/Kconfig                    |   5 +
 arch/arm64/Makefile                   |   4 +
 arch/arm64/include/asm/kvm_hyp.h      |   2 +-
 arch/arm64/include/asm/scs.h          |  39 ++++
 arch/arm64/include/asm/suspend.h      |   2 +-
 arch/arm64/include/asm/thread_info.h  |   3 +
 arch/arm64/kernel/Makefile            |   1 +
 arch/arm64/kernel/asm-offsets.c       |   3 +
 arch/arm64/kernel/efi-rt-wrapper.S    |  11 +-
 arch/arm64/kernel/entry.S             |  46 ++++-
 arch/arm64/kernel/head.S              |   9 +
 arch/arm64/kernel/irq.c               |   2 +
 arch/arm64/kernel/process.c           |   2 +
 arch/arm64/kernel/scs.c               | 114 ++++++++++++
 arch/arm64/kernel/sdei.c              |   7 +
 arch/arm64/kernel/smp.c               |   4 +
 arch/arm64/kernel/vdso/Makefile       |   2 +-
 arch/arm64/mm/proc.S                  |  14 ++
 drivers/base/node.c                   |   6 +
 drivers/firmware/efi/libstub/Makefile |   3 +
 fs/proc/meminfo.c                     |   4 +
 include/linux/compiler-clang.h        |   6 +
 include/linux/compiler_types.h        |   4 +
 include/linux/mmzone.h                |   3 +
 include/linux/scs.h                   |  57 ++++++
 init/init_task.c                      |   8 +
 kernel/Makefile                       |   1 +
 kernel/fork.c                         |   9 +
 kernel/sched/core.c                   |   2 +
 kernel/scs.c                          | 246 ++++++++++++++++++++++++++
 mm/page_alloc.c                       |   6 +
 mm/vmstat.c                           |   3 +
 34 files changed, 662 insertions(+), 7 deletions(-)
 create mode 100644 arch/arm64/include/asm/scs.h
 create mode 100644 arch/arm64/kernel/scs.c
 create mode 100644 include/linux/scs.h
 create mode 100644 kernel/scs.c


base-commit: 63623fd44972d1ed2bfb6e0fb631dfcf547fd1e7
-- 
2.25.0.265.gbab2e86ba0-goog

