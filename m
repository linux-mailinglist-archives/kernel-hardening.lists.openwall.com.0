Return-Path: <kernel-hardening-return-17033-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4AF9EDCAB6
	for <lists+kernel-hardening@lfdr.de>; Fri, 18 Oct 2019 18:16:02 +0200 (CEST)
Received: (qmail 21666 invoked by uid 550); 18 Oct 2019 16:14:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 10137 invoked from network); 18 Oct 2019 16:11:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=J6SOPI1rQkBRz/oAhlc59Qnl/pEg0yYrtpuJkIBOBkk=;
        b=XB6QWz3NWtjFWDb+Z+2Cr8pmFgRAQYSnL3Uid2Hg1L3X4a6VceEhm2xwPy1aK+VoSw
         9aDveAT40bEva7mRzlDierznfNSbLqDMAgSgjhFynz+GencRC+yEXI9GlTtBT22sGU3p
         BgssCzMTgiVVKQ7dMBIH2LGWSYP103Svydpv/Qk8+Xt+dKrQ9nOnszXcbv17KY+4wwg4
         NXeKJ9olZaMc5VRteVjdV9T7bI7kUuufX9b3S6ryE8d0aJM7RC3oqJ3jQ0cSx2x8TLsX
         ddVquFcsQoFiGmYXXscZ5m21z4LgANVA4sAoVnGTE5uNuWZVS07mkE/xs/dMfJWy0ygM
         tC4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=J6SOPI1rQkBRz/oAhlc59Qnl/pEg0yYrtpuJkIBOBkk=;
        b=TJEM7IkWQw9wO3CbRHoPgh7FrINZEQCp+qlB9Lgrf5ss48APhRzSl+rdSH086GGObL
         QoYoPXZuRKaxGmvqfonYcAAcVjNTlrQWiJNF44epVytr3/jvINBKFjGVmqDzljIP1CWe
         RAak8llJ819YWjjqtxV9jV6D7pJK4xD5nlOudcCfxG+upku+Sd/5KV5dj/pyIjG0zrXS
         Igjajp1i42FKlqHBesfoIp+KxC141HmzyBYHhjQvEAd7Grb+XpsNO3dpTCjhgZFQXLRa
         xZtoGg7XZ+kAviuRDha4G43BPkWCiP7dbNCWmeIFDFggZSGQUzxDsVq52mthZeY5ILlD
         0vqQ==
X-Gm-Message-State: APjAAAUH01/8dx593e3244RuXsXumrTDXkaO1261H9UBHcZjTZcPcwjL
	6bDqOPlg/8Aa/fgJI3UVqDg7r9fTzG8p35pfXGs=
X-Google-Smtp-Source: APXvYqx8PtU7/rtmLemGGFK39JXzIOz2FvaCxezwKfcFnavxjhOconPajgJzRwBjZVVbgrCp+Uo7fSkc9snzmg9De7Q=
X-Received: by 2002:a63:1e59:: with SMTP id p25mr10856086pgm.361.1571415082807;
 Fri, 18 Oct 2019 09:11:22 -0700 (PDT)
Date: Fri, 18 Oct 2019 09:10:28 -0700
In-Reply-To: <20191018161033.261971-1-samitolvanen@google.com>
Message-Id: <20191018161033.261971-14-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH 13/18] arm64: preserve x18 when CPU is suspended
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Don't lose the current task's shadow stack when the CPU is suspended.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/mm/proc.S | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index fdabf40a83c8..9a8bd4bc8549 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -73,6 +73,9 @@ alternative_endif
 	stp	x8, x9, [x0, #48]
 	stp	x10, x11, [x0, #64]
 	stp	x12, x13, [x0, #80]
+#ifdef CONFIG_SHADOW_CALL_STACK
+	stp	x18, xzr, [x0, #96]
+#endif
 	ret
 ENDPROC(cpu_do_suspend)
 
@@ -89,6 +92,9 @@ ENTRY(cpu_do_resume)
 	ldp	x9, x10, [x0, #48]
 	ldp	x11, x12, [x0, #64]
 	ldp	x13, x14, [x0, #80]
+#ifdef CONFIG_SHADOW_CALL_STACK
+	ldp	x18, x19, [x0, #96]
+#endif
 	msr	tpidr_el0, x2
 	msr	tpidrro_el0, x3
 	msr	contextidr_el1, x4
-- 
2.23.0.866.gb869b98d4c-goog

