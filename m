Return-Path: <kernel-hardening-return-16090-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 62BC23BEBE
	for <lists+kernel-hardening@lfdr.de>; Mon, 10 Jun 2019 23:34:57 +0200 (CEST)
Received: (qmail 13657 invoked by uid 550); 10 Jun 2019 21:34:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13635 invoked from network); 10 Jun 2019 21:34:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0gg9xI+8OwFzJxQ5Jji+7QkkrE7G1u89nLUppMZzu4U=;
        b=IC/xB4mZYUXagp1Vs5PCNT5doE5TOZwvi2QbGkJUI340xW7wqEHqYG7y/Eq+xenumk
         cS8HQehz3OrthiYSUfl/obdasSCXFz9D8cKjBNAGQDkIJQ7A/7VJiQN1LGRjnoWEmiwq
         W3AhlKPISl2oSnRtTU4apJ4FJiVcKCsWREVEg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=0gg9xI+8OwFzJxQ5Jji+7QkkrE7G1u89nLUppMZzu4U=;
        b=ikalQmX9SgRqvhkcTah9W3sTxdtX8HVLvmJKINoSFZbxc8CwFSF2aaPrpb7O4n2xsR
         b70TatY6wIm+ylZ7gAUg9EFq8hko5r6g0qsBR6/LS5eQa8kovhgyD3fey57oJqmbIIwh
         ekk+53sIK77sTWHXaw+6kLES3uZUhoFBxHH4ZdUxc8XJWXmmWa/pKsQSObvdxlWm1e94
         DXGbUlKe85Sxm6Kd4iavo/s6oyz4PxiLfK4UnO7/p1jGCXZ7+v3RyF7Pj5IWO5NNrw0z
         2mG+lyQLxmBfTICQ/6Ck+1D8Sq1lvqtn/gLK18/FLpUvFoHpREaKXUMv+xhhancnUlXh
         AWcA==
X-Gm-Message-State: APjAAAX2IsFudWOe4HZEsrS5k2XXczEuS6Au13h417HOtkddRl9+w0ve
	JQ/+4kfnegpFtGX14qtmDIioj/lf/9k=
X-Google-Smtp-Source: APXvYqzjO8yUHSkuYoQvw/HO6Xif3zgekf12tc403Aq29rm+0ex33Cb6wl/8OR0+O7ACVBSvhVTnpA==
X-Received: by 2002:a63:1f48:: with SMTP id q8mr122649pgm.417.1560202480038;
        Mon, 10 Jun 2019 14:34:40 -0700 (PDT)
Date: Mon, 10 Jun 2019 14:34:38 -0700
From: Kees Cook <keescook@chromium.org>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
	Thomas Garnier <thgarnie@google.com>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 05/12] x86/entry/64: Adapt assembly for PIE support
Message-ID: <201906101433.C0DB679DD@keescook>
References: <20190520231948.49693-1-thgarnie@chromium.org>
 <20190520231948.49693-6-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520231948.49693-6-thgarnie@chromium.org>

On Mon, May 20, 2019 at 04:19:30PM -0700, Thomas Garnier wrote:
> From: Thomas Garnier <thgarnie@google.com>
> 
> Change the assembly code to use only relative references of symbols for the
> kernel to be PIE compatible.
> 
> Position Independent Executable (PIE) support will allow to extend the
> KASLR randomization range below 0xffffffff80000000.
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> ---
>  arch/x86/entry/entry_64.S | 16 +++++++++++-----
>  1 file changed, 11 insertions(+), 5 deletions(-)
> 
> diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
> index 20e45d9b4e15..e99b3438aa9b 100644
> --- a/arch/x86/entry/entry_64.S
> +++ b/arch/x86/entry/entry_64.S
> @@ -1268,7 +1268,8 @@ ENTRY(error_entry)
>  	movl	%ecx, %eax			/* zero extend */
>  	cmpq	%rax, RIP+8(%rsp)
>  	je	.Lbstep_iret
> -	cmpq	$.Lgs_change, RIP+8(%rsp)
> +	leaq	.Lgs_change(%rip), %rcx
> +	cmpq	%rcx, RIP+8(%rsp)
>  	jne	.Lerror_entry_done
>  
>  	/*
> @@ -1465,10 +1466,10 @@ ENTRY(nmi)
>  	 * resume the outer NMI.
>  	 */
>  
> -	movq	$repeat_nmi, %rdx
> +	leaq	repeat_nmi(%rip), %rdx
>  	cmpq	8(%rsp), %rdx
>  	ja	1f
> -	movq	$end_repeat_nmi, %rdx
> +	leaq	end_repeat_nmi(%rip), %rdx
>  	cmpq	8(%rsp), %rdx
>  	ja	nested_nmi_out
>  1:
> @@ -1522,7 +1523,8 @@ nested_nmi:
>  	pushq	%rdx
>  	pushfq
>  	pushq	$__KERNEL_CS
> -	pushq	$repeat_nmi
> +	leaq	repeat_nmi(%rip), %rdx
> +	pushq	%rdx
>  
>  	/* Put stack back */
>  	addq	$(6*8), %rsp
> @@ -1561,7 +1563,11 @@ first_nmi:
>  	addq	$8, (%rsp)	/* Fix up RSP */
>  	pushfq			/* RFLAGS */
>  	pushq	$__KERNEL_CS	/* CS */
> -	pushq	$1f		/* RIP */
> +	pushq	$0		/* Futur return address */

typo: Future

> +	pushq	%rax		/* Save RAX */
> +	leaq	1f(%rip), %rax	/* RIP */
> +	movq    %rax, 8(%rsp)   /* Put 1f on return address */
> +	popq	%rax		/* Restore RAX */
>  	iretq			/* continues at repeat_nmi below */
>  	UNWIND_HINT_IRET_REGS
>  1:

Other than that:

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
