Return-Path: <kernel-hardening-return-19268-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2032F219B54
	for <lists+kernel-hardening@lfdr.de>; Thu,  9 Jul 2020 10:43:03 +0200 (CEST)
Received: (qmail 20141 invoked by uid 550); 9 Jul 2020 08:42:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 20101 invoked from network); 9 Jul 2020 08:42:56 -0000
Date: Thu, 9 Jul 2020 09:42:36 +0100
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-acpi@vger.kernel.org,
	will@kernel.org, catalin.marinas@arm.com, sudeep.holla@arm.com,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v3 0/2] arm64/acpi: restrict AML opregion memory access
Message-ID: <20200709084236.GA18009@e121166-lin.cambridge.arm.com>
References: <20200626155832.2323789-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200626155832.2323789-1-ardb@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Fri, Jun 26, 2020 at 05:58:30PM +0200, Ard Biesheuvel wrote:
> v2:
> - do a more elaborate check on the region, against the EFI memory map
> 
> v3:
> - split into two patches
> - fallback to __ioremap() for ACPI reclaim memory, in case it is not covered
>   by the linear mapping (e.g., when booting a kdump kernel)
> 
> Ard Biesheuvel (2):
>   arm64/acpi: disallow AML memory opregions to access kernel memory
>   arm64/acpi: disallow writeable AML opregion mapping for EFI code
>     regions
> 
>  arch/arm64/include/asm/acpi.h | 15 +---
>  arch/arm64/kernel/acpi.c      | 75 ++++++++++++++++++++
>  2 files changed, 76 insertions(+), 14 deletions(-)

Thanks Ard for fixing this, for the series:

Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
