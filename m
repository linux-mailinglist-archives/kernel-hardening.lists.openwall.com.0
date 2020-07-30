Return-Path: <kernel-hardening-return-19492-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 971E9232F31
	for <lists+kernel-hardening@lfdr.de>; Thu, 30 Jul 2020 11:06:41 +0200 (CEST)
Received: (qmail 18133 invoked by uid 550); 30 Jul 2020 09:06:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 18113 invoked from network); 30 Jul 2020 09:06:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596099983;
	bh=ieC3UQSH9xTQQlFP1mBTpQK8Jaet0JuMdqnPvTiLzSc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z/OlMNCjgJjVCDEAUFFVbS7j9qnE79NsrCIar3YE+oLzkykZo4SyLPjtjBmvhhkcD
	 T9PkgtjWLgbnsiDPD6gD6YwuUd+7hajjK66mABoLrTUlc/yFV744DxvWyv+/e12Zv2
	 o7cXTtiuU4bHGqJbB2DKVrNBS9iI30MBTfDZpeMY=
Date: Thu, 30 Jul 2020 11:06:12 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: madvenka@linux.microsoft.com
Cc: kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, oleg@redhat.com,
	x86@kernel.org
Subject: Re: [PATCH v1 2/4] [RFC] x86/trampfd: Provide support for the
 trampoline file descriptor
Message-ID: <20200730090612.GA900546@kroah.com>
References: <aefc85852ea518982e74b233e11e16d2e707bc32>
 <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <20200728131050.24443-3-madvenka@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728131050.24443-3-madvenka@linux.microsoft.com>

On Tue, Jul 28, 2020 at 08:10:48AM -0500, madvenka@linux.microsoft.com wrote:
> +EXPORT_SYMBOL_GPL(trampfd_valid_regs);

Why are all of these exported?  I don't see a module user in this
series, or did I miss it somehow?

EXPORT_SYMBOL* is only needed for symbols to be used by modules, not by
code that is built into the kernel.

thanks,

greg k-h
