Return-Path: <kernel-hardening-return-19138-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 734F4207E5D
	for <lists+kernel-hardening@lfdr.de>; Wed, 24 Jun 2020 23:19:36 +0200 (CEST)
Received: (qmail 22251 invoked by uid 550); 24 Jun 2020 21:19:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22219 invoked from network); 24 Jun 2020 21:19:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hjSR6mlsTCk7g8v7G12vqP6vdQOVg8YnQ0fK9Qe8YIs=; b=UTizqW0atOD47Jl6UUMex02N0S
	mc85gMkTkCOA9d9n1Mk7rnTM4frQa1iMgHTfA2VfdlpZ8Yx44nPgiXtA/RwZ2QVyVzEdRBB9mgkXe
	nq/SL1dcQZxaszgTqCwr/DLmQom+lmq1gxRtmOa84xHN64AYxblPDuloQXacicpSjzW4ceWpsFD1/
	cpMKSkTRHxL1ERgtwdB3+/RFsvdp3+WEuULy5oM/0VZnaMXNROhnOT/trbg7viBg2ffRju9Lab/TO
	DPac7DU6KB0NcpbJmhEDP16v+CcRwigXYVjOpMNYbmguUsuC/Jb5ut6v/WO8WBWrf7OFbZQZlOG/+
	MezE87Kw==;
Date: Wed, 24 Jun 2020 23:19:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH 05/22] kbuild: lto: postpone objtool
Message-ID: <20200624211908.GT4817@hirez.programming.kicks-ass.net>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-6-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624203200.78870-6-samitolvanen@google.com>

On Wed, Jun 24, 2020 at 01:31:43PM -0700, Sami Tolvanen wrote:
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index 30827f82ad62..12b115152532 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -120,7 +120,7 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
>  /* Annotate a C jump table to allow objtool to follow the code flow */
>  #define __annotate_jump_table __section(.rodata..c_jump_table)
>  
> -#ifdef CONFIG_DEBUG_ENTRY
> +#if defined(CONFIG_DEBUG_ENTRY) || defined(CONFIG_LTO_CLANG)
>  /* Begin/end of an instrumentation safe region */
>  #define instrumentation_begin() ({					\
>  	asm volatile("%c0:\n\t"						\

Why would you be doing noinstr validation for lto builds? That doesn't
make sense.

> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index 9ad9210d70a1..9fdba71c135a 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -399,7 +399,7 @@ config STACK_VALIDATION
>  
>  config VMLINUX_VALIDATION
>  	bool
> -	depends on STACK_VALIDATION && DEBUG_ENTRY && !PARAVIRT
> +	depends on STACK_VALIDATION && (DEBUG_ENTRY || LTO_CLANG) && !PARAVIRT
>  	default y
>  

For that very same reason you shouldn't be excluding paravirt either.

> diff --git a/scripts/Makefile.modfinal b/scripts/Makefile.modfinal
> index d168f0cfe67c..9f1df2f1fab5 100644
> --- a/scripts/Makefile.modfinal
> +++ b/scripts/Makefile.modfinal
> @@ -48,6 +48,21 @@ endif # CC_USING_PATCHABLE_FUNCTION_ENTRY
>  endif # CC_USING_RECORD_MCOUNT
>  endif # CONFIG_FTRACE_MCOUNT_RECORD
>  
> +ifdef CONFIG_STACK_VALIDATION
> +ifneq ($(SKIP_STACK_VALIDATION),1)
> +cmd_ld_ko_o +=								\
> +	$(objtree)/tools/objtool/objtool				\
> +		$(if $(CONFIG_UNWINDER_ORC),orc generate,check)		\
> +		--module						\
> +		$(if $(CONFIG_FRAME_POINTER),,--no-fp)			\
> +		$(if $(CONFIG_GCOV_KERNEL),--no-unreachable,)		\
> +		$(if $(CONFIG_RETPOLINE),--retpoline,)			\
> +		$(if $(CONFIG_X86_SMAP),--uaccess,)			\
> +		$(@:.ko=$(prelink-ext).o);
> +
> +endif # SKIP_STACK_VALIDATION
> +endif # CONFIG_STACK_VALIDATION

What about the objtool invocation from link-vmlinux.sh ?
