Return-Path: <kernel-hardening-return-20671-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 06D2E2FE993
	for <lists+kernel-hardening@lfdr.de>; Thu, 21 Jan 2021 13:05:26 +0100 (CET)
Received: (qmail 15415 invoked by uid 550); 21 Jan 2021 12:05:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15391 invoked from network); 21 Jan 2021 12:05:17 -0000
Date: Thu, 21 Jan 2021 13:04:27 +0100
From: Alexey Gladkov <gladkov.alexey@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	io-uring <io-uring@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux Containers <containers@lists.linux-foundation.org>,
	Linux-MM <linux-mm@kvack.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
	Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC PATCH v3 1/8] Use refcount_t for ucounts reference counting
Message-ID: <20210121120427.iiggfmw3tpsmyzeb@example.org>
References: <cover.1610722473.git.gladkov.alexey@gmail.com>
 <116c7669744404364651e3b380db2d82bb23f983.1610722473.git.gladkov.alexey@gmail.com>
 <CAHk-=wjsg0Lgf1Mh2UiJE4sqBDDo0VhFVBUbhed47ot2CQQwfQ@mail.gmail.com>
 <20210118194551.h2hrwof7b3q5vgoi@example.org>
 <CAHk-=wiNpc5BS2BfZhdDqofJx1G=uasBa2Q1eY4cr8O59Rev2A@mail.gmail.com>
 <20210118205629.zro2qkd3ut42bpyq@example.org>
 <87eeig74kv.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eeig74kv.fsf@x220.int.ebiederm.org>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Thu, 21 Jan 2021 12:05:05 +0000 (UTC)

On Tue, Jan 19, 2021 at 07:57:36PM -0600, Eric W. Biederman wrote:
> Alexey Gladkov <gladkov.alexey@gmail.com> writes:
> 
> > On Mon, Jan 18, 2021 at 12:34:29PM -0800, Linus Torvalds wrote:
> >> On Mon, Jan 18, 2021 at 11:46 AM Alexey Gladkov
> >> <gladkov.alexey@gmail.com> wrote:
> >> >
> >> > Sorry about that. I thought that this code is not needed when switching
> >> > from int to refcount_t. I was wrong.
> >> 
> >> Well, you _may_ be right. I personally didn't check how the return
> >> value is used.
> >> 
> >> I only reacted to "it certainly _may_ be used, and there is absolutely
> >> no comment anywhere about why it wouldn't matter".
> >
> > I have not found examples where checked the overflow after calling
> > refcount_inc/refcount_add.
> >
> > For example in kernel/fork.c:2298 :
> >
> >    current->signal->nr_threads++;                           
> >    atomic_inc(&current->signal->live);                      
> >    refcount_inc(&current->signal->sigcnt);  
> >
> > $ semind search signal_struct.sigcnt
> > def include/linux/sched/signal.h:83  		refcount_t		sigcnt;
> > m-- kernel/fork.c:723 put_signal_struct 		if (refcount_dec_and_test(&sig->sigcnt))
> > m-- kernel/fork.c:1571 copy_signal 		refcount_set(&sig->sigcnt, 1);
> > m-- kernel/fork.c:2298 copy_process 				refcount_inc(&current->signal->sigcnt);
> >
> > It seems to me that the only way is to use __refcount_inc and then compare
> > the old value with REFCOUNT_MAX
> >
> > Since I have not seen examples of such checks, I thought that this is
> > acceptable. Sorry once again. I have not tried to hide these changes.
> 
> The current ucount code does check for overflow and fails the increment
> in every case.
> 
> So arguably it will be a regression and inferior error handling behavior
> if the code switches to the ``better'' refcount_t data structure.
> 
> I originally didn't use refcount_t because silently saturating and not
> bothering to handle the error makes me uncomfortable.
> 
> Not having to acquire the ucounts_lock every time seems nice.  Perhaps
> the path forward would be to start with stupid/correct code that always
> takes the ucounts_lock for every increment of ucounts->count, that is
> later replaced with something more optimal.
> 
> Not impacting performance in the non-namespace cases and having good
> performance in the other cases is a fundamental requirement of merging
> code like this.

Did I understand your suggestion correctly that you suggest to use
spin_lock for atomic_read and atomic_inc ?

If so, then we are already incrementing the counter under ucounts_lock.

	...
	if (atomic_read(&ucounts->count) == INT_MAX)
		ucounts = NULL;
	else
		atomic_inc(&ucounts->count);
	spin_unlock_irq(&ucounts_lock);
	return ucounts;

something like this ?

-- 
Rgrds, legion

