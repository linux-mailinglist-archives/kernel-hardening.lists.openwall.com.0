Return-Path: <kernel-hardening-return-15888-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 18C7716784
	for <lists+kernel-hardening@lfdr.de>; Tue,  7 May 2019 18:14:34 +0200 (CEST)
Received: (qmail 15613 invoked by uid 550); 7 May 2019 16:13:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15478 invoked from network); 7 May 2019 16:13:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=R0FaOgXX67vsPpGNylXmSJBLEzb27xlF4Ynp9s27mqA=;
        b=Xud7n7Q9alggwAt4VBpYoD3o4wy4m8k9Or1L5tHoQ4LZKS7dLbaChyM3uqu7GoTcRW
         y0fcgeggtMxoepN+Ggz0h85SsQKrsPuadeKwpHA3TUVgJNkiUnuK+/HJrEULJpY2bK5V
         qe1YeB/IJCb38WXbK53R+cOpsXZyNAOfsUXHI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=R0FaOgXX67vsPpGNylXmSJBLEzb27xlF4Ynp9s27mqA=;
        b=GQBZiiDpoPnX94qwfEmAUPavHMC3VqwgOMvAVzkOrVO0y9MD2aY6//97QH24Msbhjh
         KK5ZlODa3njrEmaTd1UyI57sRrFy+gPsTbxhk1tDDQh5KTPQ1rpf5C8RaEOD2Rskc3u0
         2UP2+vvu8VtU9SdXBTqv9LU6FgLK9xFG1QbGdVPdXHwsDsEg6ad1sUG7jLP/Ha1kqUNr
         k1STpZNJXydkdB6G9A+cpchyj1ZAlChI1oiJbismIEjvy6UVh0orlrKZpOVjZfVK5xpG
         tueUAwMkRtSzCFfSBZ71iyLXHjAoXv1rrNkf7WUlDadXZXZegXoKBqEhNSL8bcq3psxc
         xK3w==
X-Gm-Message-State: APjAAAUhbs4F51Zpib2hecoBIskJjhd4caTLKCsl8oLJHW7QptETvh87
	4UgQm9ryw6V4Mds+V5vI3IODXg==
X-Google-Smtp-Source: APXvYqzaSdcf158RkoW1TjrSNwSD8052ivBcfbU3MEATurInXQewFwbYZqmU1hVduRSIntFNvxyShA==
X-Received: by 2002:a65:4105:: with SMTP id w5mr997687pgp.260.1557245613806;
        Tue, 07 May 2019 09:13:33 -0700 (PDT)
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
Subject: [PATCH v3 4/7] crypto: x86/twofish: Use new glue function macros
Date: Tue,  7 May 2019 09:13:18 -0700
Message-Id: <20190507161321.34611-5-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190507161321.34611-1-keescook@chromium.org>
References: <20190507161321.34611-1-keescook@chromium.org>

From: Joao Moreira <jmoreira@suse.de>

Convert to function declaration macros from function prototype casts
to avoid trigger Control-Flow Integrity checks during indirect function
calls.

Signed-off-by: Joao Moreira <jmoreira@suse.de>
Co-developed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/crypto/twofish_avx_glue.c    | 71 ++++++++++-----------------
 arch/x86/crypto/twofish_glue_3way.c   | 28 +++++------
 arch/x86/include/asm/crypto/twofish.h | 22 +++++----
 3 files changed, 50 insertions(+), 71 deletions(-)

diff --git a/arch/x86/crypto/twofish_avx_glue.c b/arch/x86/crypto/twofish_avx_glue.c
index 66d989230d10..68dc52291c5d 100644
--- a/arch/x86/crypto/twofish_avx_glue.c
+++ b/arch/x86/crypto/twofish_avx_glue.c
@@ -37,20 +37,12 @@
 #define TWOFISH_PARALLEL_BLOCKS 8
 
 /* 8-way parallel cipher functions */
