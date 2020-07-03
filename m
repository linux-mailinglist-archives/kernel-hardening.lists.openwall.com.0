Return-Path: <kernel-hardening-return-19210-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 50218213D5D
	for <lists+kernel-hardening@lfdr.de>; Fri,  3 Jul 2020 18:14:55 +0200 (CEST)
Received: (qmail 3906 invoked by uid 550); 3 Jul 2020 16:14:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3874 invoked from network); 3 Jul 2020 16:14:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593792874;
	bh=Yq5g2yL8MS9qTROXG6jZBf1iSC7QVCLbTbtbSdg7t3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xN5NdGnuCHugKHSTjKh5JU4jxukMytemj6mFHo+iTV2WfVcQEicxJxocuNcB3U32N
	 ThgbdJRl5NzOwXpRbXcUeUbVd4i42G7IyfwIVc5n6bx9H1ZmSFvRryki9xHNPB6WHw
	 fMfVatmcfSM+mDMOdsGjKScFhnArj4hR3xdY8vm0=
Date: Fri, 3 Jul 2020 17:14:30 +0100
From: Will Deacon <will@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [RFC PATCH v2] arm64/acpi: disallow AML memory opregions to
 access kernel memory
Message-ID: <20200703161429.GA19595@willie-the-truck>
References: <20200623093755.1534006-1-ardb@kernel.org>
 <20200623162655.GA22650@red-moon.cambridge.arm.com>
 <CAMj1kXEwnDGV=J7kdtzrPY9hT=Bp6XRCw85urK2MLXsZG3zdMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXEwnDGV=J7kdtzrPY9hT=Bp6XRCw85urK2MLXsZG3zdMw@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Jun 23, 2020 at 06:32:25PM +0200, Ard Biesheuvel wrote:
> On Tue, 23 Jun 2020 at 18:27, Lorenzo Pieralisi
> <lorenzo.pieralisi@arm.com> wrote:
> > On Tue, Jun 23, 2020 at 11:37:55AM +0200, Ard Biesheuvel wrote:
> > > AML uses SystemMemory opregions to allow AML handlers to access MMIO
> > > registers of, e.g., GPIO controllers, or access reserved regions of
> > > memory that are owned by the firmware.
> > >
> > > Currently, we also allow AML access to memory that is owned by the
> > > kernel and mapped via the linear region, which does not seem to be
> > > supported by a valid use case, and exposes the kernel's internal
> > > state to AML methods that may be buggy and exploitable.
> > >
> > > On arm64, ACPI support requires booting in EFI mode, and so we can cross
> > > reference the requested region against the EFI memory map, rather than
> > > just do a minimal check on the first page. So let's only permit regions
> > > to be remapped by the ACPI core if
> > > - they don't appear in the EFI memory map at all (which is the case for
> > >   most MMIO), or
> > > - they are covered by a single region in the EFI memory map, which is not
> > >   of a type that describes memory that is given to the kernel at boot.
> > >
> > > Reported-by: Jason A. Donenfeld <Jason@zx2c4.com>
> > > Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> > > ---
> > > v2: do a more elaborate check on the region, against the EFI memory map
> > >
> > >  arch/arm64/include/asm/acpi.h | 15 +---
> > >  arch/arm64/kernel/acpi.c      | 72 ++++++++++++++++++++
> > >  2 files changed, 73 insertions(+), 14 deletions(-)

[...]

> > > +             case EFI_RUNTIME_SERVICES_CODE:
> > > +                     /*
> > > +                      * This would be unusual, but not problematic per se,
> > > +                      * as long as we take care not to create a writable
> > > +                      * mapping for executable code.
> > > +                      */
> > > +                     prot = PAGE_KERNEL_RO;
> >
> > Nit: IIUC this tweaks the current behaviour (so it is probably better
> > to move this change to another patch).
> >
> 
> OK
> 
> > Other than that the patch is sound and probably the best we could
> > do to harden the code, goes without saying - it requires testing.
> >
> 
> Indeed. I will do some testing on the systems I have access to, and
> hopefully, other will as well.

Is this 5.9 material, or do you want it to go in as a fix?

Will
