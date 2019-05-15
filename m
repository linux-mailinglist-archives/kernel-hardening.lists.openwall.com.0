Return-Path: <kernel-hardening-return-15926-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C258A1EBDB
	for <lists+kernel-hardening@lfdr.de>; Wed, 15 May 2019 12:11:42 +0200 (CEST)
Received: (qmail 15818 invoked by uid 550); 15 May 2019 10:11:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 11994 invoked from network); 15 May 2019 10:07:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mscevK37/4nnD6iDAhQMYOtk0/NBE7+GVVa+J+i/xbw=;
        b=VfTOzfQHAEh1LniZ7/hjqkQRXVW6w0NiARMgkQz8fdmWPYx+YFlHjKrWW9SFetMWs3
         G9DBebsTzY+TzQqgaUZXHhuaJrAvPguyvG5rKygzDGVFRgykAzD9rO3eppEFQXrUDl0t
         KiCIAIs50XeDjdechjn9tNOpCIzTltid3TPjj4d5um53TgSRkcuBRE+Vm8tHVDQSZq3j
         4F5qTovSxa830D/kbxTzCF5Od4cASnkmz5b2FS8aG6wMt7X9c6XUSbGzNiMGEIJ+3WjJ
         66h2W9OJYMa8ypZNTZ+p2ZcKlrFs73YpMOW0vtYnMkyh9XXQW7DWfejdxzaJMmnDynAB
         L+Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mscevK37/4nnD6iDAhQMYOtk0/NBE7+GVVa+J+i/xbw=;
        b=qucdBznZ59yfgw/1IakgE9ZixqJiU4mR37n2aY5js0rvevCT2UF82U4A7uuGmrfNbi
         85qZ8vHceV6c1APtRx2+xglwUm/vu0eLGwTR5kwMS9P9gnfGJZDvI3ffcrL2tzB+a/l2
         Wjw8oCMzuAbFyEJnkoSzg+flE83T3OQ4ELm9qfU6Ibp8avuu+ZuKtmL3bYANI+e/G79N
         1hYhAqoLr/CKZOnHFZEknVJcfDtmEo/ABxTmV6NOUQNyLhLoHHNDln5QFZakcJ2uD5S6
         Cjtxrjw/OFXytTrU+1HU3Sg5q1dcK46rEfhS0revO2b2MqFVd2prWiiS9CF60402bUXk
         gEHw==
X-Gm-Message-State: APjAAAXwn/mJTe7UWcGWSy8g2OjaGE0Y8QLkI/GiZxjxyur1zVYZp5+H
	vPMCGsSkxnaxAR9R9bjNlSIDGaO+Yp+Wmax2oIA=
X-Google-Smtp-Source: APXvYqyq++NbMOADSqcuCndB8YwWAw8htvvh4qqGDhAqxC5mnRCZl3FTp2S7oPZzjTciowd41OY1QaLvEK3AiS3oH/o=
X-Received: by 2002:a2e:960e:: with SMTP id v14mr4236733ljh.31.1557914830398;
 Wed, 15 May 2019 03:07:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190508153736.256401-1-glider@google.com> <20190508153736.256401-4-glider@google.com>
 <CAGXu5jJS=KgLwetdmDAUq9+KhUFTd=jnCES3BZJm+qBwUBmLjQ@mail.gmail.com>
 <CAG_fn=VbJXHsqAeBD+g6zJ8WVTko4Ev2xytXrcJ-ztEWm7kOOA@mail.gmail.com>
 <CAFqt6zY1oY4YTfAd4RdV0-V8iUfK65LTHsdmxrSWs7KRnWrrCg@mail.gmail.com> <CAG_fn=XzWcF=_L1zEU6Gd++u00N=j9GptVLvYOj0_kF0HRu+ig@mail.gmail.com>
