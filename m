Return-Path: <kernel-hardening-return-15903-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B206F1804A
	for <lists+kernel-hardening@lfdr.de>; Wed,  8 May 2019 21:15:01 +0200 (CEST)
Received: (qmail 9595 invoked by uid 550); 8 May 2019 19:14:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9577 invoked from network); 8 May 2019 19:14:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9qI7nQdd3bNYCa2qF4UH/4IqrrO0K8+DgZr0J5nYZ54=;
        b=CFwO3s1B4b6gP84OVgCdY0F8XJ7Y2NgQn0S0V9cEflkmltxNycTIalnzb+5p+pWV3J
         45bh/SDBPLW0AQ3qJzdK4EptfEdJuqhNSAwQcT9ShwAhyA9io4vJn45B57823OdiUHhi
         v9viJPqnmNK011qboLI/zS/IJ7LA/BE7RzBm0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9qI7nQdd3bNYCa2qF4UH/4IqrrO0K8+DgZr0J5nYZ54=;
        b=mlBnFq9X5ZJGh5A2WGXQeV1k5K+n35RCmfSQNArp+mIrO6/OzpFRly9gDTsuAmLQf2
         GOKAcvVPjhYQ/hfSH6hrfKpYo2jmWWT6hZiqVbdR5G7q5ZsSCzOGQ++ucpzUPZBdYOvx
         d1pCAUk/9EM4pHkXDvnl9tKsy9Q+iol7Yx0o+g6F0IS7pdfks3WEdHqkakOZSZOXYkj0
         0Q+sN/OM2P0J9BoDBuFY3aVRw9QNDmyyqFsfVEYWMy46XMiEIYsjxdVBytLGiNMlZRnx
         GlS2q/xizbr3VKhVJdS9BiDGXhZW4j+CFEh5hq5SG6h1B8KMPMpdtmPi/ca8Yba8So8R
         +EKw==
X-Gm-Message-State: APjAAAVBhQT5nv22dmZo0IFYkOf4JLb5H0zhcOL8mx/O0e7dP3+RfcT6
	2aWHMDYnH+J8kjusX8HHWt1uVejvXXU=
X-Google-Smtp-Source: APXvYqyHladJ7OJtKbxLHMVuSsHStO5JDmSImS8We4OXFkjUsjmZNk2qp3ao5mwiyFLs19nHJoZ3Tg==
X-Received: by 2002:ab0:1e2:: with SMTP id 89mr21441822ual.0.1557342883409;
        Wed, 08 May 2019 12:14:43 -0700 (PDT)
X-Received: by 2002:a1f:3804:: with SMTP id f4mr5366867vka.4.1557342514950;
 Wed, 08 May 2019 12:08:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190508153736.256401-1-glider@google.com> <20190508153736.256401-4-glider@google.com>
In-Reply-To: <20190508153736.256401-4-glider@google.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 8 May 2019 12:08:23 -0700
X-Gmail-Original-Message-ID: <CAGXu5jJS=KgLwetdmDAUq9+KhUFTd=jnCES3BZJm+qBwUBmLjQ@mail.gmail.com>
Message-ID: <CAGXu5jJS=KgLwetdmDAUq9+KhUFTd=jnCES3BZJm+qBwUBmLjQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] gfp: mm: introduce __GFP_NOINIT
To: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Linux-MM <linux-mm@kvack.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, 
	Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, May 8, 2019 at 8:38 AM Alexander Potapenko <glider@google.com> wrote:
