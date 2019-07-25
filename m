Return-Path: <kernel-hardening-return-16584-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 59A6374CFB
	for <lists+kernel-hardening@lfdr.de>; Thu, 25 Jul 2019 13:24:34 +0200 (CEST)
Received: (qmail 3270 invoked by uid 550); 25 Jul 2019 11:24:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3234 invoked from network); 25 Jul 2019 11:24:26 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,306,1559545200"; 
   d="scan'208";a="160875077"
From: NitinGote <nitin.r.gote@intel.com>
To: joe@perches.com,
	keescook@chromium.org
Cc: corbet@lwn.net,
	akpm@linux-foundation.org,
	apw@canonical.com,
	linux-doc@vger.kernel.org,
	kernel-hardening@lists.openwall.com,
	Nitin Gote <nitin.r.gote@intel.com>
Subject: [PATCH v6] Documentation/checkpatch: Prefer stracpy over strcpy/strlcpy/strncpy.
Date: Thu, 25 Jul 2019 16:52:19 +0530
Message-Id: <20190725112219.6244-1-nitin.r.gote@intel.com>
X-Mailer: git-send-email 2.17.1

From: Nitin Gote <nitin.r.gote@intel.com>

Added check in checkpatch.pl to deprecate strcpy(), strlcpy() and
strncpy() in favor of stracpy().

Updated Documentation/process/deprecated.rst for stracpy().

Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>
---
 Change log:
 v5->v6
 - Used stracpy() instead of strscpy().

 v4->v5
 - Change the subject line as per review comment.
 - v5 is Reviewed-by: Kees Cook <keescook@chromium.org>

 v3->v4
 - Removed "c:func:" from deprecated.rst as per review comment.

 v2->v3
 - Avoided use of $check in implementation.
 - Incorporated trivial comments.

 v1->v2
 - For string related apis, created different %deprecated_string_api
   and these will get emitted at CHECK Level using command line option
   -f/--file to avoid bad patched from novice script users.

 Documentation/process/deprecated.rst | 10 +++++-----
 scripts/checkpatch.pl                | 24 ++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/Documentation/process/deprecated.rst b/Documentation/process/deprecated.rst
index 49e0f64a3427..709662c71a1a 100644
--- a/Documentation/process/deprecated.rst
+++ b/Documentation/process/deprecated.rst
@@ -84,7 +84,7 @@ buffer. This could result in linear overflows beyond the
 end of the buffer, leading to all kinds of misbehaviors. While
 `CONFIG_FORTIFY_SOURCE=y` and various compiler flags help reduce the
 risk of using this function, there is no good reason to add new uses of
-this function. The safe replacement is :c:func:`strscpy`.
+this function. The safe replacement is stracpy().

 strncpy() on NUL-terminated strings
 -----------------------------------
@@ -93,9 +93,9 @@ will be NUL terminated. This can lead to various linear read overflows
 and other misbehavior due to the missing termination. It also NUL-pads the
 destination buffer if the source contents are shorter than the destination
 buffer size, which may be a needless performance penalty for callers using
-only NUL-terminated strings. The safe replacement is :c:func:`strscpy`.
-(Users of :c:func:`strscpy` still needing NUL-padding will need an
-explicit :c:func:`memset` added.)
+only NUL-terminated strings. In this case, the safe replacement is
+stracpy(). If, however, the destination buffer still needs NUL-padding,
+the safe replacement is stracpy_pad().

 If a caller is using non-NUL-terminated strings, :c:func:`strncpy()` can
 still be used, but destinations should be marked with the `__nonstring
@@ -107,7 +107,7 @@ strlcpy()
 :c:func:`strlcpy` reads the entire source buffer first, possibly exceeding
 the given limit of bytes to copy. This is inefficient and can lead to
 linear read overflows if a source string is not NUL-terminated. The
-safe replacement is :c:func:`strscpy`.
+safe replacement is stracpy().

 Variable Length Arrays (VLAs)
 -----------------------------
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 342c7c781ba5..dddf5adf1aac 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -605,6 +605,20 @@ foreach my $entry (keys %deprecated_apis) {
 }
 $deprecated_apis_search = "(?:${deprecated_apis_search})";

+our %deprecated_string_apis = (
+	"strcpy"		=> "stracpy",
+	"strlcpy"		=> "stracpy",
+	"strncpy"		=> "stracpy - for non-NUL-terminated uses, strncpy dest should be __nonstring",
+);
+
+#Create a search pattern for all these strings apis to speed up a loop below
+our $deprecated_string_apis_search = "";
+foreach my $entry (keys %deprecated_string_apis) {
+        $deprecated_string_apis_search .= '|' if ($deprecated_string_apis_search ne "");
+        $deprecated_string_apis_search .= $entry;
+}
+$deprecated_string_apis_search = "(?:${deprecated_string_apis_search})";
+
 our $mode_perms_world_writable = qr{
 	S_IWUGO		|
 	S_IWOTH		|
@@ -6446,6 +6460,16 @@ sub process {
 			     "Deprecated use of '$deprecated_api', prefer '$new_api' instead\n" . $herecurr);
 		}

+# check for string deprecated apis
+		if ($line =~ /\b($deprecated_string_apis_search)\b\s*\(/) {
+			my $deprecated_string_api = $1;
+			my $new_api = $deprecated_string_apis{$deprecated_string_api};
+			my $msg_level = \&WARN;
+			$msg_level = \&CHK if ($file);
+			&{$msg_level}("DEPRECATED_API",
+				      "Deprecated use of '$deprecated_string_api', prefer '$new_api' instead\n" . $herecurr);
+		}
+
 # check for various structs that are normally const (ops, kgdb, device_tree)
 # and avoid what seem like struct definitions 'struct foo {'
 		if ($line !~ /\bconst\b/ &&
--
2.17.1

