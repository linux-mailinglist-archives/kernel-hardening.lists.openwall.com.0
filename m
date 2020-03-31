Return-Path: <kernel-hardening-return-18333-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 30E761996A4
	for <lists+kernel-hardening@lfdr.de>; Tue, 31 Mar 2020 14:37:58 +0200 (CEST)
Received: (qmail 5286 invoked by uid 550); 31 Mar 2020 12:37:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5251 invoked from network); 31 Mar 2020 12:37:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585658259;
	bh=IaryMowmAx4OQ//gy52Bp04tanIU0UkHswH1YoJsT8E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SaKeVZBvfVFoEHqJLbz1ikyoWwc6oN2EtK2dgUPhBs6A7eMaJkcCkeBD7yR+BoTB+
	 fN9koCz2ZA7p2MxmDkCWzVoCO/sBcqKe+CKQ6JmvllaeOK/niJZL+dwRlPk/dWe6cW
	 7bUzAdVBKCwc7tuOdTp0doCxc05rTxTRMi7cl4qE=
Date: Tue, 31 Mar 2020 13:37:34 +0100
From: Will Deacon <will@kernel.org>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>, kernel-team@android.com,
	kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 09/21] list: Remove unnecessary WRITE_ONCE() from
 hlist_bl_add_before()
Message-ID: <20200331123733.GB30061@willie-the-truck>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-10-will@kernel.org>
 <20200330233020.GF19865@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330233020.GF19865@paulmck-ThinkPad-P72>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Mar 30, 2020 at 04:30:20PM -0700, Paul E. McKenney wrote:
> On Tue, Mar 24, 2020 at 03:36:31PM +0000, Will Deacon wrote:
> > There is no need to use WRITE_ONCE() when inserting into a non-RCU
> > protected list.
> > 
> > Cc: Paul E. McKenney <paulmck@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Signed-off-by: Will Deacon <will@kernel.org>
> 
> OK, I will bite...  Why "unsigned long" instead of "uintptr_t"?

I just did that for consistency with the rest of the file, e.g.
hlist_bl_first(), hlist_bl_set_first(), hlist_bl_empty() and
__hlist_bl_del() all cast to 'unsigned long', yet only
hlist_bl_add_before() was using 'uintptr_t'

> Not that it matters in the context of the Linux kernel, so:
> 
> Reviewed-by: Paul E. McKenney <paulmck@kernel.org>

Thanks, Paul!

Will
