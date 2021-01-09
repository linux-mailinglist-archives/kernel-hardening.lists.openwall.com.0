Return-Path: <kernel-hardening-return-20623-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E4D4B2F0249
	for <lists+kernel-hardening@lfdr.de>; Sat,  9 Jan 2021 18:34:05 +0100 (CET)
Received: (qmail 12273 invoked by uid 550); 9 Jan 2021 17:33:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 12250 invoked from network); 9 Jan 2021 17:33:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=NikId7Xj7bWOh+hLaIn+ZZMlijXDi8nElT+l6OdToWY=;
        b=g/pQdtKnuFESOOqddx88eblRnszCnOfblr9FrlAOcVMiw7QPdJqBkMMrQ8qQv9pejD
         Ny2QqfbXSFy15cuqaGq979m/4cqR8/p9VV4Cuvi9Gve2mhoptlZVOPLFeaYRm9zI89SV
         +55oFqz636EU/Ok+b+qFnjxTAKDjuWyUWV7m7LPzGH9djYzDFb2Qb/PsVddrPMgbVPDN
         OrCQxG97wM8LYRaXgfKklCI33p8jWUdT6RGI260XhXB85Yt+7M7k/i+uGfRPxpcOpCIC
         pA5zReSdT48tC7O9yfnxIhsS+NqdW8Ux/y6F0q7ZlOhNU+h9ZOmHlkhfKUPMM+XFueIr
         M4gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=NikId7Xj7bWOh+hLaIn+ZZMlijXDi8nElT+l6OdToWY=;
        b=qgR6OXWOtw4UuptjRKLYgEM2uo+TgwBpaqTWrWga7pHuklL0pdONyPqNk5ipq8hhgM
         gX/tQvNl2L6ptFIZvfbLfCsa+bAf3Rfoe6b1ASHyiT3eKO1MD44xnwz4689uHARni2gX
         Kt2E14dTajrKSpMroMWsgPsEVpy2nOWik8UGEe55Eck/nf2R+MgDeiMXupp4IBQQUTQ3
         YjkkfWziLufeTqEe2+p6jRlZfQS0+PAZIEErKyurngTRJO3dkiIUlGU+jc4qPtK7W53g
         YvntfhTjjDe0eFKDVYKfsaq84pW5SrBDdNFAZ+axhDiPart1nOflh3/XPm37n99vYLwc
         adTQ==
X-Gm-Message-State: AOAM531waGiD2w7+sUSul7IcWHvZ+ZnHY9UhynVoylRSDJuFFqTLvyrN
	zVarLj32gWSwrhKH/PsFaCVEAJUHXp3rMvixKFg=
X-Google-Smtp-Source: ABdhPJx1ffrLsMiWlEmhD/YwfQk9GM6w4n9rJLKldS7um9a/rbcv+zWLw4Px08XWbgZ5NbTJHYMzeaP0UJYTrFD6Q3s=
X-Received: by 2002:a05:6e02:1a43:: with SMTP id u3mr9156005ilv.209.1610213627012;
 Sat, 09 Jan 2021 09:33:47 -0800 (PST)
MIME-Version: 1.0
References: <20201211184633.3213045-1-samitolvanen@google.com>
 <CA+icZUWYxO1hHW-_vrJid7EstqQRYQphjO3Xn6pj6qfEYEONbA@mail.gmail.com>
 <20210109153646.zrmglpvr27f5zd7m@treble> <CA+icZUUiucbsQZtJKYdD7Y7Cq8hJZdBwsF0U0BFbaBtnLY3Nsw@mail.gmail.com>
 <20210109160709.kqqpf64klflajarl@treble> <CA+icZUU=sS2xfzo9qTUTPQ0prbbQcj29tpDt1qK5cYZxarXuxg@mail.gmail.com>
 <20210109163256.3sv3wbgrshbj72ik@treble> <CA+icZUUszOHkJ8Acx2mDowg3StZw9EureDQ7YYkJkcAnpLBA+g@mail.gmail.com>
 <20210109170353.litivfvc4zotnimv@treble> <20210109170558.meufvgwrjtqo5v3i@treble>
In-Reply-To: <20210109170558.meufvgwrjtqo5v3i@treble>
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Sat, 9 Jan 2021 18:33:36 +0100
Message-ID: <CA+icZUVEyCJK4ja_d=45t35=uRoXSDutcqEXBtKbChoP3MozrQ@mail.gmail.com>
Subject: Re: [PATCH v9 00/16] Add support for Clang LTO
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, Masahiro Yamada <masahiroy@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, 
	Clang-Built-Linux ML <clang-built-linux@googlegroups.com>, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, Jan 9, 2021 at 6:06 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> On Sat, Jan 09, 2021 at 11:03:57AM -0600, Josh Poimboeuf wrote:
> > On Sat, Jan 09, 2021 at 05:45:47PM +0100, Sedat Dilek wrote:
> > > I tried merging with clang-cfi Git which is based on Linux v5.11-rc2+
> > > with a lot of merge conflicts.
> > >
> > > Did you try on top of cfi-10 Git tag which is based on Linux v5.10?
> > >
> > > Whatever you successfully did... Can you give me a step-by-step instruction?
> >
> > Oops, my bad.  My last three commits (which I just added) do conflict.
> > Sorry for the confusion.
> >
> > Just drop my last three commits:
> >
> > git fetch https://git.kernel.org/pub/scm/linux/kernel/git/jpoimboe/linux.git objtool-vmlinux
> > git checkout -B tmp FETCH_HEAD
> > git reset --hard HEAD~~~
> > git fetch https://github.com/samitolvanen/linux clang-lto
> > git rebase --onto FETCH_HEAD 79881bfc57be
>
> Last one should be:
>
> git rebase --onto FETCH_HEAD 2c85ebc57b3e
>

OK, that worked fine.

So commit 2c85ebc57b3e is v5.10 Git tag in upstream.

So, I substituted:

git rebase --onto FETCH_HEAD v5.10

Thanks.

- Sedat -
