Return-Path: <kernel-hardening-return-17996-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9666F172CBA
	for <lists+kernel-hardening@lfdr.de>; Fri, 28 Feb 2020 01:02:14 +0100 (CET)
Received: (qmail 21973 invoked by uid 550); 28 Feb 2020 00:01:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 21810 invoked from network); 28 Feb 2020 00:01:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UhZ7upFOZbJwSu3t6sj7kyMuepSiW+0wthtVyYvfUW8=;
        b=GXN2TwlTYNwiK+ybctcNCG0N1o4mmEfgJ3tnGih4vm5ywp9y4TrkN7Ufd9T3240JQy
         E16DACTSaDDNdfolSmZkf2EnIwxAkoDtU4kGsVdvLeQnFGFncVNe6tE644aMszLX9q3B
         X299mdovMzxD4NedWt/1mwa1YRvXp1azy1t/0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UhZ7upFOZbJwSu3t6sj7kyMuepSiW+0wthtVyYvfUW8=;
        b=VH8HohUstlQFYYgxRHgGG3Ggjb6kC9RwChWLRtwmGBRruG5pMVAh0opZ82Qqjofpfl
         l/XRY4LwIQgjV4MAKdl1Dn2Ug9xb/v//k9SZFuLLG10XaKYX3NuKaLVpQXDuPFjgb+X1
         uHMopr3/pWiJ3yX6xHu2Mt8yzDe9rqXozYVwOSnU0BXtPeDNSRiQg9DJxiqiTV2luLFx
         PLGOyuVThiHuQ7WVxaDftim/3bEAHq8Zq01NFOfM0/Vi2l8HnwczJNbJHYIt/bRl4AM3
         QR4+M5c3f5SWh9tjrh2T4+/8f2ZstlG4208A4goc4iTC/zGCRUYCSOylTHDwJgKTXBzq
         CRyg==
X-Gm-Message-State: APjAAAWxWKZLgDYdN+fjWbyRXkNTohtXOTfptxwZA4SyAQoJl/w5gIra
	O4+RqhAYZ0DsEaW29UU/LiqY0Q0/bPQ=
X-Google-Smtp-Source: APXvYqxiJCqNV8OEfXmb1fBc5jiE7n4/3DOvj4v7SG/Rln8ytNDHgILInJ8gkTkQ+TEqyjFoPLN0cw==
X-Received: by 2002:a17:90a:d80b:: with SMTP id a11mr1588095pjv.142.1582848079067;
        Thu, 27 Feb 2020 16:01:19 -0800 (PST)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	keescook@chromium.org,
	Thomas Garnier <thgarnie@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v11 05/11] x86: pm-trace - Adapt assembly for PIE support
Date: Thu, 27 Feb 2020 16:00:50 -0800
Message-Id: <20200228000105.165012-6-thgarnie@chromium.org>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
In-Reply-To: <20200228000105.165012-1-thgarnie@chromium.org>
References: <20200228000105.165012-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change assembly to use the new _ASM_MOVABS macro instead of _ASM_MOV for
the assembly to be PIE compatible.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/pm-trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/pm-trace.h b/arch/x86/include/asm/pm-trace.h
index bfa32aa428e5..972070806ce9 100644
--- a/arch/x86/include/asm/pm-trace.h
+++ b/arch/x86/include/asm/pm-trace.h
@@ -8,7 +8,7 @@
 do {								\
 	if (pm_trace_enabled) {					\
 		const void *tracedata;				\
-		asm volatile(_ASM_MOV " $1f,%0\n"		\
+		asm volatile(_ASM_MOVABS " $1f,%0\n"		\
 			     ".section .tracedata,\"a\"\n"	\
 			     "1:\t.word %c1\n\t"		\
 			     _ASM_PTR " %c2\n"			\
-- 
2.25.1.481.gfbce0eb801-goog

