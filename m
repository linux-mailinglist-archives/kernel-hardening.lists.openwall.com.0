Return-Path: <kernel-hardening-return-16305-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 17B305885D
	for <lists+kernel-hardening@lfdr.de>; Thu, 27 Jun 2019 19:30:21 +0200 (CEST)
Received: (qmail 32068 invoked by uid 550); 27 Jun 2019 17:30:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32047 invoked from network); 27 Jun 2019 17:30:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sqjgvA4tRI7gKXcYMCta47rMHZPYdqhreyw0ltkm5k4=;
        b=gIwVdMW2M0Xb8QXHac7LT85o8JUB3yXqnOVg8tPtqn6MlnaF7dsdIt9ho5MXcMFGcH
         vo1ZIAd2cmou7O23mzuhRtXvCTWVrEZ4GO3lvJs5z9K3wSenB4IgRxX9wSXiiXESbZ8I
         iQhVvuYzrb1LzX6+yTIs2/9up/lZ0BQGPLeas=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sqjgvA4tRI7gKXcYMCta47rMHZPYdqhreyw0ltkm5k4=;
        b=BK8EGpkSg4lo/2wbZ5MoRN9FK7m59+KFamX/WJ/qAIKHG6EWViTJueU7AormfEPpA1
         NROi/aXFNpQwkYwKYgVuGZzApdIbnbz6SRzBVk0+UgGO8nlMGoOjvaIn+vG2qidB0LMQ
         IuvxQsjnPV4sJy7G1QZqcXqXE7yyX/Om/K+Vf2XGCTF2e4zBYi2tKwqSuX21awfuHA2n
         76vR4ZWdLfkDZnzIDGpUUgBcHxNoc6WXijPEwqFDVEN1B3ZH/bwprzwXTBuwSQnz5r59
         72h9jVtWFKPAw5HXlm/HQPxIwm9ZHHddksiFbYonMSRxfzK7NUPvQxhn1e780rkdKBgl
         TcJw==
X-Gm-Message-State: APjAAAVNXQLnBadvAoonpiM2yiRFBoTn6Qzn1d5VVNtf1F/HGK9VsdqN
	c2QKtQOa0tToUr30W2qeGvQsPQ==
X-Google-Smtp-Source: APXvYqwPcBbkreT9oXxP01E3l2iGaTwsfiGLYGLgb7tU8kShnT1MEu64YHMK+0/M//JyJa7+K31l3Q==
X-Received: by 2002:a17:902:be12:: with SMTP id r18mr5657298pls.341.1561656602817;
        Thu, 27 Jun 2019 10:30:02 -0700 (PDT)
Date: Thu, 27 Jun 2019 10:30:01 -0700
From: Kees Cook <keescook@chromium.org>
To: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Florian Weimer <fweimer@redhat.com>, Jann Horn <jannh@google.com>,
	Borislav Petkov <bp@alien8.de>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v2 6/8] x86/vsyscall: Change the default vsyscall mode to
 xonly
Message-ID: <201906271029.584EC8319@keescook>
References: <cover.1561610354.git.luto@kernel.org>
 <30539f8072d2376b9c9efcc07e6ed0d6bf20e882.1561610354.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <30539f8072d2376b9c9efcc07e6ed0d6bf20e882.1561610354.git.luto@kernel.org>

On Wed, Jun 26, 2019 at 09:45:07PM -0700, Andy Lutomirski wrote:
> The use case for full emulation over xonly is very esoteric.  Let's
> change the default to the safer xonly mode.
> 
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>

I still think it'd be valuable to describe any known esoteric cases
here, but regardless:

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  arch/x86/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 0182d2c67590..32028edc1b0e 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2285,7 +2285,7 @@ config COMPAT_VDSO
>  choice
>  	prompt "vsyscall table for legacy applications"
>  	depends on X86_64
> -	default LEGACY_VSYSCALL_EMULATE
> +	default LEGACY_VSYSCALL_XONLY
>  	help
>  	  Legacy user code that does not know how to find the vDSO expects
>  	  to be able to issue three syscalls by calling fixed addresses in
> -- 
> 2.21.0
> 

-- 
Kees Cook
