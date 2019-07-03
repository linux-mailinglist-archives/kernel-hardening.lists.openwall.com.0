Return-Path: <kernel-hardening-return-16340-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id AA6835DDFE
	for <lists+kernel-hardening@lfdr.de>; Wed,  3 Jul 2019 08:21:01 +0200 (CEST)
Received: (qmail 23602 invoked by uid 550); 3 Jul 2019 06:20:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23561 invoked from network); 3 Jul 2019 06:20:54 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,446,1557212400"; 
   d="scan'208";a="172025329"
From: Nitin Gote <nitin.r.gote@intel.com>
To: keescook@chromium.org
Cc: jannh@google.com,
	kernel-hardening@lists.openwall.com,
	Nitin Gote <nitin.r.gote@intel.com>
Subject: [PATCH v2] checkpatch: Added warnings in favor of strscpy().
Date: Wed,  3 Jul 2019 11:50:14 +0530
Message-Id: <1562134814-12966-1-git-send-email-nitin.r.gote@intel.com>
X-Mailer: git-send-email 2.7.4

Added warnings in checkpatch.pl script to :

1. Deprecate strcpy() in favor of strscpy().
2. Deprecate strlcpy() in favor of strscpy().
3. Deprecate strncpy() in favor of strscpy() or strscpy_pad().

Updated strncpy() section in Documentation/process/deprecated.rst
to cover strscpy_pad() case.

Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>
---
 Documentation/process/deprecated.rst | 6 +++---
 scripts/checkpatch.pl                | 4 ++++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/Documentation/process/deprecated.rst b/Documentation/process/deprecated.rst
index 49e0f64..f564de3 100644
--- a/Documentation/process/deprecated.rst
+++ b/Documentation/process/deprecated.rst
@@ -93,9 +93,9 @@ will be NUL terminated. This can lead to various linear read overflows
 and other misbehavior due to the missing termination. It also NUL-pads the
 destination buffer if the source contents are shorter than the destination
 buffer size, which may be a needless performance penalty for callers using
-only NUL-terminated strings. The safe replacement is :c:func:`strscpy`.
-(Users of :c:func:`strscpy` still needing NUL-padding will need an
-explicit :c:func:`memset` added.)
+only NUL-terminated strings. In this case, the safe replacement is
+:c:func:`strscpy`. If, however, the destination buffer still needs
+NUL-padding, the safe replacement is :c:func:`strscpy_pad`.

 If a caller is using non-NUL-terminated strings, :c:func:`strncpy()` can
 still be used, but destinations should be marked with the `__nonstring
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 342c7c7..2ce2340 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -595,6 +595,10 @@ our %deprecated_apis = (
	"rcu_barrier_sched"			=> "rcu_barrier",
	"get_state_synchronize_sched"		=> "get_state_synchronize_rcu",
	"cond_synchronize_sched"		=> "cond_synchronize_rcu",
+	"strcpy"				=> "strscpy",
+	"strlcpy"				=> "strscpy",
+	"strncpy"				=> "strscpy, strscpy_pad or for non-NUL-terminated strings,
+	 strncpy() can still be used, but destinations should be marked with the __nonstring",
 );

 #Create a search pattern for all these strings to speed up a loop below
--
2.7.4
