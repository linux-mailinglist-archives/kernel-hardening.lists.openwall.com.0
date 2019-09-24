Return-Path: <kernel-hardening-return-16925-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 572E2BC676
	for <lists+kernel-hardening@lfdr.de>; Tue, 24 Sep 2019 13:15:26 +0200 (CEST)
Received: (qmail 11295 invoked by uid 550); 24 Sep 2019 11:13:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 11775 invoked from network); 24 Sep 2019 11:05:27 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,543,1559545200"; 
   d="scan'208";a="190989266"
From: Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
To: pankaj.bharadiya@gmail.com,
	andriy.shevchenko@linux.intel.com,
	kernel-hardening@lists.openwall.com,
	keescook@chromium.org,
	akpm@linux-foundation.org,
	mayhs11saini@gmail.com,
	linux-kernel@vger.kernel.org
Cc: pankaj.laxminarayan.bharadiya@intel.com
Subject: [PATCH 5/5] stddef.h: Remove sizeof_field macro
Date: Tue, 24 Sep 2019 16:28:39 +0530
Message-Id: <20190924105839.110713-6-pankaj.laxminarayan.bharadiya@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190924105839.110713-1-pankaj.laxminarayan.bharadiya@intel.com>
References: <20190924105839.110713-1-pankaj.laxminarayan.bharadiya@intel.com>

Now we have sizeof_member macro to find the size of a member of a
struct.

sizeof_field  macro is not getting used any more hence remove it.
Also modify the offsetofend macro to get rid of it.

Signed-off-by: Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
---
 include/linux/stddef.h | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/include/linux/stddef.h b/include/linux/stddef.h
index 998a4ba28eba..2181719fd907 100644
--- a/include/linux/stddef.h
+++ b/include/linux/stddef.h
@@ -19,14 +19,6 @@ enum {
 #define offsetof(TYPE, MEMBER)	((size_t)&((TYPE *)0)->MEMBER)
 #endif
 
-/**
- * sizeof_field(TYPE, MEMBER)
- *
- * @TYPE: The structure containing the field of interest
- * @MEMBER: The field to return the size of
- */
-#define sizeof_field(TYPE, MEMBER) sizeof((((TYPE *)0)->MEMBER))
-
 /**
  * offsetofend(TYPE, MEMBER)
  *
@@ -34,6 +26,6 @@ enum {
  * @MEMBER: The member within the structure to get the end offset of
  */
 #define offsetofend(TYPE, MEMBER) \
-	(offsetof(TYPE, MEMBER)	+ sizeof_field(TYPE, MEMBER))
+	(offsetof(TYPE, MEMBER)	+ sizeof(((TYPE *)0)->MEMBER))
 
 #endif
-- 
2.17.1

