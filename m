Return-Path: <kernel-hardening-return-17209-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id ABB52EBC74
	for <lists+kernel-hardening@lfdr.de>; Fri,  1 Nov 2019 04:46:11 +0100 (CET)
Received: (qmail 15959 invoked by uid 550); 1 Nov 2019 03:46:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15936 invoked from network); 1 Nov 2019 03:46:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Kif7QBlYH7HtQ8QoUYHWsgTTwYoxAYOD/DOI/uUcMFE=;
        b=PvBowQ8I1eLTJhTYXuVHJZMYoaY1/O8nPLjmt+zcY1xLezdPdRWGn2n4HDIZcjCvbI
         NHob5GFT5yXt/FXMihCaYtCBR4YaolJT3VSSuHx84Wle0iOsbg4QpAtTIhrPCOMiBDvn
         75yHNrecabFRtKKbwO6UJIuRAHJt9JwU/kz80=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Kif7QBlYH7HtQ8QoUYHWsgTTwYoxAYOD/DOI/uUcMFE=;
        b=bXxk0EUbNtuG60UFVDV1SuYJfqQSF+/XI/LvrdopuSrWXaQnPTA85KeWQT8iPbA+ic
         v3pmi64dlE8BzClOYoG8p16EUJ20v0rKpgBIFVAxiaoDECX6zA7gHPKP8oaYh72kVmd5
         gRcx4c5YqnvV6eUe6XskHF0upG3BUCle+4h0BlCM3FgLZJAkMfTC01yzpj6VA3XSO4kF
         4iuGAIVN/f2zhIU/a22SjoUfmlxLS8eB6eUk0wGUmkTXazzsfCYR98QPVK50jYhPUlu1
         fw6MSgp6itDCHuUWmYhtLQPyqQqcSZeV0y3/XMoTfadM566W0TE94IQIpm3b0ielZFjc
         GNIg==
X-Gm-Message-State: APjAAAVRWoYhGcFYd3uMCydlNVVIJEvqkP0lgH70w0b0ZDQSIpmH4qgK
	4msdDunl0IlvprtVMTOLNRWxsg==
X-Google-Smtp-Source: APXvYqxNU06p/uWWHHdHeQP2/XaFd2qFYhrmQSh39YdZ3rGPDuJG0Q+5SL1fgDuYw/eCwyxalIMr7Q==
X-Received: by 2002:a17:90a:3486:: with SMTP id p6mr12503340pjb.102.1572579951233;
        Thu, 31 Oct 2019 20:45:51 -0700 (PDT)
Date: Thu, 31 Oct 2019 20:45:48 -0700
From: Kees Cook <keescook@chromium.org>
To: samitolvanen@google.com
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Laura Abbott <labbott@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 17/17] arm64: implement Shadow Call Stack
Message-ID: <201910312042.5AF689AAC@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191031164637.48901-1-samitolvanen@google.com>
 <20191031164637.48901-18-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031164637.48901-18-samitolvanen@google.com>

On Thu, Oct 31, 2019 at 09:46:37AM -0700, samitolvanen@google.com wrote:
> This change implements shadow stack switching, initial SCS set-up,
> and interrupt shadow stacks for arm64.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

