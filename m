Return-Path: <kernel-hardening-return-16288-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3B96158323
	for <lists+kernel-hardening@lfdr.de>; Thu, 27 Jun 2019 15:09:37 +0200 (CEST)
Received: (qmail 3301 invoked by uid 550); 27 Jun 2019 13:09:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3283 invoked from network); 27 Jun 2019 13:09:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+GEy0GowFU+uQq8TtB0z8xaih9ptN5Q3IEiqpuelFDs=;
        b=EMPAztyeJD8w4tcBaVeombkZujMeYNTsJ7eaSZC9f/YoNsl84xyhDO4M73FyMmjA/x
         t5N4V/SYNJGu8aRCWbdfkZuL0gmN6Wgsx5IiESN3D5cmEWh1+qccSYhaDxN/fjQrz5Jj
         Cmx2Loy9qjuSXQ4c1Xk6qnfHtYBKzCGdneCzQmv777wUvbWV+GjeS64FIN8TGVu5kjI3
         cB8Y4DCxGroHXSrRmB1f6VKjKprKpC5G6gqTdPHTtnquOGPC1Bg5sg8J02NNcNrwL5Ku
         Y7AExdNBks6Anahq3UGPKqAJm/MXezvkzfSwn+pSQixXTQgFZClv7wnEHCzFUPX1MZUn
         6o4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+GEy0GowFU+uQq8TtB0z8xaih9ptN5Q3IEiqpuelFDs=;
        b=GjSTHfW74Wuf11K9/PaTFiil1DegAW1GnzuGZh7l3Fe2wlMt6dKNnnMRbkyRNx8ToS
         ImFgYcM8/RoZr1TE16PZB9A8ClbM76diSV2S5qM/SIhNeUUosYfIoXur9Ne3BjE90awn
         iGNMLHR9TX/ssWQCjkEfuhKOrv7lEZgKKaGDeq6xrjfho8HA/30hMO2uRqfbi5qyvLql
         aObTN3d67eVZfS1DY4oLhnVnF9wmcoq7YgBFxYR6lovEWaKJ/Y9/jChb0gvDNVfFvFnR
         iUBVxMfbso5yqL69J7Zo3nlyWTO/39wzel5ZkpULrLZNX0gQ/07HL/kym65ySWa1FTGA
         bxzA==
X-Gm-Message-State: APjAAAUsv5nNPWQhreR48+WW5rv8PxK45+9Qk986dUXz+eDb2+dYU1jm
	YL6uVH0gnRn1Jbnyvh0gdQRhW1DWpiYhdrj0KhU9Hw==
X-Google-Smtp-Source: APXvYqyybVeF02FV7oyRIEy9deXhVNP2OXv1ccgGnq0QB34Ix3HStMP+1vnMzbMN3do7c59wTe80K7fkjXUNi2zvrCQ=
X-Received: by 2002:ab0:3d2:: with SMTP id 76mr2215849uau.12.1561640958978;
 Thu, 27 Jun 2019 06:09:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190626121943.131390-1-glider@google.com> <20190626121943.131390-2-glider@google.com>
 <20190626144943.GY17798@dhcp22.suse.cz> <CAG_fn=Xf5yEuz7JyOt-gmNx1uSM6mmM57_jFxCi+9VPZ4PSwJQ@mail.gmail.com>
 <20190626154237.GZ17798@dhcp22.suse.cz>
In-Reply-To: <20190626154237.GZ17798@dhcp22.suse.cz>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 27 Jun 2019 15:09:06 +0200
Message-ID: <CAG_fn=V4SZwu50LCZq+2Fa-zAZmQ+X-80vxzN-MGJZdjpFpjhw@mail.gmail.com>
Subject: Re: [PATCH v8 1/2] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, 
	Kees Cook <keescook@chromium.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, 
	Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, Marco Elver <elver@google.com>, Qian Cai <cai@lca.pw>, 
	Linux Memory Management List <linux-mm@kvack.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2019 at 5:42 PM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Wed 26-06-19 17:00:43, Alexander Potapenko wrote:
> > On Wed, Jun 26, 2019 at 4:49 PM Michal Hocko <mhocko@kernel.org> wrote:
> [...]
> > > > @@ -1142,6 +1200,8 @@ static __always_inline bool free_pages_prepar=
e(struct page *page,
> > > >       }
> > > >       arch_free_page(page, order);
> > > >       kernel_poison_pages(page, 1 << order, 0);
> > > > +     if (want_init_on_free())
> > > > +             kernel_init_free_pages(page, 1 << order);
> > >
> > > same here. If you don't want to make this exclusive then you have to
> > > zero before poisoning otherwise you are going to blow up on the poiso=
n
> > > check, right?
> > Note that we disable initialization if page poisoning is on.
>
> Ohh, right. Missed that in the init code.
>
> > As I mentioned on another thread we can eventually merge this code
> > with page poisoning, but right now it's better to make the user decide
> > which of the features they want instead of letting them guess how the
> > combination of the two is going to work.
>
> Strictly speaking zeroying is a subset of poisoning. If somebody asks
> for both the poisoning surely satisfies any data leak guarantees
> zeroying would give. So I am not sure we have to really make them
> exclusive wrt. to the configuraion. I will leave that to you but it
> would be better if the code didn't break subtly once the early init
> restriction is removed for one way or another. So either always make
> sure that zeroying is done _before_ poisoning or that you do not zero
> when poisoning. The later sounds the best wrt. the code quality from my
> POV.
I somewhat liked the idea of always having zero-initialized page/heap
memory if init_on_{alloc,free} is on.
But in production mode we won't have page or slab poisoning anyway,
and for debugging this doesn't really matter much.
I've sent v9 with poisoning support added.
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
