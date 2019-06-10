Return-Path: <kernel-hardening-return-16091-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 855553BEBF
	for <lists+kernel-hardening@lfdr.de>; Mon, 10 Jun 2019 23:35:13 +0200 (CEST)
Received: (qmail 15604 invoked by uid 550); 10 Jun 2019 21:35:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15580 invoked from network); 10 Jun 2019 21:35:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pteaYwusSv1qv4P2op3THXOYAUVIJihXku4KOl16Zg4=;
        b=JeDugfY0nBQLUyJ8NNKi0czU62TUohv7xo5lv+lX1+btLEQAiU+AwqhR4QyxssKqCF
         xbQy3Tbzk5Z/6xR3MPKNwApNRGQvO4zbAisnDlge/d2NJQwI6etPbgu4PFg8m1vvqeAd
         Iohr4E5mhLtChm+VN9wtD9M28ewP8llVW9pbE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pteaYwusSv1qv4P2op3THXOYAUVIJihXku4KOl16Zg4=;
        b=SRkyvgCvWSvqxT4/svsvStan8hSCrSDwsWaMFqCcnNxXhpHymVlpmZJcHfnjK4fKos
         c8an+3u+obJ4kjGaSUkj42fFpxAMiuOuOXlqFe525+UMtCluKWfyhe3oyLYxBlmOGNva
         3/qn2iAjIPUpvszPd8mlaoyTjaHl05lcyV8vtRlQTNez2+g7zKZAkcUyxQBX0xAy3ZnF
         r17jzrngd/FFWv9f/8vs425/uSCnCdR8eUdB1z9RjaDS1jUbR/4sfHHA3t3Eatm1Na7+
         YPQK15TSFnWynLliNAQrHDICeuqNAyYnGTqFZdBVRwllbkn+HRRSqpoCVxh0YLIL0+G2
         LemQ==
X-Gm-Message-State: APjAAAVVtXtlnqMq4KOWzgcyvmf343bJziXL8zPEif+xmezkucHO0Vce
	iT5UBh8P80UxDp4hx/SsU2BYLQ==
X-Google-Smtp-Source: APXvYqwNZMiOvutv3Rp3VcasZg78NdLKjQBKzBhlnHUB2nT2vU+bNnhXVPKquqGWuVAsKl12MA239A==
X-Received: by 2002:a17:90a:7184:: with SMTP id i4mr23657923pjk.49.1560202495619;
        Mon, 10 Jun 2019 14:34:55 -0700 (PDT)
Date: Mon, 10 Jun 2019 14:34:54 -0700
From: Kees Cook <keescook@chromium.org>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
	Thomas Garnier <thgarnie@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 06/12] x86: pm-trace - Adapt assembly for PIE support
Message-ID: <201906101434.D20FDB0A9@keescook>
References: <20190520231948.49693-1-thgarnie@chromium.org>
 <20190520231948.49693-7-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520231948.49693-7-thgarnie@chromium.org>

On Mon, May 20, 2019 at 04:19:31PM -0700, Thomas Garnier wrote:
> From: Thomas Garnier <thgarnie@google.com>
> 
> Change assembly to use the new _ASM_MOVABS macro instead of _ASM_MOV for
> the assembly to be PIE compatible.
> 
> Position Independent Executable (PIE) support will allow to extend the
> KASLR randomization range below 0xffffffff80000000.
> 
> Signed-off-by: Thomas Garnier <thgarnie@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  arch/x86/include/asm/pm-trace.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/include/asm/pm-trace.h b/arch/x86/include/asm/pm-trace.h
> index bfa32aa428e5..972070806ce9 100644
> --- a/arch/x86/include/asm/pm-trace.h
> +++ b/arch/x86/include/asm/pm-trace.h
> @@ -8,7 +8,7 @@
>  do {								\
>  	if (pm_trace_enabled) {					\
>  		const void *tracedata;				\
> -		asm volatile(_ASM_MOV " $1f,%0\n"		\
> +		asm volatile(_ASM_MOVABS " $1f,%0\n"		\
>  			     ".section .tracedata,\"a\"\n"	\
>  			     "1:\t.word %c1\n\t"		\
>  			     _ASM_PTR " %c2\n"			\
> -- 
> 2.21.0.1020.gf2820cf01a-goog
> 

-- 
Kees Cook
