Return-Path: <kernel-hardening-return-15966-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id EC51924436
	for <lists+kernel-hardening@lfdr.de>; Tue, 21 May 2019 01:21:41 +0200 (CEST)
Received: (qmail 3497 invoked by uid 550); 20 May 2019 23:20:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3415 invoked from network); 20 May 2019 23:20:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7zcfl54ngcYZWe7SGjAVojGJkuuDkL2OOBnEHI8Zvuw=;
        b=d0sVux2H+Kp0vgnzWLkwaPIwsszW/blM2lWdjPDmAFb+mqIIG1s6CfAJxjwUcbjY6o
         fNLaPs6m1ivpVT8hWujSHn6V/uWK7/QnVmFz+fqPxMJVze0DAEF6km91b6qVleXbbxxt
         RAsVRk1pUchvj8zQPNU2JSeZCF/beeoFod/HU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7zcfl54ngcYZWe7SGjAVojGJkuuDkL2OOBnEHI8Zvuw=;
        b=BKXBGtpJo/6mhyDkaf9vLcKa/asdMB0N/pQrhRNU0IATn+R0VKhHL4VsERUcmQH0la
         9v1yn7SzobPzJAUuiQCwe/MM7XOMaAowqFQ/MbappY7QZ2+b1LzwyVYBN9EVpvd2EuDL
         wmCiuQVUGiDqOG8r74R7hPchvQw5fNYW0s7ymiJiQuUko+RadALWqQ6zWaT6HLTk6ELD
         1z0/S5EE9ot+DesNqTJv5Xwdr0apLO9iMV+gLVty4M7w0qhXv9ilsDj29x+kF6zoFvAN
         zKmZgidUD3dPDw597Tue1V1ntBYyEHv+yzPBZiConipj4e0W9DmEAuag4BK6LVM2vTUw
         hy8Q==
X-Gm-Message-State: APjAAAUMcK4/wrVPHVC+frXWf5JNMKqhvo+w8STj+BUvwk/jyYTs/7Bi
	rEgz6Jgk0lzuVlKw+qxccqeuXTyP/34=
X-Google-Smtp-Source: APXvYqyR5iFeDrOxrxE1hHhUIn+dH4BeM6Xeg5KaFIUtHRV7653rxOhVDxMaJjYMO0sQEPJqcLk2Sg==
X-Received: by 2002:a17:902:e213:: with SMTP id ce19mr80568333plb.30.1558394415530;
        Mon, 20 May 2019 16:20:15 -0700 (PDT)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	Thomas Garnier <thgarnie@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Andi Kleen <ak@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 07/12] x86/CPU: Adapt assembly for PIE support
Date: Mon, 20 May 2019 16:19:32 -0700
Message-Id: <20190520231948.49693-8-thgarnie@chromium.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
In-Reply-To: <20190520231948.49693-1-thgarnie@chromium.org>
References: <20190520231948.49693-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Thomas Garnier <thgarnie@google.com>

Change the assembly code to use only relative references of symbols for the
kernel to be PIE compatible. Use the new _ASM_MOVABS macro instead of
the 'mov $symbol, %dst' construct.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/include/asm/processor.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index c34a35c78618..5490a6ead17c 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -710,11 +710,13 @@ static inline void sync_core(void)
 		"pushfq\n\t"
 		"mov %%cs, %0\n\t"
 		"pushq %q0\n\t"
-		"pushq $1f\n\t"
+		"movabsq $1f, %q0\n\t"
+		"pushq %q0\n\t"
 		"iretq\n\t"
 		UNWIND_HINT_RESTORE
 		"1:"
-		: "=&r" (tmp), ASM_CALL_CONSTRAINT : : "cc", "memory");
+		: "=&r" (tmp), ASM_CALL_CONSTRAINT
+		: : "cc", "memory");
 #endif
 }
 
-- 
2.21.0.1020.gf2820cf01a-goog

