Return-Path: <kernel-hardening-return-17197-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 50F98EB5B5
	for <lists+kernel-hardening@lfdr.de>; Thu, 31 Oct 2019 18:01:25 +0100 (CET)
Received: (qmail 1364 invoked by uid 550); 31 Oct 2019 16:59:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 15861 invoked from network); 31 Oct 2019 16:47:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=P4MEC/JNWY+R+03CT6BMcXkN4eq/H40mvA6s8gty/0o=;
        b=FyBd2DZREBGldSQmdAl4ctWmHh0W3zmoUaOrqpBjG9EgJjGFba3+Gk8Ux29MjmAeBe
         sicne4I37jGUHXgzNedjLIMvsWVJI0ltGloZSO14XUHh9UTS3ARo7k97sP37e/Sb7gOS
         DkHrE6/vOZ1GtiQPangd/sumad9YQICceEEnhyVa//W66pwrVwkXh36b+vmOtbBKreKQ
         Cj7tQe1j/bGJXIWzMcMzK/I2qD4i61lE8pjYfsfIy6BaWm8QzTnAU3MchHhGnejhk8Hg
         PI+E7X6+lVUF1d6bWAow+VePWBv3sp0SROOStKCkYLe92oec5OgOSb4SSowmvPYz6/dp
         uItw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=P4MEC/JNWY+R+03CT6BMcXkN4eq/H40mvA6s8gty/0o=;
        b=SNX4z5ME5IOF8kTN5ejx6v8s/4zLL7vsNNBCwvrt9NsrRC2Tojd8uTRtSkwcEQ9gfm
         wJXivegxk6gT84/v6IhMYnoPZDIRwLTki7crsVeChfHwvAFVpcSE/0Swkoih29von2j5
         hRPLK0hAnZbPsYbZoymkd6JaDaNcZxdj9AGnw06wkMUswqW+Nx6ydEb7oLQRJ0GrLJqR
         pDyeC1AT18aNOTT34XYDooCLdBeQO+aCR6tCMU+Gh9H+caYBzln6CgYcucLyyi0WG96T
         6VKyd9dbZEHGW3XlimJe2eQI8i+/AEUlTrovdulpGEGoYfgkDKq3odefDgT7ZX5VdW51
         gZvw==
X-Gm-Message-State: APjAAAVit/cqUW0yIoIFwzVQJRao1NTkQ8/CmSV3PTVwWFZJmPE0p7c4
	CDMU9VBn/iYJ6O202PQM9FzBdP4D5OeLvrX86/Y=
X-Google-Smtp-Source: APXvYqyE0l4dMPPmCmPFvy8Hsugb5xtiMU18+Uv3gR8RxmoCWwbgYDkks7ERiHhw5CjwrT6msMO6tlilVlKLUvoeCVQ=
X-Received: by 2002:a63:6cf:: with SMTP id 198mr7655687pgg.259.1572540435556;
 Thu, 31 Oct 2019 09:47:15 -0700 (PDT)
Date: Thu, 31 Oct 2019 09:46:32 -0700
In-Reply-To: <20191031164637.48901-1-samitolvanen@google.com>
Message-Id: <20191031164637.48901-13-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191031164637.48901-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v3 12/17] arm64: reserve x18 from general allocation with SCS
From: samitolvanen@google.com
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Reserve the x18 register from general allocation when SCS is enabled,
because the compiler uses the register to store the current task's
shadow stack pointer. Note that all external kernel modules must also be
compiled with -ffixed-x18 if the kernel has SCS enabled.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 2c0238ce0551..ef76101201b2 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -72,6 +72,10 @@ stack_protector_prepare: prepare0
 					include/generated/asm-offsets.h))
 endif
 
+ifeq ($(CONFIG_SHADOW_CALL_STACK), y)
+KBUILD_CFLAGS	+= -ffixed-x18
+endif
+
 ifeq ($(CONFIG_CPU_BIG_ENDIAN), y)
 KBUILD_CPPFLAGS	+= -mbig-endian
 CHECKFLAGS	+= -D__AARCH64EB__
-- 
2.24.0.rc0.303.g954a862665-goog

