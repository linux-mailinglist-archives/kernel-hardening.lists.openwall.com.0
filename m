Return-Path: <kernel-hardening-return-21247-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E4B1437482A
	for <lists+kernel-hardening@lfdr.de>; Wed,  5 May 2021 20:45:57 +0200 (CEST)
Received: (qmail 1969 invoked by uid 550); 5 May 2021 18:45:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1935 invoked from network); 5 May 2021 18:45:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1620240337;
	bh=tr9FqTMNy8Aj06BcquW7hrOWHRk5sO0oNB/v3F7fSGA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U4h+XW2JoDzusBFB9PItP8owvyEeRbEBjS7C+MbTIM0pm8gW1/7Sgm3uiTnhr4l0q
	 YkH7+NKvTuQC45/hUyhq5biEIbq09EV+IPth0gS+98hzzwncgLiZHExMu8vukCqhY3
	 PNztdmE9l2g3ophWibUn6lvKlOJe/C/11NDC6/DcaH6qcq3PN4eQP12imHVas1+rXJ
	 gj0NfbuQ99F/T76cFFCGYkgDWsv7R4T6SZYqCncokXbBtSfHkxCpgq8repwdM9lSF8
	 TJJw3WF5R5H594VU3jmwl3NLWXutN9y1bHlSMTi+09MYV1ciHXSB8vuy7FJnvX+PPq
	 LdPR40kMTc13A==
Date: Wed, 5 May 2021 21:45:28 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>, dave.hansen@intel.com,
	luto@kernel.org, linux-mm@kvack.org, x86@kernel.org,
	akpm@linux-foundation.org, linux-hardening@vger.kernel.org,
	kernel-hardening@lists.openwall.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 3/9] x86/mm/cpa: Add grouped page allocations
Message-ID: <YJLnyJP755XAPZNX@kernel.org>
References: <20210505003032.489164-1-rick.p.edgecombe@intel.com>
 <20210505003032.489164-4-rick.p.edgecombe@intel.com>
 <YJKKu7kMCtCuel2L@kernel.org>
 <YJKY+Ccxfe9wD0iP@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJKY+Ccxfe9wD0iP@hirez.programming.kicks-ass.net>

On Wed, May 05, 2021 at 03:09:12PM +0200, Peter Zijlstra wrote:
> On Wed, May 05, 2021 at 03:08:27PM +0300, Mike Rapoport wrote:
> > On Tue, May 04, 2021 at 05:30:26PM -0700, Rick Edgecombe wrote:
> > > For x86, setting memory permissions on the direct map results in fracturing
> > > large pages. Direct map fracturing can be reduced by locating pages that
> > > will have their permissions set close together.
> > > 
> > > Create a simple page cache that allocates pages from huge page size
> > > blocks. Don't guarantee that a page will come from a huge page grouping,
> > > instead fallback to non-grouped pages to fulfill the allocation if
> > > needed. Also, register a shrinker such that the system can ask for the
> > > pages back if needed. Since this is only needed when there is a direct
> > > map, compile it out on highmem systems.
> > 
> > I only had time to skim through the patches, I like the idea of having a
> > simple cache that allocates larger pages with a fallback to basic page
> > size.
> > 
> > I just think it should be more generic and closer to the page allocator.
> > I was thinking about adding a GFP flag that will tell that the allocated
> > pages should be removed from the direct map. Then alloc_pages() could use
> > such cache whenever this GFP flag is specified with a fallback for lower
> > order allocations.
> 
> That doesn't provide enough information I think. Removing from direct
> map isn't the only consideration, you also want to group them by the
> target protection bits such that we don't get to use 4k pages quite so
> much.

Unless I'm missing something we anyway hand out 4k pages from the cache and
the neighbouring 4k may end up with different protections.

This is also similar to what happens in the set Rick posted a while ago to
support grouped vmalloc allocations:

[1] https://lore.kernel.org/lkml/20210405203711.1095940-1-rick.p.edgecombe@intel.com/

-- 
Sincerely yours,
Mike.
