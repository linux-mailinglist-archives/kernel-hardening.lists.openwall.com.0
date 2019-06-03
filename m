Return-Path: <kernel-hardening-return-16041-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 02F9232A4A
	for <lists+kernel-hardening@lfdr.de>; Mon,  3 Jun 2019 10:03:04 +0200 (CEST)
Received: (qmail 7880 invoked by uid 550); 3 Jun 2019 08:02:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7861 invoked from network); 3 Jun 2019 08:02:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=YGw/VDsnOloIaXgrEbA/FOCyBbJYxl2QNc1vAYVXNY0=; b=Kh81Fh/GkYy+PcGkyTuRLYqJr
	5d3meB8Iu/apofeU9LBaVTbdU34exlCBZ6/cvkSTsWYbCITa+85dcFdl1TuwCCRcbBbbBHcmz79tU
	YNA75f//Beu0qWv4xrOjE3yCBU/h7Wpdldb8AXCdnFyE/xt6GG7X5SHHOhvkwxY2EDPpuVJ40I8NT
	ZcmLp7vu3BxxYFbsJSX2sSX4rHSTxLEQ0MZogDpDfR8tMLBVyzA2HGhhcxPa3RuWryoN7hsbltCid
	ApVADLC1Be6a9Xztz6ysLp/Pg3F0N3np5vQaItnOalc4ycKqr7JKLLA3Zs069bXnA/w4o4wPQqclC
	BYeGsVrnQ==;
Date: Mon, 3 Jun 2019 10:01:28 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
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
Message-ID: <20190603080128.GA3436@hirez.programming.kicks-ass.net>
References: <20190601222738.6856-1-joel@joelfernandes.org>
 <20190601222738.6856-2-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190601222738.6856-2-joel@joelfernandes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Sat, Jun 01, 2019 at 06:27:33PM -0400, Joel Fernandes (Google) wrote:
> +#define list_for_each_entry_rcu(pos, head, member, cond...)		\
> +	if (COUNT_VARGS(cond) != 0) {					\
> +		__list_check_rcu_cond(0, ## cond);			\
> +	} else {							\
> +		__list_check_rcu();					\
> +	}								\
> +	for (pos = list_entry_rcu((head)->next, typeof(*pos), member);	\
> +		&pos->member != (head);					\
>  		pos = list_entry_rcu(pos->member.next, typeof(*pos), member))
>  
>  /**
> @@ -621,7 +648,12 @@ static inline void hlist_add_behind_rcu(struct hlist_node *n,
>   * the _rcu list-mutation primitives such as hlist_add_head_rcu()
>   * as long as the traversal is guarded by rcu_read_lock().
>   */
> +#define hlist_for_each_entry_rcu(pos, head, member, cond...)		\
> +	if (COUNT_VARGS(cond) != 0) {					\
> +		__list_check_rcu_cond(0, ## cond);			\
> +	} else {							\
> +		__list_check_rcu();					\
> +	}								\
>  	for (pos = hlist_entry_safe (rcu_dereference_raw(hlist_first_rcu(head)),\
>  			typeof(*(pos)), member);			\
>  		pos;							\


This breaks code like:

	if (...)
		list_for_each_entry_rcu(...);

as they are no longer a single statement. You'll have to frob it into
the initializer part of the for statement.
