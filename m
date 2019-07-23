Return-Path: <kernel-hardening-return-16541-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 49CF070E40
	for <lists+kernel-hardening@lfdr.de>; Tue, 23 Jul 2019 02:38:45 +0200 (CEST)
Received: (qmail 23670 invoked by uid 550); 23 Jul 2019 00:38:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22513 invoked from network); 23 Jul 2019 00:38:35 -0000
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1542:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2915:3138:3139:3140:3141:3142:3355:3865:3866:3867:3868:3871:3874:4321:5007:6261:7875:8603:10004:10848:11026:11473:11658:11914:12043:12291:12296:12297:12555:12683:12895:13141:13161:13229:13230:14181:14394:14721:21080:21451:21627:30012:30034:30054:30069:30079:30090,0,RBL:23.242.196.136:@perches.com:.lbl8.mailshell.net-62.8.0.180 64.201.201.201,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:neutral,Custom_rules:0:0:0,LFtime:17,LUA_SUMMARY:none
X-HE-Tag: wheel67_2bd70514adf25
X-Filterd-Recvd-Size: 3459
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
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] string: Add stracpy and stracpy_pad mechanisms
Date: Mon, 22 Jul 2019 17:38:15 -0700
Message-Id: <7ab8957eaf9b0931a59eff6e2bd8c5169f2f6c41.1563841972.git.joe@perches.com>
X-Mailer: git-send-email 2.15.0
In-Reply-To: <cover.1563841972.git.joe@perches.com>
References: <cover.1563841972.git.joe@perches.com>

Several uses of strlcpy and strscpy have had defects because the
last argument of each function is misused or typoed.

Add macro mechanisms to avoid this defect.

stracpy (copy a string to a string array) must have a string
array as the first argument (to) and uses sizeof(to) as the
size.

These mechanisms verify that the to argument is an array of
char or other compatible types like u8 or unsigned char.

A BUILD_BUG is emitted when the type of to is not compatible.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/string.h | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/include/linux/string.h b/include/linux/string.h
index 4deb11f7976b..f80b0973f0e5 100644
--- a/include/linux/string.h
+++ b/include/linux/string.h
@@ -35,6 +35,47 @@ ssize_t strscpy(char *, const char *, size_t);
 /* Wraps calls to strscpy()/memset(), no arch specific code required */
 ssize_t strscpy_pad(char *dest, const char *src, size_t count);
 
+/**
+ * stracpy - Copy a C-string into an array of char
+ * @to: Where to copy the string, must be an array of char and not a pointer
+ * @from: String to copy, may be a pointer or const char array
+ *
+ * Helper for strscpy.
+ * Copies a maximum of sizeof(@to) bytes of @from with %NUL termination.
+ *
+ * Returns:
+ * * The number of characters copied (not including the trailing %NUL)
+ * * -E2BIG if @to is a zero size array.
+ */
+#define stracpy(to, from)					\
+({								\
+	size_t size = ARRAY_SIZE(to);				\
+	BUILD_BUG_ON(!__same_type(typeof(*to), char));		\
+								\
+	strscpy(to, from, size);				\
+})
+
+/**
+ * stracpy_pad - Copy a C-string into an array of char with %NUL padding
+ * @to: Where to copy the string, must be an array of char and not a pointer
+ * @from: String to copy, may be a pointer or const char array
+ *
+ * Helper for strscpy_pad.
+ * Copies a maximum of sizeof(@to) bytes of @from with %NUL termination
+ * and zero-pads the remaining size of @to
+ *
+ * Returns:
+ * * The number of characters copied (not including the trailing %NUL)
+ * * -E2BIG if @to is a zero size array.
+ */
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
-- 
2.15.0

