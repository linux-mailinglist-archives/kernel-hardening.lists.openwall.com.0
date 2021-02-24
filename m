Return-Path: <kernel-hardening-return-20818-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id AAE6F323F1C
	for <lists+kernel-hardening@lfdr.de>; Wed, 24 Feb 2021 15:15:22 +0100 (CET)
Received: (qmail 14096 invoked by uid 550); 24 Feb 2021 14:15:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 11738 invoked from network); 24 Feb 2021 14:11:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1614175879;
	bh=BpYruk68R6kEq7xF24RrqNtwpV+CW2aJPPDU8jzgAT0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zk+epHjJBrdH00f9FVkblXRodT6Lfd8mxT1WJMGWIPy6IYQr7VuAAY1O8pmYZlbq1
	 JzSKh1yqqDoR+yc0x/eS76/0Y8CYsZyVeuLPb1HnQXpLbrXcv6TixCRbz/uxppnwMK
	 qxBgf344XsL3afsoJduMVjX8gxf64Ssh0OLWyh1A=
Date: Wed, 24 Feb 2021 15:11:16 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: "Lan Zheng (lanzheng)" <lanzheng@cisco.com>
Cc: "security@kernel.org" <security@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/1] Kernel Config to make randomize_va_space
 read-only.
Message-ID: <YDZehClJ+FaX9RC4@kroah.com>
References: <99738B18-C4E2-4DBA-A142-8F20650D7ADC@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99738B18-C4E2-4DBA-A142-8F20650D7ADC@cisco.com>

On Wed, Feb 24, 2021 at 03:53:37AM +0000, Lan Zheng (lanzheng) wrote:
> From ba2ec52f170a8e69d6c44238bb578f9518a7e3b7 Mon Sep 17 00:00:00 2001
> 
> From: lanzheng <lanzheng@cisco.com>

<snip>

You are still sending html email, which is rejected by the kernel
mailing lists.

And no need to cc: security@kernel.org, that is only for reporting
security issues, not new kernel changes like this.

good luck!

greg k-h
