Return-Path: <kernel-hardening-return-21145-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 460353545C1
	for <lists+kernel-hardening@lfdr.de>; Mon,  5 Apr 2021 19:02:06 +0200 (CEST)
Received: (qmail 8029 invoked by uid 550); 5 Apr 2021 17:02:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 8005 invoked from network); 5 Apr 2021 17:01:59 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux Containers <containers@lists.linux-foundation.org>,  linux-mm@kvack.org,  Alexey Gladkov <legion@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  Christian Brauner <christian.brauner@ubuntu.com>,  Jann Horn <jannh@google.com>,  Jens Axboe <axboe@kernel.dk>,  Kees Cook <keescook@chromium.org>,  Linus Torvalds <torvalds@linux-foundation.org>,  Oleg Nesterov <oleg@redhat.com>
References: <cover.1616533074.git.gladkov.alexey@gmail.com>
	<54956fd06ab4a9938421f345ecf2e1518161cb38.1616533074.git.gladkov.alexey@gmail.com>
Date: Mon, 05 Apr 2021 12:01:41 -0500
In-Reply-To: <54956fd06ab4a9938421f345ecf2e1518161cb38.1616533074.git.gladkov.alexey@gmail.com>
	(Alexey Gladkov's message of "Tue, 23 Mar 2021 21:59:12 +0100")
Message-ID: <m1eefoll6y.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lTSbh-0008Vo-Ta;;;mid=<m1eefoll6y.fsf@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/6QFidO/5lE0s5jY0UtdtqKB+He4MOhKY=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa01.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
	DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMSubLong
	autolearn=disabled version=3.4.2
X-Spam-Virus: No
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alexey Gladkov <gladkov.alexey@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 566 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 3.7 (0.7%), b_tie_ro: 2.5 (0.5%), parse: 0.68
	(0.1%), extract_message_metadata: 2.6 (0.5%), get_uri_detail_list:
	1.24 (0.2%), tests_pri_-1000: 2.8 (0.5%), tests_pri_-950: 0.98 (0.2%),
	tests_pri_-900: 0.76 (0.1%), tests_pri_-90: 255 (45.1%), check_bayes:
	254 (44.8%), b_tokenize: 6 (1.1%), b_tok_get_all: 6 (1.1%),
	b_comp_prob: 1.23 (0.2%), b_tok_touch_all: 237 (41.9%), b_finish: 0.92
	(0.2%), tests_pri_0: 287 (50.7%), check_dkim_signature: 0.42 (0.1%),
	check_dkim_adsp: 2.1 (0.4%), poll_dns_idle: 0.72 (0.1%), tests_pri_10:
	1.77 (0.3%), tests_pri_500: 6 (1.0%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v9 3/8] Use atomic_t for ucounts reference counting
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)

Alexey Gladkov <gladkov.alexey@gmail.com> writes:

> The current implementation of the ucounts reference counter requires the
> use of spin_lock. We're going to use get_ucounts() in more performance
> critical areas like a handling of RLIMIT_SIGPENDING.
>
> Now we need to use spin_lock only if we want to change the hashtable.
>
> v9:
> * Use a negative value to check that the ucounts->count is close to
>   overflow.


Overall this looks good, one small issue below.

Eric

> diff --git a/kernel/ucount.c b/kernel/ucount.c
> index 50cc1dfb7d28..7bac19bb3f1e 100644
> --- a/kernel/ucount.c
> +++ b/kernel/ucount.c
> @@ -11,7 +11,7 @@
>  struct ucounts init_ucounts = {
>  	.ns    = &init_user_ns,
>  	.uid   = GLOBAL_ROOT_UID,
> -	.count = 1,
> +	.count = ATOMIC_INIT(1),
>  };
>  
>  #define UCOUNTS_HASHTABLE_BITS 10
> @@ -139,6 +139,15 @@ static void hlist_add_ucounts(struct ucounts *ucounts)
>  	spin_unlock_irq(&ucounts_lock);
>  }
>  
> +struct ucounts *get_ucounts(struct ucounts *ucounts)
> +{
> +	if (ucounts && atomic_add_negative(1, &ucounts->count)) {
> +		atomic_dec(&ucounts->count);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^

To handle the pathological case of all of the other uses calling
put_ucounts after the value goes negative, the above should
be put_ucounts intead of atomic_dec.


> +		ucounts = NULL;
> +	}
> +	return ucounts;
> +}
> +
>  struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid)
>  {
>  	struct hlist_head *hashent = ucounts_hashentry(ns, uid);
> @@ -155,7 +164,7 @@ struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid)
>  
>  		new->ns = ns;
>  		new->uid = uid;
> -		new->count = 0;
> +		atomic_set(&new->count, 1);
>  
>  		spin_lock_irq(&ucounts_lock);
>  		ucounts = find_ucounts(ns, uid, hashent);
> @@ -163,33 +172,12 @@ struct ucounts *alloc_ucounts(struct user_namespace *ns, kuid_t uid)
>  			kfree(new);
>  		} else {
>  			hlist_add_head(&new->node, hashent);
> -			ucounts = new;
> +			spin_unlock_irq(&ucounts_lock);
> +			return new;
>  		}
>  	}
> -	if (ucounts->count == INT_MAX)
> -		ucounts = NULL;
> -	else
> -		ucounts->count += 1;
>  	spin_unlock_irq(&ucounts_lock);
> -	return ucounts;
> -}
> -
> -struct ucounts *get_ucounts(struct ucounts *ucounts)
> -{
> -	unsigned long flags;
> -
> -	if (!ucounts)
> -		return NULL;
> -
> -	spin_lock_irqsave(&ucounts_lock, flags);
> -	if (ucounts->count == INT_MAX) {
> -		WARN_ONCE(1, "ucounts: counter has reached its maximum value");
> -		ucounts = NULL;
> -	} else {
> -		ucounts->count += 1;
> -	}
> -	spin_unlock_irqrestore(&ucounts_lock, flags);
> -
> +	ucounts = get_ucounts(ucounts);
>  	return ucounts;
>  }
>  
> @@ -197,15 +185,12 @@ void put_ucounts(struct ucounts *ucounts)
>  {
>  	unsigned long flags;
>  
> -	spin_lock_irqsave(&ucounts_lock, flags);
> -	ucounts->count -= 1;
> -	if (!ucounts->count)
> +	if (atomic_dec_and_test(&ucounts->count)) {
> +		spin_lock_irqsave(&ucounts_lock, flags);
>  		hlist_del_init(&ucounts->node);
> -	else
> -		ucounts = NULL;
> -	spin_unlock_irqrestore(&ucounts_lock, flags);
> -
> -	kfree(ucounts);
> +		spin_unlock_irqrestore(&ucounts_lock, flags);
> +		kfree(ucounts);
> +	}
>  }
>  
>  static inline bool atomic_long_inc_below(atomic_long_t *v, int u)
