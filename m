Return-Path: <kernel-hardening-return-17200-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0A3BCEB5BB
	for <lists+kernel-hardening@lfdr.de>; Thu, 31 Oct 2019 18:02:01 +0100 (CET)
Received: (qmail 1779 invoked by uid 550); 31 Oct 2019 16:59:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 16035 invoked from network); 31 Oct 2019 16:47:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=hi8Cu8vAZVRE/aapAAyha6S0ojR+GJofj/wY0IAnOZ0=;
        b=P67vDmmf7l8iN6O8NA0rTRghuQ+TRNhS1arwHEnYxr1ViR1HY50ozBsDIgmKlmnXOV
         md0XEh+hEaxcVLZPP1QTlLYLvdf0FZ5h5YQ+hUhhwDYcR//ZTfxu2AYXNsiA1wS45nTi
         SVUQGq6SEiGtWg0iKnZxq+hsmFHJd94RUh0NNXXCkm0GrJaiN4pxdntxDEe2SE7qvN8R
         1E85Ba2ueIH7RNmmMjNsZslAzajrycwYYcrlzySe7vhPJyXlXhUCKyZb31QYebgcsA/j
         hbzgteQSWbLyHD9/3p76Xl00fiAX0l+Zr68AJyUeyf5tCJXRfOLQIH0Q1QaNskmKKaMW
         A+Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=hi8Cu8vAZVRE/aapAAyha6S0ojR+GJofj/wY0IAnOZ0=;
        b=W3s5FjcQoMUirTzd+CyEffgiDp5PBcQ7T2suD/Vol+LkcZjiN7/BbyHEcWiiNjobE9
         QaY+1QG+wEvdDFgsut1VjApxG3rKwDYJnoQb47dbW1HfYpUrYJuYGvdaJLz8Zfj+i8C0
         UwY3H9eBQk2vp8K8ujFDIxKpzw/P6QRYMf9gvZB/Poha5rxE1qdKPeaYBA3jEkf6sLLa
         1U3T3B5sxG1VZj8YH1tAAogr4US0ZElHiFJxpUxySGmIb3cAx+Ei/aInd1w9m4KOIivF
         oEvSM1bntOi/2eNLUDVO76xDL+lidAqR2OKBvp08mMGJLD+OcD0g5gdkjxOiTROKs18G
         aZhw==
X-Gm-Message-State: APjAAAUt5Gnn4w17ZgeBWkggEdmC51E0AeBHHAp6/Kd3ksFlD9eAjGE+
	XYrgt/dm8tVK/sixELFOmnpdGAwr5MZXyWvV8TA=
X-Google-Smtp-Source: APXvYqz6YRDXL8kUecfGxnqeQq30ocBHNq/zxXBU9i1Pelv7UcRC8hJJlGnCkmCBQjmZ8Y0bj93wNqvrOEFGlVoQDyk=
X-Received: by 2002:a63:134a:: with SMTP id 10mr7622711pgt.441.1572540443216;
 Thu, 31 Oct 2019 09:47:23 -0700 (PDT)
Date: Thu, 31 Oct 2019 09:46:35 -0700
In-Reply-To: <20191031164637.48901-1-samitolvanen@google.com>
Message-Id: <20191031164637.48901-16-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191031164637.48901-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v3 15/17] arm64: vdso: disable Shadow Call Stack
From: samitolvanen@google.com
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
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
2.24.0.rc0.303.g954a862665-goog

