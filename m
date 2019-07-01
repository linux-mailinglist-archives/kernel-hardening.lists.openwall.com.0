Return-Path: <kernel-hardening-return-15936-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 62EFD21564
	for <lists+kernel-hardening@lfdr.de>; Fri, 17 May 2019 10:34:57 +0200 (CEST)
Received: (qmail 24090 invoked by uid 550); 17 May 2019 08:34:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24042 invoked from network); 17 May 2019 08:34:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IXFYp9dXdqOGmv2GZlMSV+ZWmX1vIYgX7tAhUZgFrwY=;
        b=UTu4YULsBx6VcP9vrIzXhWm8Y+uCliaAjCh+8sltKt7pcgDt89X+byBprR+w0oWZbk
         deRXHG5rJJPcFWTG21XQAz9q+pVUWgpPBtQH3FDC29d+IUGf1Bz6IdJJ2CaJJq8NGRdG
         pd7sytdMIQhbiFykg3BicDQ6d7Lxtj3N9wmelAiCFsp3EIrogWuATiiRsXVdQtFLc2id
         ZrZK8yhfe1Hw2A50tFa1/63RdDrt1r63SaCIKO2T2fsltnD3sStlFhhsX68SaZdKa8/A
         3M31PwIcH4mpKtYmeowBMWKe5emm5Bj8pgYyXIMwXrP/0w2/vTYCgdz6HLeX5VY1FmuJ
         j1+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IXFYp9dXdqOGmv2GZlMSV+ZWmX1vIYgX7tAhUZgFrwY=;
        b=YQpemCO6F4CJuyl7N3hirPFkSJSG9YbzzXqYicJZ3QIvOH3Ia7JejYRwV2jz981rdG
         QsldWWcr8LV9jHWU5VfZylJznCSIZFndN7fbVWKPSUZ5+fKTu/Dxk2wQtRYj/MT9QcRP
         HN7K2nawW85HWAsLeMfCiubmxcAmBywzv9QC4ZnMJD0gs1zvxcFXlbAhiJ4MpGLD7hB6
         NyNWhVeWUK1be+J4ZlLRjT4Td0DC+a04YE+KiipMAE/egzsPa6kzx4vaKV0Oj19NQSgt
         rAiWFVw1psjoelXEpP1oD5NjrJWjutXWcoyYYfaoD99uBcIP52ngKhhvHwXjPYCS2caG
         xeMw==
X-Gm-Message-State: APjAAAV9VJrK1BWXFcWbybxyFNkW5kj/a2pVHRmi23wjWSzK2uliOff4
	JZFTqW4w3c0hDxxRozsGPknWOU9x2rFd2kFHrdw+GQ==
X-Google-Smtp-Source: APXvYqyyuNywbu+7GesPli45mX02H2z5juDdbDIF7jowpZusr4p7m2UEfICnYf6Udf4bUxb0LNMiwSRXEQnzj4itKH8=
X-Received: by 2002:a1f:6011:: with SMTP id u17mr1711683vkb.64.1558082077400;
 Fri, 17 May 2019 01:34:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190514143537.10435-5-glider@google.com> <201905161746.16E885F@keescook>
In-Reply-To: <201905161746.16E885F@keescook>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 17 May 2019 10:34:26 +0200
Message-ID: <CAG_fn=W41zDac9DN9qVB_EwJG89f2cNBQYNyove4oO3dwe6d5Q@mail.gmail.com>
Subject: Re: [PATCH 5/4] mm: Introduce SLAB_NO_FREE_INIT and mark excluded caches
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, 
	Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 17, 2019 at 2:50 AM Kees Cook <keescook@chromium.org> wrote:
