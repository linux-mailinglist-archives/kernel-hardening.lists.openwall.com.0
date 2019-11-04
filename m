Return-Path: <kernel-hardening-return-17265-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0136CEE59C
	for <lists+kernel-hardening@lfdr.de>; Mon,  4 Nov 2019 18:11:54 +0100 (CET)
Received: (qmail 32273 invoked by uid 550); 4 Nov 2019 17:11:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32253 invoked from network); 4 Nov 2019 17:11:49 -0000
Date: Mon, 4 Nov 2019 17:11:33 +0000
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
Subject: Re: [PATCH v4 11/17] arm64: disable function graph tracing with SCS
Message-ID: <20191104171132.GB2024@lakrids.cambridge.arm.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191101221150.116536-1-samitolvanen@google.com>
 <20191101221150.116536-12-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191101221150.116536-12-samitolvanen@google.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)

On Fri, Nov 01, 2019 at 03:11:44PM -0700, Sami Tolvanen wrote:
> With CONFIG_FUNCTION_GRAPH_TRACER, function return addresses are
> modified in ftrace_graph_caller and prepare_ftrace_return to redirect
> control flow to ftrace_return_to_handler. This is incompatible with
> SCS.

Can you please elaborate on _how_ this is incompatible in the commit
message?

For example, it's not clear to me if you mean that's functionally
incompatible, or if you're trying to remove return-altering gadgets.

If there's a functional incompatibility, please spell that out a bit
more clearly. Likewise if this is about minimizing the set of places
that can mess with control-flow outside of usual function conventions.

Thanks,
Mark.

> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/arm64/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index e7b57a8a5531..42867174920f 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -148,7 +148,7 @@ config ARM64
>  	select HAVE_FTRACE_MCOUNT_RECORD
>  	select HAVE_FUNCTION_TRACER
>  	select HAVE_FUNCTION_ERROR_INJECTION
> -	select HAVE_FUNCTION_GRAPH_TRACER
> +	select HAVE_FUNCTION_GRAPH_TRACER if !SHADOW_CALL_STACK
>  	select HAVE_GCC_PLUGINS
>  	select HAVE_HW_BREAKPOINT if PERF_EVENTS
>  	select HAVE_IRQ_TIME_ACCOUNTING
> -- 
> 2.24.0.rc1.363.gb1bccd3e3d-goog
> 
