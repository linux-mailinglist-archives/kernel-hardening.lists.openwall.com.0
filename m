Return-Path: <kernel-hardening-return-16171-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B69CC49876
	for <lists+kernel-hardening@lfdr.de>; Tue, 18 Jun 2019 06:55:31 +0200 (CEST)
Received: (qmail 19726 invoked by uid 550); 18 Jun 2019 04:55:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19631 invoked from network); 18 Jun 2019 04:55:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=QsQC2UzpT6NyTsbVwUSVvnO0Ud1PYkMdAize/TKgzcI=;
        b=nhXQMKA3pqnFMskPYlyfzfiZ0m1EDAn1/34A37MARMPc0vR6VdJcP0BLE/CZWd3K4G
         MV5zR19K/bY3u5fi7NY094sNRBhUptzdF+DEyNdptTYK+e8hw1nlN6XpuTFbcUGTB68s
         3p5aDl6HPjUBNt8/I3w6OE5IVo6Xj4pFf93yo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=QsQC2UzpT6NyTsbVwUSVvnO0Ud1PYkMdAize/TKgzcI=;
        b=BmWEpKBGRrNEgX4pRNPH+xOA3VR2ZOTfjSLMn1rvPG8Mxbj9IMSDwvfYKXzMhkR/y7
         cD8a6aHJXGminQLrJYvaQuQBmZ5aMBWf1Tvv+BwJoyZaeArBKKQsBlN9X2xzAJTfRGGD
         5Z/lMiPIidJANQtLLda+z8NXhEAMwb8uR95s/V1YW8n9QCngyyXV2ZHl1fQp7ydT8oIN
         jTfjqeTBz3BiwZrVaftnIrzSiUkPxe3eB/menGvfZB5MMCU/sMRMNvi5JOH6/tme5kyK
         pvdVACPN85go4fUKLSyKhE1lLoNnVYS2BlHUnSfHkCj/eINURb6xJRINbpIpQZra3WkM
         Ds7w==
X-Gm-Message-State: APjAAAVC8wF+YFniFxelnNcV4t1BD/0Yh1vyVOScaN3rY5Cpva35zyWC
	cRgyRL7KZjag5WtBOC53/GWe2A==
X-Google-Smtp-Source: APXvYqzvoUCCIV/j/VUYbcljjbnLQAQDKu3Bb56KK/h8GtlbpUAufcbOlyMYfYfo58429sKdsQp80g==
X-Received: by 2002:a17:90a:1785:: with SMTP id q5mr2950312pja.106.1560833708115;
        Mon, 17 Jun 2019 21:55:08 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	x86@kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Dave Hansen <dave.hansen@intel.com>,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v3 3/3] x86/asm: Pin sensitive CR0 bits
Date: Mon, 17 Jun 2019 21:55:03 -0700
Message-Id: <20190618045503.39105-4-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190618045503.39105-1-keescook@chromium.org>
References: <20190618045503.39105-1-keescook@chromium.org>

With sensitive CR4 bits pinned now, it's possible that the WP bit for
CR0 might become a target as well. Following the same reasoning for
the CR4 pinning, this pins CR0's WP bit (but this can be done with a
static value).

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/special_insns.h | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index c8c8143ab27b..b2e84d113f2a 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -31,7 +31,20 @@ static inline unsigned long native_read_cr0(void)
 
 static inline void native_write_cr0(unsigned long val)
 {
-	asm volatile("mov %0,%%cr0": : "r" (val), "m" (__force_order));
+	unsigned long bits_missing = 0;
+
+set_register:
+	asm volatile("mov %0,%%cr0": "+r" (val), "+m" (__force_order));
+
+	if (static_branch_likely(&cr_pinning)) {
+		if (unlikely((val & X86_CR0_WP) != X86_CR0_WP)) {
+			bits_missing = X86_CR0_WP;
+			val |= bits_missing;
+			goto set_register;
+		}
+		/* Warn after we've set the missing bits. */
+		WARN_ONCE(bits_missing, "CR0 WP bit went missing!?\n");
+	}
 }
 
 static inline unsigned long native_read_cr2(void)
-- 
2.17.1

