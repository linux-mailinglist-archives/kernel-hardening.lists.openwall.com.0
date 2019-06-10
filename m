Return-Path: <kernel-hardening-return-16092-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9A5C33BF79
	for <lists+kernel-hardening@lfdr.de>; Tue, 11 Jun 2019 00:26:57 +0200 (CEST)
Received: (qmail 3455 invoked by uid 550); 10 Jun 2019 22:26:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3437 invoked from network); 10 Jun 2019 22:26:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=67u0Tj2CoGeL4dThX4XrMYcQePJVLCvJn4vsI64szII=;
        b=WF1H6+d1SxAlb/vZeKF0B9iSmqUfjFmnpQhngBxfxtlTa5dzMscuS2YxqiovFwODl8
         9/UJ+FKjvDEg3auYYbf5pIpl0nH3T8j9M+qHfD4rfTJrwSdCOeSLYBN2uqtnwawrvm6u
         HfeTyvw6SOzE9f+8UL24AMx+WX8ah5iC6y6z0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=67u0Tj2CoGeL4dThX4XrMYcQePJVLCvJn4vsI64szII=;
        b=rcL2vFlcD4C8XXwo/QFs8dPEer4afhpnIKnAPt+tBjN7OEpSoT6IKJkXgSuEFd9MCk
         OYhvGEYil6C8y2Cn5MKYZ7VTcw6hfJgtmdOn1x9Sg0g8kEEEu0jLBriXN/xr0RCnWsjk
         zY5CPw70MudChLu5OF8rLYTBzq9YMpDtfri/zSRBmGhDfgBu/mR4moRrNqdTPZQVJkrc
         SKwW7YKRMY3KThijt75ANtq5dGp0WyPb68kYgC9C1OVfJJHmGl7l5efQ9r1oYTCjtJSk
         mMXkdwJJkWm3dJ68+Q2ew7lut1JwvLzo9gEcHUK7t8U4+u6GV0lOwVsDzEiJl6Z/mSs+
         3oZQ==
X-Gm-Message-State: APjAAAVNIeaDfCj6y3cTPnhxhp+R23v2ZM8KIF+xbDAJB2FeQ8lygRoT
	ycykSY4h9Tmn3HtRRrOZoRo6cQ==
X-Google-Smtp-Source: APXvYqy5v/2Y0KGHNajWxqGNxE9ok3KQd0FddzucZjpJwTPjw1E5gp1y5On3KwEmj5oBF9TfSfULAg==
X-Received: by 2002:a63:84c1:: with SMTP id k184mr15441388pgd.7.1560205599265;
        Mon, 10 Jun 2019 15:26:39 -0700 (PDT)
Date: Mon, 10 Jun 2019 15:26:37 -0700
From: Kees Cook <keescook@chromium.org>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
	Thomas Garnier <thgarnie@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	Juergen Gross <jgross@suse.com>, Feng Tang <feng.tang@intel.com>,
	Maran Wilson <maran.wilson@oracle.com>,
	Jan Beulich <JBeulich@suse.com>, Andy Lutomirski <luto@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 09/12] x86/boot/64: Adapt assembly for PIE support
Message-ID: <201906101526.66E589DDD@keescook>
References: <20190520231948.49693-1-thgarnie@chromium.org>
 <20190520231948.49693-10-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520231948.49693-10-thgarnie@chromium.org>

On Mon, May 20, 2019 at 04:19:34PM -0700, Thomas Garnier wrote:
> From: Thomas Garnier <thgarnie@google.com>
> 
> Change the assembly code to use only relative references of symbols for the
> kernel to be PIE compatible.
> 
> Early at boot, the kernel is mapped at a temporary address while preparing
> the page table. To know the changes needed for the page table with KASLR,
> the boot code calculate the difference between the expected address of the
> kernel and the one chosen by KASLR. It does not work with PIE because all
> symbols in code are relatives. Instead of getting the future relocated
> virtual address, you will get the current temporary mapping.
> Instructions were changed to have absolute 64-bit references.
> 
> Position Independent Executable (PIE) support will allow to extend the
> KASLR randomization range below 0xffffffff80000000.
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  arch/x86/kernel/head_64.S | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
> index bcd206c8ac90..64a4f0a22b20 100644
> --- a/arch/x86/kernel/head_64.S
> +++ b/arch/x86/kernel/head_64.S
> @@ -90,8 +90,10 @@ startup_64:
>  	popq	%rsi
>  
>  	/* Form the CR3 value being sure to include the CR3 modifier */
> -	addq	$(early_top_pgt - __START_KERNEL_map), %rax
> +	movabs  $(early_top_pgt - __START_KERNEL_map), %rcx
> +	addq    %rcx, %rax
>  	jmp 1f
> +
>  ENTRY(secondary_startup_64)
>  	UNWIND_HINT_EMPTY
>  	/*
> @@ -120,7 +122,8 @@ ENTRY(secondary_startup_64)
>  	popq	%rsi
>  
>  	/* Form the CR3 value being sure to include the CR3 modifier */
> -	addq	$(init_top_pgt - __START_KERNEL_map), %rax
> +	movabs	$(init_top_pgt - __START_KERNEL_map), %rcx
> +	addq    %rcx, %rax
>  1:
>  
>  	/* Enable PAE mode, PGE and LA57 */
> @@ -138,7 +141,7 @@ ENTRY(secondary_startup_64)
>  	movq	%rax, %cr3
>  
>  	/* Ensure I am executing from virtual addresses */
> -	movq	$1f, %rax
> +	movabs  $1f, %rax
>  	ANNOTATE_RETPOLINE_SAFE
>  	jmp	*%rax
>  1:
> @@ -235,11 +238,12 @@ ENTRY(secondary_startup_64)
>  	 *	REX.W + FF /5 JMP m16:64 Jump far, absolute indirect,
>  	 *		address given in m16:64.
>  	 */
> -	pushq	$.Lafter_lret	# put return address on stack for unwinder
> +	movabs  $.Lafter_lret, %rax
> +	pushq	%rax		# put return address on stack for unwinder
>  	xorl	%ebp, %ebp	# clear frame pointer
> -	movq	initial_code(%rip), %rax
> +	leaq	initial_code(%rip), %rax
>  	pushq	$__KERNEL_CS	# set correct cs
> -	pushq	%rax		# target address in negative space
> +	pushq	(%rax)		# target address in negative space
>  	lretq
>  .Lafter_lret:
>  END(secondary_startup_64)
> -- 
> 2.21.0.1020.gf2820cf01a-goog
> 

-- 
Kees Cook
