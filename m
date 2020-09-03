Return-Path: <kernel-hardening-return-19747-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id CC40625CAF8
	for <lists+kernel-hardening@lfdr.de>; Thu,  3 Sep 2020 22:37:19 +0200 (CEST)
Received: (qmail 28190 invoked by uid 550); 3 Sep 2020 20:32:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28098 invoked from network); 3 Sep 2020 20:32:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=3m31rwYywYePbNZAmvKakEWxPdLPkgQobcut8O2cWG8=;
        b=VrQ+aR64rJWvhe7qjvWHs3a3oZWcccWruofQtzpu1HjveXL8xoPtaOlTNWbvDUD61B
         CoQzytJVd31K/jZ98Hg6Rczs0j7T787BLqQ5rqWRSzjudgYpVfrS9u0CsEHLtYnV1HXj
         NBkXfjSc2/VDWHrHbvNxyyimbc/ENPMtS0Y4BlD1srNMrvDB6zxF7/e4JTm8bBAhExmj
         LBbYZBX5JZqg1Vi4vTQXgFJ8/sXigHGqY1/Ls2EwD9Mkv+uzMqNXG3LvVwSRu3v/TI6m
         0G3wr9PaIys5H7yv+q5Zpneul8N+hYLXyyZ0Ns0Se+O9j2y9H4vAevWAkkxVlU5oauch
         vreg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=3m31rwYywYePbNZAmvKakEWxPdLPkgQobcut8O2cWG8=;
        b=B2uxJlJlnHVsRe8cae7RW0PXAwK7Ni92hdKK90sgnrYBQ4wtOl8F4623w/OvBUVl7x
         C1b7HeWWAw0nxjKi+gZJMxKVavzjC3z/zsggYNca9KqEZQ/IqG4SKu1jh6X5qVmLwKa/
         NziBoB49STY2WMjNctO0aadQ1ktWLfVvzvv7BMwmMcKj61/lCortrezhyTs9BiShIBge
         Jb9lE0cT9W2vqMArlVUelSqnra/K0F2CJcbbAX6Rke/ViUu+9sdC0J6FOa7UfhYeKeoF
         CU6JFs2y2uppXLjkEOFc6nVddUcX3rGBVMacODTZTZptCqKPOyFNFuhAj5jQY0QEq5bL
         cURQ==
X-Gm-Message-State: AOAM531D4hrA3NsmzdSdSgUJFJCnCpQbqJ6VCtStp3nTFhT7eHqM1zuL
	5lQjd40S2pAdxigcXdhLm5pbJJA15vqJ5DYTNMI=
X-Google-Smtp-Source: ABdhPJzAEZ6HmlaoXFTkGyE0iiWNV3l9gW+re2enIfjvIje5wJCTs+Cu5Q/oOeRF8HT4Mmvs4O3RMcG4QddEnv8aRg0=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:2006:: with SMTP id
 g6mr5905482ybg.143.1599165114037; Thu, 03 Sep 2020 13:31:54 -0700 (PDT)
Date: Thu,  3 Sep 2020 13:30:53 -0700
In-Reply-To: <20200903203053.3411268-1-samitolvanen@google.com>
Message-Id: <20200903203053.3411268-29-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com> <20200903203053.3411268-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH v2 28/28] x86, build: allow LTO_CLANG and THINLTO to be selected
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Allow CONFIG_LTO_CLANG and CONFIG_THINLTO to be enabled.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/x86/Kconfig  | 2 ++
 arch/x86/Makefile | 5 +++++
 2 files changed, 7 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 6de2e5c0bdba..0a49008c2363 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -92,6 +92,8 @@ config X86
 	select ARCH_SUPPORTS_ACPI
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_NUMA_BALANCING	if X86_64
+	select ARCH_SUPPORTS_LTO_CLANG		if X86_64
+	select ARCH_SUPPORTS_THINLTO		if X86_64
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_QUEUED_RWLOCKS
 	select ARCH_USE_QUEUED_SPINLOCKS
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 4346ffb2e39f..49e3b8674eb5 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -173,6 +173,11 @@ ifeq ($(ACCUMULATE_OUTGOING_ARGS), 1)
 	KBUILD_CFLAGS += $(call cc-option,-maccumulate-outgoing-args,)
 endif
 
+ifdef CONFIG_LTO_CLANG
+KBUILD_LDFLAGS	+= -plugin-opt=-code-model=kernel \
+		   -plugin-opt=-stack-alignment=$(if $(CONFIG_X86_32),4,8)
+endif
+
 # Workaround for a gcc prelease that unfortunately was shipped in a suse release
 KBUILD_CFLAGS += -Wno-sign-compare
 #
-- 
2.28.0.402.g5ffc5be6b7-goog

