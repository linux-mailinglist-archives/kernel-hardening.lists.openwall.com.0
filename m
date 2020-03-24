Return-Path: <kernel-hardening-return-18195-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D9C7D191B0E
	for <lists+kernel-hardening@lfdr.de>; Tue, 24 Mar 2020 21:33:08 +0100 (CET)
Received: (qmail 17669 invoked by uid 550); 24 Mar 2020 20:32:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17602 invoked from network); 24 Mar 2020 20:32:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tXxslwRt84lo46s4AfUIy0jwZL6qW/F8aLPlGo+Vuzs=;
        b=T/YXNFJYjvxaejU1cNn6KiZWcTChX5JBh8J6KYpqLsCb4Zi/vVIMOgsSl+o1HY1WJ2
         vWHAi9J3xlxnvLtkfEmpWoe/DsoFGZbmYUNMbqksBmf+pmqHgLFCCUoxSz+q/p2uCZ5s
         HUkzy9HRyx5OmeeEAodSW6aIsMJPc3Pvav6+U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tXxslwRt84lo46s4AfUIy0jwZL6qW/F8aLPlGo+Vuzs=;
        b=tGeb6bSZwJ3IgLeCh0z6lQqK1rs13FXEkRzbIef1aoGCDISjydZA4h4NUm+J8L2wUz
         m5TrgG31hBVjAak7ZZF0xM1QxnvaoD6Vlhe3JzjVpjENErnYhGWmdxjApzntDpKni2dW
         t/5izE8hpa1X5p+W1fYctfeRq9FKWsMjYXGf9ZOfqvWb1NoTFWm2UxCJeXphZcTvHj68
         ugXeGGl5ViWK4MbJaFxKDumgKYnZoymL3MQIZWt9hl51TV4sq1r0dDC/2+3MGn6Ts5/w
         XnLrwTLUkI8FQ7CVfBrlGVITYSZvTaHl6xUvis2QhwU1aL0VzRgyO/T3bbjHcpbDv6p7
         AzGw==
X-Gm-Message-State: ANhLgQ1kMUs6dc8vUIdqY4oLXqCK9iUuV+itmskrwGjnLYGamrDq+Q7l
	nPHZiiPq+ug1kcKBxBLaRK2mig==
X-Google-Smtp-Source: ADFU+vuPz1pOMJKdmnm1JY1Cd9NWe+ToQ10sdatj73bSqAyNgc+HS1jzGaTvvHVtjKzMIO9M2dV0uA==
X-Received: by 2002:a17:902:8bc8:: with SMTP id r8mr27618425plo.48.1585081958998;
        Tue, 24 Mar 2020 13:32:38 -0700 (PDT)
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
	"Perla, Enrico" <enrico.perla@intel.com>,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/5] x86/entry: Enable random_kstack_offset support
Date: Tue, 24 Mar 2020 13:32:30 -0700
Message-Id: <20200324203231.64324-5-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324203231.64324-1-keescook@chromium.org>
References: <20200324203231.64324-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow for a randomized stack offset on a per-syscall basis, with roughly
5 bits of entropy.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/Kconfig        |  1 +
 arch/x86/entry/common.c | 12 +++++++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index beea77046f9b..b9d449581eb6 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -150,6 +150,7 @@ config X86
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE
 	select HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD if X86_64
 	select HAVE_ARCH_VMAP_STACK		if X86_64
+	select HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
 	select HAVE_ARCH_WITHIN_STACK_FRAMES
 	select HAVE_ASM_MODVERSIONS
 	select HAVE_CMPXCHG_DOUBLE
diff --git a/arch/x86/entry/common.c b/arch/x86/entry/common.c
index 9747876980b5..086d7af570af 100644
--- a/arch/x86/entry/common.c
+++ b/arch/x86/entry/common.c
@@ -26,6 +26,7 @@
 #include <linux/livepatch.h>
 #include <linux/syscalls.h>
 #include <linux/uaccess.h>
+#include <linux/randomize_kstack.h>
 
 #include <asm/desc.h>
 #include <asm/traps.h>
@@ -189,6 +190,13 @@ __visible inline void prepare_exit_to_usermode(struct pt_regs *regs)
 	lockdep_assert_irqs_disabled();
 	lockdep_sys_exit();
 
+	/*
+	 * x86_64 stack alignment means 3 bits are ignored, so keep
+	 * the top 5 bits. x86_32 needs only 2 bits of alignment, so
+	 * the top 6 bits will be used.
+	 */
+	choose_random_kstack_offset(rdtsc() & 0xFF);
+
 	cached_flags = READ_ONCE(ti->flags);
 
 	if (unlikely(cached_flags & EXIT_TO_USERMODE_LOOP_FLAGS))
@@ -283,6 +291,7 @@ __visible void do_syscall_64(unsigned long nr, struct pt_regs *regs)
 {
 	struct thread_info *ti;
 
+	add_random_kstack_offset();
 	enter_from_user_mode();
 	local_irq_enable();
 	ti = current_thread_info();
@@ -355,6 +364,7 @@ static __always_inline void do_syscall_32_irqs_on(struct pt_regs *regs)
 /* Handles int $0x80 */
 __visible void do_int80_syscall_32(struct pt_regs *regs)
 {
+	add_random_kstack_offset();
 	enter_from_user_mode();
 	local_irq_enable();
 	do_syscall_32_irqs_on(regs);
@@ -378,8 +388,8 @@ __visible long do_fast_syscall_32(struct pt_regs *regs)
 	 */
 	regs->ip = landing_pad;
 
+	add_random_kstack_offset();
 	enter_from_user_mode();
-
 	local_irq_enable();
 
 	/* Fetch EBP from where the vDSO stashed it. */
-- 
2.20.1

