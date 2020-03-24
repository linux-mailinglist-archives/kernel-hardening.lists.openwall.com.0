Return-Path: <kernel-hardening-return-18213-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5525C191BFA
	for <lists+kernel-hardening@lfdr.de>; Tue, 24 Mar 2020 22:32:23 +0100 (CET)
Received: (qmail 1362 invoked by uid 550); 24 Mar 2020 21:32:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1339 invoked from network); 24 Mar 2020 21:32:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585085526;
	bh=WAEG2qvqlmwF1kcQfLLblGPBwt/+mnbg8XT6Bvt/JzM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XX6bno7D7g8zvIKr88jks2+DO+aByMHZAU1xp4RtU01CeTnn/b6I7lqzXtSZsziOh
	 AfEt7apQ8lT6qPLpDCTIiZ61oloIGP/8cmXQjODGz9mSHQTeVTMfQ660utCXUNa0OO
	 /aUabDZwpOhhyegZa1iTUpYJBgg8u7z7F/lxGClY=
Date: Tue, 24 Mar 2020 21:32:01 +0000
From: Will Deacon <will@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	Marco Elver <elver@google.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	kernel-team <kernel-team@android.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC PATCH 03/21] list: Annotate lockless list primitives with
 data_race()
Message-ID: <20200324213200.GA21176@willie-the-truck>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-4-will@kernel.org>
 <20200324165128.GS20696@hirez.programming.kicks-ass.net>
 <CAG48ez2WJo5+wqWi1nxstR=WWyseVfZPMnpdDBsZKW5G+Tt3KQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez2WJo5+wqWi1nxstR=WWyseVfZPMnpdDBsZKW5G+Tt3KQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

[mutt crashed while I was sending this; apologies if you receive it twice]

On Tue, Mar 24, 2020 at 05:56:15PM +0100, Jann Horn wrote:
> On Tue, Mar 24, 2020 at 5:51 PM Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, Mar 24, 2020 at 03:36:25PM +0000, Will Deacon wrote:
> > > diff --git a/include/linux/list.h b/include/linux/list.h
> > > index 4fed5a0f9b77..4d9f5f9ed1a8 100644
> > > --- a/include/linux/list.h
> > > +++ b/include/linux/list.h
> > > @@ -279,7 +279,7 @@ static inline int list_is_last(const struct list_head *list,
> > >   */
> > >  static inline int list_empty(const struct list_head *head)
> > >  {
> > > -     return READ_ONCE(head->next) == head;
> > > +     return data_race(READ_ONCE(head->next) == head);
> > >  }
> >
> > list_empty() isn't lockless safe, that's what we have
> > list_empty_careful() for.
> 
> That thing looks like it could also use some READ_ONCE() sprinkled in...

Crikey, how did I miss that? I need to spend some time understanding the
ordering there.

So it sounds like the KCSAN splats relating to list_empty() and loosely
referred to by 1c97be677f72 ("list: Use WRITE_ONCE() when adding to lists
and hlists") are indicative of real bugs and we should actually restore
list_empty() to its former glory prior to 1658d35ead5d ("list: Use
READ_ONCE() when testing for empty lists"). Alternatively, assuming
list_empty_careful() does what it says on the tin, we could just make that
the default.

Will
