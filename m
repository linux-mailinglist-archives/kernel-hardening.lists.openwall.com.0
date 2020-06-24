Return-Path: <kernel-hardening-return-19154-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9CCE220973E
	for <lists+kernel-hardening@lfdr.de>; Thu, 25 Jun 2020 01:40:22 +0200 (CEST)
Received: (qmail 32077 invoked by uid 550); 24 Jun 2020 23:40:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32039 invoked from network); 24 Jun 2020 23:40:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OXwCzf5B5Vnc4rPGARP7edsvVNysUhYzQGqjGFLfJUg=;
        b=eJvh37nNRJoXUBuIREWky64c/2Zy+QfsGiyybHo4/AY79kM2WK5DCWQ2SFWNIlhRqR
         uvyBfk+MP4VctCsNpVpZcmoQSq5Bq2w+lQM6xBkh25apGFZZlExegOU/Xa4ZzLv1+QGo
         2SZwCYjmMFcvWre4jkB8JFSvGQLtaMZLbShuOQoeq/pW5jRL7ENSqIcZKBium29PAxHa
         SUKoF/TCC6EPkmXpV56a4eqzpU85/8BnY0vmWySOQ6P4JhiJF+3GTW6JN67+OxEwI6FO
         083DgLg4vlRvZAYijlbkUJhYrikRhcAUh0cGmqJe8b/JYcwRofo02mXuHf66C14NJXzV
         SJRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OXwCzf5B5Vnc4rPGARP7edsvVNysUhYzQGqjGFLfJUg=;
        b=qd72PBO2JlJVlkz/3BxZoS1h91YgX6DDKPJCg8FVQdZ8+fURanr0qdWTKj50I942u4
         LOkNVrRytilZQ8QXVYY7nkxda3rAqut4TQ5pdb3h8MY5QZCT9CnGlcM38/sCSVUCK95v
         IbDeuyGc0tpxM/LsyA7KYbnKO/qLpREb/imE6Vqra+/iCstCd4CwseabUomgEEG2KEv+
         gb8NCBM7TBzAswmU5Pp9wFN8ventuRYbQG3c8wn4H0DvlbMyGBywuMQQHhleyMWXzKu+
         ZhkJb6X2ZHTVh2Gtc3TRo+XlBp8bEf11uwzBc4wItzZFCh1QuE+6vMo2YGFHKn9FZ3ZH
         JzXg==
X-Gm-Message-State: AOAM5322F1bjIyGBubkDYj18+2Qz5sJVG2gzt4OpejzzVbzQ8LbCUVax
	EhtoBySl4ngOwl+3F6ES/Udv9w==
X-Google-Smtp-Source: ABdhPJzXlVXz0ute8/7RtpY4QOpyoQzqmeZeuFCeuHxJTgdZ5uUxN+EFgHwfWmPsVtpJN+LSHdwUaA==
X-Received: by 2002:aa7:9289:: with SMTP id j9mr33592532pfa.124.1593042004835;
        Wed, 24 Jun 2020 16:40:04 -0700 (PDT)
Date: Wed, 24 Jun 2020 16:39:59 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 17/22] arm64: vdso: disable LTO
Message-ID: <20200624233959.GB94769@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-18-samitolvanen@google.com>
 <CAKwvOdnEbCfYZ9o=OF51oswyqDvN4iP-9syWUDhxfueq4q0xcw@mail.gmail.com>
 <20200624215231.GC120457@google.com>
 <CAKwvOdnWfhU7n0VfoydC7epJPrj+ASZzyNRpBCNuvT_5E+=FcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdnWfhU7n0VfoydC7epJPrj+ASZzyNRpBCNuvT_5E+=FcQ@mail.gmail.com>

On Wed, Jun 24, 2020 at 04:05:48PM -0700, Nick Desaulniers wrote:
> On Wed, Jun 24, 2020 at 2:52 PM Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > On Wed, Jun 24, 2020 at 01:58:57PM -0700, 'Nick Desaulniers' via Clang Built Linux wrote:
> > > On Wed, Jun 24, 2020 at 1:33 PM Sami Tolvanen <samitolvanen@google.com> wrote:
> > > >
> > > > Filter out CC_FLAGS_LTO for the vDSO.
> > >
> > > Just curious about this patch (and the following one for x86's vdso),
> > > do you happen to recall specifically what the issues with the vdso's
> > > are?
> >
> > I recall the compiler optimizing away functions at some point, but as
> > LTO is not really needed in the vDSO, it's just easiest to disable it
> > there.
> 
> Sounds fishy; with extern linkage then I would think it's not safe to
> eliminate functions.  Probably unnecessary for the initial
> implementation, and something we can follow up on, but always good to
> have an answer to the inevitable question "why?" in the commit
> message.

Sure. I can test this again with the current toolchain to see if there
are still problems.

Sami
