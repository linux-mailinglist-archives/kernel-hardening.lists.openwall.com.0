Return-Path: <kernel-hardening-return-15995-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4F00E28E26
	for <lists+kernel-hardening@lfdr.de>; Fri, 24 May 2019 02:05:16 +0200 (CEST)
Received: (qmail 3293 invoked by uid 550); 24 May 2019 00:05:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3270 invoked from network); 24 May 2019 00:05:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Bg3lp1cp1YsHZIAZ+WZ5FtPbgNHk60LZKuR1dQM5X0o=;
        b=mmoVsIwHReQDPhkE8pfZYV7WXqnOV5tXm/Zklyw0xJ+ipTIIWge6M4WmPf43jJn3Ku
         wNC+tgP1Y9/6J2WES4ibeG2Hlp7iGy/v9AnM7BXbJMKkW4roaMU7xT6Dhyq1lNn2mIen
         RxLb0WX+C2o54dluBacYUimfY7Ll09hMwa7dU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Bg3lp1cp1YsHZIAZ+WZ5FtPbgNHk60LZKuR1dQM5X0o=;
        b=RMUL3edUuJNp0BeKcPsHePiLxih3esjLSg4U91QQMY7XlcMdGr6Z88vBJGG2fEqHis
         wsevj+UIJ6XCiqhBtH8UWj19WWwa3bDFrFZ2rFPP3stH90fMObE2ThNT84rvDMacs0wX
         9wDrn92pS4EQREM0cojTeZ89eZsEgh9hRGsiYrRo7V6ccB5NGgSxIQtrLjORBGj/yzM3
         EAPQuctg4br7rhChDmKSgYgGd5PekJQzqw+zaLV2vqNlHBPvliDGWHyYOamR+jKSF6PK
         qGewdEwGS7r3g115qpsAie7slnhGD9X1agEWX1srGpX/jRRPJ/PSlRMlxonod0SDYHAH
         Xjrw==
X-Gm-Message-State: APjAAAUZOfqDk/w+bOFH+PH0Ny/Gppl8lEFuMiBLHU4L7M/E80R4MLuj
	RGL1gZWvaKgY9lHgsc8az3Vu+Q==
X-Google-Smtp-Source: APXvYqyctB5V+K3NG1DpFLMcyJb93jrwPDhvUf/DwGjUNUzz8Ua+BzD11CKG169jmEoBbkZnJd67Uw==
X-Received: by 2002:a63:1c16:: with SMTP id c22mr41564941pgc.333.1558656291059;
        Thu, 23 May 2019 17:04:51 -0700 (PDT)
Date: Thu, 23 May 2019 17:04:48 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexander Potapenko <glider@google.com>
Cc: akpm@linux-foundation.org, cl@linux.com,
	kernel-hardening@lists.openwall.com, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Michal Hocko <mhocko@kernel.org>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Kostya Serebryany <kcc@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Sandeep Patil <sspatil@android.com>,
	Laura Abbott <labbott@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>,
	Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v4 1/3] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-ID: <201905231647.ED31A5FE30@keescook>
References: <20190523140844.132150-1-glider@google.com>
 <20190523140844.132150-2-glider@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523140844.132150-2-glider@google.com>

On Thu, May 23, 2019 at 04:08:42PM +0200, Alexander Potapenko wrote:
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 52e6fbb042cc..68fb6fa41cc1 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -1673,6 +1673,14 @@
>  
>  	initrd=		[BOOT] Specify the location of the initial ramdisk
>  
> +	init_on_alloc=	[MM] Fill newly allocated pages and heap objects with
> +			zeroes.
> +			Format: 0 | 1
> +			Default set by CONFIG_INIT_ON_ALLOC_DEFAULT_ON.
> +	init_on_free=	[MM] Fill freed pages and heap objects with zeroes.
> +			Format: 0 | 1
> +			Default set by CONFIG_INIT_ON_FREE_DEFAULT_ON.
> +
>  	init_pkru=	[x86] Specify the default memory protection keys rights
>  			register contents for all processes.  0x55555554 by
>  			default (disallow access to all but pkey 0).  Can

Nit: add a blank line between these new options' documentation to match
the others.

> diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
> index 0a1d4ca314f4..87883e3e3c2a 100644
> --- a/security/Kconfig.hardening
> +++ b/security/Kconfig.hardening
> @@ -159,6 +159,20 @@ config STACKLEAK_RUNTIME_DISABLE
>  	  runtime to control kernel stack erasing for kernels built with
>  	  CONFIG_GCC_PLUGIN_STACKLEAK.
>  
> +config INIT_ON_ALLOC_DEFAULT_ON
> +	bool "Set init_on_alloc=1 by default"
> +	help
> +	  Enable init_on_alloc=1 by default, making the kernel initialize every
> +	  page and heap allocation with zeroes.
> +	  init_on_alloc can be overridden via command line.
> +
> +config INIT_ON_FREE_DEFAULT_ON
> +	bool "Set init_on_free=1 by default"
> +	help
> +	  Enable init_on_free=1 by default, making the kernel initialize freed
> +	  pages and slab memory with zeroes.
> +	  init_on_free can be overridden via command line.
> +

I think these could use a lot more detail. How about something like
these, with more details and performance notes:

config INIT_ON_ALLOC_DEFAULT_ON
	bool "Enable heap memory zeroing on allocation by default"
	help
	  This has the effect of setting "init_on_alloc=1" on the kernel
	  command line. This can be disabled with "init_on_alloc=0".
	  When "init_on_alloc" is enabled, all page allocator and slab
	  allocator memory will be zeroed when allocated, eliminating
	  many kinds of "uninitialized heap memory" flaws, especially
	  heap content exposures. The performance impact varies by
	  workload, but most cases see <1% impact. Some synthetic
	  workloads have measured as high as 7%.

config INIT_ON_FREE_DEFAULT_ON
	bool "Enable heap memory zeroing on free by default"
	help
	  This has the effect of setting "init_on_free=1" on the kernel
	  command line. This can be disabled with "init_on_free=0".
	  Similar to "init_on_alloc", when "init_on_free" is enabled,
	  all page allocator and slab allocator memory will be zeroed
	  when freed, eliminating many kinds of "uninitialized heap memory"
	  flaws, especially heap content exposures. The primary difference
	  with "init_on_free" is that data lifetime in memory is reduced,
	  as anything freed is wiped immediately, making live forensics or
	  cold boot memory attacks unable to recover freed memory contents.
	  The performance impact varies by workload, but is more expensive
	  than "init_on_alloc" due to the negative cache effects of
	  touching "cold" memory areas. Most cases see 3-5% impact. Some
	  synthetic workloads have measured as high as 8%.


-- 
Kees Cook


-- 
Kees Cook
