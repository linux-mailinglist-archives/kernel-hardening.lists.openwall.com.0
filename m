Return-Path: <kernel-hardening-return-17481-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id EBFE211592D
	for <lists+kernel-hardening@lfdr.de>; Fri,  6 Dec 2019 23:15:38 +0100 (CET)
Received: (qmail 21681 invoked by uid 550); 6 Dec 2019 22:14:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 21585 invoked from network); 6 Dec 2019 22:14:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=4aDgrw7n3sKpB8rlb4e1FXGpnlGkWbIPMM9nhNp+jXs=;
        b=au1NZhTF4wAsexOlDW3QvGUTHHibdiuoOGtKnmjfRLZ0pPJFJKE+opISQXIrUR97ye
         Jne0qPeQQiFimsKZER4HaK21Z32PFAMdXThycc6amcnFXyiRGqcBd7hzGtaSxtjLovKA
         MtCxYRCUfBUiozbQAY8WWFFWshKqoTOktvqXvtAigS6VHdCV5+fVo6wqlgPIj5sUrPy7
         nyM+Yj6Rc076XJ7CjGnjpbrP4L2nSj+srGB86VsKIU0Wi383uYJUprK31BiItYr5v/o2
         Pxb9DYcCbj3fcvL19VOlmfxX8nuMHZ73nI0/DFRRg8SJ94YuyFgsEVGXyEeevmK3xEjY
         Wuvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4aDgrw7n3sKpB8rlb4e1FXGpnlGkWbIPMM9nhNp+jXs=;
        b=bqL90pF1NuJX8ixgj3a6hWOUGLeH576hr/JYieMcsC9Sy5uojeJ8jDOpspjHuiiCvw
         qwYHMwyQhCW2HZSWNxhXYMZl2c3rlp/85ffk5YvWrZNVSD3neYMga5k6FC0A0VfMQisV
         ZS9UJA53uk6wTiB764IDG5kOZIDhSt7LJ5HOQA/5TjMxvjgaYdDhS/YQ31A1mY+9FdI/
         oQ8qPed43QH/zJjUIWb8MlbQqRAm+OKPbTLbhFKIaZQykbv1TK7K1Go+FvFgzi2fgP6x
         kjlHjaiEwArZsAk51PSxXb4NjUNSbbVBbYzR7C5ySXJ9i3Cr6ewD+/eCU1dZmJ4ngGrz
         ++lA==
X-Gm-Message-State: APjAAAWkfs0Xdu59PlePbkzZHlcOcGxZBmSeklCf8C2xTB6RcVpV3E2/
	Vh3+in/5mFsAkftFXRZRcueedQlz9S2AS8kcZ5w=
X-Google-Smtp-Source: APXvYqwRlAi+m5KSot17CZFEPydPDuL4iAvmhFlppFfNB1e6R6A3XWaehHnjib1r5pVc/bUaEbkOTOtXqUzvI+1YHGE=
X-Received: by 2002:a65:518b:: with SMTP id h11mr5968857pgq.133.1575670459027;
 Fri, 06 Dec 2019 14:14:19 -0800 (PST)
Date: Fri,  6 Dec 2019 14:13:45 -0800
In-Reply-To: <20191206221351.38241-1-samitolvanen@google.com>
Message-Id: <20191206221351.38241-10-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191206221351.38241-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH v6 09/15] arm64: reserve x18 from general allocation with SCS
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
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
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/arm64/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 1fbe24d4fdb6..e69736fc1106 100644
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
2.24.0.393.g34dc348eaf-goog

