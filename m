Return-Path: <kernel-hardening-return-19320-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4E23F21FDE0
	for <lists+kernel-hardening@lfdr.de>; Tue, 14 Jul 2020 21:53:02 +0200 (CEST)
Received: (qmail 30508 invoked by uid 550); 14 Jul 2020 19:52:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30476 invoked from network); 14 Jul 2020 19:52:56 -0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ard Biesheuvel <ardb@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will@kernel.org>,
	sudeep.holla@arm.com,
	kernel-hardening@lists.openwall.com,
	linux-acpi@vger.kernel.org,
	lorenzo.pieralisi@arm.com
Subject: Re: [PATCH v3 0/2] arm64/acpi: restrict AML opregion memory access
Date: Tue, 14 Jul 2020 20:52:41 +0100
Message-Id: <159475635407.4337.14038873676675267041.b4-ty@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200626155832.2323789-1-ardb@kernel.org>
References: <20200626155832.2323789-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Fri, 26 Jun 2020 17:58:30 +0200, Ard Biesheuvel wrote:
> v2:
> - do a more elaborate check on the region, against the EFI memory map
> 
> v3:
> - split into two patches
> - fallback to __ioremap() for ACPI reclaim memory, in case it is not covered
>   by the linear mapping (e.g., when booting a kdump kernel)
> 
> [...]

Applied to arm64 (for-next/acpi), thanks!

[1/2] arm64/acpi: disallow AML memory opregions to access kernel memory
      https://git.kernel.org/arm64/c/1583052d111f
[2/2] arm64/acpi: disallow writeable AML opregion mapping for EFI code regions
      https://git.kernel.org/arm64/c/325f5585ec36

-- 
Catalin

