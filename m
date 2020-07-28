Return-Path: <kernel-hardening-return-19480-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 198EF2310E2
	for <lists+kernel-hardening@lfdr.de>; Tue, 28 Jul 2020 19:29:32 +0200 (CEST)
Received: (qmail 13809 invoked by uid 550); 28 Jul 2020 17:29:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13786 invoked from network); 28 Jul 2020 17:29:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1595957353;
	bh=2T3mr7waKN2zzqEx10ZQKW4qYXOz5+D5jfjnMLkLR2o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vVCKMUptkWj96NFd/9wAfn1anprKpA1fwfJcUu2vSpsNVfOJyrX9Kybt/aAzDWI/3
	 zhPgKHbFtGm4eNoNdXw3LASuth1mLDaaX/XN4AcfyVmGU2TOq0dJr129XX1ogXhViN
	 lIysWUbEQBTENhX/MJzpx14RG9c5PDIptwAHWYT0=
Date: Tue, 28 Jul 2020 19:29:08 +0200
From: Jessica Yu <jeyu@kernel.org>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: keescook@chromium.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
	arjan@linux.intel.com, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
	Ard Biesheuvel <ardb@kernel.org>, Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v4 10/10] module: Reorder functions
Message-ID: <20200728172907.GA31178@linux-8ccs>
References: <20200717170008.5949-1-kristen@linux.intel.com>
 <20200717170008.5949-11-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200717170008.5949-11-kristen@linux.intel.com>
X-OS: Linux linux-8ccs 5.5.0-lp150.12.61-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)

+++ Kristen Carlson Accardi [17/07/20 10:00 -0700]:
>Introduce a new config option to allow modules to be re-ordered
>by function. This option can be enabled independently of the
>kernel text KASLR or FG_KASLR settings so that it can be used
>by architectures that do not support either of these features.
>This option will be selected by default if CONFIG_FG_KASLR is
>selected.
>
>If a module has functions split out into separate text sections
>(i.e. compiled with the -ffunction-sections flag), reorder the
>functions to provide some code diversification to modules.
>
>Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
>Reviewed-by: Kees Cook <keescook@chromium.org>
>Acked-by: Ard Biesheuvel <ardb@kernel.org>
>Tested-by: Ard Biesheuvel <ardb@kernel.org>
>Reviewed-by: Tony Luck <tony.luck@intel.com>
>Tested-by: Tony Luck <tony.luck@intel.com>

Hi Kristen!

I've boot tested this on x86, (un)loaded some modules, and checked
their resulting section addresses as a quick sanity test. Feel free
to add my:

Acked-by: Jessica Yu <jeyu@kernel.org>
Tested-by: Jessica Yu <jeyu@kernel.org>

Thank you!

Jessica
