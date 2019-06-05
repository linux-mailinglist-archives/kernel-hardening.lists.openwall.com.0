Return-Path: <kernel-hardening-return-16059-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 77BBE35632
	for <lists+kernel-hardening@lfdr.de>; Wed,  5 Jun 2019 07:25:53 +0200 (CEST)
Received: (qmail 17766 invoked by uid 550); 5 Jun 2019 05:25:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17727 invoked from network); 5 Jun 2019 05:25:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=9a8hKqe93DInff5ZLnJt99v7R5ylnef5GPSafD7tn0w=;
        b=T97XQvErAV5YR0vEyOAIbTyxqJCiQjCac342A9iuSijGEDjSlvqaU/Lrb+zFRoo/P4
         FCctN63E9iIlQT/mWrcniSm9A7Xo72FTJUhxAiHxdQ5Ie3ySDQx38Yh3X8OBG0T6ijaq
         ajQFu83NaqZQx8Nbr3siIhbrk4Bv7E8n34dn0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=9a8hKqe93DInff5ZLnJt99v7R5ylnef5GPSafD7tn0w=;
        b=niObSciW3ZjWGkc9vN8jP+ChdjNvlFAEt83B4qMdSaS0ABxrqPysxlljiRf2OhODtJ
         Pzm0/criLNev9yWWzaqMpJ/F8Wz+b8IySpgTSY7Pu1oHrWd+39SVgG/rCt4XvP6+mjA7
         ux/hnlngwpHj73difHDWmvkJ6CQ1xNRNg4EhGkZQAa1BY0rtYf5IhfNn0AaIzudny8OJ
         1sg/6idrVNeUEOdf/uh5UpuGXl+KztcZZjY6KolVKnsyJrAmIzT8q2HjSV7z40c5w90H
         7W+uMWiUoMDIXdF+ITajVyhzj6b7LIv/DrRAJSoN8/dIIm0xR6sFOEJZ9WV2DZj6JvZz
         fMVQ==
X-Gm-Message-State: APjAAAXcgGYlWtXBASlN8od77X+ZGtcYpqDOa315/R7FyaHTJxdHExJo
	kvxdJ5TqPit2oNjGq+meYplZPg==
X-Google-Smtp-Source: APXvYqxGFosd7c5gW8eXl6gC1MPgOZJztjP50l1ighdi65fgtlv2L6pfV2Iuxc2LF2giYGCvBzI+mw==
X-Received: by 2002:a65:448a:: with SMTP id l10mr1921268pgq.53.1559712333660;
        Tue, 04 Jun 2019 22:25:33 -0700 (PDT)
Date: Tue, 4 Jun 2019 22:25:31 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Alexander Potapenko <glider@google.com>,
	kernel-hardening@lists.openwall.com
Subject: [PATCH] lib/test_stackinit: Handle Clang auto-initialization pattern
Message-ID: <201906042224.42A2CCB2BE@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

While the gcc plugin for automatic stack variable initialization (i.e.
CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL) performs initialization with
0x00 bytes, the Clang automatic stack variable initialization (i.e.
CONFIG_INIT_STACK_ALL) uses various type-specific patterns that are
typically 0xAA. Therefore the stackinit selftest has been fixed to check
that bytes are no longer the test fill pattern of 0xFF (instead of looking
for bytes that have become 0x00). This retains the test coverage for the
0x00 pattern of the gcc plugin while adding coverage for the mostly 0xAA
pattern of Clang.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 lib/test_stackinit.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/lib/test_stackinit.c b/lib/test_stackinit.c
index e97dc54b4fdf..2d7d257a430e 100644
--- a/lib/test_stackinit.c
+++ b/lib/test_stackinit.c
@@ -12,7 +12,7 @@
 
 /* Exfiltration buffer. */
 #define MAX_VAR_SIZE	128
-static char check_buf[MAX_VAR_SIZE];
+static u8 check_buf[MAX_VAR_SIZE];
 
 /* Character array to trigger stack protector in all functions. */
 #define VAR_BUFFER	 32
@@ -106,9 +106,18 @@ static noinline __init int test_ ## name (void)			\
 								\
 	/* Fill clone type with zero for per-field init. */	\
 	memset(&zero, 0x00, sizeof(zero));			\
+	/* Clear entire check buffer for 0xFF overlap test. */	\
+	memset(check_buf, 0x00, sizeof(check_buf));		\
 	/* Fill stack with 0xFF. */				\
 	ignored = leaf_ ##name((unsigned long)&ignored, 1,	\
 				FETCH_ARG_ ## which(zero));	\
+	/* Verify all bytes overwritten with 0xFF. */		\
+	for (sum = 0, i = 0; i < target_size; i++)		\
+		sum += (check_buf[i] != 0xFF);			\
+	if (sum) {						\
+		pr_err(#name ": leaf fill was not 0xFF!?\n");	\
+		return 1;					\
+	}							\
 	/* Clear entire check buffer for later bit tests. */	\
 	memset(check_buf, 0x00, sizeof(check_buf));		\
 	/* Extract stack-defined variable contents. */		\
@@ -126,9 +135,9 @@ static noinline __init int test_ ## name (void)			\
 		return 1;					\
 	}							\
 								\
-	/* Look for any set bits in the check region. */	\
-	for (i = 0; i < sizeof(check_buf); i++)			\
-		sum += (check_buf[i] != 0);			\
+	/* Look for any bytes still 0xFF in check region. */	\
+	for (sum = 0, i = 0; i < target_size; i++)		\
+		sum += (check_buf[i] == 0xFF);			\
 								\
 	if (sum == 0)						\
 		pr_info(#name " ok\n");				\
@@ -162,13 +171,13 @@ static noinline __init int leaf_ ## name(unsigned long sp,	\
 	 * Keep this buffer around to make sure we've got a	\
 	 * stack frame of SOME kind...				\
 	 */							\
-	memset(buf, (char)(sp && 0xff), sizeof(buf));		\
+	memset(buf, (char)(sp & 0xff), sizeof(buf));		\
 	/* Fill variable with 0xFF. */				\
 	if (fill) {						\
 		fill_start = &var;				\
 		fill_size = sizeof(var);			\
 		memset(fill_start,				\
-		       (char)((sp && 0xff) | forced_mask),	\
+		       (char)((sp & 0xff) | forced_mask),	\
 		       fill_size);				\
 	}							\
 								\
-- 
2.17.1


-- 
Kees Cook
