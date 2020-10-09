Return-Path: <kernel-hardening-return-20143-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9E339288E85
	for <lists+kernel-hardening@lfdr.de>; Fri,  9 Oct 2020 18:16:24 +0200 (CEST)
Received: (qmail 5299 invoked by uid 550); 9 Oct 2020 16:14:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5188 invoked from network); 9 Oct 2020 16:14:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=4HzvBRrh7y77qbzNEjVJ7UvC0hGlxJRwsbNcMQwghFk=;
        b=ZNNTphyuqijkRLPow6CC/aXgGKsYBRFzq/yKSKcyxkgD/lkmYvVzPyhTAXclZndZdh
         L3lGMAoJTnYIv0JKMzOqbYFxS0Z/IXLeipSXzl8ZMqk57oa/VznHrTFfgXFW0/IfZcD5
         RqYTIdP+HiFz81jIb/NfQ1D9Haxc/uPLhTJVMZahC+e46ULJHAo2s4sjJ9UcS9BRTN/f
         US6FT8LeKQoMEj/HEtVefzXtpmZ2ndjtN2ZYgQYJ/yL6MsN+9+7BEiRxGDQkpU/Prblz
         jXweMCv47z7uMWgqx10kSVje4u+fTnnhzw09XocxwMtFtHquTcS5T3ofegl5oYhmmSKN
         kLnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4HzvBRrh7y77qbzNEjVJ7UvC0hGlxJRwsbNcMQwghFk=;
        b=onZ67iiDQdviKp8I/tgZQMjeglJnxYz3O0DkFxgVUb7phgswT3l3+vL1zuISYMHlvk
         hGljY6ntYXPswC3A1DqWEgYNC9E7oVR+SGPkwW5RrRoenQxrvBCz4mjpYa/IwEAKOvTw
         qz16lgFAU29KEq1cGcny+UWN+iJlgnsrGe0A4phWWh0V04rGF4ochsvrcyahUusidtct
         BRD7NZnFMJKCfVBDnB9uR02WxUWHf2QeAHDkzFGU1Oai9fSMCT4+AZ+3kFpr8WVkqJqj
         p8gb41vOXJ0jNigXGNAIGBgYVFh+mjyXdwDItHEazb8GILlkNZ6Kk0potWGWJiZEMDPl
         JHcw==
X-Gm-Message-State: AOAM532YCk0lH/xfJD0uRVBKpzYrSrNlSU15wN5JYMMiJCqA6Mr3wIiJ
	rAbgrYMV/4Mp97zCX7iO1zl6zkK7oOGvnJecUYw=
X-Google-Smtp-Source: ABdhPJw9ZF97isedllPPEidWjLehS6Y9RG+YGmBbMiJNYvcjDkRjrFEYfvutxmTQNPM4Efl/aY3oqUISefUn5+QvCQY=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:af90:: with SMTP id
 g16mr17666057ybh.259.1602260045402; Fri, 09 Oct 2020 09:14:05 -0700 (PDT)
Date: Fri,  9 Oct 2020 09:13:21 -0700
In-Reply-To: <20201009161338.657380-1-samitolvanen@google.com>
Message-Id: <20201009161338.657380-13-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201009161338.657380-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v5 12/29] kbuild: lto: limit inlining
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

This change limits function inlining across translation unit boundaries
in order to reduce the binary size with LTO. The -import-instr-limit
flag defines a size limit, as the number of LLVM IR instructions, for
importing functions from other TUs, defaulting to 100.

Based on testing with arm64 defconfig, we found that a limit of 5 is a
reasonable compromise between performance and binary size, reducing the
size of a stripped vmlinux by 11%.

Suggested-by: George Burgess IV <gbiv@google.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Makefile b/Makefile
index 6d31a78d79ce..3fe2dca17261 100644
--- a/Makefile
+++ b/Makefile
@@ -894,6 +894,9 @@ else
 CC_FLAGS_LTO	+= -flto
 endif
 CC_FLAGS_LTO	+= -fvisibility=default
+
+# Limit inlining across translation units to reduce binary size
+KBUILD_LDFLAGS += -mllvm -import-instr-limit=5
 endif
 
 ifdef CONFIG_LTO
-- 
2.28.0.1011.ga647a8990f-goog

