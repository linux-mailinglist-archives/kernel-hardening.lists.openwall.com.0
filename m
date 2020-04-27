Return-Path: <kernel-hardening-return-18642-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BAE871BA9A5
	for <lists+kernel-hardening@lfdr.de>; Mon, 27 Apr 2020 18:02:24 +0200 (CEST)
Received: (qmail 13737 invoked by uid 550); 27 Apr 2020 16:01:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13626 invoked from network); 27 Apr 2020 16:00:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5K2KfWGbdPDvciUxJWKmXs8jymeyhVJTI52mBn5Jn2U=;
        b=Z0D9RdpHbbOHHtNvqHRo52aZbZAj07cdZRmpWEeU3iQTueml5HmYOfEBcmC2kKVIKm
         gi/I42ma62LvSvGNYMm2NpEhpa6fsNrdLgOepXOs2lXtqi4B13V7mob+8FE88DmkGTAj
         cIfoOAEzDwtio1vu3/bEbEwVj3iXpD61m74J35yn1WLDpR++aGJg9GG9gk87kfObQfaq
         2Fr6/vhs+4bP5L3TBzKyaTEUUQB4mwZj8HZ3pjL3rr671/M4/cAQ1XkhNhG0tTSV5H0Y
         Lghd93Heuw59N+AcYzl5+VmFD+sORBxuAIoCgApPPsaEMCghNZl1+DyNOu8XOZdSuzS/
         tqpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5K2KfWGbdPDvciUxJWKmXs8jymeyhVJTI52mBn5Jn2U=;
        b=U7BfBCV4wmkjOt0sfhGE1jeYbtvhIlI9QmUbVlS1gJO15ohS+brgiBvo2smbhsSqTf
         WhD0ringPT/E6W+Bj1Ba2Wv7MZPAm7CZeou89LhCpMcrR7MSKjwq1UbE+ugnSyXq+gdI
         SdORsNgssEwaAjZN4EZBuK825KT7UXt4UIvEGRIrL1B7ExgJKgyM+Lak9Z6VxpIvVUct
         /Hds8bEUxXsZDO7esv5WcFWkhzoqXkwsYNKlYpQ7RLp6mQDve5NsLTMQmWngO1/t2TEj
         q+n4tdgC21TdEBhZQEQts37Q7HPwZw17LuDajAlSrOcecR2m3qNBD1AUlb/65LwjA/K4
         CAAg==
X-Gm-Message-State: AGi0PuaUyll3ULfkxGUH5JD29+IsCYI0iJZBGIxhFKnbg8Ljkg6yosNr
	4rhGC44Hs0MMVbwuSE/GoWz0QWZbmAobryeB1E4=
X-Google-Smtp-Source: APiQypKZHPN6pHK1vtX6gJq9lobiR8zzmYnoXCSFDICaarTBdgedlZVYx+cSajiHci65J+75kJpbiA+ZLbes2n1w/OI=
X-Received: by 2002:a0c:bec4:: with SMTP id f4mr23363061qvj.26.1588003248063;
 Mon, 27 Apr 2020 09:00:48 -0700 (PDT)
Date: Mon, 27 Apr 2020 09:00:13 -0700
In-Reply-To: <20200427160018.243569-1-samitolvanen@google.com>
Message-Id: <20200427160018.243569-8-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200427160018.243569-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH v13 07/12] arm64: efi: restore x18 if it was corrupted
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	James Morse <james.morse@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Michal Marek <michal.lkml@markovi.net>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Jann Horn <jannh@google.com>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
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
2.26.2.303.gf8c07b1a785-goog

