Return-Path: <kernel-hardening-return-15826-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 896D3B2E8
	for <lists+kernel-hardening@lfdr.de>; Sat, 27 Apr 2019 08:45:00 +0200 (CEST)
Received: (qmail 3392 invoked by uid 550); 27 Apr 2019 06:43:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3259 invoked from network); 27 Apr 2019 06:43:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ZPFv6m+iH8EeSMp9wFrys9PGKYZJjpGjv1/CHTAfS5M=;
        b=p4m/oBqSG6KLPf+AqtV3OdSRGsnlwAcOGjTsQ1oMvTgRjsaBLxL2oqlvHbnUOD7DhC
         llMjaQPUwxdsPmzYP1Xk4zg6iskJI0V3bcjSumFgJeyn32g+AQyeuwbnaKNcunnSGV+X
         jFrW4YEgTD0CVzhuajD3RiuuFodFK5pQf/h/OASbcijhEUNJeR4GOVIaxGkMApARhJuz
         heZkZxY0ibC3WGtyGA9X5OpN8Qanr6vPnIs32DNHYf97D5Hp43Bu1zzc+18KCpllyi2H
         mACL4axXMqmHb8f85O6m0qGesKiJyaJ8E2Q7anmXlyeLMnsiSJBU8Ye4Tm8bsUaDuaL0
         //Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ZPFv6m+iH8EeSMp9wFrys9PGKYZJjpGjv1/CHTAfS5M=;
        b=apWAtdTALB+WaNoWYicdaCfyyZG+WIBcj2Xn6x8tYoqCO3MZ6ZvzjpCCWskOY+6d7I
         O1TPGtfMWiu4u1zKPPouhe/Vz139K2/UEyYnFAzzaMsfeamRJKNG/Wc/x+5Ljot057B/
         KAbZ8HAZRzwVzYsXT+VxAbyVOELVq0f22nl082ZuHL/wNW2V5dz33CTpxKfjS6jjyjXn
         mceSMZYCi8mzBW+nc9ZFL3xJXOtiJM1V0Hm93zRo6SPkIFHeRqF3Ium97hOHYUdQJeq5
         CA+2qLZHA/tAOw140uUZ1hHTggzQRzQlb4XQxh3j1uJYhBFqQoXlFzW2+eNyZuQ3+aLz
         6oMA==
X-Gm-Message-State: APjAAAVcmfwPrhpONkQ70UkXXFZ5agtUkMi1PG3JGMOyOeUteT2pLGlZ
	v5uyXlAzRrqKIZYA/LL1PoQ=
X-Google-Smtp-Source: APXvYqyVtXk5iHrU+w85KghleSi1h9IdIHLthG9HVX8BbnAS3s4DC3QPi8s9GkBRV20LWDs74Eyk7w==
X-Received: by 2002:a63:1359:: with SMTP id 25mr46901248pgt.92.1556347393845;
        Fri, 26 Apr 2019 23:43:13 -0700 (PDT)
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
	Nadav Amit <namit@vmware.com>,
	Kees Cook <keescook@chromium.org>,
	Dave Hansen <dave.hansen@intel.com>
Subject: [PATCH v6 07/24] x86/alternative: Initialize temporary mm for patching
Date: Fri, 26 Apr 2019 16:22:46 -0700
Message-Id: <20190426232303.28381-8-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190426232303.28381-1-nadav.amit@gmail.com>
References: <20190426232303.28381-1-nadav.amit@gmail.com>

From: Nadav Amit <namit@vmware.com>

To prevent improper use of the PTEs that are used for text patching, the
next patches will use a temporary mm struct. Initailize it by copying
the init mm.

The address that will be used for patching is taken from the lower area
that is usually used for the task memory. Doing so prevents the need to
frequently synchronize the temporary-mm (e.g., when BPF programs are
installed), since different PGDs are used for the task memory.

Finally, randomize the address of the PTEs to harden against exploits
that use these PTEs.

