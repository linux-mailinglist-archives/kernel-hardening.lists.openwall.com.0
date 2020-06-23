Return-Path: <kernel-hardening-return-19055-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6E4C2204C00
	for <lists+kernel-hardening@lfdr.de>; Tue, 23 Jun 2020 10:13:27 +0200 (CEST)
Received: (qmail 13730 invoked by uid 550); 23 Jun 2020 08:13:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13693 invoked from network); 23 Jun 2020 08:13:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592899988;
	bh=DuOTpzYPG9xq2HFv+Xyng2Imo2cj0+nwKz/IocstvS0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=2mwh5yW+8NLOWwEB2fpS2rtz04AqII7x7zCasMdNlid0PwW1+q8ba+MSeQbK275iH
	 wProUptpwL+3RSejhObvMBcORe0LlKZBsxde8+/3i3KF93+LRTN7yXfFGixEv3Rw7w
	 n178XVumq3KaHR5nmg9FW90FhYbWNAb4YgGnBNRw=
Date: Tue, 23 Jun 2020 09:13:03 +0100
From: Will Deacon <will@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
	catalin.marinas@arm.com, lorenzo.pieralisi@arm.com,
	sudeep.holla@arm.com, kernel-hardening@lists.openwall.com,
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: Re: [RFC PATCH] arm64/acpi: disallow AML memory opregions to access
 kernel memory
Message-ID: <20200623081303.GA3531@willie-the-truck>
References: <20200622092719.1380968-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622092719.1380968-1-ardb@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Mon, Jun 22, 2020 at 11:27:19AM +0200, Ard Biesheuvel wrote:
> ACPI provides support for SystemMemory opregions, to allow AML methods
> to access MMIO registers of, e.g., GPIO controllers, or access reserved
> regions of memory that are owned by the firmware.
> 
> Currently, we also permit AML methods to access memory that is owned by
> the kernel and mapped via the linear region, which does not seem to be
> supported by a valid use case, and exposes the kernel's internal state
> to AML methods that may be buggy and exploitable.
> 
> So close the door on this, and simply reject AML remapping requests for
> any memory that has a valid mapping in the linear region.
> 
> Reported-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---
>  arch/arm64/include/asm/acpi.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/acpi.h b/arch/arm64/include/asm/acpi.h
> index a45366c3909b..18dcef4e6764 100644
> --- a/arch/arm64/include/asm/acpi.h
> +++ b/arch/arm64/include/asm/acpi.h
> @@ -50,9 +50,9 @@ pgprot_t __acpi_get_mem_attribute(phys_addr_t addr);
>  static inline void __iomem *acpi_os_ioremap(acpi_physical_address phys,
>  					    acpi_size size)
>  {
> -	/* For normal memory we already have a cacheable mapping. */
> +	/* Don't allow access to kernel memory from AML code */
>  	if (memblock_is_map_memory(phys))
> -		return (void __iomem *)__phys_to_virt(phys);
> +		return NULL;

I wonder if it would be better to poison this so that if we do see reports
of AML crashes we'll know straight away that it tried to access memory
mapped by the linear region, as opposed to some other NULL dereference.

Anyway, no objections to the idea. Be good for some of the usual ACPI
suspects to check this doesn't blow up immediately, though.

Will
