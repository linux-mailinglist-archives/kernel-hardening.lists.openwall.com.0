Return-Path: <kernel-hardening-return-16227-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C1E58554B6
	for <lists+kernel-hardening@lfdr.de>; Tue, 25 Jun 2019 18:39:19 +0200 (CEST)
Received: (qmail 3207 invoked by uid 550); 25 Jun 2019 16:39:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3189 invoked from network); 25 Jun 2019 16:39:13 -0000
From: Florian Weimer <fweimer@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-api@vger.kernel.org,  kernel-hardening@lists.openwall.com,  linux-x86_64@vger.kernel.org,  linux-arch@vger.kernel.org,  Andy Lutomirski <luto@kernel.org>,  Kees Cook <keescook@chromium.org>,  Carlos O'Donell <carlos@redhat.com>,  x86@kernel.org
Subject: Re: Detecting the availability of VSYSCALL
References: <87v9wty9v4.fsf@oldenburg2.str.redhat.com>
	<alpine.DEB.2.21.1906251824500.32342@nanos.tec.linutronix.de>
Date: Tue, 25 Jun 2019 18:38:15 +0200
In-Reply-To: <alpine.DEB.2.21.1906251824500.32342@nanos.tec.linutronix.de>
	(Thomas Gleixner's message of "Tue, 25 Jun 2019 18:30:29 +0200
	(CEST)")
Message-ID: <87lfxpy614.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Tue, 25 Jun 2019 16:39:01 +0000 (UTC)

* Thomas Gleixner:

> On Tue, 25 Jun 2019, Florian Weimer wrote:
>> We're trying to create portable binaries which use VSYSCALL on older
>> kernels (to avoid performance regressions), but gracefully degrade to
>> full system calls on kernels which do not have VSYSCALL support compiled
>> in (or disabled at boot).
>>
>> For technical reasons, we cannot use vDSO fallback.  Trying vDSO first
>> and only then use VSYSCALL is the way this has been tackled in the past,
>> which is why this userspace ABI breakage goes generally unnoticed.  But
>> we don't have a dynamic linker in our scenario.
>
> I'm not following. On newer kernels which usually have vsyscall disabled
> you need to use real syscalls anyway, so why are you so worried about
> performance on older kernels. That doesn't make sense.

We want binaries that run fast on VSYSCALL kernels, but can fall back to
full system calls on kernels that do not have them (instead of
crashing).

We could parse the vDSO and prefer the functions found there, but this
is for the statically linked case.  We currently do not have a (minimal)
dynamic loader there in that version of the code base, so that doesn't
really work for us.

>> Is there any reliable way to detect that VSYSCALL is unavailable,
>> without resorting to parsing /proc/self/maps or opening file
>> descriptors?
>
> Not that I'm aware of except
>
>     sigaction(SIG_SEGV,....)
>
> /me hides

I know people do this for SIGILL to probe for CPU features, but yeah,
let's just not go there. 8-p

Thanks,
Florian
