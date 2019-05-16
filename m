Return-Path: <kernel-hardening-return-15930-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A6ED320D46
	for <lists+kernel-hardening@lfdr.de>; Thu, 16 May 2019 18:43:08 +0200 (CEST)
Received: (qmail 1929 invoked by uid 550); 16 May 2019 16:43:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1904 invoked from network); 16 May 2019 16:43:01 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qGP3s0Ih6OqVOl4yoE5OjhGMu8j59fK2Yi9/glM9Xrw=;
        b=Okxi5lkWUzIdKTINNYUM9x0CnMaOx+4nMm60iubKUC2qCx6xrcp+TpF7VhW0Fisia6
         F0nxNliuFmYXNy3jH/xpwkRoe1hzGWV9CqMzTYNwzraz5N2DueWrpxTEAf82+p1DoA9v
         W7HoBYmrAbuLZJaDIXah0OnRhmBrTDImi1h/vpZe7aomuRRUQhT+21d3qJFMmoGOHGEf
         g/B+yNhFTjBlOi6JP8Arm/xbaNfqiKOALKh2nOYaulXmSpF5zKSdQEmkXWfFFY4ULB68
         Y9Z0a/sxvRghtt+6NzvOiV00D0R8jsBlQzQv5g2tIyt5mrGvwv4P8hjZwAXpWnodcN10
         bJng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qGP3s0Ih6OqVOl4yoE5OjhGMu8j59fK2Yi9/glM9Xrw=;
        b=fyjVrQU9a5i+VtfjsSEAl/ulfnulYh5tawNwfVA28kzWW0Ghk476WMRT2dtjGiIfnc
         NEuAyZZGslKOLYvHZvbJI77BzBY9akQ0G0YzSBxOaqNw0LY69zqIqV1bm3WyMcUMV+Iw
         Cm/S82ei4M45HJT0Y9v6pUDKeFX5xX7gAqT4k0kZQB9NxQaShCU5qG84UUFxQg1f6vnT
         dMQNI1g0+HzuwKR7YgbbuVK2TnBQiH5gNMcF7v0cZFzH4Ft8lSxWWtsmVaZU5tG4Adk8
         mvFn6s4GJB7jKS/jxtO0Ll1n/D7Yj8Ugp+/vBhUq09reiAFc+KoDAqFRu9pZaOES9myK
         60nA==
X-Gm-Message-State: APjAAAVEtlYvvWLda64uZ0c2yQPyYQNCQqrP9BHt3nQZDFuvh/5X8frW
	Mp5tTtmCBeaTmb/qhSXHjDl1c73ALn1QLBMK+ZRh6g==
X-Google-Smtp-Source: APXvYqy1VuDI7sbqIeBSUq7vxcBjJYXZpt3wUC0XAgfrB4Epp7KDM4s3DQdaAV9PG0f2kxYun1qfBmQzNSJDtinvt9w=
X-Received: by 2002:ab0:29cc:: with SMTP id i12mr16086901uaq.12.1558024969202;
 Thu, 16 May 2019 09:42:49 -0700 (PDT)
MIME-Version: 1.0
References: <20190514143537.10435-1-glider@google.com> <20190514143537.10435-2-glider@google.com>
 <201905160907.92FAC880@keescook>
In-Reply-To: <201905160907.92FAC880@keescook>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 16 May 2019 18:42:37 +0200
Message-ID: <CAG_fn=VsJmyuEUYy16R_M5Hu2CX-PJkz9Kw4rdy9XUCAYHwV5g@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
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

From: Kees Cook <keescook@chromium.org>
Date: Thu, May 16, 2019 at 6:20 PM
To: Alexander Potapenko
Cc: <akpm@linux-foundation.org>, <cl@linux.com>,
<kernel-hardening@lists.openwall.com>, Masahiro Yamada, James Morris,
Serge E. Hallyn, Nick Desaulniers, Kostya Serebryany, Dmitry Vyukov,
Sandeep Patil, Laura Abbott, Randy Dunlap, Jann Horn, Mark Rutland,
<linux-mm@kvack.org>, <linux-security-module@vger.kernel.org>

