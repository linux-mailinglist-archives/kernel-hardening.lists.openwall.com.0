Return-Path: <kernel-hardening-return-16912-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 76C0BBC648
	for <lists+kernel-hardening@lfdr.de>; Tue, 24 Sep 2019 13:10:06 +0200 (CEST)
Received: (qmail 20358 invoked by uid 550); 24 Sep 2019 11:09:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 7593 invoked from network); 24 Sep 2019 08:21:15 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,543,1559545200"; 
   d="scan'208";a="203330039"
From: Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
To: kernel-hardening@lists.openwall.com,
	keescook@chromium.org,
	akpm@linux-foundation.org,
	mayhs11saini@gmail.com
Cc: pankaj.laxminarayan.bharadiya@intel.com
Subject: [PATCH 4/5] linux/kernel.h: Remove FIELD_SIZEOF macro
Date: Tue, 24 Sep 2019 13:44:38 +0530
Message-Id: <20190924081439.15219-5-pankaj.laxminarayan.bharadiya@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190924081439.15219-1-pankaj.laxminarayan.bharadiya@intel.com>
References: <20190924081439.15219-1-pankaj.laxminarayan.bharadiya@intel.com>

Now we have sizeof_member macro to find the size of a member of a struct.

FIELD_SIZEOF macro is not getting used any more hence remove it.

Signed-off-by: Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
---
 include/linux/kernel.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 0b80d8bb3978..064497792c70 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -88,15 +88,6 @@
  */
 #define sizeof_member(T, m) (sizeof(((T *)0)->m))
 
-/**
- * FIELD_SIZEOF - get the size of a struct's field
- * @t: the target struct
- * @f: the target struct's field
- * Return: the size of @f in the struct definition without having a
- * declared instance of @t.
- */
-#define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
-
 #define typeof_member(T, m)	typeof(((T*)0)->m)
 
 #define DIV_ROUND_UP __KERNEL_DIV_ROUND_UP
-- 
2.17.1

