Return-Path: <kernel-hardening-return-16569-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BE1C7728DE
	for <lists+kernel-hardening@lfdr.de>; Wed, 24 Jul 2019 09:11:20 +0200 (CEST)
Received: (qmail 10004 invoked by uid 550); 24 Jul 2019 07:11:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9972 invoked from network); 24 Jul 2019 07:11:14 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1537:1560:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:2914:3138:3139:3140:3141:3142:3622:3865:3867:3871:4321:5007:10004:10400:10848:11026:11232:11473:11658:11914:12297:12740:12760:12895:13069:13161:13229:13311:13357:13439:14659:14721:21080:21627:30054:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:26,LUA_SUMMARY:none
X-HE-Tag: sail18_25ca87690f746
X-Filterd-Recvd-Size: 1645
Message-ID: <023c0194641abe411c2338e4eed9eec876888e48.camel@perches.com>
Subject: Re: [PATCH V2 1/2] string: Add stracpy and stracpy_pad mechanisms
From: Joe Perches <joe@perches.com>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Linus Torvalds
	 <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, Stephen Kitt <steve@sk2.org>, Kees
 Cook <keescook@chromium.org>, Nitin Gote <nitin.r.gote@intel.com>,
 jannh@google.com,  kernel-hardening@lists.openwall.com, Andrew Morton
 <akpm@linux-foundation.org>
Date: Wed, 24 Jul 2019 00:10:58 -0700
In-Reply-To: <dab1b433-93c0-09ab-cceb-3db91b6ef353@rasmusvillemoes.dk>
References: <cover.1563889130.git.joe@perches.com>
	 <ed4611a4a96057bf8076856560bfbf9b5e95d390.1563889130.git.joe@perches.com>
	 <ce1320d8-60df-7c54-2348-6aabac63c24d@rasmusvillemoes.dk>
	 <c9ef2b56eaf36c8e5449b751ab6e5971b6b34311.camel@perches.com>
	 <dab1b433-93c0-09ab-cceb-3db91b6ef353@rasmusvillemoes.dk>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Wed, 2019-07-24 at 08:53 +0200, Rasmus Villemoes wrote:
> BUILD_BUG_ON(!__same_type())
> strscpy(dst, src, ARRAY_SIZE(dst))

Doing this without the temporary is less legible to read
the compiler error when someone improperly does:

	char *foo;
	char *bar;

	stracpy(foo, bar);


