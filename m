Return-Path: <kernel-hardening-return-15905-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 293C318317
	for <lists+kernel-hardening@lfdr.de>; Thu,  9 May 2019 03:05:26 +0200 (CEST)
Received: (qmail 19988 invoked by uid 550); 9 May 2019 01:05:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19970 invoked from network); 9 May 2019 01:05:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
	Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=G13SwZrvXQwLwqfSvC5cLaD8FJjp+bG9vvkSPGdxrhE=; b=b4bKpqtlBzzAQmT4dULJ60Wx/
	4+mV8vaQI2ye68XjE42FuRpIw2V+NKJMAqALzmF4L45TsWnm64cyf9aZYpA8l8d1NVLuDS8uIeCMm
	2B7tvT+bSk4czrUY6K7SQEb6YcRxEbbkhhUCmU6VEmkdwCO+ZFvwQ/ZUJqgP/w4jZo4iHlN3eaVL+
	kK/r7hTkrByF/ZaNFivjTPBINatmyiTOXJz51A7fd2jgcAqqDsyZ7d8uJeCUAQmLsnA5elniY+wKR
	sRgfHraFrxNNMgi36b/ZcrHq1Zw1KU7TahBjwB+7xbQIFWjjkzqDqw82hUi657MF+rES6DBkqzcCu
	rbCtLeMpQ==;
Subject: Re: [PATCH 1/4] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
To: Alexander Potapenko <glider@google.com>, akpm@linux-foundation.org,
 cl@linux.com, keescook@chromium.org, labbott@redhat.com
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org,
 kernel-hardening@lists.openwall.com, yamada.masahiro@socionext.com,
 jmorris@namei.org, serge@hallyn.com, ndesaulniers@google.com,
 kcc@google.com, dvyukov@google.com, sspatil@android.com, jannh@google.com,
 mark.rutland@arm.com
References: <20190508153736.256401-1-glider@google.com>
 <20190508153736.256401-2-glider@google.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <6e5ccf92-cc58-ab2b-d025-0f5642d5f4a6@infradead.org>
Date: Wed, 8 May 2019 18:04:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190508153736.256401-2-glider@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 5/8/19 8:37 AM, Alexander Potapenko wrote:
> diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
> index 0a1d4ca314f4..4a4001f5ad25 100644
> --- a/security/Kconfig.hardening
> +++ b/security/Kconfig.hardening
> @@ -159,6 +159,22 @@ config STACKLEAK_RUNTIME_DISABLE
>  	  runtime to control kernel stack erasing for kernels built with
>  	  CONFIG_GCC_PLUGIN_STACKLEAK.
>  
> +config INIT_ON_ALLOC_DEFAULT_ON
> +	bool "Set init_on_alloc=1 by default"
> +	default false

That should be spelled "default n" but since that is already the default,
just omit the line completely.

> +	help
> +	  Enable init_on_alloc=1 by default, making the kernel initialize every
> +	  page and heap allocation with zeroes.
> +	  init_on_alloc can be overridden via command line.
> +
> +config INIT_ON_FREE_DEFAULT_ON
> +	bool "Set init_on_free=1 by default"
> +	default false

ditto.

> +	help
> +	  Enable init_on_free=1 by default, making the kernel initialize freed
> +	  pages and slab memory with zeroes.
> +	  init_on_free can be overridden via command line.
> +
>  endmenu
>  
>  endmenu


-- 
~Randy
