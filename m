Return-Path: <kernel-hardening-return-18435-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 677FD19FA7B
	for <lists+kernel-hardening@lfdr.de>; Mon,  6 Apr 2020 18:42:41 +0200 (CEST)
Received: (qmail 25602 invoked by uid 550); 6 Apr 2020 16:41:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24488 invoked from network); 6 Apr 2020 16:41:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=9B6Bbg3gx9O6jKpvJ6qFzEYX2A3WHmV1/UUBgqymv0A=;
        b=HrWDz0fZO75NK2vCDmhD/+I1qivG9oQ4qAVeDGVwVMfnHG2UMPDsy9o7I7DFuuos8b
         1wMXq0iZh8/+0SOrfAKklcnAPfzQcpOOxTjvsBz0Vi0obIwCilmN41649T4n71L4/o4U
         LAdhGzV5hQoCG+zdFTTKQJpy0xQJRahkRKsMczLj6t4/jv9w74++Q58CRZVqcxunEXmb
         e/F51UD4+HJXaVRvm6gJ4a3RWNd/HZviv2qgqNNwJ3gi/p4aI5O/iHpykcrqnt5Z3sZ4
         klV/kXyI+4SCreOsjka0bJe/27FDR4qvujrtwmGtRqMmKebKPVVef3jTwgHg8nxIVBQP
         CMtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=9B6Bbg3gx9O6jKpvJ6qFzEYX2A3WHmV1/UUBgqymv0A=;
        b=T4IQe8jOTg7EVb1W3yA0qD8WDl3rp6aQU77a8dmqoiD6gssk2otq+JABVcgnIbnVIQ
         qlp6EupigOR/F64oR/WnbzWN7VZRu0hemGaSYA5kCFbjX5XdG2gvIO8/RLMvEfwiVrWG
         OuXACko2WFDG8Z3ytEuhNXS15hJ6gn3w/qo5+bKYILlof37fyIKMbv3rPdGtaAbg/FcD
         d8ArI5kuRS6nkfrNxNsE8HF8dLZlYp6okcCZtwGztcwE1P+0hROxA6gzeDvXFrwGWVuJ
         lkWUH1th5dXloc+7QQw9cY5DjQzaAJgq4yQoYKZP33rqG2xKB9l9/o/ZsNo3cnXeTunZ
         ELWQ==
X-Gm-Message-State: AGi0PubLPLmj3DV3JLpeNL8npCWSTxC7YM5GvYBfTJrLUC12m/jPQPpe
	6JCIuhEGxpaAfMrF5nxO6tZrYOTEpBDHeaAtuv4=
X-Google-Smtp-Source: APiQypIh9gY+yUNhuam6c+bzLbAj5vxnuqxB7ZWcGUFaI6ujh55+UwXryWUkEBM6Rr0lP42Us55g5qxLwuz/E8Mta2o=
X-Received: by 2002:a63:1662:: with SMTP id 34mr22378296pgw.117.1586191304990;
 Mon, 06 Apr 2020 09:41:44 -0700 (PDT)
Date: Mon,  6 Apr 2020 09:41:14 -0700
In-Reply-To: <20200406164121.154322-1-samitolvanen@google.com>
Message-Id: <20200406164121.154322-6-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200406164121.154322-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.0.292.g33ef6b2f38-goog
Subject: [PATCH v10 05/12] arm64: reserve x18 from general allocation with SCS
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
index f15f92ba53e6..34277c60cdf9 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -76,6 +76,10 @@ branch-prot-flags-$(CONFIG_AS_HAS_PAC) += -Wa,-march=armv8.3-a
 KBUILD_CFLAGS += $(branch-prot-flags-y)
 endif
 
+ifeq ($(CONFIG_SHADOW_CALL_STACK), y)
+KBUILD_CFLAGS	+= -ffixed-x18
+endif
+
 ifeq ($(CONFIG_CPU_BIG_ENDIAN), y)
 KBUILD_CPPFLAGS	+= -mbig-endian
 CHECKFLAGS	+= -D__AARCH64EB__
-- 
2.26.0.292.g33ef6b2f38-goog

