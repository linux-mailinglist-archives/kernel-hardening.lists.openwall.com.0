Return-Path: <kernel-hardening-return-17219-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E903AEBC9E
	for <lists+kernel-hardening@lfdr.de>; Fri,  1 Nov 2019 04:58:19 +0100 (CET)
Received: (qmail 32623 invoked by uid 550); 1 Nov 2019 03:58:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32603 invoked from network); 1 Nov 2019 03:58:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KTD68U7akKeCQJeQQO/3NWtyqqeAW/3/QV3ZglVyD2U=;
        b=g7eFmtjav3cj0iIv3dbseME7IVoTl6guKvHDgto9iv8aby8HSUCvIJ9sygsE5R3aF7
         sKXlGLL8uYrezZz9ZBeSn3ezAH1xjYETzfnrSaxHbKNbjiGxvuZvvDGELcQqBkpd+r4G
         E7p34oIlOhqLBiMnYarxTp8OFroVAyrGZ/Sfs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KTD68U7akKeCQJeQQO/3NWtyqqeAW/3/QV3ZglVyD2U=;
        b=b2iMsI0tb39hx6XdE52joh72ojqa0DtWTmpsDoNgbZT22nBXKEdtnOwCfAemL903WI
         WrnafGDzuO8fOc33ym+YGGfNcdRy4A+xvfg5YXrbz0vz0z/ylfQZNymEKDX5Jn9iCA6T
         WBun+KQ0EwuD0dr4cy/0KNAAqTnEj3APcP5ZmMXPQAEQp4T8OjrONwStrk8VGgVmqzO2
         rOzZsZfze8gAf8CHjGsKoACd9wirART8m64x9LaQH/E0wXlJOGygZtejjFZGZCFuXvp3
         qiF/wiZq2unKsrtqAK8RKcstnWKlkUCfA9uYf9pQ2JUqFQyy1InX5OZjZYJ1/dWweHEY
         ZpuQ==
X-Gm-Message-State: APjAAAVeA6DaYEj3oblqXjiu5eRN1eSKrDJbL26pIE7nKtGD0UML1vsp
	SY3aEeoqHkfINiBTtM3w2bmT3g==
X-Google-Smtp-Source: APXvYqzUltQIjex4hQjkY+4c/lISYONuL0ugq2i91UuUeDXV/D7mzBYyTbSsX4Ym4f6zfYJqkCbq5g==
X-Received: by 2002:a17:90a:d149:: with SMTP id t9mr12088130pjw.108.1572580682690;
        Thu, 31 Oct 2019 20:58:02 -0700 (PDT)
Date: Thu, 31 Oct 2019 20:58:00 -0700
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
Subject: Re: [PATCH v3 11/17] arm64: disable function graph tracing with SCS
Message-ID: <201910312056.E3315F0F@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191031164637.48901-1-samitolvanen@google.com>
 <20191031164637.48901-12-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031164637.48901-12-samitolvanen@google.com>

On Thu, Oct 31, 2019 at 09:46:31AM -0700, samitolvanen@google.com wrote:
> With CONFIG_FUNCTION_GRAPH_TRACER, function return addresses are
> modified in ftrace_graph_caller and prepare_ftrace_return to redirect
> control flow to ftrace_return_to_handler. This is incompatible with
> SCS.

IIRC, the argument was to disable these on a per-arch basis instead of
doing it as a "depends on !SHADOW_CALL_STACK" in the top-level function
graph tracer Kconfig? (I'm just thinking ahead to doing this again for
other architectures, though, I guess, there is much more work than just
that for, say, x86.)

Regardless:

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees


> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
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
> 2.24.0.rc0.303.g954a862665-goog
> 

-- 
Kees Cook
