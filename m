Return-Path: <kernel-hardening-return-21220-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B6304368E58
	for <lists+kernel-hardening@lfdr.de>; Fri, 23 Apr 2021 10:03:19 +0200 (CEST)
Received: (qmail 12044 invoked by uid 550); 23 Apr 2021 08:01:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 3496 invoked from network); 23 Apr 2021 07:44:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1619163877;
	bh=8vt7fJFKJyNLj4TruaKcfoqK87/dNszJK3KYc+h7llo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XPM/BW3NJ38gXdx4kC9XLRyu4R5onNo/Wqm16A+sHhEqALBFN8UtvF30xiKtpAM69
	 ruMjG+OEgzQ7mzSaFmYzUb8nMNl91VX/734G4IMxS4r2Aym+1c+LknRsdHLVGoaS9J
	 poN1lAeOZGP8dhfk81DMMpSp/vslj2BBRMtB1ZuUxTcx3KttlMPWsWZqfW15JERhqO
	 82TsZKYZAZXIh4n1KLo7G4q15+De1OCt7xrNyey9VubMs0vDbWnS7DSSg7ufwoniPq
	 0nlLbQuBnDVtXl3hK+j4sTazgBAMy+V+bMZaBJRHktnJHXg5VTrWshmxd/3oPM6y99
	 YfuILgFmKfsyA==
Date: Fri, 23 Apr 2021 09:44:31 +0200
From: Alexey Gladkov <legion@kernel.org>
To: Oliver Sang <oliver.sang@intel.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alexey Gladkov <gladkov.alexey@gmail.com>,
	0day robot <lkp@intel.com>, LKML <linux-kernel@vger.kernel.org>,
	lkp@lists.01.org, "Huang, Ying" <ying.huang@intel.com>,
	Feng Tang <feng.tang@intel.com>, zhengjun.xing@intel.com,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux Containers <containers@lists.linux-foundation.org>,
	Linux-MM <linux-mm@kvack.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
	Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: 08ed4efad6: stress-ng.sigsegv.ops_per_sec -41.9% regression
Message-ID: <20210423074431.7ob6aqasome2zjbk@example.org>
References: <7abe5ab608c61fc2363ba458bea21cf9a4a64588.1617814298.git.gladkov.alexey@gmail.com>
 <20210408083026.GE1696@xsang-OptiPlex-9020>
 <CAHk-=wigPx+MMQMQ-7EA0pq5_5+kMCNV4qFsOss-WwdCSQmb-w@mail.gmail.com>
 <m1im4wmx9g.fsf@fess.ebiederm.org>
 <20210423024722.GA13968@xsang-OptiPlex-9020>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210423024722.GA13968@xsang-OptiPlex-9020>

On Fri, Apr 23, 2021 at 10:47:22AM +0800, Oliver Sang wrote:
> hi, Eric,
> 
> On Thu, Apr 08, 2021 at 01:44:43PM -0500, Eric W. Biederman wrote:
> > Linus Torvalds <torvalds@linux-foundation.org> writes:
> > 
> > > On Thu, Apr 8, 2021 at 1:32 AM kernel test robot <oliver.sang@intel.com> wrote:
> > >>
> > >> FYI, we noticed a -41.9% regression of stress-ng.sigsegv.ops_per_sec due to commit
> > >> 08ed4efad684 ("[PATCH v10 6/9] Reimplement RLIMIT_SIGPENDING on top of ucounts")
> > >
> > > Ouch.
> > 
> > We were cautiously optimistic when no test problems showed up from
> > the last posting that there was nothing to look at here.
> > 
> > Unfortunately it looks like the bots just missed the last posting. 
> 
> this report is upon v10. do you have newer version which hope bot test?

Yes. I posted a new version of this patch set. I would be very grateful if
you could test it.

https://lore.kernel.org/lkml/cover.1619094428.git.legion@kernel.org/

