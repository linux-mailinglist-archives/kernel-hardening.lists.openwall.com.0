Return-Path: <kernel-hardening-return-15873-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 33B6214882
	for <lists+kernel-hardening@lfdr.de>; Mon,  6 May 2019 12:45:59 +0200 (CEST)
Received: (qmail 13641 invoked by uid 550); 6 May 2019 10:45:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13585 invoked from network); 6 May 2019 10:45:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xKv+xEy3yaf9hjxS97eJ8bF5UD6ClV/AWKs1R9R7OT0=;
        b=kF1i7ChTluVEsZ3ikbNOf2syJ4+ivsjXsjLhcnFw+3zjo3au50dB3lJGWGZVls8hvm
         UiXDr9gmfvy7GhmDkV5yqCMKHsxUtOnfVVLn5VLPqjnZNfITrhR+PKalFWQbG1ISgk4h
         KoMorJXSUdS2zjy07dniOizuTIR8FXNmgGfMCnyQMRAn7I48HOYBJaRrxCwZVO81oO3U
         hIlFh0FX8TSIedNQrkW6/vfSRxJ7xizgDxNXYBXpOw9UTZqpTcca+0Gw1PVYCTt/iMAf
         0qfv3rzqT/6/+z+0Dgjxf0VmlqmWy0Tg9LZUglkq2C4gnD41kKXZYxz3Am2F+l4dcFxY
         zBbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xKv+xEy3yaf9hjxS97eJ8bF5UD6ClV/AWKs1R9R7OT0=;
        b=WVnk5AVKxlT7sDh9zeQV/641GQ8/C3fTWIds1P7ixQc2RNECK35ZFsUSHSMQHa+A+a
         NoQhjq/9XkfpzHjUE86pLlBvsDoejg4/x8aJORxFlA95ajCNUY+L3QhIcXFG7mCGE32P
         dFFjeyaBnj2n2qg87otzGOaBqarXgJTJOwv3DA2E4Fl+LJjDXg3lwHgef/S365zy0HJJ
         UZM+SHrkX2z+HtATR0nqm3+u627/4kvpC7+ton23y8HGY2IfPZwBk8lrFcN6xJ0A7T0f
         t5m5hJbDFJ2exoa1AJcZg31M4cUoZ5y57gALRTkE0LPqDxakA+CqF1Ruo5drQIGZMt+F
         luLw==
X-Gm-Message-State: APjAAAXZH3D9294jTgwGsGdpPREhBfs1lKeh2GnQibx6X91aypRssaCQ
	Oh/9rrFys7xmLvC8b+PoU/rIXnxqwqoRTtvP1LQvTw==
X-Google-Smtp-Source: APXvYqyDBHXKL63GrlvzbzAlZLoMu6uI1fcU6DqxTYba4qeaC69hUwZOo9fVl75efYBzqxiD/RXB79GE3T6Xa3waVlA=
X-Received: by 2002:aca:180d:: with SMTP id h13mr676257oih.39.1557139540184;
 Mon, 06 May 2019 03:45:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190506102112.GA12668@openwall.com>
In-Reply-To: <20190506102112.GA12668@openwall.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 6 May 2019 12:45:14 +0200
Message-ID: <CAG48ez0MUSH5tJEm-6_rzj2RYTTrA=_W0K13g93Bak=QDb+bUg@mail.gmail.com>
Subject: Re: race-free process signaling
To: Solar Designer <solar@openwall.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Christian Brauner <christian@brauner.io>
Content-Type: text/plain; charset="UTF-8"

+cc Christian Brauner (author of pidfd code)

On Mon, May 6, 2019 at 12:22 PM Solar Designer <solar@openwall.com> wrote:
> I totally missed the recent work in this area (I'm not on LKML),

FWIW, you don't usually need to actually read LKML to see when major
developments happen - I read LWN, which seems to work pretty well for
that purpose.

> and am
> now wondering whether the solution that got in ("use /proc/<pid> fds as
> stable handles on struct pid"):
>
> https://lwn.net/Articles/773459/
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a9dce6679d736cb3d612af39bab9f31f8db66f9b
>
> is better or worse than what I had proposed in 1999 and 2005 ("locking"
> of pids for the caller's own visibility only):
>
> https://marc.info/?l=linux-kernel&m=112784189115058
>
> [Subject starts with "PID reuse safety for userspace apps", in case MARC
> is ever gone and someone wants to look this up in another archive.

(The kernel people now have lore.kernel.org as an email archive, which
is much nicer to use IMO - it has search, it has a nice thread view,
and you can download raw mbox files if you want to reply to a mail:
<https://lore.kernel.org/lkml/20050927172048.GA3423@openwall.com/>)

> I proposed a lockpid syscall back then, but I'd use a mere prctl now.]
>
> I still like my proposal much better - no dependency on procfs, much
> simpler implementation - but perhaps I'm missing the context here.

Actually, there is ongoing development of pidfd stuff, including
procfs-less pidfds. You may want to look through
<https://lore.kernel.org/lkml/?q=f%3Abrauner>, or something like that.

The following series adds anon-inode-based pidfds that can be returned
from sys_clone():
"[PATCH v3 2/4] clone: add CLONE_PIDFD"
<https://lore.kernel.org/lkml/20190419120904.27502-2-christian@brauner.io/>
"[PATCH v3 3/4] signal: support CLONE_PIDFD with pidfd_send_signal"
<https://lore.kernel.org/lkml/20190419120904.27502-4-christian@brauner.io/>

This patch adds process exit notifications that can be received
through the normal file polling syscalls (epoll/poll/select/...):
"[PATCH v2 1/2] Add polling support to pidfd"
<https://lore.kernel.org/lkml/20190430162154.61314-1-joel@joelfernandes.org/>

> Maybe I should have sent a patch back then.  Oh well.
