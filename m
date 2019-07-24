Return-Path: <kernel-hardening-return-16581-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0DCC373693
	for <lists+kernel-hardening@lfdr.de>; Wed, 24 Jul 2019 20:29:36 +0200 (CEST)
Received: (qmail 11718 invoked by uid 550); 24 Jul 2019 18:29:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11676 invoked from network); 24 Jul 2019 18:29:30 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3868:3870:3871:3872:3873:4184:4321:4605:5007:6119:7903:7904:8603:10004:10400:10848:11232:11658:11914:12295:12296:12297:12679:12740:12760:12895:13069:13071:13161:13229:13255:13311:13357:13439:14096:14097:14180:14659:14721:21060:21080:21324:21627:30054:30070:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:26,LUA_SUMMARY:none
X-HE-Tag: ants48_8b108300b7635
X-Filterd-Recvd-Size: 2301
Message-ID: <0d69778626901a841108ae024b8a105da679d9af.camel@perches.com>
Subject: Re: [PATCH v5] Documentation/checkpatch: Prefer strscpy/strscpy_pad
 over strcpy/strlcpy/strncpy
From: Joe Perches <joe@perches.com>
To: "Gote, Nitin R" <nitin.r.gote@intel.com>, Kees Cook
 <keescook@chromium.org>
Cc: "corbet@lwn.net" <corbet@lwn.net>, "akpm@linux-foundation.org"
	 <akpm@linux-foundation.org>, "apw@canonical.com" <apw@canonical.com>, 
	"linux-doc@vger.kernel.org"
	 <linux-doc@vger.kernel.org>, "kernel-hardening@lists.openwall.com"
	 <kernel-hardening@lists.openwall.com>
Date: Wed, 24 Jul 2019 11:29:13 -0700
In-Reply-To: <12356C813DFF6F479B608F81178A561587AE45@BGSMSX101.gar.corp.intel.com>
References: <20190717043005.19627-1-nitin.r.gote@intel.com>
	 <201907221029.B0CBED4F@keescook>
	 <28404b52d58efa0a3e85ce05ce0b210049ed6050.camel@perches.com>
	 <12356C813DFF6F479B608F81178A561587ABA9@BGSMSX101.gar.corp.intel.com>
	 <12356C813DFF6F479B608F81178A561587AE45@BGSMSX101.gar.corp.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2019-07-24 at 18:17 +0000, Gote, Nitin R wrote:
> Hi,

Hi again.

[]
> > > > > 3. Deprecate strncpy() in favor of strscpy() or strscpy_pad().

Please remember there does not exist a single actual use
of strscpy_pad in the kernel sources and no apparent real
need for it.  I don't find one anyway.

> Could you please give your opinion on below comment.
>  
> > But, if the destination buffer needs extra NUL-padding for remaining size of
> > destination, then safe replacement is strscpy_pad().  Right?  If yes, then what
> > is your opinion on below change :
> > 
> >         "strncpy" => "strscpy, strcpy_pad - for non-NUL-terminated uses,
> > strncpy() dst should be __nonstring",
> > 
> If you agree on this, then I will include this change in next patch version.

Two things:

The kernel-doc documentation uses dest not dst.
I think stracpy should be preferred over strscpy.


