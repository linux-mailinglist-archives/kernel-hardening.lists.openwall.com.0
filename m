Return-Path: <kernel-hardening-return-16065-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8ACB838F2F
	for <lists+kernel-hardening@lfdr.de>; Fri,  7 Jun 2019 17:35:16 +0200 (CEST)
Received: (qmail 28250 invoked by uid 550); 7 Jun 2019 15:35:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28205 invoked from network); 7 Jun 2019 15:35:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=KfsubRPhiyKBXFr1tZvtiO/czPIi+jUPbPm10i13Y5g=;
        b=GJB5bsI3qmo9VsdAbqA/U+U5Ba57SSzH5rgLLx9qAGERoHL+KwRa0xOm2zhZbkPdwE
         Rs5IiU+m+yotBhVrT/8BxUFHdukj0LELAt2c4gm9wycVNeo72sTiQ+EBRHAfP/UvL1h7
         Xkq2rZTAhzCRADZtQaiZ2neu2LGMv+agKeapY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=KfsubRPhiyKBXFr1tZvtiO/czPIi+jUPbPm10i13Y5g=;
        b=lhR+YwW00Fn2CyNRl1rBcGrEguNcTmCIsoauJFeJmb7NAf05xazsbLDGlH+ljX5VaU
         c3/VEQSXH5siBgnxqKOskJhpSNVUpuC3Dg/zWIiJtbD85+UM9e9z40/whh1kBX7TQT45
         Y7Dg+tHDCFIXPp/ZvbzsYzYkmtW8BYBx7p0mFXAKdDBcAH/sUCt74G3tAt5DabcibFWP
         zw2GBQY09R1kbX2zvYmSdjmWlLm6g+UY1CK8/1UJBhCNpfPoBqp7WgfYSUKxs4Zoo2eQ
         JY/rr+MevA3Mq4nlzFqreysKWRjVRV748Siqe9xwrR+C+41+7v5SNL0fNHmmcdsNGDDh
         pxTg==
X-Gm-Message-State: APjAAAWqKBjopI6LMvOYFGWBzuoH4MZJrBKmV9G/2/r/nWESpTkT5sQn
	QA26OHbVeiVKHPID/nvDsPObVw==
X-Google-Smtp-Source: APXvYqwMPVOr9kcYblLhVYRdwJwRq6N4UsAMHzOFfp9A95scFiuSqPvBYn3TQCVYvQqEcz8eubkISA==
X-Received: by 2002:a63:2109:: with SMTP id h9mr3320579pgh.51.1559921696599;
        Fri, 07 Jun 2019 08:34:56 -0700 (PDT)
Date: Fri, 7 Jun 2019 08:34:54 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
	Kostya Serebryany <kcc@google.com>,
	Laura Abbott <labbott@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Matthew Wilcox <willy@infradead.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sandeep Patil <sspatil@android.com>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Souptick Joarder <jrdr.linux@gmail.com>,
	Marco Elver <elver@google.com>,
	Kaiwan N Billimoria <kaiwan@kaiwantech.com>,
	kernel-hardening@lists.openwall.com, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org
Subject: Re: [PATCH v6 2/3] mm: init: report memory auto-initialization
 features at boot time
Message-ID: <201906070822.CEF77C844E@keescook>
References: <20190606164845.179427-1-glider@google.com>
 <20190606164845.179427-3-glider@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606164845.179427-3-glider@google.com>

On Thu, Jun 06, 2019 at 06:48:44PM +0200, Alexander Potapenko wrote:
> Print the currently enabled stack and heap initialization modes.
> 
> Stack initialization is enabled by a config flag, while heap
> initialization is configured at boot time with defaults being set
> in the config. It's more convenient for the user to have all information
> about these hardening measures in one place.

Perhaps for clarity, add this to the end of the sentence:

"... at boot, so the user can reason about the expected behavior of
the running system."

> The possible options for stack are:
>  - "all" for CONFIG_INIT_STACK_ALL;
>  - "byref_all" for CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL;
>  - "byref" for CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF;
>  - "__user" for CONFIG_GCC_PLUGIN_STRUCTLEAK_USER;
>  - "off" otherwise.
> 
> Depending on the values of init_on_alloc and init_on_free boottime
> options we also report "heap alloc" and "heap free" as "on"/"off".
> 
> In the init_on_free mode initializing pages at boot time may take some
> time, so print a notice about that as well.

Perhaps give an example too:


This depends on how much memory is installed, the memory bandwidth, etc.
On a relatively modern x86 system, it takes about 0.75s/GB to wipe all
memory:

[    0.418722] mem auto-init: stack:byref_all, heap alloc:off, heap free:on
[    0.419765] mem auto-init: clearing system memory may take some time...
[   12.376605] Memory: 16408564K/16776672K available (14339K kernel code, 1397K rwdata, 3756K rodata, 1636K init, 11460K bss, 368108K reserved, 0K cma-reserved)



More notes below...

> 
> Signed-off-by: Alexander Potapenko <glider@google.com>
> Suggested-by: Kees Cook <keescook@chromium.org>
> To: Andrew Morton <akpm@linux-foundation.org>
> To: Christoph Lameter <cl@linux.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Kostya Serebryany <kcc@google.com>
> Cc: Laura Abbott <labbott@redhat.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Sandeep Patil <sspatil@android.com>
> Cc: "Serge E. Hallyn" <serge@hallyn.com>
> Cc: Souptick Joarder <jrdr.linux@gmail.com>
> Cc: Marco Elver <elver@google.com>
> Cc: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
> Cc: kernel-hardening@lists.openwall.com
> Cc: linux-mm@kvack.org
> Cc: linux-security-module@vger.kernel.org
> ---
>  v6:
>  - update patch description, fixed message about clearing memory
> ---
>  init/main.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/init/main.c b/init/main.c
> index 66a196c5e4c3..e68ef1f181f9 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -520,6 +520,29 @@ static inline void initcall_debug_enable(void)
>  }
>  #endif
>  
> +/* Report memory auto-initialization states for this boot. */
> +void __init report_meminit(void)

Sorry I missed this before: it should be a static function.

> +{
> +	const char *stack;
> +
> +	if (IS_ENABLED(CONFIG_INIT_STACK_ALL))
> +		stack = "all";
> +	else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL))
> +		stack = "byref_all";
> +	else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF))
> +		stack = "byref";
> +	else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_USER))
> +		stack = "__user";
> +	else
> +		stack = "off";
> +
> +	pr_info("mem auto-init: stack:%s, heap alloc:%s, heap free:%s\n",
> +		stack, want_init_on_alloc(GFP_KERNEL) ? "on" : "off",
> +		want_init_on_free() ? "on" : "off");
> +	if (want_init_on_free())
> +		pr_info("mem auto-init: clearing system memory may take some time...\n");
> +}
> +
>  /*
>   * Set up kernel memory allocators
>   */
> @@ -530,6 +553,7 @@ static void __init mm_init(void)
>  	 * bigger than MAX_ORDER unless SPARSEMEM.
>  	 */
>  	page_ext_init_flatmem();
> +	report_meminit();
>  	mem_init();
>  	kmem_cache_init();
>  	pgtable_init();
> -- 
> 2.22.0.rc1.311.g5d7573a151-goog
> 

But other than that:

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
