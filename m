Return-Path: <kernel-hardening-return-15924-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D97ED1CA9C
	for <lists+kernel-hardening@lfdr.de>; Tue, 14 May 2019 16:42:37 +0200 (CEST)
Received: (qmail 11913 invoked by uid 550); 14 May 2019 14:42:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 1885 invoked from network); 14 May 2019 14:36:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lbdUPdHa+bdM+dxU1m+K2QEpeUH2T4hzEiJEzMD7K4o=;
        b=HnfouE+vVHCSk/BQWNA2IoM8dz0DlJb1ySFeCJDuDts8JvsGv0c3ABDhxeZs5R1jQ5
         fL3ARiq3DAbXqQTqJfJuZH+qPM0Rlxs+eQXmzqAwtxAnJNYEaSrvHiNcxGnelj3HmfgX
         SSeCx+dAjpm4EnYIiFU/I55GSIaka0an9xHoe2esmSu0PB5SH7by0fAzZu2mm0Mixvs1
         WAgEPqulx2gTZH/2wtpBrBL+/yGwJvgPaaOhPEwkgOBXuSvFAk/GEC3w+P2hNj9dN06E
         3f5VELZcrJ00AMfyT4YjpAwlQDk+F+t0Pa9AiePOGat0x6TjdKPGnk4TKNYrnaALiQhA
         jI1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lbdUPdHa+bdM+dxU1m+K2QEpeUH2T4hzEiJEzMD7K4o=;
        b=WixYyEeyHqm0HPuHg3bm6biR+g4/JEhRxlRwRrjJ7NROrazEIFx5TI+DRgEX79gxgq
         2Ip0p/Kknqp3CYqsFUdEMCaB24KPOIxGiOxF8VCVsStl7EnkJpLfP1Y/aDCNtSPWhYuj
         or4QHY2FIM9mLt+afIKDllP4AEpF4/LobFq4ClfFM6tzAZDB0mf8vIxItRo0zhM8+wdi
         4q6aWfKYuOyNn7oF9sCv9i7f1UdweVAhb9rn3TWs/zBcjFevakw8wPAjQazeITOP3q4L
         AC0WGfq13/GxmyujcVgCz02Gs1kfctw9CrU9OpqOBgg4D315poXciRecMtxl0UojNkYb
         Dw1Q==
X-Gm-Message-State: APjAAAV7hSuz6xg4F0y8b2U+q5+kFovn/FC+awAJm/2IMcF5YzGYxFY7
	GDhc/CQU48FhbsAkuBA+90OTYIDB6yU=
X-Google-Smtp-Source: APXvYqzwuuntM7HozbX9bxO0OlitRtQOtjK1eJ98Ru/9/M+wLdZyTT23D/aLqfOSqP4W7vywT6UYFvkqKIU=
X-Received: by 2002:aca:5f84:: with SMTP id t126mr3137888oib.18.1557844567217;
 Tue, 14 May 2019 07:36:07 -0700 (PDT)
Date: Tue, 14 May 2019 16:35:36 +0200
In-Reply-To: <20190514143537.10435-1-glider@google.com>
Message-Id: <20190514143537.10435-4-glider@google.com>
Mime-Version: 1.0
References: <20190514143537.10435-1-glider@google.com>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH v2 3/4] gfp: mm: introduce __GFP_NO_AUTOINIT
From: Alexander Potapenko <glider@google.com>
To: akpm@linux-foundation.org, cl@linux.com, keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, 
	Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, Souptick Joarder <jrdr.linux@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

When passed to an allocator (either pagealloc or SL[AOU]B),
__GFP_NO_AUTOINIT tells it to not initialize the requested memory if the
init_on_alloc boot option is enabled. This can be useful in the cases
newly allocated memory is going to be initialized by the caller right
away.

__GFP_NO_AUTOINIT doesn't affect init_on_free behavior, except for SLOB,
where init_on_free implies init_on_alloc.

__GFP_NO_AUTOINIT basically defeats the hardening against information
leaks provided by init_on_alloc, so one should use it with caution.

This patch also adds __GFP_NO_AUTOINIT to alloc_pages() calls in SL[AOU]B.
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
To: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
To: Christoph Lameter <cl@linux.com>
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
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: linux-mm@kvack.org
Cc: linux-security-module@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com
---
 v2:
  - renamed __GFP_NOINIT to __GFP_NO_AUTOINIT, updated patch
    name/description
---
 include/linux/gfp.h | 13 +++++++++----
 include/linux/mm.h  |  2 +-
 kernel/kexec_core.c |  3 ++-
 mm/slab.c           |  2 +-
 mm/slob.c           |  3 ++-
 mm/slub.c           |  1 +
 6 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/include/linux/gfp.h b/include/linux/gfp.h
