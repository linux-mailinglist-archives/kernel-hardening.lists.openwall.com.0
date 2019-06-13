Return-Path: <kernel-hardening-return-16139-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0DFAD44BED
	for <lists+kernel-hardening@lfdr.de>; Thu, 13 Jun 2019 21:15:22 +0200 (CEST)
Received: (qmail 3267 invoked by uid 550); 13 Jun 2019 19:15:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3233 invoked from network); 13 Jun 2019 19:15:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560453303;
	bh=Oa0h+VkM+jYwz1CDfagH3gFgn0xbgAhOJQVjNVroz4s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=y0ztSVbqiejhheHcChycJTSyM4/b7Dt0oiJWM+A6VsyqBm2RxLwvOBg/09wnR9y5x
	 62giVDer9tx24qEsHhEvFUfn7VUHwb2/c6v0Qde3TObUoZ6TNPl+WV8HuOfjMv0Y8q
	 7/YFm2bwGyR+Vj9jjypEuxJpgDQYLmic+igSRqgs=
X-Gm-Message-State: APjAAAXD+1bycuTlYtUrBPjDOGeqHKZZ3iTBHJ9JWMOd05TMD0SvbrHp
	GRRZ5cqROknzGl0SQK+gE16p2fnRzJ/PPpeP2Zu+/w==
X-Google-Smtp-Source: APXvYqy+WvOHJFOQlD8iR/jd81NhKk+vz0wZOKgbBUOzHS4PAhfNiAjt+elP2EqMtMeviXbLy2diLOLO4OyVUlf2Sxk=
X-Received: by 2002:a5d:6207:: with SMTP id y7mr40594967wru.265.1560453302165;
 Thu, 13 Jun 2019 12:15:02 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1560198181.git.luto@kernel.org> <25fd7036cefca16c68ecd990e05e05a8ad8fe8b2.1560198181.git.luto@kernel.org>
 <201906101344.018BE4C5C1@keescook>
In-Reply-To: <201906101344.018BE4C5C1@keescook>
From: Andy Lutomirski <luto@kernel.org>
Date: Thu, 13 Jun 2019 12:14:50 -0700
X-Gmail-Original-Message-ID: <CALCETrUYNavL8pu4jQqJjoT=PdeRyjeoLDn=0r7h=2XsHDMezQ@mail.gmail.com>
Message-ID: <CALCETrUYNavL8pu4jQqJjoT=PdeRyjeoLDn=0r7h=2XsHDMezQ@mail.gmail.com>
Subject: Re: [PATCH 5/5] x86/vsyscall: Change the default vsyscall mode to xonly
To: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Borislav Petkov <bp@alien8.de>, Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jun 10, 2019 at 1:44 PM Kees Cook <keescook@chromium.org> wrote:
>
> On Mon, Jun 10, 2019 at 01:25:31PM -0700, Andy Lutomirski wrote:
> > The use case for full emulation over xonly is very esoteric.  Let's
> > change the default to the safer xonly mode.
>
> Perhaps describe the esoteric cases here (and maybe in the Kconfig help
> text)? That should a user determine if they actually need it. (What
> would the failure under xonly look like for someone needing emulate?)

I added it to the Kconfig text.

Right now, the failure will just be a segfault.  I could add some
logic so that it would log "invalid read to vsyscall page -- fix your
userspace or boot with vsyscall=emulate".  Do you think that's
important?

--Andy
