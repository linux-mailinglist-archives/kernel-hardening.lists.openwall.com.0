Return-Path: <kernel-hardening-return-17839-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 882E81638CC
	for <lists+kernel-hardening@lfdr.de>; Wed, 19 Feb 2020 01:58:44 +0100 (CET)
Received: (qmail 27853 invoked by uid 550); 19 Feb 2020 00:58:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 27833 invoked from network); 19 Feb 2020 00:58:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iSZk69ptAiTyf7jpHNkoClrlGQ6cnI+6Xpj9dCGMjN0=;
        b=Ih0TjNY9842AqcuQgmoScvFqrmIbnDcyT2G+Zz4H7cAxEjHt0DyfSoOYIn774f5oXB
         7N482BmqyEb+fPQ62sT9IirOQ1sOWGAEpZc/b9h9LQ9qxLL2Xkg18FgiTMcYoMsUYOV1
         Agml5+hejGispc0IEUqgulEwAitKHdS/jC2J0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iSZk69ptAiTyf7jpHNkoClrlGQ6cnI+6Xpj9dCGMjN0=;
        b=Jb7dIGZzZJgip590h9/xo/AUBEfcqtugwBNlOxOXTBdDst+xZF47YfqDBxYJFfHG7e
         kIQPhiuCLF3NYjTepdQnqH8v3CjIj8AwZx2WV8ocgX6MkHbCohmaFq9a+VmrcDH5OYxI
         PCtBCxFEzxtJQfX9g/6pyC4bJJDJiN7wwx70rowDngxjcQaZp4+cnyeRHbDjkfEUhsON
         06kz/Ha/8fHonV7qBjp5hdlTbRYLL/BI5w5sL1D8vP69UMBE5isHSHHS/Fe17VjftbAx
         aYond4VWZFJf6VRjiNa2ymXZYHmUEBh6JLUQr5f5PjzQ0oGafL5IszPOuFQjwpZAB747
         5Oew==
X-Gm-Message-State: APjAAAXjYnaah9aBwplg6WrrxYWopjIdP8Kya3zwVq4AA10xRLf3PgO9
	xyUXicgFs6KDBG2TdkU/G0I7dQ==
X-Google-Smtp-Source: APXvYqwMB+TjIkvXxWZ6X+9g5aGFD1+V5OiJ0ztLwJPySi7aV3TrAhaznYiFLVqLpiYGnEPzwM+MEA==
X-Received: by 2002:aa7:9aa5:: with SMTP id x5mr24532698pfi.131.1582073906946;
        Tue, 18 Feb 2020 16:58:26 -0800 (PST)
Date: Tue, 18 Feb 2020 16:58:25 -0800
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>, james.morse@arm.com,
	Dave Martin <Dave.Martin@arm.com>,
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 09/12] arm64: disable SCS for hypervisor code
Message-ID: <202002181658.41FA7C514E@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200219000817.195049-1-samitolvanen@google.com>
 <20200219000817.195049-10-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200219000817.195049-10-samitolvanen@google.com>

On Tue, Feb 18, 2020 at 04:08:14PM -0800, Sami Tolvanen wrote:
> Disable SCS for code that runs at a different exception level by
> adding __noscs to __hyp_text.
> 
> Suggested-by: James Morse <james.morse@arm.com>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  arch/arm64/include/asm/kvm_hyp.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
> index a3a6a2ba9a63..0f0603f55ea0 100644
> --- a/arch/arm64/include/asm/kvm_hyp.h
> +++ b/arch/arm64/include/asm/kvm_hyp.h
> @@ -13,7 +13,7 @@
>  #include <asm/kvm_mmu.h>
>  #include <asm/sysreg.h>
>  
> -#define __hyp_text __section(.hyp.text) notrace
> +#define __hyp_text __section(.hyp.text) notrace __noscs
>  
>  #define read_sysreg_elx(r,nvh,vh)					\
>  	({								\
> -- 
> 2.25.0.265.gbab2e86ba0-goog
> 

-- 
Kees Cook
