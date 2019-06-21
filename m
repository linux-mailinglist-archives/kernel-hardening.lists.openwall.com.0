Return-Path: <kernel-hardening-return-16214-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6F09D4EBED
	for <lists+kernel-hardening@lfdr.de>; Fri, 21 Jun 2019 17:24:52 +0200 (CEST)
Received: (qmail 32051 invoked by uid 550); 21 Jun 2019 15:24:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32030 invoked from network); 21 Jun 2019 15:24:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=amUyKy/Lgb0XxSBaEjjhtM0Eo45SjaPoxv+deIw86VE=;
        b=Orrh03bfO4aJYjMke+4LWCWkC5w7vaywjOm7sMgTDaogBQJkmp4uomtEoruNeHvXd2
         wrFFjNZjkg9BjWHJ022RdUhZHglEuVmdtxZhRx0tOMqawEIBURchGPgfPlRj+a8uxPhP
         JX7n4iiDXIP+0JEApmdlwKD/3M2IK7LKVFDrSVbORdw5UYpwP33WvmSo1xgIQ1mF8URV
         CpjrlFZib0+riIcxhJsF+r9Q6aor+CUCS5+r6W5oWWyhoNk2kahaBYe+zmaLbLSfArA9
         tIFjs3SCWMUiX9Z3BF0xEM+M/Z+AdXOT++bJRk7DdW0a9XEcD1YrbOeecsxWtuTYKrTv
         5l5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=amUyKy/Lgb0XxSBaEjjhtM0Eo45SjaPoxv+deIw86VE=;
        b=hPTaZnYd6ir4SVVPYn/KqRts+jaFC8ASCyL8XiZfKje3Xui7PiVW8XrpzwaYTAyYq8
         aL2ZsxYm9BDiMNeJkmRSn8roHpF4pITj5PzoRgja/JJm1vfAuPrf09aVlte+A2D3KMXC
         ehBdRLedvpcYpwyZGYwbXdhVstQE+xnNvSC4PeJhcs2MDWpRhu3F0KD7ABp/NIg79a34
         gU/8ymMmvWdnMwzAuDLW9fjatJZ+2xyJeuCGAiD/oEV0XsnR0jEWGpvHz0/CLZ3T19N4
         iLSVlyprsjNKsyecxtL86TOFCaQOr2BENccxMu275vG/rkQEcYLchJet1c0VNvgRmvYA
         n8fg==
X-Gm-Message-State: APjAAAVE21fj/DtIoF/na8k+0KvXV1fUL4HApsg3N1vGvGhhHKz838fC
	0JzI3f6blcDnUlEnlINeQaQjEXTOhFL++6ADmlTE/A==
X-Google-Smtp-Source: APXvYqya9eZAEQgsoWb9uXlO3KmWacfsgpndqCO4dX8FLhHaJ4fELI+m+POxQSeCWNXsEFT6mpjddhLn9tBh04jJ7r0=
X-Received: by 2002:ab0:30a3:: with SMTP id b3mr12857232uam.3.1561130673280;
 Fri, 21 Jun 2019 08:24:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190617151050.92663-1-glider@google.com> <20190617151050.92663-2-glider@google.com>
 <20190621070905.GA3429@dhcp22.suse.cz> <CAG_fn=UFj0Lzy3FgMV_JBKtxCiwE03HVxnR8=f9a7=4nrUFXSw@mail.gmail.com>
 <CAG_fn=W90HNeZ0UcUctnbUBzJ=_b+gxMGdUoDyO3JPoyy4dGSg@mail.gmail.com> <20190621151210.GF3429@dhcp22.suse.cz>
In-Reply-To: <20190621151210.GF3429@dhcp22.suse.cz>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 21 Jun 2019 17:24:21 +0200
Message-ID: <CAG_fn=W2fm5zkAUW8PcTYpfH57H89ukFGAoBHUOmyM-S1agdZg@mail.gmail.com>
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

On Fri, Jun 21, 2019 at 5:12 PM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Fri 21-06-19 16:10:19, Alexander Potapenko wrote:
> > On Fri, Jun 21, 2019 at 10:57 AM Alexander Potapenko <glider@google.com=
> wrote:
> [...]
> > > > > diff --git a/mm/dmapool.c b/mm/dmapool.c
> > > > > index 8c94c89a6f7e..e164012d3491 100644
> > > > > --- a/mm/dmapool.c
> > > > > +++ b/mm/dmapool.c
> > > > > @@ -378,7 +378,7 @@ void *dma_pool_alloc(struct dma_pool *pool, g=
fp_t mem_flags,
> > > > >  #endif
> > > > >       spin_unlock_irqrestore(&pool->lock, flags);
> > > > >
> > > > > -     if (mem_flags & __GFP_ZERO)
> > > > > +     if (want_init_on_alloc(mem_flags))
> > > > >               memset(retval, 0, pool->size);
> > > > >
> > > > >       return retval;
> > > >
> > > > Don't you miss dma_pool_free and want_init_on_free?
> > > Agreed.
> > > I'll fix this and add tests for DMA pools as well.
> > This doesn't seem to be easy though. One needs a real DMA-capable
> > device to allocate using DMA pools.
> > On the other hand, what happens to a DMA pool when it's destroyed,
> > isn't it wiped by pagealloc?
>
> Yes it should be returned to the page allocator AFAIR. But it is when we
> are returning an object to the pool when you want to wipe the data, no?
My concern was that dma allocation is something orthogonal to heap and
page allocator.
I also don't know how many other allocators are left overboard, e.g.
we don't do anything to lib/genalloc.c yet.

> Why cannot you do it along the already existing poisoning?
I can sure keep these bits.
Any idea how the correct behavior of dma_pool_alloc/free can be tested?
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
