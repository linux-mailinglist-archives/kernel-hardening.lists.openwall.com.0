Return-Path: <kernel-hardening-return-16046-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9FEB333933
	for <lists+kernel-hardening@lfdr.de>; Mon,  3 Jun 2019 21:42:32 +0200 (CEST)
Received: (qmail 14048 invoked by uid 550); 3 Jun 2019 19:42:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 14025 invoked from network); 3 Jun 2019 19:42:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=a+lhr9Q+24Qfza3c4uXpEdm8TyEjYoUavdn6rBgETA0=;
        b=v57zkdukOzYOvhfiKNqk2b/GOjkFP1SHWP5I5eo7SiatQZoyLWIBR+84HSu7EA2L8f
         /Txa/lSthx5I4+d0+ItNuTqwsJewXfi+56sABsg3JwRHrqq33I7sTzcN+0Twcbb6KpI7
         +Pr2kvxYQLWF4bCfr03Db/6neBgFbrX8K2sXo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=a+lhr9Q+24Qfza3c4uXpEdm8TyEjYoUavdn6rBgETA0=;
        b=c7Ikbd7srku7KZiZZ7zPEawN+9cfRxVFvKiOz2mEq4izrFZCyprFbio8FjJZt6aMCI
         x8nfS8S4AjYy4FZhBxbobRDGs/iA/OC4t0s2+bqzcKaA8rhhclKgZnXCuIiWpkyYEFVD
         vS406Ui0HiXnIQ0XZbww9Sbz1oZ7Y30qFkQOl1C2mO3iKDapDgsDwZTZzQuva5899m8M
         C0cFQbf+AWWFzsdWHJbOxao3OPhV5JCX8UWgPguvm6Y0goMKeImSnQIhKxKzD/hZ4S6O
         sZceCKC21uCohpVSy4rS2DWHNSzmENZyE1+YS+1277p4Zc9+it4xlhemLzyn0Tnmvt9u
         R/Xw==
X-Gm-Message-State: APjAAAUMREk11WFV49BwR/7RwkYBl7MPO3DIujDvnXXkZAmnFAWBYPJ4
	0KZSDzejJdDN8qHzfKM8MMPhYw==
X-Google-Smtp-Source: APXvYqxWMwntCJiOP/Rg6qilGaE0r4tvP3xYpgRSB5zm6o29WMIRTYv7JT5/hpFHq7FY7Jh/PBhQ6A==
X-Received: by 2002:a63:e10d:: with SMTP id z13mr9626011pgh.116.1559590933600;
        Mon, 03 Jun 2019 12:42:13 -0700 (PDT)
Date: Mon, 3 Jun 2019 15:42:11 -0400
From: Joel Fernandes <joel@joelfernandes.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>,
	"David S. Miller" <davem@davemloft.net>, edumazet@google.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
	kernel-hardening@lists.openwall.com,
	Lai Jiangshan <jiangshanlai@gmail.com>, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-pm@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, neilb@suse.com,
	netdev@vger.kernel.org, oleg@redhat.com,
	"Paul E. McKenney" <paulmck@linux.ibm.com>,
	Pavel Machek <pavel@ucw.cz>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>, rcu@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [RFC 1/6] rcu: Add support for consolidated-RCU reader checking
Message-ID: <20190603194211.GA228607@google.com>
References: <20190601222738.6856-1-joel@joelfernandes.org>
 <20190601222738.6856-2-joel@joelfernandes.org>
 <20190603080128.GA3436@hirez.programming.kicks-ass.net>
 <20190603141847.GA94186@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603141847.GA94186@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jun 03, 2019 at 10:18:47AM -0400, Joel Fernandes wrote:
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

Actually was able to roll the if/else into its own macro as well, thus
keeping it clean. thanks!

---8<-----------------------

diff --git a/include/linux/rculist.h b/include/linux/rculist.h
index b641fdd9f1a2..cc9c382b080c 100644
--- a/include/linux/rculist.h
+++ b/include/linux/rculist.h
@@ -43,7 +43,11 @@ static inline void INIT_LIST_HEAD_RCU(struct list_head *list)
 /*
  * Check during list traversal that we are within an RCU reader
  */
-#define __list_check_rcu()						\
+
+#define SIXTH_ARG(a1, a2, a3, a4, a5, a6, ...) a6
+#define COUNT_VARGS(...) SIXTH_ARG(dummy, ## __VA_ARGS__, 4, 3, 2, 1, 0)
+
+#define __list_check_rcu_nocond()					\
 	RCU_LOCKDEP_WARN(!rcu_read_lock_any_held(),			\
 			 "RCU-list traversed in non-reader section!")
 
@@ -59,6 +63,16 @@ static inline void __list_check_rcu_cond(int dummy, ...)
 	RCU_LOCKDEP_WARN(!cond && !rcu_read_lock_any_held(),
 			 "RCU-list traversed in non-reader section!");
 }
+
+#define __list_check_rcu(cond...)				\
+     ({								\
+	if (COUNT_VARGS(cond) != 0) {				\
+		__list_check_rcu_cond(0, ## cond);		\
+	} else {						\
+		__list_check_rcu_nocond();			\
+	}							\
+      })
+
 /*
  * Insert a new entry between two known consecutive entries.
  *
@@ -357,9 +371,6 @@ static inline void list_splice_tail_init_rcu(struct list_head *list,
 						  member) : NULL; \
 })
 
-#define SIXTH_ARG(a1, a2, a3, a4, a5, a6, ...) a6
-#define COUNT_VARGS(...) SIXTH_ARG(dummy, ## __VA_ARGS__, 4, 3, 2, 1, 0)
-
 /**
  * list_for_each_entry_rcu	-	iterate over rcu list of given type
  * @pos:	the type * to use as a loop cursor.
@@ -371,12 +382,8 @@ static inline void list_splice_tail_init_rcu(struct list_head *list,
  * as long as the traversal is guarded by rcu_read_lock().
  */
 #define list_for_each_entry_rcu(pos, head, member, cond...)		\
-	if (COUNT_VARGS(cond) != 0) {					\
-		__list_check_rcu_cond(0, ## cond);			\
-	} else {							\
-		__list_check_rcu();					\
-	}								\
-	for (pos = list_entry_rcu((head)->next, typeof(*pos), member);	\
+	for (__list_check_rcu(cond),					\
+	     pos = list_entry_rcu((head)->next, typeof(*pos), member);	\
 		&pos->member != (head);					\
 		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
 
@@ -649,12 +656,8 @@ static inline void hlist_add_behind_rcu(struct hlist_node *n,
  * as long as the traversal is guarded by rcu_read_lock().
  */
 #define hlist_for_each_entry_rcu(pos, head, member, cond...)		\
-	if (COUNT_VARGS(cond) != 0) {					\
-		__list_check_rcu_cond(0, ## cond);			\
-	} else {							\
-		__list_check_rcu();					\
-	}								\
-	for (pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
+	for (__list_check_rcu(cond),					\
+	     pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
 			typeof(*(pos)), member);			\
 		pos;							\
 		pos = hlist_entry_safe(rcu_dereference_raw(hlist_next_rcu(\
-- 
2.22.0.rc1.311.g5d7573a151-goog

