Return-Path: <kernel-hardening-return-18181-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D376619163F
	for <lists+kernel-hardening@lfdr.de>; Tue, 24 Mar 2020 17:27:34 +0100 (CET)
Received: (qmail 9997 invoked by uid 550); 24 Mar 2020 16:27:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9963 invoked from network); 24 Mar 2020 16:27:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585067236;
	bh=OvenVnHl0wduNQ7fLdM6lGKydIJWaN8/+ujyCQPdt68=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GG3F8Z3DamEsezlqe5uUwSYKhHoSBCsOH1CvReBCyrJbdVmzoBSEaoPv/egxHTmqw
	 u4L57AFmtNusYvewOS2xMoZfz66EPnA9ADi25j1dMOKR7so8/uyDD8dVvPn0VitWNE
	 ItM72v4be6Kah5eRtkAqfyO66ZXiUl5G+bnYHRHM=
Date: Tue, 24 Mar 2020 17:27:14 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>, kernel-team@android.com,
	kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 01/21] list: Remove hlist_unhashed_lockless()
Message-ID: <20200324162714.GB2518046@kroah.com>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-2-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324153643.15527-2-will@kernel.org>

On Tue, Mar 24, 2020 at 03:36:23PM +0000, Will Deacon wrote:
> Commit c54a2744497d ("list: Add hlist_unhashed_lockless()") added a
> "lockless" variant of hlist_unhashed() that uses READ_ONCE() to access
> the 'pprev' pointer of the 'hlist_node', the intention being that this
> could be used by 'timer_pending()' to silence a KCSAN warning. As well
> as forgetting to add the caller, the patch also sprinkles
> {READ,WRITE}_ONCE() invocations over the standard (i.e. non-RCU) hlist
> code, which is undesirable for a number of reasons:
> 
>   1. It gives the misleading impression that the non-RCU hlist code is
>      in some way lock-free (despite the notable absence of any memory
>      barriers!) and silences KCSAN in such cases.
> 
>   2. It unnecessarily penalises code generation for non-RCU hlist users
> 
>   3. It makes it difficult to introduce list integrity checks because
>      of the possibility of concurrent callers.
> 
> Retain the {READ,WRITE}_ONCE() invocations for the RCU hlist code, but
> remove them from the non-RCU implementation. Remove the unused
> 'hlist_unhashed_lockless()' function entirely and add the READ_ONCE()
> to hlist_unhashed(), as we do already for hlist_empty() already.
> 
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Paul E. McKenney <paulmck@kernel.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  include/linux/list.h | 33 ++++++++++-----------------------
>  1 file changed, 10 insertions(+), 23 deletions(-)

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
