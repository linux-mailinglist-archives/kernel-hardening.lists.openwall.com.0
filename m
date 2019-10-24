Return-Path: <kernel-hardening-return-17115-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 40BFCE4725
	for <lists+kernel-hardening@lfdr.de>; Fri, 25 Oct 2019 11:28:47 +0200 (CEST)
Received: (qmail 5662 invoked by uid 550); 25 Oct 2019 09:27:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 19649 invoked from network); 24 Oct 2019 22:52:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=R+pagykxtiUayWbEADuJoiydRcDW6HSTgqXK05LN0/E=;
        b=I2431xJR5AtRuX5qoSiIk24z/5OCLlzSdjGi52dpOv12+bHMiaLVBU12PGCDes+r8X
         wAjuAIWuv6ZomAao/O113wncVLizdeeBSlEx1bsxh2/lzn4uD6epbHPViDUva3cOvsU0
         /UNdmDsfJIMrSw5i/0SaDjUj5Es5bVAzDEP1qir0eAi1qvv8mC+P/O4o1w4HC3L6pF50
         AQP27T022w3AaGsGKKMo5gVcBxRaoqeynh9ofqgqyGFYUY3HeancjS86aO6xkUTlSXJv
         nGykeYWoGX6nqGCK04zTzj6lvvXPcGONfsDAOADFXZa+d2m7LYp8SgIBde5lho4ylCuw
         NBDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=R+pagykxtiUayWbEADuJoiydRcDW6HSTgqXK05LN0/E=;
        b=m7dq2JRBqfF3+yi5f48QJ6gwYOTnj7d4Nnu/mjXTz2VlQ0CAG52uTcnicxIgSnd44v
         UjujXAuqdohjSB9Oa+pB4Hy0LGB8lXXbkHmXKyBKiR2nHXTrfVUT1F6606NnhpGe72jV
         vkjXoS3NBJfAKS3yrNYkZfMVfDcHjyAMgkZzA2aJh63eJZTVyt/vwVpHN/Sklz9G+rnf
         D2TaexPxAkjlGiZHfuNuPcuFtigOcDGJhmWwyA9Cq+oTnakyU7ZXa/Ck/mFOyLLiSkn+
         q2opoPYh4RAOSTR6GThrgP522r+JCVkgjQdi7Fxj94OfF/Vp+p/0Y7iMBMCe98JjKNDg
         P5qA==
X-Gm-Message-State: APjAAAVGkMCoRQTY3jUBlzWtHM3E2FBY5jQAdvkR+iFmr+xIxCKX1hhj
	ZMEwrzgwFg6LQg3n8gSqFs3wmtoePsgRgaDkKHs=
X-Google-Smtp-Source: APXvYqxu3PYbJO97f2mzp9DNQTcnJCAUNKZZIOqlBzTc4OuUnzwTI3m0AgfuJaiQwAi1b2GOeoccGn5nuZqvAM1i7Q0=
X-Received: by 2002:a25:cc87:: with SMTP id l129mr704884ybf.48.1571957534881;
 Thu, 24 Oct 2019 15:52:14 -0700 (PDT)
Date: Thu, 24 Oct 2019 15:51:25 -0700
In-Reply-To: <20191024225132.13410-1-samitolvanen@google.com>
Message-Id: <20191024225132.13410-11-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191024225132.13410-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v2 10/17] arm64: disable kretprobes with SCS
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

With CONFIG_KRETPROBES, function return addresses are modified to
redirect control flow to kretprobe_trampoline. This is incompatible
with SCS.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 8cda176dad9a..42867174920f 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -165,7 +165,7 @@ config ARM64
 	select HAVE_STACKPROTECTOR
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_KPROBES
-	select HAVE_KRETPROBES
+	select HAVE_KRETPROBES if !SHADOW_CALL_STACK
 	select HAVE_GENERIC_VDSO
 	select IOMMU_DMA if IOMMU_SUPPORT
 	select IRQ_DOMAIN
-- 
2.24.0.rc0.303.g954a862665-goog