-asmlinkage void twofish_ecb_enc_8way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src);
-asmlinkage void twofish_ecb_dec_8way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src);
-
-asmlinkage void twofish_cbc_dec_8way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src);
-asmlinkage void twofish_ctr_8way(struct twofish_ctx *ctx, u8 *dst,
-				 const u8 *src, le128 *iv);
-
-asmlinkage void twofish_xts_enc_8way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src, le128 *iv);
-asmlinkage void twofish_xts_dec_8way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src, le128 *iv);
+TWOFISH_GLUE(twofish_ecb_enc_8way);
+TWOFISH_GLUE(twofish_ecb_dec_8way);
+TWOFISH_GLUE_CBC(twofish_cbc_dec_8way);
+TWOFISH_GLUE_CTR(twofish_ctr_8way);
+TWOFISH_GLUE_XTS(twofish_xts_enc_8way);
+TWOFISH_GLUE_XTS(twofish_xts_dec_8way);
 
 static int twofish_setkey_skcipher(struct crypto_skcipher *tfm,
 				   const u8 *key, unsigned int keylen)
@@ -58,22 +50,14 @@ static int twofish_setkey_skcipher(struct crypto_skcipher *tfm,
 	return twofish_setkey(&tfm->base, key, keylen);
 }
 
-static inline void twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
-					const u8 *src)
-{
-	__twofish_enc_blk_3way(ctx, dst, src, false);
-}
-
 static void twofish_xts_enc(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(twofish_enc_blk));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, twofish_enc_blk_glue);
 }
 
 static void twofish_xts_dec(void *ctx, u128 *dst, const u128 *src, le128 *iv)
 {
-	glue_xts_crypt_128bit_one(ctx, dst, src, iv,
-				  GLUE_FUNC_CAST(twofish_dec_blk));
+	glue_xts_crypt_128bit_one(ctx, dst, src, iv, twofish_dec_blk_glue);
 }
 
 struct twofish_xts_ctx {
@@ -108,13 +92,13 @@ static const struct common_glue_ctx twofish_enc = {
 
 	.funcs = { {
 		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_ecb_enc_8way) }
+		.fn_u = { .ecb = twofish_ecb_enc_8way_glue }
 	}, {
 		.num_blocks = 3,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk_3way) }
+		.fn_u = { .ecb = twofish_enc_blk_3way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk) }
+		.fn_u = { .ecb = twofish_enc_blk_glue }
 	} }
 };
 
@@ -124,13 +108,13 @@ static const struct common_glue_ctx twofish_ctr = {
 
 	.funcs = { {
 		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(twofish_ctr_8way) }
+		.fn_u = { .ctr = twofish_ctr_8way_glue }
 	}, {
 		.num_blocks = 3,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(twofish_enc_blk_ctr_3way) }
+		.fn_u = { .ctr = twofish_enc_blk_ctr_3way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ctr = GLUE_CTR_FUNC_CAST(twofish_enc_blk_ctr) }
+		.fn_u = { .ctr = twofish_enc_blk_ctr_glue }
 	} }
 };
 
@@ -140,10 +124,10 @@ static const struct common_glue_ctx twofish_enc_xts = {
 
 	.funcs = { {
 		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(twofish_xts_enc_8way) }
+		.fn_u = { .xts = twofish_xts_enc_8way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(twofish_xts_enc) }
+		.fn_u = { .xts = twofish_xts_enc }
 	} }
 };
 
@@ -153,13 +137,13 @@ static const struct common_glue_ctx twofish_dec = {
 
 	.funcs = { {
 		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_ecb_dec_8way) }
+		.fn_u = { .ecb = twofish_ecb_dec_8way_glue }
 	}, {
 		.num_blocks = 3,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_dec_blk_3way) }
+		.fn_u = { .ecb = twofish_dec_blk_3way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_dec_blk) }
+		.fn_u = { .ecb = twofish_dec_blk_glue }
 	} }
 };
 
