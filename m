Return-Path: <kernel-hardening-return-15919-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5B6AD1A77E
	for <lists+kernel-hardening@lfdr.de>; Sat, 11 May 2019 12:15:47 +0200 (CEST)
Received: (qmail 18042 invoked by uid 550); 11 May 2019 10:15:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 15905 invoked from network); 11 May 2019 07:28:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=KopircJhRXMfrWcULPVcWQaTugpBxYovfsXkQ7fl/a4=;
        b=pc1RPcWgOjvHOLt9MpCF14rQ2eFdu9i88YDkEf9oG3Z3L7OTJ79nQRekUkoMlZrlSD
         641dup0UNQRx6weE+Hec60AjgkkLabmDHuDclZb0K6qK7Tqa9x/++DM9ZY+FVJj7uHsr
         Aa2UOs2pmfCXmT6/ehTSduIgOv24osoRyLiqZnaahIblRmJWB31ueLaLe8xeQJKqyzvh
         W2mUYJLan1l2FGIMo6kYNCyWu9DCvpSscBYbL4AKG6OUWu7yN2Yz/tb9jbRkqudKzJbm
         n+lNAI1NeGJX8CLAcpGaAtyYro1SULJASbyBF5xsvE5CQ/U6bUA5brjRVkELhRqCV2Es
         Em6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=KopircJhRXMfrWcULPVcWQaTugpBxYovfsXkQ7fl/a4=;
        b=gZVP+va/4xvEScgvfeo1dQAKpC/6NMc35M3mCcss1YDTSXZLhYMrGf7u1inNixst9S
         U2SPMKOIm84M0sCfhVdxZXVcR30s0c85GkAoyUrpjvc3PdVkdlTg1Xly/Ea6Oudj2ByF
         9GyDheeQHK+3glNgr7O5ZknD4RajSrpV/kdR8NtXTnG9h+tdd5hEbKmenolkB8PCV8lx
         I7TVO7uXOR/Ggyh6eRgSaK41hjZq5joo3PZYvSYvo7W7KqoWXIXUTTqGufXrFH+WDAU5
         3uISyA9LkCSKgNyMFZ2Sth0I56ERSRMgkzPf6WTcmpQmF9tS2vnLiSNLStySGgN9CnM6
         Oysw==
X-Gm-Message-State: APjAAAVXMFUbweb7KTbYYX9iZJLMJ96GE+QGnox3FUJgXwCpwzIcN2S+
	vrTtqN3usxwdhNlsC94zqiQppGYcbvLuuBhm0Jg=
X-Google-Smtp-Source: APXvYqy8obu1dtItC8F2islEMLSI9aCSXsTT6ZrzVl0SSzanRxxG1BvC2iK1+10Lb6vLlFmbNYHLmffWaczi3h0q3vU=
X-Received: by 2002:a2e:8787:: with SMTP id n7mr8028212lji.31.1557559717474;
 Sat, 11 May 2019 00:28:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190508153736.256401-1-glider@google.com> <20190508153736.256401-4-glider@google.com>
 <CAGXu5jJS=KgLwetdmDAUq9+KhUFTd=jnCES3BZJm+qBwUBmLjQ@mail.gmail.com> <CAG_fn=VbJXHsqAeBD+g6zJ8WVTko4Ev2xytXrcJ-ztEWm7kOOA@mail.gmail.com>
In-Reply-To: <CAG_fn=VbJXHsqAeBD+g6zJ8WVTko4Ev2xytXrcJ-ztEWm7kOOA@mail.gmail.com>
From: Souptick Joarder <jrdr.linux@gmail.com>
Date: Sat, 11 May 2019 12:58:25 +0530
Message-ID: <CAFqt6zY1oY4YTfAd4RdV0-V8iUfK65LTHsdmxrSWs7KRnWrrCg@mail.gmail.com>
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

On Thu, May 9, 2019 at 6:53 PM Alexander Potapenko <glider@google.com> wrot=
e:
>
> From: Kees Cook <keescook@chromium.org>
> Date: Wed, May 8, 2019 at 9:16 PM
> To: Alexander Potapenko
> Cc: Andrew Morton, Christoph Lameter, Kees Cook, Laura Abbott,
> Linux-MM, linux-security-module, Kernel Hardening, Masahiro Yamada,
> James Morris, Serge E. Hallyn, Nick Desaulniers, Kostya Serebryany,
> Dmitry Vyukov, Sandeep Patil, Randy Dunlap, Jann Horn, Mark Rutland
>
> > On Wed, May 8, 2019 at 8:38 AM Alexander Potapenko <glider@google.com> =
wrote:
> > > When passed to an allocator (either pagealloc or SL[AOU]B), __GFP_NOI=
NIT
> > > tells it to not initialize the requested memory if the init_on_alloc
> > > boot option is enabled. This can be useful in the cases newly allocat=
ed
> > > memory is going to be initialized by the caller right away.
> > >
> > > __GFP_NOINIT doesn't affect init_on_free behavior, except for SLOB,
> > > where init_on_free implies init_on_alloc.
> > >
> > > __GFP_NOINIT basically defeats the hardening against information leak=
s
> > > provided by init_on_alloc, so one should use it with caution.
> > >
> > > This patch also adds __GFP_NOINIT to alloc_pages() calls in SL[AOU]B.
> > > Doing so is safe, because the heap allocators initialize the pages th=
ey
> > > receive before passing memory to the callers.
> > >
> > > Slowdown for the initialization features compared to init_on_free=3D0=
,
> > > init_on_alloc=3D0:
> > >
> > > hackbench, init_on_free=3D1:  +6.84% sys time (st.err 0.74%)
> > > hackbench, init_on_alloc=3D1: +7.25% sys time (st.err 0.72%)
> > >
> > > Linux build with -j12, init_on_free=3D1:  +8.52% wall time (st.err 0.=
42%)
> > > Linux build with -j12, init_on_free=3D1:  +24.31% sys time (st.err 0.=
47%)
> > > Linux build with -j12, init_on_alloc=3D1: -0.16% wall time (st.err 0.=
40%)
> > > Linux build with -j12, init_on_alloc=3D1: +1.24% sys time (st.err 0.3=
9%)
> > >
> > > The slowdown for init_on_free=3D0, init_on_alloc=3D0 compared to the
> > > baseline is within the standard error.
> > >

