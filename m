Return-Path: <kernel-hardening-return-16644-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B8C6F7B304
	for <lists+kernel-hardening@lfdr.de>; Tue, 30 Jul 2019 21:13:43 +0200 (CEST)
Received: (qmail 28018 invoked by uid 550); 30 Jul 2019 19:13:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 27913 invoked from network); 30 Jul 2019 19:13:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cCMnXk6r3FPny+fs1rFc2SWMhw3bJ0loL2W4TiBySr8=;
        b=m478ElFD7q//7AsCxpL9OrAKQBrInm/GCtxGDID+1HbrAnQFF52Ffax0qaupTPDbf/
         GHWHftjDWsObpuzqxd4JH6kFG9bWkMamNih32q2W6VEU2kHfJUJMUiqfHVVZTC06mUOj
         MC1EU6K7NgoUvlEjAb13R+v1h/BbOjctlPBjk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cCMnXk6r3FPny+fs1rFc2SWMhw3bJ0loL2W4TiBySr8=;
        b=kNecb1Jgm48ozYSJxSbSNrkw8I52NnXWWwgK9WVqMRjvhBq6jre2HMlrQZTvLVLVKI
         KTQYgnE2HGYGN/0smN4Z735mSrjQ+ZaGmKhOIRR/aywryIaOqisSZ7fggaQIesfHYrah
         juu7hSdQourBvgv9O5T/iPL251s5UntIiLoVv9ZGdBlAOTz8rcWrGbtXP0zpBK8fXbwk
         5ELEukW0xjvrEjT0VQkEOjdXNxIOxw6hHGYQ+Ii1dLdecspoFs7yChO3bdzOss5g17YU
         CGwPDlpQHRZ7xlJf6XD2cTp9TPORsw5R6B3Mn3eS6RU5qJbJdctfFSCIvHJz8q8ki9T1
         GT7w==
X-Gm-Message-State: APjAAAXt3k9+VAQr8ri2TfXVx1/Sd0uNvx9fmLAGQzBVJVKzjuErqBL4
	PZ8wu5qW2wvEunm2Im+SdDWpNDrKxlg=
X-Google-Smtp-Source: APXvYqxEEHpoFd295wN4FVenXhrnLJncXmAxP37HqjVX+fNi4I8BrYTgPlqRHeP0sCOCSagbyTiddw==
X-Received: by 2002:a63:fd57:: with SMTP id m23mr44942158pgj.204.1564513992259;
        Tue, 30 Jul 2019 12:13:12 -0700 (PDT)
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
	Peter Zijlstra <peterz@infradead.org>,
	Nadav Amit <namit@vmware.com>,
	Jann Horn <jannh@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v9 02/11] x86: Add macro to get symbol address for PIE support
Date: Tue, 30 Jul 2019 12:12:46 -0700
Message-Id: <20190730191303.206365-3-thgarnie@chromium.org>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
In-Reply-To: <20190730191303.206365-1-thgarnie@chromium.org>
References: <20190730191303.206365-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new _ASM_MOVABS macro to fetch a symbol address. It will be used
to replace "_ASM_MOV $<symbol>, %dst" code construct that are not
compatible with PIE.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
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
2.22.0.770.g0f2c4a37fd-goog

