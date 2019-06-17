Return-Path: <kernel-hardening-return-16162-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C818D488CD
	for <lists+kernel-hardening@lfdr.de>; Mon, 17 Jun 2019 18:25:20 +0200 (CEST)
Received: (qmail 3996 invoked by uid 550); 17 Jun 2019 16:25:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3976 invoked from network); 17 Jun 2019 16:25:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=PXluhcTCTbRu7MWWqjlNoU2J2WlclfBp1+lbYvichwE=; b=NrVMIU4FjkXaOiq8EBdBsisYX
	RPTIEzflV5zzQh/U2sftmMWhHn06EA8gVxhHQI09wAKbG1YY/aylBwEQE3x3HBwdn0p4zMqAk5Mo8
	Mvga3SN32GaMtRhAnUBUhndqL+MxsHwNGkAS3M0CB357M+Invewv0tSVMt+X2l3KOM45BTbbhqnDt
	1+++Y1sYLNcIANFQDfBUusVnW+IoqYMTzumlNSNAxUdtCv1NiresC8d9lLN1vOGTCgavANJXprh0g
	Ycsi9s+FlfSM4Wn38hFtg0KP3TV8Cxgna/sKWsWO2eGeM2ZxuvI/tX2zz3ee6gP63a/gt8MV8ySJJ
	snbxbH0mw==;
Date: Mon, 17 Jun 2019 18:24:55 +0200
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
Message-ID: <20190617162455.GL3436@hirez.programming.kicks-ass.net>
References: <20190528162603.GA24097@kroah.com>
 <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
 <155905931502.7587.11705449537368497489.stgit@warthog.procyon.org.uk>
 <4031.1559064620@warthog.procyon.org.uk>
 <20190528231218.GA28384@kroah.com>
 <31936.1559146000@warthog.procyon.org.uk>
 <16193.1559163763@warthog.procyon.org.uk>
 <21942.1559304135@warthog.procyon.org.uk>
 <606.1559312412@warthog.procyon.org.uk>
 <15401.1559322762@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15401.1559322762@warthog.procyon.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, May 31, 2019 at 06:12:42PM +0100, David Howells wrote:
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > > > (and it has already been established that refcount_t doesn't work for
> > > > usage count scenarios)
> > > 
> > > ?
> > > 
> > > Does that mean struct kref doesn't either?
> > 
> > Indeed, since kref is just a pointless wrapper around refcount_t it does
> > not either.
> > 
> > The main distinction between a reference count and a usage count is that
> > 0 means different things. For a refcount 0 means dead. For a usage count
> > 0 is merely unused but valid.
> 
> Ah - I consider the terms interchangeable.
> 
> Take Documentation/filesystems/vfs.txt for instance:
> 
>   dget: open a new handle for an existing dentry (this just increments
> 	the usage count)
> 
>   dput: close a handle for a dentry (decrements the usage count). ...
> 
>   ...
> 
>   d_lookup: look up a dentry given its parent and path name component
> 	It looks up the child of that given name from the dcache
> 	hash table. If it is found, the reference count is incremented
> 	and the dentry is returned. The caller must use dput()
> 	to free the dentry when it finishes using it.
> 
> Here we interchange the terms.
> 
> Or https://www.kernel.org/doc/gorman/html/understand/understand013.html
> which seems to interchange the terms in reference to struct page.

Right, but we have two distinct set of semantics, I figured it makes
sense to have two different names for them. Do you have an alternative
naming scheme we could use?

Or should we better document our distinction between reference and usage
count?
