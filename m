Return-Path: <kernel-hardening-return-16347-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 93CF25FDDC
	for <lists+kernel-hardening@lfdr.de>; Thu,  4 Jul 2019 22:46:46 +0200 (CEST)
Received: (qmail 22340 invoked by uid 550); 4 Jul 2019 20:46:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22305 invoked from network); 4 Jul 2019 20:46:40 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3353:3622:3653:3865:3866:3867:3868:3870:3874:4250:4321:5007:6119:6691:7903:8603:10004:10400:10848:11026:11232:11473:11658:11914:12043:12049:12297:12438:12740:12760:12895:13069:13161:13229:13311:13357:13439:14181:14659:14721:21080:21451:21627:30054:30064:30070:30083:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: space91_1b23faa223b5f
X-Filterd-Recvd-Size: 2807
Message-ID: <f6a4c2b601bb59179cb2e3b8f4d836a1c11379a3.camel@perches.com>
Subject: Re: [PATCH] checkpatch: Added warnings in favor of strscpy().
From: Joe Perches <joe@perches.com>
To: Nitin Gote <nitin.r.gote@intel.com>, akpm@linux-foundation.org
Cc: corbet@lwn.net, apw@canonical.com, keescook@chromium.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-hardening@lists.openwall.com
Date: Thu, 04 Jul 2019 13:46:25 -0700
In-Reply-To: <1562219683-15474-1-git-send-email-nitin.r.gote@intel.com>
References: <1562219683-15474-1-git-send-email-nitin.r.gote@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2019-07-04 at 11:24 +0530, Nitin Gote wrote:
> Added warnings in checkpatch.pl script to :
> 
> 1. Deprecate strcpy() in favor of strscpy().
> 2. Deprecate strlcpy() in favor of strscpy().
> 3. Deprecate strncpy() in favor of strscpy() or strscpy_pad().
> 
> Updated strncpy() section in Documentation/process/deprecated.rst
> to cover strscpy_pad() case.
> 
> Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>

OK, for whatever reason, this when into a spam folder.

> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -595,6 +595,11 @@ our %deprecated_apis = (
>  	"rcu_barrier_sched"			=> "rcu_barrier",
>  	"get_state_synchronize_sched"		=> "get_state_synchronize_rcu",
>  	"cond_synchronize_sched"		=> "cond_synchronize_rcu",
> +	"strcpy"				=> "strscpy",
> +	"strlcpy"				=> "strscpy",
> +	"strncpy"				=> "strscpy, strscpy_pad or for
> +	non-NUL-terminated strings, strncpy() can still be used, but
> +	destinations should be marked with the __nonstring",
>  );

$ git grep -w strcpy | wc -l
2239
$ git grep -w strlcpy | wc -l
1760
$ git grep -w strncpy | wc -l
839

These functions are _really_ commonly used in the kernel.

This should probably be a different %deprecated_string_api
and these should probably not be emitted at WARN level
when using command line option -f/--file but at CHECK level
so that novice script users just don't send bad patches.

Also, perhaps there could be some macro for the relatively
commonly used

	strscpy(foo, bar, sizeof(foo))
and
	strlcpy(foo, bar, sizeof(foo))

so argument 1 doesn't have to be repeated in the sizeof()

Something like:

#define stracpy(to, from)					\
({								\
	size_t size = ARRAY_SIZE(to);				\
	BUILD_BUG_ON(!__same_type(typeof(*to), char));		\
								\
	strscpy(to, from, size);				\
})


