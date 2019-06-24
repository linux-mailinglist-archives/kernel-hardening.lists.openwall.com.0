Return-Path: <kernel-hardening-return-16220-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3B80251B3D
	for <lists+kernel-hardening@lfdr.de>; Mon, 24 Jun 2019 21:11:00 +0200 (CEST)
Received: (qmail 28590 invoked by uid 550); 24 Jun 2019 19:10:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28548 invoked from network); 24 Jun 2019 19:10:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6efmcv3HY90Ho573RNTB0lMwiTQ78McbsH3sWRMqrYk=;
        b=v96EkVK0rNaZLFxkF7opm/k0qR7ZGCW1EEBz6MJCo2tipnxwyTyODH+yLTEszkDcIQ
         NHQcjyr+c+mCBKXqHh0Fil2CcQLb8YFQU/Ksf1c+N61qsIoRjLymFo4BDX1PcblcIznf
         qjMucXWC2ExPQvzYgHNCFcFpiR63f8dr4LJVvRdkX/iHYoc9YrLKT9NClTlMAyb7cmJI
         Zc9EHtzZOXhZSVY1Bv6pTAALVcCCaXT+UXCPqx1dAE+oAS30WbI/r5i9cs3ALUSz5lcs
         lZo2GFSpntTnejnszDUgtV1QuiTqPU1jWyptpkyvyTC99a3417aIPvRonjbeNsbi0Z3d
         +bVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6efmcv3HY90Ho573RNTB0lMwiTQ78McbsH3sWRMqrYk=;
        b=tsJ6DiAlLmLO0NKh/usexIPqEzoiqzTkkIcRNsCMUrsutI5LPCsOPjU/o1iqJ9aCZb
         90BHkEKEahBXVZ9pJ9Q7yHmZ6+TztrvFsRef6OgAmuh3JGJ9YDXeX8Lye351ybI6pSXq
         /+9dDNdlvB0yClRYThjSmCoPZUg+Gml6Y1AZiE+sS8j2FjA8GaLQ27OMKXIoQfG7cGfn
         41cAvAwrGtdnH2xjv4QaDV+xyBSU0OfiG6yRCvIzCpsHdUn+8wGXD2t3Jg5EZ62vr4FI
         oU3z95kfq+qSKkGeUNlrP3uPR/tzsNp8L+rTLiaxtEWTJJwWS3aPCYoXj4W0OXf0CKP0
         efMw==
X-Gm-Message-State: APjAAAXahLHlpSR0yFJoQ5/NH9ZbAXVrF6XZjtRbLxMGeAp9f68msPhJ
	tVEIPq1o8071dTSTeIygekhAPaKSvXvNlEezfrdbig==
X-Google-Smtp-Source: APXvYqw0gQqv1j/JCLObxmpgpk4iVhXTcuU7fna2mHaFxbZeb/BskX9xLUo/yKTIqMgCAmVfzWTQUSwP+29xaRRrPr0=
X-Received: by 2002:aca:1b04:: with SMTP id b4mr11524190oib.157.1561403441214;
 Mon, 24 Jun 2019 12:10:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190624184534.209896-1-joel@joelfernandes.org> <20190624185214.GA211230@google.com>
In-Reply-To: <20190624185214.GA211230@google.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 24 Jun 2019 21:10:15 +0200
Message-ID: <CAG48ez3maGsRbN3qr8YVb6ZCw0FDq-7GqqiTiA4yEa1mebkubw@mail.gmail.com>
Subject: Re: [PATCH RFC v2] Convert struct pid count to refcount_t
To: Joel Fernandes <joel@joelfernandes.org>
Cc: kernel list <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Matthew Wilcox <willy@infradead.org>, 
	Peter Zijlstra <peterz@infradead.org>, Will Deacon <will.deacon@arm.com>, 
	"Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Elena Reshetova <elena.reshetova@intel.com>, 
	Kees Cook <keescook@chromium.org>, kernel-team <kernel-team@android.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jun 24, 2019 at 8:52 PM Joel Fernandes <joel@joelfernandes.org> wrote:
> On Mon, Jun 24, 2019 at 02:45:34PM -0400, Joel Fernandes (Google) wrote:
> > struct pid's count is an atomic_t field used as a refcount. Use
> > refcount_t for it which is basically atomic_t but does additional
> > checking to prevent use-after-free bugs.
> >
> > For memory ordering, the only change is with the following:
> >  -    if ((atomic_read(&pid->count) == 1) ||
> >  -         atomic_dec_and_test(&pid->count)) {
> >  +    if (refcount_dec_and_test(&pid->count)) {
> >               kmem_cache_free(ns->pid_cachep, pid);
> >
> > Here the change is from:
> > Fully ordered --> RELEASE + ACQUIRE (as per refcount-vs-atomic.rst)
> > This ACQUIRE should take care of making sure the free happens after the
> > refcount_dec_and_test().
> >
> > The above hunk also removes atomic_read() since it is not needed for the
> > code to work and it is unclear how beneficial it is. The removal lets
> > refcount_dec_and_test() check for cases where get_pid() happened before
> > the object was freed.
[...]
> I had a question about refcount_inc().
>
> As per Documentation/core-api/refcount-vs-atomic.rst , it says:
>
> A control dependency (on success) for refcounters guarantees that
> if a reference for an object was successfully obtained (reference
> counter increment or addition happened, function returned true),
> then further stores are ordered against this operation.
>
> However, in refcount_inc() I don't see any memory barriers (in the case where
> CONFIG_REFCOUNT_FULL=n). Is the documentation wrong?

That part of the documentation only talks about cases where you have a
control dependency on the return value of the refcount operation. But
refcount_inc() does not return a value, so this isn't relevant for
refcount_inc().

Also, AFAIU, the control dependency mentioned in the documentation has
to exist *in the caller* - it's just pointing out that if you write
code like the following, you have a control dependency between the
refcount operation and the write:

    if (refcount_inc_not_zero(&obj->refcount)) {
      WRITE_ONCE(obj->x, y);
    }

For more information on the details of this stuff, try reading the
section "CONTROL DEPENDENCIES" of Documentation/memory-barriers.txt.
