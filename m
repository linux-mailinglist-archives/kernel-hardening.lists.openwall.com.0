Return-Path: <kernel-hardening-return-16223-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 33F8A524E1
	for <lists+kernel-hardening@lfdr.de>; Tue, 25 Jun 2019 09:34:51 +0200 (CEST)
Received: (qmail 3673 invoked by uid 550); 25 Jun 2019 07:34:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3653 invoked from network); 25 Jun 2019 07:34:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=EfE9b6iC+ztQ2vj5wKDIVg9bT9RfKnT+aDZ7Xh8JmQE=; b=PSt1cdfG8jH5IrxOFwBR1B7iF
	JopUIkQmRjHxy5FprH9Y9CT7pNwP2YVqEqKo8zs1R7JVlb0XlkpvWvDzyT/iV0M726xXDDr5LAztO
	+clzTA2iC4AVb5yD2D0yaHL8M1nGCoVcywSlRINOe6I6HWIOVZORlh/9C5BAk+4Pe6zgbun+JUf/e
	slVVCpJLcSsz0tYF3bVjdB9286lk2vtmB7eBZ0K+d/xiufG0TuVMCQs6wQOQY+JfJGHnxgNb+T7bF
	KTIygfAloBmKQn/5WzScPCwqIV95gzFkI96M7ypN2EJxsIVWZG4UVAZ6OUoZ0KszrzoN8t3rFlXUh
	34boJnm5Q==;
Date: Tue, 25 Jun 2019 09:34:07 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jann Horn <jannh@google.com>
Cc: Joel Fernandes <joel@joelfernandes.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Matthew Wilcox <willy@infradead.org>,
	Will Deacon <will.deacon@arm.com>,
	"Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
	Elena Reshetova <elena.reshetova@intel.com>,
	Kees Cook <keescook@chromium.org>,
	kernel-team <kernel-team@android.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH RFC v2] Convert struct pid count to refcount_t
Message-ID: <20190625073407.GP3436@hirez.programming.kicks-ass.net>
References: <20190624184534.209896-1-joel@joelfernandes.org>
 <20190624185214.GA211230@google.com>
 <CAG48ez3maGsRbN3qr8YVb6ZCw0FDq-7GqqiTiA4yEa1mebkubw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez3maGsRbN3qr8YVb6ZCw0FDq-7GqqiTiA4yEa1mebkubw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jun 24, 2019 at 09:10:15PM +0200, Jann Horn wrote:
> That part of the documentation only talks about cases where you have a
> control dependency on the return value of the refcount operation. But
> refcount_inc() does not return a value, so this isn't relevant for
> refcount_inc().
> 
> Also, AFAIU, the control dependency mentioned in the documentation has
> to exist *in the caller* - it's just pointing out that if you write
> code like the following, you have a control dependency between the
> refcount operation and the write:
> 
>     if (refcount_inc_not_zero(&obj->refcount)) {
>       WRITE_ONCE(obj->x, y);
>     }
> 
> For more information on the details of this stuff, try reading the
> section "CONTROL DEPENDENCIES" of Documentation/memory-barriers.txt.

IIRC the argument went as follows:

 - if you use refcount_inc(), you've already got a stable object and
   have ACQUIRED it otherwise, typically through locking.

 - if you use refcount_inc_not_zero(), you have a semi stable object
   (RCU), but you still need to ensure any changes to the object happen
   after acquiring a reference, and this is where the control dependency
   comes in as Jann already explained.

Specifically, it would be bad to allow STOREs to happen before we know
the refcount isn't 0, as that would be a UaF.

Also see the comment in lib/refcount.c.

