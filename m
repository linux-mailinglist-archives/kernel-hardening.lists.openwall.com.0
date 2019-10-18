Return-Path: <kernel-hardening-return-17034-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id DC2D6DCAB8
	for <lists+kernel-hardening@lfdr.de>; Fri, 18 Oct 2019 18:16:14 +0200 (CEST)
Received: (qmail 22120 invoked by uid 550); 18 Oct 2019 16:14:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 10166 invoked from network); 18 Oct 2019 16:11:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OMV7GU+CS755gzThihulnjNw1pxqVtHrVsdKKTavPQY=;
        b=FGaZKiG+Ux25snyrOJrBiRd7RwQxjjLhUDr+StQE9m6QImfqUDq6yp6j+8Toagonr0
         9TtbMLb3ay20pI9YbGG7nJzzM0vR4AyRpchI4t/ZYgICefWGJVsG/b/aJxIHIw5w9UV3
         EIJDiPWiyVwP1F234VZ4D2+fA00WZK8lZRp8IvN7MdZJh8XNzU3kgbsv5o54oZ+iiZsI
         KghuQJd7vpAsaqImv6J86r3heyO3yrp6I8mcuRhzR5+TbYZJ39FxxZRefwS+iHZszAKS
         nursS3e3ycHoRmOFQHS1v/YDrqGB9JFjdDc8idnF+2J0IDA0s0+5SNkcUWwuinwq2OFT
         V+bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OMV7GU+CS755gzThihulnjNw1pxqVtHrVsdKKTavPQY=;
        b=QPz0IGCGzZ17uV6kGavGB6bMOjAedl4gwcziyoBPT80y70GQF2wjwN/b92MxmbUnk8
         tv4QQySFRpfG8HpGPwPlSO5JX+MBNC0OcC15Mz7o7krMZgeVeAcOpKlhBd1B/I/KQSOI
         yqTdtRrCQJGchz7jCp7QV/CcN5s59qgzRA+Ez2V411DKM9f5NBC4WofvSSa4nKHYO9cD
         Yd9/E7k6IQhB7lvMEmUO8dekBXGqmVr/A3bBAufoKHpyX1JsJ567DsSqYqAns0QNV1IT
         qHZZUzUt6EJ4hiRAU6Tit/cGr0OsCubDyRRWTWUeGrJ6lGjZ2jPFHB99/4TqNHBDy6+h
         P8dg==
X-Gm-Message-State: APjAAAX3yVpUZ6Aqb6DTXk/GRNkwE7xGVcyh0e4ATxAnvXIhWe6T6TiQ
	2RD4AL3A/QcpHuYfnFHaSF/oH9BXYTwHZMMc3VM=
X-Google-Smtp-Source: APXvYqycxw3zlWpqg/6yGEhb7CgOxW1rmJc0Y43aPOFAV6KRrpZHK92ZxBUvHsBpIOsv4SiMThIv0qzjvIsHF4JRnyI=
X-Received: by 2002:a63:1904:: with SMTP id z4mr11066720pgl.413.1571415085386;
 Fri, 18 Oct 2019 09:11:25 -0700 (PDT)
Date: Fri, 18 Oct 2019 09:10:29 -0700
In-Reply-To: <20191018161033.261971-1-samitolvanen@google.com>
Message-Id: <20191018161033.261971-15-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH 14/18] arm64: efi: restore x18 if it was corrupted
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

If we detect a corrupted x18 and SCS is enabled, restore the register
before jumping back to instrumented code.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/kernel/efi-rt-wrapper.S | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/efi-rt-wrapper.S b/arch/arm64/kernel/efi-rt-wrapper.S
index 3fc71106cb2b..945744f16086 100644
--- a/arch/arm64/kernel/efi-rt-wrapper.S
+++ b/arch/arm64/kernel/efi-rt-wrapper.S
@@ -34,5 +34,10 @@ ENTRY(__efi_rt_asm_wrapper)
 	ldp	x29, x30, [sp], #32
 	b.ne	0f
 	ret
-0:	b	efi_handle_corrupted_x18	// tail call
+0:
+#ifdef CONFIG_SHADOW_CALL_STACK
+	/* Restore x18 before returning to instrumented code. */
+	mov	x18, x2
+#endif
+	b	efi_handle_corrupted_x18	// tail call
 ENDPROC(__efi_rt_asm_wrapper)
-- 
2.23.0.866.gb869b98d4c-goog

