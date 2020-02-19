Return-Path: <kernel-hardening-return-17841-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2C96E163C00
	for <lists+kernel-hardening@lfdr.de>; Wed, 19 Feb 2020 05:20:22 +0100 (CET)
Received: (qmail 3486 invoked by uid 550); 19 Feb 2020 04:20:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3463 invoked from network); 19 Feb 2020 04:20:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
	Subject:Sender:Reply-To:Content-ID:Content-Description;
	bh=w1v42JIbxbTQaj+IwxBJakhg/k+j4nNZQJZ/BeGoer0=; b=MTrRstBOnZxCNBLpVqArac2zI8
	ZRetyXVcg2qmFGkwhf9hvQWNslqjh/oAAitsy1+jMz53ikunqAwVlwMaeK7TcENEcJIYL/l0QGCu/
	6ev7PfkAFxCp2mWpw+t5vQUez2oMrhh1H48QMRf0Izn7mrv4NsxRSZydBhENC5MBgcjyB09N+twpr
	ZSZBaVElmIt4rCHc+D97/8V7RvU2aD5qvXjVm2aNwmda0HqwSVTZpRsU/20Z6xVP7fx3nhgJ7BfNZ
	6K4uCdk7Op/UDWyhUlRMFMxfC2kUkb/+ou7Sg4o1Fg+/bUmrNjML9RkRUmykXGkaG7AvFe1ss+rHL
	AI/pl1xA==;
Subject: Re: [PATCH v8 01/12] add support for Clang's Shadow Call Stack (SCS)
To: Sami Tolvanen <samitolvanen@google.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
 Mark Rutland <mark.rutland@arm.com>, james.morse@arm.com
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>,
 Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>,
 Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
 Masahiro Yamada <yamada.masahiro@socionext.com>,
 clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200219000817.195049-1-samitolvanen@google.com>
 <20200219000817.195049-2-samitolvanen@google.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <60ec3a49-7b71-df31-f231-b48ff135b718@infradead.org>
Date: Tue, 18 Feb 2020 20:19:56 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200219000817.195049-2-samitolvanen@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

Hi Sami,

a couple of minor tweaks:

On 2/18/20 4:08 PM, Sami Tolvanen wrote:
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 98de654b79b3..66b34fd0df54 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -526,6 +526,40 @@ config STACKPROTECTOR_STRONG
>  	  about 20% of all kernel functions, which increases the kernel code
>  	  size by about 2%.
>  
> +config ARCH_SUPPORTS_SHADOW_CALL_STACK
> +	bool
> +	help
> +	  An architecture should select this if it supports Clang's Shadow
> +	  Call Stack, has asm/scs.h, and implements runtime support for shadow
> +	  stack switching.
> +
> +config SHADOW_CALL_STACK
> +	bool "Clang Shadow Call Stack"
> +	depends on ARCH_SUPPORTS_SHADOW_CALL_STACK
> +	help
> +	  This option enables Clang's Shadow Call Stack, which uses a
> +	  shadow stack to protect function return addresses from being
> +	  overwritten by an attacker. More information can be found from

	                                                      found in

> +	  Clang's documentation:
> +
> +	    https://clang.llvm.org/docs/ShadowCallStack.html
> +
> +	  Note that security guarantees in the kernel differ from the ones
> +	  documented for user space. The kernel must store addresses of shadow
> +	  stacks used by other tasks and interrupt handlers in memory, which
> +	  means an attacker capable reading and writing arbitrary memory may

	                    capable of

> +	  be able to locate them and hijack control flow by modifying shadow
> +	  stacks that are not currently in use.
> +
> +config SHADOW_CALL_STACK_VMAP
> +	bool "Use virtually mapped shadow call stacks"
> +	depends on SHADOW_CALL_STACK
> +	help
> +	  Use virtually mapped shadow call stacks. Selecting this option
> +	  provides better stack exhaustion protection, but increases per-thread
> +	  memory consumption as a full page is allocated for each shadow stack.
> +
> +
>  config HAVE_ARCH_WITHIN_STACK_FRAMES
>  	bool
>  	help


thanks.
-- 
~Randy

