Return-Path: <kernel-hardening-return-20639-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 82C8E2F5001
	for <lists+kernel-hardening@lfdr.de>; Wed, 13 Jan 2021 17:33:05 +0100 (CET)
Received: (qmail 1275 invoked by uid 550); 13 Jan 2021 16:32:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1236 invoked from network); 13 Jan 2021 16:32:57 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,  Linux Containers <containers@lists.linux-foundation.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Alexey Gladkov <legion@kernel.org>,  Kees Cook <keescook@chromium.org>,  Christian Brauner <christian@brauner.io>,  Linus Torvalds <torvalds@linux-foundation.org>
References: <cover.1610299857.git.gladkov.alexey@gmail.com>
	<447547b12bba1894d3f1f79d6408dfc60b219b0c.1610299857.git.gladkov.alexey@gmail.com>
Date: Wed, 13 Jan 2021 10:31:40 -0600
In-Reply-To: <447547b12bba1894d3f1f79d6408dfc60b219b0c.1610299857.git.gladkov.alexey@gmail.com>
	(Alexey Gladkov's message of "Sun, 10 Jan 2021 18:33:40 +0100")
Message-ID: <878s8wdcib.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1kzj4d-009Vz0-HQ;;;mid=<878s8wdcib.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX195fKSBqSZ+lYzEZIXlkNCqt38tQhw2MoY=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa08.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
	DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMSubLong autolearn=disabled
	version=3.4.2
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4984]
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa08 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa08 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alexey Gladkov <gladkov.alexey@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 510 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 12 (2.3%), b_tie_ro: 10 (2.0%), parse: 0.77
	(0.2%), extract_message_metadata: 2.7 (0.5%), get_uri_detail_list:
	0.96 (0.2%), tests_pri_-1000: 3.4 (0.7%), tests_pri_-950: 1.38 (0.3%),
	tests_pri_-900: 1.13 (0.2%), tests_pri_-90: 240 (47.1%), check_bayes:
	239 (46.8%), b_tokenize: 6 (1.1%), b_tok_get_all: 6 (1.2%),
	b_comp_prob: 1.52 (0.3%), b_tok_touch_all: 221 (43.4%), b_finish: 1.10
	(0.2%), tests_pri_0: 233 (45.7%), check_dkim_signature: 0.50 (0.1%),
	check_dkim_adsp: 5 (1.1%), poll_dns_idle: 4.0 (0.8%), tests_pri_10:
	2.2 (0.4%), tests_pri_500: 7 (1.3%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [RFC PATCH v2 1/8] Use atomic type for ucounts reference counting
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)

Alexey Gladkov <gladkov.alexey@gmail.com> writes:

We might want to use refcount_t instead of atomic_t.  Not a big deal
either way.

> Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
> ---
>  include/linux/user_namespace.h |  2 +-
>  kernel/ucount.c                | 10 +++++-----
>  2 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
> index 64cf8ebdc4ec..84fefa9247c4 100644
> --- a/include/linux/user_namespace.h
> +++ b/include/linux/user_namespace.h
> @@ -92,7 +92,7 @@ struct ucounts {
>  	struct hlist_node node;
>  	struct user_namespace *ns;
>  	kuid_t uid;
> -	int count;
> +	atomic_t count;
>  	atomic_t ucount[UCOUNT_COUNTS];
>  };
>  
> diff --git a/kernel/ucount.c b/kernel/ucount.c
> index 11b1596e2542..0f2c7c11df19 100644
> --- a/kernel/ucount.c
> +++ b/kernel/ucount.c
> @@ -141,7 +141,8 @@ static struct ucounts *get_ucounts(struct user_namespace *ns, kuid_t uid)
>  
>  		new->ns = ns;
>  		new->uid = uid;
> -		new->count = 0;
> +
> +		atomic_set(&new->count, 0);
>  
>  		spin_lock_irq(&ucounts_lock);
>  		ucounts = find_ucounts(ns, uid, hashent);
> @@ -152,10 +153,10 @@ static struct ucounts *get_ucounts(struct user_namespace *ns, kuid_t uid)
>  			ucounts = new;
>  		}
>  	}
> -	if (ucounts->count == INT_MAX)
> +	if (atomic_read(&ucounts->count) == INT_MAX)
>  		ucounts = NULL;
>  	else
> -		ucounts->count += 1;
> +		atomic_inc(&ucounts->count);
>  	spin_unlock_irq(&ucounts_lock);
>  	return ucounts;
>  }
> @@ -165,8 +166,7 @@ static void put_ucounts(struct ucounts *ucounts)
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&ucounts_lock, flags);
> -	ucounts->count -= 1;
> -	if (!ucounts->count)
> +	if (atomic_dec_and_test(&ucounts->count))
>  		hlist_del_init(&ucounts->node);
>  	else
>  		ucounts = NULL;


This can become:
static void put_ucounts(struct ucounts *ucounts)
{
	unsigned long flags;

        if (atomic_dec_and_lock_irqsave(&ucounts->count, &ucounts_lock, flags)) {
        	hlist_del_init(&ucounts->node);
                spin_unlock_irqrestore(&ucounts_lock);
                kfree(ucounts);
        }
}

