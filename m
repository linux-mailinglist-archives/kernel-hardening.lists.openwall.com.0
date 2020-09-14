Return-Path: <kernel-hardening-return-19897-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 076C32695CA
	for <lists+kernel-hardening@lfdr.de>; Mon, 14 Sep 2020 21:43:20 +0200 (CEST)
Received: (qmail 31780 invoked by uid 550); 14 Sep 2020 19:43:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 31757 invoked from network); 14 Sep 2020 19:43:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B26ZPwSMQkEgl0FLKfBn1bcFzAEPMlr/0cRYgdbCJm4=;
        b=MvgJXiZx2nV1v+RFwDa0Ew2gpF/YMUm1Qzl9uP0JoeTwPkWschjlATZudFOjyAIymN
         jJB7CAfq+BpdKpEqeroG5Y7ueTlhTlgM+6LKj7M/TcVdvxK4rdi9pYpCVGasFgNnIweT
         66+OK8SAHXNYBvklweFjzvmaa+Q7pxQDrOuyV4OSavfjbUh/GTOB0/dTGHcXB5og63fs
         hvyUH+1dQT5+qQQyzqRC8vgQa2klF9z87EZ56xelz5zRMKd7xRTRJDyE/7GPPA7Gsper
         vQGtuke/Cs2S3Z/KC4HPmMFtSHp3XPc5cMLPQw2vv+ytvQBW4AUOUbR1dxtFSHQYUW0E
         xajw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B26ZPwSMQkEgl0FLKfBn1bcFzAEPMlr/0cRYgdbCJm4=;
        b=X2lSYED0gR/+V2RC1f1SRIMh0cZv/hTRwbQ98skduVqdZjdPmhBsSIun5aUl+PALXC
         jTOiifi1Ba5to04g24k/grbrnDrqVxlFAaHbHKDH2jhdWLl4K3K2v0/tVjFur+TYDELm
         FfpXa2HgX4rAPhp8rw4IZeYC1pY/pJhCUkTJTeyjcMPcWB7ToLviDMOrXAuZzy9kkKW9
         D0vJLbnei2dUqtL8v+04RlBClL8R3cxXJrXOE+p8c/NAV8+wHHPE+Eg90jPjiZ1c1lBh
         Y2IaY3Ob+Zog+hJN6uIbTVVDwBwQT7TD3FtxYX94S0nYZfSUEL6t9/fiU9dRdN0hyKqH
         YLPA==
X-Gm-Message-State: AOAM533L94QjT1QHDoGugYf5C+5OqyyINB2zyE6sbMBSU5p2CyLHu1ui
	L/yV3mrUCRPF1cH6ZsApiv4YO9xIOoHI62bluEP73w==
X-Google-Smtp-Source: ABdhPJwIyj+9kqnlMOpAnTl++v/tLI6DikXxNqu6vECzgkcVLWCncCazo3lOF4hNj+FGq7wU79q5bP4k/TU5T/il6ac=
X-Received: by 2002:a05:6402:176c:: with SMTP id da12mr19288248edb.386.1600112583753;
 Mon, 14 Sep 2020 12:43:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200910202107.3799376-1-keescook@chromium.org>
 <20200910202107.3799376-6-keescook@chromium.org> <CAG48ez1gbu+eBA_PthLemcVVR+AU7Xa1zzbJ8tLMLBDCe_a+fQ@mail.gmail.com>
 <20200913172415.GA2880@ubuntu>
In-Reply-To: <20200913172415.GA2880@ubuntu>
From: Jann Horn <jannh@google.com>
Date: Mon, 14 Sep 2020 21:42:37 +0200
Message-ID: <CAG48ez0BcSY0is2LzdkizcOQYkaOJwfa=5ZSwjKb+faRwG9QCA@mail.gmail.com>
Subject: Re: [RFC PATCH 5/6] security/fbfam: Detect a fork brute force attack
To: John Wood <john.wood@gmx.com>
Cc: Kees Cook <keescook@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Matthew Wilcox <willy@infradead.org>, 
	Jonathan Corbet <corbet@lwn.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Luis Chamberlain <mcgrof@kernel.org>, Iurii Zaikin <yzaikin@google.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, linux-doc@vger.kernel.org, 
	kernel list <linux-kernel@vger.kernel.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Sun, Sep 13, 2020 at 7:55 PM John Wood <john.wood@gmx.com> wrote:
> On Thu, Sep 10, 2020 at 11:10:38PM +0200, Jann Horn wrote:
> > On Thu, Sep 10, 2020 at 10:22 PM Kees Cook <keescook@chromium.org> wrote:
> > > To detect a fork brute force attack it is necessary to compute the
> > > crashing rate of the application. This calculation is performed in each
> > > fatal fail of a task, or in other words, when a core dump is triggered.
> > > If this rate shows that the application is crashing quickly, there is a
> > > clear signal that an attack is happening.
> > >
> > > Since the crashing rate is computed in milliseconds per fault, if this
> > > rate goes under a certain threshold a warning is triggered.
[...]
> > > +       delta_jiffies = get_jiffies_64() - stats->jiffies;
> > > +       delta_time = jiffies64_to_msecs(delta_jiffies);
> > > +       crashing_rate = delta_time / (u64)stats->faults;
> >
> > Do I see this correctly, is this computing the total runtime of this
> > process hierarchy divided by the total number of faults seen in this
> > process hierarchy? If so, you may want to reconsider whether that's
> > really the behavior you want. For example, if I configure the minimum
> > period between crashes to be 30s (as is the default in the sysctl
> > patch), and I try to attack a server that has been running without any
> > crashes for a month, I'd instantly be able to crash around
> > 30*24*60*60/30 = 86400 times before the detection kicks in. That seems
> > suboptimal.
>
> You are right. This is not the behaviour we want. So, for the next
> version it would be better to compute the crashing period as the time
> between two faults, or the time between the execve call and the first
> fault (first fault case).
>
> However, I am afraid of a premature detection if a child process fails
> twice in a short period.
>
> So, I think it would be a good idea add a new sysctl to setup a
> minimum number of faults before the time between faults starts to be
> computed. And so, the attack detection only will be triggered if the
> application crashes quickly but after a number of crashes.
>
> What do you think?

You could keep a list of the timestamps of the last five crashes or
so, and then take action if the last five crashes happened within
(5-1)*crash_period_limit time.
