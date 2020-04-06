Return-Path: <kernel-hardening-return-18451-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F2C841A017C
	for <lists+kernel-hardening@lfdr.de>; Tue,  7 Apr 2020 01:17:13 +0200 (CEST)
Received: (qmail 24392 invoked by uid 550); 6 Apr 2020 23:16:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24281 invoked from network); 6 Apr 2020 23:16:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6T/7mkz2QJj1i6yBI9rf5y5UrGkfIoNdamdak5bIEr8=;
        b=SHvDMZKynQoupRAYdyzGP7833YCcGwM4Pjmu4hIlfgEi41IUoIMZIvMFkCimFNo1pC
         ukiFfjPKn6dwME2ko+g8mNG5D99lrZbhcV9idRFBRE7QuhQxO7LJZsbFMVIn38ydgfCG
         4qMfQRVb21FqPszfB/2JLkg9/aNX0WWnHNT0E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6T/7mkz2QJj1i6yBI9rf5y5UrGkfIoNdamdak5bIEr8=;
        b=U+gg1G7YdxUBltaNSd3yXEqpRB9EM+6WlYUiGMmdpjF1xFINSTds5wMGK+H0/PSMzG
         DV+rckuX7Ex5iWmQDR9nLVkm4n3gsP+kHIlBFWLMLwaORanPd/g9gL1ptKW3qTSzhoQY
         Y5X7EDJZRzXWkGKQB/Sp05eDpoRNzf2QfrphbUmqO8H+4U/FdJFl8UFlpluHiU4pLbo9
         5koURmGna0vjQvGRA4BLgzJjRvyaa3omKZLGEOUzpI7ZMAQkkvbP88j0SVmGC4tecSvg
         mkSq2MB78rXdu/hJRbqi1MXVmwSijwg/xk7TUzuFSGTFsih4EYT3Y3vdHIIKOGPIA9w2
         6DoA==
X-Gm-Message-State: AGi0PuZg++kXba7o/dedoR6XpPMQ6h3q1oIdGM5+Avu11OoMVW9Yalo1
	qBZ61Mci+R+khkGXKArkWumsug==
X-Google-Smtp-Source: APiQypKPb2SK+P7H+McMjGGqVwR7DToHZCme/uHbB59Pjk0ShbX/p0nUYaBfdUBZDv7/4hnnvCIAMQ==
X-Received: by 2002:a62:d10b:: with SMTP id z11mr1732920pfg.205.1586214975509;
        Mon, 06 Apr 2020 16:16:15 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>,
	Elena Reshetova <elena.reshetova@intel.com>,
	x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/5] arm64: entry: Enable random_kstack_offset support
Date: Mon,  6 Apr 2020 16:16:06 -0700
Message-Id: <20200406231606.37619-6-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200406231606.37619-1-keescook@chromium.org>
References: <20200406231606.37619-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow for a randomized stack offset on a per-syscall basis, with roughly
5 bits of entropy.

In order to avoid unconditional stack canaries on syscall entry, also
downgrade from -fstack-protector-strong to -fstack-protector to avoid
triggering checks due to alloca(). Examining the resulting syscall.o,
sees no changes in canary coverage (none before, none now).

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/arm64/Kconfig          |  1 +
 arch/arm64/kernel/Makefile  |  4 ++++
 arch/arm64/kernel/syscall.c | 10 ++++++++++
 3 files changed, 15 insertions(+)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 0b30e884e088..4d5aa4959f72 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -127,6 +127,7 @@ config ARM64
 	select HAVE_ARCH_MMAP_RND_BITS
 	select HAVE_ARCH_MMAP_RND_COMPAT_BITS if COMPAT
 	select HAVE_ARCH_PREL32_RELOCATIONS
+	select HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
 	select HAVE_ARCH_SECCOMP_FILTER
 	select HAVE_ARCH_STACKLEAK
 	select HAVE_ARCH_THREAD_STRUCT_WHITELIST
diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
index fc6488660f64..b89005f125d6 100644
--- a/arch/arm64/kernel/Makefile
+++ b/arch/arm64/kernel/Makefile
@@ -11,6 +11,10 @@ CFLAGS_REMOVE_ftrace.o = $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_insn.o = $(CC_FLAGS_FTRACE)
 CFLAGS_REMOVE_return_address.o = $(CC_FLAGS_FTRACE)
 
+# Downgrade to -fstack-protector to avoid triggering unneeded stack canary
+# checks due to randomize_kstack_offset.
+CFLAGS_syscall.o	+= $(subst -fstack-protector-strong,-fstack-protector,$(filter -fstack-protector-strong,$(KBUILD_CFLAGS)))
+
 # Object file lists.
 obj-y			:= debug-monitors.o entry.o irq.o fpsimd.o		\
 			   entry-common.o entry-fpsimd.o process.o ptrace.o	\
diff --git a/arch/arm64/kernel/syscall.c b/arch/arm64/kernel/syscall.c
index a12c0c88d345..238dbd753b44 100644
--- a/arch/arm64/kernel/syscall.c
+++ b/arch/arm64/kernel/syscall.c
@@ -5,6 +5,7 @@
 #include <linux/errno.h>
 #include <linux/nospec.h>
 #include <linux/ptrace.h>
+#include <linux/randomize_kstack.h>
 #include <linux/syscalls.h>
 
 #include <asm/daifflags.h>
@@ -42,6 +43,8 @@ static void invoke_syscall(struct pt_regs *regs, unsigned int scno,
 {
 	long ret;
 
+	add_random_kstack_offset();
+
 	if (scno < sc_nr) {
 		syscall_fn_t syscall_fn;
 		syscall_fn = syscall_table[array_index_nospec(scno, sc_nr)];
@@ -51,6 +54,13 @@ static void invoke_syscall(struct pt_regs *regs, unsigned int scno,
 	}
 
 	regs->regs[0] = ret;
+
+	/*
+	 * Since the compiler chooses a 4 bit alignment for the stack,
+	 * let's save one additional bit (9 total), which gets us up
+	 * near 5 bits of entropy.
+	 */
+	choose_random_kstack_offset(get_random_int() & 0x1FF);
 }
 
 static inline bool has_syscall_work(unsigned long flags)
-- 
2.20.1

