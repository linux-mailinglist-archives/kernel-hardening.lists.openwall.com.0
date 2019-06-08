Return-Path: <kernel-hardening-return-16075-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3293B39B58
	for <lists+kernel-hardening@lfdr.de>; Sat,  8 Jun 2019 08:02:31 +0200 (CEST)
Received: (qmail 23615 invoked by uid 550); 8 Jun 2019 06:02:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23581 invoked from network); 8 Jun 2019 06:02:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QzrS4OkV54efMrkQxlRHAHRsLieGOevBrVbnGXjC0n8=;
        b=gLapKu9YfeUNyW6XnY5EvpSUfzHG6uoUO8+uj/p6xPFtT7W5r5VhEJX9TigSp0aEih
         /M7HzT7V5UN35GhC0rBw3KWOPIgfToahjqzYO4rEn4xphdcPuDPrHG/YfIrnu5j/FX6Y
         +37x4mEbAaOm1mREemrVD2BRdGj0l23tXx4sGX9UzM3r88UOa4mgYPh828uGbTAG4E+z
         D9MhHiOUAa5YteZRqHlgP1sm4snhG2UMuLRkI+pqJaoIcOkF4fyh4MrbHwCKRGL942C1
         fNHHb8ql7KpFydGgYun+B8mPiH+E0PITelZxx+7++Fy7oUmTAz/NUTf1iuqMH7NMrrdk
         2DSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QzrS4OkV54efMrkQxlRHAHRsLieGOevBrVbnGXjC0n8=;
        b=IdMAKKd2oVcSfam4YTRuM5fB/3+uwXEGi0KaVv6yWGcxQbA79KJYBwKZ0gp1qVYYLZ
         b6ifAdPwndtWoUpiOs6C3JaTE4du1Sg/TbYZy3fKJJi/nPZeofRW3n0rSum8lsh1kkI1
         Qif+qfjod0+27+bLaWpnl3tnG+FE6Q7HBF51blqiP1fCASvrgcbSezb2Rjvy9s9Pz11m
         AdySIJ2FQc9rR5njk7V3pOURN67f0itq+uDbaTu8zLD4830mduYd5dP4F1Nitg4Q1E/R
         9XwUZYYGQRXeLfUcK/vuNMKSy4OsI4hVlmhcTPKvi/NK2lEchUGQZaSTQFkv/sLSUKvE
         tvrg==
X-Gm-Message-State: APjAAAV33ulDm20T2S8ZJkeqQv106xDSSk8KALLHIZBA0aTVgmPABy4L
	Ru2BEeshq88F9+o3iIAsnhhi/LhcnAwjM+lkikE=
X-Google-Smtp-Source: APXvYqz6WCto1zwghqVAtflohO+HRm7Gqa3+Z91OY3zukeLvIT5QUFbx9SEM38RlJYDy4INCPt8vy4SWtOdbBSkYJ9U=
X-Received: by 2002:a9d:3f62:: with SMTP id m89mr22968458otc.128.1559973732263;
 Fri, 07 Jun 2019 23:02:12 -0700 (PDT)
MIME-Version: 1.0
References: <CABgxDo+x3r=8HFxyM89HAc_FdY6+kBpJR5RpAgpOYsu0xZtshQ@mail.gmail.com>
 <CABgxDoJ-ue6HKyBR_q8cmbOp8DFnZDVf7zbxv8_wmHh7uis_vw@mail.gmail.com>
 <CAOfkYf4OxG-vkCOoWvmGxyRg3UVFcGszkdStKSoXf5qqyF_RQA@mail.gmail.com>
 <CABgxDoLe3fXNLob3pnj7Nn2v54Htqr+cg5gRRQPxFK7HPX85=Q@mail.gmail.com> <201906072117.A1C045C@keescook>
In-Reply-To: <201906072117.A1C045C@keescook>
From: Shyam Saini <mayhs11saini@gmail.com>
Date: Sat, 8 Jun 2019 11:32:00 +0530
Message-ID: <CAOfkYf40dzGm5qhEqMDJOHEHr0Zbw9KDT93QAPfb_jHEqWNu0g@mail.gmail.com>
Subject: Re: Get involved
To: Kees Cook <keescook@chromium.org>
Cc: Romain Perier <romain.perier@gmail.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

Hi Kees,

>
> Hi! Sorry for the late reply: I've been travelling this week. :P

> > Okay, np. I will select another one then :) (hehe that's the game ;) )
> >
> > @Kees: do you have something in mind (as a new task) ?
> Shyam, you'd also started FIELD_SIZEOF refactoring, but never sent a v2
> patch if I was following correctly? Is there one or the other of these
> tasks you'd like help with?  https://patchwork.kernel.org/patch/10900187/

sorry for being too late.

You assigned me 3 tasks
1) FIELD_SIZEOF
2) WARN on kfree() of ERR_PTR range
3) NLA_STRING

I'll send patches for task 1 and 2 today or tomorrow.

If Roman is taking NLA_STRING task, I'd pick some other once i send
patches for 1 and 2.


> Romain, what do you think about reviewing NLA code? I'd mentioned a
> third task here:
> https://www.openwall.com/lists/kernel-hardening/2019/04/17/8
>
> Quoting...
>
>
> - audit and fix all misuse of NLA_STRING
>
> This is a following up on noticing the misuse of NLA_STRING (no NUL
> terminator), getting used with regular string functions (that expect a
> NUL termination):
> https://lore.kernel.org/lkml/1519329289.2637.12.camel@sipsolutions.net/T/#u
>
> It'd be nice if someone could inspect all the NLA_STRING
> representations and find if there are any other problems like this
> (and see if there was a good way to systemically fix the problem).
>
>
>
> For yet another idea would be to get syzkaller[1] set up and enable
> integer overflow detection (by adding "-fsanitize=signed-integer-overflow"
> to KBUILD_CFLAGS) and start finding and fixes cases like this[2].
>
> Thanks and let me know what you think!
>
> -Kees
>
> [1] https://github.com/google/syzkaller/blob/master/docs/linux/setup.md
> [2] https://lore.kernel.org/lkml/20180824215439.GA46785@beast/
>
>
> --
> Kees Cook
