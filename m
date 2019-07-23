Return-Path: <kernel-hardening-return-16554-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 26DF6719C2
	for <lists+kernel-hardening@lfdr.de>; Tue, 23 Jul 2019 15:52:02 +0200 (CEST)
Received: (qmail 13323 invoked by uid 550); 23 Jul 2019 13:51:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 12262 invoked from network); 23 Jul 2019 13:51:53 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:988:989:1260:1345:1437:1534:1538:1561:1711:1714:1730:1747:1777:1792:1801:2393:2559:2562:3138:3139:3140:3141:3142:3867:3868:4605:5007:6119:6261:10004:10848:11658:11914:12043:12291:12296:12297:12679:12683:12895:13069:13311:13357:14110:14181:14384:14394:14581:14721:21080:21451:21627:30054:30079,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:26,LUA_SUMMARY:none
X-HE-Tag: tiger29_82ea9ecb2fe20
X-Filterd-Recvd-Size: 1297
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>,
	Stephen Kitt <steve@sk2.org>,
	Kees Cook <keescook@chromium.org>,
	Nitin Gote <nitin.r.gote@intel.com>,
	jannh@google.com,
	kernel-hardening@lists.openwall.com,
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org
Subject: [PATCH V2 0/2] string: Add stracpy and stracpy_pad
Date: Tue, 23 Jul 2019 06:51:35 -0700
Message-Id: <cover.1563889130.git.joe@perches.com>
X-Mailer: git-send-email 2.15.0

Add more string copy mechanisms to help avoid defects

Joe Perches (2):
  string: Add stracpy and stracpy_pad mechanisms
  kernel-doc: core-api: Include string.h into core-api

 Documentation/core-api/kernel-api.rst |  3 +++
 include/linux/string.h                | 50 +++++++++++++++++++++++++++++++++--
 lib/string.c                          | 10 ++++---
 3 files changed, 57 insertions(+), 6 deletions(-)

-- 
2.15.0

