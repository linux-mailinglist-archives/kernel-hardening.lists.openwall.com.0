Return-Path: <kernel-hardening-return-18326-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 06C15199568
	for <lists+kernel-hardening@lfdr.de>; Tue, 31 Mar 2020 13:39:22 +0200 (CEST)
Received: (qmail 1575 invoked by uid 550); 31 Mar 2020 11:39:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 5620 invoked from network); 30 Mar 2020 23:13:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585609996;
	bh=PpxCxvKLaRJ3LSmf1WVhJNuLiZcY8a+gLLy8BYzmxKs=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
	b=bL+lH8/woQHRfbfj6X0OQm3jLCC/PyAVz624J3d3ldSRIkJT1jDwr7HQW+n0LG4Il
	 CyGPUF3pinRoPEQQoJC46Cjh8gikh9/dc4Jec+VcryFNQe9hEtROWG/kt4gf4h1Djk
	 e5Bz7vm38oee3hPXpXnLakPax4v+rbh77n/XESIQ=
Date: Mon, 30 Mar 2020 16:13:15 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Will Deacon <will@kernel.org>
Cc: Jann Horn <jannh@google.com>, Peter Zijlstra <peterz@infradead.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	kernel-team <kernel-team@android.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC PATCH 03/21] list: Annotate lockless list primitives with
 data_race()
Message-ID: <20200330231315.GZ19865@paulmck-ThinkPad-P72>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-4-will@kernel.org>
 <20200324165128.GS20696@hirez.programming.kicks-ass.net>
 <CAG48ez2WJo5+wqWi1nxstR=WWyseVfZPMnpdDBsZKW5G+Tt3KQ@mail.gmail.com>
 <20200324213200.GA21176@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200324213200.GA21176@willie-the-truck>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Tue, Mar 24, 2020 at 09:32:01PM +0000, Will Deacon wrote:
> [mutt crashed while I was sending this; apologies if you receive it twice]
> 
> On Tue, Mar 24, 2020 at 05:56:15PM +0100, Jann Horn wrote:
> > On Tue, Mar 24, 2020 at 5:51 PM Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Tue, Mar 24, 2020 at 03:36:25PM +0000, Will Deacon wrote:
> > > > diff --git a/include/linux/list.h b/include/linux/list.h
> > > > index 4fed5a0f9b77..4d9f5f9ed1a8 100644
> > > > --- a/include/linux/list.h
> > > > +++ b/include/linux/list.h
> > > > @@ -279,7 +279,7 @@ static inline int list_is_last(const struct list_head *list,
> > > >   */
> > > >  static inline int list_empty(const struct list_head *head)
> > > >  {
> > > > -     return READ_ONCE(head->next) == head;
> > > > +     return data_race(READ_ONCE(head->next) == head);
> > > >  }
> > >
> > > list_empty() isn't lockless safe, that's what we have
> > > list_empty_careful() for.
> > 
> > That thing looks like it could also use some READ_ONCE() sprinkled in...
> 
> Crikey, how did I miss that? I need to spend some time understanding the
> ordering there.
> 
> So it sounds like the KCSAN splats relating to list_empty() and loosely
> referred to by 1c97be677f72 ("list: Use WRITE_ONCE() when adding to lists
> and hlists") are indicative of real bugs and we should actually restore
> list_empty() to its former glory prior to 1658d35ead5d ("list: Use
> READ_ONCE() when testing for empty lists"). Alternatively, assuming
> list_empty_careful() does what it says on the tin, we could just make that
> the default.

The list_empty_careful() function (suitably annotated) returns false if
the list is non-empty, including when it is in the process of becoming
either empty or non-empty.  It would be fine for the lockless use cases
I have come across.

							Thanx, Paul
