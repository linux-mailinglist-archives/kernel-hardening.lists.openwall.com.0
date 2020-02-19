Return-Path: <kernel-hardening-return-17832-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 283F2163826
	for <lists+kernel-hardening@lfdr.de>; Wed, 19 Feb 2020 01:09:28 +0100 (CET)
Received: (qmail 32144 invoked by uid 550); 19 Feb 2020 00:09:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32042 invoked from network); 19 Feb 2020 00:09:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tR8HWR8eyR6LK2Q8Pau54PB7Q0F7v08515rGGzIGLyo=;
        b=b5n4a+qzRVoc9p1sMaGcT/avtJg0p34XcrSWSeo6yE4SNClAhGvDWJAoBExyHPO3/M
         PugrHM1VkHW3JMcUgboaltvnYlevaK0mhr2LWRqBIjWKqlzzLgwrVNQ3WddvYgyZ590f
         EhOJfkNAkqMLFx8slzXRty6uvqQquUIPBM/qiVSwThzajXQpK2du4fa3QUrFH6uSuwiw
         w0rKl/E1ibiFUvV8qBI2200bkOB5w3Pa6/gAJnn7yIMSbqnGEL5kL5QKEghpUKm+Uin5
         /fxQ/rvydrg0/k7tj3penT6Yk7Wsvz1o47oE7V6wluUfG2Bz66AXSiCps8hDwWSTAkqK
         OklQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tR8HWR8eyR6LK2Q8Pau54PB7Q0F7v08515rGGzIGLyo=;
        b=DIeh5hmOrv+6xersbis5pojiyTH/ZiWOune5k1hD4v3htR9sE7t2HyqRATIdlPGE2O
         MC2VHSFQyW/YvAUu2RTYxgTLtKtVJo2sm9bMAX1M7oPTm8gAv3V2+KfOmBMO50P2uTLD
         +s+blzGUNX0d5d3u2ZrwUvb+I2q6c58W95JFGqZ2EKaGIkY/KU1tOUiRllYKJsuFoH+c
         LRFSl+gp1TJJxTn4WG3/x8Z19PArIOpYVqi386kERwkP2C6brlLG020o1cFmmd4ykAnb
         c4NRO5NB8tH3Aw7HN3vqdoaUvazuk+C9jg0M164KfnrS5s6BZYJgIA3rnv8nJNL4VaBc
         wpog==
X-Gm-Message-State: APjAAAWdeRyicD9JKYVhoy24mjFnGZyPFmVifFjFFe/j0gZv1EfVTykS
	wT8Gf71yxuPsyUJQGKO2hjaAa0yuNs2hl8VcScU=
X-Google-Smtp-Source: APXvYqxOXrqP7Hvugsa8IU49Lr4UDLSOLYebYtchIFGNM9hOXl0Twc3BrDAcc+jG4ELWfvylhcvwGTzbahuYoyApHyM=
X-Received: by 2002:a63:3d44:: with SMTP id k65mr4554387pga.349.1582070928011;
 Tue, 18 Feb 2020 16:08:48 -0800 (PST)
Date: Tue, 18 Feb 2020 16:08:11 -0800
In-Reply-To: <20200219000817.195049-1-samitolvanen@google.com>
Message-Id: <20200219000817.195049-7-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200219000817.195049-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH v8 06/12] arm64: preserve x18 when CPU is suspended
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, james.morse@arm.com
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't lose the current task's shadow stack when the CPU is suspended.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/suspend.h |  2 +-
 arch/arm64/mm/proc.S             | 14 ++++++++++++++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/suspend.h b/arch/arm64/include/asm/suspend.h
index 8939c87c4dce..0cde2f473971 100644
--- a/arch/arm64/include/asm/suspend.h
+++ b/arch/arm64/include/asm/suspend.h
@@ -2,7 +2,7 @@
 #ifndef __ASM_SUSPEND_H
 #define __ASM_SUSPEND_H
 
-#define NR_CTX_REGS 12
+#define NR_CTX_REGS 13
 #define NR_CALLEE_SAVED_REGS 12
 
 /*
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index aafed6902411..7d37e3c70ff5 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -56,6 +56,8 @@
  * cpu_do_suspend - save CPU registers context
  *
  * x0: virtual address of context pointer
+ *
+ * This must be kept in sync with struct cpu_suspend_ctx in <asm/suspend.h>.
  */
 SYM_FUNC_START(cpu_do_suspend)
 	mrs	x2, tpidr_el0
@@ -80,6 +82,11 @@ alternative_endif
 	stp	x8, x9, [x0, #48]
 	stp	x10, x11, [x0, #64]
 	stp	x12, x13, [x0, #80]
+	/*
+	 * Save x18 as it may be used as a platform register, e.g. by shadow
+	 * call stack.
+	 */
+	str	x18, [x0, #96]
 	ret
 SYM_FUNC_END(cpu_do_suspend)
 
@@ -96,6 +103,13 @@ SYM_FUNC_START(cpu_do_resume)
 	ldp	x9, x10, [x0, #48]
 	ldp	x11, x12, [x0, #64]
 	ldp	x13, x14, [x0, #80]
+	/*
+	 * Restore x18, as it may be used as a platform register, and clear
+	 * the buffer to minimize the risk of exposure when used for shadow
+	 * call stack.
+	 */
+	ldr	x18, [x0, #96]
+	str	xzr, [x0, #96]
 	msr	tpidr_el0, x2
 	msr	tpidrro_el0, x3
 	msr	contextidr_el1, x4
-- 
2.25.0.265.gbab2e86ba0-goog

