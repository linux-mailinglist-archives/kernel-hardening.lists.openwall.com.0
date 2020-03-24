Return-Path: <kernel-hardening-return-18182-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3EA08191652
	for <lists+kernel-hardening@lfdr.de>; Tue, 24 Mar 2020 17:27:47 +0100 (CET)
Received: (qmail 11733 invoked by uid 550); 24 Mar 2020 16:27:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11699 invoked from network); 24 Mar 2020 16:27:39 -0000
Date: Tue, 24 Mar 2020 17:27:25 +0100
From: Greg KH <greg@kroah.com>
To: Will Deacon <will@kernel.org>
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>, kernel-team@android.com,
	kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 02/21] list: Remove hlist_nulls_unhashed_lockless()
Message-ID: <20200324162725.GC2518046@kroah.com>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-3-will@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324153643.15527-3-will@kernel.org>

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
> ---
>  include/linux/list_nulls.h | 14 --------------
>  1 file changed, 14 deletions(-)

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
