Return-Path: <kernel-hardening-return-16233-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4A8DB55879
	for <lists+kernel-hardening@lfdr.de>; Tue, 25 Jun 2019 22:11:56 +0200 (CEST)
Received: (qmail 20040 invoked by uid 550); 25 Jun 2019 20:11:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 20021 invoked from network); 25 Jun 2019 20:11:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561493498;
	bh=EEgDTn2acFAmQZQO3MkPdApy27ciI+GVpCKZTuXCYvA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PVsMHvQg4NzwVAfuGHGplLn7MJyzkh7ctvV73YnV2d7IA+QGtzN2aEIpbQT9GIC17
	 asPWX7Za4Zrr/ag8CHqGiLCokLdB1oNdQKiK/jCbstl3Fg4HqbAl6VhdJdsyeM5SoR
	 5Irc0BxRb1H4AmkR/kPNxhQCInVE+0u3FjXfgpFk=
X-Gm-Message-State: APjAAAVpNpBlVyxFWBmsrGS/NdBozYpnKsvP/2dyuXK7s0KS8Lrv+rYe
	O+TblPbaVDfi3BTxZggUpj0K4L7qqeGFl16ibuCnCw==
X-Google-Smtp-Source: APXvYqyW7C9F4Fp13kmilM/0Tp6IXxWEIJxs/+rVeUuVpitLsYIvQ9gyfb71LuqgyjAuj4bqiYpGGQz85a/sf6WmEco=
X-Received: by 2002:a1c:9a53:: with SMTP id c80mr128356wme.173.1561493496503;
 Tue, 25 Jun 2019 13:11:36 -0700 (PDT)
MIME-Version: 1.0
References: <87v9wty9v4.fsf@oldenburg2.str.redhat.com> <alpine.DEB.2.21.1906251824500.32342@nanos.tec.linutronix.de>
 <87lfxpy614.fsf@oldenburg2.str.redhat.com>
In-Reply-To: <87lfxpy614.fsf@oldenburg2.str.redhat.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Tue, 25 Jun 2019 13:11:25 -0700
X-Gmail-Original-Message-ID: <CALCETrVh1f5wJNMbMoVqY=bq-7G=uQ84BUkepf5RksA3vUopNQ@mail.gmail.com>
Message-ID: <CALCETrVh1f5wJNMbMoVqY=bq-7G=uQ84BUkepf5RksA3vUopNQ@mail.gmail.com>
Subject: Re: Detecting the availability of VSYSCALL
To: Florian Weimer <fweimer@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Linux API <linux-api@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-x86_64@vger.kernel.org, 
	linux-arch <linux-arch@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, 
	Kees Cook <keescook@chromium.org>, "Carlos O'Donell" <carlos@redhat.com>, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jun 25, 2019 at 9:39 AM Florian Weimer <fweimer@redhat.com> wrote:
>
> * Thomas Gleixner:
>
> > On Tue, 25 Jun 2019, Florian Weimer wrote:
> >> We're trying to create portable binaries which use VSYSCALL on older
> >> kernels (to avoid performance regressions), but gracefully degrade to
> >> full system calls on kernels which do not have VSYSCALL support compiled
> >> in (or disabled at boot).
> >>
> >> For technical reasons, we cannot use vDSO fallback.  Trying vDSO first
> >> and only then use VSYSCALL is the way this has been tackled in the past,
> >> which is why this userspace ABI breakage goes generally unnoticed.  But
> >> we don't have a dynamic linker in our scenario.
> >
> > I'm not following. On newer kernels which usually have vsyscall disabled
> > you need to use real syscalls anyway, so why are you so worried about
> > performance on older kernels. That doesn't make sense.
>
> We want binaries that run fast on VSYSCALL kernels, but can fall back to
> full system calls on kernels that do not have them (instead of
> crashing).

Define "VSYSCALL kernels."  On any remotely recent kernel (*all* new
kernels and all kernels for the last several years that haven't
specifically requested vsyscall=native), using vsyscalls is much, much
slower than just doing syscalls.  I know a way you can tell whether
vsyscalls are fast, but it's unreliable, and I'm disinclined to
suggest it.  There are also at least two pending patch series that
will interfere.

>
> We could parse the vDSO and prefer the functions found there, but this
> is for the statically linked case.  We currently do not have a (minimal)
> dynamic loader there in that version of the code base, so that doesn't
> really work for us.

Is anything preventing you from adding a vDSO parser?  I wrote one
just for this type of use:

$ wc -l tools/testing/selftests/vDSO/parse_vdso.c
269 tools/testing/selftests/vDSO/parse_vdso.c

(289 lines includes quite a bit of comment.)


$ head -n8 tools/testing/selftests/vDSO/parse_vdso.c
/*
 * parse_vdso.c: Linux reference vDSO parser
 * Written by Andrew Lutomirski, 2011-2014.
 *
 * This code is meant to be linked in to various programs that run on Linux.
 * As such, it is available with as few restrictions as possible.  This file
 * is licensed under the Creative Commons Zero License, version 1.0,
 * available at http://creativecommons.org/publicdomain/zero/1.0/legalcode

If this license is too restrictive for you, I could probably be
convinced to relicense it, I'd be surprised :)  In hindsight, I kind
of wish I'd used MIT instead, since the Go runtime took advantage of
the CC0 license to import it without attribution *and* break it quite
badly in the process.

IMO the correct solution is to parse the vDSO and, if that fails, to
use plain syscalls as a fallback.  You should not ship anything that
uses a vsyscall under any circumstances, unless you need the last
ounce of performance on that one ancient version of OpenSuSE that
crashes if the vDSO is enabled.
