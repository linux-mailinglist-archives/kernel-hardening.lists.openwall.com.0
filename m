Return-Path: <kernel-hardening-return-15950-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7A5C221B37
	for <lists+kernel-hardening@lfdr.de>; Fri, 17 May 2019 18:13:35 +0200 (CEST)
Received: (qmail 24151 invoked by uid 550); 17 May 2019 16:13:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24097 invoked from network); 17 May 2019 16:13:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=m02iPOvo556PAupUnS9qzquFGaL67NVm3EjfgL2dy5A=;
        b=dxB5PWDK5Ubq2UYGrAtUPASDCX1nBouaHJnYPPCDht/KwMlctyK5LwRI6KbDJjVvbI
         HqXHsPePvPX1QWUDr1d9ekMHs0Zj5byZfC4wEAdxVtQcEXr/Wtj5v6/zHjqcimjzICBF
         Yvt8t2d/Y9dZzZnkJh8xnV/qjGuh6UppseOIg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=m02iPOvo556PAupUnS9qzquFGaL67NVm3EjfgL2dy5A=;
        b=D865MX8uYgqcXT48AD2mx1W2HWdphu8fQY//hIiPNPj5LODIsc+fL6qyI/spagLscL
         ugMAvfQSpC6mTtlequjiXddm0jg1IgF8e/NskmJzGM7JXfyQ6pk8KOtSA77J4Gctmm80
         nQzFHSTEz7fnnfCanonJOTI5YqK5Lb61K9VNu2yQE1vYdMdR86n1tzBi3g0t6aM19CN4
         1sY2SnAPyv871toZIVNOGH1TaHO6TfUmMzNt5TjmUlMlmrdecSIRf34rWp8jdzvuDPUo
         JkX5GQEBGUzbQxaCO/0zxcOD1dbE71w3ks4df9o1bYupXlu2R+O9hhg8BCQUYRUqZoEP
         hxFw==
X-Gm-Message-State: APjAAAUUzowR8ywMVxvBY9atgQSfct7W087d5HYhWj4152AxHAbbcd7y
	CRGbHJtMz29pAHcGTBeYXGAvGg==
X-Google-Smtp-Source: APXvYqzxdYYkC4Vm6qLkhkpXpaHS6hS+/bNgbbir5gqCgNKRQ20zMhl2VQQoGk52iRa1FhEBt45aSg==
X-Received: by 2002:a17:902:8214:: with SMTP id x20mr35601151pln.308.1558109597070;
        Fri, 17 May 2019 09:13:17 -0700 (PDT)
Date: Fri, 17 May 2019 09:13:14 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Kostya Serebryany <kcc@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Sandeep Patil <sspatil@android.com>,
	Laura Abbott <labbott@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] net: apply __GFP_NO_AUTOINIT to AF_UNIX sk_buff
 allocations
Message-ID: <201905170900.BFA80ED@keescook>
References: <20190514143537.10435-1-glider@google.com>
 <20190514143537.10435-5-glider@google.com>
 <201905160923.BD3E530EFC@keescook>
 <201905161714.A53D472D9@keescook>
 <CAG_fn=Vj6Jk_DY_-0+x6EpbsVh+abpEVcjycBhJxeMH3wuy9rw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG_fn=Vj6Jk_DY_-0+x6EpbsVh+abpEVcjycBhJxeMH3wuy9rw@mail.gmail.com>

On Fri, May 17, 2019 at 10:49:03AM +0200, Alexander Potapenko wrote:
> On Fri, May 17, 2019 at 2:26 AM Kees Cook <keescook@chromium.org> wrote:
> > On Thu, May 16, 2019 at 09:53:01AM -0700, Kees Cook wrote:
> > > On Tue, May 14, 2019 at 04:35:37PM +0200, Alexander Potapenko wrote:
> > > > Add sock_alloc_send_pskb_noinit(), which is similar to
> > > > sock_alloc_send_pskb(), but allocates with __GFP_NO_AUTOINIT.
> > > > This helps reduce the slowdown on hackbench in the init_on_alloc mode
> > > > from 6.84% to 3.45%.
> > >
> > > Out of curiosity, why the creation of the new function over adding a
> > > gfp flag argument to sock_alloc_send_pskb() and updating callers? (There
> > > are only 6 callers, and this change already updates 2 of those.)
> > >
> > > > Slowdown for the initialization features compared to init_on_free=0,
> > > > init_on_alloc=0:
> > > >
> > > > hackbench, init_on_free=1:  +7.71% sys time (st.err 0.45%)
> > > > hackbench, init_on_alloc=1: +3.45% sys time (st.err 0.86%)
> >
> > So I've run some of my own wall-clock timings of kernel builds (which
> > should be an pretty big "worst case" situation, and I see much smaller
> > performance changes:
> How many cores were you using? I suspect the numbers may vary a bit
> depending on that.

I was using 4.

> > init_on_alloc=1
> >         Run times: 289.72 286.95 287.87 287.34 287.35
> >         Min: 286.95 Max: 289.72 Mean: 287.85 Std Dev: 0.98
> >                 0.25% faster (within the std dev noise)
> >
> > init_on_free=1
> >         Run times: 303.26 301.44 301.19 301.55 301.39
> >         Min: 301.19 Max: 303.26 Mean: 301.77 Std Dev: 0.75
> >                 4.57% slower
> >
> > init_on_free=1 with the PAX_MEMORY_SANITIZE slabs excluded:
> >         Run times: 299.19 299.85 298.95 298.23 298.64
> >         Min: 298.23 Max: 299.85 Mean: 298.97 Std Dev: 0.55
> >                 3.60% slower
> >
> > So the tuning certainly improved things by 1%. My perf numbers don't
> > show the 24% hit you were seeing at all, though.
> Note that 24% is the _sys_ time slowdown. The wall time slowdown seen
> in this case was 8.34%

Ah! Gotcha. Yeah, seems the impact for init_on_free is pretty
variable. The init_on_alloc appears close to free, though.

-- 
Kees Cook
