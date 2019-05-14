Return-Path: <kernel-hardening-return-15922-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 80A3E1CA99
	for <lists+kernel-hardening@lfdr.de>; Tue, 14 May 2019 16:42:15 +0200 (CEST)
Received: (qmail 11446 invoked by uid 550); 14 May 2019 14:42:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 1762 invoked from network); 14 May 2019 14:36:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tNK6c3aJODeVfKVlftZ1eTaADkEG96XAn6GGaXTgxaQ=;
        b=vG9gQLI2lXywaOvrrIEFCVZp6zeKS60jUXH/kBcVGz4gs8DO2PORTBGYpvSQBqvwWR
         fkOlbwzJy7Z08kV3LwjO99kMveD5Cy5THpaGjt3sTwpiFXFLbrLVg2NXZqnaiLIZHpmP
         KPRuZezJaQjfA/N7+4Em7IwQZvb9JOV2QLIbopbM7qSGJn3hNYAdKygawWJx5fZIh9ev
         tj1lRwxVa5o88EmITP+jzWnzn0l5WpVlNZyyqCzVlUS4XaYk3YKUYDzrVooZSDo2eJyd
         tLomXqk1yF5oAyBZUbTqTkhIG7pivvHVNWMo6p+6mqi/s3UnN1UiBZlXO1VsyykVE08l
         V9HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tNK6c3aJODeVfKVlftZ1eTaADkEG96XAn6GGaXTgxaQ=;
        b=Rb2CpooN1rBL6POLDgPt2uYNGOdORAgc9tzE9pGcmJgT/24brBho7tTpmCR/7ev6pn
         azIAmTP0vsN19wEvQ+nLC/HPS8JLrqhvknjqkiVWa9x/FczbpbMMmvlAunGydI9z2ZGc
         JFKRvFJuaolf3WUaB3/BiGSWt1hibmlfwcG+DhSZIFKT0Xx5LFUvdunksh11t9kb045C
         Dr8d7hbazrawM/SLOincXtQ0gN4coHWghNJqGBAHRDC0YHlD4+olcGuQ2mxYoEiDOuQg
         QVBbwmaq7f2rtdRNwevU/oQpIQwTM8QUasNTdvCns62bLD2r1zdFr4XkNS2NV1vpALR7
         wT3A==
X-Gm-Message-State: APjAAAW++tezKr11vMZAqlYbb+Syy5myqqlPF5q1dc7rCeP+sf5+hgjy
	N8YxF1qWtJuW2LnQhGqI4FxrWTUygpk=
X-Google-Smtp-Source: APXvYqx0Gci0O8TuOUC0PcZn/6jZdfvXrJBwxOf4Cb5x2emHjiYnnBvX91urZmqQe0/D0DVQD0O/m9MyJnw=
X-Received: by 2002:a25:70c3:: with SMTP id l186mr17482948ybc.54.1557844558228;
 Tue, 14 May 2019 07:35:58 -0700 (PDT)
Date: Tue, 14 May 2019 16:35:34 +0200
In-Reply-To: <20190514143537.10435-1-glider@google.com>
Message-Id: <20190514143537.10435-2-glider@google.com>
Mime-Version: 1.0
References: <20190514143537.10435-1-glider@google.com>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH v2 1/4] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
From: Alexander Potapenko <glider@google.com>
To: akpm@linux-foundation.org, cl@linux.com, keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, 
	Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

The new options are needed to prevent possible information leaks and
make control-flow bugs that depend on uninitialized values more
deterministic.

init_on_alloc=1 makes the kernel initialize newly allocated pages and heap
objects with zeroes. Initialization is done at allocation time at the
places where checks for __GFP_ZERO are performed.

init_on_free=1 makes the kernel initialize freed pages and heap objects
with zeroes upon their deletion. This helps to ensure sensitive data
doesn't leak via use-after-free accesses.

Both init_on_alloc=1 and init_on_free=1 guarantee that the allocator
returns zeroed memory. The only exception is slab caches with
constructors. Those are never zero-initialized to preserve their semantics.

