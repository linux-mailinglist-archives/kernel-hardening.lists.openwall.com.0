Return-Path: <kernel-hardening-return-15911-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 1172118A7F
	for <lists+kernel-hardening@lfdr.de>; Thu,  9 May 2019 15:23:59 +0200 (CEST)
Received: (qmail 17498 invoked by uid 550); 9 May 2019 13:23:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17477 invoked from network); 9 May 2019 13:23:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=sff58sBqd6I3jr2LoJpmtNzqy1jhnIaSBJFG4nsnerE=;
        b=B8KVmFpYir3rnGiAmtbgvsOw3dAWOQSkdZJUYG8fS5wXW80tGeFcMS4JftdHCYf7RR
         cDRIZtR8K5J268kAxu4OAWuxKySPy+9UpAcpWshQlpBVWX0GKbokVQ4WVwHnGohtrNM8
         6P+KeAUmebTGRqhnEjTmpruGfm4SKQJzZsEbArjpju6Sh9ejzvD67gSqXFNu/OpJko4u
         a96bv2j3YgkaJ+zcoJy6czXaap8XM7C9eHsCadPG208r6U1LH04GjvIarBzxyBpH6b00
         JagTxOBnoo0lssjXVRA3qvqhb2MOtjD4aZrbW0thhi1/ZJJlrN6xhujGn3AChqmUWtg7
         2ZZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=sff58sBqd6I3jr2LoJpmtNzqy1jhnIaSBJFG4nsnerE=;
        b=QtQ1gWMZwwSq8g5TynZsIl4kj0m03IrA1C2QdXgv103WuCSMWMtgtzUwLlsZC9hLkY
         AF2SNnZVJbxXqpkXuXvkE6eezWho5fyLrYJkMXO1Lq3WCCsRsVSnA97zCHPWozAkQKrg
         tTt9fXAT9IY36j7KrIK+Au1cCLHP4/p/8+vk/DkyWC2/zFEV3IcAvv/ITqUW6H0hK5ZB
         sbltkQHv6hCIX7maDy+4PCefOoeQ6w/RuVYbl8vSXuvN4nelV1VxTit4oaOChZCKqoJd
         aTx9Vyc38KAg6e2K4a2tusEfUV8EF0+oINdEwET8xHBTbHt18dBX9eQ5KfVJ6fnCO0Vm
         ZqoQ==
X-Gm-Message-State: APjAAAWxV3lMVCbSMHfnhqTsXhUqc9KR0vZsCLQT6FZN9r77BnjJftuA
	UCbAybzsHYr614AyfsxbDu2UYZ5SjviGbh5hxUBRjg==
X-Google-Smtp-Source: APXvYqwqW1Oquf8DAl74l6krQGTZ6Q5Lm130MtNSPSwLB1iofEZlAVrSXg8AEP36V6GqFHDuK+CN6QVFaD2IWmXNX+I=
X-Received: by 2002:a67:7241:: with SMTP id n62mr2198744vsc.217.1557408218840;
 Thu, 09 May 2019 06:23:38 -0700 (PDT)
MIME-Version: 1.0
References: <20190508153736.256401-1-glider@google.com> <20190508153736.256401-4-glider@google.com>
 <CAGXu5jJS=KgLwetdmDAUq9+KhUFTd=jnCES3BZJm+qBwUBmLjQ@mail.gmail.com>
In-Reply-To: <CAGXu5jJS=KgLwetdmDAUq9+KhUFTd=jnCES3BZJm+qBwUBmLjQ@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 9 May 2019 15:23:26 +0200
Message-ID: <CAG_fn=VbJXHsqAeBD+g6zJ8WVTko4Ev2xytXrcJ-ztEWm7kOOA@mail.gmail.com>
Subject: Re: [PATCH 3/4] gfp: mm: introduce __GFP_NOINIT
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, 
	Laura Abbott <labbott@redhat.com>, Linux-MM <linux-mm@kvack.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, 
	Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Kees Cook <keescook@chromium.org>
Date: Wed, May 8, 2019 at 9:16 PM
To: Alexander Potapenko
Cc: Andrew Morton, Christoph Lameter, Kees Cook, Laura Abbott,
Linux-MM, linux-security-module, Kernel Hardening, Masahiro Yamada,
James Morris, Serge E. Hallyn, Nick Desaulniers, Kostya Serebryany,
Dmitry Vyukov, Sandeep Patil, Randy Dunlap, Jann Horn, Mark Rutland

