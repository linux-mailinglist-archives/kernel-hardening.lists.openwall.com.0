Return-Path: <kernel-hardening-return-16398-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A08E463038
	for <lists+kernel-hardening@lfdr.de>; Tue,  9 Jul 2019 07:58:18 +0200 (CEST)
Received: (qmail 16311 invoked by uid 550); 9 Jul 2019 05:58:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 16273 invoked from network); 9 Jul 2019 05:58:12 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:599:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:1801:2197:2198:2199:2200:2393:2559:2562:2693:2828:2895:3138:3139:3140:3141:3142:3353:3622:3653:3865:3866:3867:3868:3870:3871:3873:3874:4321:4605:5007:6119:7576:7903:8957:10004:10400:10848:11026:11232:11233:11658:11914:12043:12297:12438:12740:12760:12895:13439:14181:14659:14721:21080:21221:21451:21627:30012:30054:30064:30070:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: month28_7fc9c36087e4a
X-Filterd-Recvd-Size: 3399
Message-ID: <5e2fb063f50b0d0d8caac5742117488245c4b052.camel@perches.com>
Subject: Re: [PATCH v2] Added warnings in checkpatch.pl script to :
From: Joe Perches <joe@perches.com>
To: NitinGote <nitin.r.gote@intel.com>, akpm@linux-foundation.org
Cc: corbet@lwn.net, apw@canonical.com, keescook@chromium.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-hardening@lists.openwall.com
Date: Mon, 08 Jul 2019 22:57:56 -0700
In-Reply-To: <20190709054055.21984-1-nitin.r.gote@intel.com>
References: <20190709054055.21984-1-nitin.r.gote@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Tue, 2019-07-09 at 11:10 +0530, NitinGote wrote:
> From: Nitin Gote <nitin.r.gote@intel.com>
> 
> 1. Deprecate strcpy() in favor of strscpy().
> 2. Deprecate strlcpy() in favor of strscpy().
> 3. Deprecate strncpy() in favor of strscpy() or strscpy_pad().
> 
> Updated strncpy() section in Documentation/process/deprecated.rst
> to cover strscpy_pad() case.
> 
> Acked-by: Kees Cook <keescook@chromium.org>

Kees, I think the concept is fine, but perhaps your
acked-by here isn't great.  There are a few clear
defects in the checkpatch code that you also might
have overlooked.

>  Change log:
>  v1->v2
>  - For string related apis, created different %deprecated_string_api
>    and these will get emitted at CHECK Level using command line option
>    -f/--file to avoid bad patched from novice script users.
> 

[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl

[]
> @@ -605,6 +605,21 @@ foreach my $entry (keys %deprecated_apis) {
>  }
>  $deprecated_apis_search = "(?:${deprecated_apis_search})";
> 
> +our %deprecated_string_apis = (
> +        "strcpy"                                => "strscpy",
> +        "strlcpy"                               => "strscpy",
> +        "strncpy"                               => "strscpy, strscpy_pad or for non-NUL-terminated strings,
> +         strncpy() can still be used, but destinations should be marked with the __nonstring",

This last strncpy line should not be on multiple lines.
checkpatch output is single line.

[]

> @@ -6446,6 +6461,16 @@ sub process {
>  			     "Deprecated use of '$deprecated_api', prefer '$new_api' instead\n" . $herecurr);
>  		}
> 
> +# check for string deprecated apis
> +                if ($line =~ /\b($deprecated_string_apis_search)\b\s*\(/) {
> +                        my $deprecated_string_api = $1;
> +                        my $new_api = $deprecated_string_apis{$deprecated_string_api};
> +			$check = 1;
> +                        CHK("DEPRECATED_API",
> +                             "Deprecated use of '$deprecated_string_api', prefer '$new_api' instead\n" . $herecurr);
> +			$check = 0;

nack.

Please use consistent tab indentation and no,
do not set and unset $check.

Please use the same style as the rest of the script
when emitting at different levels for -f uses

			my $msg_level = \&WARN;
			$msg_level = \&CHK if ($file);
			&{$msg_level}("DEPRECATED_API", etc...


