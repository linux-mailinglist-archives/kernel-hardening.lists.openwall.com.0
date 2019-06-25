Return-Path: <kernel-hardening-return-16236-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6F4C855A3A
	for <lists+kernel-hardening@lfdr.de>; Tue, 25 Jun 2019 23:50:01 +0200 (CEST)
Received: (qmail 18135 invoked by uid 550); 25 Jun 2019 21:49:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 18105 invoked from network); 25 Jun 2019 21:49:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561499381;
	bh=nsK9ldkmdjVwnnDSmeYoL//aK+whouJyfJYufkycbv8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=L8PXFlud8h1hxJq8oRRyDOvxZnWIttVneba+a4ol6wWoQwKifMlxse/1dbX5U0SEE
	 AOhvtAdqyM/Q0qp3YwQ4cuuo5HIc9LCkv1lUFnyQFV2Bw+2nN87aWTdNzyz2lxFkZa
	 e2Tqs8pgWtBasWFqai5IiX28UeilQUwmNB6bDtfw=
X-Gm-Message-State: APjAAAW4a6ktynY08XAKsdavPaH5uuZJZ91AWy8WXuOwxXdSGbIS4xp6
	iXmb+jtVBPOEikKwW0+ZnYrHvua63L+6KCqAtoSyWQ==
X-Google-Smtp-Source: APXvYqwjTTwscskVZ7N3TOHt3DEsgP/Wy+j7rvfi9No7Uxt/UAtG9s0LdSQiw47ZnV6mtt9xrRs6re6oCQ6d0NVhypk=
X-Received: by 2002:adf:f28a:: with SMTP id k10mr235032wro.343.1561499380210;
 Tue, 25 Jun 2019 14:49:40 -0700 (PDT)
MIME-Version: 1.0
References: <87v9wty9v4.fsf@oldenburg2.str.redhat.com> <alpine.DEB.2.21.1906251824500.32342@nanos.tec.linutronix.de>
 <87lfxpy614.fsf@oldenburg2.str.redhat.com> <CALCETrVh1f5wJNMbMoVqY=bq-7G=uQ84BUkepf5RksA3vUopNQ@mail.gmail.com>
 <87a7e5v1d9.fsf@oldenburg2.str.redhat.com>
In-Reply-To: <87a7e5v1d9.fsf@oldenburg2.str.redhat.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Tue, 25 Jun 2019 14:49:27 -0700
X-Gmail-Original-Message-ID: <CALCETrUDt4v3=FqD+vseGTKTuG=qY+1LwRPrOrU8C7vCVbo=uA@mail.gmail.com>
Message-ID: <CALCETrUDt4v3=FqD+vseGTKTuG=qY+1LwRPrOrU8C7vCVbo=uA@mail.gmail.com>
Subject: Re: Detecting the availability of VSYSCALL
To: Florian Weimer <fweimer@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Linux API <linux-api@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-x86_64@vger.kernel.org, 
	linux-arch <linux-arch@vger.kernel.org>, Kees Cook <keescook@chromium.org>, 
	"Carlos O'Donell" <carlos@redhat.com>, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jun 25, 2019 at 1:47 PM Florian Weimer <fweimer@redhat.com> wrote:
>
> * Andy Lutomirski:
>
> >> We want binaries that run fast on VSYSCALL kernels, but can fall back to
> >> full system calls on kernels that do not have them (instead of
> >> crashing).
> >
> > Define "VSYSCALL kernels."  On any remotely recent kernel (*all* new
> > kernels and all kernels for the last several years that haven't
> > specifically requested vsyscall=native), using vsyscalls is much, much
> > slower than just doing syscalls.  I know a way you can tell whether
> > vsyscalls are fast, but it's unreliable, and I'm disinclined to
> > suggest it.  There are also at least two pending patch series that
> > will interfere.
>
> The fast path is for the benefit of the 2.6.32-based kernel in Red Hat
> Enterprise Linux 6.  It doesn't have the vsyscall emulation code yet, I
> think.
>
> My hope is to produce (statically linked) binaries that run as fast on
> that kernel as they run today, but can gracefully fall back to something
> else on kernels without vsyscall support.
>
> >> We could parse the vDSO and prefer the functions found there, but this
> >> is for the statically linked case.  We currently do not have a (minimal)
> >> dynamic loader there in that version of the code base, so that doesn't
> >> really work for us.
> >
> > Is anything preventing you from adding a vDSO parser?  I wrote one
> > just for this type of use:
> >
> > $ wc -l tools/testing/selftests/vDSO/parse_vdso.c
> > 269 tools/testing/selftests/vDSO/parse_vdso.c
> >
> > (289 lines includes quite a bit of comment.)
>
> I'm worried that if I use a custom parser and the binaries start
> crashing again because something changed in the kernel (within the scope
> permitted by the ELF specification), the kernel won't be fixed.
>
> That is, we'd be in exactly the same situation as today.

With my maintainer hat on, the kernel won't do that.  Obviously a
review of my parser would be appreciated, but I consider it to be
fully supported, just like glibc and musl's parsers are fully
supported.  Sadly, I *also* consider the version Go forked for a while
(now fixed) to be supported.  Sigh.
