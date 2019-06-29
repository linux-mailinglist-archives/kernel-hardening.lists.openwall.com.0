Return-Path: <kernel-hardening-return-16327-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 04E835AC9B
	for <lists+kernel-hardening@lfdr.de>; Sat, 29 Jun 2019 18:45:51 +0200 (CEST)
Received: (qmail 1260 invoked by uid 550); 29 Jun 2019 16:45:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1219 invoked from network); 29 Jun 2019 16:45:44 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:599:800:960:968:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3874:4037:4321:5007:6742:10004:10400:10848:10967:11232:11658:11914:12043:12297:12663:12740:12760:12895:13069:13138:13231:13311:13357:13439:14096:14097:14181:14659:14721:21080:21433:21627:30034:30054:30070:30090:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.14.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: wood26_67b7f2b025644
X-Filterd-Recvd-Size: 3038
Message-ID: <c3b83ba7f9b003dd4fb9cad885461ce93165dc04.camel@perches.com>
Subject: Re: [PATCH V2] include: linux: Regularise the use of FIELD_SIZEOF
 macro
From: Joe Perches <joe@perches.com>
To: Alexey Dobriyan <adobriyan@gmail.com>, Andreas Dilger <adilger@dilger.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shyam Saini
 <shyam.saini@amarulasolutions.com>, kernel-hardening@lists.openwall.com, 
 linux-kernel@vger.kernel.org, keescook@chromium.org, 
 linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, 
 intel-gvt-dev@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, netdev@vger.kernel.org, linux-ext4
 <linux-ext4@vger.kernel.org>, devel@lists.orangefs.org, linux-mm@kvack.org,
  linux-sctp@vger.kernel.org, bpf@vger.kernel.org, kvm@vger.kernel.org, 
 mayhs11saini@gmail.com
Date: Sat, 29 Jun 2019 09:45:10 -0700
In-Reply-To: <20190629142510.GA10629@avx2>
References: <20190611193836.2772-1-shyam.saini@amarulasolutions.com>
	 <20190611134831.a60c11f4b691d14d04a87e29@linux-foundation.org>
	 <6DCAE4F8-3BEC-45F2-A733-F4D15850B7F3@dilger.ca>
	 <20190629142510.GA10629@avx2>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Sat, 2019-06-29 at 17:25 +0300, Alexey Dobriyan wrote:
> On Tue, Jun 11, 2019 at 03:00:10PM -0600, Andreas Dilger wrote:
> > On Jun 11, 2019, at 2:48 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > On Wed, 12 Jun 2019 01:08:36 +0530 Shyam Saini <shyam.saini@amarulasolutions.com> wrote:
> > I did a check, and FIELD_SIZEOF() is used about 350x, while sizeof_field()
> > is about 30x, and SIZEOF_FIELD() is only about 5x.
> > 
> > That said, I'm much more in favour of "sizeof_field()" or "sizeof_member()"
> > than FIELD_SIZEOF().  Not only does that better match "offsetof()", with
> > which it is closely related, but is also closer to the original "sizeof()".
> > 
> > Since this is a rather trivial change, it can be split into a number of
> > patches to get approval/landing via subsystem maintainers, and there is no
> > huge urgency to remove the original macros until the users are gone.  It
> > would make sense to remove SIZEOF_FIELD() and sizeof_field() quickly so
> > they don't gain more users, and the remaining FIELD_SIZEOF() users can be
> > whittled away as the patches come through the maintainer trees.
> 
> The signature should be
> 
> 	sizeof_member(T, m)
> 
> it is proper English,
> it is lowercase, so is easier to type,
> it uses standard term (member, not field),
> it blends in with standard "sizeof" operator,

yes please.

Also, a simple script conversion applied
immediately after an rc1 might be easiest
rather than individual patches.


