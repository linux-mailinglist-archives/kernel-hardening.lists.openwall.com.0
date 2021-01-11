Return-Path: <kernel-hardening-return-20636-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 652B52F208F
	for <lists+kernel-hardening@lfdr.de>; Mon, 11 Jan 2021 21:18:44 +0100 (CET)
Received: (qmail 10074 invoked by uid 550); 11 Jan 2021 20:18:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 10036 invoked from network); 11 Jan 2021 20:18:35 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>,  LKML <linux-kernel@vger.kernel.org>,  Linux Containers <containers@lists.linux-foundation.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Alexey Gladkov <legion@kernel.org>,  Kees Cook <keescook@chromium.org>,  Christian Brauner <christian@brauner.io>
References: <cover.1610299857.git.gladkov.alexey@gmail.com>
	<CAHk-=wgXZmRu762bjSeK80+T_LTo+UP9y5rP-uvym1vquSxmBw@mail.gmail.com>
Date: Mon, 11 Jan 2021 14:17:19 -0600
In-Reply-To: <CAHk-=wgXZmRu762bjSeK80+T_LTo+UP9y5rP-uvym1vquSxmBw@mail.gmail.com>
	(Linus Torvalds's message of "Sun, 10 Jan 2021 10:46:05 -0800")
Message-ID: <87a6tfp6sw.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1kz3ds-00GF4a-SO;;;mid=<87a6tfp6sw.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/Yf/U+HHFa2llriv5GGUzjHmbH00nuzd4=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa02.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
	DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG autolearn=disabled
	version=3.4.2
X-Spam-Virus: No
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4988]
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 485 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 3.5 (0.7%), b_tie_ro: 2.4 (0.5%), parse: 1.21
	(0.2%), extract_message_metadata: 15 (3.1%), get_uri_detail_list: 3.0
	(0.6%), tests_pri_-1000: 4.7 (1.0%), tests_pri_-950: 1.08 (0.2%),
	tests_pri_-900: 0.84 (0.2%), tests_pri_-90: 120 (24.7%), check_bayes:
	111 (22.8%), b_tokenize: 7 (1.5%), b_tok_get_all: 9 (1.8%),
	b_comp_prob: 1.96 (0.4%), b_tok_touch_all: 89 (18.4%), b_finish: 0.74
	(0.2%), tests_pri_0: 328 (67.6%), check_dkim_signature: 0.41 (0.1%),
	check_dkim_adsp: 2.1 (0.4%), poll_dns_idle: 0.74 (0.2%), tests_pri_10:
	1.73 (0.4%), tests_pri_500: 5 (1.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [RFC PATCH v2 0/8] Count rlimits in each user namespace
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Sun, Jan 10, 2021 at 9:34 AM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
>>
>> To address the problem, we bind rlimit counters to each user namespace. The
>> result is a tree of rlimit counters with the biggest value at the root (aka
>> init_user_ns). The rlimit counter increment/decrement occurs in the current and
>> all parent user namespaces.
>
> I'm not seeing why this is necessary.
>
> Maybe it's the right approach, but none of the patches (or this cover
> letter email) really explain it to me.
>
> I understand why you might want the _limits_ themselves would form a
> tree like this - with the "master limit" limiting the limits in the
> user namespaces under it.
>
> But I don't understand why the _counts_ should do that. The 'struct
> user_struct' should be shared across even user namespaces for the same
> user.
>
> IOW, the very example of the problem you quote seems to argue against this:
>
>> For example, there are two containers (A and B) created by one user. The
>> container A sets RLIMIT_NPROC=1 and starts one process. Everything is fine, but
>> when container B tries to do the same it will fail because the number of
>> processes is counted globally for each user and user has one process already.
>
> Note how the problem was _not_ that the _count_ was global. That part
> was fine and all good.

The problem is fundamentally that the per process RLIMIT_NPROC was
compared against the user_struct->processes.

I have only heard the problem described but I believe it is either the
RLIMIT_NPROC test in fork or at the beginning of do_execveat_common that
is failing.

From fs/exec.c line 1866:
> 	/*
> 	 * We move the actual failure in case of RLIMIT_NPROC excess from
> 	 * set*uid() to execve() because too many poorly written programs
> 	 * don't check setuid() return code.  Here we additionally recheck
> 	 * whether NPROC limit is still exceeded.
> 	 */
> 	if ((current->flags & PF_NPROC_EXCEEDED) &&
> 	    atomic_read(&current_user()->processes) > rlimit(RLIMIT_NPROC)) {
> 		retval = -EAGAIN;
> 		goto out_ret;
> 	}

From fs/fork.c line 1966:
> 	retval = -EAGAIN;
> 	if (atomic_read(&p->real_cred->user->processes) >=
> 			task_rlimit(p, RLIMIT_NPROC)) {
> 		if (p->real_cred->user != INIT_USER &&
> 		    !capable(CAP_SYS_RESOURCE) && !capable(CAP_SYS_ADMIN))
> 			goto bad_fork_free;
> 	}
> 	current->flags &= ~PF_NPROC_EXCEEDED;

In both the cases the RLIMIT_NPROC value comes from
task->signal->rlim[RLIMIT_NPROC] and the count of processes
comes from task->cred->user->processes.

> No, the problem was that the _limit_ in container A also ended up
> affecting container B.

The description I have is that both containers run the same service
that set it's RLIMIT_NPROC to 1 in both containers.

> So to me, that says that it would make sense to continue to use the
> resource counts in 'struct user_struct' (because if user A has a hard
> limit of X, then creating a new namespace shouldn't expand that
> limit), but then have the ability to make per-container changes to the
> resource limits (as long as they are within the bounds of the parent
> user namespace resource limit).

I agree that needs to work as well.

> Maybe there is some reason for this ucounts approach, but if so, I
> feel it was not explained at all.

Let me see if I can starte the example a litle more clearly.

Suppose there is a service never_fork that sets RLIMIT_NPROC runs as
never_fork_user and sets RLIMIT_NPROC to 1 in it's systemd service file.

Further suppose there is a user bob who has two containers he wants to
run: container1 and container2.  Both containers start the never_fork
service.

Bob first starts container1 and inside it the never_fork service starts.
Bob starts container2 and the never_fork service fails to start.

Does that make it clear that it is the count of the processes that would
exceed 1 if both instances of the never_fork service starts that would
be the problem?

Eric