The only suggestion would be calling attention the clearing step (both in
comments below and in the commit log), just to record the earlier
discussion about it.

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  arch/arm64/Kconfig                   |  5 ++++
>  arch/arm64/include/asm/scs.h         | 37 ++++++++++++++++++++++++++
>  arch/arm64/include/asm/stacktrace.h  |  4 +++
>  arch/arm64/include/asm/thread_info.h |  3 +++
>  arch/arm64/kernel/Makefile           |  1 +
>  arch/arm64/kernel/asm-offsets.c      |  3 +++
>  arch/arm64/kernel/entry.S            | 28 ++++++++++++++++++++
>  arch/arm64/kernel/head.S             |  9 +++++++
>  arch/arm64/kernel/irq.c              |  2 ++
>  arch/arm64/kernel/process.c          |  2 ++
>  arch/arm64/kernel/scs.c              | 39 ++++++++++++++++++++++++++++
>  arch/arm64/kernel/smp.c              |  4 +++
>  12 files changed, 137 insertions(+)
>  create mode 100644 arch/arm64/include/asm/scs.h
>  create mode 100644 arch/arm64/kernel/scs.c
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 42867174920f..f4c94c5e8012 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -66,6 +66,7 @@ config ARM64
>  	select ARCH_USE_QUEUED_RWLOCKS
>  	select ARCH_USE_QUEUED_SPINLOCKS
>  	select ARCH_SUPPORTS_MEMORY_FAILURE
> +	select ARCH_SUPPORTS_SHADOW_CALL_STACK if CC_HAVE_SHADOW_CALL_STACK
>  	select ARCH_SUPPORTS_ATOMIC_RMW
>  	select ARCH_SUPPORTS_INT128 if GCC_VERSION >= 50000 || CC_IS_CLANG
>  	select ARCH_SUPPORTS_NUMA_BALANCING
> @@ -948,6 +949,10 @@ config ARCH_HAS_CACHE_LINE_SIZE
>  config ARCH_ENABLE_SPLIT_PMD_PTLOCK
>  	def_bool y if PGTABLE_LEVELS > 2
>  
> +# Supported by clang >= 7.0
> +config CC_HAVE_SHADOW_CALL_STACK
> +	def_bool $(cc-option, -fsanitize=shadow-call-stack -ffixed-x18)
> +
>  config SECCOMP
>  	bool "Enable seccomp to safely compute untrusted bytecode"
>  	---help---
> diff --git a/arch/arm64/include/asm/scs.h b/arch/arm64/include/asm/scs.h
> new file mode 100644
> index 000000000000..c50d2b0c6c5f
> --- /dev/null
> +++ b/arch/arm64/include/asm/scs.h
> @@ -0,0 +1,37 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_SCS_H
> +#define _ASM_SCS_H
> +
> +#ifndef __ASSEMBLY__
> +
> +#include <linux/scs.h>
> +
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +
> +extern void scs_init_irq(void);
> +
> +static __always_inline void scs_save(struct task_struct *tsk)
> +{
> +	void *s;
> +
> +	asm volatile("mov %0, x18" : "=r" (s));
> +	task_set_scs(tsk, s);
> +}
> +
> +static inline void scs_overflow_check(struct task_struct *tsk)
> +{
> +	if (unlikely(scs_corrupted(tsk)))
> +		panic("corrupted shadow stack detected inside scheduler\n");
> +}
> +
> +#else /* CONFIG_SHADOW_CALL_STACK */
> +
> +static inline void scs_init_irq(void) {}
> +static inline void scs_save(struct task_struct *tsk) {}
> +static inline void scs_overflow_check(struct task_struct *tsk) {}
> +
> +#endif /* CONFIG_SHADOW_CALL_STACK */
> +
> +#endif /* __ASSEMBLY __ */
> +
> +#endif /* _ASM_SCS_H */
> diff --git a/arch/arm64/include/asm/stacktrace.h b/arch/arm64/include/asm/stacktrace.h
> index 4d9b1f48dc39..b6cf32fb4efe 100644
> --- a/arch/arm64/include/asm/stacktrace.h
> +++ b/arch/arm64/include/asm/stacktrace.h
> @@ -68,6 +68,10 @@ extern void dump_backtrace(struct pt_regs *regs, struct task_struct *tsk);
>  
>  DECLARE_PER_CPU(unsigned long *, irq_stack_ptr);
>  
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +DECLARE_PER_CPU(unsigned long *, irq_shadow_call_stack_ptr);
> +#endif
> +
>  static inline bool on_irq_stack(unsigned long sp,
>  				struct stack_info *info)
>  {
> diff --git a/arch/arm64/include/asm/thread_info.h b/arch/arm64/include/asm/thread_info.h
> index f0cec4160136..8c73764b9ed2 100644
> --- a/arch/arm64/include/asm/thread_info.h
> +++ b/arch/arm64/include/asm/thread_info.h
> @@ -41,6 +41,9 @@ struct thread_info {
>  #endif
>  		} preempt;
>  	};
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +	void			*shadow_call_stack;
> +#endif
>  };
>  
>  #define thread_saved_pc(tsk)	\
> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
> index 478491f07b4f..b3995329d9e5 100644
> --- a/arch/arm64/kernel/Makefile
> +++ b/arch/arm64/kernel/Makefile
> @@ -63,6 +63,7 @@ obj-$(CONFIG_CRASH_CORE)		+= crash_core.o
>  obj-$(CONFIG_ARM_SDE_INTERFACE)		+= sdei.o
>  obj-$(CONFIG_ARM64_SSBD)		+= ssbd.o
>  obj-$(CONFIG_ARM64_PTR_AUTH)		+= pointer_auth.o
> +obj-$(CONFIG_SHADOW_CALL_STACK)		+= scs.o
>  
>  obj-y					+= vdso/ probes/
>  obj-$(CONFIG_COMPAT_VDSO)		+= vdso32/
> diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
> index 214685760e1c..f6762b9ae1e1 100644
> --- a/arch/arm64/kernel/asm-offsets.c
> +++ b/arch/arm64/kernel/asm-offsets.c
> @@ -33,6 +33,9 @@ int main(void)
>    DEFINE(TSK_TI_ADDR_LIMIT,	offsetof(struct task_struct, thread_info.addr_limit));
>  #ifdef CONFIG_ARM64_SW_TTBR0_PAN
>    DEFINE(TSK_TI_TTBR0,		offsetof(struct task_struct, thread_info.ttbr0));
> +#endif
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +  DEFINE(TSK_TI_SCS,		offsetof(struct task_struct, thread_info.shadow_call_stack));
>  #endif
>    DEFINE(TSK_STACK,		offsetof(struct task_struct, stack));
>  #ifdef CONFIG_STACKPROTECTOR
> diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
> index cf3bd2976e57..12a5bc209280 100644
> --- a/arch/arm64/kernel/entry.S
> +++ b/arch/arm64/kernel/entry.S
> @@ -172,6 +172,10 @@ alternative_cb_end
>  
>  	apply_ssbd 1, x22, x23
>  
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +	ldr	x18, [tsk, #TSK_TI_SCS]		// Restore shadow call stack
> +	str	xzr, [tsk, #TSK_TI_SCS]
> +#endif
>  	.else
>  	add	x21, sp, #S_FRAME_SIZE
>  	get_current_task tsk
> @@ -278,6 +282,12 @@ alternative_else_nop_endif
>  	ct_user_enter
>  	.endif
>  
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +	.if	\el == 0
> +	str	x18, [tsk, #TSK_TI_SCS]		// Save shadow call stack
> +	.endif
> +#endif
> +
>  #ifdef CONFIG_ARM64_SW_TTBR0_PAN
>  	/*
>  	 * Restore access to TTBR0_EL1. If returning to EL0, no need for SPSR
> @@ -383,6 +393,9 @@ alternative_insn eret, nop, ARM64_UNMAP_KERNEL_AT_EL0
>  
>  	.macro	irq_stack_entry
>  	mov	x19, sp			// preserve the original sp
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +	mov	x20, x18		// preserve the original shadow stack
> +#endif
>  
>  	/*
>  	 * Compare sp with the base of the task stack.
> @@ -400,6 +413,12 @@ alternative_insn eret, nop, ARM64_UNMAP_KERNEL_AT_EL0
>  
>  	/* switch to the irq stack */
>  	mov	sp, x26
> +
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +	/* also switch to the irq shadow stack */
> +	ldr_this_cpu x18, irq_shadow_call_stack_ptr, x26
> +#endif
> +
>  9998:
>  	.endm
>  
> @@ -409,6 +428,10 @@ alternative_insn eret, nop, ARM64_UNMAP_KERNEL_AT_EL0
>  	 */
>  	.macro	irq_stack_exit
>  	mov	sp, x19
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +	/* x20 is also preserved */
> +	mov	x18, x20
> +#endif
>  	.endm
>  
>  /* GPRs used by entry code */
> @@ -1155,6 +1178,11 @@ ENTRY(cpu_switch_to)
>  	ldr	lr, [x8]
>  	mov	sp, x9
>  	msr	sp_el0, x1
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +	str	x18, [x0, #TSK_TI_SCS]
> +	ldr	x18, [x1, #TSK_TI_SCS]
> +	str	xzr, [x1, #TSK_TI_SCS]

For example here.

> +#endif
>  	ret
>  ENDPROC(cpu_switch_to)
>  NOKPROBE(cpu_switch_to)
> diff --git a/arch/arm64/kernel/head.S b/arch/arm64/kernel/head.S
> index 989b1944cb71..2be977c6496f 100644
> --- a/arch/arm64/kernel/head.S
> +++ b/arch/arm64/kernel/head.S
> @@ -27,6 +27,7 @@
>  #include <asm/pgtable-hwdef.h>
>  #include <asm/pgtable.h>
>  #include <asm/page.h>
> +#include <asm/scs.h>
>  #include <asm/smp.h>
>  #include <asm/sysreg.h>
>  #include <asm/thread_info.h>
> @@ -424,6 +425,10 @@ __primary_switched:
>  	stp	xzr, x30, [sp, #-16]!
>  	mov	x29, sp
>  
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +	adr_l	x18, init_shadow_call_stack	// Set shadow call stack
> +#endif
> +
>  	str_l	x21, __fdt_pointer, x5		// Save FDT pointer
>  
>  	ldr_l	x4, kimage_vaddr		// Save the offset between
> @@ -731,6 +736,10 @@ __secondary_switched:
>  	ldr	x2, [x0, #CPU_BOOT_TASK]
>  	cbz	x2, __secondary_too_slow
>  	msr	sp_el0, x2
> +#ifdef CONFIG_SHADOW_CALL_STACK
> +	ldr	x18, [x2, #TSK_TI_SCS]		// Set shadow call stack
> +	str	xzr, [x2, #TSK_TI_SCS]

And here. Maybe something like "// Limit visibility of saved SCS"

-Kees

> +#endif
>  	mov	x29, #0
>  	mov	x30, #0
>  	b	secondary_start_kernel
> diff --git a/arch/arm64/kernel/irq.c b/arch/arm64/kernel/irq.c
> index 04a327ccf84d..fe0ca522ff60 100644
> --- a/arch/arm64/kernel/irq.c
> +++ b/arch/arm64/kernel/irq.c
> @@ -21,6 +21,7 @@
>  #include <linux/vmalloc.h>
>  #include <asm/daifflags.h>
>  #include <asm/vmap_stack.h>
> +#include <asm/scs.h>
>  
>  unsigned long irq_err_count;
>  
> @@ -63,6 +64,7 @@ static void init_irq_stacks(void)
>  void __init init_IRQ(void)
>  {
>  	init_irq_stacks();
> +	scs_init_irq();
>  	irqchip_init();
>  	if (!handle_arch_irq)
>  		panic("No interrupt controller found.");
> diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
> index 71f788cd2b18..5f0aec285848 100644
> --- a/arch/arm64/kernel/process.c
> +++ b/arch/arm64/kernel/process.c
> @@ -52,6 +52,7 @@
>  #include <asm/mmu_context.h>
>  #include <asm/processor.h>
>  #include <asm/pointer_auth.h>
> +#include <asm/scs.h>
>  #include <asm/stacktrace.h>
>  
>  #if defined(CONFIG_STACKPROTECTOR) && !defined(CONFIG_STACKPROTECTOR_PER_TASK)
> @@ -507,6 +508,7 @@ __notrace_funcgraph struct task_struct *__switch_to(struct task_struct *prev,
>  	uao_thread_switch(next);
>  	ptrauth_thread_switch(next);
>  	ssbs_thread_switch(next);
> +	scs_overflow_check(next);
>  
>  	/*
>  	 * Complete any pending TLB or cache maintenance on this CPU in case
> diff --git a/arch/arm64/kernel/scs.c b/arch/arm64/kernel/scs.c
> new file mode 100644
> index 000000000000..6f255072c9a9
> --- /dev/null
> +++ b/arch/arm64/kernel/scs.c
> @@ -0,0 +1,39 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Shadow Call Stack support.
> + *
> + * Copyright (C) 2019 Google LLC
> + */
> +
> +#include <linux/percpu.h>
> +#include <linux/vmalloc.h>
> +#include <asm/scs.h>
> +
> +DEFINE_PER_CPU(unsigned long *, irq_shadow_call_stack_ptr);
> +
> +#ifndef CONFIG_SHADOW_CALL_STACK_VMAP
> +DEFINE_PER_CPU(unsigned long [SCS_SIZE/sizeof(long)], irq_shadow_call_stack)
> +	__aligned(SCS_SIZE);
> +#endif
> +
> +void scs_init_irq(void)
> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +#ifdef CONFIG_SHADOW_CALL_STACK_VMAP
> +		unsigned long *p;
> +
> +		p = __vmalloc_node_range(SCS_SIZE, SCS_SIZE,
> +					 VMALLOC_START, VMALLOC_END,
> +					 SCS_GFP, PAGE_KERNEL,
> +					 0, cpu_to_node(cpu),
> +					 __builtin_return_address(0));
> +
> +		per_cpu(irq_shadow_call_stack_ptr, cpu) = p;
> +#else
> +		per_cpu(irq_shadow_call_stack_ptr, cpu) =
> +			per_cpu(irq_shadow_call_stack, cpu);
> +#endif /* CONFIG_SHADOW_CALL_STACK_VMAP */
> +	}
> +}
> diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
> index dc9fe879c279..cc1938a585d2 100644
> --- a/arch/arm64/kernel/smp.c
> +++ b/arch/arm64/kernel/smp.c
> @@ -44,6 +44,7 @@
>  #include <asm/pgtable.h>
>  #include <asm/pgalloc.h>
>  #include <asm/processor.h>
> +#include <asm/scs.h>
>  #include <asm/smp_plat.h>
>  #include <asm/sections.h>
>  #include <asm/tlbflush.h>
> @@ -357,6 +358,9 @@ void cpu_die(void)
>  {
>  	unsigned int cpu = smp_processor_id();
>  
> +	/* Save the shadow stack pointer before exiting the idle task */
> +	scs_save(current);
> +
>  	idle_task_exit();
>  
>  	local_daif_mask();
> -- 
> 2.24.0.rc0.303.g954a862665-goog
> 

-- 
Kees Cook
