Return-Path: <kernel-hardening-return-16205-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 972DF4E272
	for <lists+kernel-hardening@lfdr.de>; Fri, 21 Jun 2019 10:58:07 +0200 (CEST)
Received: (qmail 13845 invoked by uid 550); 21 Jun 2019 08:58:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13819 invoked from network); 21 Jun 2019 08:57:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=p0seZSpVgUNBPW28BWcr2U4E6EkfOYFjtnKpVitnWIY=;
        b=sGaOh+GQBP49uUyoJOZ9+Asi6u5yGz2ONKs00ljT7XJJE+2213mnLgebU2M+3Dw2ad
         gNxoHMcK9jZIXpsL9KlAeK1a7fP3c+b5AmXoRQmC5wFjy2wtGorZUbqhTyVNcC68Qkxg
         cxA9HPIOSjsGrQ1MPi3VJQWGu9w9G5oQTlkvAxyVCSy5w3xPA/tM4H20JkP1We3ufkXd
         cvQt1NGxK+jQiqh3pG3X8tCPKSPVaH1YTWoM/1CLcjAr13ShP7BJjJUgQhdRYnaW2rdp
         hoi4WHrMXYyWABEgsKSCNSS4nT7ZoZT0xiDb9kOeDpsWGZsWooJKrocGq/DiNus8tGH+
         dUWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=p0seZSpVgUNBPW28BWcr2U4E6EkfOYFjtnKpVitnWIY=;
        b=leuDfX7UKJdyybLYAN3oWufbQoxSFJ0obaA1bvlB8J7PzEqsmwlSM9OxiVyqB7LXR2
         Wq0QsAEFhv8yAXZ+hFTJbkEuI4X8nIzWorAAXybIW2yTNA74INlQn/jJBvvw19CDYvel
         Xz5in5JqP+Pq0aTCwkQmmpizIxs7L9SUbNESuSTpG4SqAbcubHOdz6A2tune9Z/VuSEq
         tVs/AP22kAL7ebapYiZfFAqrGfxU0rszbW1/jvTS9Egw4gSr1wWYzWSDN2zb8X7exT6H
         8QWyaKXodYfZEZNeAyoM+AzPdl/0UL2SY8dYjD3WX4Mpdfg5bHC8KM+hvvDoXq3afmMN
         a/Ww==
X-Gm-Message-State: APjAAAXMV9Bb9kK6xuY2te/1XFN6/rq75eeHMe/IO2zyNDcrtZbu+0sa
	iQ8xyCjzGMsSLJLFWtnRPor5g5/qlgFUkjwT5tH9Zg==
X-Google-Smtp-Source: APXvYqwDXcF8Q+Kmw8HmTuNq/UhEJosCDSBhSR6JfC+oGEZCEL/m2PiH3U3TeICGfLD3w3LljE+CxBA/BEL2eL8RePs=
X-Received: by 2002:ab0:64cc:: with SMTP id j12mr7182070uaq.110.1561107467551;
 Fri, 21 Jun 2019 01:57:47 -0700 (PDT)
MIME-Version: 1.0
References: <20190617151050.92663-1-glider@google.com> <20190617151050.92663-2-glider@google.com>
 <20190621070905.GA3429@dhcp22.suse.cz>
In-Reply-To: <20190621070905.GA3429@dhcp22.suse.cz>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 21 Jun 2019 10:57:35 +0200
Message-ID: <CAG_fn=UFj0Lzy3FgMV_JBKtxCiwE03HVxnR8=f9a7=4nrUFXSw@mail.gmail.com>
Subject: Re: [PATCH v7 1/2] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, 
	Kees Cook <keescook@chromium.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, 
	Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, Marco Elver <elver@google.com>, 
	Linux Memory Management List <linux-mm@kvack.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 21, 2019 at 9:09 AM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Mon 17-06-19 17:10:49, Alexander Potapenko wrote:
> > The new options are needed to prevent possible information leaks and
> > make control-flow bugs that depend on uninitialized values more
> > deterministic.
> >
> > init_on_alloc=3D1 makes the kernel initialize newly allocated pages and=
 heap
