Return-Path: <kernel-hardening-return-21181-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 50F3E358CDC
	for <lists+kernel-hardening@lfdr.de>; Thu,  8 Apr 2021 20:45:14 +0200 (CEST)
Received: (qmail 7853 invoked by uid 550); 8 Apr 2021 18:45:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7829 invoked from network); 8 Apr 2021 18:45:06 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kernel test robot <oliver.sang@intel.com>,  Alexey Gladkov <gladkov.alexey@gmail.com>,  0day robot <lkp@intel.com>,  LKML <linux-kernel@vger.kernel.org>,  lkp@lists.01.org,  "Huang\, Ying" <ying.huang@intel.com>,  Feng Tang <feng.tang@intel.com>,  zhengjun.xing@intel.com,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux Containers <containers@lists.linux-foundation.org>,  Linux-MM <linux-mm@kvack.org>,  Alexey Gladkov <legion@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  Christian Brauner <christian.brauner@ubuntu.com>,  Jann Horn <jannh@google.com>,  Jens Axboe <axboe@kernel.dk>,  Kees Cook <keescook@chromium.org>,  Oleg Nesterov <oleg@redhat.com>
References: <7abe5ab608c61fc2363ba458bea21cf9a4a64588.1617814298.git.gladkov.alexey@gmail.com>
	<20210408083026.GE1696@xsang-OptiPlex-9020>
	<CAHk-=wigPx+MMQMQ-7EA0pq5_5+kMCNV4qFsOss-WwdCSQmb-w@mail.gmail.com>
Date: Thu, 08 Apr 2021 13:44:43 -0500
In-Reply-To: <CAHk-=wigPx+MMQMQ-7EA0pq5_5+kMCNV4qFsOss-WwdCSQmb-w@mail.gmail.com>
	(Linus Torvalds's message of "Thu, 8 Apr 2021 09:22:40 -0700")
Message-ID: <m1im4wmx9g.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-XM-SPF: eid=1lUZe4-00A0nq-5p;;;mid=<m1im4wmx9g.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19JLUsOtBvU+Hb1U0UwhyIZDve8LzlJSks=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
	DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMSubLong,XM_B_Unicode
	autolearn=disabled version=3.4.2
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4999]
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.0 XM_B_Unicode BODY: Testing for specific types of unicode
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 785 ms - load_scoreonly_sql: 0.08 (0.0%),
	signal_user_changed: 12 (1.5%), b_tie_ro: 10 (1.3%), parse: 1.21
	(0.2%), extract_message_metadata: 18 (2.3%), get_uri_detail_list: 3.2
	(0.4%), tests_pri_-1000: 15 (1.9%), tests_pri_-950: 1.55 (0.2%),
	tests_pri_-900: 1.16 (0.1%), tests_pri_-90: 194 (24.7%), check_bayes:
	179 (22.8%), b_tokenize: 13 (1.7%), b_tok_get_all: 14 (1.8%),
	b_comp_prob: 4.5 (0.6%), b_tok_touch_all: 143 (18.2%), b_finish: 1.12
	(0.1%), tests_pri_0: 529 (67.3%), check_dkim_signature: 0.71 (0.1%),
	check_dkim_adsp: 2.5 (0.3%), poll_dns_idle: 0.77 (0.1%), tests_pri_10:
	2.2 (0.3%), tests_pri_500: 8 (1.0%), rewrite_mail: 0.00 (0.0%)
Subject: Re: 08ed4efad6: stress-ng.sigsegv.ops_per_sec -41.9% regression
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, Apr 8, 2021 at 1:32 AM kernel test robot <oliver.sang@intel.com> =
wrote:
>>
>> FYI, we noticed a -41.9% regression of stress-ng.sigsegv.ops_per_sec due=
 to commit
