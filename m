Return-Path: <kernel-hardening-return-19186-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D53F520C655
	for <lists+kernel-hardening@lfdr.de>; Sun, 28 Jun 2020 08:00:53 +0200 (CEST)
Received: (qmail 22215 invoked by uid 550); 28 Jun 2020 06:00:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22181 invoked from network); 28 Jun 2020 06:00:45 -0000
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com 05S60Pt9004020
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
	s=dec2015msa; t=1593324027;
	bh=0Adi9oEkoNL+VTKk8ereW4+c8tkNY7OySZ7YBSe/YKA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=djQ8GNcZ6OaJRd6KZriIuFLm4oHwO98Z73bgyDkIIGwgMeV9ji3d+fUDWbfZpHd9L
	 yS3k8arpc4oL8YK+PkqqoLv8VIHIfH52qjvHJTVcl80p6bmftr3aPtwDq6K/0hYCsw
	 R16OHZajjQ/Q/h+txtb1JIFlNQo4Ir+Z0V8g7Wpfcu9xkEPqtEX3Hm/QwnggCfXxAI
	 DAe70KRDRgEDP+41rG2Xnl2wIo1Mhd/wfKuMfcrX2UyiT/bY3CbVMmAsf4Kz2PhX3X
	 cNiIoQBd4KhuLUw/7fAhc3XRXuXoRVx3ttTybTW+yPKC/+cRHgEcyEbNDQ4FYHtaNb
	 j4aoLZBOrCWew==
X-Nifty-SrcIP: [209.85.217.41]
X-Gm-Message-State: AOAM530bwQ8THkAVbp2xZrLSumCv04b55Ei9So/oeB7ZKVipvy2wwja/
	H8pe379LvxC0sKUmFGvvh/oiVLoUCapA7Sv4Xes=
X-Google-Smtp-Source: ABdhPJxgrePNlmZbq4ODpdCqz51OGKwCFn/JnfhPPtPIn9WGJz+XI26wgi75kbSCrE2XC7QDCT/X8jAgUv6zb+cIVPk=
X-Received: by 2002:a67:22c7:: with SMTP id i190mr7470079vsi.179.1593324024627;
 Sat, 27 Jun 2020 23:00:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200213122410.1605-1-masahiroy@kernel.org> <202002251057.C4E397A@keescook>
In-Reply-To: <202002251057.C4E397A@keescook>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Sun, 28 Jun 2020 14:59:47 +0900
X-Gmail-Original-Message-ID: <CAK7LNASw0YT8_itaa0OeZi8toV1TUj6EKCMbg6rchdYub0cgww@mail.gmail.com>
Message-ID: <CAK7LNASw0YT8_itaa0OeZi8toV1TUj6EKCMbg6rchdYub0cgww@mail.gmail.com>
Subject: Re: [PATCH] gcc-plugins: fix gcc-plugins directory path in documentation
To: Kees Cook <keescook@chromium.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Emese Revfy <re.emese@gmail.com>,
        Michal Marek <michal.lkml@markovi.net>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Feb 26, 2020 at 3:58 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Feb 13, 2020 at 09:24:10PM +0900, Masahiro Yamada wrote:
> > Fix typos "plgins" -> "plugins".
> >
> > Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
>
> Thanks!
>
> Acked-by: Kees Cook <keescook@chromium.org>
>
> Jon, can you take this?

I noticed this patch had fallen into a crack.

Applied to linux-kbuild now.
Thanks.





> -Kees
>
> > ---
> >
> >  Documentation/kbuild/reproducible-builds.rst | 2 +-
> >  scripts/gcc-plugins/Kconfig                  | 2 +-
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/kbuild/reproducible-builds.rst b/Documentation/kbuild/reproducible-builds.rst
> > index 503393854e2e..3b25655e441b 100644
> > --- a/Documentation/kbuild/reproducible-builds.rst
> > +++ b/Documentation/kbuild/reproducible-builds.rst
> > @@ -101,7 +101,7 @@ Structure randomisation
> >
> >  If you enable ``CONFIG_GCC_PLUGIN_RANDSTRUCT``, you will need to
> >  pre-generate the random seed in
> > -``scripts/gcc-plgins/randomize_layout_seed.h`` so the same value
> > +``scripts/gcc-plugins/randomize_layout_seed.h`` so the same value
> >  is used in rebuilds.
> >
> >  Debug info conflicts
> > diff --git a/scripts/gcc-plugins/Kconfig b/scripts/gcc-plugins/Kconfig
> > index e3569543bdac..7b63c819610c 100644
> > --- a/scripts/gcc-plugins/Kconfig
> > +++ b/scripts/gcc-plugins/Kconfig
> > @@ -86,7 +86,7 @@ config GCC_PLUGIN_RANDSTRUCT
> >         source tree isn't cleaned after kernel installation).
> >
> >         The seed used for compilation is located at
> > -       scripts/gcc-plgins/randomize_layout_seed.h.  It remains after
> > +       scripts/gcc-plugins/randomize_layout_seed.h.  It remains after
> >         a make clean to allow for external modules to be compiled with
> >         the existing seed and will be removed by a make mrproper or
> >         make distclean.
> > --
> > 2.17.1
> >
>
> --
> Kees Cook



--
Best Regards

Masahiro Yamada
