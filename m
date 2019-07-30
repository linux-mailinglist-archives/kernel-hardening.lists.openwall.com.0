Return-Path: <kernel-hardening-return-16648-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 390CF7B315
	for <lists+kernel-hardening@lfdr.de>; Tue, 30 Jul 2019 21:14:17 +0200 (CEST)
Received: (qmail 28409 invoked by uid 550); 30 Jul 2019 19:13:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28334 invoked from network); 30 Jul 2019 19:13:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=okwXTawHyuFa4icd55twJCHtmhUjDA75Nfe9+fhiSRI=;
        b=WTaj/tCWBI6QVlq4nKTsAxYz1lBPqS7a9eK0QDXPMmbAPy3XkclyuEpGhNiM9+Qc+a
         GfZPY1tJuv8B58Sdyy1D7YxyiHEVqzCtOyRukRfXTl4S9nHMyfrDJWQu9PKz6P5BMI8I
         gB3+kX3pX//wpXa3Ez7mNRLg83QLHpddaT690=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=okwXTawHyuFa4icd55twJCHtmhUjDA75Nfe9+fhiSRI=;
        b=U6RJlUgYb8sAph6ZbUyWCNbL2FaFokBuxzvH7/QL70h4p09mcGCYuZQBtsOtAaAwzm
         ngbZelKa57o2nCDm1nb6/rIOs6Sr1kC/jYxDL3rV9HfdH4Y0EeHYMm8b5Er+7fL5Q2qr
         SWqmbdDP38wzQVl+el2sst7dQU4MF6kCqzk4OkS7uouDBO+cxbary3jLWxtj36FyoKqv
         Buq1UyLK+oL0iWJhsJNN+GJ2o6qM6qHKouTsNhhrldzmoAfy6hQljk8iRmLpmYDQZIih
         b90zoDiC2iOwtC9+C/J7lYTROHpvhNhIc9wNY+Jrt7WPoBJl4mEAxjHJ+vII9P0G+8Yx
         /WHA==
X-Gm-Message-State: APjAAAUTmMHe2jwRrBqL2Joxgt0xWpklvfdeH6o+cmDTrbOGC2ZehxLb
	/mmIErCyz5E7uRHYyKD+439jR0yE9k4=
X-Google-Smtp-Source: APXvYqyboxn+AlEAdie6u7CC57V8sWfALD8FpbLQHIYoEr0y0DEAHDVqK2YOnXcRGhf2UDGdqqHftQ==
X-Received: by 2002:a63:184b:: with SMTP id 11mr49666372pgy.112.1564513997493;
        Tue, 30 Jul 2019 12:13:17 -0700 (PDT)
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
Subject: [PATCH v9 05/11] x86: pm-trace - Adapt assembly for PIE support
Date: Tue, 30 Jul 2019 12:12:49 -0700
Message-Id: <20190730191303.206365-6-thgarnie@chromium.org>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
In-Reply-To: <20190730191303.206365-1-thgarnie@chromium.org>
References: <20190730191303.206365-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change assembly to use the new _ASM_MOVABS macro instead of _ASM_MOV for
the assembly to be PIE compatible.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

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
2.22.0.770.g0f2c4a37fd-goog