Cc: Kees Cook <keescook@chromium.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Masami Hiramatsu <mhiramat@kernel.org>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/pgtable.h       |  3 +++
 arch/x86/include/asm/text-patching.h |  2 ++
 arch/x86/kernel/alternative.c        |  3 +++
 arch/x86/mm/init.c                   | 37 ++++++++++++++++++++++++++++
 init/main.c                          |  3 +++
 5 files changed, 48 insertions(+)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 5cfbbb6d458d..6b6bfdfe83aa 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1038,6 +1038,9 @@ static inline void __meminit init_trampoline_default(void)
 	/* Default trampoline pgd value */
 	trampoline_pgd_entry = init_top_pgt[pgd_index(__PAGE_OFFSET)];
 }
+
+void __init poking_init(void);
+
 # ifdef CONFIG_RANDOMIZE_MEMORY
 void __meminit init_trampoline(void);
 # else
diff --git a/arch/x86/include/asm/text-patching.h b/arch/x86/include/asm/text-patching.h
index f8fc8e86cf01..a75eed841eed 100644
--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -39,5 +39,7 @@ extern void *text_poke_kgdb(void *addr, const void *opcode, size_t len);
 extern int poke_int3_handler(struct pt_regs *regs);
 extern void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler);
 extern int after_bootmem;
+extern __ro_after_init struct mm_struct *poking_mm;
+extern __ro_after_init unsigned long poking_addr;
 
 #endif /* _ASM_X86_TEXT_PATCHING_H */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 0a814d73547a..11d5c710a94f 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -679,6 +679,9 @@ void *__init_or_module text_poke_early(void *addr, const void *opcode,
 	return addr;
 }
 
+__ro_after_init struct mm_struct *poking_mm;
+__ro_after_init unsigned long poking_addr;
+
 static void *__text_poke(void *addr, const void *opcode, size_t len)
 {
 	unsigned long flags;
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index f905a2371080..c25bb00955db 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -22,6 +22,7 @@
 #include <asm/hypervisor.h>
 #include <asm/cpufeature.h>
 #include <asm/pti.h>
+#include <asm/text-patching.h>
 
 /*
  * We need to define the tracepoints somewhere, and tlb.c
@@ -700,6 +701,42 @@ void __init init_mem_mapping(void)
 	early_memtest(0, max_pfn_mapped << PAGE_SHIFT);
 }
 
+/*
+ * Initialize an mm_struct to be used during poking and a pointer to be used
+ * during patching.
+ */
+void __init poking_init(void)
+{
+	spinlock_t *ptl;
+	pte_t *ptep;
+
+	pr_err("%s\n", __func__);
+	poking_mm = copy_init_mm();
+	BUG_ON(!poking_mm);
+
+	/*
+	 * Randomize the poking address, but make sure that the following page
+	 * will be mapped at the same PMD. We need 2 pages, so find space for 3,
+	 * and adjust the address if the PMD ends after the first one.
+	 */
+	poking_addr = TASK_UNMAPPED_BASE;
+	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE))
+		poking_addr += (kaslr_get_random_long("Poking") & PAGE_MASK) %
+			(TASK_SIZE - TASK_UNMAPPED_BASE - 3 * PAGE_SIZE);
+
+	if (((poking_addr + PAGE_SIZE) & ~PMD_MASK) == 0)
+		poking_addr += PAGE_SIZE;
+
+	/*
+	 * We need to trigger the allocation of the page-tables that will be
+	 * needed for poking now. Later, poking may be performed in an atomic
+	 * section, which might cause allocation to fail.
+	 */
+	ptep = get_locked_pte(poking_mm, poking_addr, &ptl);
+	BUG_ON(!ptep);
+	pte_unmap_unlock(ptep, ptl);
+}
+
 /*
  * devmem_is_allowed() checks to see if /dev/mem access to a certain address
  * is valid. The argument is a physical page number.
diff --git a/init/main.c b/init/main.c
index 598e278b46f7..949eed8015ec 100644
--- a/init/main.c
+++ b/init/main.c
@@ -504,6 +504,8 @@ void __init __weak thread_stack_cache_init(void)
 
 void __init __weak mem_encrypt_init(void) { }
 
+void __init __weak poking_init(void) { }
+
 bool initcall_debug;
 core_param(initcall_debug, initcall_debug, bool, 0644);
 
@@ -737,6 +739,7 @@ asmlinkage __visible void __init start_kernel(void)
 	taskstats_init_early();
 	delayacct_init();
 
+	poking_init();
 	check_bugs();
 
 	acpi_subsystem_init();
-- 
2.17.1

