Return-Path: <kernel-hardening-return-17483-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E2CE4115938
	for <lists+kernel-hardening@lfdr.de>; Fri,  6 Dec 2019 23:16:00 +0100 (CET)
Received: (qmail 22215 invoked by uid 550); 6 Dec 2019 22:14:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22122 invoked from network); 6 Dec 2019 22:14:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FhYYEjTDkPuKHbZnKePlOaf9pf8CUWO3nD3sOS+po+M=;
        b=c1Wx0pmgZzJDLcr5nKIxS6pdb72MNBZXygUHxUgHfIREUjivSfJmFNkd4nH821+c7c
         XdMpdHUqSUmAmYnv/wYcSmRCYqJtUh+jdTQ3/0TYFxbvGCg3KubysunPGfqG0BjN6R5p
         FZYsTRty1KKiwCF3GFPmHDSfqSVDKBB9Dl9Svv8Esh85iZQ6Gp8IldBOuKDVG0NAYrct
         KCNN1c4Jt5Qnd9QE5BIqwUiELeUVYdQWv32ArtiqQbBLSzZpaS8483/PTd49tfr3IpbZ
         ZlBwyqxJM8pdiJ2dTz9waDv/2F+kWZdAUGGPKaihus1bQ20pRuQajRsHhJifC3dGS/Vz
         k2Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=FhYYEjTDkPuKHbZnKePlOaf9pf8CUWO3nD3sOS+po+M=;
        b=RX7lHrhghduTDpLUyB0ZK43Fg0nyna1Al3sMTBxT9SGGA4GWxxTCDMolWK4BaOJeeT
         i0uHoj5QiC12kJeVcEWevT6W/0ViVOKSdZl6HRQKvyhgIRXKn7eFhiHMu0PYy3lZU0yk
         YNY5xLNzx/IvK1tMgcZGJMD/LpsL3lBakthc2QkCHifKfzGh9VRjIR794w+kmQIV1lp/
         wUfdFZwhMsDJaDErUIj2Orz6KJ1dDBkT5DCHoaFxQnrQnp6nas5QbRR1I+EPSDb3eUCL
         +HXVp0MElzNgL5cAThHvXJqM+W9opB5xbENiy9eEwrbX6FdNi1+UygX6ifFcFfxnNpj9
         Xt2g==
X-Gm-Message-State: APjAAAU0ow8IsbrWdaTkcGMiqdJ5A2Rh1Jq8W1dDGBJ8dtulsJ5gLIep
	nbkLOe30VPfiECG3fTFtr1EAFyrXqMaaQ8gnSck=
X-Google-Smtp-Source: APXvYqwZLBeooXOHcOO29WvEdpgbxookvNvj944sJ15kbZCCqA2Ea8mnulB5DEVBZW8wLWpSg85W/yQRRXH7nkmyS6o=
X-Received: by 2002:ac8:2201:: with SMTP id o1mr15071384qto.247.1575670464028;
 Fri, 06 Dec 2019 14:14:24 -0800 (PST)
Date: Fri,  6 Dec 2019 14:13:47 -0800
In-Reply-To: <20191206221351.38241-1-samitolvanen@google.com>
Message-Id: <20191206221351.38241-12-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191206221351.38241-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
Subject: [PATCH v6 11/15] arm64: efi: restore x18 if it was corrupted
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

If we detect a corrupted x18 and SCS is enabled, restore the register
before jumping back to instrumented code. This is safe, because the
wrapper is called with preemption disabled and a separate shadow stack
is used for interrupt handling.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/arm64/kernel/efi-rt-wrapper.S | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/efi-rt-wrapper.S b/arch/arm64/kernel/efi-rt-wrapper.S
index 3fc71106cb2b..62f0260f5c17 100644
--- a/arch/arm64/kernel/efi-rt-wrapper.S
+++ b/arch/arm64/kernel/efi-rt-wrapper.S
@@ -34,5 +34,14 @@ ENTRY(__efi_rt_asm_wrapper)
 	ldp	x29, x30, [sp], #32
 	b.ne	0f
 	ret
-0:	b	efi_handle_corrupted_x18	// tail call
+0:
+#ifdef CONFIG_SHADOW_CALL_STACK
+	/*
+	 * Restore x18 before returning to instrumented code. This is
+	 * safe because the wrapper is called with preemption disabled and
+	 * a separate shadow stack is used for interrupts.
+	 */
+	mov	x18, x2
+#endif
+	b	efi_handle_corrupted_x18	// tail call
 ENDPROC(__efi_rt_asm_wrapper)
-- 
2.24.0.393.g34dc348eaf-goog

