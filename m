Return-Path: <kernel-hardening-return-16067-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 95D1A38F8D
	for <lists+kernel-hardening@lfdr.de>; Fri,  7 Jun 2019 17:42:50 +0200 (CEST)
Received: (qmail 8036 invoked by uid 550); 7 Jun 2019 15:42:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7959 invoked from network); 7 Jun 2019 15:42:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZTKHB0/SPQnh5O6uvqPLAsIofFpvubfJWsN2iGQGWzo=;
        b=nH1oL74JD0Zwm4TvDR1uqFVi16VD+kFzOYBpfK6/MsimpUXDBxjxp8AftbnIlEXewM
         xTrzkdn4R8qig/zdT8VichtkcKBUxcHEYqRLjMb7vi6K6U+DaZ4vBxI4Eq/KVAxlTwu4
         IoZFR1sQoWeNE6x9UM7qDSytgFuwaoHBa5FxQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZTKHB0/SPQnh5O6uvqPLAsIofFpvubfJWsN2iGQGWzo=;
        b=RKqpk0hr0iyRHahfHGTG15DYje1FlxWEuynUvgvCyn5QhK/xGhkwUx08XCtoqzFjJC
         GssebSCGq8VnQFoFJWQgS6FyjO3b+3eBV7btsyvfYv4UkN07WlqmO+YFr4ZzIAxMMPtc
         Jpo5sUVddiEUT4eTrJ2MFq++YUEXBE4PfR3uYO8yOafdoJfvxLkmD60RmA8u5sFp3Nvj
         ZMXhV5BYti5oDTx7Zu4S28poSeSFT+dSoDG+BOhktwxBA/5EJxRJJYMIBwiXzDpMytcp
         Yn69/p+Gc1P5x2ArqTmstu5JDTTtIlGIoPxcD5S3wrLvrp3WG3VUMzbzLH0Dq702namx
         QdFQ==
X-Gm-Message-State: APjAAAWKYi3FRD2n2dyJZZSu+n12hXWaYnWluPz6dI+ln2SJyxsBFGuc
	+KAiGsVqAiDOsb5gO+smF4yltg==
X-Google-Smtp-Source: APXvYqy/tQ6u/ZklAxZPO/RuoWG0ozBbGj+Ufn/uDExCBarSvffDij8LO4l6LJH10CsjyCSCn6TcMQ==
X-Received: by 2002:a17:902:1029:: with SMTP id b38mr55281485pla.72.1559922149524;
        Fri, 07 Jun 2019 08:42:29 -0700 (PDT)
Date: Fri, 7 Jun 2019 08:42:27 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Michal Hocko <mhocko@kernel.org>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Kostya Serebryany <kcc@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Sandeep Patil <sspatil@android.com>,
	Laura Abbott <labbott@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>,
	Mark Rutland <mark.rutland@arm.com>, Marco Elver <elver@google.com>,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v6 1/3] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-ID: <201906070841.4680E54@keescook>
References: <20190606164845.179427-1-glider@google.com>
 <20190606164845.179427-2-glider@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190606164845.179427-2-glider@google.com>

