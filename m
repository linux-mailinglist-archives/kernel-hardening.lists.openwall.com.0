Return-Path: <kernel-hardening-return-19059-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 69CD4204DA1
	for <lists+kernel-hardening@lfdr.de>; Tue, 23 Jun 2020 11:14:37 +0200 (CEST)
Received: (qmail 22314 invoked by uid 550); 23 Jun 2020 09:14:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22276 invoked from network); 23 Jun 2020 09:14:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592903658;
	bh=TKjMTcF3Mb6Sr+/zsrwHMHOvC6Gj6PDqtkhuXVJ/fZk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZpqzATd9x15l1Ll9Qprze5762QiDejHlLm6X1EXRgEn9vutEYmcTd/KlvkMq0rJLJ
	 7lmQ8B5CJ6/KCdeHH+4qufTcqGbQbsjJTqaop8sG19iIhvskxJmFT+I9QMQEPZjyEJ
	 r1RttWX+zpQ0bV0qknhec+otG0flV6HtHRMJ5QLU=
Date: Tue, 23 Jun 2020 10:14:13 +0100
From: Will Deacon <will@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Linux ARM <linux-arm-kernel@lists.infradead.org>,
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [RFC PATCH] arm64/acpi: disallow AML memory opregions to access
 kernel memory
Message-ID: <20200623091412.GC3743@willie-the-truck>
References: <20200622092719.1380968-1-ardb@kernel.org>
 <20200623081303.GA3531@willie-the-truck>
 <CAMj1kXFX5okSWZ8SgnOrbs7qVSS1A2kyL12UXQi8JcEWmcDb=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMj1kXFX5okSWZ8SgnOrbs7qVSS1A2kyL12UXQi8JcEWmcDb=w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Jun 23, 2020 at 10:16:19AM +0200, Ard Biesheuvel wrote:
> On Tue, 23 Jun 2020 at 10:13, Will Deacon <will@kernel.org> wrote:
> > On Mon, Jun 22, 2020 at 11:27:19AM +0200, Ard Biesheuvel wrote:
> > > diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
> > > index a45366c3909b..18dcef4e6764 100644
> > > --- a/arch/arm64/include/asm/acpi.h
> > > +++ b/arch/arm64/include/asm/acpi.h
> > > @@ -50,9 +50,9 @@ pgprot_t __acpi_get_mem_attribute(phys_addr_t addr);
> > >  static inline void __iomem *acpi_os_ioremap(acpi_physical_address phys,
> > >                                           acpi_size size)
> > >  {
> > > -     /* For normal memory we already have a cacheable mapping. */
> > > +     /* Don't allow access to kernel memory from AML code */
> > >       if (memblock_is_map_memory(phys))
> > > -             return (void __iomem *)__phys_to_virt(phys);
> > > +             return NULL;
> >
> > I wonder if it would be better to poison this so that if we do see reports
> > of AML crashes we'll know straight away that it tried to access memory
> > mapped by the linear region, as opposed to some other NULL dereference.
> >
> 
> We could just add a WARN_ONCE() here, no?

Yeah, or that, or a firmware taint. Just something to distinguish this
from other NULL pointer derefs.

> > Anyway, no objections to the idea. Be good for some of the usual ACPI
> > suspects to check this doesn't blow up immediately, though.
> >
> 
> Indeed, hence the RFC. Jason does have a point regarding the range
> check, so I will try to do something about that and send a v2.

Ok, I'll keep an eye out for it.

Will
