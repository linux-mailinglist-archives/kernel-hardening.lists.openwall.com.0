Return-Path: <kernel-hardening-return-20638-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5E98F2F4FEE
	for <lists+kernel-hardening@lfdr.de>; Wed, 13 Jan 2021 17:26:54 +0100 (CET)
Received: (qmail 29869 invoked by uid 550); 13 Jan 2021 16:26:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 29837 invoked from network); 13 Jan 2021 16:26:46 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,  Linux Containers <containers@lists.linux-foundation.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Alexey Gladkov <legion@kernel.org>,  Kees Cook <keescook@chromium.org>,  Christian Brauner <christian@brauner.io>,  Linus Torvalds <torvalds@linux-foundation.org>
References: <cover.1610299857.git.gladkov.alexey@gmail.com>
	<5cef3f3b60e9cda7f4a42820ee333fa2d171a58b.1610299857.git.gladkov.alexey@gmail.com>
Date: Wed, 13 Jan 2021 10:25:29 -0600
In-Reply-To: <5cef3f3b60e9cda7f4a42820ee333fa2d171a58b.1610299857.git.gladkov.alexey@gmail.com>
	(Alexey Gladkov's message of "Sun, 10 Jan 2021 18:33:41 +0100")
Message-ID: <87sg74dcsm.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1kziye-009ULz-1I;;;mid=<87sg74dcsm.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18bSWki381+ZQyR9dpaNfWJsBh5GnUmXTk=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa02.xmission.com
X-Spam-Level: **
X-Spam-Status: No, score=2.4 required=8.0 tests=ALL_TRUSTED,BAYES_50,
	DCC_CHECK_NEGATIVE,LotsOfNums_01,T_TM2_M_HEADER_IN_MSG,XMSubLong,
	XM_B_SpammyWords,XM_B_Unsub autolearn=disabled version=3.4.2
X-Spam-Virus: No
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_B_Unsub Unsubscribe in body of email but missing unsubscribe
	*       header
	*  0.2 XM_B_SpammyWords One or more commonly used spammy words
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: **;Alexey Gladkov <gladkov.alexey@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 681 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 3.7 (0.5%), b_tie_ro: 2.6 (0.4%), parse: 0.78
	(0.1%), extract_message_metadata: 4.0 (0.6%), get_uri_detail_list: 2.5
	(0.4%), tests_pri_-1000: 1.95 (0.3%), tests_pri_-950: 0.95 (0.1%),
	tests_pri_-900: 0.73 (0.1%), tests_pri_-90: 268 (39.3%), check_bayes:
	266 (39.1%), b_tokenize: 10 (1.4%), b_tok_get_all: 10 (1.5%),
	b_comp_prob: 1.74 (0.3%), b_tok_touch_all: 242 (35.5%), b_finish: 0.69
	(0.1%), tests_pri_0: 389 (57.1%), check_dkim_signature: 0.42 (0.1%),
	check_dkim_adsp: 2.1 (0.3%), poll_dns_idle: 0.83 (0.1%), tests_pri_10:
	1.52 (0.2%), tests_pri_500: 5 (0.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [RFC PATCH v2 2/8] Add a reference to ucounts for each user
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)


The subject is wrong.  This should be:
[RFC PATCH v2 2/8] Add a reference to ucounts for each cred.

Further the explanation could use a little work.  Something along the
lines of:

For RLIMIT_NPROC and some other rlimits the user_struct that holds the
global limit is kept alive for the lifetime of a process by keeping it
in struct cred.  Add a ucounts reference to struct cred, so that
RLIMIT_NPROC can switch from using a per user limit to using a per user
per user namespace limit.

Nits about the code below.

Alexey Gladkov <gladkov.alexey@gmail.com> writes:

> Before this, only the owner of the user namespace had an entry in ucounts.
> This entry addressed the user in the given user namespace.
>
> Now we create such an entry in ucounts for all users in the user namespace.
> Each user has only one entry for each user namespace.
>
> This commit is in preparation for migrating rlimits to ucounts.
>
> Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
> ---
>  include/linux/cred.h           |  1 +
>  include/linux/user_namespace.h |  2 ++
>  kernel/cred.c                  | 17 +++++++++++++++--
>  kernel/ucount.c                | 12 +++++++++++-
>  kernel/user_namespace.c        |  1 +
>  5 files changed, 30 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/cred.h b/include/linux/cred.h
> index 18639c069263..307744fcc387 100644
> --- a/include/linux/cred.h
> +++ b/include/linux/cred.h
> @@ -144,6 +144,7 @@ struct cred {
>  #endif
>  	struct user_struct *user;	/* real user ID subscription */
>  	struct user_namespace *user_ns; /* user_ns the caps and keyrings are relative to. */
> +	struct ucounts *ucounts;
>  	struct group_info *group_info;	/* supplementary groups for euid/fsgid */
>  	/* RCU deletion */
>  	union {
> diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
> index 84fefa9247c4..483568a56f7f 100644
> --- a/include/linux/user_namespace.h
> +++ b/include/linux/user_namespace.h
> @@ -102,6 +102,8 @@ bool setup_userns_sysctls(struct user_namespace *ns);
>  void retire_userns_sysctls(struct user_namespace *ns);
>  struct ucounts *inc_ucount(struct user_namespace *ns, kuid_t uid, enum ucount_type type);
>  void dec_ucount(struct ucounts *ucounts, enum ucount_type type);
> +void put_ucounts(struct ucounts *ucounts);
> +void set_cred_ucounts(const struct cred *cred, struct user_namespace *ns, kuid_t uid);
>  
>  #ifdef CONFIG_USER_NS
>  
> diff --git a/kernel/cred.c b/kernel/cred.c
> index 421b1149c651..d19e2e97092c 100644
> --- a/kernel/cred.c
> +++ b/kernel/cred.c
> @@ -119,6 +119,7 @@ static void put_cred_rcu(struct rcu_head *rcu)
>  	if (cred->group_info)
>  		put_group_info(cred->group_info);
>  	free_uid(cred->user);
> +	put_ucounts(cred->ucounts);
>  	put_user_ns(cred->user_ns);
>  	kmem_cache_free(cred_jar, cred);
>  }
> @@ -144,6 +145,9 @@ void __put_cred(struct cred *cred)
>  	BUG_ON(cred == current->cred);
>  	BUG_ON(cred == current->real_cred);
>  
> +	BUG_ON(cred->ucounts == NULL);
> +	BUG_ON(cred->ucounts->ns != cred->user_ns);
> +
>  	if (cred->non_rcu)
>  		put_cred_rcu(&cred->rcu);
>  	else
> @@ -271,6 +275,9 @@ struct cred *prepare_creds(void)
>  	get_uid(new->user);
>  	get_user_ns(new->user_ns);
>  
> +	new->ucounts = NULL;
> +	set_cred_ucounts(new, new->user_ns, new->euid);
> +
This hunk should be:
	atomic_inc(&new->count);

That means you get to skip the lookup by uid and user_ns which while it
should be cheap is completely unnecessary in this case.

>  #ifdef CONFIG_KEYS
>  	key_get(new->session_keyring);
>  	key_get(new->process_keyring);
> @@ -363,6 +370,7 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
>  		ret = create_user_ns(new);
>  		if (ret < 0)
>  			goto error_put;
> +		set_cred_ucounts(new, new->user_ns, new->euid);
>  	}
>  
>  #ifdef CONFIG_KEYS
> @@ -485,8 +493,11 @@ int commit_creds(struct cred *new)
>  	 * in set_user().
>  	 */
>  	alter_cred_subscribers(new, 2);
> -	if (new->user != old->user)
> -		atomic_inc(&new->user->processes);
> +	if (new->user != old->user || new->user_ns != old->user_ns) {
> +		if (new->user != old->user)
> +			atomic_inc(&new->user->processes);
> +		set_cred_ucounts(new, new->user_ns, new->euid);
> +	}
>  	rcu_assign_pointer(task->real_cred, new);
>  	rcu_assign_pointer(task->cred, new);
>  	if (new->user != old->user)
> @@ -661,6 +672,7 @@ void __init cred_init(void)
>  	/* allocate a slab in which we can store credentials */
>  	cred_jar = kmem_cache_create("cred_jar", sizeof(struct cred), 0,
>  			SLAB_HWCACHE_ALIGN|SLAB_PANIC|SLAB_ACCOUNT, NULL);
> +	set_cred_ucounts(&init_cred, &init_user_ns, GLOBAL_ROOT_UID);
	Unfortuantely this is needed here because this is the first cred
        and there is no ucount reference to copy.
>  }
>  
>  /**
> @@ -704,6 +716,7 @@ struct cred *prepare_kernel_cred(struct task_struct *daemon)
>  	get_uid(new->user);
>  	get_user_ns(new->user_ns);
>  	get_group_info(new->group_info);
> +	set_cred_ucounts(new, new->user_ns, new->euid);
This hunk should be:
	atomic_inc(&new->count);

>  
>  #ifdef CONFIG_KEYS
>  	new->session_keyring = NULL;
> diff --git a/kernel/ucount.c b/kernel/ucount.c
> index 0f2c7c11df19..80a39073bcef 100644
> --- a/kernel/ucount.c
> +++ b/kernel/ucount.c
> @@ -161,7 +161,7 @@ static struct ucounts *get_ucounts(struct user_namespace *ns, kuid_t uid)
>  	return ucounts;
>  }
>  
> -static void put_ucounts(struct ucounts *ucounts)
> +void put_ucounts(struct ucounts *ucounts)
>  {
>  	unsigned long flags;
>  
> @@ -175,6 +175,16 @@ static void put_ucounts(struct ucounts *ucounts)
>  	kfree(ucounts);
>  }
>  
> +void set_cred_ucounts(const struct cred *cred, struct user_namespace *ns, kuid_t uid)
> +{
> +	if (cred->ucounts) {
> +		if (cred->ucounts->ns == ns && uid_eq(cred->ucounts->uid, uid))
> +			return;
> +		put_ucounts(cred->ucounts);
> +	}
> +	((struct cred *) cred)->ucounts = get_ucounts(ns, uid);
> +}
> +

That can become:
void reset_cred_ucounts(struct cred *cred, struct user_namespace *ns, kuid_t uid)
{
	struct ucounts *old = cred->ucounts;

	if (old && old->ns && uid_eq(old->uid, uid))
        	return;

	cred->ucounts = get_ucounts(ns, uid);
        if (old)
        	put_ucounts(old);
}

Removing the const on struct cred will make any mistakes where you use
this with anything except a brand new cred show up at compile time.

Changing the tests around just makes it a little clearer what the code
is doing.

Changing the name emphasises that prepare_cred should not be using this
only commit_cred and friends where the ucounts may have changed.


>  static inline bool atomic_inc_below(atomic_t *v, int u)
>  {
>  	int c, old;
> diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
> index af612945a4d0..4b8a4468d391 100644
> --- a/kernel/user_namespace.c
> +++ b/kernel/user_namespace.c
> @@ -1280,6 +1280,7 @@ static int userns_install(struct nsset *nsset, struct ns_common *ns)
>  
>  	put_user_ns(cred->user_ns);
>  	set_cred_user_ns(cred, get_user_ns(user_ns));
> +	set_cred_ucounts(cred, user_ns, cred->euid);
>  
>  	return 0;
>  }
