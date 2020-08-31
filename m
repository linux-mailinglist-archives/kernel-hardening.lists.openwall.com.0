Return-Path: <kernel-hardening-return-19712-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3CF7A257140
	for <lists+kernel-hardening@lfdr.de>; Mon, 31 Aug 2020 02:44:33 +0200 (CEST)
Received: (qmail 15646 invoked by uid 550); 31 Aug 2020 00:44:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15611 invoked from network); 31 Aug 2020 00:44:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598834651;
	bh=6LFPsle47n36rc0FcyNKsEGD+oQ4SDQDYywUFSKldSk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FqO+brb/S1ZYZR+ybuH+M8gh/BEZ8/GsluEaod9qSVDzwNgYPGNyU7DDH2mFQJtGk
	 1rt59pZPUr/dPHYYhq9IJH9JCvqG/i49ZHYaUV8gikAXPEDtE0GC2ilTIEc2ySqG8J
	 bmXa2J5CykCnsfwLD9XSikkCFf2IWpjf+0P9Yy9s=
Date: Sun, 30 Aug 2020 17:44:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mrinal Pandey <mrinalmni@gmail.com>
Cc: skhan@linuxfoundation.org,
 Linux-kernel-mentees@lists.linuxfoundation.org, lukas.bulwahn@gmail.com,
 keescook@chromium.org, re.emese@gmail.com, maennich@google.com,
 tglx@linutronix.de, gregkh@linuxfoundation.org,
 kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
 linux-spdx@vger.kernel.org
Subject: Re: [PATCH] scripts: Add intended executable mode and SPDX license
Message-Id: <20200830174409.c24c3f67addcce0cea9a9d4c@linux-foundation.org>
In-Reply-To: <20200827092405.b6hymjxufn2nvgml@mrinalpandey>
References: <20200827092405.b6hymjxufn2nvgml@mrinalpandey>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 27 Aug 2020 14:54:05 +0530 Mrinal Pandey <mrinalmni@gmail.com> wrote:

> commit b72231eb7084 ("scripts: add spdxcheck.py self test") added the file
> spdxcheck-test.sh to the repository without the executable flag and license
> information.

The x bit shouldn't matter.

If someone downloads and applies patch-5.9.xz (which is a supported way
of obtaining a kernel) then patch(1) will erase the x bit anyway.

Is some other script invoking spdxcheck-test.sh directly, instead of
using `/bin/sh spdxcheck-test.sh'?  If so, please let's fix that.
