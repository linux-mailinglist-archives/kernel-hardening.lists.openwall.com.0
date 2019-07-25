Return-Path: <kernel-hardening-return-16586-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id EBD1B757BB
	for <lists+kernel-hardening@lfdr.de>; Thu, 25 Jul 2019 21:20:00 +0200 (CEST)
Received: (qmail 11617 invoked by uid 550); 25 Jul 2019 19:19:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11561 invoked from network); 25 Jul 2019 19:19:54 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3653:3865:3866:3867:3868:3870:3871:3874:4321:5007:7576:7903:8957:10004:10400:10848:11026:11232:11658:11914:12043:12297:12438:12679:12740:12760:12895:13069:13255:13311:13357:13439:14181:14659:14721:21080:21451:21627:30054:30064:30070:30090:30091,0,RBL:error,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:26,LUA_SUMMARY:none
X-HE-Tag: space70_377920f55ef61
X-Filterd-Recvd-Size: 2036
Message-ID: <b23889e2ba458736b3cf25e0c17a4598451e78d7.camel@perches.com>
Subject: Re: [PATCH v6] Documentation/checkpatch: Prefer stracpy over
 strcpy/strlcpy/strncpy.
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>, NitinGote <nitin.r.gote@intel.com>
Cc: corbet@lwn.net, akpm@linux-foundation.org, apw@canonical.com, 
	linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
Date: Thu, 25 Jul 2019 12:19:39 -0700
In-Reply-To: <201907251149.B7FD8631@keescook>
References: <20190725112219.6244-1-nitin.r.gote@intel.com>
	 <201907251149.B7FD8631@keescook>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2019-07-25 at 11:50 -0700, Kees Cook wrote:
> On Thu, Jul 25, 2019 at 04:52:19PM +0530, NitinGote wrote:
> > From: Nitin Gote <nitin.r.gote@intel.com>
> > 
> > Added check in checkpatch.pl to deprecate strcpy(), strlcpy() and
> > strncpy() in favor of stracpy().
> 
> stracpy() is preferred when the destination is a char array (rather than
> a string pointer), so that likely needs to be clarified.
[]
> > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> > @@ -605,6 +605,20 @@ foreach my $entry (keys %deprecated_apis) {
> >  }
> >  $deprecated_apis_search = "(?:${deprecated_apis_search})";
> > 
> > +our %deprecated_string_apis = (
> > +	"strcpy"		=> "stracpy",
> > +	"strlcpy"		=> "stracpy",
> > +	"strncpy"		=> "stracpy - for non-NUL-terminated uses, strncpy dest should be __nonstring",
> > +);

Maybe:

our %deprecated_string_apis = (
	"strcpy"		=> "stracpy or strscpy",
	"strlcpy"		=> "stracpy or strscpy",
	"strncpy"		=> "stracpy or strscpy - for non-NUL-terminated uses, strncpy dest should be __nonstring",
);

