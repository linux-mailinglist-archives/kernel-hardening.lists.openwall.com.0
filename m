Return-Path: <kernel-hardening-return-18633-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 176AD1B7D1A
	for <lists+kernel-hardening@lfdr.de>; Fri, 24 Apr 2020 19:39:57 +0200 (CEST)
Received: (qmail 13631 invoked by uid 550); 24 Apr 2020 17:39:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13604 invoked from network); 24 Apr 2020 17:39:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1587749978;
	bh=ykdr8Ad8jl8gHvtaRn/WVhFxDPP4Du64k/eazMGYOcg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Zm+H2R6y6P9TayzzrFFqaP9FIGHRcB5Zf9vvEDfKBAa6HRNHevNmJoa9cD2B46+de
	 ZI+jYRehLuoBGmabynajkJb7OUlD6KpgjQ8k0bDc8XQDc0QaY7FzSXVdr0j918B5gG
	 dtpAwTMmv2RPzj/xWWZd7COR04RQ5XSNv7tuatCo=
Date: Fri, 24 Apr 2020 18:39:33 +0100
From: Will Deacon <will@kernel.org>
To: "Paul E. McKenney" <paulmck@kernel.org>
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
Message-ID: <20200424173932.GK21141@willie-the-truck>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-4-will@kernel.org>
 <20200324165128.GS20696@hirez.programming.kicks-ass.net>
 <CAG48ez2WJo5+wqWi1nxstR=WWyseVfZPMnpdDBsZKW5G+Tt3KQ@mail.gmail.com>
 <20200324213200.GA21176@willie-the-truck>
 <20200330231315.GZ19865@paulmck-ThinkPad-P72>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330231315.GZ19865@paulmck-ThinkPad-P72>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Mar 30, 2020 at 04:13:15PM -0700, Paul E. McKenney wrote:
> On Tue, Mar 24, 2020 at 09:32:01PM +0000, Will Deacon wrote:
> > [mutt crashed while I was sending this; apologies if you receive it twice]
> > 
> > On Tue, Mar 24, 2020 at 05:56:15PM +0100, Jann Horn wrote:
> > > On Tue, Mar 24, 2020 at 5:51 PM Peter Zijlstra <peterz@infradead.org> wrote:
> > > > On Tue, Mar 24, 2020 at 03:36:25PM +0000, Will Deacon wrote:
> > > > > diff --git a/include/linux/list.h b/include/linux/list.h
> > > > > index 4fed5a0f9b77..4d9f5f9ed1a8 100644
> > > > > --- a/include/linux/list.h
> > > > > +++ b/include/linux/list.h
> > > > > @@ -279,7 +279,7 @@ static inline int list_is_last(const struct list_head *list,
> > > > >   */
> > > > >  static inline int list_empty(const struct list_head *head)
> > > > >  {
> > > > > -     return READ_ONCE(head->next) == head;
> > > > > +     return data_race(READ_ONCE(head->next) == head);
> > > > >  }
> > > >
> > > > list_empty() isn't lockless safe, that's what we have
> > > > list_empty_careful() for.
> > > 
> > > That thing looks like it could also use some READ_ONCE() sprinkled in...
> > 
> > Crikey, how did I miss that? I need to spend some time understanding the
> > ordering there.
> > 
> > So it sounds like the KCSAN splats relating to list_empty() and loosely
> > referred to by 1c97be677f72 ("list: Use WRITE_ONCE() when adding to lists
> > and hlists") are indicative of real bugs and we should actually restore
> > list_empty() to its former glory prior to 1658d35ead5d ("list: Use
> > READ_ONCE() when testing for empty lists"). Alternatively, assuming
> > list_empty_careful() does what it says on the tin, we could just make that
> > the default.
> 
> The list_empty_careful() function (suitably annotated) returns false if
> the list is non-empty, including when it is in the process of becoming
> either empty or non-empty.  It would be fine for the lockless use cases
> I have come across.

Hmm, I had a look at the implementation and I'm not at all convinced that
it's correct. First of all, the comment above it states:

 * NOTE: using list_empty_careful() without synchronization
 * can only be safe if the only activity that can happen
 * to the list entry is list_del_init(). Eg. it cannot be used
 * if another CPU could re-list_add() it.

but it seems that people disregard this note and instead use it as a
general-purpose lockless test, taking a lock and rechecking if it returns
non-empty. It would also mean we'd have to keep the WRITE_ONCE() in
INIT_LIST_HEAD, which is something that I've been trying to remove.

In the face of something like a concurrent list_add(); list_add_tail()
sequence, then the tearing writes to the head->{prev,next} pointers could
cause list_empty_careful() to indicate that the list is momentarily empty.

I've started looking at whether we can use a NULL next pointer to indicate
an empty list, which might allow us to kill the __list_del_clearprev() hack
at the same time, but I've not found enough time to really get my teeth into
it yet.

Will