> When passed to an allocator (either pagealloc or SL[AOU]B), __GFP_NOINIT
> tells it to not initialize the requested memory if the init_on_alloc
> boot option is enabled. This can be useful in the cases newly allocated
> memory is going to be initialized by the caller right away.
>
> __GFP_NOINIT doesn't affect init_on_free behavior, except for SLOB,
> where init_on_free implies init_on_alloc.
>
> __GFP_NOINIT basically defeats the hardening against information leaks
> provided by init_on_alloc, so one should use it with caution.
>
> This patch also adds __GFP_NOINIT to alloc_pages() calls in SL[AOU]B.
> Doing so is safe, because the heap allocators initialize the pages they
> receive before passing memory to the callers.
>
> Slowdown for the initialization features compared to init_on_free=0,
> init_on_alloc=0:
>
> hackbench, init_on_free=1:  +6.84% sys time (st.err 0.74%)
> hackbench, init_on_alloc=1: +7.25% sys time (st.err 0.72%)
>
> Linux build with -j12, init_on_free=1:  +8.52% wall time (st.err 0.42%)
> Linux build with -j12, init_on_free=1:  +24.31% sys time (st.err 0.47%)
> Linux build with -j12, init_on_alloc=1: -0.16% wall time (st.err 0.40%)
> Linux build with -j12, init_on_alloc=1: +1.24% sys time (st.err 0.39%)
>
> The slowdown for init_on_free=0, init_on_alloc=0 compared to the
> baseline is within the standard error.
>
> Signed-off-by: Alexander Potapenko <glider@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> Cc: James Morris <jmorris@namei.org>
> Cc: "Serge E. Hallyn" <serge@hallyn.com>
> Cc: Nick Desaulniers <ndesaulniers@google.com>
> Cc: Kostya Serebryany <kcc@google.com>
> Cc: Dmitry Vyukov <dvyukov@google.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Sandeep Patil <sspatil@android.com>
> Cc: Laura Abbott <labbott@redhat.com>
> Cc: Randy Dunlap <rdunlap@infradead.org>
> Cc: Jann Horn <jannh@google.com>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Cc: linux-mm@kvack.org
> Cc: linux-security-module@vger.kernel.org
> Cc: kernel-hardening@lists.openwall.com
> ---
>  include/linux/gfp.h | 6 +++++-
>  include/linux/mm.h  | 2 +-
>  kernel/kexec_core.c | 2 +-
>  mm/slab.c           | 2 +-
>  mm/slob.c           | 3 ++-
>  mm/slub.c           | 1 +
>  6 files changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index fdab7de7490d..66d7f5604fe2 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -44,6 +44,7 @@ struct vm_area_struct;
>  #else
>  #define ___GFP_NOLOCKDEP       0
>  #endif
> +#define ___GFP_NOINIT          0x1000000u

I mentioned this in the other patch, but I think this needs to be
moved ahead of GFP_NOLOCKDEP and adjust the values for GFP_NOLOCKDEP
and to leave the IS_ENABLED() test in __GFP_BITS_SHIFT alone.

>  /* If the above are modified, __GFP_BITS_SHIFT may need updating */
>
>  /*
> @@ -208,16 +209,19 @@ struct vm_area_struct;
>   * %__GFP_COMP address compound page metadata.
>   *
>   * %__GFP_ZERO returns a zeroed page on success.
> + *
> + * %__GFP_NOINIT requests non-initialized memory from the underlying allocator.
>   */
>  #define __GFP_NOWARN   ((__force gfp_t)___GFP_NOWARN)
>  #define __GFP_COMP     ((__force gfp_t)___GFP_COMP)
>  #define __GFP_ZERO     ((__force gfp_t)___GFP_ZERO)
> +#define __GFP_NOINIT   ((__force gfp_t)___GFP_NOINIT)
>
>  /* Disable lockdep for GFP context tracking */
>  #define __GFP_NOLOCKDEP ((__force gfp_t)___GFP_NOLOCKDEP)
>
>  /* Room for N __GFP_FOO bits */
> -#define __GFP_BITS_SHIFT (23 + IS_ENABLED(CONFIG_LOCKDEP))
> +#define __GFP_BITS_SHIFT (25)

AIUI, this will break non-CONFIG_LOCKDEP kernels: it should just be:

-#define __GFP_BITS_SHIFT (23 + IS_ENABLED(CONFIG_LOCKDEP))
+#define __GFP_BITS_SHIFT (24 + IS_ENABLED(CONFIG_LOCKDEP))

>  #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
>
>  /**
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index ee1a1092679c..8ab152750eb4 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2618,7 +2618,7 @@ DECLARE_STATIC_KEY_FALSE(init_on_alloc);
>  static inline bool want_init_on_alloc(gfp_t flags)
>  {
>         if (static_branch_unlikely(&init_on_alloc))
> -               return true;
> +               return !(flags & __GFP_NOINIT);
>         return flags & __GFP_ZERO;

What do you think about renaming __GFP_NOINIT to __GFP_NO_AUTOINIT or something?

Regardless, yes, this is nice.

-- 
Kees Cook
