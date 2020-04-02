Return-Path: <kernel-hardening-return-18388-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3639A19C6CB
	for <lists+kernel-hardening@lfdr.de>; Thu,  2 Apr 2020 18:12:05 +0200 (CEST)
Received: (qmail 18431 invoked by uid 550); 2 Apr 2020 16:12:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 18411 invoked from network); 2 Apr 2020 16:11:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yt6zWERiKTCjDwTG56J7PYbCEtxdXxHidONUlaX/0Js=;
        b=cRMdri6VXL1PrIKwuy81gkl35L7PPDq29lpPSc9oxeCIc5SGIiqZg8pZqrkDDLnVb9
         ATIfA6ph4AX+mgQJ2g4xFtlTed8dXG9kFXpWDDmRmc9iZRJ/VvaCXIYwKdNcvGxYya9T
         JrvodRpKIVTZYh5OZgKCQvDiX1x+OBqYoVfSEje9Sjp+wrWHzZu7VuCxoB8n27O7DS7K
         m2VuRbXpPfA/c2K3BAp3HojSyhNMlssuF//ntu3Mv5fMltgcizzbIz2Hwvm4Rl5RrTh7
         db1ESdeqzHZCuVNlj451tRQJnKHTM+fat+l1dFjPYun9ATeoy3nvp7eWR1J38Wv435Ab
         BUYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yt6zWERiKTCjDwTG56J7PYbCEtxdXxHidONUlaX/0Js=;
        b=Tsa1Za/wFgUEisFuO8kEkQ5ahNstSwiai4XZlTVMvzTHfnLng+7Ux21oguiS8lEklD
         Gju0dh8xKOv1VqoKymZsI7VjdvK1eEfWZSg7jjSRjdr73lN5C3posrC/Z7auKoRcZbmA
         W10boi6e6U8w7C7hKnDQXH+ng1E+WNoF7r8CsfpPFo6qQfsBn0fXt+ll0rsmksz5eoBf
         KrpMZoUojs4DecMWu/CPshzFhjp5dvdXr79rbLTXWwE+8ARcY2nz8CpEEAgxMztr7ZiA
         H8Kyjr7N6ScApRSpBWeK3WeLHYBdWhfhp56GaC9hP59EkRn5izE5en8KX3lj/vDVmqxn
         yFKw==
X-Gm-Message-State: AGi0Pua9O4ELk2rHqTeKM9D2sjowLLPk70wewdaQnl6pOsF4vbMJzLCd
	PvUpRBC+n1RqmAewdwqre3bO63K6+a1c7OBd2G5S8A==
X-Google-Smtp-Source: APiQypIY+3gHVfOON959mT3BWUZJaXvVOSvN8K0EQOmiQuny69JdN42ugLz+DORki8l/0FvOcEvx2X4tgIn4sOhB9vA=
X-Received: by 2002:a19:700a:: with SMTP id h10mr2752575lfc.184.1585843907063;
 Thu, 02 Apr 2020 09:11:47 -0700 (PDT)
MIME-Version: 1.0
References: <20200327172331.418878-9-gladkov.alexey@gmail.com> <20200330111235.154182-1-gladkov.alexey@gmail.com>
In-Reply-To: <20200330111235.154182-1-gladkov.alexey@gmail.com>
From: Jann Horn <jannh@google.com>
Date: Thu, 2 Apr 2020 18:11:20 +0200
Message-ID: <CAG48ez2L__TODzwQW0MjYim6rh=WjkU__xvAoi2CtBCkNP2=Fg@mail.gmail.com>
Subject: Re: [PATCH v11 8/9] proc: use human-readable values for hidehid
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux API <linux-api@vger.kernel.org>, 
	Linux FS Devel <linux-fsdevel@vger.kernel.org>, 
	Linux Security Module <linux-security-module@vger.kernel.org>, 
	Akinobu Mita <akinobu.mita@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Alexey Dobriyan <adobriyan@gmail.com>, Alexey Gladkov <legion@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, 
	Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, 
	"Dmitry V . Levin" <ldv@altlinux.org>, "Eric W . Biederman" <ebiederm@xmission.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@kernel.org>, 
	"J . Bruce Fields" <bfields@fieldses.org>, Jeff Layton <jlayton@poochiereds.net>, 
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Mar 30, 2020 at 1:13 PM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
> The hidepid parameter values are becoming more and more and it becomes
> difficult to remember what each new magic number means.

nit: subject line says "hidehid"
