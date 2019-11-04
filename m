Return-Path: <kernel-hardening-return-17255-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7DF4AEDE04
	for <lists+kernel-hardening@lfdr.de>; Mon,  4 Nov 2019 12:52:01 +0100 (CET)
Received: (qmail 26329 invoked by uid 550); 4 Nov 2019 11:51:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26306 invoked from network); 4 Nov 2019 11:51:55 -0000
Date: Mon, 4 Nov 2019 11:51:39 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 03/17] arm64: kvm: stop treating register x18 as
 caller save
Message-ID: <20191104115138.GB45140@lakrids.cambridge.arm.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191101221150.116536-1-samitolvanen@google.com>
 <20191101221150.116536-4-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101221150.116536-4-samitolvanen@google.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)

On Fri, Nov 01, 2019 at 03:11:36PM -0700, Sami Tolvanen wrote:
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> In preparation of reserving x18, stop treating it as caller save in
> the KVM guest entry/exit code. Currently, the code assumes there is
> no need to preserve it for the host, given that it would have been
> assumed clobbered anyway by the function call to __guest_enter().
> Instead, preserve its value and restore it upon return.
> 
> Link: https://patchwork.kernel.org/patch/9836891/
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> [Sami: updated commit message, switched from x18 to x29 for the guest context]
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/arm64/kvm/hyp/entry.S | 41 +++++++++++++++++++-------------------
>  1 file changed, 20 insertions(+), 21 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
> index e5cc8d66bf53..c3c2d842c609 100644
> --- a/arch/arm64/kvm/hyp/entry.S
> +++ b/arch/arm64/kvm/hyp/entry.S
> @@ -23,6 +23,7 @@
>  	.pushsection	.hyp.text, "ax"
>  

Could we please add a note here, e.g.

/*
 * We treat x18 as callee-saved as the host may use it as a platform
 * register (e.g. for shadow call stack).
 */

... as that will avoid anyone trying to optimize this away in future
after reading the AAPCS.

>  .macro save_callee_saved_regs ctxt
> +	str	x18,      [\ctxt, #CPU_XREG_OFFSET(18)]
>  	stp	x19, x20, [\ctxt, #CPU_XREG_OFFSET(19)]
>  	stp	x21, x22, [\ctxt, #CPU_XREG_OFFSET(21)]
>  	stp	x23, x24, [\ctxt, #CPU_XREG_OFFSET(23)]
> @@ -32,6 +33,8 @@
>  .endm
>  
>  .macro restore_callee_saved_regs ctxt
> +	// We assume \ctxt is not x18-x28

Probably worth s/assume/require/ here.

Otherwise, this looks godo to me:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

Mark.

> +	ldr	x18,      [\ctxt, #CPU_XREG_OFFSET(18)]
>  	ldp	x19, x20, [\ctxt, #CPU_XREG_OFFSET(19)]
>  	ldp	x21, x22, [\ctxt, #CPU_XREG_OFFSET(21)]
>  	ldp	x23, x24, [\ctxt, #CPU_XREG_OFFSET(23)]
> @@ -48,7 +51,7 @@ ENTRY(__guest_enter)
>  	// x0: vcpu
>  	// x1: host context
>  	// x2-x17: clobbered by macros
> -	// x18: guest context
> +	// x29: guest context
>  
>  	// Store the host regs
>  	save_callee_saved_regs x1
> @@ -67,31 +70,28 @@ alternative_else_nop_endif
>  	ret
>  
>  1:
> -	add	x18, x0, #VCPU_CONTEXT
> +	add	x29, x0, #VCPU_CONTEXT
>  
>  	// Macro ptrauth_switch_to_guest format:
>  	// 	ptrauth_switch_to_guest(guest cxt, tmp1, tmp2, tmp3)
>  	// The below macro to restore guest keys is not implemented in C code
>  	// as it may cause Pointer Authentication key signing mismatch errors
>  	// when this feature is enabled for kernel code.
> -	ptrauth_switch_to_guest x18, x0, x1, x2
> +	ptrauth_switch_to_guest x29, x0, x1, x2
>  
>  	// Restore guest regs x0-x17
> -	ldp	x0, x1,   [x18, #CPU_XREG_OFFSET(0)]
> -	ldp	x2, x3,   [x18, #CPU_XREG_OFFSET(2)]
> -	ldp	x4, x5,   [x18, #CPU_XREG_OFFSET(4)]
> -	ldp	x6, x7,   [x18, #CPU_XREG_OFFSET(6)]
> -	ldp	x8, x9,   [x18, #CPU_XREG_OFFSET(8)]
> -	ldp	x10, x11, [x18, #CPU_XREG_OFFSET(10)]
> -	ldp	x12, x13, [x18, #CPU_XREG_OFFSET(12)]
> -	ldp	x14, x15, [x18, #CPU_XREG_OFFSET(14)]
> -	ldp	x16, x17, [x18, #CPU_XREG_OFFSET(16)]
> -
> -	// Restore guest regs x19-x29, lr
> -	restore_callee_saved_regs x18
> -
> -	// Restore guest reg x18
> -	ldr	x18,      [x18, #CPU_XREG_OFFSET(18)]
> +	ldp	x0, x1,   [x29, #CPU_XREG_OFFSET(0)]
> +	ldp	x2, x3,   [x29, #CPU_XREG_OFFSET(2)]
> +	ldp	x4, x5,   [x29, #CPU_XREG_OFFSET(4)]
> +	ldp	x6, x7,   [x29, #CPU_XREG_OFFSET(6)]
> +	ldp	x8, x9,   [x29, #CPU_XREG_OFFSET(8)]
> +	ldp	x10, x11, [x29, #CPU_XREG_OFFSET(10)]
> +	ldp	x12, x13, [x29, #CPU_XREG_OFFSET(12)]
> +	ldp	x14, x15, [x29, #CPU_XREG_OFFSET(14)]
> +	ldp	x16, x17, [x29, #CPU_XREG_OFFSET(16)]
> +
> +	// Restore guest regs x18-x29, lr
> +	restore_callee_saved_regs x29
>  
>  	// Do not touch any register after this!
>  	eret
> @@ -114,7 +114,7 @@ ENTRY(__guest_exit)
>  	// Retrieve the guest regs x0-x1 from the stack
>  	ldp	x2, x3, [sp], #16	// x0, x1
>  
> -	// Store the guest regs x0-x1 and x4-x18
> +	// Store the guest regs x0-x1 and x4-x17
>  	stp	x2, x3,   [x1, #CPU_XREG_OFFSET(0)]
>  	stp	x4, x5,   [x1, #CPU_XREG_OFFSET(4)]
>  	stp	x6, x7,   [x1, #CPU_XREG_OFFSET(6)]
> @@ -123,9 +123,8 @@ ENTRY(__guest_exit)
>  	stp	x12, x13, [x1, #CPU_XREG_OFFSET(12)]
>  	stp	x14, x15, [x1, #CPU_XREG_OFFSET(14)]
>  	stp	x16, x17, [x1, #CPU_XREG_OFFSET(16)]
> -	str	x18,      [x1, #CPU_XREG_OFFSET(18)]
>  
> -	// Store the guest regs x19-x29, lr
> +	// Store the guest regs x18-x29, lr
>  	save_callee_saved_regs x1
>  
>  	get_host_ctxt	x2, x3
> -- 
> 2.24.0.rc1.363.gb1bccd3e3d-goog
> 
