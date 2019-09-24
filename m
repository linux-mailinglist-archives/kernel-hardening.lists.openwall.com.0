Return-Path: <kernel-hardening-return-16909-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A6DF2BC643
	for <lists+kernel-hardening@lfdr.de>; Tue, 24 Sep 2019 13:09:29 +0200 (CEST)
Received: (qmail 17889 invoked by uid 550); 24 Sep 2019 11:09:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 7462 invoked from network); 24 Sep 2019 08:21:11 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,543,1559545200"; 
   d="scan'208";a="203329988"
From: Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
To: kernel-hardening@lists.openwall.com,
	keescook@chromium.org,
	akpm@linux-foundation.org,
	mayhs11saini@gmail.com
Cc: pankaj.laxminarayan.bharadiya@intel.com
Subject: [PATCH 1/5] linux/kernel.h: Add sizeof_member macro
Date: Tue, 24 Sep 2019 13:44:35 +0530
Message-Id: <20190924081439.15219-2-pankaj.laxminarayan.bharadiya@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190924081439.15219-1-pankaj.laxminarayan.bharadiya@intel.com>
References: <20190924081439.15219-1-pankaj.laxminarayan.bharadiya@intel.com>

At present we have 3 different macros to calculate the size of a
member of a struct:
  - SIZEOF_FIELD
  - FIELD_SIZEOF
  - sizeof_field

To bring uniformity in entire kernel source tree let's add
sizeof_member macro.

Replace all occurrences of above 3 macro's with sizeof_member in
future patches.

Signed-off-by: Pankaj Bharadiya <pankaj.laxminarayan.bharadiya@intel.com>
---
 include/linux/kernel.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 4fa360a13c1e..0b80d8bb3978 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -79,6 +79,15 @@
  */
 #define round_down(x, y) ((x) & ~__round_mask(x, y))
 
+/**
+ * sizeof_member - get the size of a struct's member
+ * @T: the target struct
+ * @m: the target struct's member
+ * Return: the size of @m in the struct definition without having a
+ * declared instance of @T.
+ */
+#define sizeof_member(T, m) (sizeof(((T *)0)->m))
+
 /**
  * FIELD_SIZEOF - get the size of a struct's field
  * @t: the target struct
-- 
2.17.1

