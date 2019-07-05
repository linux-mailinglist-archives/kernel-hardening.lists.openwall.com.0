Return-Path: <kernel-hardening-return-16348-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 644B75FEFC
	for <lists+kernel-hardening@lfdr.de>; Fri,  5 Jul 2019 02:16:20 +0200 (CEST)
Received: (qmail 12048 invoked by uid 550); 5 Jul 2019 00:16:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 12016 invoked from network); 5 Jul 2019 00:16:12 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:982:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3870:4321:5007:6119:6120:8603:10004:10400:10471:10848:11026:11232:11473:11658:11914:12043:12297:12555:12740:12760:12895:13069:13141:13230:13255:13311:13357:13439:14181:14659:14721:21080:21451:21627:30012:30054:30091,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:24,LUA_SUMMARY:none
X-HE-Tag: lace17_6e747616f8753
X-Filterd-Recvd-Size: 2600
Message-ID: <d1524130f91d7cfd61bc736623409693d2895f57.camel@perches.com>
Subject: [RFC PATCH] string.h: Add stracpy/stracpy_pad (was: Re: [PATCH]
 checkpatch: Added warnings in favor of strscpy().)
From: Joe Perches <joe@perches.com>
To: Nitin Gote <nitin.r.gote@intel.com>, akpm@linux-foundation.org
Cc: corbet@lwn.net, apw@canonical.com, keescook@chromium.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kernel-hardening@lists.openwall.com
Date: Thu, 04 Jul 2019 17:15:57 -0700
In-Reply-To: <f6a4c2b601bb59179cb2e3b8f4d836a1c11379a3.camel@perches.com>
References: <1562219683-15474-1-git-send-email-nitin.r.gote@intel.com>
	 <f6a4c2b601bb59179cb2e3b8f4d836a1c11379a3.camel@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.5-0ubuntu0.18.10.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Thu, 2019-07-04 at 13:46 -0700, Joe Perches wrote:
> On Thu, 2019-07-04 at 11:24 +0530, Nitin Gote wrote:
> > Added warnings in checkpatch.pl script to :
> > 
> > 1. Deprecate strcpy() in favor of strscpy().
> > 2. Deprecate strlcpy() in favor of strscpy().
> > 3. Deprecate strncpy() in favor of strscpy() or strscpy_pad().
> > 
> > Updated strncpy() section in Documentation/process/deprecated.rst
> > to cover strscpy_pad() case.

[]

I sent a patch series for some strscpy/strlcpy misuses.

How about adding a macro helper to avoid the misuses like:
---
 include/linux/string.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index 4deb11f7976b..ef01bd6f19df 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -35,6 +35,22 @@ ssize_t strscpy(char *, const char *, size_t);
 /* Wraps calls to strscpy()/memset(), no arch specific code required */
 ssize_t strscpy_pad(char *dest, const char *src, size_t count);
 
+#define stracpy(to, from)					\
+({								\
+	size_t size = ARRAY_SIZE(to);				\
+	BUILD_BUG_ON(!__same_type(typeof(*to), char));		\
+								\
+	strscpy(to, from, size);				\
+})
+
+#define stracpy_pad(to, from)					\
+({								\
+	size_t size = ARRAY_SIZE(to);				\
+	BUILD_BUG_ON(!__same_type(typeof(*to), char));		\
+								\
+	strscpy_pad(to, from, size);				\
+})
+
 #ifndef __HAVE_ARCH_STRCAT
 extern char * strcat(char *, const char *);
 #endif