> > objects with zeroes. Initialization is done at allocation time at the
> > places where checks for __GFP_ZERO are performed.
> >
> > init_on_free=3D1 makes the kernel initialize freed pages and heap objec=
ts
> > with zeroes upon their deletion. This helps to ensure sensitive data
> > doesn't leak via use-after-free accesses.
> >
> > Both init_on_alloc=3D1 and init_on_free=3D1 guarantee that the allocato=
r
> > returns zeroed memory. The two exceptions are slab caches with
> > constructors and SLAB_TYPESAFE_BY_RCU flag. Those are never
> > zero-initialized to preserve their semantics.
> >
> > Both init_on_alloc and init_on_free default to zero, but those defaults
> > can be overridden with CONFIG_INIT_ON_ALLOC_DEFAULT_ON and
> > CONFIG_INIT_ON_FREE_DEFAULT_ON.
> >
> > Slowdown for the new features compared to init_on_free=3D0,
> > init_on_alloc=3D0:
> >
> > hackbench, init_on_free=3D1:  +7.62% sys time (st.err 0.74%)
> > hackbench, init_on_alloc=3D1: +7.75% sys time (st.err 2.14%)
> >
> > Linux build with -j12, init_on_free=3D1:  +8.38% wall time (st.err 0.39=
%)
> > Linux build with -j12, init_on_free=3D1:  +24.42% sys time (st.err 0.52=
%)
> > Linux build with -j12, init_on_alloc=3D1: -0.13% wall time (st.err 0.42=
%)
> > Linux build with -j12, init_on_alloc=3D1: +0.57% sys time (st.err 0.40%=
)
> >
> > The slowdown for init_on_free=3D0, init_on_alloc=3D0 compared to the
> > baseline is within the standard error.
> >
> > The new features are also going to pave the way for hardware memory
> > tagging (e.g. arm64's MTE), which will require both on_alloc and on_fre=
e
> > hooks to set the tags for heap objects. With MTE, tagging will have the
> > same cost as memory initialization.
> >
> > Although init_on_free is rather costly, there are paranoid use-cases wh=
ere
> > in-memory data lifetime is desired to be minimized. There are various
> > arguments for/against the realism of the associated threat models, but
> > given that we'll need the infrastructre for MTE anyway, and there are
> > people who want wipe-on-free behavior no matter what the performance co=
st,
> > it seems reasonable to include it in this series.
>
> Thanks for reworking the original implemenation. This looks much better!
>
> > Signed-off-by: Alexander Potapenko <glider@google.com>
> > Acked-by: Kees Cook <keescook@chromium.org>
> > To: Andrew Morton <akpm@linux-foundation.org>
> > To: Christoph Lameter <cl@linux.com>
> > To: Kees Cook <keescook@chromium.org>
> > Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
> > Cc: Michal Hocko <mhocko@kernel.org>
> > Cc: James Morris <jmorris@namei.org>
> > Cc: "Serge E. Hallyn" <serge@hallyn.com>
> > Cc: Nick Desaulniers <ndesaulniers@google.com>
> > Cc: Kostya Serebryany <kcc@google.com>
> > Cc: Dmitry Vyukov <dvyukov@google.com>
> > Cc: Sandeep Patil <sspatil@android.com>
> > Cc: Laura Abbott <labbott@redhat.com>
> > Cc: Randy Dunlap <rdunlap@infradead.org>
> > Cc: Jann Horn <jannh@google.com>
> > Cc: Mark Rutland <mark.rutland@arm.com>
> > Cc: Marco Elver <elver@google.com>
> > Cc: linux-mm@kvack.org
> > Cc: linux-security-module@vger.kernel.org
> > Cc: kernel-hardening@lists.openwall.com
>
> Acked-by: Michal Hocko <mhocko@suse.cz> # page allocator parts.
>
> kmalloc based parts look good to me as well but I am not sure I fill
> qualified to give my ack there without much more digging and I do not
> have much time for that now.
>
> [...]
> > diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> > index fd5c95ff9251..2f75dd0d0d81 100644
> > --- a/kernel/kexec_core.c
> > +++ b/kernel/kexec_core.c
> > @@ -315,7 +315,7 @@ static struct page *kimage_alloc_pages(gfp_t gfp_ma=
sk, unsigned int order)
> >               arch_kexec_post_alloc_pages(page_address(pages), count,
> >                                           gfp_mask);
> >
> > -             if (gfp_mask & __GFP_ZERO)
> > +             if (want_init_on_alloc(gfp_mask))
> >                       for (i =3D 0; i < count; i++)
> >                               clear_highpage(pages + i);
> >       }
>
> I am not really sure I follow here. Why do we want to handle
> want_init_on_alloc here? The allocated memory comes from the page
> allocator and so it will get zeroed there. arch_kexec_post_alloc_pages
> might touch the content there but is there any actual risk of any kind
> of leak?
You're right, we don't want to initialize this memory if init_on_alloc is o=
n.
We need something along the lines of:
  if (!static_branch_unlikely(&init_on_alloc))
    if (gfp_mask & __GFP_ZERO)
      // clear the pages

Another option would be to disable initialization in alloc_pages() using a =
flag.
>
> > diff --git a/mm/dmapool.c b/mm/dmapool.c
> > index 8c94c89a6f7e..e164012d3491 100644
> > --- a/mm/dmapool.c
> > +++ b/mm/dmapool.c
> > @@ -378,7 +378,7 @@ void *dma_pool_alloc(struct dma_pool *pool, gfp_t m=
em_flags,
> >  #endif
> >       spin_unlock_irqrestore(&pool->lock, flags);
> >
> > -     if (mem_flags & __GFP_ZERO)
> > +     if (want_init_on_alloc(mem_flags))
> >               memset(retval, 0, pool->size);
> >
> >       return retval;
>
> Don't you miss dma_pool_free and want_init_on_free?
Agreed.
I'll fix this and add tests for DMA pools as well.
> --
> Michal Hocko
> SUSE Labs



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
