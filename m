Return-Path: <kernel-hardening-return-16005-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B8C122E4A6
	for <lists+kernel-hardening@lfdr.de>; Wed, 29 May 2019 20:43:27 +0200 (CEST)
Received: (qmail 14283 invoked by uid 550); 29 May 2019 18:43:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 14238 invoked from network); 29 May 2019 18:43:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=EfGbBMHYGMmn9vTu990IJy1DO6Nzjk593nZn1dz4oVk=;
        b=jegnb+b+gX//d0vhP3uQvq7x+sAF3QEmogXo39wiwjaOrMNfZo1hXe3LqWwdyTlEGP
         sLjJiDBuOiQ5XbLD/BthT+9Q0e3xSRma3rzkzRLE/SH7g1hdl3RHi25rlwNs1z+/ZU5g
         y/2mNWS5Qnps3vAMakm3FhuP5d/GjDu0t652o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=EfGbBMHYGMmn9vTu990IJy1DO6Nzjk593nZn1dz4oVk=;
        b=dQkmH73Ms0vnCAWjsgsQ/fAqXfh1JzFhRUtp7QpIBbr15fXatFzhdcE/kY7qa5sdEy
         PwEoF/VVI0xXdRYBxYY66FLg6pLTi7sRgGre8feDl5UzfGmTKih/nMlE45Qcyg9JbsPv
         PwycLLRdHQ5CfzAFjdsVvW+Pv/1/6X5iE/ylwHiwDberjUR1LN5+4Yli+LAfPhVgWUtT
         9qfNcnnwOfCZbJK6T5KxeLNXKhIKPlpVUXjGmQBzvBHeW5tL92PyUT4scBB/PDn//Rr7
         BTX2SEMPbQehDba0fGRQjmVFWRMolsOopKpiwor0C4aHE/LHpxXsPPg1GWYKkMc6wMg3
         iWJg==
X-Gm-Message-State: APjAAAVj56x3/j3ARDXdPhed1u87t8nFJpzXHZmLn8IxTKiEZRuCOp7R
	7kW87g9fJF5AVn/qQOqavmQktg==
X-Google-Smtp-Source: APXvYqzpr7CoVb5BM/Pz1u+mLgd3ASb0jPnJQzj1N/X5EKbeo05UJH/jb1NCHGZzD/mmLzqv8VLj5Q==
X-Received: by 2002:a17:902:7c08:: with SMTP id x8mr5907075pll.159.1559155389784;
        Wed, 29 May 2019 11:43:09 -0700 (PDT)
Date: Wed, 29 May 2019 11:43:08 -0700
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
	Marco Elver <elver@google.com>, kernel-hardening@lists.openwall.com,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v5 2/3] mm: init: report memory auto-initialization
 features at boot time
Message-ID: <201905291142.E415379F2@keescook>
References: <20190529123812.43089-1-glider@google.com>
 <20190529123812.43089-3-glider@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190529123812.43089-3-glider@google.com>

On Wed, May 29, 2019 at 02:38:11PM +0200, Alexander Potapenko wrote:
> Print the currently enabled stack and heap initialization modes.
> 
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
> 
> Signed-off-by: Alexander Potapenko <glider@google.com>
> Suggested-by: Kees Cook <keescook@chromium.org>

Looks good to me!

Acked-by: Kees Cook <keescook@chromium.org>

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
> Cc: kernel-hardening@lists.openwall.com
> Cc: linux-mm@kvack.org
> Cc: linux-security-module@vger.kernel.org
> ---
>  init/main.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/init/main.c b/init/main.c
> index 66a196c5e4c3..9d63ff1d48f3 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -520,6 +520,29 @@ static inline void initcall_debug_enable(void)
>  }
>  #endif
>  
> +/* Report memory auto-initialization states for this boot. */
> +void __init report_meminit(void)
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
> +		pr_info("Clearing system memory may take some time...\n");
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
> 2.22.0.rc1.257.g3120a18244-goog
> 

-- 
Kees Cook
