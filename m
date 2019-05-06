Return-Path: <kernel-hardening-return-15874-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F19A3148F5
	for <lists+kernel-hardening@lfdr.de>; Mon,  6 May 2019 13:32:06 +0200 (CEST)
Received: (qmail 11450 invoked by uid 550); 6 May 2019 11:32:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 1107 invoked from network); 6 May 2019 11:14:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brauner.io; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=AkmqTqEpz+voJSE7sMPW3Gi4tqC4TWEBljJqM21xrPw=;
        b=S7aN3yo3ww2JiP/hqx6XXUGhk1fKlBlH+TIVWOUqYPYGg/y33UdzCSGuusQRf4LpMk
         MlNuuADDb/sID3+FjZmz/UyItxaTRo2s7nIK0pPICepuOnESDZ6MrHPENSpQ0aQGM9dn
         yDHB5452A9lOipb17H20jQnyN5ujANgSGwmddZJ3OiMaNwfJ7g8zPzzqEhW7BjpS0bsD
         GTj55Aumtbbo8yFJSPOQxC1ER6UIeIOLig18ff5eUDs2TJxjd9HpNwwBVhtdbfrvTpQj
         XRV3hmi3eeJU3txXEonl/Vv11I0stzZdR+RMO/Vy5pF6OlR08lzwXu1j1T8V7m0c/Age
         V+/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=AkmqTqEpz+voJSE7sMPW3Gi4tqC4TWEBljJqM21xrPw=;
        b=LxFC6BhRVTzVqSyblgGAJl6UU4GgyW9Ie2aMl00+D3UIpLmHqbewn58v2912OLhqnk
         nKAWaLcxurHoDA5Rlu+PrDZy0AvTz+cYrbOaQBUTmigeo4eQB7n/2mrg+dHXnhLzJg15
         UHoM4lpLOjp+JeIfv0qT8pwi2lrKxp2RgCL4PsmMCDgsDSJ0pM6abQc383NqkPTTdq7O
         R3K6NqIjOdIf2FVpD0mra8yVtPZ2OS6PBcOoTsZJdMHCk1ArRbzHGWVaXbWh9btVVhHv
         vtphO8IJYDd9FumbKf6Hs0bAmvxEKzcmaBoiCXdRYQtXV9pVM4PTGBvcYRhfhHjicgtl
         Dl4A==
X-Gm-Message-State: APjAAAXlrv9n/LucoSv+ghTiauh7Wnyaq9Oq5QFDjFWQyfrRxIIHcy0o
	IFi2U923QcZooBvMhC4MgCCfDA==
X-Google-Smtp-Source: APXvYqy9eq89Ab1H6LOMu0EOgIGQJxsJgn/o8ObMAkSa/CWL7uML2qdORRJ5YrDpUH+CtEmd2d+tfw==
X-Received: by 2002:a17:906:3410:: with SMTP id c16mr19148972ejb.281.1557141257822;
        Mon, 06 May 2019 04:14:17 -0700 (PDT)
Date: Mon, 6 May 2019 13:14:16 +0200
From: Christian Brauner <christian@brauner.io>
To: Jann Horn <jannh@google.com>
Cc: Solar Designer <solar@openwall.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: race-free process signaling
Message-ID: <20190506111415.mjznjwqzidvouqmj@brauner.io>
References: <20190506102112.GA12668@openwall.com>
 <CAG48ez0MUSH5tJEm-6_rzj2RYTTrA=_W0K13g93Bak=QDb+bUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAG48ez0MUSH5tJEm-6_rzj2RYTTrA=_W0K13g93Bak=QDb+bUg@mail.gmail.com>
User-Agent: NeoMutt/20180716

On Mon, May 06, 2019 at 12:45:14PM +0200, Jann Horn wrote:
> +cc Christian Brauner (author of pidfd code)
> 
> On Mon, May 6, 2019 at 12:22 PM Solar Designer <solar@openwall.com> wrote:
> > I totally missed the recent work in this area (I'm not on LKML),
> 
> FWIW, you don't usually need to actually read LKML to see when major
> developments happen - I read LWN, which seems to work pretty well for
> that purpose.
> 
> > and am
> > now wondering whether the solution that got in ("use /proc/<pid> fds as
> > stable handles on struct pid"):
> >
> > https://lwn.net/Articles/773459/
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a9dce6679d736cb3d612af39bab9f31f8db66f9b
> >
> > is better or worse than what I had proposed in 1999 and 2005 ("locking"
> > of pids for the caller's own visibility only):
> >
> > https://marc.info/?l=linux-kernel&m=112784189115058
> >
> > [Subject starts with "PID reuse safety for userspace apps", in case MARC
> > is ever gone and someone wants to look this up in another archive.
> 
> (The kernel people now have lore.kernel.org as an email archive, which
> is much nicer to use IMO - it has search, it has a nice thread view,
> and you can download raw mbox files if you want to reply to a mail:
> <https://lore.kernel.org/lkml/20050927172048.GA3423@openwall.com/>)
> 
> > I proposed a lockpid syscall back then, but I'd use a mere prctl now.]
> >
> > I still like my proposal much better - no dependency on procfs, much

This has always been the goal and with the new CLONE_PIDFD flag we make
this possible. I'm about to send the PR for this merge window.
/proc/<pid> fds stay behind as a convenience for pidfd_send_signal()
only with no new features added to them.
There is some (tedious) historical context why it came to be that way.
My original implementation was already different. 
pidfd_send_signal() was basically based on /proc/<pid> fd because some
developers had opposed other solutions since the /proc/<pid> idea seemed
so "simple".
The truth is it gets very very problematic when you think about
returning fds at process creation time. This is why pidfds will be anon
inodes.

> > simpler implementation - but perhaps I'm missing the context here.
> 
> Actually, there is ongoing development of pidfd stuff, including
> procfs-less pidfds. You may want to look through
> <https://lore.kernel.org/lkml/?q=f%3Abrauner>, or something like that.
> 
> The following series adds anon-inode-based pidfds that can be returned
> from sys_clone():
> "[PATCH v3 2/4] clone: add CLONE_PIDFD"
> <https://lore.kernel.org/lkml/20190419120904.27502-2-christian@brauner.io/>
> "[PATCH v3 3/4] signal: support CLONE_PIDFD with pidfd_send_signal"
> <https://lore.kernel.org/lkml/20190419120904.27502-4-christian@brauner.io/>
> 
> This patch adds process exit notifications that can be received
> through the normal file polling syscalls (epoll/poll/select/...):
> "[PATCH v2 1/2] Add polling support to pidfd"
> <https://lore.kernel.org/lkml/20190430162154.61314-1-joel@joelfernandes.org/>
> 
> > Maybe I should have sent a patch back then.  Oh well.
