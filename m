Return-Path: <kernel-hardening-return-16221-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A6BD751C91
	for <lists+kernel-hardening@lfdr.de>; Mon, 24 Jun 2019 22:43:51 +0200 (CEST)
Received: (qmail 8105 invoked by uid 550); 24 Jun 2019 20:43:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 8087 invoked from network); 24 Jun 2019 20:43:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=78Ty9brXQcBAfvxld/f2zy+UAZIXu4cST4SKUNq/ZtE=;
        b=xKiw1EbnAnfUc3KMYQZj1husi/5d7wyoTv61YtaUEGlAk6+Cx6H9nk+XtVFoVu8wol
         rz/1NwN++wuI6Uhe/UEaU6btO6xG82p4eMw84Xv06jebmDuhfsLsYfOQSTCTvKeKTFh5
         eFsNc5HO2n5oLw6Lv9jbXl5F20CICgwhKQhIo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=78Ty9brXQcBAfvxld/f2zy+UAZIXu4cST4SKUNq/ZtE=;
        b=DJNtl5s28s+ivw6AjtNKpuar0gfPEw+45ulaxHmTqa02tP886NYF9ik6TmKn117opc
         clWMw1lDgwW7RolhzP0mOtPUXx2oLGu7OuDEsaKyEh90c6Ol8bOKsWr6acexEYkPHK8t
         78Gcw+Edkl441/VzG1JEWpE3C7DJeMTvRzVsTwzUfY4JVHfvbnW84DTtpgwToQlBQ5N7
         SdfwBXWSo2zAD976S9zaPN0de/XHbNjtao8OVVG1kdWw8ZTsbLx/61Jc5LcSkIz/0xSA
         t9Z3r9XVnXi1ikf6gnKMRZkq+LYTCphhpOZTjqyy/746uweAAUjmwVjxilSHpVUj+FQ5
         RtKQ==
X-Gm-Message-State: APjAAAUZsq5i/C2JKrffrxJTrFWVlohm0Oxf6efv/w42PADuGiPnVBhL
	C5twDXMVpxsceT1d1bylmCoNEXSwl9XfTc7UueEoRA==
X-Google-Smtp-Source: APXvYqwFKhBC2b2GNzjVuUNDKWP5VikyikO+bWYhlqNLOi9JgXItzjYtroIAYeD1HVZqvuRGFwSJGCZ32ysvJzqvmGI=
X-Received: by 2002:a2e:8583:: with SMTP id b3mr64474038lji.171.1561409013254;
 Mon, 24 Jun 2019 13:43:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190624184534.209896-1-joel@joelfernandes.org>
 <20190624185214.GA211230@google.com> <CAG48ez3maGsRbN3qr8YVb6ZCw0FDq-7GqqiTiA4yEa1mebkubw@mail.gmail.com>
In-Reply-To: <CAG48ez3maGsRbN3qr8YVb6ZCw0FDq-7GqqiTiA4yEa1mebkubw@mail.gmail.com>
From: Joel Fernandes <joel@joelfernandes.org>
Date: Mon, 24 Jun 2019 16:43:21 -0400
Message-ID: <CAEXW_YS0YR8Au+1f-sW_BT3xVONXKo9zrcSJMBwGJizyMw0xag@mail.gmail.com>
Subject: Re: [PATCH RFC v2] Convert struct pid count to refcount_t
To: Jann Horn <jannh@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Matthew Wilcox <willy@infradead.org>, 
	Peter Zijlstra <peterz@infradead.org>, Will Deacon <will.deacon@arm.com>, 
	"Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Elena Reshetova <elena.reshetova@intel.com>, 
	Kees Cook <keescook@chromium.org>, kernel-team <kernel-team@android.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Eric W. Biederman" <ebiederm@xmission.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jun 24, 2019 at 3:10 PM Jann Horn <jannh@google.com> wrote:
>
> On Mon, Jun 24, 2019 at 8:52 PM Joel Fernandes <joel@joelfernandes.org> wrote:
> > On Mon, Jun 24, 2019 at 02:45:34PM -0400, Joel Fernandes (Google) wrote:
> > > struct pid's count is an atomic_t field used as a refcount. Use
> > > refcount_t for it which is basically atomic_t but does additional
> > > checking to prevent use-after-free bugs.
> > >
> > > For memory ordering, the only change is with the following:
> > >  -    if ((atomic_read(&pid->count) == 1) ||
> > >  -         atomic_dec_and_test(&pid->count)) {
> > >  +    if (refcount_dec_and_test(&pid->count)) {
> > >               kmem_cache_free(ns->pid_cachep, pid);
> > >
> > > Here the change is from:
> > > Fully ordered --> RELEASE + ACQUIRE (as per refcount-vs-atomic.rst)
> > > This ACQUIRE should take care of making sure the free happens after the
> > > refcount_dec_and_test().
> > >
> > > The above hunk also removes atomic_read() since it is not needed for the
> > > code to work and it is unclear how beneficial it is. The removal lets
> > > refcount_dec_and_test() check for cases where get_pid() happened before
> > > the object was freed.
> [...]
> > I had a question about refcount_inc().
> >
> > As per Documentation/core-api/refcount-vs-atomic.rst , it says:
> >
> > A control dependency (on success) for refcounters guarantees that
> > if a reference for an object was successfully obtained (reference
> > counter increment or addition happened, function returned true),
> > then further stores are ordered against this operation.
> >
> > However, in refcount_inc() I don't see any memory barriers (in the case where
> > CONFIG_REFCOUNT_FULL=n). Is the documentation wrong?
>
> That part of the documentation only talks about cases where you have a
> control dependency on the return value of the refcount operation. But
> refcount_inc() does not return a value, so this isn't relevant for
> refcount_inc().
>
> Also, AFAIU, the control dependency mentioned in the documentation has
> to exist *in the caller* - it's just pointing out that if you write
> code like the following, you have a control dependency between the
> refcount operation and the write:
>
>     if (refcount_inc_not_zero(&obj->refcount)) {
>       WRITE_ONCE(obj->x, y);
>     }
>
> For more information on the details of this stuff, try reading the
> section "CONTROL DEPENDENCIES" of Documentation/memory-barriers.txt.

Makes sense now, thank you Jann!

 - Joel
