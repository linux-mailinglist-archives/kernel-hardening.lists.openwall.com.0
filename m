Return-Path: <kernel-hardening-return-18329-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3658519956B
	for <lists+kernel-hardening@lfdr.de>; Tue, 31 Mar 2020 13:39:48 +0200 (CEST)
Received: (qmail 5304 invoked by uid 550); 31 Mar 2020 11:39:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 7466 invoked from network); 30 Mar 2020 23:20:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585610391;
	bh=knMGEU53xC+KPtKJP1jsuRoJ7sa4gkeHaJVEPUc4f7Y=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=U5XF6eygiF8K/M6F+FMs3jEOjwHcIgGS9MuHISkDZX3KyqITcsD8Xs1yD+UVKVXGM
	 tHl5zq4QhbfFv04/h+wmlll0DUgUESlTLoM1jqIkVs9LBv9cVPtQVTw1oM7Js11ZuJ
	 zKnLUqTXu2m7dAXVATi7QmOizyd+rO8Af/b1+3P0=
Date: Mon, 30 Mar 2020 16:19:51 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>, kernel-team@android.com,
	kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 07/21] Revert "list: Use WRITE_ONCE() when adding to
 lists and hlists"
Message-ID: <20200330231951.GB19865@paulmck-ThinkPad-P72>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-8-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324153643.15527-8-will@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Tue, Mar 24, 2020 at 03:36:29PM +0000, Will Deacon wrote:
> This reverts commit 1c97be677f72b3c338312aecd36d8fff20322f32.
> 
> There is no need to use WRITE_ONCE() for the non-RCU list and hlist
> implementations.
> 
> Cc: Paul E. McKenney <paulmck@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Will Deacon <will@kernel.org>

Which means that the lockless uses of hlist_empty() will also need
attention, correct?

							Thanx, Paul

> ---
>  include/linux/list.h | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/list.h b/include/linux/list.h
> index ec1f780d1449..c7331c259792 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -70,7 +70,7 @@ static inline void __list_add(struct list_head *new,
>  	next->prev = new;
>  	new->next = next;
>  	new->prev = prev;
> -	WRITE_ONCE(prev->next, new);
> +	prev->next = new;
>  }
>  
>  /**
> @@ -843,7 +843,7 @@ static inline void hlist_add_head(struct hlist_node *n, struct hlist_head *h)
>  	n->next = first;
>  	if (first)
>  		first->pprev = &n->next;
> -	WRITE_ONCE(h->first, n);
> +	h->first = n;
>  	n->pprev = &h->first;
>  }
>  
> @@ -858,7 +858,7 @@ static inline void hlist_add_before(struct hlist_node *n,
>  	n->pprev = next->pprev;
>  	n->next = next;
>  	next->pprev = &n->next;
> -	WRITE_ONCE(*(n->pprev), n);
> +	*(n->pprev) = n;
>  }
>  
>  /**
> -- 
> 2.20.1
> 
