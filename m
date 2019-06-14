Return-Path: <kernel-hardening-return-16141-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9149A453EA
	for <lists+kernel-hardening@lfdr.de>; Fri, 14 Jun 2019 07:19:45 +0200 (CEST)
Received: (qmail 24330 invoked by uid 550); 14 Jun 2019 05:19:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24290 invoked from network); 14 Jun 2019 05:19:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nskhfJQuIY7GF0zjhR2dKbT25UZTtER3vtr2UfHLkl0=;
        b=YDO9pFM8Osq93VSo2f3tLfUq86JpUfsiv1X1siRWgaiWymHC7MRXwP56QUxsFHRv3H
         SKCzR0zRWWIU5aRmc/2nEN3bRodhtEo4Zx4gbF9YAeLAQ7MkrR9ImCkLSMhntm06ER6o
         kwKZQJszlo4xYiui9CzoeVonWOJLucEs1S7dw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nskhfJQuIY7GF0zjhR2dKbT25UZTtER3vtr2UfHLkl0=;
        b=MrriJO3GZspfmRNyRVJ5QQeKrPBPAJft6eNVSrfNlFZPz4Xvr9FzVpU/efjDYOMT5o
         /MDTTZdX5bFzJ5O6q6x9NaJCJLb9R8pZoAvmrralf3XZx4Jt6vvr9Rj4vMEKXzwszSdw
         EhaGRoRdcvesDiSjVgTdet4Kr/OGsDPihdi4i2YR+i2D6DpKzS4yDmvixFrN7boCd23Q
         g5hEd3EAiHtxJWY4+DNAB0SZE5KPfB2awvc0/215dhX0avQDVhzd5a6jCU3WUp+yDVGq
         Iv0QH8VtYxn4CeCma7OfygzYuZvPWXMzlhJa0ChLCkaaWCG5VQbq7AQBDqJQe5gFGOUK
         CFZQ==
X-Gm-Message-State: APjAAAWD/A9MMdiaN4AyHcUohpvYolvedWO9xRG0KYptYwnPzIxP3ZJN
	z9un7vR6odgLd+BnCKieCckqYA==
X-Google-Smtp-Source: APXvYqxrnfq+JKGiO2MZ5LrxEthLtuHyFKWQHWwvD7llZNQrcCIKzBfSJFqibnh9dhqVgmZUEBd3tQ==
X-Received: by 2002:a63:4c:: with SMTP id 73mr32496569pga.134.1560489565544;
        Thu, 13 Jun 2019 22:19:25 -0700 (PDT)
Date: Thu, 13 Jun 2019 22:19:23 -0700
From: Kees Cook <keescook@chromium.org>
To: Andy Lutomirski <luto@kernel.org>
Cc: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 5/5] x86/vsyscall: Change the default vsyscall mode to
 xonly
Message-ID: <201906132218.E923F38F@keescook>
References: <cover.1560198181.git.luto@kernel.org>
 <25fd7036cefca16c68ecd990e05e05a8ad8fe8b2.1560198181.git.luto@kernel.org>
 <201906101344.018BE4C5C1@keescook>
 <CALCETrUYNavL8pu4jQqJjoT=PdeRyjeoLDn=0r7h=2XsHDMezQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUYNavL8pu4jQqJjoT=PdeRyjeoLDn=0r7h=2XsHDMezQ@mail.gmail.com>

On Thu, Jun 13, 2019 at 12:14:50PM -0700, Andy Lutomirski wrote:
> On Mon, Jun 10, 2019 at 1:44 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Mon, Jun 10, 2019 at 01:25:31PM -0700, Andy Lutomirski wrote:
> > > The use case for full emulation over xonly is very esoteric.  Let's
> > > change the default to the safer xonly mode.
> >
> > Perhaps describe the esoteric cases here (and maybe in the Kconfig help
> > text)? That should a user determine if they actually need it. (What
> > would the failure under xonly look like for someone needing emulate?)
> 
> I added it to the Kconfig text.
> 
> Right now, the failure will just be a segfault.  I could add some
> logic so that it would log "invalid read to vsyscall page -- fix your
> userspace or boot with vsyscall=emulate".  Do you think that's
> important?

I think it would be a friendly way to help anyone wondering why
something suddenly started segfaulting, yeah. Just a pr_warn_once() or
something (not a WARN() since it's "intentionally" reachable by
userspace).

-- 
Kees Cook
