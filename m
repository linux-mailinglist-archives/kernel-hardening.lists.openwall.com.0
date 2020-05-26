Return-Path: <kernel-hardening-return-18334-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E4ECE199703
	for <lists+kernel-hardening@lfdr.de>; Tue, 31 Mar 2020 15:10:27 +0200 (CEST)
Received: (qmail 16354 invoked by uid 550); 31 Mar 2020 13:10:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 16316 invoked from network); 31 Mar 2020 13:10:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585660208;
	bh=ts/jwCIfi83GogPG5jQKnlmOLa3e5lymvLi0SUUKZxQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z4uoSLgMdWSrhvR+cLyS50YXcM/8YIApUCCqSAdaLXZzv6keHgUATjrrGX6OC9ohA
	 9LHEth9UJklbVgScbX297IS6DdvFPQKRNqNXOepFq61AnlIWxmHQMyFJ1WfYr9XJXI
	 Z1sAyxQN20CP8gTCBEE6NiK+BURMf7PGrqIaP+mc=
Date: Tue, 31 Mar 2020 14:10:03 +0100
From: Will Deacon <will@kernel.org>
To: Marco Elver <elver@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Eric Dumazet <edumazet@google.com>,
	Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
	Maddie Stone <maddiestone@google.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>, kernel-team@android.com,
	kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 03/21] list: Annotate lockless list primitives with
 data_race()
Message-ID: <20200331131002.GA30975@willie-the-truck>
References: <20200324153643.15527-1-will@kernel.org>
 <20200324153643.15527-4-will@kernel.org>
 <CANpmjNPWpkxqZQJJOwmx0oqvzfcxhtqErjCzjRO_y0BQSmre8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNPWpkxqZQJJOwmx0oqvzfcxhtqErjCzjRO_y0BQSmre8A@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Mar 24, 2020 at 05:23:30PM +0100, Marco Elver wrote:
> On Tue, 24 Mar 2020 at 16:37, Will Deacon <will@kernel.org> wrote:
> > Some list predicates can be used locklessly even with the non-RCU list
> > implementations, since they effectively boil down to a test against
> > NULL. For example, checking whether or not a list is empty is safe even
> > in the presence of a concurrent, tearing write to the list head pointer.
> > Similarly, checking whether or not an hlist node has been hashed is safe
> > as well.
> >
> > Annotate these lockless list predicates with data_race() and READ_ONCE()
> > so that KCSAN and the compiler are aware of what's going on. The writer
> > side can then avoid having to use WRITE_ONCE() in the non-RCU
> > implementation.
> >
> > Cc: Paul E. McKenney <paulmck@kernel.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Marco Elver <elver@google.com>
> > Signed-off-by: Will Deacon <will@kernel.org>
> > ---
> >  include/linux/list.h       | 10 +++++-----
> >  include/linux/list_bl.h    |  5 +++--
> >  include/linux/list_nulls.h |  6 +++---
> >  include/linux/llist.h      |  2 +-
> >  4 files changed, 12 insertions(+), 11 deletions(-)
> >
> > diff --git a/include/linux/list.h b/include/linux/list.h
> > index 4fed5a0f9b77..4d9f5f9ed1a8 100644
> > --- a/include/linux/list.h
> > +++ b/include/linux/list.h
> > @@ -279,7 +279,7 @@ static inline int list_is_last(const struct list_head *list,
> >   */
> >  static inline int list_empty(const struct list_head *head)
> >  {
> > -       return READ_ONCE(head->next) == head;
> > +       return data_race(READ_ONCE(head->next) == head);
> 
> Double-marking should never be necessary, at least if you want to make
> KCSAN happy. From what I gather there is an unmarked write somewhere,
> correct? In that case, KCSAN will still complain because if it sees a
> race between this read and the other write, then at least one is still
> plain (the write).

Ok, then I should drop the data_race() annotation and stick to READ_ONCE(),
I think (but see below).

> Then, my suggestion would be to mark the write with data_race() and
> just leave this as a READ_ONCE(). Having a data_race() somewhere only
> makes KCSAN stop reporting the race if the paired access is also
> marked (be it with data_race() or _ONCE, etc.).

The problem with taking that approach is that it ends up much of the
list implementation annotated with either WRITE_ONCE() or data_race(),
meaning that concurrent, racy list operations will no longer be reported
by KCSAN. I think that's a pretty big deal and I'm strongly against
annotating the internals of library code such as this because it means
that buggy callers will largely go undetected.

The situation we have here is that some calls, e.g. hlist_empty() are
safe even in the presence of a racy write and I'd like to suppress KCSAN
reports without annotating the writes at all.

> Alternatively, if marking the write is impossible, you can surround
> the access with kcsan_disable_current()/kcsan_enable_current(). Or, as
> a last resort, just leaving as-is is fine too, because KCSAN's default
> config (still) has KCSAN_ASSUME_PLAIN_WRITES_ATOMIC selected.

Hmm, I suppose some bright spark will want to change the default at the some
point though, no? ;) I'll look at using
kcsan_disable_current()/kcsan_enable_current(), thanks.

Will
