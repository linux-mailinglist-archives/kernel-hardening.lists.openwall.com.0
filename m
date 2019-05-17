Return-Path: <kernel-hardening-return-15954-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 48B3421C40
	for <lists+kernel-hardening@lfdr.de>; Fri, 17 May 2019 19:11:27 +0200 (CEST)
Received: (qmail 8045 invoked by uid 550); 17 May 2019 17:11:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 8024 invoked from network); 17 May 2019 17:11:19 -0000
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Date: Fri, 17 May 2019 19:11:05 +0200
From: Michal Hocko <mhocko@kernel.org>
To: Kees Cook <keescook@chromium.org>
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
Message-ID: <20190517171105.GT6836@dhcp22.suse.cz>
References: <20190514143537.10435-1-glider@google.com>
 <20190514143537.10435-4-glider@google.com>
 <20190517125916.GF1825@dhcp22.suse.cz>
 <CAG_fn=VG6vrCdpEv0g73M-Au4wW07w8g0uydEiHA96QOfcCVhA@mail.gmail.com>
 <20190517132542.GJ6836@dhcp22.suse.cz>
 <CAG_fn=Ve88z2ezFjV6CthufMUhJ-ePNMT2=3m6J3nHWh9iSgsg@mail.gmail.com>
 <20190517140108.GK6836@dhcp22.suse.cz>
 <201905170925.6FD47DDFFF@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201905170925.6FD47DDFFF@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri 17-05-19 09:27:54, Kees Cook wrote:
> On Fri, May 17, 2019 at 04:01:08PM +0200, Michal Hocko wrote:
> > On Fri 17-05-19 15:37:14, Alexander Potapenko wrote:
> > > > > > Freeing a memory is an opt-in feature and the slab allocator can already
> > > > > > tell many (with constructor or GFP_ZERO) do not need it.
> > > > > Sorry, I didn't understand this piece. Could you please elaborate?
> > > >
> > > > The allocator can assume that caches with a constructor will initialize
> > > > the object so additional zeroying is not needed. GFP_ZERO should be self
> > > > explanatory.
> > > Ah, I see. We already do that, see the want_init_on_alloc()
> > > implementation here: https://patchwork.kernel.org/patch/10943087/
> > > > > > So can we go without this gfp thing and see whether somebody actually
> > > > > > finds a performance problem with the feature enabled and think about
> > > > > > what can we do about it rather than add this maint. nightmare from the
> > > > > > very beginning?
> > > > >
> > > > > There were two reasons to introduce this flag initially.
> > > > > The first was double initialization of pages allocated for SLUB.
> > > >
> > > > Could you elaborate please?
> > > When the kernel allocates an object from SLUB, and SLUB happens to be
> > > short on free pages, it requests some from the page allocator.
> > > Those pages are initialized by the page allocator
> > 
> > ... when the feature is enabled ...
> > 
> > > and split into objects. Finally SLUB initializes one of the available
> > > objects and returns it back to the kernel.
> > > Therefore the object is initialized twice for the first time (when it
> > > comes directly from the page allocator).
> > > This cost is however amortized by SLUB reusing the object after it's been freed.
> > 
> > OK, I see what you mean now. Is there any way to special case the page
> > allocation for this feature? E.g. your implementation tries to make this
> > zeroying special but why cannot you simply do this
> > 
> > 
> > struct page *
> > ____alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
> > 							nodemask_t *nodemask)
> > {
> > 	//current implementation
> > }
> > 
> > struct page *
> > __alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
> > 							nodemask_t *nodemask)
> > {
> > 	if (your_feature_enabled)
> > 		gfp_mask |= __GFP_ZERO;
> > 	return ____alloc_pages_nodemask(gfp_mask, order, preferred_nid,
> > 					nodemask);
> > }
> > 
> > and use ____alloc_pages_nodemask from the slab or other internal
> > allocators?
> 
> If an additional allocator function is preferred over a new GFP flag, then
> I don't see any reason not to do this. (Though adding more "__"s seems
> a bit unfriendly to code-documentation.) What might be better naming?

The naminig is the last thing I would be worried about. Let's focus on
the most simplistic implementation first. And means, can we really make
it as simple as above? At least on the page allocator level.

> This would mean that the skb changes later in the series would use the
> "no auto init" version of the allocator too, then.

No, this would be an internal function to MM. I would really like to
optimize once there are numbers from _real_ workloads to base those
optimizations.
-- 
Michal Hocko
SUSE Labs
