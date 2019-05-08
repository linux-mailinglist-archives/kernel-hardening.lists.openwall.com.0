Return-Path: <kernel-hardening-return-15900-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4C78B17DF2
	for <lists+kernel-hardening@lfdr.de>; Wed,  8 May 2019 18:18:08 +0200 (CEST)
Received: (qmail 28622 invoked by uid 550); 8 May 2019 16:17:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 10120 invoked from network); 8 May 2019 15:38:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lo76tEV8/5tTBkkO8xlJz/8lajq8uCmmdOMOd2IZBb4=;
        b=vPEylMZXayPSZVpEaDJqWP9qm/OESynGMJRRV2MuSsH86lVqB1H02b/PiTIS+flJKP
         t6u5nGh7WqlGTmmiuLu9CAqTVfSYiEM6CS7PMQr8LiNxQWqIygR1z3f1vzfHvunG8MfG
         Nl+u+93U4iGK/9xuTGGr+SHMh4RT1GIIASx9sNQyJpVm3j1i3Pg4YdJN9WEBHKx81UNM
         y0n9VztOlXCZo0Mo0bd5i8gmrFPjvvepY5C/rjxdAqKOJ8m1Iw72t3OCjEbfehy4tigT
         H8V9L5vu7Y47nOBAZQpVNjPcmDubUS/YkZvy3vwto5ROsdazyfci1dI+FRklG39i5/QI
         U8zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lo76tEV8/5tTBkkO8xlJz/8lajq8uCmmdOMOd2IZBb4=;
        b=Ev1LyJ4aG4X3OyC10hKA4E3jDW0+aWzB5JTRnUnRZW8pL8fWAUvcU/2xMY3LwM7MuO
         a/U86/OMqGBSdTp8o0mIBNlBYlUFfKtGwYlC0VvqxD2lje+mE50WedbWLFB9Oj0Bo2F7
         3lmkUweg0OmuLL9kHiN/ndrvhTN9iq2RXGmrNfg/mMi8qNDMgvVOpyx3oXuRL+wSCvdb
         uglkoiOKmDzEwHCtZAqx/EgduPLFtCt9si64qXCOlpQKQy1cAMPSlpNssQaL0lR4CSzH
         qgf1ndG52Z7thvRQWp4bTszgpSct0lLXEPp3Z9vlJDIbJystX6P3z6fNCctlsYA47Ren
         W9+g==
X-Gm-Message-State: APjAAAXkBLm62+tmBaCAbp6cbKoRty6kmLS68lroP5vMFYu3HqnEPiZS
	hTHGLeisl8I9RWIn0FpZEK7AbpPeneU=
X-Google-Smtp-Source: APXvYqwNgpwHjUPfZi1Dbb0SZ7eXYtog/czzOSLoWn+D6mOOwqHmlQYuA0cyyWtpdJ//wXF2GWIvL/IEdeo=
X-Received: by 2002:a0c:c3d0:: with SMTP id p16mr31293733qvi.229.1557329902083;
 Wed, 08 May 2019 08:38:22 -0700 (PDT)
Date: Wed,  8 May 2019 17:37:35 +0200
In-Reply-To: <20190508153736.256401-1-glider@google.com>
Message-Id: <20190508153736.256401-4-glider@google.com>
Mime-Version: 1.0
References: <20190508153736.256401-1-glider@google.com>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH 3/4] gfp: mm: introduce __GFP_NOINIT
From: Alexander Potapenko <glider@google.com>
To: akpm@linux-foundation.org, cl@linux.com, keescook@chromium.org, 
	labbott@redhat.com
Cc: linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	kernel-hardening@lists.openwall.com, yamada.masahiro@socionext.com, 
	jmorris@namei.org, serge@hallyn.com, ndesaulniers@google.com, kcc@google.com, 
	dvyukov@google.com, sspatil@android.com, rdunlap@infradead.org, 
	jannh@google.com, mark.rutland@arm.com
Content-Type: text/plain; charset="UTF-8"

When passed to an allocator (either pagealloc or SL[AOU]B), __GFP_NOINIT
tells it to not initialize the requested memory if the init_on_alloc
boot option is enabled. This can be useful in the cases newly allocated
memory is going to be initialized by the caller right away.

__GFP_NOINIT doesn't affect init_on_free behavior, except for SLOB,
where init_on_free implies init_on_alloc.

__GFP_NOINIT basically defeats the hardening against information leaks
provided by init_on_alloc, so one should use it with caution.

This patch also adds __GFP_NOINIT to alloc_pages() calls in SL[AOU]B.
Doing so is safe, because the heap allocators initialize the pages they
receive before passing memory to the callers.

Slowdown for the initialization features compared to init_on_free=0,
init_on_alloc=0:

hackbench, init_on_free=1:  +6.84% sys time (st.err 0.74%)
hackbench, init_on_alloc=1: +7.25% sys time (st.err 0.72%)