@@ -169,13 +153,13 @@ static const struct common_glue_ctx twofish_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_cbc_dec_8way) }
+		.fn_u = { .cbc = twofish_cbc_dec_8way_cbc_glue }
 	}, {
 		.num_blocks = 3,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_dec_blk_cbc_3way) }
+		.fn_u = { .cbc = twofish_dec_blk_cbc_3way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_dec_blk) }
+		.fn_u = { .cbc = twofish_dec_blk_cbc_glue }
 	} }
 };
 
@@ -185,10 +169,10 @@ static const struct common_glue_ctx twofish_dec_xts = {
 
 	.funcs = { {
 		.num_blocks = TWOFISH_PARALLEL_BLOCKS,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(twofish_xts_dec_8way) }
+		.fn_u = { .xts = twofish_xts_dec_8way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .xts = GLUE_XTS_FUNC_CAST(twofish_xts_dec) }
+		.fn_u = { .xts = twofish_xts_dec }
 	} }
 };
 
@@ -204,8 +188,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(twofish_enc_blk),
-					   req);
+	return glue_cbc_encrypt_req_128bit(twofish_enc_blk_glue, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
@@ -224,7 +207,7 @@ static int xts_encrypt(struct skcipher_request *req)
 	struct twofish_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&twofish_enc_xts, req,
-				   XTS_TWEAK_CAST(twofish_enc_blk),
+				   twofish_enc_blk_glue,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx);
 }
 
@@ -234,7 +217,7 @@ static int xts_decrypt(struct skcipher_request *req)
 	struct twofish_xts_ctx *ctx = crypto_skcipher_ctx(tfm);
 
 	return glue_xts_req_128bit(&twofish_dec_xts, req,
-				   XTS_TWEAK_CAST(twofish_enc_blk),
+				   twofish_enc_blk_glue,
 				   &ctx->tweak_ctx, &ctx->crypt_ctx);
 }
 
diff --git a/arch/x86/crypto/twofish_glue_3way.c b/arch/x86/crypto/twofish_glue_3way.c
index 571485502ec8..e58236435735 100644
--- a/arch/x86/crypto/twofish_glue_3way.c
+++ b/arch/x86/crypto/twofish_glue_3way.c
@@ -40,12 +40,6 @@ static int twofish_setkey_skcipher(struct crypto_skcipher *tfm,
 	return twofish_setkey(&tfm->base, key, keylen);
 }
 
-static inline void twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
-					const u8 *src)
-{
-	__twofish_enc_blk_3way(ctx, dst, src, false);
-}
-
 static inline void twofish_enc_blk_xor_3way(struct twofish_ctx *ctx, u8 *dst,
 					    const u8 *src)
 {
@@ -66,7 +60,8 @@ void twofish_dec_blk_cbc_3way(void *ctx, u128 *dst, const u128 *src)
 }
 EXPORT_SYMBOL_GPL(twofish_dec_blk_cbc_3way);
 
-void twofish_enc_blk_ctr(void *ctx, u128 *dst, const u128 *src, le128 *iv)
+void twofish_enc_blk_ctr(struct twofish_ctx *ctx, u128 *dst, const u128 *src,
+		le128 *iv)
 {
 	be128 ctrblk;
 
@@ -109,10 +104,10 @@ static const struct common_glue_ctx twofish_enc = {
 
 	.funcs = { {
 		.num_blocks = 3,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk_3way) }
+		.fn_u = { .ecb = twofish_enc_blk_3way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk) }
+		.fn_u = { .ecb = twofish_enc_blk_glue }
 	} }
 };
 
@@ -122,10 +117,10 @@ static const struct common_glue_ctx twofish_ctr = {
 
 	.funcs = { {
 		.num_blocks = 3,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk_ctr_3way) }
+		.fn_u = { .ctr = twofish_enc_blk_ctr_3way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk_ctr) }
+		.fn_u = { .ctr = twofish_enc_blk_ctr_glue }
 	} }
 };
 
