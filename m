Return-Path: <kernel-hardening-return-16087-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E947C3BDB3
	for <lists+kernel-hardening@lfdr.de>; Mon, 10 Jun 2019 22:45:13 +0200 (CEST)
Received: (qmail 1975 invoked by uid 550); 10 Jun 2019 20:45:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1936 invoked from network); 10 Jun 2019 20:45:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gFNF363RDc/XdYA/qTwjgCIxHifrzxkDYNHAq+P6+0s=;
        b=e2CZUihYvTafnYYHa056o7+bSSzfL1Ff4bnwCZJQJRYmAZXuNLs4PAqpQu2Hc877TH
         oVAuevfcQD/nV5NtqR0pXt0JiPAQE1f+NvWQAA/cDZJNvE1WXgUMc4qET2B9/WPz4AZI
         JaHy3eRaR0YvxNOAZ1ua6HxHSX0pLNCycB4r0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gFNF363RDc/XdYA/qTwjgCIxHifrzxkDYNHAq+P6+0s=;
        b=fBk1dDk3AHft23NGT8375MQeXMgPnQkTZIV1VkJ8lG1SjC7t4fUYJ3ZxN7LX9/zP/8
         wzvzAsR+5GeAB4pgMxoZwbp7rPyn9OdjfM2dfhrmzeP8Sw0MCwFiz4uT7hCfDJ1bhPDZ
         jmgF3mdxC9c/S+7uFcRkeKhYbZGCtjBFNf01tENFnD2tPN+FYIzq44hZHKeURWYTD+Yh
         YhxCL55/pfAAsgYhp3XLp16nskDs+sjW5IQIig91OuGR7Iqy97xw3uqkcr91aKIdv4hH
         MpJCD1BjaErHHPIBcjavct1hh8xfjDjBy+7iDTpFWTMbAaL6C2lduvzeNwDobwmRxuF9
         G8Ig==
X-Gm-Message-State: APjAAAWPmWIJ4e1x93paaVz1WTPiuhBI/t7xveN4dq9/03ReJ8C4VnEp
	NXzCnAXlEmLj1AOnwbu1WhFGkQ==
X-Google-Smtp-Source: APXvYqybNR2PIaiWpTHApIK7YBw6IPSSen1QXNs1Vc9JJjXcnCU9uxUQ/3zVX0wDRddk2VworcnaBw==
X-Received: by 2002:a17:90a:b00b:: with SMTP id x11mr23332542pjq.120.1560199496619;
        Mon, 10 Jun 2019 13:44:56 -0700 (PDT)
Date: Mon, 10 Jun 2019 13:44:55 -0700
From: Kees Cook <keescook@chromium.org>
To: Andy Lutomirski <luto@kernel.org>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/5] x86/vsyscall: Change the default vsyscall mode to
 xonly
Message-ID: <201906101344.018BE4C5C1@keescook>
References: <cover.1560198181.git.luto@kernel.org>
 <25fd7036cefca16c68ecd990e05e05a8ad8fe8b2.1560198181.git.luto@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <25fd7036cefca16c68ecd990e05e05a8ad8fe8b2.1560198181.git.luto@kernel.org>

On Mon, Jun 10, 2019 at 01:25:31PM -0700, Andy Lutomirski wrote:
> The use case for full emulation over xonly is very esoteric.  Let's
> change the default to the safer xonly mode.

Perhaps describe the esoteric cases here (and maybe in the Kconfig help
text)? That should a user determine if they actually need it. (What
would the failure under xonly look like for someone needing emulate?)

-Kees

> 
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>  arch/x86/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 054033cc4b1b..e56f33e6b045 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -2280,7 +2280,7 @@ config COMPAT_VDSO
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
