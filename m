Return-Path: <kernel-hardening-return-20861-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2CAAF327221
	for <lists+kernel-hardening@lfdr.de>; Sun, 28 Feb 2021 12:51:07 +0100 (CET)
Received: (qmail 23669 invoked by uid 550); 28 Feb 2021 11:51:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23634 invoked from network); 28 Feb 2021 11:50:59 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:967:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2561:2564:2682:2685:2693:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:7514:7652:7903:9025:10004:10400:10848:11232:11658:11914:12043:12048:12297:12438:12555:12740:12760:12895:13069:13255:13311:13357:13439:14181:14659:14721:14764:21080:21433:21451:21611:21627:21990:30054:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: lake55_4500ff4276ab
X-Filterd-Recvd-Size: 2254
Message-ID: <1bf09d848148311a952870113401077dfc956bbd.camel@perches.com>
Subject: Re: [PATCH 11/20] hwmon: Manual replacement of the deprecated
 strlcpy() with return values
From: Joe Perches <joe@perches.com>
To: Guenter Roeck <linux@roeck-us.net>, Romain Perier
 <romain.perier@gmail.com>,  Kees Cook <keescook@chromium.org>,
 kernel-hardening@lists.openwall.com
Cc: linux-hwmon@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 28 Feb 2021 03:50:44 -0800
In-Reply-To: <3b8dd556-8c09-9686-dec6-9d523a9762a8@roeck-us.net>
References: <20210222151231.22572-1-romain.perier@gmail.com>
	 <20210222151231.22572-12-romain.perier@gmail.com>
	 <3b8dd556-8c09-9686-dec6-9d523a9762a8@roeck-us.net>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2021-02-22 at 07:46 -0800, Guenter Roeck wrote:
> On 2/22/21 7:12 AM, Romain Perier wrote:
> > The strlcpy() reads the entire source buffer first, it is dangerous if
> > the source buffer lenght is unbounded or possibility non NULL-terminated.
> 
> length
> 
> > It can lead to linear read overflows, crashes, etc...
> > 
> Not here. This description is misleading.
> 
> > As recommended in the deprecated interfaces [1], it should be replaced
> > by strscpy.
> > 
> > This commit replaces all calls to strlcpy that handle the return values
> > by the corresponding strscpy calls with new handling of the return
> > values (as it is quite different between the two functions).
> > 
> > [1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> > 
> > Signed-off-by: Romain Perier <romain.perier@gmail.com>
> 
> This patch just adds pain to injury, as the source 'buffers' are all fixed
> strings and their length will never exceed the maximum buffer length.
> I really don't see the point of using strscpy() in this situation.

Might as well just use strcpy (I'd still prefer stracpy)

https://lore.kernel.org/lkml/24bb53c57767c1c2a8f266c305a670f7@sk2.org/T/