> On Tue, May 14, 2019 at 04:35:34PM +0200, Alexander Potapenko wrote:
> > Slowdown for the new features compared to init_on_free=3D0,
> > init_on_alloc=3D0:
> >
> > hackbench, init_on_free=3D1:  +7.62% sys time (st.err 0.74%)
> > hackbench, init_on_alloc=3D1: +7.75% sys time (st.err 2.14%)
>
> I wonder if the patch series should be reorganized to introduce
> __GFP_NO_AUTOINIT first, so that when the commit with benchmarks appears,
> we get the "final" numbers...
>
> > Linux build with -j12, init_on_free=3D1:  +8.38% wall time (st.err 0.39=
%)
> > Linux build with -j12, init_on_free=3D1:  +24.42% sys time (st.err 0.52=
%)
> > Linux build with -j12, init_on_alloc=3D1: -0.13% wall time (st.err 0.42=
%)
> > Linux build with -j12, init_on_alloc=3D1: +0.57% sys time (st.err 0.40%=
)
>
> I'm working on reproducing these benchmarks. I'd really like to narrow
> down the +24% number here. But it does
I suspect the slowdown of init_on_free is bigger than that of
PAX_SANITIZE_MEMORY, as we've set the goal to have fully zeroed memory
at alloc time.
If we want a mode that only wipes the user data upon free() but
doesn't eliminate all uninit memory, then we can make it faster.
> > The slowdown for init_on_free=3D0, init_on_alloc=3D0 compared to the
> > baseline is within the standard error.
>
> I think the use of static keys here is really great: this is available
> by default for anyone that wants to turn it on.
>
> I'm thinking, given the configuable nature of this, it'd be worth adding
> a little more detail at boot time. I think maybe a separate patch could
> be added to describe the kernel's memory auto-initialization features,
> and add something like this to mm_init():
>
> +void __init report_meminit(void)
> +{
> +       const char *stack;
> +
> +       if (IS_ENABLED(CONFIG_INIT_STACK_ALL))
> +               stack =3D "all";
> +       else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL))
> +               stack =3D "byref_all";
> +       else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF))
> +               stack =3D "byref";
> +       else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_USER))
> +               stack =3D "__user";
> +       else
> +               stack =3D "off";
> +
> +       /* Report memory auto-initialization states for this boot. */
> +       pr_info("mem auto-init: stack:%s, heap alloc:%s, heap free:%s\n",
> +               stack, want_init_on_alloc(GFP_KERNEL) ? "on" : "off",
> +               want_init_on_free() ? "on" : "off");
> +}
>
> To get a boot line like:
>
>         mem auto-init: stack:off, heap alloc:off, heap free:on
For stack there's no binary on/off, as you can potentially build half
of the kernel with stack instrumentation and another half without it.
We could make the instrumentation insert a static global flag into
each translation unit, but this won't give us any interesting info.

> And one other thought I had was that in the init_on_free=3D1 case, there =
is
> a large pause at boot while memory is being cleared. I think it'd be hand=
y
> to include a comment about that, just to keep people from being surprised=
:
>
> diff --git a/init/main.c b/init/main.c
> index cf0c3948ce0e..aea278392338 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -529,6 +529,8 @@ static void __init mm_init(void)
>          * bigger than MAX_ORDER unless SPARSEMEM.
>          */
>         page_ext_init_flatmem();
> +       if (want_init_on_free())
> +               pr_info("Clearing system memory ...\n");
>         mem_init();
>         kmem_cache_init();
>         pgtable_init();
>
> Beyond these thoughts, I think this series is in good shape.
>
> Andrew (or anyone else) do you have any concerns about this?
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
