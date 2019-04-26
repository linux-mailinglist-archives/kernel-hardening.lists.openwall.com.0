Return-Path: <kernel-hardening-return-15822-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 51109B2E4
	for <lists+kernel-hardening@lfdr.de>; Sat, 27 Apr 2019 08:44:12 +0200 (CEST)
Received: (qmail 1838 invoked by uid 550); 27 Apr 2019 06:43:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1720 invoked from network); 27 Apr 2019 06:43:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fM02CdP3EHsEznyJ/zI3DVkvywjW2Y0W5QE/m/kGqS8=;
        b=Bic4fgDhw/zNUsH9AvCevjRRuqcBr7SeEwPi/mNBJHeVn3HWTtTQy0lqVBwB+uwJON
         033sEQUJVf4JsE8w16M+5haGmPR56gXJit7dknF2eDmFepylyOdGJlykH0b1NW+PihEa
         WnVuUa5XLxRLLr06QvgHjZbZbm6umZ2Z7Tk21XFYdu0XsSy3LVhSR76ovrEOyDS4RqXk
         ethcFURK2XAu1qKbwE8JJm/EyYlwhoXg4rc/DRAR47BR1Lx07vr+RFt4HZ8bItbsDTBV
         RxWJwnwgvwuNGmSEvPkHWRxMq59R7mUfHELo2gZLY6QtoYxwGmeesmwvk7AesQMYnBzh
         N2AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fM02CdP3EHsEznyJ/zI3DVkvywjW2Y0W5QE/m/kGqS8=;
        b=VHxpFdxynn/etpweZgpXu6L+D5B4qewZuFwqQW8TjQD9sp2nmSI8zUbrk8uVPmhHqy
         MbnhMJtqG1JPm8Q0TkXoghHdZ1wnkuEbZTN1nCmgVOv3jf8/5HpLUam8GYmXyEKsvFUb
         yWfsSoaa3xa+u3uwgWaZGj5JU08ALPCCjIJlyBzO4Y7jxcVM71MSk6eDnjIRtCn/tRaw
         dBLKZhro6jL5MgrjDfoFxzvDIZBGxSbH6jqP4RSkhzrV3cBZX1GjJT0otpzyphN4tNLD
         0aH7P4hyCfEfckdfXHzhcg+ePXm7kB9qhn4Ig6Z3ziKjh6uofu/9DrjcsWSD/F7h36nf
         Uuaw==
X-Gm-Message-State: APjAAAUJmfNvGrMVEIz2yDWinK+uK68TitR1PQbwI/vapEB9kYBaWqCX
	a1xAMTaaO7rbjkCFUh421yE=
X-Google-Smtp-Source: APXvYqxN6NLybNs8lwtcaE7rd9moWK47+PtSS3OruWZmc0YNonCQSY0zJUJKCwxGbV5SIYzeiwOfdw==
X-Received: by 2002:a17:902:d83:: with SMTP id 3mr52111624plv.125.1556347387028;
        Fri, 26 Apr 2019 23:43:07 -0700 (PDT)
From: nadav.amit@gmail.com
To: Peter Zijlstra <peterz@infradead.org>,
	Borislav Petkov <bp@alien8.de>,
	Andy Lutomirski <luto@kernel.org>,
	Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	hpa@zytor.com,
	Thomas Gleixner <tglx@linutronix.de>,
	Nadav Amit <nadav.amit@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux_dti@icloud.com,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	akpm@linux-foundation.org,
	kernel-hardening@lists.openwall.com,
	linux-mm@kvack.org,
	will.deacon@arm.com,
	ard.biesheuvel@linaro.org,
	kristen@linux.intel.com,
	deneen.t.dock@intel.com,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Kees Cook <keescook@chromium.org>,
	Dave Hansen <dave.hansen@intel.com>,
	Nadav Amit <namit@vmware.com>
Subject: [PATCH v6 03/24] x86/mm: Introduce temporary mm structs
Date: Fri, 26 Apr 2019 16:22:42 -0700
Message-Id: <20190426232303.28381-4-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190426232303.28381-1-nadav.amit@gmail.com>
References: <20190426232303.28381-1-nadav.amit@gmail.com>

From: Andy Lutomirski <luto@kernel.org>

Using a dedicated page-table for temporary PTEs prevents other cores
from using - even speculatively - these PTEs, thereby providing two
benefits:

(1) Security hardening: an attacker that gains kernel memory writing
abilities cannot easily overwrite sensitive data.

(2) Avoiding TLB shootdowns: the PTEs do not need to be flushed in
remote page-tables.

To do so a temporary mm_struct can be used. Mappings which are private
for this mm can be set in the userspace part of the address-space.
During the whole time in which the temporary mm is loaded, interrupts
must be disabled.

The first use-case for temporary mm struct, which will follow, is for
poking the kernel text.

[ Commit message was written by Nadav Amit ]

Cc: Kees Cook <keescook@chromium.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/mmu_context.h | 33 ++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 19d18fae6ec6..24dc3b810970 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -356,4 +356,37 @@ static inline unsigned long __get_current_cr3_fast(void)
 	return cr3;
 }
 
+typedef struct {
+	struct mm_struct *mm;
+} temp_mm_state_t;
+
+/*
+ * Using a temporary mm allows to set temporary mappings that are not accessible
+ * by other CPUs. Such mappings are needed to perform sensitive memory writes
+ * that override the kernel memory protections (e.g., W^X), without exposing the
+ * temporary page-table mappings that are required for these write operations to
+ * other CPUs. Using a temporary mm also allows to avoid TLB shootdowns when the
+ * mapping is torn down.
+ *
+ * Context: The temporary mm needs to be used exclusively by a single core. To
+ *          harden security IRQs must be disabled while the temporary mm is
+ *          loaded, thereby preventing interrupt handler bugs from overriding
+ *          the kernel memory protection.
+ */
+static inline temp_mm_state_t use_temporary_mm(struct mm_struct *mm)
+{
+	temp_mm_state_t temp_state;
+
+	lockdep_assert_irqs_disabled();
+	temp_state.mm = this_cpu_read(cpu_tlbstate.loaded_mm);
+	switch_mm_irqs_off(NULL, mm, current);
+	return temp_state;
+}
+
+static inline void unuse_temporary_mm(temp_mm_state_t prev_state)
+{
+	lockdep_assert_irqs_disabled();
+	switch_mm_irqs_off(NULL, prev_state.mm, current);
+}
+
 #endif /* _ASM_X86_MMU_CONTEXT_H */
-- 
2.17.1

