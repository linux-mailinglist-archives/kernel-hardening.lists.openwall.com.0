Return-Path: <kernel-hardening-return-18077-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BF52517A906
	for <lists+kernel-hardening@lfdr.de>; Thu,  5 Mar 2020 16:39:58 +0100 (CET)
Received: (qmail 21573 invoked by uid 550); 5 Mar 2020 15:39:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 21540 invoked from network); 5 Mar 2020 15:39:52 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:966:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1540:1593:1594:1711:1714:1730:1747:1777:1792:2196:2199:2393:2559:2562:2828:2894:3138:3139:3140:3141:3142:3351:3622:3865:3867:3868:3870:3872:4250:4321:4385:5007:6119:7903:10004:10400:10848:11026:11232:11658:11914:12294:12296:12297:12555:12740:12760:12895:12986:13019:13069:13311:13357:13439:14096:14097:14659:14721:21080:21451:21627:30003:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:2,LUA_SUMMARY:none
X-HE-Tag: coach66_70fd47f5d3b57
X-Filterd-Recvd-Size: 2111
Message-ID: <31d1567c4c195f3bc5c6b610386cf0f559f9094f.camel@perches.com>
Subject: Re: [PATCH] sh: Stop printing the virtual memory layout
From: Joe Perches <joe@perches.com>
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Arvind Sankar
	 <nivedita@alum.mit.edu>, Kees Cook <keescook@chromium.org>
Cc: "Tobin C . Harding" <me@tobin.cc>, Tycho Andersen <tycho@tycho.ws>, 
 kernel-hardening@lists.openwall.com, Yoshinori Sato
 <ysato@users.sourceforge.jp>,  Rich Felker <dalias@libc.org>,
 linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 05 Mar 2020 07:38:01 -0800
In-Reply-To: <f672417e-1323-4ef2-58a1-1158c482d569@physik.fu-berlin.de>
References: <202003021038.8F0369D907@keescook>
	 <20200305151010.835954-1-nivedita@alum.mit.edu>
	 <f672417e-1323-4ef2-58a1-1158c482d569@physik.fu-berlin.de>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.34.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2020-03-05 at 16:18 +0100, John Paul Adrian Glaubitz wrote:
> On 3/5/20 4:10 PM, Arvind Sankar wrote:
> > For security, don't display the kernel's virtual memory layout.
> > 
> > Kees Cook points out:
> > "These have been entirely removed on other architectures, so let's
> > just do the same for ia32 and remove it unconditionally."
> > 
> > 071929dbdd86 ("arm64: Stop printing the virtual memory layout")
> > 1c31d4e96b8c ("ARM: 8820/1: mm: Stop printing the virtual memory layout")
> > 31833332f798 ("m68k/mm: Stop printing the virtual memory layout")
> > fd8d0ca25631 ("parisc: Hide virtual kernel memory layout")
> > adb1fe9ae2ee ("mm/page_alloc: Remove kernel address exposure in free_reserved_area()")
> Aww, why wasn't this made configurable? I found these memory map printouts
> very useful for development.

It could be changed from pr_info to pr_devel.

A #define DEBUG would have to be added to emit it.



