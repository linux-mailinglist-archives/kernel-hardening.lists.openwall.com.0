Return-Path: <kernel-hardening-return-17427-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 967C0105E03
	for <lists+kernel-hardening@lfdr.de>; Fri, 22 Nov 2019 02:04:55 +0100 (CET)
Received: (qmail 20055 invoked by uid 550); 22 Nov 2019 01:03:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19901 invoked from network); 22 Nov 2019 01:03:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xI/dPXrrYqWegaSFAnlL3jgT7wQ+lhRdMLTgo6t8Ans=;
        b=RBA3HZTsQVNixmKnD00ysKCsEDYLlENk0r/mTUsZOUy2hD49/648riiImHjQvVx0UQ
         CVLu6vTL3NnJbZQsBBWrXdW9cDUAvmrEW95/8AV6i2Yx10wKLN21RO/l29TkxpEhsg3K
         LMUCtW6tqZ89BRUaz/wG5cnaSs+0EUGxfaLe4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xI/dPXrrYqWegaSFAnlL3jgT7wQ+lhRdMLTgo6t8Ans=;
        b=GUL4atJ9Wrs0uyA1/1n9Qm7F8GxeJ+MpyHDtIH17oGtjgtuP1wN8kqkIu8I253ePk5
         2AxiF3uF9CT0CCgfuVmVdXmV93L6Ztq/soAg71P0kahHDWuHov4BNy7aMCcmz5o7QJ7h
         xRi7CGAY4Ql4/FqAm8U8Fo6MGasUruGE1UMcWK+65xqskCvE+Ii++UabmWDh+XVKvsHs
         5VwWklMZbokL+LN50+cWXyNSTWtZUdhVIaiHE4oYvL0l+wtc08fCDDvhfPOFU/Jw+geM
         kkoah9ik8oV0aSwVU9Vrm5SzmhAGCejQoDnzYN2r7FkjL2IK8rIMpQpagP8qkD+lzitU
         hSFw==
X-Gm-Message-State: APjAAAUnQGdTXZqyP7NUfLS+jKRS0wNMdlCD0oXo/WCC49Gcv2ltOW8V
	udfLUPCPnHQDtuirnDbXaGQM2A==
X-Google-Smtp-Source: APXvYqxvLuLvwOD7ySfWOmJmnhEcGvvulnrYgJt72BDggzBdZ0gfowf/Jw6lqUM9sF24EUx+wum6aQ==
X-Received: by 2002:a17:902:b7cb:: with SMTP id v11mr11529425plz.176.1574384624926;
        Thu, 21 Nov 2019 17:03:44 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kees Cook <keescook@chromium.org>,
	=?UTF-8?q?Jo=C3=A3o=20Moreira?= <joao.moreira@intel.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	Stephan Mueller <smueller@chronox.de>,
	x86@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v6 7/8] crypto: x86/glue_helper: Remove function prototype cast helpers
Date: Thu, 21 Nov 2019 17:03:33 -0800
Message-Id: <20191122010334.12081-8-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191122010334.12081-1-keescook@chromium.org>
References: <20191122010334.12081-1-keescook@chromium.org>

Now that all users of the function prototype casting helpers have been
removed, delete the unused macros.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/crypto/glue_helper.h | 5 -----
 include/crypto/xts.h                      | 2 --
 2 files changed, 7 deletions(-)

diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
index ba48d5af4f16..777c0f63418c 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -18,11 +18,6 @@ typedef void (*common_glue_ctr_func_t)(const void *ctx, u8 *dst, const u8 *src,
 typedef void (*common_glue_xts_func_t)(const void *ctx, u8 *dst, const u8 *src,
 				       le128 *iv);
 
-#define GLUE_FUNC_CAST(fn) ((common_glue_func_t)(fn))
-#define GLUE_CBC_FUNC_CAST(fn) ((common_glue_cbc_func_t)(fn))
-#define GLUE_CTR_FUNC_CAST(fn) ((common_glue_ctr_func_t)(fn))
-#define GLUE_XTS_FUNC_CAST(fn) ((common_glue_xts_func_t)(fn))
-
 struct common_glue_func_entry {
 	unsigned int num_blocks; /* number of blocks that @fn will process */
 	union {
diff --git a/include/crypto/xts.h b/include/crypto/xts.h
index 75fd96ff976b..15ae7fdc0478 100644
--- a/include/crypto/xts.h
+++ b/include/crypto/xts.h
@@ -8,8 +8,6 @@
 
 #define XTS_BLOCK_SIZE 16
 
-#define XTS_TWEAK_CAST(x) ((void (*)(void *, u8*, const u8*))(x))
-
 static inline int xts_check_key(struct crypto_tfm *tfm,
 				const u8 *key, unsigned int keylen)
 {
-- 
2.17.1

