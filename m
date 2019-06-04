Return-Path: <kernel-hardening-return-16052-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5B1F0349AE
	for <lists+kernel-hardening@lfdr.de>; Tue,  4 Jun 2019 16:01:23 +0200 (CEST)
Received: (qmail 21644 invoked by uid 550); 4 Jun 2019 14:01:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 21624 invoked from network); 4 Jun 2019 14:01:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmusvillemoes.dk; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cCCcfuCqU/qdREtoEDzLnVLy4LPKMGX0jGv9c5Rh1B8=;
        b=HJSNN4aGaVf75WsJzCiqd24YGmv+eZuyGZvznilJ1e+2a0cE9WH+E2w1582cVJHoki
         7R15HFWDhBVWJe95YMNP8tx/FFttEqVFVHJwcCY7JKwNjDsvxC0GDd1Fsj1omDTbMOYV
         9NMNrqjplqfUQr+pP71ijNH1O1RSDigcSsd0c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cCCcfuCqU/qdREtoEDzLnVLy4LPKMGX0jGv9c5Rh1B8=;
        b=Tj8r5WwM9UUhBNWqCKXb8LttPISyx5rAb2FOJiYRkq7gKEFDPc9puy+fJfq6QQP9q7
         m/qFm0AdoRlI/Iwp63T8DXIMLi+A6XuPrxdZ4cinJUhtL24yEud1nZ90djCYbgF+BZcy
         GNotbSjgOHOwaNrclZP7KDE0VTatV+T/gUS6ObSS+t1bmRb8BSkfr4qz/f2DhHoFukpt
         bFj/XWiNxwck09YkCvI8aBJHJnuQe1Fxz3b9NiWfn5Jzq8YR71nz5JWORNwwjBS0p4QS
         HJpWUXSSiOhSHLFBGWhGjhQLT62atyCDq1ZUD9TxNP/9SiKqRsofRjoyPyVTQYx5Gr8z
         Ea5g==
X-Gm-Message-State: APjAAAUC/l+PzZnG43VBy8sXAGGbGdkSl2U9zBCT65uramrO0GWUuRGY
	fAQeiJ1qKVhQ0v98hf9sMHmqmw==
X-Google-Smtp-Source: APXvYqwG4oEZZFnE0bcH3TRJ/Wba3p5uDNigTPmrPwm+Ag78TvQVmitBkN+Um1v3cCkDe6yNMmLSRw==
X-Received: by 2002:a2e:834f:: with SMTP id l15mr13058888ljh.56.1559656863956;
        Tue, 04 Jun 2019 07:01:03 -0700 (PDT)
Subject: Re: [RFC 1/6] rcu: Add support for consolidated-RCU reader checking
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>,
 linux-kernel@vger.kernel.org
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
 Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>,
 "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, "H. Peter Anvin"
 <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
 Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
 kernel-hardening@lists.openwall.com, Lai Jiangshan <jiangshanlai@gmail.com>,
 Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
 linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, neilb@suse.com,
 netdev@vger.kernel.org, oleg@redhat.com,
 "Paul E. McKenney" <paulmck@linux.ibm.com>, Pavel Machek <pavel@ucw.cz>,
 peterz@infradead.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
 rcu@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
 Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