For SLOB allocator init_on_free=1 also implies init_on_alloc=1 behavior,
i.e. objects are zeroed at both allocation and deallocation time.
This is done because SLOB may otherwise return multiple freelist pointers
in the allocated object. For SLAB and SLUB enabling either init_on_alloc
or init_on_free leads to one-time initialization of the object.

Both init_on_alloc and init_on_free default to zero, but those defaults
can be overridden with CONFIG_INIT_ON_ALLOC_DEFAULT_ON and
CONFIG_INIT_ON_FREE_DEFAULT_ON.

Slowdown for the new features compared to init_on_free=0,
init_on_alloc=0:

hackbench, init_on_free=1:  +7.62% sys time (st.err 0.74%)
hackbench, init_on_alloc=1: +7.75% sys time (st.err 2.14%)

Linux build with -j12, init_on_free=1:  +8.38% wall time (st.err 0.39%)
Linux build with -j12, init_on_free=1:  +24.42% sys time (st.err 0.52%)
Linux build with -j12, init_on_alloc=1: -0.13% wall time (st.err 0.42%)
Linux build with -j12, init_on_alloc=1: +0.57% sys time (st.err 0.40%)

The slowdown for init_on_free=0, init_on_alloc=0 compared to the
baseline is within the standard error.

Signed-off-by: Alexander Potapenko <glider@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
To: Kees Cook <keescook@chromium.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Kostya Serebryany <kcc@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Sandeep Patil <sspatil@android.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Jann Horn <jannh@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-mm@kvack.org
Cc: linux-security-module@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com
---
 v2:
  - unconditionally initialize pages in kernel_init_free_pages()
  - comment from Randy Dunlap: drop 'default false' lines from Kconfig.hardening
---
 .../admin-guide/kernel-parameters.txt         |  8 +++
 drivers/infiniband/core/uverbs_ioctl.c        |  2 +-
 include/linux/mm.h                            | 22 ++++++
 kernel/kexec_core.c                           |  2 +-
 mm/dmapool.c                                  |  2 +-
 mm/page_alloc.c                               | 68 ++++++++++++++++---
 mm/slab.c                                     | 16 ++++-
 mm/slab.h                                     | 16 +++++
 mm/slob.c                                     | 22 +++++-
 mm/slub.c                                     | 27 ++++++--
 net/core/sock.c                               |  2 +-
 security/Kconfig.hardening                    | 14 ++++
 12 files changed, 178 insertions(+), 23 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 08df58805703..cece9a56ddb1 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -1673,6 +1673,14 @@
 
 	initrd=		[BOOT] Specify the location of the initial ramdisk
 
+	init_on_alloc=	[MM] Fill newly allocated pages and heap objects with
+			zeroes.
+			Format: 0 | 1
+			Default set by CONFIG_INIT_ON_ALLOC_DEFAULT_ON.
+	init_on_free=	[MM] Fill freed pages and heap objects with zeroes.
+			Format: 0 | 1
+			Default set by CONFIG_INIT_ON_FREE_DEFAULT_ON.
+
 	init_pkru=	[x86] Specify the default memory protection keys rights
 			register contents for all processes.  0x55555554 by
 			default (disallow access to all but pkey 0).  Can
diff --git a/drivers/infiniband/core/uverbs_ioctl.c b/drivers/infiniband/core/uverbs_ioctl.c
index 829b0c6944d8..61758201d9b2 100644
--- a/drivers/infiniband/core/uverbs_ioctl.c
+++ b/drivers/infiniband/core/uverbs_ioctl.c
@@ -127,7 +127,7 @@ __malloc void *_uverbs_alloc(struct uverbs_attr_bundle *bundle, size_t size,
 	res = (void *)pbundle->internal_buffer + pbundle->internal_used;
 	pbundle->internal_used =
 		ALIGN(new_used, sizeof(*pbundle->internal_buffer));
-	if (flags & __GFP_ZERO)
+	if (want_init_on_alloc(flags))
 		memset(res, 0, size);
 	return res;
 }
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 083d7b4863ed..18d96f1d07c5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2610,6 +2610,28 @@ static inline void kernel_poison_pages(struct page *page, int numpages,
 					int enable) { }
 #endif
 
