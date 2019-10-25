Return-Path: <kernel-hardening-return-17126-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id CAFD8E480F
	for <lists+kernel-hardening@lfdr.de>; Fri, 25 Oct 2019 12:02:54 +0200 (CEST)
Received: (qmail 5740 invoked by uid 550); 25 Oct 2019 10:02:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5719 invoked from network); 25 Oct 2019 10:02:48 -0000
Date: Fri, 25 Oct 2019 11:02:32 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: samitolvanen@google.com
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Laura Abbott <labbott@redhat.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 04/17] arm64: kernel: avoid x18 as an arbitrary temp
 register
Message-ID: <20191025100232.GC40270@lakrids.cambridge.arm.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191024225132.13410-1-samitolvanen@google.com>
 <20191024225132.13410-5-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024225132.13410-5-samitolvanen@google.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)

Minor nit, but could we make the title a bit more specific (and more
uniform across the series)? e.g.

  arm64: kvm: avoid x18 in __cpu_soft_restart

That makes things a bit nicer when trawling through git logs as the
scope of the patch is clearer.

On Thu, Oct 24, 2019 at 03:51:19PM -0700, samitolvanen@google.com wrote:
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> The code in __cpu_soft_restart() uses x18 as an arbitrary temp register,
> which will shortly be disallowed. So use x8 instead.
> 
> Link: https://patchwork.kernel.org/patch/9836877/
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Either way:

Reviewed-by: Mark Rutland <mark.rutland@arm.com>

> ---
>  arch/arm64/kernel/cpu-reset.S | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kernel/cpu-reset.S b/arch/arm64/kernel/cpu-reset.S
> index 6ea337d464c4..32c7bf858dd9 100644
> --- a/arch/arm64/kernel/cpu-reset.S
> +++ b/arch/arm64/kernel/cpu-reset.S
> @@ -42,11 +42,11 @@ ENTRY(__cpu_soft_restart)
>  	mov	x0, #HVC_SOFT_RESTART
>  	hvc	#0				// no return
>  
> -1:	mov	x18, x1				// entry
> +1:	mov	x8, x1				// entry
>  	mov	x0, x2				// arg0
>  	mov	x1, x3				// arg1
>  	mov	x2, x4				// arg2
> -	br	x18
> +	br	x8
>  ENDPROC(__cpu_soft_restart)
>  
>  .popsection
> -- 
> 2.24.0.rc0.303.g954a862665-goog
> 
