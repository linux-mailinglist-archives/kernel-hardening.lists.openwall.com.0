Return-Path: <kernel-hardening-return-17752-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 390701581A5
	for <lists+kernel-hardening@lfdr.de>; Mon, 10 Feb 2020 18:47:03 +0100 (CET)
Received: (qmail 5775 invoked by uid 550); 10 Feb 2020 17:46:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5755 invoked from network); 10 Feb 2020 17:46:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cMABvWd/7c4TphsJ+M/Bzt18EBtYsvxejNNk0qYwcjM=;
        b=AJWGb7viPUuSlXbBtks15QbiGc0V+5N1kFBw6HmGv/BocUHZwmHNnivHvSwIiPeEQm
         1fliH10RGyoPY6yV4O5rwY5izrulFkNof0M2GsGbSrfCirug6Mx7f0jNvrzCMioGftQD
         acWtx/PsAUjj64YLYfwg5kSuWK5If6M0QpBoQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cMABvWd/7c4TphsJ+M/Bzt18EBtYsvxejNNk0qYwcjM=;
        b=S8JcfhnOzf+WQb25dtLU476N6uh7PuuVosnxBYiNgtxsp965PipYoKOo456kpd6s7g
         34wFx1Y+0JN4wdmqCceLD50pBD/elzrSbYQiNMeywXqY9Hhl97sNxbNJOwGOwh/mm9T/
         /zI/e30q48vFLqCaCE3dePvmRHrmPkKzp8bhU15ZHOj4LxpFvHdFXFT5IUk99EKhmTF2
         Q7tALE0/T1Ha3ffpo3M6tfJ+v+m0OYPW3znBfPgjg4aiaYcqzVaBtvx81zRXtjB+mpRH
         TmpadxBdJZimhISQm3xLCrE9vCqwd4zhq3mjaHBWdf28nMWYwZatklMKBcLk4zLjsThH
         4htQ==
X-Gm-Message-State: APjAAAXG/QftkGdnOWfncrpzc4vyXDMwHvSo20GrcQSN4VUoCSWcOY0E
	6cpssuJ+1/sYDtUGFfNA3JKt1A+L48Q=
X-Google-Smtp-Source: APXvYqwTHL9ChgRWfAKxQ/D6wzwFgvOurHekUkQXnXW6Eda1xB9Bw6cH+7cDqQ3GIu0JHQMUUBj0Dw==
X-Received: by 2002:ac2:592f:: with SMTP id v15mr1298342lfi.105.1581356804656;
        Mon, 10 Feb 2020 09:46:44 -0800 (PST)
X-Received: by 2002:a2e:461a:: with SMTP id t26mr1591348lja.204.1581356802297;
 Mon, 10 Feb 2020 09:46:42 -0800 (PST)
MIME-Version: 1.0
References: <20200210150519.538333-1-gladkov.alexey@gmail.com> <20200210150519.538333-8-gladkov.alexey@gmail.com>
In-Reply-To: <20200210150519.538333-8-gladkov.alexey@gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 10 Feb 2020 09:46:26 -0800
X-Gmail-Original-Message-ID: <CAHk-=wh05FniF0xJYqcFrmGeCvOJUqR0UL4jTC-_LvpsfNCkNw@mail.gmail.com>
Message-ID: <CAHk-=wh05FniF0xJYqcFrmGeCvOJUqR0UL4jTC-_LvpsfNCkNw@mail.gmail.com>
Subject: Re: [PATCH v8 07/11] proc: flush task dcache entries from all procfs instances
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, 
	Linux FS Devel <linux-fsdevel@vger.kernel.org>, 
	Linux Security Module <linux-security-module@vger.kernel.org>, 
	Akinobu Mita <akinobu.mita@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Lutomirski <luto@kernel.org>, Daniel Micay <danielmicay@gmail.com>, 
	Djalal Harouni <tixxdz@gmail.com>, "Dmitry V . Levin" <ldv@altlinux.org>, 
	"Eric W . Biederman" <ebiederm@xmission.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Ingo Molnar <mingo@kernel.org>, "J . Bruce Fields" <bfields@fieldses.org>, 
	Jeff Layton <jlayton@poochiereds.net>, Jonathan Corbet <corbet@lwn.net>, 
	Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, 
	Solar Designer <solar@openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Feb 10, 2020 at 7:06 AM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
>
> This allows to flush dcache entries of a task on multiple procfs mounts
> per pid namespace.
>
> The RCU lock is used because the number of reads at the task exit time
> is much larger than the number of procfs mounts.

Ok, this looks better to me than the previous version.

But that may be the "pee-in-the-snow" effect, and I _really_ want
others to take a good look at the whole series.

The right people seem to be cc'd, but this is pretty core, and /proc
has a tendency to cause interesting issues because of how it's
involved in a lot of areas indirectly.

Al, Oleg, Andy, Eric?

             Linus
