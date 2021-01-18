Return-Path: <kernel-hardening-return-20665-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6AECE2FAA74
	for <lists+kernel-hardening@lfdr.de>; Mon, 18 Jan 2021 20:46:25 +0100 (CET)
Received: (qmail 13875 invoked by uid 550); 18 Jan 2021 19:46:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13855 invoked from network); 18 Jan 2021 19:46:19 -0000
Date: Mon, 18 Jan 2021 20:45:51 +0100
From: Alexey Gladkov <gladkov.alexey@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	io-uring <io-uring@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux Containers <containers@lists.linux-foundation.org>,
	Linux-MM <linux-mm@kvack.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
	Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC PATCH v3 1/8] Use refcount_t for ucounts reference counting
Message-ID: <20210118194551.h2hrwof7b3q5vgoi@example.org>
References: <cover.1610722473.git.gladkov.alexey@gmail.com>
 <116c7669744404364651e3b380db2d82bb23f983.1610722473.git.gladkov.alexey@gmail.com>
 <CAHk-=wjsg0Lgf1Mh2UiJE4sqBDDo0VhFVBUbhed47ot2CQQwfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjsg0Lgf1Mh2UiJE4sqBDDo0VhFVBUbhed47ot2CQQwfQ@mail.gmail.com>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Mon, 18 Jan 2021 19:46:07 +0000 (UTC)

On Mon, Jan 18, 2021 at 11:14:48AM -0800, Linus Torvalds wrote:
> On Fri, Jan 15, 2021 at 6:59 AM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
> >
> > @@ -152,10 +153,7 @@ static struct ucounts *get_ucounts(struct user_namespace *ns, kuid_t uid)
> >                         ucounts = new;
> >                 }
> >         }
> > -       if (ucounts->count == INT_MAX)
> > -               ucounts = NULL;
> > -       else
> > -               ucounts->count += 1;
> > +       refcount_inc(&ucounts->count);
> >         spin_unlock_irq(&ucounts_lock);
> >         return ucounts;
> >  }
> 
> This is wrong.
> 
> It used to return NULL when the count saturated.
> 
> Now it just silently saturates.
> 
> I'm not sure how many people care, but that NULL return ends up being
> returned quite widely (through "inc_uncount()" and friends).
> 
> The fact that this has no commit message at all to explain what it is
> doing and why is also a grounds for just NAK.

Sorry about that. I thought that this code is not needed when switching
from int to refcount_t. I was wrong. I'll think about how best to check
it.

-- 
Rgrds, legion

