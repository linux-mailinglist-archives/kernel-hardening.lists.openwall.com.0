Return-Path: <kernel-hardening-return-16526-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 772DF707A5
	for <lists+kernel-hardening@lfdr.de>; Mon, 22 Jul 2019 19:41:19 +0200 (CEST)
Received: (qmail 12066 invoked by uid 550); 22 Jul 2019 17:41:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 12034 invoked from network); 22 Jul 2019 17:41:13 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2895:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:4321:4605:5007:6119:7576:7808:7903:8957:10004:10400:10848:11232:11658:11914:12043:12297:12740:12760:12895:13069:13255:13311:13357:13439:14096:14097:14181:14659:14721:21080:21451:21627:30003:30012:30054:30064:30070:30090:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: worm76_25cee27498045
X-Filterd-Recvd-Size: 2116
Message-ID: <28404b52d58efa0a3e85ce05ce0b210049ed6050.camel@perches.com>
Subject: Re: [PATCH v5] Documentation/checkpatch: Prefer strscpy/strscpy_pad
 over strcpy/strlcpy/strncpy
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>, NitinGote <nitin.r.gote@intel.com>
Cc: corbet@lwn.net, akpm@linux-foundation.org, apw@canonical.com, 
	linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
Date: Mon, 22 Jul 2019 10:40:58 -0700
In-Reply-To: <201907221029.B0CBED4F@keescook>
References: <20190717043005.19627-1-nitin.r.gote@intel.com>
	 <201907221029.B0CBED4F@keescook>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2019-07-22 at 10:30 -0700, Kees Cook wrote:
> On Wed, Jul 17, 2019 at 10:00:05AM +0530, NitinGote wrote:
> > From: Nitin Gote <nitin.r.gote@intel.com>
> > 
> > Added check in checkpatch.pl to
> > 1. Deprecate strcpy() in favor of strscpy().
> > 2. Deprecate strlcpy() in favor of strscpy().
> > 3. Deprecate strncpy() in favor of strscpy() or strscpy_pad().
> > 
> > Updated strncpy() section in Documentation/process/deprecated.rst
> > to cover strscpy_pad() case.
> > 
> > Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 
> Joe, does this address your checkpatch concerns?

Well, kinda.

strscpy_pad isn't used anywhere in the kernel.

And

+        "strncpy"				=> "strscpy, strscpy_pad or for non-NUL-terminated strings, strncpy() can still be used, but destinations should be marked with __nonstring",

is a bit verbose.  This could be simply:

+        "strncpy" => "strscpy - for non-NUL-terminated uses, strncpy() dst should be __nonstring",

And I still prefer adding stracpy as it
reduces code verbosity and eliminates defects.