> On Wed, May 8, 2019 at 8:38 AM Alexander Potapenko <glider@google.com> wr=
ote:
> > When passed to an allocator (either pagealloc or SL[AOU]B), __GFP_NOINI=
T
> > tells it to not initialize the requested memory if the init_on_alloc
> > boot option is enabled. This can be useful in the cases newly allocated
> > memory is going to be initialized by the caller right away.
> >
> > __GFP_NOINIT doesn't affect init_on_free behavior, except for SLOB,
> > where init_on_free implies init_on_alloc.
> >
> > __GFP_NOINIT basically defeats the hardening against information leaks
> > provided by init_on_alloc, so one should use it with caution.
> >
> > This patch also adds __GFP_NOINIT to alloc_pages() calls in SL[AOU]B.
> > Doing so is safe, because the heap allocators initialize the pages they
> > receive before passing memory to the callers.
> >
> > Slowdown for the initialization features compared to init_on_free=3D0,
> > init_on_alloc=3D0:
> >
> > hackbench, init_on_free=3D1:  +6.84% sys time (st.err 0.74%)
> > hackbench, init_on_alloc=3D1: +7.25% sys time (st.err 0.72%)
> >
> > Linux build with -j12, init_on_free=3D1:  +8.52% wall time (st.err 0.42=
%)
> > Linux build with -j12, init_on_free=3D1:  +24.31% sys time (st.err 0.47=
%)
> > Linux build with -j12, init_on_alloc=3D1: -0.16% wall time (st.err 0.40=
%)
> > Linux build with -j12, init_on_alloc=3D1: +1.24% sys time (st.err 0.39%=
)
> >
> > The slowdown for init_on_free=3D0, init_on_alloc=3D0 compared to the
> > baseline is within the standard error.
> >
> > Signed-off-by: Alexander Potapenko <glider@google.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> > Cc: James Morris <jmorris@namei.org>
> > Cc: "Serge E. Hallyn" <serge@hallyn.com>
> > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > Cc: Kostya Serebryany <kcc@google.com>
> > Cc: Dmitry Vyukov <dvyukov@google.com>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Sandeep Patil <sspatil@android.com>
> > Cc: Laura Abbott <labbott@redhat.com>
> > Cc: Randy Dunlap <rdunlap@infradead.org>
> > Cc: Jann Horn <jannh@google.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: linux-mm@kvack.org
> > Cc: linux-security-module@vger.kernel.org
> > Cc: kernel-hardening@lists.openwall.com
> > ---
> >  include/linux/gfp.h | 6 +++++-
> >  include/linux/mm.h  | 2 +-
> >  kernel/kexec_core.c | 2 +-
> >  mm/slab.c           | 2 +-
> >  mm/slob.c           | 3 ++-
> >  mm/slub.c           | 1 +
> >  6 files changed, 11 insertions(+), 5 deletions(-)
> >
> > diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> > index fdab7de7490d..66d7f5604fe2 100644
> > --- a/include/linux/gfp.h
> > +++ b/include/linux/gfp.h
> > @@ -44,6 +44,7 @@ struct vm_area_struct;
> >  #else
> >  #define ___GFP_NOLOCKDEP       0
> >  #endif
> > +#define ___GFP_NOINIT          0x1000000u
>
> I mentioned this in the other patch, but I think this needs to be
> moved ahead of GFP_NOLOCKDEP and adjust the values for GFP_NOLOCKDEP
> and to leave the IS_ENABLED() test in __GFP_BITS_SHIFT alone.
Do we really need this blinking GFP_NOLOCKDEP bit at all?
This approach doesn't scale, we can't even have a second feature that
has a bit depending on the config settings.
Cannot we just fix the number of bits instead?

> >  /* If the above are modified, __GFP_BITS_SHIFT may need updating */
> >
> >  /*
> > @@ -208,16 +209,19 @@ struct vm_area_struct;
> >   * %__GFP_COMP address compound page metadata.
> >   *
> >   * %__GFP_ZERO returns a zeroed page on success.
> > + *
> > + * %__GFP_NOINIT requests non-initialized memory from the underlying a=
llocator.
> >   */
> >  #define __GFP_NOWARN   ((__force gfp_t)___GFP_NOWARN)
> >  #define __GFP_COMP     ((__force gfp_t)___GFP_COMP)
> >  #define __GFP_ZERO     ((__force gfp_t)___GFP_ZERO)
> > +#define __GFP_NOINIT   ((__force gfp_t)___GFP_NOINIT)
> >
> >  /* Disable lockdep for GFP context tracking */
> >  #define __GFP_NOLOCKDEP ((__force gfp_t)___GFP_NOLOCKDEP)
> >
> >  /* Room for N __GFP_FOO bits */
> > -#define __GFP_BITS_SHIFT (23 + IS_ENABLED(CONFIG_LOCKDEP))
> > +#define __GFP_BITS_SHIFT (25)
>
> AIUI, this will break non-CONFIG_LOCKDEP kernels: it should just be:
>
> -#define __GFP_BITS_SHIFT (23 + IS_ENABLED(CONFIG_LOCKDEP))
> +#define __GFP_BITS_SHIFT (24 + IS_ENABLED(CONFIG_LOCKDEP))
>
> >  #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1))
> >
> >  /**
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index ee1a1092679c..8ab152750eb4 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -2618,7 +2618,7 @@ DECLARE_STATIC_KEY_FALSE(init_on_alloc);
> >  static inline bool want_init_on_alloc(gfp_t flags)
> >  {
> >         if (static_branch_unlikely(&init_on_alloc))
> > -               return true;
> > +               return !(flags & __GFP_NOINIT);
> >         return flags & __GFP_ZERO;
>
> What do you think about renaming __GFP_NOINIT to __GFP_NO_AUTOINIT or som=
ething?
>
> Regardless, yes, this is nice.
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
