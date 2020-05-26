Return-Path: <kernel-hardening-return-18327-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B091A199569
	for <lists+kernel-hardening@lfdr.de>; Tue, 31 Mar 2020 13:39:30 +0200 (CEST)
Received: (qmail 3178 invoked by uid 550); 31 Mar 2020 11:39:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 5798 invoked from network); 30 Mar 2020 23:15:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585610096;
	bh=VVSNPfwNTi/eewRuFYhE6zHWE9KPNO3Iea9w8iAWJQU=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=siSm447IUzxXtgfrXMT+dm2UB+eOcmg2IHY8EYAANBKNIAAlzAe3U4hgLktrF2Nl0
	 Jj+C/sJZu0iMwZ9MwXpCOB6xmTvpUstfmu8CIgfvaT+eJiBiOgkJdKf16h2iNK/hEF
	 1nUyulakvnSeA5XBjFaYwTfmhRJCU+qwebq1dzVA=
Date: Mon, 30 Mar 2020 16:14:56 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>, kernel-team@android.com,
	kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 05/21] list: Comment missing WRITE_ONCE() in
 __list_del()
Message-ID: <20200330231456.GA19865@paulmck-ThinkPad-P72>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-6-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324153643.15527-6-will@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Tue, Mar 24, 2020 at 03:36:27PM +0000, Will Deacon wrote:
> Although __list_del() is called from the RCU list implementation, it
> omits WRITE_ONCE() when updating the 'prev' pointer for the 'next' node.
> This is reasonable because concurrent RCU readers only access the 'next'
> pointers.
> 
> Although it's obvious after reading the code, add a comment.
> 
> Cc: Paul E. McKenney <paulmck@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Will Deacon <will@kernel.org>

OK, I will take the easy one.  ;-)

Reviewed-by: Paul E. McKenney <paulmck@kernel.org>

> ---
>  include/linux/list.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/list.h b/include/linux/list.h
> index 4d9f5f9ed1a8..ec1f780d1449 100644
> --- a/include/linux/list.h
> +++ b/include/linux/list.h
> @@ -109,6 +109,7 @@ static inline void list_add_tail(struct list_head *new, struct list_head *head)
>   */
>  static inline void __list_del(struct list_head * prev, struct list_head * next)
>  {
> +	/* RCU readers don't read the 'prev' pointer */
>  	next->prev = prev;
>  	WRITE_ONCE(prev->next, next);
>  }
> -- 
> 2.20.1
> 
