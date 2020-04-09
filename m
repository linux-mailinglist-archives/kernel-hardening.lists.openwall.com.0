Return-Path: <kernel-hardening-return-18466-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 390441A3312
	for <lists+kernel-hardening@lfdr.de>; Thu,  9 Apr 2020 13:20:23 +0200 (CEST)
Received: (qmail 30132 invoked by uid 550); 9 Apr 2020 11:18:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 32462 invoked from network); 9 Apr 2020 10:54:06 -0000
X-IronPort-AV: E=Sophos;i="5.72,362,1580770800"; 
   d="scan'208";a="444554909"
Date: Thu, 9 Apr 2020 12:53:54 +0200 (CEST)
From: Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To: Alexander Popov <alex.popov@linux.com>
cc: Gilles Muller <Gilles.Muller@lip6.fr>, 
    Nicolas Palix <nicolas.palix@imag.fr>, 
    Michal Marek <michal.lkml@markovi.net>, cocci@systeme.lip6.fr, 
    "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, 
    Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>, 
    Hans Verkuil <hverkuil@xs4all.nl>, 
    Mauro Carvalho Chehab <mchehab@kernel.org>, 
    Linux Media Mailing List <linux-media@vger.kernel.org>, 
    LKML <linux-kernel@vger.kernel.org>, jannh@google.com
Subject: Re: [Cocci] Coccinelle rule for CVE-2019-18683
In-Reply-To: <fff664e9-06c9-d2fb-738f-e8e591e09569@linux.com>
Message-ID: <alpine.DEB.2.21.2004091248190.2403@hadrien>
References: <fff664e9-06c9-d2fb-738f-e8e591e09569@linux.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII



On Thu, 9 Apr 2020, Alexander Popov wrote:

> Hello!
>
> Some time ago I fixed CVE-2019-18683 in the V4L2 subsystem of the Linux kernel.
>
> I created a Coccinelle rule that detects that bug pattern. Let me show it.

Thanks for the discussion :)

>
>
> Bug pattern
> ===========
>
> CVE-2019-18683 refers to three similar vulnerabilities caused by the same
> incorrect approach to locking that is used in vivid_stop_generating_vid_cap(),
> vivid_stop_generating_vid_out(), and sdr_cap_stop_streaming().
>
> For fixes please see the commit 6dcd5d7a7a29c1e4 (media: vivid: Fix wrong
> locking that causes race conditions on streaming stop).
>
> These three functions are called during streaming stopping with vivid_dev.mutex
> locked. And they all do the same mistake while stopping their kthreads, which
> need to lock this mutex as well. See the example from
> vivid_stop_generating_vid_cap():
>     /* shutdown control thread */
>     vivid_grab_controls(dev, false);
>     mutex_unlock(&dev->mutex);
>     kthread_stop(dev->kthread_vid_cap);
>     dev->kthread_vid_cap = NULL;
>     mutex_lock(&dev->mutex);
>
> But when this mutex is unlocked, another vb2_fop_read() can lock it instead of
> the kthread and manipulate the buffer queue. That causes use-after-free.
>
> I created a Coccinelle rule that detects mutex_unlock+kthread_stop+mutex_lock
> within one function.
>
>
> Coccinelle rule
> ===============
>
> virtual report
>
> @race exists@
> expression E;
> position stop_p;
> position unlock_p;
> position lock_p;
> @@
>
> mutex_unlock@unlock_p(E)
> ...

It would be good to put when != mutex_lock(E) after the ... above.  Your
rule doesn't actually prevent the lock from being retaken.

> kthread_stop@stop_p(...)
> ...
> mutex_lock@lock_p(E)
>
> @script:python@
> stop_p << race.stop_p;
> unlock_p << race.unlock_p;
> lock_p << race.lock_p;
> E << race.E;
> @@
>
> coccilib.report.print_report(unlock_p[0], 'mutex_unlock(' + E + ') here')
> coccilib.report.print_report(stop_p[0], 'kthread_stop here')
> coccilib.report.print_report(lock_p[0], 'mutex_lock(' + E + ') here\n')
>
>
> Testing the rule
> ================
>
> I reverted the commit 6dcd5d7a7a29c1e4 and called:
> COCCI=./scripts/coccinelle/kthread_race.cocci make coccicheck MODE=report
>
> The result:
>
> ./drivers/media/platform/vivid/vivid-kthread-out.c:347:1-13: mutex_unlock(& dev
> -> mutex) here
> ./drivers/media/platform/vivid/vivid-kthread-out.c:348:1-13: kthread_stop here
> ./drivers/media/platform/vivid/vivid-kthread-out.c:350:1-11: mutex_lock(& dev ->
> mutex) here
>
> ./drivers/media/platform/vivid/vivid-sdr-cap.c:306:1-13: mutex_unlock(& dev ->
> mutex) here
> ./drivers/media/platform/vivid/vivid-sdr-cap.c:307:1-13: kthread_stop here
> ./drivers/media/platform/vivid/vivid-sdr-cap.c:309:1-11: mutex_lock(& dev ->
> mutex) here
>
> ./drivers/media/platform/vivid/vivid-kthread-cap.c:1001:1-13: mutex_unlock(& dev
> -> mutex) here
> ./drivers/media/platform/vivid/vivid-kthread-cap.c:1002:1-13: kthread_stop here
> ./drivers/media/platform/vivid/vivid-kthread-cap.c:1004:1-11: mutex_lock(& dev
> -> mutex) here
>
> There are no other bugs detected.
>
> Do you have any idea how to improve it?
> Do we need that rule for regression testing in the upstream?

Based on Jann's suggestion, it seem like it could be interesting to find
these locking pauses, and then collect functions that are used in locks
and in lock pauses.  If a function is mostly used with locks held, then
using it in a lock pause could be a sign of a bug.  I will see if it turns
up anything interesting.

julia
