Return-Path: <kernel-hardening-return-16570-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 00BF372DD4
	for <lists+kernel-hardening@lfdr.de>; Wed, 24 Jul 2019 13:40:52 +0200 (CEST)
Received: (qmail 24061 invoked by uid 550); 24 Jul 2019 11:40:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24027 invoked from network); 24 Jul 2019 11:40:46 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:2915:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3874:4321:4362:5007:8603:10004:10400:10848:11026:11232:11473:11658:11914:12043:12296:12297:12740:12760:12895:13069:13311:13357:13439:14181:14659:14721:21080:21627:30054:30069:30079:30090:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:29,LUA_SUMMARY:none
X-HE-Tag: shape98_3ee351f3c5a54
X-Filterd-Recvd-Size: 2144
Message-ID: <b88ca439f5b2d578888a1cd39b30acb8121d422c.camel@perches.com>
Subject: Re: [PATCH 1/2] string: Add stracpy and stracpy_pad mechanisms
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
 linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Stephen
 Kitt <steve@sk2.org>, Nitin Gote <nitin.r.gote@intel.com>,
 jannh@google.com,  kernel-hardening@lists.openwall.com, Rasmus Villemoes
 <rasmus.villemoes@prevas.dk>, Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 24 Jul 2019 04:40:30 -0700
In-Reply-To: <201907231435.FABB1CC@keescook>
References: <cover.1563841972.git.joe@perches.com>
	 <7ab8957eaf9b0931a59eff6e2bd8c5169f2f6c41.1563841972.git.joe@perches.com>
	 <201907231435.FABB1CC@keescook>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2019-07-23 at 14:36 -0700, Kees Cook wrote:
> On Mon, Jul 22, 2019 at 05:38:15PM -0700, Joe Perches wrote:
> > Several uses of strlcpy and strscpy have had defects because the
> > last argument of each function is misused or typoed.
> > 
> > Add macro mechanisms to avoid this defect.
> > 
> > stracpy (copy a string to a string array) must have a string
> > array as the first argument (to) and uses sizeof(to) as the
> > size.
> > 
> > These mechanisms verify that the to argument is an array of
> > char or other compatible types like u8 or unsigned char.
> > 
> > A BUILD_BUG is emitted when the type of to is not compatible.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> I think Rasmus's suggestion would make sense:
> 
> 	BUILD_BUG_ON(!__same_type(typeof(to), char[]))

I think Rasmus had an excellent suggestion.
I liked it and submitted it as V2.

> Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks.


