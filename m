Return-Path: <kernel-hardening-return-18190-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 07DA819170A
	for <lists+kernel-hardening@lfdr.de>; Tue, 24 Mar 2020 17:56:59 +0100 (CET)
Received: (qmail 3570 invoked by uid 550); 24 Mar 2020 16:56:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3539 invoked from network); 24 Mar 2020 16:56:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XFIGNUpDtx5h3b6b+QEOb2QoBDkARJdMv8Frt7I6mcA=;
        b=QxhaqVRqxE0tPjxrjiFFHwiVs8u2p615mXSrju0U3UuWgoLLYUWEQU+OKjgjF53E9c
         q5jtVRTHsvMjYvRETJyKjbrLGxHHYT278X1y0HsDX/H+j7Tq8y25cJmSkPVjbnclwjOH
         Y6XGY+xWWe229Z8UWWIo1D/YiQ9kPJC5idX6IFKK/1MZtnKtL2TXRieh3d08F2EI2PWT
         AfWmBbNVlKl0O+Gy7tLu+op1tpAXWzcSVj53v2/JJjS3GKfGybabnAsy9OaQ6/5bP/QQ
         CpGjLqa9p84STUG0co/tM5DY38XvrfrMhoE3ofKqSBC2JtAuuDkr1DXqPTEFYJNqNK/U
         CtTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XFIGNUpDtx5h3b6b+QEOb2QoBDkARJdMv8Frt7I6mcA=;
        b=RQj/DM6dCFkQmX+uOdOfK1b8vE00QB/vWQCWVaVt8SfilveXSLWjeeqIBI6bE38UeM
         c6TSQhdC8ZGMamibo4iQf/w1X7toh97BkxWrAUcJukJmhhSX3Kehe+riWW3uUGgyLJQ/
         smiTK0SW1Fih38fkJCRrDG/eoPxr3ty3e2bDQx1vzXPt4QNVrSDmcdMkQfeloAJhtTwC
         YZ8oD6IR7XhFf/bymwSbHaRjrONluUwxyhiBXv4JSIYkgDSwYVOMNEMF0TAex4F+ai6a
         gVjzQo76HnR3alRsmpX1k7vQ/dTNBASGr6HEdpNbbhwEjK1wKBfO/WMWMQjSlp4FWmGp
         TBZw==
X-Gm-Message-State: ANhLgQ3bqq/5K9w1WYNzH8KnVvTS+Jiy/Zgldwr879I7PJ0HUNElVE/9
	ECGcZuPjIApg1V/zz5WZPfLCXcAEkCB6Yb7HlD4uSQ==
X-Google-Smtp-Source: ADFU+vv3k8ZkJQxHJmVmXT2nkkdi7lVh9FsmwbzVxxYv13+3VtTq5l/toW1odvSLvnTLqAuk7oiHpfiw6M+O+7TBNRI=
X-Received: by 2002:a19:ad43:: with SMTP id s3mr10218645lfd.63.1585069002228;
 Tue, 24 Mar 2020 09:56:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200324153643.15527-1-will@kernel.org> <20200324153643.15527-4-will@kernel.org>
 <20200324165128.GS20696@hirez.programming.kicks-ass.net>
In-Reply-To: <20200324165128.GS20696@hirez.programming.kicks-ass.net>
From: Jann Horn <jannh@google.com>
Date: Tue, 24 Mar 2020 17:56:15 +0100
Message-ID: <CAG48ez2WJo5+wqWi1nxstR=WWyseVfZPMnpdDBsZKW5G+Tt3KQ@mail.gmail.com>
Subject: Re: [RFC PATCH 03/21] list: Annotate lockless list primitives with data_race()
To: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>, kernel list <linux-kernel@vger.kernel.org>, 
	Eric Dumazet <edumazet@google.com>, Kees Cook <keescook@chromium.org>, 
	Maddie Stone <maddiestone@google.com>, Marco Elver <elver@google.com>, 
	"Paul E . McKenney" <paulmck@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	kernel-team <kernel-team@android.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Mar 24, 2020 at 5:51 PM Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Mar 24, 2020 at 03:36:25PM +0000, Will Deacon wrote:
> > diff --git a/include/linux/list.h b/include/linux/list.h
> > index 4fed5a0f9b77..4d9f5f9ed1a8 100644
> > --- a/include/linux/list.h
> > +++ b/include/linux/list.h
> > @@ -279,7 +279,7 @@ static inline int list_is_last(const struct list_head *list,
> >   */
> >  static inline int list_empty(const struct list_head *head)
> >  {
> > -     return READ_ONCE(head->next) == head;
> > +     return data_race(READ_ONCE(head->next) == head);
> >  }
>
> list_empty() isn't lockless safe, that's what we have
> list_empty_careful() for.

That thing looks like it could also use some READ_ONCE() sprinkled in...
