Return-Path: <kernel-hardening-return-16051-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 77BC93466D
	for <lists+kernel-hardening@lfdr.de>; Tue,  4 Jun 2019 14:19:39 +0200 (CEST)
Received: (qmail 28037 invoked by uid 550); 4 Jun 2019 12:19:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 28286 invoked from network); 4 Jun 2019 10:54:22 -0000
Date: Tue, 4 Jun 2019 06:53:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Joel Fernandes <joel@joelfernandes.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
 Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>, Bjorn Helgaas
 <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>, "David S. Miller"
 <davem@davemloft.net>, edumazet@google.com, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
 "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, Josh
 Triplett <josh@joshtriplett.org>, keescook@chromium.org,
 kernel-hardening@lists.openwall.com, Lai Jiangshan
 <jiangshanlai@gmail.com>, Len Brown <lenb@kernel.org>,
 linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-pm@vger.kernel.org, Mathieu Desnoyers
 <mathieu.desnoyers@efficios.com>, neilb@suse.com, netdev@vger.kernel.org,
 oleg@redhat.com, "Paul E. McKenney" <paulmck@linux.ibm.com>, Pavel Machek
 <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
 rcu@vger.kernel.org, Tejun Heo <tj@kernel.org>, Thomas Gleixner
 <tglx@linutronix.de>, "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)"
 <x86@kernel.org>
Subject: Re: [RFC 1/6] rcu: Add support for consolidated-RCU reader checking
Message-ID: <20190604065358.73347ced@oasis.local.home>
In-Reply-To: <20190603141847.GA94186@google.com>
References: <20190601222738.6856-1-joel@joelfernandes.org>
	<20190601222738.6856-2-joel@joelfernandes.org>
	<20190603080128.GA3436@hirez.programming.kicks-ass.net>
	<20190603141847.GA94186@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 3 Jun 2019 10:18:47 -0400
Joel Fernandes <joel@joelfernandes.org> wrote:

> On Mon, Jun 03, 2019 at 10:01:28AM +0200, Peter Zijlstra wrote:
> > On Sat, Jun 01, 2019 at 06:27:33PM -0400, Joel Fernandes (Google) wrote:  
> > > +#define list_for_each_entry_rcu(pos, head, member, cond...)		\
> > > +	if (COUNT_VARGS(cond) != 0) {					\
> > > +		__list_check_rcu_cond(0, ## cond);			\
> > > +	} else {							\
> > > +		__list_check_rcu();					\
> > > +	}								\
> > > +	for (pos = list_entry_rcu((head)->next, typeof(*pos), member);	\
> > > +		&pos->member != (head);					\
> > >  		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
> > >  
> > >  /**
> > > @@ -621,7 +648,12 @@ static inline void hlist_add_behind_rcu(struct hlist_node *n,
> > >   * the _rcu list-mutation primitives such as hlist_add_head_rcu()
> > >   * as long as the traversal is guarded by rcu_read_lock().
> > >   */
> > > +#define hlist_for_each_entry_rcu(pos, head, member, cond...)		\
> > > +	if (COUNT_VARGS(cond) != 0) {					\
> > > +		__list_check_rcu_cond(0, ## cond);			\
> > > +	} else {							\
> > > +		__list_check_rcu();					\
> > > +	}								\
> > >  	for (pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
> > >  			typeof(*(pos)), member);			\
> > >  		pos;							\  
> > 
> > 
> > This breaks code like:
> > 
> > 	if (...)
> > 		list_for_each_entry_rcu(...);
> > 
> > as they are no longer a single statement. You'll have to frob it into
> > the initializer part of the for statement.  
> 
> Thanks a lot for that. I fixed it as below (diff is on top of the patch):
> 
> If not for that '##' , I could have abstracted the whole if/else
> expression into its own macro and called it from list_for_each_entry_rcu() to
> keep it more clean.
> 
> ---8<-----------------------
> 
> diff --git a/include/linux/rculist.h b/include/linux/rculist.h
> index b641fdd9f1a2..cc742d294bb0 100644
> --- a/include/linux/rculist.h
> +++ b/include/linux/rculist.h
> @@ -371,12 +372,15 @@ static inline void list_splice_tail_init_rcu(struct list_head *list,
>   * as long as the traversal is guarded by rcu_read_lock().
>   */
>  #define list_for_each_entry_rcu(pos, head, member, cond...)		\
> -	if (COUNT_VARGS(cond) != 0) {					\
> -		__list_check_rcu_cond(0, ## cond);			\
> -	} else {							\
> -		__list_check_rcu();					\
> -	}								\
> -	for (pos = list_entry_rcu((head)->next, typeof(*pos), member);	\
> +	for (								\
> +	     ({								\
> +		if (COUNT_VARGS(cond) != 0) {				\
> +			__list_check_rcu_cond(0, ## cond);		\
> +		} else {						\
> +			__list_check_rcu_nocond();			\
> +		}							\
> +	      }),							\

For easier to read I would do something like this:

#define check_rcu_list(cond)						\
	({								\
		if (COUNT_VARGS(cond) != 0)				\
			__list_check_rcu_cond(0, ## cond);		\
		else							\
			__list_check_rcu_nocond();			\
	})

#define list_for_each_entry_rcu(pos, head, member, cond...)		\
	for (check_rcu_list(cond),					\


-- Steve

> +	     pos = list_entry_rcu((head)->next, typeof(*pos), member);	\
>  		&pos->member != (head);					\
>  		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
>  
> @@ -649,12 +653,15 @@ static inline void hlist_add_behind_rcu(struct hlist_node *n,
>   * as long as the traversal is guarded by rcu_read_lock().
>   */
>  #define hlist_for_each_entry_rcu(pos, head, member, cond...)		\
> -	if (COUNT_VARGS(cond) != 0) {					\
> -		__list_check_rcu_cond(0, ## cond);			\
> -	} else {							\
> -		__list_check_rcu();					\
> -	}								\
> -	for (pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
> +	for (								\
> +	     ({								\
> +		if (COUNT_VARGS(cond) != 0) {				\
> +			__list_check_rcu_cond(0, ## cond);		\
> +		} else {						\
> +			__list_check_rcu_nocond();			\
> +		}							\
> +	     }),							\
> +	     pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
>  			typeof(*(pos)), member);			\
>  		pos;							\
>  		pos = hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu(\

