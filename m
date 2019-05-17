Return-Path: <kernel-hardening-return-15947-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0A2A0219E3
	for <lists+kernel-hardening@lfdr.de>; Fri, 17 May 2019 16:39:21 +0200 (CEST)
Received: (qmail 1190 invoked by uid 550); 17 May 2019 14:39:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1172 invoked from network); 17 May 2019 14:39:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ddYknnyy251jUXjF119a2VyFqAoO0MJ7lwXqU8aG9CY=;
        b=ZfCTHd4njmwJ6LmyMIrWpboajTklaeBflvOkckUG57zSTiCO9V6zZ/F4wxPdk/qNUQ
         PVYMluJEt88jyugSzqc0nG7UZR7DLvqpFQzEFftB05/78KyrZltNrXCTTPfD64+BZVrD
         petSewDBThIM52+IEcDFxCTrwU4XGvwQzXx2OnY7RGaGl7FzEu9k9MeOMqSnQQ9BAkCW
         oGVCwrkpIb4glulSXJTh+pRPJrqZboKu7VuIf2urRTJSx9c6Q/Pq/jAHZhhJ81Od6+24
         +t1zJKIIPbGUXy6ajnaWTV/1OoHtLOlwMLRNj475X7xcV2GizLUQNcqPSE4CshTe69LP
         g0xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ddYknnyy251jUXjF119a2VyFqAoO0MJ7lwXqU8aG9CY=;
        b=KR5Pyse7fFIJW5ulx2ZHDH9CoL6AjYxOQEK0J5Rvce+zMohXRjjGMKrnjR0BNX+cmw
         LT5p2TU6RNWCW+xuFhcjcrNdeM6Dvkr3robNFLVTCf0nUW1OhpKFPsvsiKioG/EfLnLR
         FnrsKEHZMBqNmucE36yJ4KwWUywin/L5ELG7i3m87tEp0KzYYda5b5OF87IVlF+Cark+
         WF8SaMarEgDm6Gvwo42FSzooK7RgUn/fZXDbrpw99FmA9G3PzNjAWxzStez0zFZp8aP+
         a3njfVeyZbc2wze8MbDAmf5ziSS7AMjYsQJ3rbvHXxTUE8qFjvxUNw7Ml6yMy0mzOdaJ
         gh0w==
X-Gm-Message-State: APjAAAUdTF3W7J+XLwz0ZEUdypbW1SEWMMXj2ZIUpjKTd1jzAJLYT2qy
	Bwm/HajYYcW9wkt41qm69mztXPTNp93BWhPDXu6yow==
X-Google-Smtp-Source: APXvYqzmJFfH7vnjyDXwEt0PEao3F5jTjrlEKGaCN9GO7PVaS+H8433b6AZMGQxWDooobwXiz1H5CeN39cIPFc6Nv50=
X-Received: by 2002:a1f:ae4b:: with SMTP id x72mr2631730vke.29.1558103943898;
 Fri, 17 May 2019 07:39:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190514143537.10435-1-glider@google.com> <20190514143537.10435-2-glider@google.com>
 <201905161824.63B0DF0E@keescook>
In-Reply-To: <201905161824.63B0DF0E@keescook>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 17 May 2019 16:38:51 +0200
Message-ID: <CAG_fn=U-8XiBVRDhr9QxLj0Yj+1ud41KvmUqEt9Gih9MAznuPw@mail.gmail.com>
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

On Fri, May 17, 2019 at 3:26 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Tue, May 14, 2019 at 04:35:34PM +0200, Alexander Potapenko wrote:
> > [...]
> > diff --git a/mm/slab.h b/mm/slab.h
> > index 43ac818b8592..24ae887359b8 100644
> > --- a/mm/slab.h
> > +++ b/mm/slab.h
> > @@ -524,4 +524,20 @@ static inline int cache_random_seq_create(struct k=
mem_cache *cachep,
> > [...]
> > +static inline bool slab_want_init_on_free(struct kmem_cache *c)
> > +{
> > +     if (static_branch_unlikely(&init_on_free))
> > +             return !(c->ctor);
>
> BTW, why is this checking for c->ctor here? Shouldn't it not matter for
> the free case?
It does matter, see e.g. the handling of __OBJECT_POISON in slub.c
If we just return true here, the kernel crashes.
> > +     else
> > +             return false;
> > +}
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