@@ -135,10 +130,10 @@ static const struct common_glue_ctx twofish_dec = {
 
 	.funcs = { {
 		.num_blocks = 3,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_dec_blk_3way) }
+		.fn_u = { .ecb = twofish_dec_blk_3way_glue }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .ecb = GLUE_FUNC_CAST(twofish_dec_blk) }
+		.fn_u = { .ecb = twofish_dec_blk_glue }
 	} }
 };
 
@@ -148,10 +143,10 @@ static const struct common_glue_ctx twofish_dec_cbc = {
 
 	.funcs = { {
 		.num_blocks = 3,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_dec_blk_cbc_3way) }
+		.fn_u = { .cbc = twofish_dec_blk_cbc_3way }
 	}, {
 		.num_blocks = 1,
-		.fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_dec_blk) }
+		.fn_u = { .cbc = twofish_dec_blk_cbc_glue }
 	} }
 };
 
@@ -167,8 +162,7 @@ static int ecb_decrypt(struct skcipher_request *req)
 
 static int cbc_encrypt(struct skcipher_request *req)
 {
-	return glue_cbc_encrypt_req_128bit(GLUE_FUNC_CAST(twofish_enc_blk),
-					   req);
+	return glue_cbc_encrypt_req_128bit(twofish_enc_blk_glue, req);
 }
 
 static int cbc_decrypt(struct skcipher_request *req)
diff --git a/arch/x86/include/asm/crypto/twofish.h b/arch/x86/include/asm/crypto/twofish.h
index f618bf272b90..59f3228fbc5d 100644
--- a/arch/x86/include/asm/crypto/twofish.h
+++ b/arch/x86/include/asm/crypto/twofish.h
@@ -6,22 +6,24 @@
 #include <crypto/twofish.h>
 #include <crypto/b128ops.h>
 
+#define TWOFISH_GLUE(func)	GLUE_CAST(func, twofish_ctx)
+#define TWOFISH_GLUE_XOR(func)	GLUE_CAST_XOR(func, twofish_ctx)
+#define TWOFISH_GLUE_CBC(func)	GLUE_CAST_CBC(func, twofish_ctx)
+#define TWOFISH_GLUE_CTR(func)	GLUE_CAST_CTR(func, twofish_ctx)
+#define TWOFISH_GLUE_XTS(func)	GLUE_CAST_XTS(func, twofish_ctx)
+
 /* regular block cipher functions from twofish_x86_64 module */
-asmlinkage void twofish_enc_blk(struct twofish_ctx *ctx, u8 *dst,
-				const u8 *src);
-asmlinkage void twofish_dec_blk(struct twofish_ctx *ctx, u8 *dst,
-				const u8 *src);
+TWOFISH_GLUE(twofish_enc_blk);
+TWOFISH_GLUE(twofish_dec_blk);
+TWOFISH_GLUE_CBC(twofish_dec_blk);
 
 /* 3-way parallel cipher functions */
-asmlinkage void __twofish_enc_blk_3way(struct twofish_ctx *ctx, u8 *dst,
-				       const u8 *src, bool xor);
-asmlinkage void twofish_dec_blk_3way(struct twofish_ctx *ctx, u8 *dst,
-				     const u8 *src);
+TWOFISH_GLUE_XOR(twofish_enc_blk_3way);
+TWOFISH_GLUE(twofish_dec_blk_3way);
 
 /* helpers from twofish_x86_64-3way module */
 extern void twofish_dec_blk_cbc_3way(void *ctx, u128 *dst, const u128 *src);
-extern void twofish_enc_blk_ctr(void *ctx, u128 *dst, const u128 *src,
-				le128 *iv);
+TWOFISH_GLUE_CTR(twofish_enc_blk_ctr);
 extern void twofish_enc_blk_ctr_3way(void *ctx, u128 *dst, const u128 *src,
 				     le128 *iv);
 
-- 
2.17.1