index fdab7de7490d..e1a83bd0ca67 100644
--- a/include/linux/gfp.h
+++ b/include/linux/gfp.h
@@ -44,6 +44,7 @@ struct vm_area_struct;
 #else
 #define ___GFP_NOLOCKDEP	0
 #endif
+#define ___GFP_NO_AUTOINIT	0x1000000u
 /* If the above are modified, __GFP_BITS_SHIFT may need updating */
 
 /*
@@ -208,16 +209,20 @@ struct vm_area_struct;
  * %__GFP_COMP address compound page metadata.
  *
  * %__GFP_ZERO returns a zeroed page on success.
+ *
+ * %__GFP_NO_AUTOINIT requests non-initialized memory from the underlying
+ * allocator.
  */
-#define __GFP_NOWARN	((__force gfp_t)___GFP_NOWARN)
-#define __GFP_COMP	((__force gfp_t)___GFP_COMP)
-#define __GFP_ZERO	((__force gfp_t)___GFP_ZERO)
+#define __GFP_NOWARN		((__force gfp_t)___GFP_NOWARN)
+#define __GFP_COMP		((__force gfp_t)___GFP_COMP)
+#define __GFP_ZERO		((__force gfp_t)___GFP_ZERO)
+#define __GFP_NO_AUTOINIT	((__force gfp_t)___GFP_NO_AUTOINIT)
 
 /* Disable lockdep for GFP context tracking */
 #define __GFP_NOLOCKDEP ((__force gfp_t)___GFP_NOLOCKDEP)
 
 /* Room for N __GFP_FOO bits */
-#define __GFP_BITS_SHIFT (23 + IS_ENABLED(CONFIG_LOCKDEP))
+#define __GFP_BITS_SHIFT (25)
 #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
 
 /**
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 18d96f1d07c5..ce6c63396002 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2618,7 +2618,7 @@ DECLARE_STATIC_KEY_FALSE(init_on_alloc);
 static inline bool want_init_on_alloc(gfp_t flags)
 {
 	if (static_branch_unlikely(&init_on_alloc))
-		return true;
+		return !(flags & __GFP_NO_AUTOINIT);
 	return flags & __GFP_ZERO;
 }
 
diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
index 2f75dd0d0d81..7fc37bacac79 100644
--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -302,7 +302,8 @@ static struct page *kimage_alloc_pages(gfp_t gfp_mask, unsigned int order)
 {
 	struct page *pages;
 
-	pages = alloc_pages(gfp_mask & ~__GFP_ZERO, order);
+	pages = alloc_pages((gfp_mask & ~__GFP_ZERO) | __GFP_NO_AUTOINIT,
+			    order);
 	if (pages) {
 		unsigned int count, i;
 
diff --git a/mm/slab.c b/mm/slab.c
index d00e9de26a45..1089461fc22b 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -1393,7 +1393,7 @@ static struct page *kmem_getpages(struct kmem_cache *cachep, gfp_t flags,
 	struct page *page;
 	int nr_pages;
 
-	flags |= cachep->allocflags;
+	flags |= (cachep->allocflags | __GFP_NO_AUTOINIT);
 
 	page = __alloc_pages_node(nodeid, flags, cachep->gfporder);
 	if (!page) {
diff --git a/mm/slob.c b/mm/slob.c
index 351d3dfee000..d505f36aa398 100644
--- a/mm/slob.c
+++ b/mm/slob.c
@@ -192,6 +192,7 @@ static void *slob_new_pages(gfp_t gfp, int order, int node)
 {
 	void *page;
 
+	gfp |= __GFP_NO_AUTOINIT;
 #ifdef CONFIG_NUMA
 	if (node != NUMA_NO_NODE)
 		page = __alloc_pages_node(node, gfp, order);
@@ -221,7 +222,7 @@ static inline bool slob_want_init_on_alloc(gfp_t flags, struct kmem_cache *c)
 {
 	if (static_branch_unlikely(&init_on_alloc) ||
 	    static_branch_unlikely(&init_on_free))
-		return c ? (!c->ctor) : true;
+		return c ? (!c->ctor) : !(flags & __GFP_NO_AUTOINIT);
 	return flags & __GFP_ZERO;
 }
 
diff --git a/mm/slub.c b/mm/slub.c
index 01424e910800..0aa306f5769a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1495,6 +1495,7 @@ static inline struct page *alloc_slab_page(struct kmem_cache *s,
 	struct page *page;
 	unsigned int order = oo_order(oo);
 
+	flags |= __GFP_NO_AUTOINIT;
 	if (node == NUMA_NO_NODE)
 		page = alloc_pages(flags, order);
 	else
-- 
2.21.0.1020.gf2820cf01a-goog

