Return-Path: <kernel-hardening-return-17629-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9FA9C14C053
	for <lists+kernel-hardening@lfdr.de>; Tue, 28 Jan 2020 19:51:13 +0100 (CET)
Received: (qmail 13313 invoked by uid 550); 28 Jan 2020 18:50:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 12211 invoked from network); 28 Jan 2020 18:50:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=bNCXRmM/yr4GL3yZ1bhHRJc0r5YpsDoQ2qXNiKtbIjQ=;
        b=o7KYQScaTc5r0bWGyHvOSj2qDSparI8nM7EV2GGaR8zJgb85Unw1bAkclg2/3gkVjV
         sWiP8fvXbxWaFa/3ylPd3mUT0DJXJwDNPclKGR0BQxZ4Cc2/1/tkupECkGjVL+qym1xJ
         Ae3JulKZHCqg8uCAc0O9oxR71IRgfwLYrHi5idXDY3EpdKDxL0ypLNFgS5UoGwYlvaVK
         coXWpBTQvrtoEim7i5jhgtRDRSCIEyXek1a+HFz3DKK+zmjORBlTmey8aAdNXMqQeIAI
         9YEW0BDh4vOazWGWstuyBaqYyWx5H8LIDc1PihTJnexHB7ha5NBdEF0GBHhBS0eIc4XK
         0rfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=bNCXRmM/yr4GL3yZ1bhHRJc0r5YpsDoQ2qXNiKtbIjQ=;
        b=UKclOPZrNF97K+XrsmtQlxv4/yVLp4DmrkzTaGznYwivhvOOZSf8XgCAlThAcccTaS
         tk5mGLP1DdYaBu/hn7am3wWS4pToXQaUwct04NoDZGofize4OI+R5ygO9EANzv8lmW5w
         VTDoI/zyBlTGpHlks4+d5B+nfJ2wQAmDcQwH7XVFYj3kN8lJGOM4gRQRPpsegS6aJWeG
         PhzABmxK3zZY1i2zBRYD90/+SVOq+VEmvlp7jCuf0j6HNPSEcKezRwDED4KQriQa9ItT
         3cXeeOwHEFHwPIV8spWILXcsTvXj6kuKIlDvLwA/wAJAlhyDjgOwdkZJM15K6wEvqwdM
         eJzw==
X-Gm-Message-State: APjAAAUm9gqyCPAIFZZoe9geCc3OMoLtGgnHZFqASgu2Qrc46Jm1D7lW
	6UILn4Bt6mvs1DEIWaUGJvI3TrjQgTOUzIw8Vdo=
X-Google-Smtp-Source: APXvYqx+U9CfKO16wIXNBeeO96dJ60XaZ+hhyoe8kAoit2FdttoilLWi0KpO3nWQj2EBXb7JYYq1XAJT8FXWdsvdaLA=
X-Received: by 2002:aed:2783:: with SMTP id a3mr7863657qtd.284.1580237398897;
 Tue, 28 Jan 2020 10:49:58 -0800 (PST)
Date: Tue, 28 Jan 2020 10:49:31 -0800
In-Reply-To: <20200128184934.77625-1-samitolvanen@google.com>
Message-Id: <20200128184934.77625-9-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200128184934.77625-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH v7 08/11] arm64: vdso: disable Shadow Call Stack
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, james.morse@arm.com
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Shadow stacks are only available in the kernel, so disable SCS
instrumentation for the vDSO.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kernel/vdso/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
index dd2514bb1511..a87a4f11724e 100644
--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -25,7 +25,7 @@ ccflags-y += -DDISABLE_BRANCH_PROFILING
 
 VDSO_LDFLAGS := -Bsymbolic
 
-CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os
+CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os $(CC_FLAGS_SCS)
 KBUILD_CFLAGS			+= $(DISABLE_LTO)
 KASAN_SANITIZE			:= n
 UBSAN_SANITIZE			:= n
-- 
2.25.0.341.g760bfbb309-goog

