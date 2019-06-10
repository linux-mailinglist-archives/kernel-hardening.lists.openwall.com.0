Return-Path: <kernel-hardening-return-16089-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8FDC93BEB8
	for <lists+kernel-hardening@lfdr.de>; Mon, 10 Jun 2019 23:33:24 +0200 (CEST)
Received: (qmail 9567 invoked by uid 550); 10 Jun 2019 21:33:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9545 invoked from network); 10 Jun 2019 21:33:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=825Is8NE7RT8Jz0RpT7VVuP0UsDVOSwHLm6oF1wC/YU=;
        b=JZs+5DeutR1B/D3BdPr4D+n3NH1somXSgr0zmI6lWGlLMSblkHtowdJJ8SnJ/EyEaT
         vrFjXglj30BU2fmFW/XhemfiYhbvsDJD7e8e/bLPI/HCHW4EsSv7G1jT0FZqaMF0NSuS
         Gx4kpEr/qt1k8y3/DrU7IYsObBsYTcttNkmos=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=825Is8NE7RT8Jz0RpT7VVuP0UsDVOSwHLm6oF1wC/YU=;
        b=tT9NJd7TBZsbd42dUHchrlSNScvV0JKWny6S4lb5ZetmzueJXAiJPisnZHyKeIP1gB
         BpY6UPf87yPUrQ2Rao+21QTgAkWa+LSclGdZxc0RrAT7q03UY4g0xmkfTqUAyanu3tTh
         hh0yLDxcwFSnuytY089oAJ/ZtGf0Q8ucNZcknIeBf7axgiOH/G3iDYAjF7N3BzKngjv2
         ykwa8v3hVODyHNtnazKtBhy9XyhZ8cTTaIHt26lJcns4Z03v8NM/zCao6DEcc1KUBXdp
         14Zk82v6Vcsk6yZapO8PC/3FVjjqnFwGiz/RClgtOe3osxValckzDSAu16HeUCZJa62z
         H5oQ==
X-Gm-Message-State: APjAAAWLOzv6zxGuGskYGGDBsWKDwFM73WEO8OkBksYQekDVFSkiDlJq
	K07df6lnWpqJ5ZKhUnTVKlS/1A==
X-Google-Smtp-Source: APXvYqw9TXY3olY6Pl/0Z1nz7YqPCYtLr1ZiA+NtCVd1DLzmoU/1gP95w+gvw/fnAiD4DrEKysAVHA==
X-Received: by 2002:a17:902:102c:: with SMTP id b41mr22976465pla.204.1560202386832;
        Mon, 10 Jun 2019 14:33:06 -0700 (PDT)
Date: Mon, 10 Jun 2019 14:33:05 -0700
From: Kees Cook <keescook@chromium.org>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
	Thomas Garnier <thgarnie@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 04/12] x86: relocate_kernel - Adapt assembly for PIE
 support
Message-ID: <201906101433.0A1A27960@keescook>
References: <20190520231948.49693-1-thgarnie@chromium.org>
 <20190520231948.49693-5-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520231948.49693-5-thgarnie@chromium.org>

On Mon, May 20, 2019 at 04:19:29PM -0700, Thomas Garnier wrote:
> From: Thomas Garnier <thgarnie@google.com>
> 
> Change the assembly code to use only absolute references of symbols for the
> kernel to be PIE compatible.
> 
> Position Independent Executable (PIE) support will allow to extend the
> KASLR randomization range below 0xffffffff80000000.
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  arch/x86/kernel/relocate_kernel_64.S | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/kernel/relocate_kernel_64.S b/arch/x86/kernel/relocate_kernel_64.S
> index 11eda21eb697..3320368b6ec9 100644
> --- a/arch/x86/kernel/relocate_kernel_64.S
> +++ b/arch/x86/kernel/relocate_kernel_64.S
> @@ -208,7 +208,7 @@ identity_mapped:
>  	movq	%rax, %cr3
>  	lea	PAGE_SIZE(%r8), %rsp
>  	call	swap_pages
> -	movq	$virtual_mapped, %rax
> +	movabsq	$virtual_mapped, %rax
>  	pushq	%rax
>  	ret
>  
> -- 
> 2.21.0.1020.gf2820cf01a-goog
> 

-- 
Kees Cook
