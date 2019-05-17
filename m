Return-Path: <kernel-hardening-return-15939-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C096421903
	for <lists+kernel-hardening@lfdr.de>; Fri, 17 May 2019 15:18:49 +0200 (CEST)
Received: (qmail 1265 invoked by uid 550); 17 May 2019 13:18:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1241 invoked from network); 17 May 2019 13:18:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=PHV0x8tuOxPE6AqNKxBxzAvruYWCBsuwR0QrG4TEbUE=;
        b=CZjfeqpw5FcEeYHMcUKZVX8/pa/LEJC0l7EOx5UoHipHih2W8VGdJ8TVRwU2TuCvhw
         /5gNk4X5G3s2uLTIq4aB82fNENnK4Pvncv2CsRtPemDSOyF62oJQwWU1NEJfZ5Kw3z9q
         5U3fAlo4NnuNYAs9dqqmxBZq5aSMFSkgwz42a1MX33oHOnJhz65SEPPXfhcsNLonGjBo
         m/n2xS5DaD5mRefwlNU6XgweWmVdAU4JZCEECBVWqP2lBkxN6Zxo29p1pasfElCWCAI7
         UNjsW2knxCfX4SsRQ9yb6Qgy0Wv16iC3hx54Kjs9q4umf79mYey1ShkyEqq/f+EKL3iz
         sGqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=PHV0x8tuOxPE6AqNKxBxzAvruYWCBsuwR0QrG4TEbUE=;
        b=L3J7ql2SVQcQI3FV/RF+Nf9c5H/uVkdS+6bJZ2BCArlPFzILjvhuiR9dxmFJSSyzWT
         Q47o+eDkM2nKLZRxWZpYU4HdsIn1BMj+0acElwEqUQPeujQemtZ8PdV5hJJPvaqzWKnD
         zuM72PDCv7LeVa3vytqh6bd0ftiCbLkDT9LKp33IkSwIsHQ3F/bkPX+qlh9nb4lOUF6N
         huf3nGUnNXifI+fB/Q01tXgbmuJ8VNHV3BIVBxpELVS01raYQivUrJGdnVoyH+HD6e7N
         KbZ+vHMj57lybMj1TjTX+8/ft+9l7HUpOLzIOZ1xNLtZAvgyuYDGbxPH+ERpz8qyckT1
         wWHA==
X-Gm-Message-State: APjAAAU1M5odZbXg2kt77a3Dub36Ql4CKMu8LQvBDlfsw3jiDOKh09J/
	+OuVqsvqqynzoEmJzizUt3FG1dmtgYFuFXvfEIERXQ==
X-Google-Smtp-Source: APXvYqyKBU4Hrndly6ZORHu6XZo6dCOdhGOvLEa/j2LUVcs0Hwr5DRL/F/5P3O7jDiSyGYHh0UJe3x4EkQIEynAhKpU=
X-Received: by 2002:a1f:3492:: with SMTP id b140mr2372879vka.8.1558099111004;
 Fri, 17 May 2019 06:18:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190514143537.10435-1-glider@google.com> <20190514143537.10435-4-glider@google.com>
 <20190517125916.GF1825@dhcp22.suse.cz>
In-Reply-To: <20190517125916.GF1825@dhcp22.suse.cz>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 17 May 2019 15:18:19 +0200
Message-ID: <CAG_fn=VG6vrCdpEv0g73M-Au4wW07w8g0uydEiHA96QOfcCVhA@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] gfp: mm: introduce __GFP_NO_AUTOINIT
To: Michal Hocko <mhocko@kernel.org>, Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, 
	Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, 
	Mark Rutland <mark.rutland@arm.com>, Souptick Joarder <jrdr.linux@gmail.com>, 
	Matthew Wilcox <willy@infradead.org>, Linux Memory Management List <linux-mm@kvack.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 17, 2019 at 2:59 PM Michal this flag Hocko
<mhocko@kernel.org> wrote:
>
> [It would be great to keep people involved in the previous version in the
> CC list]
Yes, I've been trying to keep everyone in the loop, but your email
fell through the cracks.
Sorry about that.
> On Tue 14-05-19 16:35:36, Alexander Potapenko wrote:
> > When passed to an allocator (either pagealloc or SL[AOU]B),
> > __GFP_NO_AUTOINIT tells it to not initialize the requested memory if th=
e
> > init_on_alloc boot option is enabled. This can be useful in the cases
> > newly allocated memory is going to be initialized by the caller right
> > away.
> >
> > __GFP_NO_AUTOINIT doesn't affect init_on_free behavior, except for SLOB=
,
> > where init_on_free implies init_on_alloc.
> >
> > __GFP_NO_AUTOINIT basically defeats the hardening against information
> > leaks provided by init_on_alloc, so one should use it with caution.
> >
> > This patch also adds __GFP_NO_AUTOINIT to alloc_pages() calls in SL[AOU=
]B.
> > Doing so is safe, because the heap allocators initialize the pages they
> > receive before passing memory to the callers.
>
> I still do not like the idea of a new gfp flag as explained in the
> previous email. People will simply use it incorectly or arbitrarily.
> We have that juicy experience from the past.

Just to preserve some context, here's the previous email:
https://patchwork.kernel.org/patch/10907595/
(plus the patch removing GFP_TEMPORARY for the curious ones:
https://lwn.net/Articles/729145/)

> Freeing a memory is an opt-in feature and the slab allocator can already
> tell many (with constructor or GFP_ZERO) do not need it.
Sorry, I didn't understand this piece. Could you please elaborate?

> So can we go without this gfp thing and see whether somebody actually
> finds a performance problem with the feature enabled and think about
> what can we do about it rather than add this maint. nightmare from the
> very beginning?

There were two reasons to introduce this flag initially.
The first was double initialization of pages allocated for SLUB.
However the benchmark results provided in this and the previous patch
don't show any noticeable difference - most certainly because the cost
of initializing the page is amortized.
The second one was to fine-tune hackbench, for which the slowdown
drops by a factor of 2.
But optimizing a mitigation for certain benchmarks is a questionable
measure, so maybe we could really go without it.

Kees, what do you think?
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