> please be noted, sorry to say, due to various reasons, it will be a
> big challenge for us to capture each version of a patch set.
> 
> e.g. we didn't make out a similar performance regression for
> v8/v9 version of this one..
> 
> > 
> > So it seems we are finally pretty much at correct code in need
> > of performance tuning.
> > 
> > > I *think* this test may be testing "send so many signals that it
> > > triggers the signal queue overflow case".
> > >
> > > And I *think* that the performance degradation may be due to lots of
> > > unnecessary allocations, because ity looks like that commit changes
> > > __sigqueue_alloc() to do
> > >
> > >         struct sigqueue *q = kmem_cache_alloc(sigqueue_cachep, flags);
> > >
> > > *before* checking the signal limit, and then if the signal limit was
> > > exceeded, it will just be free'd instead.
> > >
> > > The old code would check the signal count against RLIMIT_SIGPENDING
> > > *first*, and if there were m ore pending signals then it wouldn't do
> > > anything at all (including not incrementing that expensive atomic
> > > count).
> > 
> > This is an interesting test in a lot of ways as it is testing the
> > synchronous signal delivery path caused by an exception.  The test
> > is either executing *ptr = 0 (where ptr points to a read-only page)
> > or it executes an x86 instruction that is excessively long.
> > 
> > I have found the code but I haven't figured out how it is being
> > called yet.  The core loop is just:
> > 	for(;;) {
> > 		sigaction(SIGSEGV, &action, NULL);
> > 		sigaction(SIGILL, &action, NULL);
> > 		sigaction(SIGBUS, &action, NULL);
> > 
> > 		ret = sigsetjmp(jmp_env, 1);
> > 		if (done())
> >                 	break;
> > 		if (ret) {
> >                 	/* verify signal */
> >                 } else {
> >                 	*ptr = 0;
> >                 }
> > 	}
> > 
> > Code like that fundamentally can not be multi-threaded.  So the only way
> > the sigpending limit is being hit is if there are more processes running
> > that code simultaneously than the size of the limit.
> > 
> > Further it looks like stress-ng pushes RLIMIT_SIGPENDING as high as it
> > will go before the test starts.
> > 
> > 
> > > Also, the old code was very careful to only do the "get_user()" for
> > > the *first* signal it added to the queue, and do the "put_user()" for
> > > when removing the last signal. Exactly because those atomics are very
> > > expensive.
> > >
> > > The new code just does a lot of these atomics unconditionally.
> > 
> > Yes. That seems a likely culprit.
> > 
> > > I dunno. The profile data in there is a bit hard to read, but there's
> > > a lot more cachee misses, and a *lot* of node crossers:
> > >
> > >>    5961544          +190.4%   17314361        perf-stat.i.cache-misses
> > >>   22107466          +119.2%   48457656        perf-stat.i.cache-references
> > >>     163292 ą  3%   +4582.0%    7645410        perf-stat.i.node-load-misses
> > >>     227388 ą  2%   +3708.8%    8660824        perf-stat.i.node-loads
> > >
> > > and (probably as a result) average instruction costs have gone up enormously:
> > >
> > >>       3.47           +66.8%       5.79        perf-stat.overall.cpi
> > >>      22849           -65.6%       7866        perf-stat.overall.cycles-between-cache-misses
> > >
> > > and it does seem to be at least partly about "put_ucounts()":
> > >
> > >>       0.00            +4.5        4.46        perf-profile.calltrace.cycles-pp.put_ucounts.__sigqueue_free.get_signal.arch_do_signal_or_restart.exit_to_user_mode_prepare
> > >
> > > and a lot of "get_ucounts()".
> > >
> > > But it may also be that the new "get sigpending" is just *so* much
> > > more expensive than it used to be.
> > 
> > That too is possible.
> > 
> > That node-load-misses number does look like something is bouncing back
> > and forth between the nodes a lot more.  So I suspect stress-ng is
> > running multiple copies of the sigsegv test in different processes at
> > once.
> > 
> > 
> > 
> > That really suggests cache line ping pong from get_ucounts and
> > incrementing sigpending.
> > 
> > It surprises me that obtaining the cache lines exclusively is
> > the dominant cost on this code path but obtaining two cache lines
> > exclusively instead of one cache cache line exclusively is consistent
> > with a causing the exception delivery to take nearly twice as long.
> > 
> > For the optimization we only care about the leaf count so with a little
> > care we can restore the optimization.  So that is probably the thing
> > to do here.  The fewer changes to worry about the less likely to find
> > surprises.
> > 
> > 
> > 
> > That said for this specific case there is a lot of potential room for
> > improvement.  As this is a per thread signal the code update sigpending
> > in commit_cred and never worry about needing to pin the struct
> > user_struct or struct ucounts.  As this is a synchronous signal we could
> > skip the sigpending increment, skip the signal queue entirely, and
> > deliver the signal to user-space immediately.  The removal of all cache
> > ping pongs might make it worth it.
> > 
> > There is also Thomas Gleixner's recent optimization to cache one
> > sigqueue entry per task to give more predictable behavior.  That
> > would remove the cost of the allocation.
> > 
> > Eric
> 

-- 
Rgrds, legion

