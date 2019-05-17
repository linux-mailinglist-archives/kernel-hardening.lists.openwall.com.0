Return-Path: <kernel-hardening-return-15942-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6952121962
	for <lists+kernel-hardening@lfdr.de>; Fri, 17 May 2019 15:51:17 +0200 (CEST)
Received: (qmail 18128 invoked by uid 550); 17 May 2019 13:51:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 18100 invoked from network); 17 May 2019 13:51:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Tu/XZ8WyPQtcgBo1xp6f5SWrU4YW1BvieV2uRJevOns=;
        b=rHgPeR5EkFNJw0Y3h/Mnc5B3YIjO3Y1YYz70lHZ/6bNSNruCgaPJ0q8vYl/adsMLdX
         6iGuqKG17GHfn8zZ2HIXYYhWBfrZgQINJdBu+zSuSI9NwS65IwehTsTyUc7/3k8Vkglr
         O5/HdvT3rb5yihdqKcJ/D87syAkfpLR+oHBxCN3SDwir5YfLhI9mTTRDGvX5uO9vf31h
         1ivJ+m9a+DiI3PIwR23gsHmVNAamQVcnymqpKtqNP8EGv7pM7MT36U/02a40FBAIJekh
         8SHU3k8q5I4KA/DxLizSAy0Q2nPp9H+6y9jFSYcJK/6tZ9gjsyCiX0i4aSlumrcdhjy4
         nyIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Tu/XZ8WyPQtcgBo1xp6f5SWrU4YW1BvieV2uRJevOns=;
        b=MB8My25em9Zb/GQmCkIFClAr1hyf17jNGF0bH9syibhQi9fgxxYNj3N23MOh6S3qW+
         YgEXYDp54dtRrdVb/r7Jxj9h8eSih5cfz5a6RXEUi6WM0oWRXLpJb0tDDXyVMEKrftTw
         A54NmlNFJ9hHv8oGpsSiWwUG8X5XhCLBhgx3KTpQGk475FCnf0iQp2PiRNjcBEpu28ZJ
         EOxeetdwjkxFcuRdzo61e98CCBw1/wNBFhToH0AuTSAkoE21mD/we3TkA8wt26yyEQDb
         Vb/48fMU3M1SYV+QxdfVcxdvDMXg2W2hpDGdDCHVfhmYR1gYejM6WeRmeHMucX2YbqEK
         3blw==
X-Gm-Message-State: APjAAAW8Qpyj0v8haNfHhYp5inmCczmLh9FwcAbg+C/jnugxZzSnmHGq
	sdYZS/7jU4QTq6b9rxVYa/hVa8++ctE8cDHHVBezJQ==
X-Google-Smtp-Source: APXvYqz/GeQC7brtsyxMaawY3Pnb522oTj0eF7F0BnKqrc45R8aoK2BmfjgDo8jGr/SCpZm4mSpV/UmZRTjKjXaJ8tI=
X-Received: by 2002:a67:7241:: with SMTP id n62mr4234300vsc.217.1558101057477;
 Fri, 17 May 2019 06:50:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190514143537.10435-1-glider@google.com> <20190514143537.10435-5-glider@google.com>
 <201905160923.BD3E530EFC@keescook> <201905161714.A53D472D9@keescook> <CAG_fn=Vj6Jk_DY_-0+x6EpbsVh+abpEVcjycBhJxeMH3wuy9rw@mail.gmail.com>
In-Reply-To: <CAG_fn=Vj6Jk_DY_-0+x6EpbsVh+abpEVcjycBhJxeMH3wuy9rw@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 17 May 2019 15:50:45 +0200
Message-ID: <CAG_fn=VqXVEi_W0VDpZKYgBh831JADPRFPRmYR=1ApfuO+7HQw@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] net: apply __GFP_NO_AUTOINIT to AF_UNIX sk_buff allocations
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

On Fri, May 17, 2019 at 10:49 AM Alexander Potapenko <glider@google.com> wr=
ote:
>
> On Fri, May 17, 2019 at 2:26 AM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Thu, May 16, 2019 at 09:53:01AM -0700, Kees Cook wrote:
> > > On Tue, May 14, 2019 at 04:35:37PM +0200, Alexander Potapenko wrote:
> > > > Add sock_alloc_send_pskb_noinit(), which is similar to
> > > > sock_alloc_send_pskb(), but allocates with __GFP_NO_AUTOINIT.
> > > > This helps reduce the slowdown on hackbench in the init_on_alloc mo=
de
> > > > from 6.84% to 3.45%.
> > >
> > > Out of curiosity, why the creation of the new function over adding a
> > > gfp flag argument to sock_alloc_send_pskb() and updating callers? (Th=
ere
> > > are only 6 callers, and this change already updates 2 of those.)
> > >
> > > > Slowdown for the initialization features compared to init_on_free=
=3D0,
> > > > init_on_alloc=3D0:
> > > >
> > > > hackbench, init_on_free=3D1:  +7.71% sys time (st.err 0.45%)
> > > > hackbench, init_on_alloc=3D1: +3.45% sys time (st.err 0.86%)
> >
> > So I've run some of my own wall-clock timings of kernel builds (which
> > should be an pretty big "worst case" situation, and I see much smaller
> > performance changes:
> How many cores were you using? I suspect the numbers may vary a bit
> depending on that.
> > everything off
> >         Run times: 289.18 288.61 289.66 287.71 287.67
> >         Min: 287.67 Max: 289.66 Mean: 288.57 Std Dev: 0.79
> >                 baseline
> >
> > init_on_alloc=3D1
> >         Run times: 289.72 286.95 287.87 287.34 287.35
> >         Min: 286.95 Max: 289.72 Mean: 287.85 Std Dev: 0.98
> >                 0.25% faster (within the std dev noise)
> >
> > init_on_free=3D1
> >         Run times: 303.26 301.44 301.19 301.55 301.39
> >         Min: 301.19 Max: 303.26 Mean: 301.77 Std Dev: 0.75
> >                 4.57% slower
> >
> > init_on_free=3D1 with the PAX_MEMORY_SANITIZE slabs excluded:
> >         Run times: 299.19 299.85 298.95 298.23 298.64
> >         Min: 298.23 Max: 299.85 Mean: 298.97 Std Dev: 0.55
> >                 3.60% slower
> >
> > So the tuning certainly improved things by 1%. My perf numbers don't
> > show the 24% hit you were seeing at all, though.
> Note that 24% is the _sys_ time slowdown. The wall time slowdown seen
> in this case was 8.34%
I've collected more stats running QEMU with different numbers of cores.
The slowdown values of init_on_free compared to baseline are:
2 CPUs - 5.94% for wall time (20.08% for sys time)
6 CPUs - 7.43% for wall time (23.55% for sys time)
12 CPUs - 8.41% for wall time (24.25% for sys time)
24 CPUs - 9.49% for wall time (17.98% for sys time)

I'm building a defconfig of some fixed KMSAN tree with Clang, but that
shouldn't matter much.

> > > In the commit log it might be worth mentioning that this is only
> > > changing the init_on_alloc case (in case it's not already obvious to
> > > folks). Perhaps there needs to be a split of __GFP_NO_AUTOINIT into
> > > __GFP_NO_AUTO_ALLOC_INIT and __GFP_NO_AUTO_FREE_INIT? Right now
> > > __GFP_NO_AUTOINIT is only checked for init_on_alloc:
> >
> > I was obviously crazy here. :) GFP isn't present for free(), but a SLAB
> > flag works (as was done in PAX_MEMORY_SANITIZE). I'll send the patch I
> > used for the above timing test.
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



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
