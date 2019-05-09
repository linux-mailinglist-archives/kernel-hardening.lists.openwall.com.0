Return-Path: <kernel-hardening-return-15913-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 495C918E54
	for <lists+kernel-hardening@lfdr.de>; Thu,  9 May 2019 18:43:52 +0200 (CEST)
Received: (qmail 20125 invoked by uid 550); 9 May 2019 16:43:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 20105 invoked from network); 9 May 2019 16:43:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=scoklaUKCwoyF6C6A+2vS8qnRMGu4PDFVwRfwqNtv98=;
        b=W5NPu7UNCMvXR4FF+Orajnb/B6NZxQzAvi9Rnniu5D1QBMIj1zEd1ZOTFs7N0YCb4h
         obNz04dmCAXeV8V10GEaxiDmcRhVkfNt0Sm9pD4dYF/C1vabNRy4tyw/q7pPU4tQMNfr
         KhlKXF2buBmjsDZq5ypkF3nP3KBRvADS4tobRjqeogywxqaPTtWxqDz5C5JWDdqIo4q9
         nGlCgGUJ8Vitujn2OgVQsAdeVHSP6yhMv9Ya4xWGm4t8jYixlVweNEFJSk9DnlVnYaO1
         kTMxqWZfeq5kV4no0PIgvREzErEcSEXQqIUq8unew+2G0z3iFWyYgkfqg9umSa6KielS
         6rXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=scoklaUKCwoyF6C6A+2vS8qnRMGu4PDFVwRfwqNtv98=;
        b=SoAS85Y/XVO2h38Bf8CexJGK+UUGlOH3I21+98r+TElBew7vVCb6tJ5KxIiRrhEyT1
         ccxcgttf+AL4waiTfiOQlyokRzMP0Wwb8jHVGM0f549FYk6lx/u8/RcKj/h/EjX209ne
         vMcZU+zTQnKD1X9N8TrFVnrlv4Qdhoz9Dbi8hsCR8FiewTI8z5QqC8570bP7vv6AWfs8
         rPyqy+n/GaWH6oZ3D2UT1MfQWoAyz+Md1ShLX1VAEENgBUlPKEjmWMJAwVqkTJ4k5I6i
         54R8wqY+dTjWOixAD6xnDBlrLUGtbVYiHRqrZ2CbS1H3c1MrZs8Lk+zQrFKkzn7v1ITp
         ndTA==
X-Gm-Message-State: APjAAAUO4jXXk1ssInc+OmH8LaHORPZAG0uO1+fxqPSq+0rOYR6q92Eq
	y1vJMzlyNVcD/TJs9itES4cUHiVIfzQLLGO2sYqmgw==
X-Google-Smtp-Source: APXvYqyCrNILIPE1aM9yj+g5z6EqLOv3bZuyYJ/RoOpitBlKLPTF4cJxqZd//NaX8Rp91mG9W2FyALdArcIfwkl6nKs=
X-Received: by 2002:a1f:ae4b:: with SMTP id x72mr2336739vke.29.1557420213429;
 Thu, 09 May 2019 09:43:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190508153736.256401-1-glider@google.com> <20190508153736.256401-2-glider@google.com>
 <CAGXu5jKfxYfRQS+CouYZc8-BMEWR1U3kwshu4892pM0pmmACGw@mail.gmail.com>
In-Reply-To: <CAGXu5jKfxYfRQS+CouYZc8-BMEWR1U3kwshu4892pM0pmmACGw@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 9 May 2019 18:43:21 +0200
Message-ID: <CAG_fn=UDyVpZz5=oP4HHdYCB43NnXG1sLypRXopyEk9qgq471A@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
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
Date: Wed, May 8, 2019 at 9:02 PM
To: Alexander Potapenko
Cc: Andrew Morton, Christoph Lameter, Kees Cook, Laura Abbott,
Linux-MM, linux-security-module, Kernel Hardening, Masahiro Yamada,
James Morris, Serge E. Hallyn, Nick Desaulniers, Kostya Serebryany,
Dmitry Vyukov, Sandeep Patil, Randy Dunlap, Jann Horn, Mark Rutland

> On Wed, May 8, 2019 at 8:38 AM Alexander Potapenko <glider@google.com> wr=
ote:
> > The new options are needed to prevent possible information leaks and
> > make control-flow bugs that depend on uninitialized values more
> > deterministic.
>
> I like having this available on both alloc and free. This makes it
> much more configurable for the end users who can adapt to their work
> loads, etc.
>
> > Linux build with -j12, init_on_free=3D1:  +24.42% sys time (st.err 0.52=
%)
> > [...]
> > Linux build with -j12, init_on_alloc=3D1: +0.57% sys time (st.err 0.40%=
)
>
> Any idea why there is such a massive difference here? This seems to
> high just for cache-locality effects of touching all the freed pages.
I've measured a single `make -j12` again under perf stat.

The numbers for init_on_alloc=3D1 were:

        4936513177      cache-misses              #    8.056 % of all
cache refs      (44.44%)
       61278262461      cache-references
               (44.45%)
          42844784      page-faults
     1449630221347      L1-dcache-loads
               (44.45%)
       50569965485      L1-dcache-load-misses     #    3.49% of all
L1-dcache hits    (44.44%)
      299987258588      L1-icache-load-misses
               (44.44%)
     1449857258648      dTLB-loads
               (44.45%)
         826292490      dTLB-load-misses          #    0.06% of all
dTLB cache hits   (44.44%)
       22028472701      iTLB-loads
               (44.44%)
         858451905      iTLB-load-misses          #    3.90% of all
iTLB cache hits   (44.45%)
     162.120107145 seconds time elapsed

, and for init_on_free=3D1:

        6666716777      cache-misses              #   10.862 % of all
cache refs      (44.45%)
       61378258434      cache-references
               (44.46%)
          42850913      page-faults
     1449986416063      L1-dcache-loads
               (44.45%)
       51277338771      L1-dcache-load-misses     #    3.54% of all
L1-dcache hits    (44.45%)
      298295905805      L1-icache-load-misses
               (44.44%)
     1450378031344      dTLB-loads
               (44.43%)
         807011341      dTLB-load-misses          #    0.06% of all
dTLB cache hits   (44.44%)
       22044976638      iTLB-loads
               (44.44%)
         846377845      iTLB-load-misses          #    3.84% of all
iTLB cache hits   (44.45%)
     164.427054893 seconds time elapsed


(note that we don't see the speed difference under perf)

init_on_free=3D1 causes 1.73B more cache misses than init_on_alloc=3D1.
If I'm understanding correctly, a cache miss costs 12-14 cycles on my
3GHz Skylake CPU, which can explain explain a 7-8-second difference
between the two modes.
But as I just realized this is both kernel and userspace, so while the
difference is almost correct for wall time (120s for init_on_alloc,
130s for init_on_free) this doesn't tell much about the time spent in
the kernel.

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
