Return-Path: <kernel-hardening-return-17167-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7A962E9B5B
	for <lists+kernel-hardening@lfdr.de>; Wed, 30 Oct 2019 13:14:37 +0100 (CET)
Received: (qmail 9395 invoked by uid 550); 30 Oct 2019 12:14:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9357 invoked from network); 30 Oct 2019 12:14:29 -0000
X-powerpc-patch-notification: thanks
X-powerpc-patch-commit: 96664dee5cf1815777286227b09884b4f019727f
In-Reply-To: <20190907061124.1947-2-cmr@informatik.wtf>
To: "Christopher M. Riedl" <cmr@informatik.wtf>, linuxppc-dev@ozlabs.org, kernel-hardening@lists.openwall.com
From: Michael Ellerman <patch-notifications@ellerman.id.au>
Cc: ajd@linux.ibm.com, dja@axtens.net
Subject: Re: [PATCH v7 1/2] powerpc/xmon: Allow listing and clearing breakpoints in read-only mode
Message-Id: <4736nh54WPz9sQm@ozlabs.org>
Date: Wed, 30 Oct 2019 23:14:16 +1100 (AEDT)

On Sat, 2019-09-07 at 06:11:23 UTC, "Christopher M. Riedl" wrote:
> Read-only mode should not prevent listing and clearing any active
> breakpoints.
> 
> Tested-by: Daniel Axtens <dja@axtens.net>
> Reviewed-by: Daniel Axtens <dja@axtens.net>
> Signed-off-by: Christopher M. Riedl <cmr@informatik.wtf>

Series applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/96664dee5cf1815777286227b09884b4f019727f

cheers
