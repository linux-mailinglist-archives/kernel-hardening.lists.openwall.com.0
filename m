Return-Path: <kernel-hardening-return-16203-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 40B2F4DEB4
	for <lists+kernel-hardening@lfdr.de>; Fri, 21 Jun 2019 03:37:53 +0200 (CEST)
Received: (qmail 32059 invoked by uid 550); 21 Jun 2019 01:37:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32041 invoked from network); 21 Jun 2019 01:37:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+BBLwZtK559RusCbv05GmPVwa01R9tY1N/TrVS8kF/s=;
        b=UgJtjkuAPfCnrYv5/+nT3DgmraBLhmyJlPrB/1R/HP+7xj5HMoOxBowzAxJKYuhXal
         TUXR4AliTFs+xAYskx4xEjwkCvPnV5s/p3VitrZPdgdQ+pzqZ4eC+e5HFC1HQ72WpDov
         PdJmAQwmEYv2XrO5loF/BkZSQVzjTeTg7Sv8c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+BBLwZtK559RusCbv05GmPVwa01R9tY1N/TrVS8kF/s=;
        b=U/bfrHMwkFZclr46ftiOEIe+Z3scvuWpz8M1gxljKFBQ+rA05CvsBGa1AtPKJ9+Yaj
         +fc1zI9d6CTWMTo588VS4TaPR9z8xehzNGbfkBM6ekA/bzuplxYR+5WFYYybpN+9BcPX
         kmP5YUdf0FgHCj4cjzLShmZsYJEVlVKk2l9SMCQK41S9kOcTrbMIcuHZdoJa7lP9WKZw
         nxU+vjakV0hvYaT+W18jGg3HZbUipheSPjg2XILZrpqR5EuvWJz9ASNM1iwKvUqLF+vu
         KcCKFC8Pq2lT2IGzCrZp/7Lew+DkiHdEmQ/tsM6FiAMfA690QgWg+j1ggdokHiMQltgB
         kFbA==
X-Gm-Message-State: APjAAAWMJuBbK6/1DM5vxBVNr5PIMsE1RWxHuiqwE/ATSC1tTc+lm58X
	RsPkLxyFjBk1jrWRMal3VmqhCw==
X-Google-Smtp-Source: APXvYqz96MlZh/gHUsZQiQrw95Tphw+Mau0IgtUkGB4/+lWwwoAdzVWZRWZFmnOth83mrBsvYd712g==
X-Received: by 2002:a63:60d:: with SMTP id 13mr10624086pgg.272.1561081052880;
        Thu, 20 Jun 2019 18:37:32 -0700 (PDT)
Date: Thu, 20 Jun 2019 18:37:30 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Michal Hocko <mhocko@kernel.org>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Kostya Serebryany <kcc@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Sandeep Patil <sspatil@android.com>,
	Laura Abbott <labbott@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>,
	Mark Rutland <mark.rutland@arm.com>, Marco Elver <elver@google.com>,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v6 1/3] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-ID: <201906201821.8887E75@keescook>
References: <20190606164845.179427-1-glider@google.com>
 <20190606164845.179427-2-glider@google.com>
 <201906070841.4680E54@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201906070841.4680E54@keescook>

On Fri, Jun 07, 2019 at 08:42:27AM -0700, Kees Cook wrote:
> On Thu, Jun 06, 2019 at 06:48:43PM +0200, Alexander Potapenko wrote:
> > [...]
> > diff --git a/mm/slub.c b/mm/slub.c
> > index cd04dbd2b5d0..9c4a8b9a955c 100644
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > [...]
> > @@ -2741,8 +2758,14 @@ static __always_inline void *slab_alloc_node(struct kmem_cache *s,
> >  		prefetch_freepointer(s, next_object);
> >  		stat(s, ALLOC_FASTPATH);
> >  	}
> > +	/*
> > +	 * If the object has been wiped upon free, make sure it's fully
> > +	 * initialized by zeroing out freelist pointer.
> > +	 */
> > +	if (unlikely(slab_want_init_on_free(s)) && object)
> > +		*(void **)object = NULL;

In looking at metadata again, I noticed that I don't think this is
correct, as it needs to be using s->offset to find the location of the
freelist pointer:

	memset(object + s->offset, 0, sizeof(void *));

> >  
> > -	if (unlikely(gfpflags & __GFP_ZERO) && object)
> > +	if (unlikely(slab_want_init_on_alloc(gfpflags, s)) && object)
> >  		memset(object, 0, s->object_size);

init_on_alloc is using "object_size" but init_on_free is using "size". I
assume the "alloc" wipe is smaller because metadata was just written
for the allocation?

-- 
Kees Cook
