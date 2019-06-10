Return-Path: <kernel-hardening-return-16094-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D46DB3C038
	for <lists+kernel-hardening@lfdr.de>; Tue, 11 Jun 2019 01:52:51 +0200 (CEST)
Received: (qmail 17456 invoked by uid 550); 10 Jun 2019 23:52:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17438 invoked from network); 10 Jun 2019 23:52:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=//UIhUwMjcLEhM8jw0JdGfPxbu/l+D9BdzjQBHxa+3I=;
        b=S5twQrqcfMlYQ7HpJx67BBgHCAXoiezTWufgTwmq7vEJIDmSmgxiNFaSqrzgEZLYBb
         tiZ+uAc3MEee8GOKVN3q66fZBuujaKmt6U4ZDFTEE92khx921OCBx/0XA3OLN2i34diO
         jJwwMQZ/GLIYF6fVKnWmKER+HFF1f0apsT4/E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=//UIhUwMjcLEhM8jw0JdGfPxbu/l+D9BdzjQBHxa+3I=;
        b=PGOyx6QDRWmDfp+EO2INLbjVo37SArDwe+eShZ4yBxc6q5bcMjUg+9Yqkd9spUnOa2
         JkBiFckrZbqXZcr4a/eKbq48qqYebtGtXw0nTs+EdwvtQeYM4wMGo/rR4Djae7eBU/EV
         BfjAzH/OE3jEmA/y6LNy6t+wPbXVhraf8kuLnxtLJYA23DNONr/n0XAlavgjxO7xpwhu
         Of7Lb7QQ07MZalIejIcESjYd3dqPWJT1Y55BeqndmDn1da+khMS4Rx3JpGXaFe6zrvEq
         jlb90sNSD2k2fIUMNiHEte7jH2mTcV97I7/WZWPTqdQHwW4boURvWK9YcWC/QqeXJNB4
         f10A==
X-Gm-Message-State: APjAAAXP6tu9pGnd/A7dSQgrB+C/XmR/kjm3wGyD1zB8pg8D2PdAkkcT
	VjYrh75XoKcaq/cTRpvUv8Tv4A==
X-Google-Smtp-Source: APXvYqx/uFQL581YeJrYZ1Czs+Zxdcfgf1YQbiKV68dE70gZNUeve1m6AmJretOfUB9S5Ieus0eafg==
X-Received: by 2002:a63:a056:: with SMTP id u22mr17603182pgn.318.1560210754118;
        Mon, 10 Jun 2019 16:52:34 -0700 (PDT)
Date: Mon, 10 Jun 2019 16:52:32 -0700
From: Kees Cook <keescook@chromium.org>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
	Thomas Garnier <thgarnie@google.com>, Pavel Machek <pavel@ucw.cz>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 10/12] x86/power/64: Adapt assembly for PIE support
Message-ID: <201906101652.94483CD@keescook>
References: <20190520231948.49693-1-thgarnie@chromium.org>
 <20190520231948.49693-11-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520231948.49693-11-thgarnie@chromium.org>

On Mon, May 20, 2019 at 04:19:35PM -0700, Thomas Garnier wrote:
> From: Thomas Garnier <thgarnie@google.com>
> 
> Change the assembly code to use only relative references of symbols for the
> kernel to be PIE compatible.
> 
> Position Independent Executable (PIE) support will allow to extend the
> KASLR randomization range below 0xffffffff80000000.
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> Acked-by: Pavel Machek <pavel@ucw.cz>
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> ---
>  arch/x86/power/hibernate_asm_64.S | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/power/hibernate_asm_64.S b/arch/x86/power/hibernate_asm_64.S
> index 3008baa2fa95..9ed980efef72 100644
> --- a/arch/x86/power/hibernate_asm_64.S
> +++ b/arch/x86/power/hibernate_asm_64.S
> @@ -24,7 +24,7 @@
>  #include <asm/frame.h>
>  
>  ENTRY(swsusp_arch_suspend)
> -	movq	$saved_context, %rax
> +	leaq	saved_context(%rip), %rax
>  	movq	%rsp, pt_regs_sp(%rax)
>  	movq	%rbp, pt_regs_bp(%rax)
>  	movq	%rsi, pt_regs_si(%rax)
> @@ -115,7 +115,7 @@ ENTRY(restore_registers)
>  	movq	%rax, %cr4;  # turn PGE back on
>  
>  	/* We don't restore %rax, it must be 0 anyway */
> -	movq	$saved_context, %rax
> +	leaq	saved_context(%rip), %rax
>  	movq	pt_regs_sp(%rax), %rsp
>  	movq	pt_regs_bp(%rax), %rbp
>  	movq	pt_regs_si(%rax), %rsi
> -- 
> 2.21.0.1020.gf2820cf01a-goog
> 

-- 
Kees Cook
