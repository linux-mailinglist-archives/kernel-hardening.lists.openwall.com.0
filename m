Return-Path: <kernel-hardening-return-20275-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 455A92993C2
	for <lists+kernel-hardening@lfdr.de>; Mon, 26 Oct 2020 18:28:08 +0100 (CET)
Received: (qmail 4093 invoked by uid 550); 26 Oct 2020 17:28:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 11550 invoked from network); 26 Oct 2020 14:53:05 -0000
Date: Mon, 26 Oct 2020 14:52:46 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Topi Miettinen <toiwoton@gmail.com>
Cc: Kees Cook <keescook@chromium.org>,
	Szabolcs Nagy <szabolcs.nagy@arm.com>,
	Jeremy Linton <jeremy.linton@arm.com>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	libc-alpha@sourceware.org, systemd-devel@lists.freedesktop.org,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mark Brown <broonie@kernel.org>, Dave Martin <dave.martin@arm.com>,
	Will Deacon <will.deacon@arm.com>,
	Salvatore Mesoraca <s.mesoraca16@gmail.com>,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org
Subject: Re: BTI interaction between seccomp filters in systemd and glibc
 mprotect calls, causing service failures
Message-ID: <20201026145245.GD3117@gaia>
References: <8584c14f-5c28-9d70-c054-7c78127d84ea@arm.com>
 <20201022075447.GO3819@arm.com>
 <78464155-f459-773f-d0ee-c5bdbeb39e5d@gmail.com>
 <202010221256.A4F95FD11@keescook>
 <20201023090232.GA25736@gaia>
 <cf655c11-d854-281a-17ae-262ddf0aaa08@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf655c11-d854-281a-17ae-262ddf0aaa08@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Sat, Oct 24, 2020 at 02:01:30PM +0300, Topi Miettinen wrote:
> On 23.10.2020 12.02, Catalin Marinas wrote:
> > On Thu, Oct 22, 2020 at 01:02:18PM -0700, Kees Cook wrote:
> > > Regardless, it makes sense to me to have the kernel load the executable
> > > itself with BTI enabled by default. I prefer gaining Catalin's suggested
> > > patch[2]. :)
> > [...]
> > > [2] https://lore.kernel.org/linux-arm-kernel/20201022093104.GB1229@gaia/
> > 
> > I think I first heard the idea at Mark R ;).
> > 
> > It still needs glibc changes to avoid the mprotect(), or at least ignore
> > the error. Since this is an ABI change and we don't know which kernels
> > would have it backported, maybe better to still issue the mprotect() but
> > ignore the failure.
> 
> What about kernel adding an auxiliary vector as a flag to indicate that BTI
> is supported and recommended by the kernel? Then dynamic loader could use
> that to detect that a) the main executable is BTI protected and there's no
> need to mprotect() it and b) PROT_BTI flag should be added to all PROT_EXEC
> pages.

We could add a bit to AT_FLAGS, it's always been 0 for Linux.

> In absence of the vector, the dynamic loader might choose to skip doing
> PROT_BTI at all (since the main executable isn't protected anyway either, or
> maybe even the kernel is up-to-date but it knows that it's not recommended
> for some reason, or maybe the kernel is so ancient that it doesn't know
> about BTI). Optionally it could still read the flag from ELF later (for
> compatibility with old kernels) and then do the mprotect() dance, which may
> trip seccomp filters, possibly fatally.

I think the safest is for the dynamic loader to issue an mprotect() and
ignore the EPERM error. Not all user deployments have this seccomp
filter, so they can still benefit, and user can't tell whether the
kernel change has been backported.

Now, if the dynamic loader silently ignores the mprotect() failure on
the main executable, is there much value in exposing a flag in the aux
vectors? It saves a few (one?) mprotect() calls but I don't think it
matters much. Anyway, I don't mind the flag.

The only potential risk is if the dynamic loader decides not to turn
PROT_BTI one because of some mix and match of objects but AFAIK BTI
allows interworking.

-- 
Catalin
