Return-Path: <kernel-hardening-return-16226-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6F56A55487
	for <lists+kernel-hardening@lfdr.de>; Tue, 25 Jun 2019 18:30:49 +0200 (CEST)
Received: (qmail 26127 invoked by uid 550); 25 Jun 2019 16:30:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26109 invoked from network); 25 Jun 2019 16:30:42 -0000
Date: Tue, 25 Jun 2019 18:30:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Florian Weimer <fweimer@redhat.com>
cc: linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com, 
    linux-x86_64@vger.kernel.org, linux-arch@vger.kernel.org, 
    Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, 
    Carlos O'Donell <carlos@redhat.com>, x86@kernel.org
Subject: Re: Detecting the availability of VSYSCALL
In-Reply-To: <87v9wty9v4.fsf@oldenburg2.str.redhat.com>
Message-ID: <alpine.DEB.2.21.1906251824500.32342@nanos.tec.linutronix.de>
References: <87v9wty9v4.fsf@oldenburg2.str.redhat.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001

On Tue, 25 Jun 2019, Florian Weimer wrote:
> We're trying to create portable binaries which use VSYSCALL on older
> kernels (to avoid performance regressions), but gracefully degrade to
> full system calls on kernels which do not have VSYSCALL support compiled
> in (or disabled at boot).
>
> For technical reasons, we cannot use vDSO fallback.  Trying vDSO first
> and only then use VSYSCALL is the way this has been tackled in the past,
> which is why this userspace ABI breakage goes generally unnoticed.  But
> we don't have a dynamic linker in our scenario.

I'm not following. On newer kernels which usually have vsyscall disabled
you need to use real syscalls anyway, so why are you so worried about
performance on older kernels. That doesn't make sense.

> Is there any reliable way to detect that VSYSCALL is unavailable,
> without resorting to parsing /proc/self/maps or opening file
> descriptors?

Not that I'm aware of except

    sigaction(SIG_SEGV,....)

/me hides
 
> Should we try mapping something at the magic address (without MAP_FIXED)
> and see if we get back a different address?  Something in the auxiliary
> vector would work for us, too, but nothing seems to exists there
> unfortunately.

Would, but there is no such thing.

Thanks,

	tglx
