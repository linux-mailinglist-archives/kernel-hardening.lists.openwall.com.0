Return-Path: <kernel-hardening-return-16533-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2ED84708B8
	for <lists+kernel-hardening@lfdr.de>; Mon, 22 Jul 2019 20:35:54 +0200 (CEST)
Received: (qmail 22024 invoked by uid 550); 22 Jul 2019 18:35:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 21980 invoked from network); 22 Jul 2019 18:35:48 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:599:973:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3870:3872:4321:5007:6119:6120:7903:8603:10004:10400:10471:10848:11026:11232:11473:11658:11914:12043:12297:12740:12760:12895:13069:13255:13311:13357:13439:14659:14721:21080:21451:21627:30054:30090:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:26,LUA_SUMMARY:none
X-HE-Tag: sort55_4dc629887d118
X-Filterd-Recvd-Size: 2243
Message-ID: <207e201cb7a36e38f032bcb66e79e2d4b9b63c7b.camel@perches.com>
Subject: Re: [RFC PATCH] string.h: Add stracpy/stracpy_pad (was: Re: [PATCH]
 checkpatch: Added warnings in favor of strscpy().)
From: Joe Perches <joe@perches.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, Nitin Gote <nitin.r.gote@intel.com>, 
	akpm@linux-foundation.org, corbet@lwn.net, apw@canonical.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-hardening@lists.openwall.com, Rasmus Villemoes
	 <rasmus.villemoes@prevas.dk>
Date: Mon, 22 Jul 2019 11:35:33 -0700
In-Reply-To: <20190722182703.GE363@bombadil.infradead.org>
References: <1562219683-15474-1-git-send-email-nitin.r.gote@intel.com>
	 <f6a4c2b601bb59179cb2e3b8f4d836a1c11379a3.camel@perches.com>
	 <d1524130f91d7cfd61bc736623409693d2895f57.camel@perches.com>
	 <201907221031.8B87A9DE@keescook>
	 <b9bb5550b264d4b29b2b20f7ff8b1b40d20def6a.camel@perches.com>
	 <2c959c56c23d0052e5c35ecfa2f6051b17fb2798.camel@perches.com>
	 <20190722182703.GE363@bombadil.infradead.org>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2019-07-22 at 11:27 -0700, Matthew Wilcox wrote:
> On Mon, Jul 22, 2019 at 10:58:15AM -0700, Joe Perches wrote:
> > On Mon, 2019-07-22 at 10:43 -0700, Joe Perches wrote:
> > > On Mon, 2019-07-22 at 10:33 -0700, Kees Cook wrote:
> > > > On Thu, Jul 04, 2019 at 05:15:57PM -0700, Joe Perches wrote:
> > > > > On Thu, 2019-07-04 at 13:46 -0700, Joe Perches wrote:
[]
> > > > > +#define stracpy(to, from)					\
> > > > > +({								\
> > > > > +	size_t size = ARRAY_SIZE(to);				\
> > > > > +	BUILD_BUG_ON(!__same_type(typeof(*to), char));		\
> > > > > +								\
> > > > > +	strscpy(to, from, size);				\
> > > > > +})
> 
> Where does the 'a' in 'stracpy' come from?

No place in particular.

I used it because dst has to be an 'a'rray rather
than a pointer.


