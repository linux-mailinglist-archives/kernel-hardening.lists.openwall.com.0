Return-Path: <kernel-hardening-return-20778-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 46401321424
	for <lists+kernel-hardening@lfdr.de>; Mon, 22 Feb 2021 11:28:19 +0100 (CET)
Received: (qmail 9354 invoked by uid 550); 22 Feb 2021 10:28:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9332 invoked from network); 22 Feb 2021 10:28:12 -0000
Date: Mon, 22 Feb 2021 11:27:33 +0100
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
Subject: Re: [PATCH v6 0/7] Count rlimits in each user namespace
Message-ID: <20210222102733.gic3q7dniljlbosm@example.org>
References: <cover.1613392826.git.gladkov.alexey@gmail.com>
 <CAHk-=wjsmAXyYZs+QQFQtY=w-pOOSWoi-ukvoBVVjBnb+v3q7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjsmAXyYZs+QQFQtY=w-pOOSWoi-ukvoBVVjBnb+v3q7A@mail.gmail.com>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Mon, 22 Feb 2021 10:28:01 +0000 (UTC)

On Sun, Feb 21, 2021 at 02:20:00PM -0800, Linus Torvalds wrote:
> On Mon, Feb 15, 2021 at 4:42 AM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
> >
> > These patches are for binding the rlimit counters to a user in user namespace.
> 
> So this is now version 6, but I think the kernel test robot keeps
> complaining about them causing KASAN issues.
> 
> The complaints seem to change, so I'm hoping they get fixed, but it
> does seem like every version there's a new one. Hmm?

First, KASAN found an unexpected bug in the second patch (Add a reference
to ucounts for each cred). Because I missed that creed_alloc_blank() is
used wider than I found.

Now KASAN has found problems in the RLIMIT_MEMLOCK which I believe I fixed
in v7.

-- 
Rgrds, legion

