Return-Path: <kernel-hardening-return-16042-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 15DF332CCA
	for <lists+kernel-hardening@lfdr.de>; Mon,  3 Jun 2019 11:25:20 +0200 (CEST)
Received: (qmail 7692 invoked by uid 550); 3 Jun 2019 09:25:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7674 invoked from network); 3 Jun 2019 09:25:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=w8FJ04SPncA3GGt4qcZJVbuvO4+vsSKpHoksXqQuYUI=;
        b=OMLIbGGF4iqU/3IBxXXOo51Z1Gh2iX+jT/XJanv3y/0Mlanl8zJA2fHTPptaNqwAy/
         wCPISvYJLg8glT89EOkSCGrUEwLbQNGSsPQB3xP0gjI7Qnoj9v/0iNfgM4mS6UVs1cdI
         ASiojU2tdAvCieLPAYfFUbKUwAx39XfYmeDORSJzdkuJ3vkYOm8FZf+sap+UctIi5Inl
         AgNqY79mVOQvJbxNLvSndWErvOsmI5+gxjsaG/j0cl6rh4ldiKUw56A3oejSuCOFbFTv
         5Lkaj44XlpdgfkLJZbb89pa8zO7s4vqoneWdvi7fIrUzKI7kgDAV+syf1sGfWPpsVjG/
         PAzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=w8FJ04SPncA3GGt4qcZJVbuvO4+vsSKpHoksXqQuYUI=;
        b=p608CQMTXQVepohPLKBvRzKLWdPwS3HSAD5QrQQT7AreBd7KHbOs5QySg7ZCapoLv3
         aBVgvhbi/IavHHB1VroxGxK4e7UebhGPVe8gVhB/NZuM7f6ocnNrmdH8Eexu1K079ssf
         b3C2DRa2+pM+tvoGWgFHVS8uWSPrW8/TKBF46Wl0Tl23aMInGcIS8ArvXJvJlEUqFia5
         k7Mnt3Zis4Mt8i8rENmIxwTB3ZZnULXWZ9nW1nBRKfBz2MFU93uBBB3ybL3ocb3mjlf2
         65lZtm1e07TeN6MRkwwBizlDs66krWtFqKzRxdVInKjO/DTQOu7x/2wmbva/egS+4AwU
         4ztg==
X-Gm-Message-State: APjAAAVTVd7dKoYBbS7fvBIjYtxilm9Tt+iVTchsDmr/AvKfJZpOE6I+
	yn6gCfKYnTbjhgeswVJpOMNyMw+7LnjbyOGUdeEqkg==
X-Google-Smtp-Source: APXvYqyh6QlCEo0EU+R0uj2OfHoB0V/HJYqXE1klW7h8DXFh/JtB716lws+dopD6Xp86RJPH8UG3RqT+AAiUP3DAyxA=
X-Received: by 2002:ab0:c11:: with SMTP id a17mr8422532uak.3.1559553901030;
 Mon, 03 Jun 2019 02:25:01 -0700 (PDT)
MIME-Version: 1.0
References: <20190529123812.43089-1-glider@google.com> <20190529123812.43089-3-glider@google.com>
 <20190531181832.e7c3888870ce9e50db9f69e6@linux-foundation.org>
In-Reply-To: <20190531181832.e7c3888870ce9e50db9f69e6@linux-foundation.org>
From: Alexander Potapenko <glider@google.com>
Date: Mon, 3 Jun 2019 11:24:49 +0200
Message-ID: <CAG_fn=XBq-ipvZng3hEiGwyQH2rRNFbN_Cj0r+5VoJqou0vovA@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] mm: init: report memory auto-initialization
 features at boot time
To: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>
Cc: Christoph Lameter <cl@linux.com>, Dmitry Vyukov <dvyukov@google.com>, James Morris <jmorris@namei.org>, 
	Jann Horn <jannh@google.com>, Kostya Serebryany <kcc@google.com>, Laura Abbott <labbott@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, 
	Matthew Wilcox <willy@infradead.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Sandeep Patil <sspatil@android.com>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Souptick Joarder <jrdr.linux@gmail.com>, Marco Elver <elver@google.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux Memory Management List <linux-mm@kvack.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 1, 2019 at 3:18 AM Andrew Morton <akpm@linux-foundation.org> wr=
ote:
>
> On Wed, 29 May 2019 14:38:11 +0200 Alexander Potapenko <glider@google.com=
> wrote:
>
> > Print the currently enabled stack and heap initialization modes.
> >
> > The possible options for stack are:
> >  - "all" for CONFIG_INIT_STACK_ALL;
> >  - "byref_all" for CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL;
> >  - "byref" for CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF;
> >  - "__user" for CONFIG_GCC_PLUGIN_STRUCTLEAK_USER;
> >  - "off" otherwise.
> >
> > Depending on the values of init_on_alloc and init_on_free boottime
> > options we also report "heap alloc" and "heap free" as "on"/"off".
>
> Why?
>
> Please fully describe the benefit to users so that others can judge the
> desirability of the patch.  And so they can review it effectively, etc.
I'm going to update the description with the following passage:

    Print the currently enabled stack and heap initialization modes.

    Stack initialization is enabled by a config flag, while heap
    initialization is configured at boot time with defaults being set
    in the config. It's more convenient for the user to have all informatio=
n
    about these hardening measures in one place.

Does this make sense?
> Always!
>
> > In the init_on_free mode initializing pages at boot time may take some
> > time, so print a notice about that as well.
>
> How much time?
I've seen pauses up to 1 second, not actually sure they're worth a
separate line in the log.
Kees, how long were the delays in your case?



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
