Return-Path: <kernel-hardening-return-18332-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 41722199571
	for <lists+kernel-hardening@lfdr.de>; Tue, 31 Mar 2020 13:40:21 +0200 (CEST)
Received: (qmail 7492 invoked by uid 550); 31 Mar 2020 11:39:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 9913 invoked from network); 30 Mar 2020 23:32:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585611150;
	bh=8b5HIjf7fUEp9ElalKXw7B8EDu2hSeQR4NS2umfR6BM=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=BluPqwgNhvMqV0zGuT57PqZr56rwdmxMcr223hkonDn0I00AwCaitFsFBKt+pixN1
	 H5Y0OX22+SWSMcTL2Sy6fy1bGjEsc9r2fLGJVdwQ+phFxc9eQYhqmX0g5N8FjzQawb
	 Xyv5YxqNpj2JfF7xMU6P2QQdCn8rpY1GaG1ybH3c=
Date: Mon, 30 Mar 2020 16:32:29 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>, kernel-team@android.com,
	kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 12/21] list: Poison ->next pointer for non-RCU
 deletion of 'hlist_nulls_node'
Message-ID: <20200330233229.GG19865@paulmck-ThinkPad-P72>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-13-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324153643.15527-13-will@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Tue, Mar 24, 2020 at 03:36:34PM +0000, Will Deacon wrote:
> hlist_nulls_del() is used for non-RCU deletion of an 'hlist_nulls_node'
> and so we can safely poison the ->next pointer without having to worry
> about concurrent readers, just like we do for other non-RCU list
> deletion primitives
> 
> Cc: Paul E. McKenney <paulmck@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Will Deacon <will@kernel.org>

Agreed, any code having difficulty with this change should use instead
hlist_nulls_del_rcu().

Reviewed-by: Paul E. McKenney <paulmck@kernel.org>

> ---
>  include/linux/list_nulls.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/list_nulls.h b/include/linux/list_nulls.h
> index fd154ceb5b0d..48f33ae16381 100644
> --- a/include/linux/list_nulls.h
> +++ b/include/linux/list_nulls.h
> @@ -99,6 +99,7 @@ static inline void __hlist_nulls_del(struct hlist_nulls_node *n)
>  static inline void hlist_nulls_del(struct hlist_nulls_node *n)
>  {
>  	__hlist_nulls_del(n);
> +	n->next = LIST_POISON1;
>  	n->pprev = LIST_POISON2;
>  }
>  
> -- 
> 2.20.1
> 
