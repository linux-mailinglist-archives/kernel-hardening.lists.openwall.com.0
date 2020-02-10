Return-Path: <kernel-hardening-return-17756-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9ED08158233
	for <lists+kernel-hardening@lfdr.de>; Mon, 10 Feb 2020 19:23:54 +0100 (CET)
Received: (qmail 28080 invoked by uid 550); 10 Feb 2020 18:23:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28057 invoked from network); 10 Feb 2020 18:23:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581359017;
	bh=t3Wks9ek7HdZAz6PJfkKNyateIsqhC1vSgHRd0AbOp8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=iiK85FFk1llSss7Y+WKoCQhsXOljBpzzUvKnMT33O/2Qb4MLgmoMZsRb/ugOpUOYA
	 maNfzqkY1lGCPD+4umyoaW2df4LcCztXq2pR9ffElISHzDdNZQQxIkNB+SStreUyHy
	 kWIfoQZJbKDHzCBnaTfwpRYalPutSU3oG+LzdppA=
X-Gm-Message-State: APjAAAU5o8zTzkb63+y9r+0Y/mF+8uCf3dgTwdX7K2BtcGbzGIkWsZ/u
	R8G8i2WH4NUbrgr2vOGYI6bcXYmym3YsB9pp825dng==
X-Google-Smtp-Source: APXvYqyvQmNAMgah8c6tQsJZ+XZQiG6GIX/jTddr8+dPCUtkW0/ytdNqMktRK7dZRNI8z6/OdYPguTtbJfJo4KyutMo=
X-Received: by 2002:a7b:cbcf:: with SMTP id n15mr262021wmi.21.1581359015424;
 Mon, 10 Feb 2020 10:23:35 -0800 (PST)
MIME-Version: 1.0
References: <20200210150519.538333-1-gladkov.alexey@gmail.com> <20200210150519.538333-4-gladkov.alexey@gmail.com>
In-Reply-To: <20200210150519.538333-4-gladkov.alexey@gmail.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Mon, 10 Feb 2020 10:23:23 -0800
X-Gmail-Original-Message-ID: <CALCETrWGpRr86tVKJU-sEMcg+x0Yzp+TbiBhrAc71RaO8=DYGQ@mail.gmail.com>
Message-ID: <CALCETrWGpRr86tVKJU-sEMcg+x0Yzp+TbiBhrAc71RaO8=DYGQ@mail.gmail.com>
Subject: Re: [PATCH v8 03/11] proc: move /proc/{self|thread-self} dentries to proc_fs_info
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
	Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Oleg Nesterov <oleg@redhat.com>, Solar Designer <solar@openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Feb 10, 2020 at 7:06 AM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
>
> This is a preparation patch that moves /proc/{self|thread-self} dentries
> to be stored inside procfs fs_info struct instead of making them per pid
> namespace. Since we want to support multiple procfs instances we need to
> make sure that these dentries are also per-superblock instead of
> per-pidns,

The changelog makes perfect sense so far...

> unmounting a private procfs won't clash with other procfs
> mounts.

This doesn't parse as part of the previous sentence.  I'm also not
convinced that this really involves unmounting per se.  Maybe just
delete these words.
