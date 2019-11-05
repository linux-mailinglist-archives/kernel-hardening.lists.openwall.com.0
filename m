Return-Path: <kernel-hardening-return-17311-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id CD020F0AB8
	for <lists+kernel-hardening@lfdr.de>; Wed,  6 Nov 2019 00:58:11 +0100 (CET)
Received: (qmail 26529 invoked by uid 550); 5 Nov 2019 23:56:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26465 invoked from network); 5 Nov 2019 23:56:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=uZ/kQt4EYM2LvpfCusnWoxftHyD2DxgcHTICv7X7dqw=;
        b=JN9cRXW3eTB7Z2OFW88PXu3tlOY8dStgQEbY8qRUEgweBu4PUIX8TxJ8b95mM5amMG
         dY/gdqPeBwxcAj5lhK+CRHRd9Y9Vpp0cdvG07lguYzEIxlPQjlLTWMX36AhhMbrOp+bu
         Cl6hQENGtphPESeiB1wGFAywqSFr434R5npfiMW2A0Y8vIjGPZh4zUIbEexaOWFxdCOT
         CLAJQw1H0pC3jFL2n55/3yC6h22GnBsHily047age54Pgx3FfV4IqFsu4AOA5+wZCKOA
         Vh966NbyvN58mnGWJfBhXw2nRYEngLWud/TUyZ3xl1yXKU0boesH5G03NhQo6gYktAXR
         HQGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=uZ/kQt4EYM2LvpfCusnWoxftHyD2DxgcHTICv7X7dqw=;
        b=mHJDvfs2b2GtkUm9UIIUB4iYD/qltOMLIFeD9e97UMbqhlAASzGFUcOitjd2siIUTS
         xzOvVI4Q72HE8IkojUVnSnLtrxs58ezp9jBJBf649dLirvKSbpefmZkU1deE/vw0Gsce
         B/Pr8Ua7/rSlCZYjqh6d1ncMVlKHBpuZ/e6wbz4GXkhdo1DrFiONZorxVDZmy3b6Ouah
         3D4athl/OB9hHzYCsxQZnBvxWPUUa1/Cn49MqoWVXh6E+GAAmfZKXal+ouljFqZnxc/V
         CdWPw73B74/Tfebt1dmSfsSTAKdtN4FOeMbJ/ZbPwUqxQCZjmpHOUxsj/Q4naip7MSTn
         Ks6w==
X-Gm-Message-State: APjAAAWBamBDZft1dMN4cjUBT/3ezc31hl872w/iclRqXH8qsW4O3Eg1
	uf93GasWAzzjDCibxJ/1dNENMOM1N0IhW/1LK+E=
X-Google-Smtp-Source: APXvYqxTWXWUBEJ0UiXFjDLjnNptoAXq2B85FgeAZV4DWhGGMZ0/dSlB0BXzaBE92E4TUaHE+e4XmBjxNCDfcOvMvRU=
X-Received: by 2002:a65:5a8c:: with SMTP id c12mr39559106pgt.140.1572998205590;
 Tue, 05 Nov 2019 15:56:45 -0800 (PST)
Date: Tue,  5 Nov 2019 15:56:05 -0800
In-Reply-To: <20191105235608.107702-1-samitolvanen@google.com>
Message-Id: <20191105235608.107702-12-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191105235608.107702-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v5 11/14] arm64: efi: restore x18 if it was corrupted
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, 
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
2.24.0.rc1.363.gb1bccd3e3d-goog

