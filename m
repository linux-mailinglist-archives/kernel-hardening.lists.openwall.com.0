Return-Path: <kernel-hardening-return-18437-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 417DF19FA7E
	for <lists+kernel-hardening@lfdr.de>; Mon,  6 Apr 2020 18:43:04 +0200 (CEST)
Received: (qmail 26235 invoked by uid 550); 6 Apr 2020 16:42:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26168 invoked from network); 6 Apr 2020 16:42:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=P7tRJ6/bRwi2I74AEfEJ7NL6sovvq6Ksezb3luMLZ/I=;
        b=I6aOOb4F+m585U3+RTjXCgdA35wkhP1CN3Uhmh+0KXvkwJcQQrkknIVKYFc21EGa9T
         gXREpmuKmKvxZJQyHbkni+ojnnrEUvsfKtX9CGOGZlTJmkKexDQDF2et3kSeqToQRiKo
         Wt+3R+N5GtS2ABYhkNEB3tNvZvXgtf9rP6ZYtHP7qsABnpKM8zORokraX7ZOWpN6zase
         7NeHFG/CLonjoUheDOHlw7LzXo3Z6KjdaB9CNgPtQJRi3+pdaP4ZaWGXm8Emnc+boObD
         Up/eCuQFeygzhdH7a2SHIC/Eb6fhV//t/0cYReB1Mak0oksza68jY0Bqyf5hZJG0QQMh
         gQVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=P7tRJ6/bRwi2I74AEfEJ7NL6sovvq6Ksezb3luMLZ/I=;
        b=quWbj46bGQmqFfqEJaB56v0O6Shgg9HTREWETtu8zzuWUVqrS2QBHabVYZ8saYW17v
         ZkmzJB1Mz2XAuHwbecIEcYp7NrJ+1OJfkylZdIVNaSi2c3ZMJqhuMC4HHG2zMnZ4AmmJ
         UXVNsD2XfjNIRdi9aNG4+79XMsl/fDtkaJRxLLSuDI1VROLun5gtjQhW21jX+2qseUer
         u24YzG80jCdN7KPBb2i6ADzvtJSgW1kd7MKBsFDEPM4bDWb0Pa68FUpnGWQrMyrcfmBy
         HP6I89TkRYVFj6aLjRinasisFatPRXYcFNUKwv9u9mMZvN59bN55+RNlq7p+VfAhnBP8
         WfeQ==
X-Gm-Message-State: AGi0PuZISaHI9HKwL3j65shTSrhYNlaCX2X5lam2XWR6zNnCsqn6bdLJ
	Mwxf6Z+TOLP1j8iceKTviEL+0mMKAMpASSnZ4T4=
X-Google-Smtp-Source: APiQypJJ2vW2BCKCiSZ+xIRCi6v70yfbRRHeakQcdO++WZV928etab2mQBvVqnKPYnI22hBzW364z/buE5ZaeQqgJWo=
X-Received: by 2002:a67:fb0f:: with SMTP id d15mr471360vsr.88.1586191313260;
 Mon, 06 Apr 2020 09:41:53 -0700 (PDT)
Date: Mon,  6 Apr 2020 09:41:16 -0700
In-Reply-To: <20200406164121.154322-1-samitolvanen@google.com>
Message-Id: <20200406164121.154322-8-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200406164121.154322-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.0.292.g33ef6b2f38-goog
Subject: [PATCH v10 07/12] arm64: efi: restore x18 if it was corrupted
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

If we detect a corrupted x18, restore the register before jumping back
to potentially SCS instrumented code. This is safe, because the wrapper
is called with preemption disabled and a separate shadow stack is used
for interrupt handling.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/efi-rt-wrapper.S | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/efi-rt-wrapper.S b/arch/arm64/kernel/efi-rt-wrapper.S
index 3fc71106cb2b..6ca6c0dc11a1 100644
--- a/arch/arm64/kernel/efi-rt-wrapper.S
+++ b/arch/arm64/kernel/efi-rt-wrapper.S
@@ -34,5 +34,14 @@ ENTRY(__efi_rt_asm_wrapper)
 	ldp	x29, x30, [sp], #32
 	b.ne	0f
 	ret
-0:	b	efi_handle_corrupted_x18	// tail call
+0:
+	/*
+	 * With CONFIG_SHADOW_CALL_STACK, the kernel uses x18 to store a
+	 * shadow stack pointer, which we need to restore before returning to
+	 * potentially instrumented code. This is safe because the wrapper is
+	 * called with preemption disabled and a separate shadow stack is used
+	 * for interrupts.
+	 */
+	mov	x18, x2
+	b	efi_handle_corrupted_x18	// tail call
 ENDPROC(__efi_rt_asm_wrapper)
-- 
2.26.0.292.g33ef6b2f38-goog

