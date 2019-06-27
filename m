Return-Path: <kernel-hardening-return-16275-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 40AE857ACC
	for <lists+kernel-hardening@lfdr.de>; Thu, 27 Jun 2019 06:45:54 +0200 (CEST)
Received: (qmail 11592 invoked by uid 550); 27 Jun 2019 04:45:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11503 invoked from network); 27 Jun 2019 04:45:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561610714;
	bh=VopC/H2LVqjcArgoYlGlZvUD87RJOZBksD278wuXTlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c/SGCTX2m4pgv/Y3apFKe1QA4IlTkvXgkc30v0hs5sKOSjFHEgmL/nyBoMJyqTTHD
	 lQp8yX4hm+EUnbKBCJ7O3bpTy6DV8rNAc/eTc9LTlxl3JjIex4DtsxDyJfy4ghj/dn
	 qF/bQizyevBTmoGNtHwJMXqDMQzU8P8RILEIYFUc=
From: Andy Lutomirski <luto@kernel.org>
To: x86@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Florian Weimer <fweimer@redhat.com>,
	Jann Horn <jannh@google.com>,
	Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2 4/8] x86/vsyscall: Document odd SIGSEGV error code for vsyscalls
Date: Wed, 26 Jun 2019 21:45:05 -0700
Message-Id: <75c91855fd850649ace162eec5495a1354221aaa.1561610354.git.luto@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1561610354.git.luto@kernel.org>
References: <cover.1561610354.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Even if vsyscall=none, we report uer page faults on the vsyscall
page as though the PROT bit in the error code was set.  Add a
comment explaining why this is probably okay and display the value
in the test case.

While we're at it, explain why our behavior is correct with respect
to PKRU.

This also modifies the selftest to print the odd error code so that
you can run the selftest and see that the behavior is odd.

If anyone really cares about more accurate emulation, we could
change the behavior.

Cc: Kees Cook <keescook@chromium.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/mm/fault.c                         | 7 +++++++
 tools/testing/selftests/x86/test_vsyscall.c | 9 ++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 288a5462076f..58e4f1f00bbc 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -710,6 +710,10 @@ static void set_signal_archinfo(unsigned long address,
 	 * To avoid leaking information about the kernel page
 	 * table layout, pretend that user-mode accesses to
 	 * kernel addresses are always protection faults.
+	 *
+	 * NB: This means that failed vsyscalls with vsyscall=none
+	 * will have the PROT bit.  This doesn't leak any
+	 * information and does not appear to cause any problems.
 	 */
 	if (address >= TASK_SIZE_MAX)
 		error_code |= X86_PF_PROT;
@@ -1375,6 +1379,9 @@ void do_user_addr_fault(struct pt_regs *regs,
 	 *
 	 * The vsyscall page does not have a "real" VMA, so do this
 	 * emulation before we go searching for VMAs.
+	 *
+	 * PKRU never rejects instruction fetches, so we don't need
+	 * to consider the PF_PK bit.
 	 */
 	if (is_vsyscall_vaddr(address)) {
 		if (emulate_vsyscall(hw_error_code, regs, address))
diff --git a/tools/testing/selftests/x86/test_vsyscall.c b/tools/testing/selftests/x86/test_vsyscall.c
index 0b4f1cc2291c..4c9a8d76dba0 100644
--- a/tools/testing/selftests/x86/test_vsyscall.c
+++ b/tools/testing/selftests/x86/test_vsyscall.c
@@ -183,9 +183,13 @@ static inline long sys_getcpu(unsigned * cpu, unsigned * node,
 }
 
 static jmp_buf jmpbuf;
+static volatile unsigned long segv_err;
 
 static void sigsegv(int sig, siginfo_t *info, void *ctx_void)
 {
+	ucontext_t *ctx = (ucontext_t *)ctx_void;
+
+	segv_err =  ctx->uc_mcontext.gregs[REG_ERR];
 	siglongjmp(jmpbuf, 1);
 }
 
@@ -416,8 +420,11 @@ static int test_vsys_r(void)
 	} else if (!can_read && should_read_vsyscall) {
 		printf("[FAIL]\tWe don't have read access, but we should\n");
 		return 1;
+	} else if (can_read) {
+		printf("[OK]\tWe have read access\n");
 	} else {
-		printf("[OK]\tgot expected result\n");
+		printf("[OK]\tWe do not have read access: #PF(0x%lx)\n",
+		       segv_err);
 	}
 #endif
 
-- 
2.21.0

