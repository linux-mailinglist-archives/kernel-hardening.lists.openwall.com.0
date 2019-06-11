Return-Path: <kernel-hardening-return-16097-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B259241666
	for <lists+kernel-hardening@lfdr.de>; Tue, 11 Jun 2019 22:48:50 +0200 (CEST)
Received: (qmail 18363 invoked by uid 550); 11 Jun 2019 20:48:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 18303 invoked from network); 11 Jun 2019 20:48:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560286113;
	bh=y33lrlkQja7eoIovWsePDjdEdIHZ/RJoRj29PafhqOI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=UgyruavCsSZLLvbVGn/8Url9hdMFqD/vc6cS2xvCxVAaLGSpqRyO7wgSl3uYSlnrC
	 3+fJjYU9x+kvkKn62ONAnZk5QMPYKtIt9RU5V2bIySebdJX4pNazzbre4oO5OlK2mG
	 81xtH5C+HAjNqK8Itw5roVmiKtRcfGnYRZlw+kVk=
Date: Tue, 11 Jun 2019 13:48:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shyam Saini <shyam.saini@amarulasolutions.com>
Cc: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
 keescook@chromium.org, linux-arm-kernel@lists.infradead.org,
 linux-mips@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 netdev@vger.kernel.org, linux-ext4@vger.kernel.org,
 devel@lists.orangefs.org, linux-mm@kvack.org, linux-sctp@vger.kernel.org,
 bpf@vger.kernel.org, kvm@vger.kernel.org, mayhs11saini@gmail.com, Alexey
 Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH V2] include: linux: Regularise the use of FIELD_SIZEOF
 macro
Message-Id: <20190611134831.a60c11f4b691d14d04a87e29@linux-foundation.org>
In-Reply-To: <20190611193836.2772-1-shyam.saini@amarulasolutions.com>
References: <20190611193836.2772-1-shyam.saini@amarulasolutions.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 12 Jun 2019 01:08:36 +0530 Shyam Saini <shyam.saini@amarulasolutions.com> wrote:

> Currently, there are 3 different macros, namely sizeof_field, SIZEOF_FIELD
> and FIELD_SIZEOF which are used to calculate the size of a member of
> structure, so to bring uniformity in entire kernel source tree lets use
> FIELD_SIZEOF and replace all occurrences of other two macros with this.
> 
> For this purpose, redefine FIELD_SIZEOF in include/linux/stddef.h and
> tools/testing/selftests/bpf/bpf_util.h and remove its defination from
> include/linux/kernel.h
> 
> In favour of FIELD_SIZEOF, this patch also deprecates other two similar
> macros sizeof_field and SIZEOF_FIELD.
> 
> For code compatibility reason, retain sizeof_field macro as a wrapper macro
> to FIELD_SIZEOF

As Alexey has pointed out, C structs and unions don't have fields -
they have members.  So this is an opportunity to switch everything to
a new member_sizeof().

What do people think of that and how does this impact the patch footprint?
