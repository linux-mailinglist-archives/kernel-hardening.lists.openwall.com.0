Return-Path: <kernel-hardening-return-17910-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B2F0316ECCA
	for <lists+kernel-hardening@lfdr.de>; Tue, 25 Feb 2020 18:40:47 +0100 (CET)
Received: (qmail 1727 invoked by uid 550); 25 Feb 2020 17:40:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1648 invoked from network); 25 Feb 2020 17:40:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jVKqEF9zEsFZTQz5E/s7PAlXyZsbPgu1MND2Fom4HAc=;
        b=V+O8aB/kkUO8xqMJE51PIQtZsppsJth+56C9mzqs3rHEUWYqsaBskb5C8HPCIPzcS0
         KLPMyT4P8jAjhfw3HtS6Zd2Bb5U4/swuVVbMREAIk3jxj7rYDCvJV69tJYOtu8AUZqQf
         z2JnJ+dqNTgOx86Zx5X0AKcPG1QBderHLqB7MhI+u/50ASt0GTaqJITfIYTKWJX1nDlb
         MH5KYE7gNzyqd1gGbRsR7gUtF6BdQMWSviF1MHJ423kF5K89MmBFjiBcyN5dmGhPgq/S
         lhVwlyp4UFisGTJT9QGrdtvE2NZMU8DEbTuhfkbOuZMSqCeD2QDwyktTVpa+TfqPqQwZ
         EwDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jVKqEF9zEsFZTQz5E/s7PAlXyZsbPgu1MND2Fom4HAc=;
        b=ZXGn4X+rs99DXMqSBVEQs8orFKE6nO7jfoCKjibifaiJBv8gx4w7zysHzlXu/78msx
         a9c671VJGDDAK/emP8SBExqVDcUJdUd6IbQPz9V0j7262hF1+5iOup2pTPPSGPdoTwID
         oybY5f60gPymrTPx9pmvJjGlYpFEZWgU+Anjk8a5tQDFghqq1pHHXZNWpYyQJqcJrJvJ
         muJI0BA3dVUD2phmZDyqDl+/B1SkNoOEmxx9Fdjf4nQkZYflk5HNZ59oRnO1orKB83Eq
         bnkhSFzrc1hjw42drU37xvUN3df7bPkYNjKx0QR53xYSEYAEyDIlISA0cw10gIskeiDe
         qMDA==
X-Gm-Message-State: APjAAAV3c/uDaILzz2uU5x6ZYFDzTmI0OATt1TWd/lyY0Yx+1CCx++QU
	trB7MtKiPtRjDQtgoEaBUGTNrLEvMAqasbVs36c=
X-Google-Smtp-Source: APXvYqx9O9w9/ihBrjsk0SyFNaEZNd7Lr04/IUqXXK96nskmhLx3/ywlCS6EAR4FJpxoJjOrSsMx/Wn5T6BL4+LTzRE=
X-Received: by 2002:a63:e04a:: with SMTP id n10mr57879618pgj.341.1582652401052;
 Tue, 25 Feb 2020 09:40:01 -0800 (PST)
Date: Tue, 25 Feb 2020 09:39:26 -0800
In-Reply-To: <20200225173933.74818-1-samitolvanen@google.com>
Message-Id: <20200225173933.74818-6-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200225173933.74818-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH v9 05/12] arm64: reserve x18 from general allocation with SCS
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	James Morse <james.morse@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Mark Rutland <mark.rutland@arm.com>
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
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index dca1a97751ab..ab26b448faa9 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -65,6 +65,10 @@ stack_protector_prepare: prepare0
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
2.25.0.265.gbab2e86ba0-goog

