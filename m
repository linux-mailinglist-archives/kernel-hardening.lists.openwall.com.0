Return-Path: <kernel-hardening-return-15833-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0F4D3B2EF
	for <lists+kernel-hardening@lfdr.de>; Sat, 27 Apr 2019 08:46:37 +0200 (CEST)
Received: (qmail 5354 invoked by uid 550); 27 Apr 2019 06:43:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5215 invoked from network); 27 Apr 2019 06:43:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RkWBxdSztj8rR+UGwRQ8u46DAnXrPhDoGJsRNKYizGU=;
        b=sZ/qLuZJUAyo8qbKkeTMfaDU5l+q5915X9t7GRxTKJHbpjNKTHl8pciE33HsZyKxMj
         FHDGynPK6j9EMARDmUngJuJvUrJzSdZ856tWm7M07XqPW/SWzM6ZNX5zl88lma+UJQTP
         glz3jYPedES7CBs45n1TgBVlpwj8P8UlUX7TYH4J9CMC1SwMSQqAcgs/6v2TrFDCMTCc
         9+WmCz+Xk4CqkdBn0hJ5YGF1/DTIcg/k9CSmxM2My4drnNNp3ITpwY4FI+yvE/59hq2C
         LbPH5HAGU5SG85yKGAzKgHwuQvpQ2iezoip/gl/Zm0v6Wm0PDoU46D9nD3GQpDAmdtBS
         P0cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RkWBxdSztj8rR+UGwRQ8u46DAnXrPhDoGJsRNKYizGU=;
        b=KsgCb8YQgOLyQ2TyHmoUG+lEGT/nGJj9kLx87aoITD+Xuf5zu3OEUALjrJX024PqGo
         BbhjE8tSxj23errmAqPnDb68+Ihtbw8A2rMi5JXJRAI/p0odjWNXdlEnnqc+89od9JSY
         zOMCVYTTf6ZQayTFjdt2VBTLWVVJtT6Z3eAqPLFmXHJumUBDS4Rh88z5z59atwsbxim9
         0UlbRKzAxwUgfTA6ZcwJbvAtTcIgPfTTllnVjJMSN5WbeDQcwUhW3JECLIhsLnqAvnDh
         NoJh2rP+gd+7OTzVMr/gPDydnioPaaUFyu5RwjW/NN2jzPx4ulWAhNyoKhrH3YIq6662
         FI0A==
X-Gm-Message-State: APjAAAVFHJz8v8pXTeSn/OuU3jwvLBkynfceThkQslfZtNmLQyMKyuM8
	uTz17bgZgjG3CQEVtxYcuRU=
X-Google-Smtp-Source: APXvYqymwtMNRBHdVQWTPWr7iZe7bQ6p95NnoQCCbzB15xIf0gFL50JmokfCH/M9gUZzJVqeF2oaxg==
X-Received: by 2002:aa7:81d0:: with SMTP id c16mr50378631pfn.132.1556347404841;
        Fri, 26 Apr 2019 23:43:24 -0700 (PDT)
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
	Dave Hansen <dave.hansen@intel.com>,
	Masami Hiramatsu <mhiramat@kernel.org>
Subject: [PATCH v6 14/24] x86/alternative: Remove the return value of text_poke_*()
Date: Fri, 26 Apr 2019 16:22:53 -0700
Message-Id: <20190426232303.28381-15-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190426232303.28381-1-nadav.amit@gmail.com>
References: <20190426232303.28381-1-nadav.amit@gmail.com>

From: Nadav Amit <namit@vmware.com>

The return value of text_poke_early() and text_poke_bp() is useless.
Remove it.

Cc: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/text-patching.h |  4 ++--
 arch/x86/kernel/alternative.c        | 11 ++++-------
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/text-patching.h b/arch/x86/include/asm/text-patching.h
index a75eed841eed..c90678fd391a 100644
--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -18,7 +18,7 @@ static inline void apply_paravirt(struct paravirt_patch_site *start,
 #define __parainstructions_end	NULL
 #endif
 
-extern void *text_poke_early(void *addr, const void *opcode, size_t len);
+extern void text_poke_early(void *addr, const void *opcode, size_t len);
 
 /*
  * Clear and restore the kernel write-protection flag on the local CPU.
@@ -37,7 +37,7 @@ extern void *text_poke_early(void *addr, const void *opcode, size_t len);
 extern void *text_poke(void *addr, const void *opcode, size_t len);
 extern void *text_poke_kgdb(void *addr, const void *opcode, size_t len);
 extern int poke_int3_handler(struct pt_regs *regs);
-extern void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler);
+extern void text_poke_bp(void *addr, const void *opcode, size_t len, void *handler);
 extern int after_bootmem;
 extern __ro_after_init struct mm_struct *poking_mm;
 extern __ro_after_init unsigned long poking_addr;
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 3d2b6b6fb20c..18f959975ea0 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -265,7 +265,7 @@ static void __init_or_module add_nops(void *insns, unsigned int len)
 
 extern struct alt_instr __alt_instructions[], __alt_instructions_end[];
 extern s32 __smp_locks[], __smp_locks_end[];
-void *text_poke_early(void *addr, const void *opcode, size_t len);
+void text_poke_early(void *addr, const void *opcode, size_t len);
 
 /*
  * Are we looking at a near JMP with a 1 or 4-byte displacement.
@@ -667,8 +667,8 @@ void __init alternative_instructions(void)
  * instructions. And on the local CPU you need to be protected again NMI or MCE
  * handlers seeing an inconsistent instruction while you patch.
  */
-void *__init_or_module text_poke_early(void *addr, const void *opcode,
-				       size_t len)
+void __init_or_module text_poke_early(void *addr, const void *opcode,
+				      size_t len)
 {
 	unsigned long flags;
 
@@ -691,7 +691,6 @@ void *__init_or_module text_poke_early(void *addr, const void *opcode,
 		 * that causes hangs on some VIA CPUs.
 		 */
 	}
-	return addr;
 }
 
 __ro_after_init struct mm_struct *poking_mm;
@@ -893,7 +892,7 @@ NOKPROBE_SYMBOL(poke_int3_handler);
  *	  replacing opcode
  *	- sync cores
  */
-void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
+void text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
 {
 	unsigned char int3 = 0xcc;
 
@@ -935,7 +934,5 @@ void *text_poke_bp(void *addr, const void *opcode, size_t len, void *handler)
 	 * the writing of the new instruction.
 	 */
 	bp_patching_in_progress = false;
-
-	return addr;
 }
 
-- 
2.17.1