>
> In order to improve the init_on_free performance, some frequently
> freed caches with less sensitive contents can be excluded from the
> init_on_free behavior.
Did you see any notable performance improvement with this patch?
A similar one gave me only 1-2% on the parallel Linux build.
> This patch is modified from Brad Spengler/PaX Team's code in the
> last public patch of grsecurity/PaX based on my understanding of the
> code. Changes or omissions from the original code are mine and don't
> reflect the original grsecurity/PaX code.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  fs/buffer.c          | 2 +-
>  fs/dcache.c          | 3 ++-
>  include/linux/slab.h | 3 +++
>  kernel/fork.c        | 6 ++++--
>  mm/rmap.c            | 5 +++--
>  mm/slab.h            | 5 +++--
>  net/core/skbuff.c    | 6 ++++--
>  7 files changed, 20 insertions(+), 10 deletions(-)
>
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 0faa41fb4c88..04a85bd4cf2e 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -3457,7 +3457,7 @@ void __init buffer_init(void)
>         bh_cachep =3D kmem_cache_create("buffer_head",
>                         sizeof(struct buffer_head), 0,
>                                 (SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|
> -                               SLAB_MEM_SPREAD),
> +                               SLAB_MEM_SPREAD|SLAB_NO_FREE_INIT),
>                                 NULL);
>
>         /*
> diff --git a/fs/dcache.c b/fs/dcache.c
> index 8136bda27a1f..323b039accba 100644
> --- a/fs/dcache.c
> +++ b/fs/dcache.c
> @@ -3139,7 +3139,8 @@ void __init vfs_caches_init_early(void)
>  void __init vfs_caches_init(void)
>  {
>         names_cachep =3D kmem_cache_create_usercopy("names_cache", PATH_M=
AX, 0,
> -                       SLAB_HWCACHE_ALIGN|SLAB_PANIC, 0, PATH_MAX, NULL)=
;
> +                       SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_NO_FREE_INIT, =
0,
> +                       PATH_MAX, NULL);
>
>         dcache_init();
>         inode_init();
> diff --git a/include/linux/slab.h b/include/linux/slab.h
> index 9449b19c5f10..7eba9ad8830d 100644
> --- a/include/linux/slab.h
> +++ b/include/linux/slab.h
> @@ -92,6 +92,9 @@
>  /* Avoid kmemleak tracing */
>  #define SLAB_NOLEAKTRACE       ((slab_flags_t __force)0x00800000U)
>
> +/* Exclude slab from zero-on-free when init_on_free is enabled */
> +#define SLAB_NO_FREE_INIT      ((slab_flags_t __force)0x01000000U)
> +
>  /* Fault injection mark */
>  #ifdef CONFIG_FAILSLAB
>  # define SLAB_FAILSLAB         ((slab_flags_t __force)0x02000000U)
> diff --git a/kernel/fork.c b/kernel/fork.c
> index b4cba953040a..9868585f5520 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -2550,11 +2550,13 @@ void __init proc_caches_init(void)
>
>         mm_cachep =3D kmem_cache_create_usercopy("mm_struct",
>                         mm_size, ARCH_MIN_MMSTRUCT_ALIGN,
> -                       SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT,
> +                       SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT|
> +                       SLAB_NO_FREE_INIT,
>                         offsetof(struct mm_struct, saved_auxv),
>                         sizeof_field(struct mm_struct, saved_auxv),
>                         NULL);
> -       vm_area_cachep =3D KMEM_CACHE(vm_area_struct, SLAB_PANIC|SLAB_ACC=
OUNT);
> +       vm_area_cachep =3D KMEM_CACHE(vm_area_struct, SLAB_PANIC|SLAB_ACC=
OUNT|
> +                                                   SLAB_NO_FREE_INIT);
>         mmap_init();
>         nsproxy_cache_init();
>  }
> diff --git a/mm/rmap.c b/mm/rmap.c
> index e5dfe2ae6b0d..b7b8013eeb0a 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -432,10 +432,11 @@ static void anon_vma_ctor(void *data)
>  void __init anon_vma_init(void)
>  {
>         anon_vma_cachep =3D kmem_cache_create("anon_vma", sizeof(struct a=
non_vma),
> -                       0, SLAB_TYPESAFE_BY_RCU|SLAB_PANIC|SLAB_ACCOUNT,
> +                       0, SLAB_TYPESAFE_BY_RCU|SLAB_PANIC|SLAB_ACCOUNT|
> +                       SLAB_NO_FREE_INIT,
>                         anon_vma_ctor);
>         anon_vma_chain_cachep =3D KMEM_CACHE(anon_vma_chain,
> -                       SLAB_PANIC|SLAB_ACCOUNT);
> +                       SLAB_PANIC|SLAB_ACCOUNT|SLAB_NO_FREE_INIT);
>  }
>
>  /*
> diff --git a/mm/slab.h b/mm/slab.h
> index 24ae887359b8..f95b4f03c57b 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -129,7 +129,8 @@ static inline slab_flags_t kmem_cache_flags(unsigned =
int object_size,
>  /* Legal flag mask for kmem_cache_create(), for various configurations *=
/
>  #define SLAB_CORE_FLAGS (SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA | \
>                          SLAB_CACHE_DMA32 | SLAB_PANIC | \
> -                        SLAB_TYPESAFE_BY_RCU | SLAB_DEBUG_OBJECTS )
> +                        SLAB_TYPESAFE_BY_RCU | SLAB_DEBUG_OBJECTS | \
> +                        SLAB_NO_FREE_INIT)
>
>  #if defined(CONFIG_DEBUG_SLAB)
>  #define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER)
> @@ -535,7 +536,7 @@ static inline bool slab_want_init_on_alloc(gfp_t flag=
s, struct kmem_cache *c)
>  static inline bool slab_want_init_on_free(struct kmem_cache *c)
>  {
>         if (static_branch_unlikely(&init_on_free))
> -               return !(c->ctor);
> +               return !(c->ctor) && ((c->flags & SLAB_NO_FREE_INIT) =3D=
=3D 0);
>         else
>                 return false;
>  }
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index e89be6282693..b65902d2c042 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -3981,14 +3981,16 @@ void __init skb_init(void)
>         skbuff_head_cache =3D kmem_cache_create_usercopy("skbuff_head_cac=
he",
>                                               sizeof(struct sk_buff),
>                                               0,
> -                                             SLAB_HWCACHE_ALIGN|SLAB_PAN=
IC,
> +                                             SLAB_HWCACHE_ALIGN|SLAB_PAN=
IC|
> +                                             SLAB_NO_FREE_INIT,
>                                               offsetof(struct sk_buff, cb=
),
>                                               sizeof_field(struct sk_buff=
, cb),
>                                               NULL);
>         skbuff_fclone_cache =3D kmem_cache_create("skbuff_fclone_cache",
>                                                 sizeof(struct sk_buff_fcl=
ones),
>                                                 0,
> -                                               SLAB_HWCACHE_ALIGN|SLAB_P=
ANIC,
> +                                               SLAB_HWCACHE_ALIGN|SLAB_P=
ANIC|
> +                                               SLAB_NO_FREE_INIT,
>                                                 NULL);
>         skb_extensions_init();
>  }
> --
> 2.17.1
>
>
> --
> Kees Cook



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
