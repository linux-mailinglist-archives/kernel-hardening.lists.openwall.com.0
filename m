Return-Path: <kernel-hardening-return-17210-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F2D80EBC76
	for <lists+kernel-hardening@lfdr.de>; Fri,  1 Nov 2019 04:46:27 +0100 (CET)
Received: (qmail 17706 invoked by uid 550); 1 Nov 2019 03:46:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17686 invoked from network); 1 Nov 2019 03:46:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ipB5k5z37+Fd8igQLbmVYrL5E9roHGbRK+wBmA4Y9yU=;
        b=IJQVm+nHblMlKtJOM196C6hcfBE3KUu5qTQKv0FOe/rkT2KShvxSF9ZK3miYtArp8S
         iCx9zhvAVMbHgtEQYP6IvQSYka4Me/BNhBXNxL6j6tLCRlIaOcOYAOppDrF9cr1jDZQa
         fRCejTSNEe4g/nH0rKI9uiV455M5B/EKg6M0Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ipB5k5z37+Fd8igQLbmVYrL5E9roHGbRK+wBmA4Y9yU=;
        b=n1BN+tuKSi89ZI6Dco0pzWdxr6EYsOqllzp1DLxIvRpjjVprqfAXSIpL5RLNIhdv8e
         sfEGg2AtC5bemjAWQkTmcdE36/yGn5ROF4ZutarhHIzlvcjkRjyNM88948eEMB3xV/1/
         fcoXj4vghwQesYcyM4sSGFEeVn9FFLgHjIYs7wTdHawV9Ocbo0hl1Tn4b+5MMmKSauaG
         KObCguqz6mO2T6+qz7YkHhFHuSZNb11WpoAhITfPuT78nDIkeEoPJ5RfuedrLhULIEme
         qr9DT2RWVuAQr5XbKMQ4MObGJEVPo+FL5FPV5XI0ZM6znLHOFB7b2qhMuZMXga2BZ/Eb
         tLGA==
X-Gm-Message-State: APjAAAXfd9q51ahaBXBk3w0dO9qC1dX9VN8VgIGtFrTTuF15ZVYuPC+u
	BQd2WUkcWZgb1stSMXqwZzws2g==
X-Google-Smtp-Source: APXvYqzPevvEfpBSK+c7IiF5pLcK+obnlKmRuGuDHbGO/WB/NYdDcoJIb57F0lxIPa76vBgqS1skUA==
X-Received: by 2002:a17:90a:2326:: with SMTP id f35mr12315696pje.134.1572579965327;
        Thu, 31 Oct 2019 20:46:05 -0700 (PDT)
Date: Thu, 31 Oct 2019 20:46:03 -0700
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
Subject: Re: [PATCH v3 16/17] arm64: disable SCS for hypervisor code
Message-ID: <201910312046.343E275D@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191031164637.48901-1-samitolvanen@google.com>
 <20191031164637.48901-17-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191031164637.48901-17-samitolvanen@google.com>

On Thu, Oct 31, 2019 at 09:46:36AM -0700, samitolvanen@google.com wrote:
> Filter out CC_FLAGS_SCS for code that runs at a different exception
> level.
> 
> Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  arch/arm64/kvm/hyp/Makefile | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
> index ea710f674cb6..17ea3da325e9 100644
> --- a/arch/arm64/kvm/hyp/Makefile
> +++ b/arch/arm64/kvm/hyp/Makefile
> @@ -28,3 +28,6 @@ GCOV_PROFILE	:= n
>  KASAN_SANITIZE	:= n
>  UBSAN_SANITIZE	:= n
>  KCOV_INSTRUMENT	:= n
> +
> +# remove the SCS flags from all objects in this directory
> +KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
> -- 
> 2.24.0.rc0.303.g954a862665-goog
> 

-- 
Kees Cook
