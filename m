Return-Path: <kernel-hardening-return-16589-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D1C9B75B1A
	for <lists+kernel-hardening@lfdr.de>; Fri, 26 Jul 2019 00:57:35 +0200 (CEST)
Received: (qmail 13313 invoked by uid 550); 25 Jul 2019 22:57:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 12252 invoked from network); 25 Jul 2019 22:57:29 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3622:3866:3867:3868:3870:4321:5007:7576:8957:10004:10400:10848:11026:11232:11658:11914:12297:12438:12679:12740:12760:12895:13069:13255:13311:13357:13439:14181:14659:14721:21080:21627:30054:30064:30070:30091,0,RBL:error,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:26,LUA_SUMMARY:none
X-HE-Tag: linen95_3f6004f62bf19
X-Filterd-Recvd-Size: 1633
Message-ID: <dd43e8789b82a072b89911f41560bbc203d11771.camel@perches.com>
Subject: Re: [PATCH v6] Documentation/checkpatch: Prefer stracpy over
 strcpy/strlcpy/strncpy.
From: Joe Perches <joe@perches.com>
To: NitinGote <nitin.r.gote@intel.com>, keescook@chromium.org
Cc: corbet@lwn.net, akpm@linux-foundation.org, apw@canonical.com, 
	linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
Date: Thu, 25 Jul 2019 15:57:13 -0700
In-Reply-To: <20190725112219.6244-1-nitin.r.gote@intel.com>
References: <20190725112219.6244-1-nitin.r.gote@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2019-07-25 at 16:52 +0530, NitinGote wrote:
> From: Nitin Gote <nitin.r.gote@intel.com>
> 
> Added check in checkpatch.pl to deprecate strcpy(), strlcpy() and
> strncpy() in favor of stracpy().
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> +our %deprecated_string_apis = (
> +	"strcpy"		=> "stracpy",
> +	"strlcpy"		=> "stracpy",
> +	"strncpy"		=> "stracpy - for non-NUL-terminated uses, strncpy dest should be __nonstring",
> +);

Maybe:

our %deprecated_string_apis = (
	"strcpy"		=> "stracpy or strscpy",
	"strlcpy"		=> "stracpy or strscpy",
	"strncpy"		=> "stracpy or strscpy - for non-NUL-terminated uses, strncpy dest should be __nonstring",
);