+#ifdef CONFIG_INIT_ON_ALLOC_DEFAULT_ON
+DECLARE_STATIC_KEY_TRUE(init_on_alloc);
+#else
+DECLARE_STATIC_KEY_FALSE(init_on_alloc);
+#endif
+static inline bool want_init_on_alloc(gfp_t flags)
+{
+	if (static_branch_unlikely(&init_on_alloc))
+		return true;
+	return flags & __GFP_ZERO;
+}
+
+#ifdef CONFIG_INIT_ON_FREE_DEFAULT_ON
+DECLARE_STATIC_KEY_TRUE(init_on_free);
+#else
+DECLARE_STATIC_KEY_FALSE(init_on_free);
+#endif
+static inline bool want_init_on_free(void)
+{
+	return static_branch_unlikely(&init_on_free);
+}
+
 extern bool _debug_pagealloc_enabled;
 
 static inline bool debug_pagealloc_enabled(void)
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index fd5c95ff9251..2f75dd0d0d81 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -315,7 +315,7 @@ static struct page *kimage_alloc_pages(gfp_t gfp_mask, unsigned int order)
 		arch_kexec_post_alloc_pages(page_address(pages), count,
 					    gfp_mask);
 
-		if (gfp_mask & __GFP_ZERO)
+		if (want_init_on_alloc(gfp_mask))
 			for (i = 0; i < count; i++)
 				clear_highpage(pages + i);
 	}
diff --git a/mm/dmapool.c b/mm/dmapool.c
index 76a160083506..493d151067cb 100644
--- a/mm/dmapool.c
+++ b/mm/dmapool.c
@@ -381,7 +381,7 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t mem_flags,
 #endif
 	spin_unlock_irqrestore(&pool->lock, flags);
 
-	if (mem_flags & __GFP_ZERO)
+	if (want_init_on_alloc(mem_flags))
 		memset(retval, 0, pool->size);
 
 	return retval;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 59661106da16..463c681a3633 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -133,6 +133,48 @@ unsigned long totalcma_pages __read_mostly;
 
 int percpu_pagelist_fraction;
 gfp_t gfp_allowed_mask __read_mostly = GFP_BOOT_MASK;
