Return-Path: <kernel-hardening-return-15890-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3D99916792
	for <lists+kernel-hardening@lfdr.de>; Tue,  7 May 2019 18:14:42 +0200 (CEST)
Received: (qmail 15686 invoked by uid 550); 7 May 2019 16:13:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15565 invoked from network); 7 May 2019 16:13:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QA3HzzjjvBBxLzgrZcUsI/Ka76WXbPB2jGuemOph6Xg=;
        b=EPXA/HhfhYmNIpyStTLIe0HkJknQfVtp7TmERucT0x6/R3/KPT7QKZ1j8HPBgPNCmH
         PPj6gw/Sa78McVub6La5gCIYi1dmv7wK9IsmDDQvk1p6gCHAVy3tgJaXQoomkmjGWRSe
         9ZlZyEgwZMCzML51PiaHKSel0UM2lPxW9HPDo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QA3HzzjjvBBxLzgrZcUsI/Ka76WXbPB2jGuemOph6Xg=;
        b=X1uQFJ2FrNSRBXRwPMeRQ9D2zGDkfJYKmqe2Zh+fwJCudIgh0OTym36W9lWez21LK0
         1PwdxmAIpro3VVgkhE6TOxVYRMuaCr59voZz/fvCHOMMApf3cYcAZfktkzF3o3Joc7vB
         fl/+T8pSN5JT8JPzJu1pemH465nBRGj+mbWtPmQUpkbJcJswmKIyZKwITXnQ3Ta5R9fL
         UnK7M02wXuSHmEjcdSSKICU88aMrM2wG+h1G4m/Bnh4308yzBucdR918Vxc0vAqSAD+u
         ymD4NC2nBoRqOCR0jKQkOPj18TQNBldkICd4zOG5iu2VC04M6xiiN9lGoLNWeuf0Gsup
         Lr2g==
X-Gm-Message-State: APjAAAUZkVM9fOq214BVhKPMF32sJjQjrRT7QF/MumGBnrdga8+lDEDp
	AKnB8hoZ09xSoMn//UYv/7PMtg==
X-Google-Smtp-Source: APXvYqyeW7D+sPyiZumGQOGNkqWQIR/WsqzmD/UtQYSmmk7rzstgyo+h1xm936mPXzVcBXe1ba+o9g==
X-Received: by 2002:a17:902:b614:: with SMTP id b20mr4001088pls.200.1557245615448;
        Tue, 07 May 2019 09:13:35 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kees Cook <keescook@chromium.org>,
	Joao Moreira <jmoreira@suse.de>,
	Eric Biggers <ebiggers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@alien8.de>,
	x86@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v3 7/7] crypto: x86/glue_helper: Remove function prototype cast helpers
Date: Tue,  7 May 2019 09:13:21 -0700
Message-Id: <20190507161321.34611-8-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190507161321.34611-1-keescook@chromium.org>
References: <20190507161321.34611-1-keescook@chromium.org>

Now that all users of the function prototype casting helpers have been
removed, this deletes the unused macros.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/crypto/glue_helper.h | 6 ------
 include/crypto/xts.h                      | 2 --
 2 files changed, 8 deletions(-)

diff --git a/arch/x86/include/asm/crypto/glue_helper.h b/arch/x86/include/asm/crypto/glue_helper.h
index 3b039d563809..2b2d8d4a5081 100644
--- a/arch/x86/include/asm/crypto/glue_helper.h
+++ b/arch/x86/include/asm/crypto/glue_helper.h
@@ -18,12 +18,6 @@ typedef void (*common_glue_ctr_func_t)(void *ctx, u128 *dst, const u128 *src,
 typedef void (*common_glue_xts_func_t)(void *ctx, u128 *dst, const u128 *src,
 				       le128 *iv);
 
-#define GLUE_FUNC_CAST(fn) ((common_glue_func_t)(fn))
-#define GLUE_CBC_FUNC_CAST(fn) ((common_glue_cbc_func_t)(fn))
-#define GLUE_CTR_FUNC_CAST(fn) ((common_glue_ctr_func_t)(fn))
-#define GLUE_XTS_FUNC_CAST(fn) ((common_glue_xts_func_t)(fn))
-
-
 #define GLUE_CAST(func, context)					\
 asmlinkage void func(struct context *ctx, u8 *dst, const u8 *src);	\
 asmlinkage static inline						\
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

