Return-Path: <kernel-hardening-return-17460-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 49BAB113885
	for <lists+kernel-hardening@lfdr.de>; Thu,  5 Dec 2019 01:11:17 +0100 (CET)
Received: (qmail 28051 invoked by uid 550); 5 Dec 2019 00:10:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 27997 invoked from network); 5 Dec 2019 00:10:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ALzclmclfe7/Are+E2zwtoN5E20g3s/7atxslYp5zww=;
        b=StNnDlpBGGpkxh4LmqeR9wQsbcrNJKHaZeCmAjkMHb8h4GTl1ZQHqs4uCC/JvHxElq
         /txNvdxS5adtJxiAROs0VVndZR8Kr1R4yXT4EJxkMc7Wt7DhsZDWJ5E+4a1VFw/xMwZy
         P/zLTliHZPcyMRn4gvSewOaYYINB+zv5mAwd8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ALzclmclfe7/Are+E2zwtoN5E20g3s/7atxslYp5zww=;
        b=UUkN69k/LkiXp8OdDrkrUK4fAHOtYAJMz9ZlzCXRCZdwnaMynCmEJAON2veGFMhcD/
         Di8tpNb9HnmDlIZ22q4z4CA71/3DYqEcQwb3Vi/KShUWD+UMS+kAb1p8CsBXB4oYJnyv
         xoWbmAZYXlc+47XysmarN3KGCeHkYivIfTP+4f3CcMZF+C5IWmSLGBeE8TCxmtkz4b0C
         Cib80Qicw0zf28ErIRUwT/8sTSYnNiUHfiL/Hk91LDHk4jwwJ9+O5h5VpCb1uB0PeyG2
         USVOJG+fdX5cMJXCbvFlKlUesjT0qVDcQDUISmGBxnsuZilBx7rcqDFK2NuWULXrzt9m
         bWnw==
X-Gm-Message-State: APjAAAUzXE6/uISZWVQkUMYpyUccr1FfyiQQpAubjJ/3WdQolRPHk/od
	ubnh8FF3RbkhZpEkfiBUYM3CTp1wSRo=
X-Google-Smtp-Source: APXvYqxSdZ7Wkqu57YaZ3sPkRlqDS6GltWmE59e0kHGg9y8FxcGordcqDvfMgNftRbTyxHsQtapMFw==
X-Received: by 2002:a17:902:b089:: with SMTP id p9mr6262250plr.154.1575504617608;
        Wed, 04 Dec 2019 16:10:17 -0800 (PST)
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
Subject: [PATCH v10 05/11] x86: pm-trace - Adapt assembly for PIE support
Date: Wed,  4 Dec 2019 16:09:42 -0800
Message-Id: <20191205000957.112719-6-thgarnie@chromium.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
In-Reply-To: <20191205000957.112719-1-thgarnie@chromium.org>
References: <20191205000957.112719-1-thgarnie@chromium.org>
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
2.24.0.393.g34dc348eaf-goog

