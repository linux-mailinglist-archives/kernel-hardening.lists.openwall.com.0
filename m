Return-Path: <kernel-hardening-return-17308-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F2812F0AB3
	for <lists+kernel-hardening@lfdr.de>; Wed,  6 Nov 2019 00:57:40 +0100 (CET)
Received: (qmail 25771 invoked by uid 550); 5 Nov 2019 23:56:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25678 invoked from network); 5 Nov 2019 23:56:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=m4cUlF+6BFA5FNFSy/SkP+A5WQosIpsKOuqRDiNS4Fs=;
        b=MkeBlqOT1wtRB47pSUzDXD8m2gj/abIK7oOlbgO8kye4NcSoywAeU5ZtSxATJfMS2n
         sLQRqxnA5iMAtD4OVyCqAKV61xGoMEiKHHv5WZLdZGpXH5vTzfmZlcB9JqF0UIw0+fxi
         c3v/IzYD4RKwck3PyJuzlC7Jvs44fd+x/pfQVweb8C0DMCYwaLsC3QIombbYFjvnDAcI
         6fAyLaVNPBEmDJx0XgWILXvjSQ16pLXXh8OX20eaMdKqUAUb/IPjwkwA5StaodCgnT6k
         fOX3eGQKvjofeZjc0oKfmlzFJBlDBOoEIoLe2boRm/0W+bt6Nlx8c29PhG3Gh4cKijCZ
         KWjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=m4cUlF+6BFA5FNFSy/SkP+A5WQosIpsKOuqRDiNS4Fs=;
        b=tyGkmoT8CqQ4BFVr8ZR5wOlKLP7yMmIwi8TlHfLow1E/rUBSgxfpr7jC84FF2JZm0i
         UFi46Ybpshy6nSPi/HzmlMH7/ct4BMiSgdzQ31x2kq3unKRz3ghXF1VykEUjgLQS+tUS
         Lhh6GYLH86/41XfWTtwECnmrrAYEXRNeg1OImYW3OitwcFpH6A84i8IeZ3zKfmSl7z0p
         HbjhJYbhSQhJ1GBHoEG3VDK8jk9slEFJt3CsezCf64Eh4ookaH2ax3/prmjmdfMnNzKn
         4bcItwg2LYzQPolQD4LqUgiDc4yDd1t8X8kyss0q1isUFnfyTrt2uLkuPXxrWHkka+JV
         Db+A==
X-Gm-Message-State: APjAAAWJOAC6+hV6b/OI/EP2HW6ediJB3RMBfz2xnpTDWzR0M7XRGtDM
	V2tIaCV/+W3aP6NeSBETYLnmxIgYYBN4CkeWY5Y=
X-Google-Smtp-Source: APXvYqym75lPAYmcFoKuMCRVIb2Z6qedUXVgqze3G/7tmrBj7VQss4UHqbqav7+LM2z+KkYxzkxHGz+pJ9MZsn3n848=
X-Received: by 2002:a63:c40e:: with SMTP id h14mr39330366pgd.254.1572998197596;
 Tue, 05 Nov 2019 15:56:37 -0800 (PST)
Date: Tue,  5 Nov 2019 15:56:02 -0800
In-Reply-To: <20191105235608.107702-1-samitolvanen@google.com>
Message-Id: <20191105235608.107702-9-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191105235608.107702-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v5 08/14] arm64: disable function graph tracing with SCS
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

The graph tracer hooks returns by modifying frame records on the
(regular) stack, but with SCS the return address is taken from the
shadow stack, and the value in the frame record has no effect. As we
don't currently have a mechanism to determine the corresponding slot
on the shadow stack (and to pass this through the ftrace
infrastructure), for now let's disable the graph tracer when SCS is
enabled.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/arm64/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 3f047afb982c..8cda176dad9a 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -148,7 +148,7 @@ config ARM64
 	select HAVE_FTRACE_MCOUNT_RECORD
 	select HAVE_FUNCTION_TRACER
 	select HAVE_FUNCTION_ERROR_INJECTION
-	select HAVE_FUNCTION_GRAPH_TRACER
+	select HAVE_FUNCTION_GRAPH_TRACER if !SHADOW_CALL_STACK
 	select HAVE_GCC_PLUGINS
 	select HAVE_HW_BREAKPOINT if PERF_EVENTS
 	select HAVE_IRQ_TIME_ACCOUNTING
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

