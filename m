Return-Path: <kernel-hardening-return-16023-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E7EEF312AB
	for <lists+kernel-hardening@lfdr.de>; Fri, 31 May 2019 18:45:09 +0200 (CEST)
Received: (qmail 26142 invoked by uid 550); 31 May 2019 16:45:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26119 invoked from network); 31 May 2019 16:45:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=kWlXD8DiGcPRvC35zTm87cBBCSSsFkc29ZuXEbkqGVk=; b=E7kQkfZHgd8Xhu0FahwHyMpg5
	V3rEtjoLJ3K9R4uoncA6Hex5gD8HOVuW7fVxbtdnIqyfv8W/h+05KnWJBg4vEKPRe2ymP3ySMITTe
	ixeyxsQmEDk7ZL4SYsPhLh0YihzKKEhtCm/WT5wgoDmN0fh1RghSDBWMAye5x0mUZAwBsAoTYuGAY
	Z9VFIGkIDNokycSy82VgJisRCfDA50kqxwNtaNZLL5GhRla8oD9tR3ZSVr+ETnDPQj7Z4gDMat87o
	PPgb+VPA/Vnh79iL++6flNyNB0V08ayFnXyxdC5HHjU1AWvBHkzDjczpYsUEZb6q0WmsvsoqSEH2I
	nHFV3dpDw==;
Date: Fri, 31 May 2019 18:44:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: David Howells <dhowells@redhat.com>
Cc: Jann Horn <jannh@google.com>, Greg KH <gregkh@linuxfoundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org,
	keyrings@vger.kernel.org,
	linux-security-module <linux-security-module@vger.kernel.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH 1/7] General notification queue with user mmap()'able
 ring buffer
Message-ID: <20190531164444.GD2606@hirez.programming.kicks-ass.net>
References: <CAG48ez0R-R3Xs+3Xg9T9qcV3Xv6r4pnx1Z2y=Ltx7RGOayte_w@mail.gmail.com>
 <20190528162603.GA24097@kroah.com>
 <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
 <155905931502.7587.11705449537368497489.stgit@warthog.procyon.org.uk>
 <4031.1559064620@warthog.procyon.org.uk>
 <20190528231218.GA28384@kroah.com>
 <31936.1559146000@warthog.procyon.org.uk>
 <16193.1559163763@warthog.procyon.org.uk>
 <21942.1559304135@warthog.procyon.org.uk>
 <606.1559312412@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <606.1559312412@warthog.procyon.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, May 31, 2019 at 03:20:12PM +0100, David Howells wrote:
> Peter Zijlstra <peterz@infradead.org> wrote:

> > (and it has already been established that refcount_t doesn't work for
> > usage count scenarios)
> 
> ?
> 
> Does that mean struct kref doesn't either?

Indeed, since kref is just a pointless wrapper around refcount_t it does
not either.

The main distinction between a reference count and a usage count is that
0 means different things. For a refcount 0 means dead. For a usage count
0 is merely unused but valid.

Incrementing a 0 refcount is a serious bug -- use-after-free (and hence
refcount_t will refuse this and splat), for a usage count this is no
problem.

Now, it is sort-of possible to merge the two, by basically stating
something like: usage = refcount - 1. But that can get tricky and people
have not really liked the result much for the few times I tried.
