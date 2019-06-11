Return-Path: <kernel-hardening-return-16100-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id DBBB1416E4
	for <lists+kernel-hardening@lfdr.de>; Tue, 11 Jun 2019 23:28:27 +0200 (CEST)
Received: (qmail 12144 invoked by uid 550); 11 Jun 2019 21:28:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 12110 invoked from network); 11 Jun 2019 21:28:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yfYsg0/cES0OHcG6fX5W9snm90ggOgAM9kXY3QBEhu4=;
        b=uikxw7UtyOptEVyjeY2qK4xy247KZZSlixb4FYF44cy5IOYuGfhYNz0auK7eAN3lSf
         RDykMi53c/UWnKOss3Gbf99f02SgcsLInyU9jZT7mZ9OHg9hKC6fNrTncVfEUwMvFzyT
         LcQoyh1B+GWH1wcVdCBdLQqRjW9xbNzL/XHVXJwKNd+h41OfOLBnxXrK/w2EGMY7Sdql
         Ev+iISe8afAaHYadIsKtGIEgMDX6CnpwHgbsBe+aUSzQIjTpiqosNwjLo3ub7MMP5bSh
         sv6W0b+fg0PHcDLs3IdJMwn13c7joqsHqAOaS3kYpN0/uUkfhOoBhUB3X+c5vOw3dtMp
         LbTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yfYsg0/cES0OHcG6fX5W9snm90ggOgAM9kXY3QBEhu4=;
        b=Ijy8kA9t9+MigsqBQ/XTYMYLUzr/IulswyT2U3auDnlFKNqFK0yH2tEfmRenam+Be+
         7xji7mHSpYy6rgiiWQcjPaQvoVcjfVfS9iAH63cZIsyrt5H026P2gs3qpuogD2tidXLm
         rmH10qyEuhCV/jMS0vqUeCYenr66jlfDBZmKEstP3b/Xc8m96fFDUxMqd2HaVEDqTV+W
         wLE7hx0CATMYjqlRN7GQGuxtjJW9EIaJfhknDV4uADLVBO6pyS4gYlx9wU7w5pg8ZnPZ
         elH6vACRyfxa76hs8xUCqbE0Vi4AMb67GIkolLFXMcX44J00gmWJPrut7+Q5o3sr0Mhn
         QVmQ==
X-Gm-Message-State: APjAAAWCOyaVIPzeWPnPNN0FM0cgW3SaxhItpMUUaknoJdxBAjfDY41W
	uo8JzvLyuHNoo+B19fXhizctaULD1BhqhHZjMbo=
X-Google-Smtp-Source: APXvYqwZE6DuGW97Wtdkbau380s5wncliqmuWNA2I8e3nRFVHn0Gyt7oiNVh7GBK4ctz/0QIVrifVcW0qHRMDnaPYKk=
X-Received: by 2002:a9d:7b43:: with SMTP id f3mr18847440oto.337.1560288490020;
 Tue, 11 Jun 2019 14:28:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190611193836.2772-1-shyam.saini@amarulasolutions.com>
 <20190611134831.a60c11f4b691d14d04a87e29@linux-foundation.org>
 <6DCAE4F8-3BEC-45F2-A733-F4D15850B7F3@dilger.ca> <20190611140907.899bebb12a3d731da24a9ad1@linux-foundation.org>
In-Reply-To: <20190611140907.899bebb12a3d731da24a9ad1@linux-foundation.org>
From: Shyam Saini <mayhs11saini@gmail.com>
Date: Wed, 12 Jun 2019 02:57:58 +0530
Message-ID: <CAOfkYf5_HTN1HO0gQY9iGchK5Anf6oVx7knzMhL1hWpv4gV20Q@mail.gmail.com>
Subject: Re: [PATCH V2] include: linux: Regularise the use of FIELD_SIZEOF macro
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Dilger <adilger@dilger.ca>, Shyam Saini <shyam.saini@amarulasolutions.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-kernel <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, 
	linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
	intel-gvt-dev@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
	dri-devel <dri-devel@lists.freedesktop.org>, 
	Network Development <netdev@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>, 
	devel@lists.orangefs.org, linux-mm <linux-mm@kvack.org>, linux-sctp@vger.kernel.org, 
	bpf <bpf@vger.kernel.org>, kvm@vger.kernel.org, 
	Alexey Dobriyan <adobriyan@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Hi Andrew,

>
> On Tue, 11 Jun 2019 15:00:10 -0600 Andreas Dilger <adilger@dilger.ca> wrote:
>
> > >> to FIELD_SIZEOF
> > >
> > > As Alexey has pointed out, C structs and unions don't have fields -
> > > they have members.  So this is an opportunity to switch everything to
> > > a new member_sizeof().
> > >
> > > What do people think of that and how does this impact the patch footprint?
> >
> > I did a check, and FIELD_SIZEOF() is used about 350x, while sizeof_field()
> > is about 30x, and SIZEOF_FIELD() is only about 5x.
>
> Erk.  Sorry, I should have grepped.
>
> > That said, I'm much more in favour of "sizeof_field()" or "sizeof_member()"
> > than FIELD_SIZEOF().  Not only does that better match "offsetof()", with
> > which it is closely related, but is also closer to the original "sizeof()".
> >
> > Since this is a rather trivial change, it can be split into a number of
> > patches to get approval/landing via subsystem maintainers, and there is no
> > huge urgency to remove the original macros until the users are gone.  It
> > would make sense to remove SIZEOF_FIELD() and sizeof_field() quickly so
> > they don't gain more users, and the remaining FIELD_SIZEOF() users can be
> > whittled away as the patches come through the maintainer trees.
>
> In that case I'd say let's live with FIELD_SIZEOF() and remove
> sizeof_field() and SIZEOF_FIELD().
>
> I'm a bit surprised that the FIELD_SIZEOF() definition ends up in
> stddef.h rather than in kernel.h where such things are normally
> defined.  Why is that?

Thanks for pointing out this, I was not aware if this is a convention.
Anyway, I'll keep FIELD_SIZEOF definition in kernel.h in next version.
