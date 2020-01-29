Return-Path: <kernel-hardening-return-17635-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id DDDEF14C583
	for <lists+kernel-hardening@lfdr.de>; Wed, 29 Jan 2020 06:17:50 +0100 (CET)
Received: (qmail 16265 invoked by uid 550); 29 Jan 2020 05:17:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 16225 invoked from network); 29 Jan 2020 05:17:43 -0000
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 970d54f99ceac5bbf27929cb5ebfe18338ba1543
In-Reply-To: <20191224064126.183670-1-ruscur@russell.cc>
To: Russell Currey <ruscur@russell.cc>, linuxppc-dev@lists.ozlabs.org
From: Michael Ellerman <patch-notifications@ellerman.id.au>
Cc: ajd@linux.ibm.com, kernel-hardening@lists.openwall.com, npiggin@gmail.com, Russell Currey <ruscur@russell.cc>
Subject: Re: [PATCH 1/2] powerpc/book3s64/hash: Disable 16M linear mapping size if not aligned
Message-Id: <486sDm3Clwz9sRW@ozlabs.org>
Date: Wed, 29 Jan 2020 16:17:28 +1100 (AEDT)

On Tue, 2019-12-24 at 06:41:25 UTC, Russell Currey wrote:
> With STRICT_KERNEL_RWX on in a relocatable kernel under the hash MMU, if
> the position the kernel is loaded at is not 16M aligned, the kernel
> miscalculates its ALIGN*()s and things go horribly wrong.
> 
> We can easily avoid this when selecting the linear mapping size, so do
> so and print a warning.  I tested this for various alignments and as
> long as the position is 64K aligned it's fine (the base requirement for
> powerpc).
> 
> Signed-off-by: Russell Currey <ruscur@russell.cc>

Series applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/970d54f99ceac5bbf27929cb5ebfe18338ba1543

cheers
