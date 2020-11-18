Return-Path: <kernel-hardening-return-20423-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 320B12B8790
	for <lists+kernel-hardening@lfdr.de>; Wed, 18 Nov 2020 23:10:44 +0100 (CET)
Received: (qmail 7995 invoked by uid 550); 18 Nov 2020 22:08:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7911 invoked from network); 18 Nov 2020 22:08:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=zNEbBbUjVUwNrqsw9c+UpkNEFF7VA0EYfHLp5cIzntw=;
        b=n0bp9cJvxDsjt7xTCOt5iMFW1d/2tTomLx5U5GAiKgRUC31U0PGdIlVksp+a0VVrdY
         g5/MehVGAk5dAFkfZ/0D3/kc0qKP/5ghMg0SX2rzCLQrn7ZzkYIMJRTQA4tAkeENX90q
         zMfWfxpHMr797C3+ufNsF8n5E2EarI0M+SxfmyYFrfheXFRY/USHp0McDL2ojl4Lgr9c
         ZSVHHwyxFBuJf6EQIB49Tm2/Idyx3u+mRdPPOBh4ppAaY5/pZ300gTIMAOc0hbNqctmz
         NshfWwPYJRHHUsUv7bRZJJIdOYMWpv3CBbpJoRLYa/A5uDpHU91hRb4ca8tn+CBC/z2v
         7wmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zNEbBbUjVUwNrqsw9c+UpkNEFF7VA0EYfHLp5cIzntw=;
        b=EoC1Bv/dWqZmiULIBhBdEp4zOQFmZUVWdWG2j8WyPIEmTj9GBxENrhbm6rjz5NpF+T
         gudTZ5aeVXBeAAQubtmIuDJ6ldPpgkeJAYyjwGDpF106iCaSoaDTJ975tSdbfBmciSjY
         Advd1sXhN5Tn7I9wsWtU4+r8uFDhyNQ2EyyZvjxeyKHg6z86sTLrWjoXsocB5Q8hRNxW
         sBKTyVeS8+V6yKGnUOgi436Qxn5inDd+UMwY8CHdBKE+5E5yMSc9W52simgIYjmgcCwl
         rXvfLRa1mR2oRysUUlyrZ0WAcvrtL2f3uoScnTy3KaD15EXRhfKLna97gQIy/WAv1Vvr
         egfA==
X-Gm-Message-State: AOAM530ttq69zxl0fg9e+YgE+amYynEVmgH6Is4rn1tdO8kPJGVFCCd1
	+1Qzh5mDmsbcSBqJ/P33VCr1hofeek+U7Hf2IME=
X-Google-Smtp-Source: ABdhPJwWbtiTp58G6aNpNqEPufDWDe2zDs+IKNE1XLpICWlrRQN8YWmIrp5YpIBo0gnH6aOzErytNSLLgd+pskDj6ew=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:aa04:: with SMTP id
 s4mr8172287ybi.285.1605737293084; Wed, 18 Nov 2020 14:08:13 -0800 (PST)
Date: Wed, 18 Nov 2020 14:07:31 -0800
In-Reply-To: <20201118220731.925424-1-samitolvanen@google.com>
Message-Id: <20201118220731.925424-18-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201118220731.925424-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH v7 17/17] arm64: allow LTO_CLANG and THINLTO to be selected
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Allow CONFIG_LTO_CLANG and CONFIG_THINLTO to be enabled.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/arm64/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index c7f07978f5b6..56bd83a764f4 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -73,6 +73,8 @@ config ARM64
 	select ARCH_USE_SYM_ANNOTATIONS
 	select ARCH_SUPPORTS_MEMORY_FAILURE
 	select ARCH_SUPPORTS_SHADOW_CALL_STACK if CC_HAVE_SHADOW_CALL_STACK
+	select ARCH_SUPPORTS_LTO_CLANG
+	select ARCH_SUPPORTS_THINLTO
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_INT128 if CC_HAS_INT128 && (GCC_VERSION >= 50000 || CC_IS_CLANG)
 	select ARCH_SUPPORTS_NUMA_BALANCING
-- 
2.29.2.299.gdc1121823c-goog

