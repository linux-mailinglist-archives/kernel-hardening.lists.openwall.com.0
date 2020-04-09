Return-Path: <kernel-hardening-return-18483-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A58791A3B7E
	for <lists+kernel-hardening@lfdr.de>; Thu,  9 Apr 2020 22:46:18 +0200 (CEST)
Received: (qmail 26597 invoked by uid 550); 9 Apr 2020 20:46:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26574 invoked from network); 9 Apr 2020 20:46:12 -0000
X-IronPort-AV: E=Sophos;i="5.72,364,1580770800"; 
   d="scan'208";a="444630938"
Date: Thu, 9 Apr 2020 22:45:59 +0200 (CEST)
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
    LKML <linux-kernel@vger.kernel.org>, 
    Markus Elfring <Markus.Elfring@web.de>
Subject: Re: [Cocci] Coccinelle rule for CVE-2019-18683
In-Reply-To: <3c92523d-4b3f-e805-84e6-6abd1eedd683@linux.com>
Message-ID: <alpine.DEB.2.21.2004092242450.2403@hadrien>
References: <fff664e9-06c9-d2fb-738f-e8e591e09569@linux.com> <alpine.DEB.2.21.2004091248190.2403@hadrien> <3c92523d-4b3f-e805-84e6-6abd1eedd683@linux.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

> >> kthread_stop@stop_p(...)
> >> ...
> >> mutex_lock@lock_p(E)
> >>
> >> @script:python@
> >> stop_p << race.stop_p;
> >> unlock_p << race.unlock_p;
> >> lock_p << race.lock_p;
> >> E << race.E;
> >> @@
> >>
> >> coccilib.report.print_report(unlock_p[0], 'mutex_unlock(' + E + ') here')
> >> coccilib.report.print_report(stop_p[0], 'kthread_stop here')
> >> coccilib.report.print_report(lock_p[0], 'mutex_lock(' + E + ') here\n')
>
> ...
>
> > Based on Jann's suggestion, it seem like it could be interesting to find
> > these locking pauses, and then collect functions that are used in locks
> > and in lock pauses.  If a function is mostly used with locks held, then
> > using it in a lock pause could be a sign of a bug.  I will see if it turns
> > up anything interesting.
>
> Do you mean collecting the behaviour that happens between unlocking and locking
> and then analysing it somehow?

Yes.  I have tried doing what I described, but I'm not sure that the
results are very reliable at the moment.

julia