References: <20190601222738.6856-1-joel@joelfernandes.org>
 <20190601222738.6856-2-joel@joelfernandes.org>
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Message-ID: <0ff9e0e3-b9fb-8953-1f76-807102f785ee@rasmusvillemoes.dk>
Date: Tue, 4 Jun 2019 16:01:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190601222738.6856-2-joel@joelfernandes.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 02/06/2019 00.27, Joel Fernandes (Google) wrote:
> This patch adds support for checking RCU reader sections in list
> traversal macros. Optionally, if the list macro is called under SRCU or
> other lock/mutex protection, then appropriate lockdep expressions can be
> passed to make the checks pass.
> 
> Existing list_for_each_entry_rcu() invocations don't need to pass the
> optional fourth argument (cond) unless they are under some non-RCU
> protection and needs to make lockdep check pass.
> 
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> ---
>  include/linux/rculist.h  | 40 ++++++++++++++++++++++++++++++++++++----
>  include/linux/rcupdate.h |  7 +++++++
>  kernel/rcu/update.c      | 26 ++++++++++++++++++++++++++
>  3 files changed, 69 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> index e91ec9ddcd30..b641fdd9f1a2 100644
> --- a/include/linux/rculist.h
> +++ b/include/linux/rculist.h
> @@ -40,6 +40,25 @@ static inline void INIT_LIST_HEAD_RCU(struct list_head *list)
>   */
>  #define list_next_rcu(list)	(*((struct list_head __rcu **)(&(list)->next)))
>  
> +/*
> + * Check during list traversal that we are within an RCU reader
> + */
> +#define __list_check_rcu()						\
> +	RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),			\
> +			 "RCU-list traversed in non-reader section!")
> +
> +static inline void __list_check_rcu_cond(int dummy, ...)
> +{
> +	va_list ap;
> +	int cond;
> +
> +	va_start(ap, dummy);
> +	cond = va_arg(ap, int);
> +	va_end(ap);
> +
> +	RCU_LOCKDEP_WARN(!cond && !rcu_read_lock_any_held(),
> +			 "RCU-list traversed in non-reader section!");
> +}
>  /*
>   * Insert a new entry between two known consecutive entries.
>   *
> @@ -338,6 +357,9 @@ static inline void list_splice_tail_init_rcu(struct list_head *list,
>  						  member) : NULL; \
>  })
>  
> +#define SIXTH_ARG(a1, a2, a3, a4, a5, a6, ...) a6
> +#define COUNT_VARGS(...) SIXTH_ARG(dummy, ## __VA_ARGS__, 4, 3, 2, 1, 0)
> +>  /**
>   * list_for_each_entry_rcu	-	iterate over rcu list of given type
>   * @pos:	the type * to use as a loop cursor.
> @@ -348,9 +370,14 @@ static inline void list_splice_tail_init_rcu(struct list_head *list,
>   * the _rcu list-mutation primitives such as list_add_rcu()
>   * as long as the traversal is guarded by rcu_read_lock().
>   */
> -#define list_for_each_entry_rcu(pos, head, member) \
> -	for (pos = list_entry_rcu((head)->next, typeof(*pos), member); \
> -		&pos->member != (head); \
> +#define list_for_each_entry_rcu(pos, head, member, cond...)		\
> +	if (COUNT_VARGS(cond) != 0) {					\
> +		__list_check_rcu_cond(0, ## cond);			\
> +	} else {							\
> +		__list_check_rcu();					\
> +	}								\
> +	for (pos = list_entry_rcu((head)->next, typeof(*pos), member);	\
> +		&pos->member != (head);					\
>  		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))

Wouldn't something as simple as

#define __list_check_rcu(dummy, cond, ...) \
       RCU_LOCKDEP_WARN(!cond && !rcu_read_lock_any_held(), \
			 "RCU-list traversed in non-reader section!");

for ( ({ __list_check_rcu(junk, ##cond, 0); }), pos = ... )

work just as well (i.e., no need for two list_check_rcu and
list_check_rcu_cond variants)? If there's an optional cond, we use that,
if not, we pick the trailing 0, so !cond disappears and it reduces to
your __list_check_rcu(). Moreover, this ensures the RCU_LOCKDEP_WARN
expansion actually picks up the __LINE__ and __FILE__ where the for loop
is used, and not the __FILE__ and __LINE__ of the static inline function
from the header file. It also makes it a bit more type safe/type generic
(if the cond expression happened to have type long or u64 something
rather odd could happen with the inline vararg function).

Rasmus
