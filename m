Return-Path: <kernel-hardening-return-17336-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F05E5F828F
	for <lists+kernel-hardening@lfdr.de>; Mon, 11 Nov 2019 22:47:09 +0100 (CET)
Received: (qmail 32686 invoked by uid 550); 11 Nov 2019 21:46:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32499 invoked from network); 11 Nov 2019 21:46:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Q2lZ7Dm1L5aRXMm9XxNsm9WxcGVGFqTOrxf2vwq2v/c=;
        b=X6cJO6j+LuNeFzoMBlJXSpwENsy0YOCb5jmcJTGxZvPS1RV2nWRXEkpU9UtVC0gzU3
         +Skr+AL2+vJk7GunbZi7TcgodFA6q2V5iT3hVRsf4ee2IKQkEKCEGk0zUGnZWZV6us3x
         dsdp/HxQ5DvQXnLDmGpXnTwQRiGC4YdyBTjDE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Q2lZ7Dm1L5aRXMm9XxNsm9WxcGVGFqTOrxf2vwq2v/c=;
        b=uOwbxKf2QaK+h7uV2F/WU6s113k1Tf1mNc3Cr3wHsDcMT7S+aynhAdSvwS1ILUQHBv
         yEXZpzzaCtQ6pX6XgdtzwTPBu4EkklckIYZMkJgEG3e82KbhMJLr0d3oeBxYIjDaj31N
         lqrWNgGhr20Mex/9izR1uVVCQXL6On/zSf33l3JMdJRE3JZKlV79dLa0izzUkpkZ03Cz
         GQgXHDKLrbMI3HTns6MfhjlnHEOT2f0G8Kdo8YE4I/3mQZpYwjQcaYWnp2KROH300225
         GySe0l8gp/RnqlVypd035dKZ6dwHHnkZQ8wdIt7t1ccccfh6kLDbA4umumohlCopuSU8
         Pr6A==
X-Gm-Message-State: APjAAAX4o/69VHaVU7NQGCM/WfcgCr4ZZzPK6dC582ID5N0TuvndzocO
	RIq/FtucYLHMKdP1cyPPnFNgzg==
X-Google-Smtp-Source: APXvYqyte6oJuiojDpH+7VVh1GlXynL4x0mJaAVAGIUiJyoki2Cy/SuhjS+ya0YYXVwQoQZshdRvoA==
X-Received: by 2002:a17:902:b948:: with SMTP id h8mr27221875pls.139.1573508766383;
        Mon, 11 Nov 2019 13:46:06 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kees Cook <keescook@chromium.org>,
	=?UTF-8?q?Jo=C3=A3o=20Moreira?= <joao.moreira@lsc.ic.unicamp.br>,
	Eric Biggers <ebiggers@kernel.org>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Stephan Mueller <smueller@chronox.de>,
	x86@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v4 7/8] crypto: x86/glue_helper: Remove function prototype cast helpers
Date: Mon, 11 Nov 2019 13:45:51 -0800
Message-Id: <20191111214552.36717-8-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191111214552.36717-1-keescook@chromium.org>
References: <20191111214552.36717-1-keescook@chromium.org>

Now that all users of the function prototype casting helpers have been
removed, delete the unused macros.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/crypto/glue_helper.h | 5 -----
 include/crypto/xts.h                      | 2 --
 2 files changed, 7 deletions(-)

diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
index 2fa4968ab8e2..a9935bbb3eb9 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -18,11 +18,6 @@ typedef void (*common_glue_ctr_func_t)(void *ctx, u128 *dst, const u128 *src,
 typedef void (*common_glue_xts_func_t)(void *ctx, u128 *dst, const u128 *src,
 				       le128 *iv);
 
-#define GLUE_FUNC_CAST(fn) ((common_glue_func_t)(fn))
-#define GLUE_CBC_FUNC_CAST(fn) ((common_glue_cbc_func_t)(fn))
-#define GLUE_CTR_FUNC_CAST(fn) ((common_glue_ctr_func_t)(fn))
-#define GLUE_XTS_FUNC_CAST(fn) ((common_glue_xts_func_t)(fn))
-
 #define CRYPTO_FUNC(func)						\
 asmlinkage void func(void *ctx, u8 *dst, const u8 *src)
 
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

