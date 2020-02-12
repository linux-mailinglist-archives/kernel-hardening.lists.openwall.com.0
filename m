Return-Path: <kernel-hardening-return-17787-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 42D4615A4BF
	for <lists+kernel-hardening@lfdr.de>; Wed, 12 Feb 2020 10:28:23 +0100 (CET)
Received: (qmail 32265 invoked by uid 550); 12 Feb 2020 09:28:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32191 invoked from network); 12 Feb 2020 09:28:15 -0000
Date: Wed, 12 Feb 2020 09:28:00 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>, Hector Marco-Gisbert <hecmargi@upv.es>,
	Will Deacon <will.deacon@arm.com>,
	Jason Gunthorpe <jgg@mellanox.com>, Jann Horn <jannh@google.com>,
	Russell King <linux@armlinux.org.uk>, x86@kernel.org,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 6/7] arm64, elf: Disable automatic READ_IMPLIES_EXEC
 for 64-bit address spaces
Message-ID: <20200212092800.GD488264@arrakis.emea.arm.com>
References: <20200210193049.64362-1-keescook@chromium.org>
 <20200210193049.64362-7-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210193049.64362-7-keescook@chromium.org>

On Mon, Feb 10, 2020 at 11:30:48AM -0800, Kees Cook wrote:
> With arm64 64-bit environments, there should never be a need for automatic
> READ_IMPLIES_EXEC, as the architecture has always been execute-bit aware
> (as in, the default memory protection should be NX unless a region
> explicitly requests to be executable).
> 
> Suggested-by: Hector Marco-Gisbert <hecmargi@upv.es>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
