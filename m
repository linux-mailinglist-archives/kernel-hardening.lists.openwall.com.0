Return-Path: <kernel-hardening-return-20667-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C8A672FABF6
	for <lists+kernel-hardening@lfdr.de>; Mon, 18 Jan 2021 21:57:14 +0100 (CET)
Received: (qmail 26202 invoked by uid 550); 18 Jan 2021 20:57:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26179 invoked from network); 18 Jan 2021 20:57:08 -0000
Date: Mon, 18 Jan 2021 21:56:29 +0100
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
Message-ID: <20210118205629.zro2qkd3ut42bpyq@example.org>
References: <cover.1610722473.git.gladkov.alexey@gmail.com>
 <116c7669744404364651e3b380db2d82bb23f983.1610722473.git.gladkov.alexey@gmail.com>
 <CAHk-=wjsg0Lgf1Mh2UiJE4sqBDDo0VhFVBUbhed47ot2CQQwfQ@mail.gmail.com>
 <20210118194551.h2hrwof7b3q5vgoi@example.org>
 <CAHk-=wiNpc5BS2BfZhdDqofJx1G=uasBa2Q1eY4cr8O59Rev2A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiNpc5BS2BfZhdDqofJx1G=uasBa2Q1eY4cr8O59Rev2A@mail.gmail.com>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Mon, 18 Jan 2021 20:56:57 +0000 (UTC)

On Mon, Jan 18, 2021 at 12:34:29PM -0800, Linus Torvalds wrote:
> On Mon, Jan 18, 2021 at 11:46 AM Alexey Gladkov
> <gladkov.alexey@gmail.com> wrote:
> >
> > Sorry about that. I thought that this code is not needed when switching
> > from int to refcount_t. I was wrong.
> 
> Well, you _may_ be right. I personally didn't check how the return
> value is used.
> 
> I only reacted to "it certainly _may_ be used, and there is absolutely
> no comment anywhere about why it wouldn't matter".

I have not found examples where checked the overflow after calling
refcount_inc/refcount_add.

For example in kernel/fork.c:2298 :

   current->signal->nr_threads++;                           
   atomic_inc(&current->signal->live);                      
   refcount_inc(&current->signal->sigcnt);  

$ semind search signal_struct.sigcnt
def include/linux/sched/signal.h:83  		refcount_t		sigcnt;
m-- kernel/fork.c:723 put_signal_struct 		if (refcount_dec_and_test(&sig->sigcnt))
m-- kernel/fork.c:1571 copy_signal 		refcount_set(&sig->sigcnt, 1);
m-- kernel/fork.c:2298 copy_process 				refcount_inc(&current->signal->sigcnt);

It seems to me that the only way is to use __refcount_inc and then compare
the old value with REFCOUNT_MAX

Since I have not seen examples of such checks, I thought that this is
acceptable. Sorry once again. I have not tried to hide these changes.

-- 
Rgrds, legion