+#ifdef CONFIG_INIT_ON_ALLOC_DEFAULT_ON
+DEFINE_STATIC_KEY_TRUE(init_on_alloc);
+#else
+DEFINE_STATIC_KEY_FALSE(init_on_alloc);
+#endif
+#ifdef CONFIG_INIT_ON_FREE_DEFAULT_ON
+DEFINE_STATIC_KEY_TRUE(init_on_free);
+#else
+DEFINE_STATIC_KEY_FALSE(init_on_free);
+#endif
+
+static int __init early_init_on_alloc(char *buf)
+{
+	int ret;
+	bool bool_result;
+
+	if (!buf)
+		return -EINVAL;
+	ret = kstrtobool(buf, &bool_result);
+	if (bool_result)
+		static_branch_enable(&init_on_alloc);
+	else
+		static_branch_disable(&init_on_alloc);
+	return ret;
+}
+early_param("init_on_alloc", early_init_on_alloc);
+
+static int __init early_init_on_free(char *buf)
+{
+	int ret;
+	bool bool_result;
+
+	if (!buf)
+		return -EINVAL;
+	ret = kstrtobool(buf, &bool_result);
+	if (bool_result)
+		static_branch_enable(&init_on_free);
+	else
+		static_branch_disable(&init_on_free);
+	return ret;
+}
+early_param("init_on_free", early_init_on_free);
 
 /*
  * A cached value of the page's pageblock's migratetype, used when the page is
@@ -1092,6 +1134,14 @@ static int free_tail_pages_check(struct page *head_page, struct page *page)
 	return ret;
 }
 
+static void kernel_init_free_pages(struct page *page, int numpages)
+{
+	int i;
+
+	for (i = 0; i < numpages; i++)
+		clear_highpage(page + i);
+}
+
 static __always_inline bool free_pages_prepare(struct page *page,
 					unsigned int order, bool check_free)
 {
@@ -1144,9 +1194,10 @@ static __always_inline bool free_pages_prepare(struct page *page,
 	}
 	arch_free_page(page, order);
 	kernel_poison_pages(page, 1 << order, 0);
+	if (want_init_on_free())
+		kernel_init_free_pages(page, 1 << order);
 	if (debug_pagealloc_enabled())
 		kernel_map_pages(page, 1 << order, 0);
-
 	kasan_free_nondeferred_pages(page, order);
 
 	return true;
@@ -1452,8 +1503,10 @@ meminit_pfn_in_nid(unsigned long pfn, int node,
 void __init memblock_free_pages(struct page *page, unsigned long pfn,
 							unsigned int order)
 {
-	if (early_page_uninitialised(pfn))
+	if (early_page_uninitialised(pfn)) {
+		kernel_init_free_pages(page, 1 << order);
 		return;
+	}
 	__free_pages_core(page, order);
 }
 
@@ -1971,8 +2024,8 @@ static inline int check_new_page(struct page *page)
 
 static inline bool free_pages_prezeroed(void)
 {
-	return IS_ENABLED(CONFIG_PAGE_POISONING_ZERO) &&
-		page_poisoning_enabled();
+	return (IS_ENABLED(CONFIG_PAGE_POISONING_ZERO) &&
+		page_poisoning_enabled()) || want_init_on_free();
 }
 
 #ifdef CONFIG_DEBUG_VM
@@ -2026,13 +2079,10 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
 static void prep_new_page(struct page *page, unsigned int order, gfp_t gfp_flags,
 							unsigned int alloc_flags)
 {
-	int i;
-
 	post_alloc_hook(page, order, gfp_flags);
 
-	if (!free_pages_prezeroed() && (gfp_flags & __GFP_ZERO))
-		for (i = 0; i < (1 << order); i++)
-			clear_highpage(page + i);
+	if (!free_pages_prezeroed() && want_init_on_alloc(gfp_flags))
+		kernel_init_free_pages(page, 1 << order);
 
 	if (order && (gfp_flags & __GFP_COMP))
 		prep_compound_page(page, order);
diff --git a/mm/slab.c b/mm/slab.c
index 284ab737faee..d00e9de26a45 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1855,6 +1855,14 @@ static bool set_objfreelist_slab_cache(struct kmem_cache *cachep,
 
 	cachep->num = 0;
 
+	/*
+	 * If slab auto-initialization on free is enabled, store the freelist
+	 * off-slab, so that its contents don't end up in one of the allocated
+	 * objects.
+	 */
+	if (unlikely(slab_want_init_on_free(cachep)))
+		return false;
+
 	if (cachep->ctor || flags & SLAB_TYPESAFE_BY_RCU)
 		return false;
 
