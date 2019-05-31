Return-Path: <kernel-hardening-return-16021-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E94E231006
	for <lists+kernel-hardening@lfdr.de>; Fri, 31 May 2019 16:20:38 +0200 (CEST)
Received: (qmail 8175 invoked by uid 550); 31 May 2019 14:20:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 8147 invoked from network); 31 May 2019 14:20:31 -0000
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20190531132620.GC2606@hirez.programming.kicks-ass.net>
References: <20190531132620.GC2606@hirez.programming.kicks-ass.net> <20190531111445.GO2677@hirez.programming.kicks-ass.net> <CAG48ez0R-R3Xs+3Xg9T9qcV3Xv6r4pnx1Z2y=Ltx7RGOayte_w@mail.gmail.com> <20190528162603.GA24097@kroah.com> <155905930702.7587.7100265859075976147.stgit@warthog.procyon.org.uk> <155905931502.7587.11705449537368497489.stgit@warthog.procyon.org.uk> <4031.1559064620@warthog.procyon.org.uk> <20190528231218.GA28384@kroah.com> <31936.1559146000@warthog.procyon.org.uk> <16193.1559163763@warthog.procyon.org.uk> <21942.1559304135@warthog.procyon.org.uk>
To: Peter Zijlstra <peterz@infradead.org>
Cc: dhowells@redhat.com, Jann Horn <jannh@google.com>,
    Greg KH <gregkh@linuxfoundation.org>,
    Al Viro <viro@zeniv.linux.org.uk>, raven@themaw.net,
    linux-fsdevel <linux-fsdevel@vger.kernel.org>,
    Linux API <linux-api@vger.kernel.org>, linux-block@vger.kernel.org,
    keyrings@vger.kernel.org,
    linux-security-module <linux-security-module@vger.kernel.org>,
    kernel list <linux-kernel@vger.kernel.org>,
    Kees Cook <keescook@chromium.org>,
    Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [PATCH 1/7] General notification queue with user mmap()'able ring buffer
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <605.1559312411.1@warthog.procyon.org.uk>
Date: Fri, 31 May 2019 15:20:12 +0100
Message-ID: <606.1559312412@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.26]); Fri, 31 May 2019 14:20:19 +0000 (UTC)

Peter Zijlstra <peterz@infradead.org> wrote:

> Is it not the responsibility of the task that affects the 1->0
> transition to actually free the memory?
> 
> That is, I'm expecting the '...' in both cases above the include the
> actual freeing of the object. If this is not the case, then @usage is
> not a reference count.

Yes.  The '...' does the freeing.  It seemed unnecessary to include the code
ellipsised there since it's not the point of the discussion, but if you want
the full function:

	void afs_put_call(struct afs_call *call)
	{
		struct afs_net *net = call->net;
		int n = atomic_dec_return(&call->usage);
		int o = atomic_read(&net->nr_outstanding_calls);

		trace_afs_call(call, afs_call_trace_put, n + 1, o,
			       __builtin_return_address(0));

		ASSERTCMP(n, >=, 0);
		if (n == 0) {
			ASSERT(!work_pending(&call->async_work));
			ASSERT(call->type->name != NULL);

			if (call->rxcall) {
				rxrpc_kernel_end_call(net->socket, call->rxcall);
				call->rxcall = NULL;
			}
			if (call->type->destructor)
				call->type->destructor(call);

			afs_put_server(call->net, call->server);
			afs_put_cb_interest(call->net, call->cbi);
			afs_put_addrlist(call->alist);
			kfree(call->request);

			trace_afs_call(call, afs_call_trace_free, 0, o,
				       __builtin_return_address(0));
			kfree(call);

			o = atomic_dec_return(&net->nr_outstanding_calls);
			if (o == 0)
				wake_up_var(&net->nr_outstanding_calls);
		}
	}

You can see the kfree(call) in there.
Peter Zijlstra <peterz@infradead.org> wrote:

> (and it has already been established that refcount_t doesn't work for
> usage count scenarios)

?

Does that mean struct kref doesn't either?

> Aside from that, is the problem that refcount_dec_and_test() returns a
> boolean (true - last put, false - not last) instead of the refcount
> value? This does indeed make it hard to print the exact count value for
> the event.

That is the problem, yes - well, one of them: refcount_inc() doesn't either.

David
