Return-Path: <kernel-hardening-return-16401-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4BE4D63914
	for <lists+kernel-hardening@lfdr.de>; Tue,  9 Jul 2019 18:10:38 +0200 (CEST)
Received: (qmail 31799 invoked by uid 550); 9 Jul 2019 16:10:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 31765 invoked from network); 9 Jul 2019 16:10:31 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:599:800:960:967:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2559:2563:2682:2685:2828:2859:2895:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3653:3865:3866:3867:3868:3870:3871:3873:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:4605:5007:6119:7576:7903:8957:8985:9025:9545:10004:10400:10848:11026:11232:11658:11914:12043:12297:12438:12555:12679:12740:12760:12895:12986:13019:13069:13161:13229:13311:13357:13439:14096:14097:14181:14659:14721:14777:21080:21433:21451:21627:21811:30054:30064:30091,0,RBL:error,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: front40_59e25574f9562
X-Filterd-Recvd-Size: 2588
Message-ID: <040b50f00501ae131256bb13a5362731ebdd6bfe.camel@perches.com>
Subject: Re: [PATCH v4] Added warnings in checkpatch.pl script to :
From: Joe Perches <joe@perches.com>
To: NitinGote <nitin.r.gote@intel.com>, corbet@lwn.net
Cc: akpm@linux-foundation.org, apw@canonical.com, keescook@chromium.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-hardening@lists.openwall.com
Date: Tue, 09 Jul 2019 09:10:16 -0700
In-Reply-To: <20190709154806.26363-1-nitin.r.gote@intel.com>
References: <20190709154806.26363-1-nitin.r.gote@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2019-07-09 at 21:18 +0530, NitinGote wrote:
> From: Nitin Gote <nitin.r.gote@intel.com>
> 
> 1. Deprecate strcpy() in favor of strscpy().
> 2. Deprecate strlcpy() in favor of strscpy().
> 3. Deprecate strncpy() in favor of strscpy() or strscpy_pad().
> 
> Updated strncpy() section in Documentation/process/deprecated.rst
> to cover strscpy_pad() case.

Please slow down your patch submission rate for
this instance and respond appropriately to the
comments you've been given.

This stuff is not critical bug fixing.

The subject could be something like:

Subject: [PATCH v#] Documentation/checkpatch: Prefer strscpy over strcpy/strlcpy

> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -605,6 +605,20 @@ foreach my $entry (keys %deprecated_apis) {
>  }
>  $deprecated_apis_search = "(?:${deprecated_apis_search})";
> 
> +our %deprecated_string_apis = (
> +        "strcpy"				=> "strscpy",
> +        "strlcpy"				=> "strscpy",
> +        "strncpy"				=> "strscpy, strscpy_pad or for non-NUL-terminated strings, strncpy() can still be used, but destinations should be marked with the __nonstring",

'the' is not necessary.

There could likely also be a strscat created for
strcat, strlcat and strncat.

btw:

There were several defects in the kernel for misuses
of strlcpy.

Did you or anyone else have an opinion on stracpy
to avoid duplicating the first argument in a
sizeof()?

	strlcpy(foo, bar, sizeof(foo))
to
	stracpy(foo, bar)

where foo must be char array compatible ?

https://lore.kernel.org/lkml/d1524130f91d7cfd61bc736623409693d2895f57.camel@perches.com/