Linux build with -j12, init_on_free=1:  +8.52% wall time (st.err 0.42%)
Linux build with -j12, init_on_free=1:  +24.31% sys time (st.err 0.47%)
Linux build with -j12, init_on_alloc=1: -0.16% wall time (st.err 0.40%)
Linux build with -j12, init_on_alloc=1: +1.24% sys time (st.err 0.39%)

The slowdown for init_on_free=0, init_on_alloc=0 compared to the
baseline is within the standard error.

Signed-off-by: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: James Morris <jmorris@namei.org>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Kostya Serebryany <kcc@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Sandeep Patil <sspatil@android.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Jann Horn <jannh@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-mm@kvack.org
Cc: linux-security-module@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com
---
 include/linux/gfp.h | 6 +++++-
 include/linux/mm.h  | 2 +-
 kernel/kexec_core.c | 2 +-
 mm/slab.c           | 2 +-
 mm/slob.c           | 3 ++-
 mm/slub.c           | 1 +
 6 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index fdab7de7490d..66d7f5604fe2 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -44,6 +44,7 @@ struct vm_area_struct;
 #else
 #define ___GFP_NOLOCKDEP	0
 #endif
+#define ___GFP_NOINIT		0x1000000u
 /* If the above are modified, __GFP_BITS_SHIFT may need updating */
 
 /*
@@ -208,16 +209,19 @@ struct vm_area_struct;
  * %__GFP_COMP address compound page metadata.
  *
  * %__GFP_ZERO returns a zeroed page on success.
+ *
+ * %__GFP_NOINIT requests non-initialized memory from the underlying allocator.
  */
 #define __GFP_NOWARN	((__force gfp_t)___GFP_NOWARN)
 #define __GFP_COMP	((__force gfp_t)___GFP_COMP)
 #define __GFP_ZERO	((__force gfp_t)___GFP_ZERO)
+#define __GFP_NOINIT	((__force gfp_t)___GFP_NOINIT)
 
 /* Disable lockdep for GFP context tracking */
 #define __GFP_NOLOCKDEP ((__force gfp_t)___GFP_NOLOCKDEP)
 
 /* Room for N __GFP_FOO bits */
-#define __GFP_BITS_SHIFT (23 + IS_ENABLED(CONFIG_LOCKDEP))
+#define __GFP_BITS_SHIFT (25)
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
 /**
diff --git a/include/linux/mm.h b/include/linux/mm.h
index ee1a1092679c..8ab152750eb4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2618,7 +2618,7 @@ DECLARE_STATIC_KEY_FALSE(init_on_alloc);
 static inline bool want_init_on_alloc(gfp_t flags)
 {
 	if (static_branch_unlikely(&init_on_alloc))
-		return true;
+		return !(flags & __GFP_NOINIT);
 	return flags & __GFP_ZERO;
 }
 
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index f19d1a91190b..e8ed6e3c6702 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -302,7 +302,7 @@ static struct page *kimage_alloc_pages(gfp_t gfp_mask, unsigned int order)
 {
 	struct page *pages;
 
-	pages = alloc_pages(gfp_mask & ~__GFP_ZERO, order);
+	pages = alloc_pages((gfp_mask & ~__GFP_ZERO) | __GFP_NOINIT, order);
 	if (pages) {
 		unsigned int count, i;
 
diff --git a/mm/slab.c b/mm/slab.c
index fc5b3b81db60..f18739559825 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1393,7 +1393,7 @@ static struct page *kmem_getpages(struct kmem_cache *cachep, gfp_t flags,
 	struct page *page;
 	int nr_pages;
 
-	flags |= cachep->allocflags;
+	flags |= (cachep->allocflags | __GFP_NOINIT);
 
 	page = __alloc_pages_node(nodeid, flags, cachep->gfporder);
 	if (!page) {
diff --git a/mm/slob.c b/mm/slob.c
index 351d3dfee000..5b3c40dbd3f2 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -192,6 +192,7 @@ static void *slob_new_pages(gfp_t gfp, int order, int node)
 {
 	void *page;
 
+	gfp |= __GFP_NOINIT;
 #ifdef CONFIG_NUMA
 	if (node != NUMA_NO_NODE)
 		page = __alloc_pages_node(node, gfp, order);
@@ -221,7 +222,7 @@ static inline bool slob_want_init_on_alloc(gfp_t flags, struct kmem_cache *c)
 {
 	if (static_branch_unlikely(&init_on_alloc) ||
 	    static_branch_unlikely(&init_on_free))
-		return c ? (!c->ctor) : true;
+		return c ? (!c->ctor) : !(flags & __GFP_NOINIT);
 	return flags & __GFP_ZERO;
 }
 
diff --git a/mm/slub.c b/mm/slub.c
index cc091424c593..8b61d244fdb4 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1504,6 +1504,7 @@ static inline struct page *alloc_slab_page(struct kmem_cache *s,
 	struct page *page;
 	unsigned int order = oo_order(oo);
 
+	flags |= __GFP_NOINIT;
 	if (node == NUMA_NO_NODE)
 		page = alloc_pages(flags, order);
 	else
-- 
2.21.0.1020.gf2820cf01a-goog

