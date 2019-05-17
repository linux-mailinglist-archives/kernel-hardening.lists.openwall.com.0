Return-Path: <kernel-hardening-return-15951-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2472D21B9D
	for <lists+kernel-hardening@lfdr.de>; Fri, 17 May 2019 18:28:15 +0200 (CEST)
Received: (qmail 5561 invoked by uid 550); 17 May 2019 16:28:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5442 invoked from network); 17 May 2019 16:28:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iWEen/ZJGfJ/91ljuOGunKKjV2wkX9buixAuCmp2VbQ=;
        b=BrIhPn8ivTpMxlGPBk6IKIJLDMLnaVlDNMmu/vyM0gUSzZQvMLtGhLveRkfKi2vAM6
         +YkxY+z/cz2xTsv4w3Vlqtv9pbXvDXBqlfpTdOthbYK93wuom517jGpjWySLJNPNrOSc
         h8Jjt1InPKK6ea8zEWJIYE8CvdlJcSCOeFKdo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iWEen/ZJGfJ/91ljuOGunKKjV2wkX9buixAuCmp2VbQ=;
        b=BAL0GOwPzp+7n3kSQE1gIpFIras9nioS20/QOs2kCiI7U8n5YPsZleE/vkHJFeEVI+
         6WHg0C/b+K4kXI2fYaaeNmoJk9LlFc+5a7c88IW97tisQws8zthCLeCExhMBTh7wrl1+
         Zlu1gZKyMh+I1HiGPAxdI+uDTOqZOhnJM9yuM7U9+K5xhtMh2/U5BQu1FcDj+ju5aU4w
         vQVtchBDWkKFB7h7p7T9T1ZaxGh5LrsdK1z6XoRLCNore/EDuL5NzkdXgZIWiY9QSy1q
         zylMmmcvZ+Mr3cwNsVsAUuiq7mZQqdbqovxQPuW+mIdUQiTT+Pb9Pb6M5sb17G0ogPH1
         sfdg==
X-Gm-Message-State: APjAAAXVB9gE5VjqFh4stJYbAp/TZYAZZz7A1nv+70UB+OsTQkpC2pFt
	VVgB0g7c8RrF1Jenqdt7B5cu1g==
X-Google-Smtp-Source: APXvYqzdfBNgSus/Lm8itRXOgphQ1CTGG6b41OjNny+0hxO3EQG2Jz/Uzp0pZo6RricP0oBOyE23uA==
X-Received: by 2002:a17:902:7d90:: with SMTP id a16mr56467129plm.122.1558110476011;
        Fri, 17 May 2019 09:27:56 -0700 (PDT)
Date: Fri, 17 May 2019 09:27:54 -0700
From: Kees Cook <keescook@chromium.org>
To: Michal Hocko <mhocko@kernel.org>
Cc: Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Souptick Joarder <jrdr.linux@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v2 3/4] gfp: mm: introduce __GFP_NO_AUTOINIT
Message-ID: <201905170925.6FD47DDFFF@keescook>
References: <20190514143537.10435-1-glider@google.com>
 <20190514143537.10435-4-glider@google.com>
 <20190517125916.GF1825@dhcp22.suse.cz>
 <CAG_fn=VG6vrCdpEv0g73M-Au4wW07w8g0uydEiHA96QOfcCVhA@mail.gmail.com>
 <20190517132542.GJ6836@dhcp22.suse.cz>
 <CAG_fn=Ve88z2ezFjV6CthufMUhJ-ePNMT2=3m6J3nHWh9iSgsg@mail.gmail.com>
 <20190517140108.GK6836@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190517140108.GK6836@dhcp22.suse.cz>

On Fri, May 17, 2019 at 04:01:08PM +0200, Michal Hocko wrote:
> On Fri 17-05-19 15:37:14, Alexander Potapenko wrote:
> > > > > Freeing a memory is an opt-in feature and the slab allocator can already
> > > > > tell many (with constructor or GFP_ZERO) do not need it.
> > > > Sorry, I didn't understand this piece. Could you please elaborate?
> > >
> > > The allocator can assume that caches with a constructor will initialize
> > > the object so additional zeroying is not needed. GFP_ZERO should be self
> > > explanatory.
> > Ah, I see. We already do that, see the want_init_on_alloc()
> > implementation here: https://patchwork.kernel.org/patch/10943087/
> > > > > So can we go without this gfp thing and see whether somebody actually
> > > > > finds a performance problem with the feature enabled and think about
> > > > > what can we do about it rather than add this maint. nightmare from the
> > > > > very beginning?
> > > >
> > > > There were two reasons to introduce this flag initially.
> > > > The first was double initialization of pages allocated for SLUB.
> > >
> > > Could you elaborate please?
> > When the kernel allocates an object from SLUB, and SLUB happens to be
> > short on free pages, it requests some from the page allocator.
> > Those pages are initialized by the page allocator
> 
> ... when the feature is enabled ...
> 
> > and split into objects. Finally SLUB initializes one of the available
> > objects and returns it back to the kernel.
> > Therefore the object is initialized twice for the first time (when it
> > comes directly from the page allocator).
> > This cost is however amortized by SLUB reusing the object after it's been freed.
> 
> OK, I see what you mean now. Is there any way to special case the page
> allocation for this feature? E.g. your implementation tries to make this
> zeroying special but why cannot you simply do this
> 
> 
> struct page *
> ____alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
> 							nodemask_t *nodemask)
> {
> 	//current implementation
> }
> 
> struct page *
> __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
> 							nodemask_t *nodemask)
> {
> 	if (your_feature_enabled)
> 		gfp_mask |= __GFP_ZERO;
> 	return ____alloc_pages_nodemask(gfp_mask, order, preferred_nid,
> 					nodemask);
> }
> 
> and use ____alloc_pages_nodemask from the slab or other internal
> allocators?

If an additional allocator function is preferred over a new GFP flag, then
I don't see any reason not to do this. (Though adding more "__"s seems
a bit unfriendly to code-documentation.) What might be better naming?

This would mean that the skb changes later in the series would use the
"no auto init" version of the allocator too, then.

-- 
Kees Cook
