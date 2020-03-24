Return-Path: <kernel-hardening-return-18194-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5E0EB191B0D
	for <lists+kernel-hardening@lfdr.de>; Tue, 24 Mar 2020 21:33:02 +0100 (CET)
Received: (qmail 17637 invoked by uid 550); 24 Mar 2020 20:32:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17601 invoked from network); 24 Mar 2020 20:32:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QtcXhojXdvVAaDeWfB/KlcDfMVh9eKi/T1lC0sMYq8g=;
        b=Vpxmpa7ys0bod0SNGpU9HyY796q3xE/M3orNp8yw116/0ZyHjlZKj+WNR92bTLQ7N7
         mX5GB7DrOSUiWFgL9zFZ9VSSzsyJoLgWbC4sD0apXV2JjP55GWJ/SQRkk+tLe9BdjdAA
         RdWbcxQUkap+TOsmpSxq5+j6/AOKEweKlqbt8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QtcXhojXdvVAaDeWfB/KlcDfMVh9eKi/T1lC0sMYq8g=;
        b=dqFF1owKSluHJb8B8gz7gU9zV9B11t8uwycS1Oei9T6GofNUZ4rk/DpCFzNNdGMWC2
         38pVZ1XCBazKIHI5zOHalXrZoRXuLgFHSH9Sl3HjwSfbRMQyutVTahU6k4rZHbN2p/jf
         oQcqWOYpLEn0TdmeW3g9fpmU6F2Q5MNiry9Oqhy7K2YqCAKRcdSgjyBFDGpC43wvG4HW
         3ZX5Sgu03yTEQZ1qM3BUhTbdLOQUxPNmvCw/Ece0djyhUxhjtWrO+SOZpcWJ+/p7CKqk
         1FvruXazUn75ayvj3jmpPrdeHWBnu5m/qclheOFwRowGP89NBVDREjXq/KVEUOrFaqT+
         krKg==
X-Gm-Message-State: ANhLgQ1UJ14RXcf+F0h2qXml2/A3Zx6iZvq/HlFg1zhztZbIWNdGPfBg
	5ZyeJ8HRsl2JtKlZ21LLVigYMA==
X-Google-Smtp-Source: ADFU+vtPSvkZ9yb3NUUQBsFHC9q7zD81H0YjIqBGW1aGNMgqBP877n5HImnbQzQDRnrTS9OMqHYFgg==
X-Received: by 2002:a17:90b:124a:: with SMTP id gx10mr7434930pjb.117.1585081958466;
        Tue, 24 Mar 2020 13:32:38 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>,
	Elena Reshetova <elena.reshetova@intel.com>,
	x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>,
	"Perla, Enrico" <enrico.perla@intel.com>,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/5] init_on_alloc: Unpessimize default-on builds
Date: Tue, 24 Mar 2020 13:32:28 -0700
Message-Id: <20200324203231.64324-3-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324203231.64324-1-keescook@chromium.org>
References: <20200324203231.64324-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Right now, the state of CONFIG_INIT_ON_ALLOC_DEFAULT_ON (and
...ON_FREE...) did not change the assembly ordering of the static branch
tests. Use the new jump_label macro to check CONFIG settings to default
to the "expected" state, unpessimizes the resulting assembly code.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/mm.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 059658604dd6..64e911159ffa 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2665,7 +2665,8 @@ static inline void kernel_poison_pages(struct page *page, int numpages,
 DECLARE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_ALLOC_DEFAULT_ON, init_on_alloc);
 static inline bool want_init_on_alloc(gfp_t flags)
 {
-	if (static_branch_unlikely(&init_on_alloc) &&
+	if (static_branch_maybe(CONFIG_INIT_ON_ALLOC_DEFAULT_ON,
+				&init_on_alloc) &&
 	    !page_poisoning_enabled())
 		return true;
 	return flags & __GFP_ZERO;
@@ -2674,7 +2675,8 @@ static inline bool want_init_on_alloc(gfp_t flags)
 DECLARE_STATIC_KEY_MAYBE(CONFIG_INIT_ON_FREE_DEFAULT_ON, init_on_free);
 static inline bool want_init_on_free(void)
 {
-	return static_branch_unlikely(&init_on_free) &&
+	return static_branch_maybe(CONFIG_INIT_ON_FREE_DEFAULT_ON,
+				   &init_on_free) &&
 	       !page_poisoning_enabled();
 }
 
-- 
2.20.1

