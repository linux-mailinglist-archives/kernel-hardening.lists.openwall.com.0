Return-Path: <kernel-hardening-return-18325-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 95102199567
	for <lists+kernel-hardening@lfdr.de>; Tue, 31 Mar 2020 13:39:15 +0200 (CEST)
Received: (qmail 1217 invoked by uid 550); 31 Mar 2020 11:39:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 3920 invoked from network); 30 Mar 2020 23:08:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585609672;
	bh=4AVexlNiYtLyPvD8KLzOZUsgxdPsZ/3OqrKRBK5t78U=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=eaMgIeH63FPjbwbmlPJ1EDvOTFm3tqCkT0ss3Y+WINaDPNQ/I4KjnasBeJbiDOt2L
	 5MGtBK1edC6BncMz8rT8XPOqspWxPMHbLCCJF+s2hhVMeB1/VazpACz3WjycFJQy2X
	 c2AXDCapRXA5Sjy7/HLSbURBVhd4l+B3/Wh9AUd8=
Date: Mon, 30 Mar 2020 16:07:52 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>, kernel-team@android.com,
	kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 02/21] list: Remove hlist_nulls_unhashed_lockless()
Message-ID: <20200330230752.GY19865@paulmck-ThinkPad-P72>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-3-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324153643.15527-3-will@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Tue, Mar 24, 2020 at 03:36:24PM +0000, Will Deacon wrote:
> Commit 02b99b38f3d9 ("rcu: Add a hlist_nulls_unhashed_lockless() function")
> introduced the (as yet unused) hlist_nulls_unhashed_lockless() function
> to avoid KCSAN reports when an RCU reader checks the 'hashed' status
> of an 'hlist_nulls' concurrently undergoing modification.
> 
> Remove the unused function and add a READ_ONCE() to hlist_nulls_unhashed(),
> just like we do already for hlist_nulls_empty().
> 
> Cc: Paul E. McKenney <paulmck@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Will Deacon <will@kernel.org>

Well, I guess that the added docbook comment might be seen as worthwhile.

Acked-by: Paul E. McKenney <paulmck@kernel.org>

> ---
>  include/linux/list_nulls.h | 14 --------------
>  1 file changed, 14 deletions(-)
> 
> diff --git a/include/linux/list_nulls.h b/include/linux/list_nulls.h
> index fa6e8471bd22..3a9ff01e9a11 100644
> --- a/include/linux/list_nulls.h
> +++ b/include/linux/list_nulls.h
> @@ -65,20 +65,6 @@ static inline unsigned long get_nulls_value(const struct hlist_nulls_node *ptr)
>   * but hlist_nulls_del() does not.
>   */
>  static inline int hlist_nulls_unhashed(const struct hlist_nulls_node *h)
> -{
> -	return !h->pprev;
> -}
> -
> -/**
> - * hlist_nulls_unhashed_lockless - Has node been removed and reinitialized?
> - * @h: Node to be checked
> - *
> - * Not that not all removal functions will leave a node in unhashed state.
> - * For example, hlist_del_init_rcu() leaves the node in unhashed state,
> - * but hlist_nulls_del() does not.  Unlike hlist_nulls_unhashed(), this
> - * function may be used locklessly.
> - */
> -static inline int hlist_nulls_unhashed_lockless(const struct hlist_nulls_node *h)
>  {
>  	return !READ_ONCE(h->pprev);
>  }
> -- 
> 2.20.1
> 
