Return-Path: <kernel-hardening-return-16649-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E9BA97B316
	for <lists+kernel-hardening@lfdr.de>; Tue, 30 Jul 2019 21:14:28 +0200 (CEST)
Received: (qmail 28444 invoked by uid 550); 30 Jul 2019 19:13:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28380 invoked from network); 30 Jul 2019 19:13:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Qa0vdqU/e4QPHFVnoNOrEozPMumAGtkoZQ9IP0jYnkg=;
        b=m0iQTXUNy9Ivxk8S8rx6UuqUrCNk/lmb9ABT6tX720KuMWsD28POJqIHBW6/ecVDNQ
         1wbWq2OFtsCV/gCMaCWhi/N9ivwFCLXmf8NoCB80kLVtvh5oGNjC8TdkekyoWfngXYpv
         g4yOAr38UwABJuJh4u7l9MRi4cavnGZbRi9Oc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Qa0vdqU/e4QPHFVnoNOrEozPMumAGtkoZQ9IP0jYnkg=;
        b=FXbcu3BZNRl6gYWYsaxwgddr2VwA6Yho2bFXQzmzyi8i84ygTU/+vyKkZENYV9BtVi
         ejjN+xRHm7bCo8zgZbnmaqN7c2nJJkRRlQirBFSpx2NiYiy7Wwpj8KgeHh+z5U/wB/vf
         GJU54ohurtxUadJaoaD2dW5TXpJE41iXhUYEIDSzFQ81Tj5/pw0b8rsFgYwhXPN94Kgi
         ECI+Ytc1wetNDkIJU34hNpYWlQa1YFmmSJIzvwGAGx8WcZoXrZ8pVwxb9kzOjMpLPSei
         zNGOy0KtzFuAauaK5s+9QCjep0fsXV5AHV7AW/Pyk/SpJ8Cx3CSzmVwK2JAWm14ZO6CO
         543w==
X-Gm-Message-State: APjAAAW8EPsWd72xKmgNieDlZFdUv6GQNrkN1M39uwvrYt84yzNH+Nkv
	q9pOw8gowwBo6eHw0RjVLAVM9bozQwE=
X-Google-Smtp-Source: APXvYqw4FhQAyLlzTXXeXnWi4AdlBXSr5qODFDIUZbZ8fdBVPq/Zyh+2sg3WQmjXFcNGWYaH8U26QA==
X-Received: by 2002:a17:90a:b115:: with SMTP id z21mr56057575pjq.64.1564513999646;
        Tue, 30 Jul 2019 12:13:19 -0700 (PDT)
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
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Len Brown <len.brown@intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v9 06/11] x86/CPU: Adapt assembly for PIE support
Date: Tue, 30 Jul 2019 12:12:50 -0700
Message-Id: <20190730191303.206365-7-thgarnie@chromium.org>
X-Mailer: git-send-email 2.22.0.770.g0f2c4a37fd-goog
In-Reply-To: <20190730191303.206365-1-thgarnie@chromium.org>
References: <20190730191303.206365-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change the assembly code to use only relative references of symbols for the
kernel to be PIE compatible.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
---
 arch/x86/include/asm/processor.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 6e0a3b43d027..bf333d62889e 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -713,11 +713,13 @@ static inline void sync_core(void)
 		"pushfq\n\t"
 		"mov %%cs, %0\n\t"
 		"pushq %q0\n\t"
-		"pushq $1f\n\t"
+		"leaq 1f(%%rip), %q0\n\t"
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
2.22.0.770.g0f2c4a37fd-goog