Not sure, but I think this patch will clash with Matthew's posted patch ser=
ies
*Remove 'order' argument from many mm functions*.

> > > Signed-off-by: Alexander Potapenko <glider@google.com>
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> > > Cc: James Morris <jmorris@namei.org>
> > > Cc: "Serge E. Hallyn" <serge@hallyn.com>
> > > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > > Cc: Kostya Serebryany <kcc@google.com>
> > > Cc: Dmitry Vyukov <dvyukov@google.com>
> > > Cc: Kees Cook <keescook@chromium.org>
> > > Cc: Sandeep Patil <sspatil@android.com>
> > > Cc: Laura Abbott <labbott@redhat.com>
> > > Cc: Randy Dunlap <rdunlap@infradead.org>
> > > Cc: Jann Horn <jannh@google.com>
> > > Cc: Mark Rutland <mark.rutland@arm.com>
> > > Cc: linux-mm@kvack.org
> > > Cc: linux-security-module@vger.kernel.org
> > > Cc: kernel-hardening@lists.openwall.com
> > > ---
> > >  include/linux/gfp.h | 6 +++++-
> > >  include/linux/mm.h  | 2 +-
> > >  kernel/kexec_core.c | 2 +-
> > >  mm/slab.c           | 2 +-
> > >  mm/slob.c           | 3 ++-
> > >  mm/slub.c           | 1 +
> > >  6 files changed, 11 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> > > index fdab7de7490d..66d7f5604fe2 100644
> > > --- a/include/linux/gfp.h
> > > +++ b/include/linux/gfp.h
> > > @@ -44,6 +44,7 @@ struct vm_area_struct;
> > >  #else
> > >  #define ___GFP_NOLOCKDEP       0
> > >  #endif
> > > +#define ___GFP_NOINIT          0x1000000u
> >
> > I mentioned this in the other patch, but I think this needs to be
> > moved ahead of GFP_NOLOCKDEP and adjust the values for GFP_NOLOCKDEP
> > and to leave the IS_ENABLED() test in __GFP_BITS_SHIFT alone.
> Do we really need this blinking GFP_NOLOCKDEP bit at all?
> This approach doesn't scale, we can't even have a second feature that
> has a bit depending on the config settings.
> Cannot we just fix the number of bits instead?
>
> > >  /* If the above are modified, __GFP_BITS_SHIFT may need updating */
> > >
> > >  /*
> > > @@ -208,16 +209,19 @@ struct vm_area_struct;
> > >   * %__GFP_COMP address compound page metadata.
> > >   *
> > >   * %__GFP_ZERO returns a zeroed page on success.
> > > + *
> > > + * %__GFP_NOINIT requests non-initialized memory from the underlying=
 allocator.
> > >   */
> > >  #define __GFP_NOWARN   ((__force gfp_t)___GFP_NOWARN)
> > >  #define __GFP_COMP     ((__force gfp_t)___GFP_COMP)
> > >  #define __GFP_ZERO     ((__force gfp_t)___GFP_ZERO)
> > > +#define __GFP_NOINIT   ((__force gfp_t)___GFP_NOINIT)
> > >
> > >  /* Disable lockdep for GFP context tracking */
> > >  #define __GFP_NOLOCKDEP ((__force gfp_t)___GFP_NOLOCKDEP)
> > >
> > >  /* Room for N __GFP_FOO bits */
> > > -#define __GFP_BITS_SHIFT (23 + IS_ENABLED(CONFIG_LOCKDEP))
> > > +#define __GFP_BITS_SHIFT (25)
> >
> > AIUI, this will break non-CONFIG_LOCKDEP kernels: it should just be:
> >
> > -#define __GFP_BITS_SHIFT (23 + IS_ENABLED(CONFIG_LOCKDEP))
> > +#define __GFP_BITS_SHIFT (24 + IS_ENABLED(CONFIG_LOCKDEP))
> >
> > >  #define __GFP_BITS_MASK ((__force gfp_t)((1 << __GFP_BITS_SHIFT) - 1=
))
> > >
> > >  /**
> > > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > > index ee1a1092679c..8ab152750eb4 100644
> > > --- a/include/linux/mm.h
> > > +++ b/include/linux/mm.h
> > > @@ -2618,7 +2618,7 @@ DECLARE_STATIC_KEY_FALSE(init_on_alloc);
> > >  static inline bool want_init_on_alloc(gfp_t flags)
> > >  {
> > >         if (static_branch_unlikely(&init_on_alloc))
> > > -               return true;
> > > +               return !(flags & __GFP_NOINIT);
> > >         return flags & __GFP_ZERO;
> >
> > What do you think about renaming __GFP_NOINIT to __GFP_NO_AUTOINIT or s=
omething?
> >
> > Regardless, yes, this is nice.
> >
> > --
> > Kees Cook
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
>
