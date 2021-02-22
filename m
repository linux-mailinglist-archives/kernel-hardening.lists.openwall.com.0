Return-Path: <kernel-hardening-return-20777-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 65BF73213D1
	for <lists+kernel-hardening@lfdr.de>; Mon, 22 Feb 2021 11:12:04 +0100 (CET)
Received: (qmail 1453 invoked by uid 550); 22 Feb 2021 10:11:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1432 invoked from network); 22 Feb 2021 10:11:58 -0000
Date: Mon, 22 Feb 2021 11:11:41 +0100
From: Alexey Gladkov <gladkov.alexey@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: LKML <linux-kernel@vger.kernel.org>, io-uring@vger.kernel.org,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux Containers <containers@lists.linux-foundation.org>,
	linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v6 3/7] Reimplement RLIMIT_NPROC on top of ucounts
Message-ID: <20210222101141.uve6hnftsakf4u7n@example.org>
References: <cover.1613392826.git.gladkov.alexey@gmail.com>
 <72fdcd154bec7e0dfad090f1af65ddac1e767451.1613392826.git.gladkov.alexey@gmail.com>
 <72214339-57fc-e47f-bb57-d1b39c69e38e@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72214339-57fc-e47f-bb57-d1b39c69e38e@kernel.dk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Mon, 22 Feb 2021 10:11:46 +0000 (UTC)

On Sun, Feb 21, 2021 at 04:38:10PM -0700, Jens Axboe wrote:
> On 2/15/21 5:41 AM, Alexey Gladkov wrote:
> > diff --git a/fs/io-wq.c b/fs/io-wq.c
> > index a564f36e260c..5b6940c90c61 100644
> > --- a/fs/io-wq.c
> > +++ b/fs/io-wq.c
> > @@ -1090,10 +1091,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
> >  		wqe->node = alloc_node;
> >  		wqe->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
> >  		atomic_set(&wqe->acct[IO_WQ_ACCT_BOUND].nr_running, 0);
> > -		if (wq->user) {
> > -			wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers =
> > -					task_rlimit(current, RLIMIT_NPROC);
> > -		}
> > +		wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers = task_rlimit(current, RLIMIT_NPROC);
> 
> This doesn't look like an equivalent transformation. But that may be
> moot if we merge the io_uring-worker.v3 series, as then you would not
> have to touch io-wq at all.

In the current code the wq->user is always set to current_user():

io_uring_create [1]
`- io_sq_offload_create
   `- io_init_wq_offload [2]
      `-io_wq_create [3]

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/io_uring.c#n9752
[2] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/io_uring.c#n8107
[3] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/io-wq.c#n1070

So, specifying max_workers always happens.

-- 
Rgrds, legion