@@ -3294,7 +3302,7 @@ slab_alloc_node(struct kmem_cache *cachep, gfp_t flags, int nodeid,
 	local_irq_restore(save_flags);
 	ptr = cache_alloc_debugcheck_after(cachep, flags, ptr, caller);
 
-	if (unlikely(flags & __GFP_ZERO) && ptr)
+	if (unlikely(slab_want_init_on_alloc(flags, cachep)) && ptr)
 		memset(ptr, 0, cachep->object_size);
 
 	slab_post_alloc_hook(cachep, flags, 1, &ptr);
@@ -3351,7 +3359,7 @@ slab_alloc(struct kmem_cache *cachep, gfp_t flags, unsigned long caller)
 	objp = cache_alloc_debugcheck_after(cachep, flags, objp, caller);
 	prefetchw(objp);
 
-	if (unlikely(flags & __GFP_ZERO) && objp)
+	if (unlikely(slab_want_init_on_alloc(flags, cachep)) && objp)
 		memset(objp, 0, cachep->object_size);
 
 	slab_post_alloc_hook(cachep, flags, 1, &objp);
@@ -3472,6 +3480,8 @@ void ___cache_free(struct kmem_cache *cachep, void *objp,
 	struct array_cache *ac = cpu_cache_get(cachep);
 
 	check_irq_off();
+	if (unlikely(slab_want_init_on_free(cachep)))
+		memset(objp, 0, cachep->object_size);
 	kmemleak_free_recursive(objp, cachep->flags);
 	objp = cache_free_debugcheck(cachep, objp, caller);
 
@@ -3559,7 +3569,7 @@ int kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
 	cache_alloc_debugcheck_after_bulk(s, flags, size, p, _RET_IP_);
 
 	/* Clear memory outside IRQ disabled section */
-	if (unlikely(flags & __GFP_ZERO))
+	if (unlikely(slab_want_init_on_alloc(flags, s)))
 		for (i = 0; i < size; i++)
 			memset(p[i], 0, s->object_size);
 
diff --git a/mm/slab.h b/mm/slab.h
index 43ac818b8592..24ae887359b8 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -524,4 +524,20 @@ static inline int cache_random_seq_create(struct kmem_cache *cachep,
 static inline void cache_random_seq_destroy(struct kmem_cache *cachep) { }
 #endif /* CONFIG_SLAB_FREELIST_RANDOM */
 
+static inline bool slab_want_init_on_alloc(gfp_t flags, struct kmem_cache *c)
+{
+	if (static_branch_unlikely(&init_on_alloc))
+		return !(c->ctor);
+	else
+		return flags & __GFP_ZERO;
+}
+
+static inline bool slab_want_init_on_free(struct kmem_cache *c)
+{
+	if (static_branch_unlikely(&init_on_free))
+		return !(c->ctor);
+	else
+		return false;
+}
+
 #endif /* MM_SLAB_H */
diff --git a/mm/slob.c b/mm/slob.c
index 307c2c9feb44..351d3dfee000 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -212,6 +212,19 @@ static void slob_free_pages(void *b, int order)
 	free_pages((unsigned long)b, order);
 }
 
+/*
+ * init_on_free=1 also implies initialization at allocation time.
+ * This is because newly allocated objects may contain freelist pointers
+ * somewhere in the middle.
+ */
+static inline bool slob_want_init_on_alloc(gfp_t flags, struct kmem_cache *c)
+{
+	if (static_branch_unlikely(&init_on_alloc) ||
+	    static_branch_unlikely(&init_on_free))
+		return c ? (!c->ctor) : true;
+	return flags & __GFP_ZERO;
+}
+
 /*
  * Allocate a slob block within a given slob_page sp.
  */
@@ -330,8 +343,6 @@ static void *slob_alloc(size_t size, gfp_t gfp, int align, int node)
 		BUG_ON(!b);
 		spin_unlock_irqrestore(&slob_lock, flags);
 	}
-	if (unlikely(gfp & __GFP_ZERO))
-		memset(b, 0, size);
 	return b;
 }
 
@@ -366,6 +377,9 @@ static void slob_free(void *block, int size)
 		return;
 	}
 
+	if (unlikely(want_init_on_free()))
+		memset(block, 0, size);
+
 	if (!slob_page_free(sp)) {
 		/* This slob page is about to become partially free. Easy! */
 		sp->units = units;
@@ -461,6 +475,8 @@ __do_kmalloc_node(size_t size, gfp_t gfp, int node, unsigned long caller)
 	}
 
 	kmemleak_alloc(ret, size, 1, gfp);
+	if (unlikely(slob_want_init_on_alloc(gfp, 0)))
+		memset(ret, 0, size);
 	return ret;
 }
 
@@ -559,6 +575,8 @@ static void *slob_alloc_node(struct kmem_cache *c, gfp_t flags, int node)
 		WARN_ON_ONCE(flags & __GFP_ZERO);
 		c->ctor(b);
 	}
+	if (unlikely(slob_want_init_on_alloc(flags, c)))
+		memset(b, 0, c->size);
 
 	kmemleak_alloc_recursive(b, c->size, 1, c->flags, flags);
 	return b;
