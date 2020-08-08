Return-Path: <kernel-hardening-return-19574-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id ED2D023F94A
	for <lists+kernel-hardening@lfdr.de>; Sun,  9 Aug 2020 00:18:09 +0200 (CEST)
Received: (qmail 1083 invoked by uid 550); 8 Aug 2020 22:18:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1051 invoked from network); 8 Aug 2020 22:18:01 -0000
Date: Sun, 9 Aug 2020 00:17:48 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>
Cc: Mark Rutland <mark.rutland@arm.com>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, oleg@redhat.com,
	x86@kernel.org
Subject: Re: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
Message-ID: <20200808221748.GA1020@bug>
References: <aefc85852ea518982e74b233e11e16d2e707bc32>
 <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <20200731180955.GC67415@C02TD0UTHF1T.local>
 <6236adf7-4bed-534e-0956-fddab4fd96b6@linux.microsoft.com>
 <20200804143018.GB7440@C02TD0UTHF1T.local>
 <b3368692-afe6-89b5-d634-12f4f0a601f8@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3368692-afe6-89b5-d634-12f4f0a601f8@linux.microsoft.com>
User-Agent: Mutt/1.5.23 (2014-03-12)

Hi!

> Thanks for the lively discussion. I have tried to answer some of the
> comments below.

> > There are options today, e.g.
> >
> > a) If the restriction is only per-alias, you can have distinct aliases
> >    where one is writable and another is executable, and you can make it
> >    hard to find the relationship between the two.
> >
> > b) If the restriction is only temporal, you can write instructions into
> >    an RW- buffer, transition the buffer to R--, verify the buffer
> >    contents, then transition it to --X.
> >
> > c) You can have two processes A and B where A generates instrucitons into
> >    a buffer that (only) B can execute (where B may be restricted from
> >    making syscalls like write, mprotect, etc).
> 
> The general principle of the mitigation is W^X. I would argue that
> the above options are violations of the W^X principle. If they are
> allowed today, they must be fixed. And they will be. So, we cannot
> rely on them.

Would you mind describing your threat model?

Because I believe you are using model different from everyone else.

In particular, I don't believe b) is a problem or should be fixed.

I'll add d), application mmaps a file(R--), and uses write syscall to change
trampolines in it.

> b) This is again a violation. The kernel should refuse to give execute
> ???????? permission to a page that was writeable in the past and refuse to
> ???????? give write permission to a page that was executable in the past.

Why?

										Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
