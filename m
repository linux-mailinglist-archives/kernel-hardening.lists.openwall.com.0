Return-Path: <kernel-hardening-return-21244-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2F11C373C09
	for <lists+kernel-hardening@lfdr.de>; Wed,  5 May 2021 15:10:39 +0200 (CEST)
Received: (qmail 1044 invoked by uid 550); 5 May 2021 13:10:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32753 invoked from network); 5 May 2021 13:10:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RCnOPkMC/G1Vcdql+vcGlBPx7y6AVxksEchUg4RxzkQ=; b=HfZvW5qU94p4oR2x4wqzGUPz2C
	oUXMRaZvZIiKUS0yu7zzm9G8JgWZKmdwbOIuReAcoiBJNS2SeFYoosJWcnydI27HD4ZLYn9SYeL+W
	BXZkVVtX1MN8k7232jA7Vj7pPv3nuhhdRuDgOeHiiLjJL1JXEbaWaNfMo7MjFV2tnhF5jbwLGzGt2
	wmR6p75zHIsBDQ6GkXyT+tVRkvbmuibjXvIdM08ySYeuUagX9MzvqKuyg3r5tV41aIUFmF2iBKqPj
	xYjLfvxZhXqEqjKGsPw88JEHUSK7oFKjoAGuz41FoVzkFAnbsvnonAkNYrS0LgisF2C8ubNhwx4pz
	s5bxp44g==;
Date: Wed, 5 May 2021 15:09:12 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, dave.hansen@intel.com,
	luto@kernel.org, linux-mm@kvack.org, x86@kernel.org,
	akpm@linux-foundation.org, linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 3/9] x86/mm/cpa: Add grouped page allocations
Message-ID: <YJKY+Ccxfe9wD0iP@hirez.programming.kicks-ass.net>
References: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
 <20210505003032.489164-4-rick.p.edgecombe@intel.com>
 <YJKKu7kMCtCuel2L@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJKKu7kMCtCuel2L@kernel.org>

On Wed, May 05, 2021 at 03:08:27PM +0300, Mike Rapoport wrote:
> On Tue, May 04, 2021 at 05:30:26PM -0700, Rick Edgecombe wrote:
> > For x86, setting memory permissions on the direct map results in fracturing
> > large pages. Direct map fracturing can be reduced by locating pages that
> > will have their permissions set close together.
> > 
> > Create a simple page cache that allocates pages from huge page size
> > blocks. Don't guarantee that a page will come from a huge page grouping,
> > instead fallback to non-grouped pages to fulfill the allocation if
> > needed. Also, register a shrinker such that the system can ask for the
> > pages back if needed. Since this is only needed when there is a direct
> > map, compile it out on highmem systems.
> 
> I only had time to skim through the patches, I like the idea of having a
> simple cache that allocates larger pages with a fallback to basic page
> size.
> 
> I just think it should be more generic and closer to the page allocator.
> I was thinking about adding a GFP flag that will tell that the allocated
> pages should be removed from the direct map. Then alloc_pages() could use
> such cache whenever this GFP flag is specified with a fallback for lower
> order allocations.

That doesn't provide enough information I think. Removing from direct
map isn't the only consideration, you also want to group them by the
target protection bits such that we don't get to use 4k pages quite so
much.