diff --git a/mm/slub.c b/mm/slub.c
index 6b28cd2b5a58..01424e910800 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1423,6 +1423,19 @@ static __always_inline bool slab_free_hook(struct kmem_cache *s, void *x)
 static inline bool slab_free_freelist_hook(struct kmem_cache *s,
 					   void **head, void **tail)
 {
+
+	void *object;
+	void *next = *head;
+	void *old_tail = *tail ? *tail : *head;
+
+	if (slab_want_init_on_free(s))
+		do {
+			object = next;
+			next = get_freepointer(s, object);
+			memset(object, 0, s->size);
+			set_freepointer(s, object, next);
+		} while (object != old_tail);
+
 /*
  * Compiler cannot detect this function can be removed if slab_free_hook()
  * evaluates to nothing.  Thus, catch all relevant config debug options here.
@@ -1432,9 +1445,7 @@ static inline bool slab_free_freelist_hook(struct kmem_cache *s,
 	defined(CONFIG_DEBUG_OBJECTS_FREE) ||	\
 	defined(CONFIG_KASAN)
 
-	void *object;
-	void *next = *head;
-	void *old_tail = *tail ? *tail : *head;
+	next = *head;
 
 	/* Head and tail of the reconstructed freelist */
 	*head = NULL;
@@ -2740,8 +2751,14 @@ static __always_inline void *slab_alloc_node(struct kmem_cache *s,
 		prefetch_freepointer(s, next_object);
 		stat(s, ALLOC_FASTPATH);
 	}
+	/*
+	 * If the object has been wiped upon free, make sure it's fully
+	 * initialized by zeroing out freelist pointer.
+	 */
+	if (slab_want_init_on_free(s))
+		*(void **)object = 0;
 
-	if (unlikely(gfpflags & __GFP_ZERO) && object)
+	if (unlikely(slab_want_init_on_alloc(gfpflags, s)) && object)
 		memset(object, 0, s->object_size);
 
 	slab_post_alloc_hook(s, gfpflags, 1, &object);
@@ -3163,7 +3180,7 @@ int kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
 	local_irq_enable();
 
 	/* Clear memory outside IRQ disabled fastpath loop */
-	if (unlikely(flags & __GFP_ZERO)) {
+	if (unlikely(slab_want_init_on_alloc(flags, s))) {
 		int j;
 
 		for (j = 0; j < i; j++)
diff --git a/net/core/sock.c b/net/core/sock.c
index 75b1c950b49f..9ceb90c875bc 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -1602,7 +1602,7 @@ static struct sock *sk_prot_alloc(struct proto *prot, gfp_t priority,
 		sk = kmem_cache_alloc(slab, priority & ~__GFP_ZERO);
 		if (!sk)
 			return sk;
-		if (priority & __GFP_ZERO)
+		if (want_init_on_alloc(priority))
 			sk_prot_clear_nulls(sk, prot->obj_size);
 	} else
 		sk = kmalloc(prot->obj_size, priority);
diff --git a/security/Kconfig.hardening b/security/Kconfig.hardening
index 0a1d4ca314f4..87883e3e3c2a 100644
--- a/security/Kconfig.hardening
+++ b/security/Kconfig.hardening
@@ -159,6 +159,20 @@ config STACKLEAK_RUNTIME_DISABLE
 	  runtime to control kernel stack erasing for kernels built with
 	  CONFIG_GCC_PLUGIN_STACKLEAK.
 
+config INIT_ON_ALLOC_DEFAULT_ON
+	bool "Set init_on_alloc=1 by default"
+	help
+	  Enable init_on_alloc=1 by default, making the kernel initialize every
+	  page and heap allocation with zeroes.
+	  init_on_alloc can be overridden via command line.
+
+config INIT_ON_FREE_DEFAULT_ON
+	bool "Set init_on_free=1 by default"
+	help
+	  Enable init_on_free=1 by default, making the kernel initialize freed
+	  pages and slab memory with zeroes.
+	  init_on_free can be overridden via command line.
+
 endmenu
 
 endmenu
-- 
2.21.0.1020.gf2820cf01a-goog