>> 08ed4efad684 ("[PATCH v10 6/9] Reimplement RLIMIT_SIGPENDING on top of u=
counts")
>
> Ouch.

We were cautiously optimistic when no test problems showed up from
the last posting that there was nothing to look at here.

Unfortunately it looks like the bots just missed the last posting.=20

So it seems we are finally pretty much at correct code in need
of performance tuning.

> I *think* this test may be testing "send so many signals that it
> triggers the signal queue overflow case".
>
> And I *think* that the performance degradation may be due to lots of
> unnecessary allocations, because ity looks like that commit changes
> __sigqueue_alloc() to do
>
>         struct sigqueue *q =3D kmem_cache_alloc(sigqueue_cachep, flags);
>
> *before* checking the signal limit, and then if the signal limit was
> exceeded, it will just be free'd instead.
>
> The old code would check the signal count against RLIMIT_SIGPENDING
> *first*, and if there were m ore pending signals then it wouldn't do
> anything at all (including not incrementing that expensive atomic
> count).

This is an interesting test in a lot of ways as it is testing the
synchronous signal delivery path caused by an exception.  The test
is either executing *ptr =3D 0 (where ptr points to a read-only page)
or it executes an x86 instruction that is excessively long.

I have found the code but I haven't figured out how it is being
called yet.  The core loop is just:
	for(;;) {
		sigaction(SIGSEGV, &action, NULL);
		sigaction(SIGILL, &action, NULL);
		sigaction(SIGBUS, &action, NULL);

		ret =3D sigsetjmp(jmp_env, 1);
		if (done())
                	break;
		if (ret) {
                	/* verify signal */
                } else {
                	*ptr =3D 0;
                }
	}

Code like that fundamentally can not be multi-threaded.  So the only way
the sigpending limit is being hit is if there are more processes running
that code simultaneously than the size of the limit.

Further it looks like stress-ng pushes RLIMIT_SIGPENDING as high as it
will go before the test starts.


> Also, the old code was very careful to only do the "get_user()" for
> the *first* signal it added to the queue, and do the "put_user()" for
> when removing the last signal. Exactly because those atomics are very
> expensive.
>
> The new code just does a lot of these atomics unconditionally.

Yes. That seems a likely culprit.

> I dunno. The profile data in there is a bit hard to read, but there's
> a lot more cachee misses, and a *lot* of node crossers:
>
>>    5961544          +190.4%   17314361        perf-stat.i.cache-misses
>>   22107466          +119.2%   48457656        perf-stat.i.cache-referenc=
es
>>     163292 =C4=85  3%   +4582.0%    7645410        perf-stat.i.node-load=
-misses
>>     227388 =C4=85  2%   +3708.8%    8660824        perf-stat.i.node-loads
>
> and (probably as a result) average instruction costs have gone up enormou=
sly:
>
>>       3.47           +66.8%       5.79        perf-stat.overall.cpi
>>      22849           -65.6%       7866        perf-stat.overall.cycles-b=
etween-cache-misses
>
> and it does seem to be at least partly about "put_ucounts()":
>
>>       0.00            +4.5        4.46        perf-profile.calltrace.cyc=
les-pp.put_ucounts.__sigqueue_free.get_signal.arch_do_signal_or_restart.exi=
t_to_user_mode_prepare
>
> and a lot of "get_ucounts()".
>
> But it may also be that the new "get sigpending" is just *so* much
> more expensive than it used to be.

That too is possible.

That node-load-misses number does look like something is bouncing back
and forth between the nodes a lot more.  So I suspect stress-ng is
running multiple copies of the sigsegv test in different processes at
once.



That really suggests cache line ping pong from get_ucounts and
incrementing sigpending.

It surprises me that obtaining the cache lines exclusively is
the dominant cost on this code path but obtaining two cache lines
exclusively instead of one cache cache line exclusively is consistent
with a causing the exception delivery to take nearly twice as long.

For the optimization we only care about the leaf count so with a little
care we can restore the optimization.  So that is probably the thing
to do here.  The fewer changes to worry about the less likely to find
surprises.



That said for this specific case there is a lot of potential room for
improvement.  As this is a per thread signal the code update sigpending
in commit_cred and never worry about needing to pin the struct
user_struct or struct ucounts.  As this is a synchronous signal we could
skip the sigpending increment, skip the signal queue entirely, and
deliver the signal to user-space immediately.  The removal of all cache
ping pongs might make it worth it.

There is also Thomas Gleixner's recent optimization to cache one
sigqueue entry per task to give more predictable behavior.  That
would remove the cost of the allocation.

Eric
