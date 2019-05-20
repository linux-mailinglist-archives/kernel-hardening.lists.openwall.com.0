Return-Path: <kernel-hardening-return-15962-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9AB7E24429
	for <lists+kernel-hardening@lfdr.de>; Tue, 21 May 2019 01:20:54 +0200 (CEST)
Received: (qmail 1833 invoked by uid 550); 20 May 2019 23:20:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1738 invoked from network); 20 May 2019 23:20:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u/wnY+KqFixg56gyP1D7CB7HYKg32m+bqFWSsKBa+/I=;
        b=UjHBMQNV86pahygu8pDM7RodmVPNoOF5hJ3fT3xbyH0dL1de2+tRNhk/hUmxNtJl1q
         +WhScnJIT/kY02tSuiJfwqhs0EkygcgfQQ2Hl2HZpixKp6zgVRzVT74gxZBzXqobqJWx
         rLMNTGXxUbQq9oPM7H/xYWCXBM//FHTX0NQ7g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u/wnY+KqFixg56gyP1D7CB7HYKg32m+bqFWSsKBa+/I=;
        b=PxrRi12sD5ViUq1UMP1lv5aRoKSu67cafGGCw3lqXhXlaALWsraAXQE3QNBZalJfva
         EGc/jVkBy5yFzqTXw9aP/CO/c98c77qb/84k7CAMLZOnQHvIMTHzX0q8NdnhG2HS77DE
         Ov9w7wVctprvxOJYtb9MUksshdMscFsNRWIg6uldn6uo6cAyAF7V6WTStdAJOI8+6RlI
         A9cNTXRe7xBLKSlkPKm/sJx8LhWJCs0+MT1GUZQNKJP3k3ihSoxokf/uwMKh/7on2u40
         3nLN/4EmQRCOb+MEdWPHSGjxh9Ljr7W2Fu3Dr/XkEJgJmaBR3nD/F2vT18anUwny65Kw
         GNvg==
X-Gm-Message-State: APjAAAXJBQH36GH0vIuOGC7ZCx4AyDPezXjOxr+h6uGb//cs9hjpuLLC
	B5HghN9CMH2BVoTYZr+zPIo06RaP9aY=
X-Google-Smtp-Source: APXvYqzV7SBvojMe///9CX7UEbIEQn/fen5oCvVGd76rfHpQHJwNd6ySlPIAhPdQ4X7SwFRT1BafWw==
X-Received: by 2002:a62:2f87:: with SMTP id v129mr9812794pfv.9.1558394407163;
        Mon, 20 May 2019 16:20:07 -0700 (PDT)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	Thomas Garnier <thgarnie@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Nadav Amit <namit@vmware.com>,
	Jann Horn <jannh@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 03/12] x86: Add macro to get symbol address for PIE support
Date: Mon, 20 May 2019 16:19:28 -0700
Message-Id: <20190520231948.49693-4-thgarnie@chromium.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
In-Reply-To: <20190520231948.49693-1-thgarnie@chromium.org>
References: <20190520231948.49693-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Thomas Garnier <thgarnie@google.com>

Add a new _ASM_MOVABS macro to fetch a symbol address. It will be used
to replace "_ASM_MOV $<symbol>, %dst" code construct that are not
compatible with PIE.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/include/asm/asm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index 3ff577c0b102..3a686057e882 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -30,6 +30,7 @@
 #define _ASM_ALIGN	__ASM_SEL(.balign 4, .balign 8)
 
 #define _ASM_MOV	__ASM_SIZE(mov)
+#define _ASM_MOVABS	__ASM_SEL(movl, movabsq)
 #define _ASM_INC	__ASM_SIZE(inc)
 #define _ASM_DEC	__ASM_SIZE(dec)
 #define _ASM_ADD	__ASM_SIZE(add)
-- 
2.21.0.1020.gf2820cf01a-goog

