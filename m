Return-Path: <kernel-hardening-return-15933-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 59DB721141
	for <lists+kernel-hardening@lfdr.de>; Fri, 17 May 2019 02:26:31 +0200 (CEST)
Received: (qmail 26167 invoked by uid 550); 17 May 2019 00:26:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26090 invoked from network); 17 May 2019 00:26:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ilDv0+YTa/WnY3XhZH80fN4U1WpmetjpQlVMabTh6tw=;
        b=ASs9/AsKmgukkUd8ZkGKrmFLrJLHhcmjh9zttsNZWu9UiLxwGqq+jTPLZfvADEE6BT
         0wo7n9b7ck3n1cRmgHDKeiMzhg+VhnE8FHKem/W4KuR+HtEfYDi+njtYVyXvv+cb4FKI
         TheGLDDVwvh9uyy0Qq5Jox9zPBUe3teBFpXhw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ilDv0+YTa/WnY3XhZH80fN4U1WpmetjpQlVMabTh6tw=;
        b=jSY68AzNfa+FxaTLsNB5RctDjzEA6spYrRL5jUQ4g6/Gbwwl6jaT1YHB96qo3utZZ/
         2lw10XFWPd1ZLhqplCS+2LxbxKUvLw9jhaiwtDHSsY6MR8QC9EQsH00D0vEKMDBEXImZ
         rdFm6wUxQWMIKIbXyM4fcVclVdr/s4Bjq2aqGYFuc1++QmQBTt8zmUJd+4Yg8nJm+IS+
         4Gcl1HxebK1GFWiyyTMwvoJuIlxa/L5juglA8y+2INAiOcNO2CMlGGn+tVTW0xDwkAiw
         /KQjdwJfH+5zMY3EIoZLColTVeYOLjX07dRsHNCBceShz4v6asTOLaZCtBGYWpQtEL5f
         AlGw==
X-Gm-Message-State: APjAAAXBLX84HM3bOgGg6W0Jo9lgcEvuRlkb8Buq/sV37SBeLtVygll7
	u9Mu5kmZKN2NHPvQw1NbR6r7cQ==
X-Google-Smtp-Source: APXvYqwlMKqnUliknBdwEvFPxguLJNac2aseYZx+RJq6e02esXvj8m81/U384KtDWip6FxOC9kYkMg==
X-Received: by 2002:a63:ef56:: with SMTP id c22mr2023348pgk.13.1558052772428;
        Thu, 16 May 2019 17:26:12 -0700 (PDT)
Date: Thu, 16 May 2019 17:26:09 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexander Potapenko <glider@google.com>
Cc: akpm@linux-foundation.org, cl@linux.com,
	kernel-hardening@lists.openwall.com,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Kostya Serebryany <kcc@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Sandeep Patil <sspatil@android.com>,
	Laura Abbott <labbott@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>,
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 4/4] net: apply __GFP_NO_AUTOINIT to AF_UNIX sk_buff
 allocations
Message-ID: <201905161714.A53D472D9@keescook>
References: <20190514143537.10435-1-glider@google.com>
 <20190514143537.10435-5-glider@google.com>
 <201905160923.BD3E530EFC@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201905160923.BD3E530EFC@keescook>

On Thu, May 16, 2019 at 09:53:01AM -0700, Kees Cook wrote:
> On Tue, May 14, 2019 at 04:35:37PM +0200, Alexander Potapenko wrote:
> > Add sock_alloc_send_pskb_noinit(), which is similar to
> > sock_alloc_send_pskb(), but allocates with __GFP_NO_AUTOINIT.
> > This helps reduce the slowdown on hackbench in the init_on_alloc mode
> > from 6.84% to 3.45%.
> 
> Out of curiosity, why the creation of the new function over adding a
> gfp flag argument to sock_alloc_send_pskb() and updating callers? (There
> are only 6 callers, and this change already updates 2 of those.)
> 
> > Slowdown for the initialization features compared to init_on_free=0,
> > init_on_alloc=0:
> > 
> > hackbench, init_on_free=1:  +7.71% sys time (st.err 0.45%)
> > hackbench, init_on_alloc=1: +3.45% sys time (st.err 0.86%)

So I've run some of my own wall-clock timings of kernel builds (which
should be an pretty big "worst case" situation, and I see much smaller
performance changes:

everything off
	Run times: 289.18 288.61 289.66 287.71 287.67
	Min: 287.67 Max: 289.66 Mean: 288.57 Std Dev: 0.79
		baseline

init_on_alloc=1
	Run times: 289.72 286.95 287.87 287.34 287.35
	Min: 286.95 Max: 289.72 Mean: 287.85 Std Dev: 0.98
		0.25% faster (within the std dev noise)

init_on_free=1
	Run times: 303.26 301.44 301.19 301.55 301.39
	Min: 301.19 Max: 303.26 Mean: 301.77 Std Dev: 0.75
		4.57% slower

init_on_free=1 with the PAX_MEMORY_SANITIZE slabs excluded:
	Run times: 299.19 299.85 298.95 298.23 298.64
	Min: 298.23 Max: 299.85 Mean: 298.97 Std Dev: 0.55
		3.60% slower

So the tuning certainly improved things by 1%. My perf numbers don't
show the 24% hit you were seeing at all, though.

> In the commit log it might be worth mentioning that this is only
> changing the init_on_alloc case (in case it's not already obvious to
> folks). Perhaps there needs to be a split of __GFP_NO_AUTOINIT into
> __GFP_NO_AUTO_ALLOC_INIT and __GFP_NO_AUTO_FREE_INIT? Right now
> __GFP_NO_AUTOINIT is only checked for init_on_alloc:

I was obviously crazy here. :) GFP isn't present for free(), but a SLAB
flag works (as was done in PAX_MEMORY_SANITIZE). I'll send the patch I
used for the above timing test.

-- 
Kees Cook
