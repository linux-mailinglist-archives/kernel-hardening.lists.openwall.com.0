Return-Path: <kernel-hardening-return-18583-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 449451B1B9B
	for <lists+kernel-hardening@lfdr.de>; Tue, 21 Apr 2020 04:15:18 +0200 (CEST)
Received: (qmail 15994 invoked by uid 550); 21 Apr 2020 02:15:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15961 invoked from network); 21 Apr 2020 02:15:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zO2dq0dcbhJ815P0MdiGU5l5HoFPErQL7jVCuXU15vU=;
        b=jKUvEIXKjCwDi7VxiaGGgm+68jE8+gLIwtbS+nQGP2L55Kvgz6jrR0cg3HBLaQDoPT
         kj2PvdQC2DeAWJV72KovdvbTYG8nIjROlwRbD27sjH2MTne2b/KK5BXK5qOPzplqlfTY
         iO5582vvMRpdtqvwdFebuvlR0FXmT2jaD9u0mCUxAtbZPLb8Kznwu0LZButBO7qPGBHZ
         hkyBpvnTyccdUytXn6wZyT3yHsWk4yEhlsgEbDAonGBobz5iIBqCMgzXIw4VzeVAcf5r
         3/vnl6fgLtroSGs7JJlqY48dt4fsC2dUcO7gAweUIRtA+AYgk9akyAP57JmYvLnStf6s
         7Tog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zO2dq0dcbhJ815P0MdiGU5l5HoFPErQL7jVCuXU15vU=;
        b=tX1iPVd47D8ZmxBCp+EdNDkzKAEP9HGdxRLmEN955TSml90Fw/i5XzqR9K3Xw75644
         rozVuB/VaB1DGYgbdfKZt98It6xHuvUtAnyqDlwwPkoIH6WZQzyRyuDQa9TcpUy85fpK
         zIKsN4NruF2PLauafZiOzTEFstvfCKp9qeFgdT1mc/5iwVQQ3DqEI4hOljPPFlX6EmEL
         O9qZGU7hdt3mAUfNklIyhw3i4m23FSSJMOPNhSpkVYo/HpaGF/PM9jMtoi6snzPjYgPv
         R3h7zPrM+Ddq6DXmAq/VgOjUX4YkooBnjmJwqAvu9xx2XQ25W/2D+MbSvDMKvDIKtIST
         1xuw==
X-Gm-Message-State: AGi0PuZQGx4moO5mL3pt4tW4o9e7gry7td+am9TCHupuH9IeO0/53GX4
	XUrXFCBFGxqjj3NrsLuZrDcf7RjkCZBFu3LhEsk=
X-Google-Smtp-Source: APiQypI6hIcsvKrgAQe5tUAMEv7w3A4ud+O0jxc/RslUTwHtHvwlmXLhEyl2LbgnQXIEo+fNbdmgcHh423jngQPBqK4=
X-Received: by 2002:a17:90a:fc89:: with SMTP id ci9mr2810302pjb.140.1587435297066;
 Mon, 20 Apr 2020 19:14:57 -0700 (PDT)
Date: Mon, 20 Apr 2020 19:14:41 -0700
In-Reply-To: <20191018161033.261971-1-samitolvanen@google.com>
Message-Id: <20200421021453.198187-1-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v12 00/12] add support for Clang's Shadow Call Stack
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	James Morse <james.morse@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Michal Marek <michal.lkml@markovi.net>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Jann Horn <jannh@google.com>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
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
memory, which means an attacker capable of reading and writing
arbitrary memory may be able to locate them and hijack control
flow by modifying shadow stacks that are not currently in use.

SCS is currently supported only on arm64, where the compiler
requires the x18 register to be reserved for holding the current
task's shadow stack pointer.

With -fsanitize=shadow-call-stack, the compiler injects
instructions to all non-leaf C functions to store the return
address to the shadow stack, and unconditionally load it again
before returning. As a result, SCS is incompatible with features
that rely on modifying function return addresses in the kernel
stack to alter control flow. A copy of the return address is
still kept in the kernel stack for compatibility with stack
unwinding, for example.

SCS has a minimal performance overhead, but allocating
shadow stacks increases kernel memory usage. The feature is
therefore mostly useful on hardware that lacks support for PAC
instructions.

Changes in v12:
 - Removed CONFIG_SHADOW_CALL_STACK_VMAP.
 - Added CC_IS_CLANG as a dependency to CONFIG_SHADOW_CALL_STACK.
 - Changed SCS_END_MAGIC to use POISON_POINTER_DELTA.
 - Removed the unnecessary scs_set_magic() helper function.
 - Moved scs_task_reset() and scs_corrupted() to scs.h, along with
   __scs_magic() and __scs_base().
 - Removed a redundant warning from memory allocation.
 - Removed an unnecessary task_set_scs() call from scs_release().
 - Changed the accounting code to calculate KiB instead of bytes.
 - Replaced the lock in scs_check_usage() with a cmpxchg() loop.

Changes in v11:
 - Rebased, added maintainers for kernel/ changes.

Changes in v10:
 - Removed an unnecessary <asm/scs.h> include from head.S.

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

 Makefile                              |   6 ++
 arch/Kconfig                          |  26 ++++++
 arch/arm64/Kconfig                    |   5 ++
 arch/arm64/Makefile                   |   4 +
 arch/arm64/include/asm/kvm_hyp.h      |   2 +-
 arch/arm64/include/asm/scs.h          |  34 ++++++++
 arch/arm64/include/asm/suspend.h      |   2 +-
 arch/arm64/include/asm/thread_info.h  |   3 +
 arch/arm64/kernel/Makefile            |   1 +
 arch/arm64/kernel/asm-offsets.c       |   3 +
 arch/arm64/kernel/efi-rt-wrapper.S    |  11 ++-
 arch/arm64/kernel/entry.S             |  47 +++++++++-
 arch/arm64/kernel/head.S              |   8 ++
 arch/arm64/kernel/process.c           |   2 +
 arch/arm64/kernel/scs.c               |  21 +++++
 arch/arm64/kernel/smp.c               |   4 +
 arch/arm64/kernel/vdso/Makefile       |   2 +-
 arch/arm64/mm/proc.S                  |  14 +++
 drivers/base/node.c                   |   6 ++
 drivers/firmware/efi/libstub/Makefile |   3 +
 fs/proc/meminfo.c                     |   4 +
 include/linux/compiler-clang.h        |   6 ++
 include/linux/compiler_types.h        |   4 +
 include/linux/mmzone.h                |   3 +
 include/linux/scs.h                   |  92 ++++++++++++++++++++
 init/init_task.c                      |   8 ++
 kernel/Makefile                       |   1 +
 kernel/fork.c                         |   9 ++
 kernel/sched/core.c                   |   2 +
 kernel/scs.c                          | 121 ++++++++++++++++++++++++++
 mm/page_alloc.c                       |   6 ++
 mm/vmstat.c                           |   3 +
 32 files changed, 456 insertions(+), 7 deletions(-)
 create mode 100644 arch/arm64/include/asm/scs.h
 create mode 100644 arch/arm64/kernel/scs.c
 create mode 100644 include/linux/scs.h
 create mode 100644 kernel/scs.c


base-commit: ae83d0b416db002fe95601e7f97f64b59514d936
-- 
2.26.1.301.g55bc3eb7cb9-goog

