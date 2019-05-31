Return-Path: <kernel-hardening-return-16020-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2361230ED0
	for <lists+kernel-hardening@lfdr.de>; Fri, 31 May 2019 15:26:49 +0200 (CEST)
Received: (qmail 3314 invoked by uid 550); 31 May 2019 13:26:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3293 invoked from network); 31 May 2019 13:26:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=8n09TENg//rbgbzsGXRPd289l+d2UZWCH+fGg2NaHa4=; b=oMieT2howrG7WS9bOvNKdCmiR
	jX6TmxtTHoTJ6p19NQ7BG0HE7FY04HsI5/nyRw+Aq42dtfLxVH85f/Oo1wrKHZiXHSYILXb6bYx6K
	yhA1rgynmCx8lfqGcZssXNV6HHnn7atgrynyvL/+8MltoPvEPtws/8cz6hOIaknzrE3S4stP3RQCA
	+MPBd2PAi7l2iU3fhSRgYTaCLKkRqUgtXi6eiRPa1g0WJHp8m2WPOXwF9+0/y9HLU+804TTCeG+yR
	KtRFcgaXX9U1NowGmovnO8AyDivrrgn/IpW9UKTGwPivpjuRU9V2uX1aDiIUIutXoeABwDttquviR
	2s09w9mqg==;
Date: Fri, 31 May 2019 15:26:20 +0200
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
Message-ID: <20190531132620.GC2606@hirez.programming.kicks-ass.net>
References: <20190531111445.GO2677@hirez.programming.kicks-ass.net>
 <CAG48ez0R-R3Xs+3Xg9T9qcV3Xv6r4pnx1Z2y=Ltx7RGOayte_w@mail.gmail.com>
 <20190528162603.GA24097@kroah.com>
 <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk>
 <155905931502.7587.11705449537368497489.stgit@warthog.procyon.org.uk>
 <4031.1559064620@warthog.procyon.org.uk>
 <20190528231218.GA28384@kroah.com>
 <31936.1559146000@warthog.procyon.org.uk>
 <16193.1559163763@warthog.procyon.org.uk>
 <21942.1559304135@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21942.1559304135@warthog.procyon.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, May 31, 2019 at 01:02:15PM +0100, David Howells wrote:
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > Can you re-iterate the exact problem? I konw we talked about this in the
> > past, but I seem to have misplaced those memories :/
> 
> Take this for example:
> 
> 	void afs_put_call(struct afs_call *call)
> 	{
> 		struct afs_net *net = call->net;
> 		int n = atomic_dec_return(&call->usage);
> 		int o = atomic_read(&net->nr_outstanding_calls);
> 
> 		trace_afs_call(call, afs_call_trace_put, n + 1, o,
> 			       __builtin_return_address(0));
> 
> 		ASSERTCMP(n, >=, 0);
> 		if (n == 0) {
> 			...
> 		}
> 	}
> 
> I am printing the usage count in the afs_call tracepoint so that I can use it
> to debug refcount bugs.  If I do it like this:
> 
> 	void afs_put_call(struct afs_call *call)
> 	{
> 		int n = refcount_read(&call->usage);
> 		int o = atomic_read(&net->nr_outstanding_calls);
> 
> 		trace_afs_call(call, afs_call_trace_put, n, o,
> 			       __builtin_return_address(0));
> 
> 		if (refcount_dec_and_test(&call->usage)) {
> 			...
> 		}
> 	}
> 
> then there's a temporal gap between the usage count being read and the actual
> atomic decrement in which another CPU can alter the count.  This can be
> exacerbated by an interrupt occurring, a softirq occurring or someone enabling
> the tracepoint.
> 
> I can't do the tracepoint after the decrement if refcount_dec_and_test()
> returns false unless I save all the values from the object that I might need
> as the object could be destroyed any time from that point on.

Is it not the responsibility of the task that affects the 1->0
transition to actually free the memory?

That is, I'm expecting the '...' in both cases above the include the
actual freeing of the object. If this is not the case, then @usage is
not a reference count.

(and it has already been established that refcount_t doesn't work for
usage count scenarios)

Aside from that, is the problem that refcount_dec_and_test() returns a
boolean (true - last put, false - not last) instead of the refcount
value? This does indeed make it hard to print the exact count value for
the event.
