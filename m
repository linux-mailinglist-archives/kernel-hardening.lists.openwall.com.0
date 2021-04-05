Return-Path: <kernel-hardening-return-21144-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F123B3545B9
	for <lists+kernel-hardening@lfdr.de>; Mon,  5 Apr 2021 18:59:13 +0200 (CEST)
Received: (qmail 5779 invoked by uid 550); 5 Apr 2021 16:59:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5758 invoked from network); 5 Apr 2021 16:59:08 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux Containers <containers@lists.linux-foundation.org>,  linux-mm@kvack.org,  Alexey Gladkov <legion@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  Christian Brauner <christian.brauner@ubuntu.com>,  Jann Horn <jannh@google.com>,  Jens Axboe <axboe@kernel.dk>,  Kees Cook <keescook@chromium.org>,  Linus Torvalds <torvalds@linux-foundation.org>,  Oleg Nesterov <oleg@redhat.com>
References: <cover.1616533074.git.gladkov.alexey@gmail.com>
	<9c8b24db40a030347652ee58f44028ca1081acfa.1616533074.git.gladkov.alexey@gmail.com>
Date: Mon, 05 Apr 2021 11:58:51 -0500
In-Reply-To: <9c8b24db40a030347652ee58f44028ca1081acfa.1616533074.git.gladkov.alexey@gmail.com>
	(Alexey Gladkov's message of "Tue, 23 Mar 2021 21:59:15 +0100")
Message-ID: <m1r1jollbo.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lTSYw-000Z25-OY;;;mid=<m1r1jollbo.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/lRCz+abrVYSdzhXtMBllzyd5yG1jeH8w=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa02.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.7 required=8.0 tests=ALL_TRUSTED,BAYES_50,
	DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMSubLong,
	XM_B_SpammyWords autolearn=disabled version=3.4.2
X-Spam-Virus: No
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.2 XM_B_SpammyWords One or more commonly used spammy words
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alexey Gladkov <gladkov.alexey@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 452 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 4.1 (0.9%), b_tie_ro: 2.8 (0.6%), parse: 1.17
	(0.3%), extract_message_metadata: 4.0 (0.9%), get_uri_detail_list:
	1.77 (0.4%), tests_pri_-1000: 3.3 (0.7%), tests_pri_-950: 1.10 (0.2%),
	tests_pri_-900: 0.89 (0.2%), tests_pri_-90: 167 (37.0%), check_bayes:
	166 (36.7%), b_tokenize: 6 (1.3%), b_tok_get_all: 6 (1.2%),
	b_comp_prob: 1.53 (0.3%), b_tok_touch_all: 150 (33.1%), b_finish: 0.82
	(0.2%), tests_pri_0: 252 (55.7%), check_dkim_signature: 0.40 (0.1%),
	check_dkim_adsp: 2.5 (0.5%), poll_dns_idle: 1.10 (0.2%), tests_pri_10:
	2.9 (0.6%), tests_pri_500: 8 (1.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v9 6/8] Reimplement RLIMIT_SIGPENDING on top of ucounts
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)


A small bug below.

Eric


> diff --git a/kernel/signal.c b/kernel/signal.c
> index f2a1b898da29..1b537d9de447 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -413,49 +413,44 @@ void task_join_group_stop(struct task_struct *task)
>  static struct sigqueue *
>  __sigqueue_alloc(int sig, struct task_struct *t, gfp_t flags, int override_rlimit)
>  {
> -	struct sigqueue *q = NULL;
> -	struct user_struct *user;
> -	int sigpending;
> +	struct sigqueue *q = kmem_cache_alloc(sigqueue_cachep, flags);
>  
> -	/*
> -	 * Protect access to @t credentials. This can go away when all
> -	 * callers hold rcu read lock.
> -	 *
> -	 * NOTE! A pending signal will hold on to the user refcount,
> -	 * and we get/put the refcount only when the sigpending count
> -	 * changes from/to zero.
> -	 */
> -	rcu_read_lock();
> -	user = __task_cred(t)->user;
> -	sigpending = atomic_inc_return(&user->sigpending);
> -	if (sigpending == 1)
> -		get_uid(user);
> -	rcu_read_unlock();
> +	if (likely(q != NULL)) {
> +		bool overlimit;
>  
> -	if (override_rlimit || likely(sigpending <= task_rlimit(t, RLIMIT_SIGPENDING))) {
> -		q = kmem_cache_alloc(sigqueue_cachep, flags);
> -	} else {
> -		print_dropped_signal(sig);
> -	}
> -
> -	if (unlikely(q == NULL)) {
> -		if (atomic_dec_and_test(&user->sigpending))
> -			free_uid(user);
> -	} else {
>  		INIT_LIST_HEAD(&q->list);
>  		q->flags = 0;
> -		q->user = user;
> +
> +		/*
> +		 * Protect access to @t credentials. This can go away when all
> +		 * callers hold rcu read lock.
> +		 */
> +		rcu_read_lock();
> +		q->ucounts = get_ucounts(task_ucounts(t));
> +		if (q->ucounts) {
> +			overlimit = inc_rlimit_ucounts_and_test(q->ucounts, UCOUNT_RLIMIT_SIGPENDING,
> +					1, task_rlimit(t, RLIMIT_SIGPENDING));
> +
> +			if (override_rlimit || likely(!overlimit)) {
> +				rcu_read_unlock();
> +				return q;
> +			}
> +		}
> +		rcu_read_unlock();

I believe you need to call __sigqueue_free here.

>  	}
>  
> -	return q;
> +	print_dropped_signal(sig);
> +	return NULL;
>  }
>  
>  static void __sigqueue_free(struct sigqueue *q)
>  {
>  	if (q->flags & SIGQUEUE_PREALLOC)
>  		return;
> -	if (atomic_dec_and_test(&q->user->sigpending))
> -		free_uid(q->user);
> +	if (q->ucounts) {
> +		dec_rlimit_ucounts(q->ucounts, UCOUNT_RLIMIT_SIGPENDING, 1);
> +		put_ucounts(q->ucounts);
> +	}
>  	kmem_cache_free(sigqueue_cachep, q);
>  }
>  

Eric