In-Reply-To: <CAG_fn=XzWcF=_L1zEU6Gd++u00N=j9GptVLvYOj0_kF0HRu+ig@mail.gmail.com>
From: Souptick Joarder <jrdr.linux@gmail.com>
Date: Wed, 15 May 2019 15:36:57 +0530
Message-ID: <CAFqt6zYvftTKDbpc-PyHw_uNvAnYuswevAe=F12ACFrBP1N6xA@mail.gmail.com>
Subject: Re: [PATCH 3/4] gfp: mm: introduce __GFP_NOINIT
To: Alexander Potapenko <glider@google.com>
Cc: Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@linux.com>, Laura Abbott <labbott@redhat.com>, Linux-MM <linux-mm@kvack.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 14, 2019 at 8:10 PM Alexander Potapenko <glider@google.com> wro=
te:
>
> From: Souptick Joarder <jrdr.linux@gmail.com>
> Date: Sat, May 11, 2019 at 9:28 AM
> To: Alexander Potapenko
> Cc: Kees Cook, Andrew Morton, Christoph Lameter, Laura Abbott,
> Linux-MM, linux-security-module, Kernel Hardening, Masahiro Yamada,
> James Morris, Serge E. Hallyn, Nick Desaulniers, Kostya Serebryany,
> Dmitry Vyukov, Sandeep Patil, Randy Dunlap, Jann Horn, Mark Rutland,
> Matthew Wilcox
>
> > On Thu, May 9, 2019 at 6:53 PM Alexander Potapenko <glider@google.com> =
wrote:
> > >
> > > From: Kees Cook <keescook@chromium.org>
> > > Date: Wed, May 8, 2019 at 9:16 PM
> > > To: Alexander Potapenko
> > > Cc: Andrew Morton, Christoph Lameter, Kees Cook, Laura Abbott,
> > > Linux-MM, linux-security-module, Kernel Hardening, Masahiro Yamada,
> > > James Morris, Serge E. Hallyn, Nick Desaulniers, Kostya Serebryany,
> > > Dmitry Vyukov, Sandeep Patil, Randy Dunlap, Jann Horn, Mark Rutland
> > >
> > > > On Wed, May 8, 2019 at 8:38 AM Alexander Potapenko <glider@google.c=
om> wrote:
> > > > > When passed to an allocator (either pagealloc or SL[AOU]B), __GFP=
_NOINIT
> > > > > tells it to not initialize the requested memory if the init_on_al=
loc
> > > > > boot option is enabled. This can be useful in the cases newly all=
ocated
> > > > > memory is going to be initialized by the caller right away.
> > > > >
> > > > > __GFP_NOINIT doesn't affect init_on_free behavior, except for SLO=
B,
> > > > > where init_on_free implies init_on_alloc.
> > > > >
> > > > > __GFP_NOINIT basically defeats the hardening against information =
leaks
> > > > > provided by init_on_alloc, so one should use it with caution.
> > > > >
> > > > > This patch also adds __GFP_NOINIT to alloc_pages() calls in SL[AO=
U]B.
> > > > > Doing so is safe, because the heap allocators initialize the page=
s they
> > > > > receive before passing memory to the callers.
> > > > >
> > > > > Slowdown for the initialization features compared to init_on_free=
=3D0,
> > > > > init_on_alloc=3D0:
> > > > >
> > > > > hackbench, init_on_free=3D1:  +6.84% sys time (st.err 0.74%)
> > > > > hackbench, init_on_alloc=3D1: +7.25% sys time (st.err 0.72%)
> > > > >
> > > > > Linux build with -j12, init_on_free=3D1:  +8.52% wall time (st.er=
r 0.42%)
> > > > > Linux build with -j12, init_on_free=3D1:  +24.31% sys time (st.er=
r 0.47%)
> > > > > Linux build with -j12, init_on_alloc=3D1: -0.16% wall time (st.er=
r 0.40%)
> > > > > Linux build with -j12, init_on_alloc=3D1: +1.24% sys time (st.err=
 0.39%)
> > > > >
> > > > > The slowdown for init_on_free=3D0, init_on_alloc=3D0 compared to =
the
> > > > > baseline is within the standard error.
> > > > >
> >
> > Not sure, but I think this patch will clash with Matthew's posted patch=
 series
> > *Remove 'order' argument from many mm functions*.
> Not sure I can do much with that before those patches reach mainline.
> Once they do, I'll update my patches.
> Please let me know if there's a better way to resolve such conflicts.

I just thought to highlight about a possible conflict. Nothing else :)
IMO, if other patch series merge into -next tree before this,
then this series can be updated against -next.

... And I am sure others will have a better suggestion.