On Thu, Jun 06, 2019 at 06:48:43PM +0200, Alexander Potapenko wrote:
> The new options are needed to prevent possible information leaks and
> make control-flow bugs that depend on uninitialized values more
> deterministic.
> 
> init_on_alloc=1 makes the kernel initialize newly allocated pages and heap
> objects with zeroes. Initialization is done at allocation time at the
> places where checks for __GFP_ZERO are performed.
> 
> init_on_free=1 makes the kernel initialize freed pages and heap objects
> with zeroes upon their deletion. This helps to ensure sensitive data
> doesn't leak via use-after-free accesses.
> 
> Both init_on_alloc=1 and init_on_free=1 guarantee that the allocator
> returns zeroed memory. The two exceptions are slab caches with
> constructors and SLAB_TYPESAFE_BY_RCU flag. Those are never
> zero-initialized to preserve their semantics.
> 
> Both init_on_alloc and init_on_free default to zero, but those defaults
> can be overridden with CONFIG_INIT_ON_ALLOC_DEFAULT_ON and
> CONFIG_INIT_ON_FREE_DEFAULT_ON.
> 
> Slowdown for the new features compared to init_on_free=0,
> init_on_alloc=0:
> 
> hackbench, init_on_free=1:  +7.62% sys time (st.err 0.74%)
> hackbench, init_on_alloc=1: +7.75% sys time (st.err 2.14%)
> 
> Linux build with -j12, init_on_free=1:  +8.38% wall time (st.err 0.39%)
> Linux build with -j12, init_on_free=1:  +24.42% sys time (st.err 0.52%)
> Linux build with -j12, init_on_alloc=1: -0.13% wall time (st.err 0.42%)
> Linux build with -j12, init_on_alloc=1: +0.57% sys time (st.err 0.40%)
> 
> The slowdown for init_on_free=0, init_on_alloc=0 compared to the
> baseline is within the standard error.
> 
> The new features are also going to pave the way for hardware memory
> tagging (e.g. arm64's MTE), which will require both on_alloc and on_free
> hooks to set the tags for heap objects. With MTE, tagging will have the
> same cost as memory initialization.
> 
> Although init_on_free is rather costly, there are paranoid use-cases where
> in-memory data lifetime is desired to be minimized. There are various
> arguments for/against the realism of the associated threat models, but
> given that we'll need the infrastructre for MTE anyway, and there are
> people who want wipe-on-free behavior no matter what the performance cost,
> it seems reasonable to include it in this series.
> 
> Signed-off-by: Alexander Potapenko <glider@google.com>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> To: Andrew Morton <akpm@linux-foundation.org>
> To: Christoph Lameter <cl@linux.com>
> To: Kees Cook <keescook@chromium.org>
> Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: James Morris <jmorris@namei.org>
> Cc: "Serge E. Hallyn" <serge@hallyn.com>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Kostya Serebryany <kcc@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Sandeep Patil <sspatil@android.com>
> Cc: Laura Abbott <labbott@redhat.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: Marco Elver <elver@google.com>
> Cc: linux-mm@kvack.org
> Cc: linux-security-module@vger.kernel.org
> Cc: kernel-hardening@lists.openwall.com
> ---
>  v2:
>   - unconditionally initialize pages in kernel_init_free_pages()
>   - comment from Randy Dunlap: drop 'default false' lines from Kconfig.hardening
>  v3:
>   - don't call kernel_init_free_pages() from memblock_free_pages()
>   - adopted some Kees' comments for the patch description
>  v4:
>   - use NULL instead of 0 in slab_alloc_node() (found by kbuild test robot)
>   - don't write to NULL object in slab_alloc_node() (found by Android
>     testing)
>  v5:
>   - adjusted documentation wording as suggested by Kees
>   - disable SLAB_POISON if auto-initialization is on
>   - don't wipe RCU cache allocations made without __GFP_ZERO
>   - dropped SLOB support
> ---
>  .../admin-guide/kernel-parameters.txt         |  9 +++
>  drivers/infiniband/core/uverbs_ioctl.c        |  2 +-
>  include/linux/mm.h                            | 22 +++++++
>  kernel/kexec_core.c                           |  2 +-
>  mm/dmapool.c                                  |  2 +-
>  mm/page_alloc.c                               | 63 ++++++++++++++++---
>  mm/slab.c                                     | 16 ++++-
>  mm/slab.h                                     | 19 ++++++
>  mm/slub.c                                     | 33 ++++++++--
>  net/core/sock.c                               |  2 +-
>  security/Kconfig.hardening                    | 29 +++++++++
>  11 files changed, 180 insertions(+), 19 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 138f6664b2e2..84ee1121a2b9 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -1673,6 +1673,15 @@
>  
>  	initrd=		[BOOT] Specify the location of the initial ramdisk
>  
> +	init_on_alloc=	[MM] Fill newly allocated pages and heap objects with
> +			zeroes.
> +			Format: 0 | 1
> +			Default set by CONFIG_INIT_ON_ALLOC_DEFAULT_ON.
> +
> +	init_on_free=	[MM] Fill freed pages and heap objects with zeroes.
> +			Format: 0 | 1
> +			Default set by CONFIG_INIT_ON_FREE_DEFAULT_ON.
> +
>  	init_pkru=	[x86] Specify the default memory protection keys rights
>  			register contents for all processes.  0x55555554 by
>  			default (disallow access to all but pkey 0).  Can
> diff --git a/drivers/infiniband/core/uverbs_ioctl.c b/drivers/infiniband/core/uverbs_ioctl.c
> index 829b0c6944d8..61758201d9b2 100644
> --- a/drivers/infiniband/core/uverbs_ioctl.c
> +++ b/drivers/infiniband/core/uverbs_ioctl.c
> @@ -127,7 +127,7 @@ __malloc void *_uverbs_alloc(struct uverbs_attr_bundle *bundle, size_t size,
>  	res = (void *)pbundle->internal_buffer + pbundle->internal_used;
>  	pbundle->internal_used =
>  		ALIGN(new_used, sizeof(*pbundle->internal_buffer));
> -	if (flags & __GFP_ZERO)
> +	if (want_init_on_alloc(flags))
>  		memset(res, 0, size);
>  	return res;
>  }
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 0e8834ac32b7..7733a341c0c4 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2685,6 +2685,28 @@ static inline void kernel_poison_pages(struct page *page, int numpages,
>  					int enable) { }
>  #endif
>  
> +#ifdef CONFIG_INIT_ON_ALLOC_DEFAULT_ON
> +DECLARE_STATIC_KEY_TRUE(init_on_alloc);
> +#else
> +DECLARE_STATIC_KEY_FALSE(init_on_alloc);
> +#endif
> +static inline bool want_init_on_alloc(gfp_t flags)
> +{
> +	if (static_branch_unlikely(&init_on_alloc))
> +		return true;
> +	return flags & __GFP_ZERO;
> +}
> +
> +#ifdef CONFIG_INIT_ON_FREE_DEFAULT_ON
> +DECLARE_STATIC_KEY_TRUE(init_on_free);
> +#else
> +DECLARE_STATIC_KEY_FALSE(init_on_free);
> +#endif
> +static inline bool want_init_on_free(void)
> +{
> +	return static_branch_unlikely(&init_on_free);
> +}
> +
>  extern bool _debug_pagealloc_enabled;
>  
>  static inline bool debug_pagealloc_enabled(void)
> diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> index fd5c95ff9251..2f75dd0d0d81 100644
> --- a/kernel/kexec_core.c
> +++ b/kernel/kexec_core.c
> @@ -315,7 +315,7 @@ static struct page *kimage_alloc_pages(gfp_t gfp_mask, unsigned int order)
>  		arch_kexec_post_alloc_pages(page_address(pages), count,
>  					    gfp_mask);
>  
> -		if (gfp_mask & __GFP_ZERO)
> +		if (want_init_on_alloc(gfp_mask))
>  			for (i = 0; i < count; i++)
>  				clear_highpage(pages + i);
>  	}
> diff --git a/mm/dmapool.c b/mm/dmapool.c
> index 76a160083506..493d151067cb 100644
> --- a/mm/dmapool.c
> +++ b/mm/dmapool.c
> @@ -381,7 +381,7 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
>  #endif
>  	spin_unlock_irqrestore(&pool->lock, flags);
>  
> -	if (mem_flags & __GFP_ZERO)
> +	if (want_init_on_alloc(mem_flags))
>  		memset(retval, 0, pool->size);
>  
>  	return retval;
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index d66bc8abe0af..50a3b104a491 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -136,6 +136,48 @@ unsigned long totalcma_pages __read_mostly;
>  
>  int percpu_pagelist_fraction;
>  gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
> +#ifdef CONFIG_INIT_ON_ALLOC_DEFAULT_ON
> +DEFINE_STATIC_KEY_TRUE(init_on_alloc);
> +#else
> +DEFINE_STATIC_KEY_FALSE(init_on_alloc);
> +#endif
> +#ifdef CONFIG_INIT_ON_FREE_DEFAULT_ON
> +DEFINE_STATIC_KEY_TRUE(init_on_free);
> +#else
> +DEFINE_STATIC_KEY_FALSE(init_on_free);
> +#endif
> +
> +static int __init early_init_on_alloc(char *buf)
> +{
> +	int ret;
> +	bool bool_result;
> +
> +	if (!buf)
> +		return -EINVAL;
> +	ret = kstrtobool(buf, &bool_result);
> +	if (bool_result)
> +		static_branch_enable(&init_on_alloc);
> +	else
> +		static_branch_disable(&init_on_alloc);
> +	return ret;
> +}
> +early_param("init_on_alloc", early_init_on_alloc);
> +
> +static int __init early_init_on_free(char *buf)
> +{
> +	int ret;
> +	bool bool_result;
> +
> +	if (!buf)
> +		return -EINVAL;
> +	ret = kstrtobool(buf, &bool_result);
> +	if (bool_result)
> +		static_branch_enable(&init_on_free);
> +	else
> +		static_branch_disable(&init_on_free);
> +	return ret;
> +}
> +early_param("init_on_free", early_init_on_free);
>  
>  /*
>   * A cached value of the page's pageblock's migratetype, used when the page is
> @@ -1090,6 +1132,14 @@ static int free_tail_pages_check(struct page *head_page, struct page *page)
>  	return ret;
>  }
>  
> +static void kernel_init_free_pages(struct page *page, int numpages)
> +{
> +	int i;
> +
> +	for (i = 0; i < numpages; i++)
> +		clear_highpage(page + i);
> +}
> +
>  static __always_inline bool free_pages_prepare(struct page *page,
>  					unsigned int order, bool check_free)
>  {
> @@ -1142,6 +1192,8 @@ static __always_inline bool free_pages_prepare(struct page *page,
>  	}
>  	arch_free_page(page, order);
>  	kernel_poison_pages(page, 1 << order, 0);
> +	if (want_init_on_free())
> +		kernel_init_free_pages(page, 1 << order);
>  	if (debug_pagealloc_enabled())
>  		kernel_map_pages(page, 1 << order, 0);
>  
> @@ -2020,8 +2072,8 @@ static inline int check_new_page(struct page *page)
>  
>  static inline bool free_pages_prezeroed(void)
>  {
> -	return IS_ENABLED(CONFIG_PAGE_POISONING_ZERO) &&
> -		page_poisoning_enabled();
> +	return (IS_ENABLED(CONFIG_PAGE_POISONING_ZERO) &&
> +		page_poisoning_enabled()) || want_init_on_free();
>  }
>  
>  #ifdef CONFIG_DEBUG_VM
> @@ -2075,13 +2127,10 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
>  static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
>  							unsigned int alloc_flags)
>  {
> -	int i;
> -
>  	post_alloc_hook(page, order, gfp_flags);
>  
> -	if (!free_pages_prezeroed() && (gfp_flags & __GFP_ZERO))
> -		for (i = 0; i < (1 << order); i++)
> -			clear_highpage(page + i);
> +	if (!free_pages_prezeroed() && want_init_on_alloc(gfp_flags))
> +		kernel_init_free_pages(page, 1 << order);
>  
>  	if (order && (gfp_flags & __GFP_COMP))
>  		prep_compound_page(page, order);
> diff --git a/mm/slab.c b/mm/slab.c
> index f7117ad9b3a3..98a89d7c922d 100644
> --- a/mm/slab.c
> +++ b/mm/slab.c
> @@ -1830,6 +1830,14 @@ static bool set_objfreelist_slab_cache(struct kmem_cache *cachep,
>  
>  	cachep->num = 0;
>  
> +	/*
> +	 * If slab auto-initialization on free is enabled, store the freelist
> +	 * off-slab, so that its contents don't end up in one of the allocated
> +	 * objects.
> +	 */
> +	if (unlikely(slab_want_init_on_free(cachep)))
> +		return false;
> +
>  	if (cachep->ctor || flags & SLAB_TYPESAFE_BY_RCU)
>  		return false;
>  
> @@ -3263,7 +3271,7 @@ slab_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
>  	local_irq_restore(save_flags);
>  	ptr = cache_alloc_debugcheck_after(cachep, flags, ptr, caller);
>  
> -	if (unlikely(flags & __GFP_ZERO) && ptr)
> +	if (unlikely(slab_want_init_on_alloc(flags, cachep)) && ptr)
>  		memset(ptr, 0, cachep->object_size);
>  
>  	slab_post_alloc_hook(cachep, flags, 1, &ptr);
> @@ -3320,7 +3328,7 @@ slab_alloc(struct kmem_cache *cachep, gfp_t flags, unsigned long caller)
>  	objp = cache_alloc_debugcheck_after(cachep, flags, objp, caller);
>  	prefetchw(objp);
>  
> -	if (unlikely(flags & __GFP_ZERO) && objp)
> +	if (unlikely(slab_want_init_on_alloc(flags, cachep)) && objp)
>  		memset(objp, 0, cachep->object_size);
>  
>  	slab_post_alloc_hook(cachep, flags, 1, &objp);
> @@ -3441,6 +3449,8 @@ void ___cache_free(struct kmem_cache *cachep, void *objp,
>  	struct array_cache *ac = cpu_cache_get(cachep);
>  
>  	check_irq_off();
> +	if (unlikely(slab_want_init_on_free(cachep)))
> +		memset(objp, 0, cachep->object_size);
>  	kmemleak_free_recursive(objp, cachep->flags);
>  	objp = cache_free_debugcheck(cachep, objp, caller);
>  
> @@ -3528,7 +3538,7 @@ int kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
>  	cache_alloc_debugcheck_after_bulk(s, flags, size, p, _RET_IP_);
>  
>  	/* Clear memory outside IRQ disabled section */
> -	if (unlikely(flags & __GFP_ZERO))
> +	if (unlikely(slab_want_init_on_alloc(flags, s)))
>  		for (i = 0; i < size; i++)
>  			memset(p[i], 0, s->object_size);
>  
> diff --git a/mm/slab.h b/mm/slab.h
> index 43ac818b8592..31032d488b29 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -524,4 +524,23 @@ static inline int cache_random_seq_create(struct kmem_cache *cachep,
>  static inline void cache_random_seq_destroy(struct kmem_cache *cachep) { }
>  #endif /* CONFIG_SLAB_FREELIST_RANDOM */
>  
> +static inline bool slab_want_init_on_alloc(gfp_t flags, struct kmem_cache *c)
> +{
> +	if (static_branch_unlikely(&init_on_alloc)) {
> +		if (c->ctor)
> +			return false;
> +		if (c->flags & SLAB_TYPESAFE_BY_RCU)
> +			return flags & __GFP_ZERO;
> +		return true;
> +	}
> +	return flags & __GFP_ZERO;
> +}
> +
> +static inline bool slab_want_init_on_free(struct kmem_cache *c)
> +{
> +	if (static_branch_unlikely(&init_on_free))
> +		return !(c->ctor || (c->flags & SLAB_TYPESAFE_BY_RCU));
> +	return false;
> +}
> +
>  #endif /* MM_SLAB_H */
> diff --git a/mm/slub.c b/mm/slub.c
> index cd04dbd2b5d0..9c4a8b9a955c 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1279,6 +1279,12 @@ static int __init setup_slub_debug(char *str)
>  	if (*str == ',')
>  		slub_debug_slabs = str + 1;
>  out:
> +	if ((static_branch_unlikely(&init_on_alloc) ||
> +	     static_branch_unlikely(&init_on_free)) &&
> +	    (slub_debug & SLAB_POISON)) {
> +		pr_warn("disabling SLAB_POISON: can't be used together with memory auto-initialization\n");
> +		slub_debug &= ~SLAB_POISON;
> +	}
>  	return 1;
>  }
>  
> @@ -1424,6 +1430,19 @@ static __always_inline bool slab_free_hook(struct kmem_cache *s, void *x)
>  static inline bool slab_free_freelist_hook(struct kmem_cache *s,
>  					   void **head, void **tail)
>  {
> +
> +	void *object;
> +	void *next = *head;
> +	void *old_tail = *tail ? *tail : *head;
> +
> +	if (slab_want_init_on_free(s))
> +		do {
> +			object = next;
> +			next = get_freepointer(s, object);
> +			memset(object, 0, s->size);
> +			set_freepointer(s, object, next);
> +		} while (object != old_tail);
> +
>  /*
>   * Compiler cannot detect this function can be removed if slab_free_hook()
>   * evaluates to nothing.  Thus, catch all relevant config debug options here.
> @@ -1433,9 +1452,7 @@ static inline bool slab_free_freelist_hook(struct kmem_cache *s,
>  	defined(CONFIG_DEBUG_OBJECTS_FREE) ||	\
>  	defined(CONFIG_KASAN)
>  
> -	void *object;
> -	void *next = *head;
> -	void *old_tail = *tail ? *tail : *head;
> +	next = *head;
>  
>  	/* Head and tail of the reconstructed freelist */
>  	*head = NULL;
> @@ -2741,8 +2758,14 @@ static __always_inline void *slab_alloc_node(struct kmem_cache *s,
>  		prefetch_freepointer(s, next_object);
>  		stat(s, ALLOC_FASTPATH);
>  	}
> +	/*
> +	 * If the object has been wiped upon free, make sure it's fully
> +	 * initialized by zeroing out freelist pointer.
> +	 */
> +	if (unlikely(slab_want_init_on_free(s)) && object)
> +		*(void **)object = NULL;
>  
> -	if (unlikely(gfpflags & __GFP_ZERO) && object)
> +	if (unlikely(slab_want_init_on_alloc(gfpflags, s)) && object)
>  		memset(object, 0, s->object_size);
>  
>  	slab_post_alloc_hook(s, gfpflags, 1, &object);
> @@ -3163,7 +3186,7 @@ int kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
>  	local_irq_enable();
>  
>  	/* Clear memory outside IRQ disabled fastpath loop */
> -	if (unlikely(flags & __GFP_ZERO)) {
> +	if (unlikely(slab_want_init_on_alloc(flags, s))) {
>  		int j;
>  
>  		for (j = 0; j < i; j++)
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 75b1c950b49f..9ceb90c875bc 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1602,7 +1602,7 @@ static struct sock *sk_prot_alloc(struct proto *prot, gfp_t priority,
>  		sk = kmem_cache_alloc(slab, priority & ~__GFP_ZERO);
>  		if (!sk)
>  			return sk;
> -		if (priority & __GFP_ZERO)
> +		if (want_init_on_alloc(priority))
>  			sk_prot_clear_nulls(sk, prot->obj_size);
>  	} else
>  		sk = kmalloc(prot->obj_size, priority);
> diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
> index c6cb2d9b2905..a1ffe2eb4d5f 100644
> --- a/security/Kconfig.hardening
> +++ b/security/Kconfig.hardening
> @@ -160,6 +160,35 @@ config STACKLEAK_RUNTIME_DISABLE
>  	  runtime to control kernel stack erasing for kernels built with
>  	  CONFIG_GCC_PLUGIN_STACKLEAK.
>  
> +config INIT_ON_ALLOC_DEFAULT_ON
> +	bool "Enable heap memory zeroing on allocation by default"
> +	help
> +	  This has the effect of setting "init_on_alloc=1" on the kernel
> +	  command line. This can be disabled with "init_on_alloc=0".
> +	  When "init_on_alloc" is enabled, all page allocator and slab
> +	  allocator memory will be zeroed when allocated, eliminating
> +	  many kinds of "uninitialized heap memory" flaws, especially
> +	  heap content exposures. The performance impact varies by
> +	  workload, but most cases see <1% impact. Some synthetic
> +	  workloads have measured as high as 7%.
> +
> +config INIT_ON_FREE_DEFAULT_ON
> +	bool "Enable heap memory zeroing on free by default"
> +	help
> +	  This has the effect of setting "init_on_free=1" on the kernel
> +	  command line. This can be disabled with "init_on_free=0".
> +	  Similar to "init_on_alloc", when "init_on_free" is enabled,
> +	  all page allocator and slab allocator memory will be zeroed
> +	  when freed, eliminating many kinds of "uninitialized heap memory"
> +	  flaws, especially heap content exposures. The primary difference
> +	  with "init_on_free" is that data lifetime in memory is reduced,
> +	  as anything freed is wiped immediately, making live forensics or
> +	  cold boot memory attacks unable to recover freed memory contents.
> +	  The performance impact varies by workload, but is more expensive
> +	  than "init_on_alloc" due to the negative cache effects of
> +	  touching "cold" memory areas. Most cases see 3-5% impact. Some
> +	  synthetic workloads have measured as high as 8%.
> +
>  endmenu
>  
>  endmenu
> -- 
> 2.22.0.rc1.311.g5d7573a151-goog
> 

-- 
Kees Cook
