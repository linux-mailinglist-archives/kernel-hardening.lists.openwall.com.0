Return-Path: <kernel-hardening-return-17128-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 32644E4923
	for <lists+kernel-hardening@lfdr.de>; Fri, 25 Oct 2019 13:03:41 +0200 (CEST)
Received: (qmail 26424 invoked by uid 550); 25 Oct 2019 11:03:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26391 invoked from network); 25 Oct 2019 11:03:35 -0000
Date: Fri, 25 Oct 2019 12:03:13 +0100
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
Subject: Re: [PATCH v2 09/17] arm64: disable function graph tracing with SCS
Message-ID: <20191025110313.GE40270@lakrids.cambridge.arm.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191024225132.13410-1-samitolvanen@google.com>
 <20191024225132.13410-10-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024225132.13410-10-samitolvanen@google.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)

On Thu, Oct 24, 2019 at 03:51:24PM -0700, samitolvanen@google.com wrote:
> With CONFIG_FUNCTION_GRAPH_TRACER, function return addresses are
> modified in ftrace_graph_caller and prepare_ftrace_return to redirect
> control flow to ftrace_return_to_handler. This is incompatible with
> SCS.

I'm guessing it's difficult to always figure out the SCS slot for an
instrumented callsite unless we pass this explicitly from the ftrace
entry code, so we'd probably have to change some common infrastructure
for that.

We have a similar issue with pointer authentication, and we're solving
that with -fpatchable-function-entry, which allows us to hook the
callsite before it does anything with the return address. IIUC we could
use the same mechanism here (and avoid introducing a third).

Are there plans to implement -fpatchable-function-entry on the clang
side?

Thanks,
Mark.

> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> ---
>  arch/arm64/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 3f047afb982c..8cda176dad9a 100644
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
> 2.24.0.rc0.303.g954a862665-goog
> 