> > > > > Signed-off-by: Alexander Potapenko <glider@google.com>
> > > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > > Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> > > > > Cc: James Morris <jmorris@namei.org>
> > > > > Cc: "Serge E. Hallyn" <serge@hallyn.com>
> > > > > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > > > > Cc: Kostya Serebryany <kcc@google.com>
> > > > > Cc: Dmitry Vyukov <dvyukov@google.com>
> > > > > Cc: Kees Cook <keescook@chromium.org>
> > > > > Cc: Sandeep Patil <sspatil@android.com>
> > > > > Cc: Laura Abbott <labbott@redhat.com>
> > > > > Cc: Randy Dunlap <rdunlap@infradead.org>
> > > > > Cc: Jann Horn <jannh@google.com>
> > > > > Cc: Mark Rutland <mark.rutland@arm.com>
> > > > > Cc: linux-mm@kvack.org
> > > > > Cc: linux-security-module@vger.kernel.org
> > > > > Cc: kernel-hardening@lists.openwall.com
> > > > > ---
> > > > >  include/linux/gfp.h | 6 +++++-
> > > > >  include/linux/mm.h  | 2 +-
> > > > >  kernel/kexec_core.c | 2 +-
> > > > >  mm/slab.c           | 2 +-
> > > > >  mm/slob.c           | 3 ++-
> > > > >  mm/slub.c           | 1 +
> > > > >  6 files changed, 11 insertions(+), 5 deletions(-)
> > > > >
> > > > > diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> > > > > index fdab7de7490d..66d7f5604fe2 100644
> > > > > --- a/include/linux/gfp.h
> > > > > +++ b/include/linux/gfp.h
> > > > > @@ -44,6 +44,7 @@ struct vm_area_struct;
> > > > >  #else
> > > > >  #define ___GFP_NOLOCKDEP       0
> > > > >  #endif
> > > > > +#define ___GFP_NOINIT          0x1000000u
> > > >
> > > > I mentioned this in the other patch, but I think this needs to be
> > > > moved ahead of GFP_NOLOCKDEP and adjust the values for GFP_NOLOCKDE=
P
> > > > and to leave the IS_ENABLED() test in __GFP_BITS_SHIFT alone.
> > > Do we really need this blinking GFP_NOLOCKDEP bit at all?
> > > This approach doesn't scale, we can't even have a second feature that
> > > has a bit depending on the config settings.
> > > Cannot we just fix the number of bits instead?
> > >
> > > > >  /* If the above are modified, __GFP_BITS_SHIFT may need updating=
 */
> > > > >
> > > > >  /*
> > > > > @@ -208,16 +209,19 @@ struct vm_area_struct;
> > > > >   * %__GFP_COMP address compound page metadata.
> > > > >   *
> > > > >   * %__GFP_ZERO returns a zeroed page on success.
> > > > > + *
> > > > > + * %__GFP_NOINIT requests non-initialized memory from the underl=
ying allocator.
> > > > >   */
> > > > >  #define __GFP_NOWARN   ((__force gfp_t)___GFP_NOWARN)
> > > > >  #define __GFP_COMP     ((__force gfp_t)___GFP_COMP)
> > > > >  #define __GFP_ZERO     ((__force gfp_t)___GFP_ZERO)
> > > > > +#define __GFP_NOINIT   ((__force gfp_t)___GFP_NOINIT)
> > > > >
> > > > >  /* Disable lockdep for GFP context tracking */
> > > > >  #define __GFP_NOLOCKDEP ((__force gfp_t)___GFP_NOLOCKDEP)
> > > > >
> > > > >  /* Room for N __GFP_FOO bits */
> > > > > -#define __GFP_BITS_SHIFT (23 + IS_ENABLED(CONFIG_LOCKDEP))
> > > > > +#define __GFP_BITS_SHIFT (25)
> > > >
> > > > AIUI, this will break non-CONFIG_LOCKDEP kernels: it should just be=
:
> > > >
> > > > -#define __GFP_BITS_SHIFT (23 + IS_ENABLED(CONFIG_LOCKDEP))
> > > > +#define __GFP_BITS_SHIFT (24 + IS_ENABLED(CONFIG_LOCKDEP))
> > > >
> > > > >  #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT)=
 - 1))
> > > > >
> > > > >  /**
> > > > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > > > index ee1a1092679c..8ab152750eb4 100644
> > > > > --- a/include/linux/mm.h
> > > > > +++ b/include/linux/mm.h
> > > > > @@ -2618,7 +2618,7 @@ DECLARE_STATIC_KEY_FALSE(init_on_alloc);
> > > > >  static inline bool want_init_on_alloc(gfp_t flags)
> > > > >  {
> > > > >         if (static_branch_unlikely(&init_on_alloc))
> > > > > -               return true;
> > > > > +               return !(flags & __GFP_NOINIT);
> > > > >         return flags & __GFP_ZERO;
> > > >
> > > > What do you think about renaming __GFP_NOINIT to __GFP_NO_AUTOINIT =
or something?
> > > >
> > > > Regardless, yes, this is nice.
> > > >
> > > > --
> > > > Kees Cook
> > >
> > >
> > >
> > > --
> > > Alexander Potapenko
> > > Software Engineer
> > >
> > > Google Germany GmbH
> > > Erika-Mann-Stra=C3=9Fe, 33
> > > 80636 M=C3=BCnchen
> > >
> > > Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
> > > Registergericht und -nummer: Hamburg, HRB 86891
> > > Sitz der Gesellschaft: Hamburg
> > >
>
>
>
> --
> Alexander Potapenko
> Software Engineer
>
> Google Germany GmbH
> Erika-Mann-Stra=C3=9Fe, 33
> 80636 M=C3=BCnchen
>
> Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
> Registergericht und -nummer: Hamburg, HRB 86891
> Sitz der Gesellschaft: Hamburg
