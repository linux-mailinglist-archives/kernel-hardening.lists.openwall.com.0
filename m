Return-Path: <kernel-hardening-return-19721-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 510CC25CA59
	for <lists+kernel-hardening@lfdr.de>; Thu,  3 Sep 2020 22:31:31 +0200 (CEST)
Received: (qmail 17595 invoked by uid 550); 3 Sep 2020 20:31:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17493 invoked from network); 3 Sep 2020 20:31:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Wz9KEqPe6jynvYZUGVwJeRVVfJ6wC2gosaUL7BUwAA8=;
        b=r6if3o8knJySaJfoQ4JTngFUI0d1h6vp5qLxz+Vvlc8q1cbeT5KkqtSOVWg7ghFfQV
         qsMG7kKX9nNp1jnuolNpkrvj9xT183rdg77MJJBWQgGF5csZOMvL+2NyKRIdITpZuiaB
         aMoTZEyAcj84fqVuNMqyTh/tD9qLUaPUgC9twAC5d7Kdh6bPIQBWLn/6fQPd3H+tBLIS
         BHX9rtxDfsQSWDSPW1p36oUHIyzyQDklpIkkB7aCEYC6BbMCgcOM/tjTbDaj/3jq2r+b
         YRmbX2nQcBS9pgUkuhLEj0IiOREm6aVewLODSFBUooZ+BFlVjDMARblfxZE/gz5AgH8E
         PfQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Wz9KEqPe6jynvYZUGVwJeRVVfJ6wC2gosaUL7BUwAA8=;
        b=oAK7ns6DM1CuKn0b4e+FhrNNbKoUI+Yn4l9GubDUPxS0uCMwMB2NMwfPZJJXsfXopa
         9LVgYUVNSPO0R6ck1XX3RcFWlnKMd37l/hiGkUtQS42h7V0JlmJVH51dbMlS2IwSk9KA
         cqG7PRak/rEA8hsaedirLg7DKUEmHVkQsC8Js+WEmStpsO8RFJ0ZeKZjtmMBEOw0CC0n
         UV5GwlQduC+ZFFztu/A8Ao5S4HN7ntm7n7bC9eA+g9VTyxQh8twVAlP2KJ02HudvMEV2
         dLLSf5ZG/tjcb35Z/QNg+EuJEOHKKW+uUDOMpA4jANdhmCZm+5xUyw6rFfym4X883n8W
         RjeA==
X-Gm-Message-State: AOAM530WzMhc4hy+URjW+EL/dgszYY0lb0SzeZVeJ0g5kctMVTUO5bH5
	0lvzUM0u/q9KKnGI/fPUiEkmDAzTSfGCpte8Rx8=
X-Google-Smtp-Source: ABdhPJx1LZYXiaw/GwusQ9gBkXNPhAc7NSMNU+Bf/gMurElFCbaIO17NmgnX7OhagTFary4oUp+SEuBx/fIdC4iS/ag=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a62:14c5:0:b029:13c:1611:658a with
 SMTP id 188-20020a6214c50000b029013c1611658amr3803962pfu.7.1599165058704;
 Thu, 03 Sep 2020 13:30:58 -0700 (PDT)
Date: Thu,  3 Sep 2020 13:30:27 -0700
In-Reply-To: <20200903203053.3411268-1-samitolvanen@google.com>
Message-Id: <20200903203053.3411268-3-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com> <20200903203053.3411268-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH v2 02/28] x86/asm: Replace __force_order with memory clobber
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Arvind Sankar <nivedita@alum.mit.edu>
Content-Type: text/plain; charset="UTF-8"

From: Arvind Sankar <nivedita@alum.mit.edu>

The CRn accessor functions use __force_order as a dummy operand to
prevent the compiler from reordering CRn reads/writes with respect to
each other.

The fact that the asm is volatile should be enough to prevent this:
volatile asm statements should be executed in program order. However GCC
4.9.x and 5.x have a bug that might result in reordering. This was fixed
in 8.1, 7.3 and 6.5. Versions prior to these, including 5.x and 4.9.x,
may reorder volatile asm statements with respect to each other.

There are some issues with __force_order as implemented:
- It is used only as an input operand for the write functions, and hence
  doesn't do anything additional to prevent reordering writes.
- It allows memory accesses to be cached/reordered across write
  functions, but CRn writes affect the semantics of memory accesses, so
  this could be dangerous.
- __force_order is not actually defined in the kernel proper, but the
  LLVM toolchain can in some cases require a definition: LLVM (as well
  as GCC 4.9) requires it for PIE code, which is why the compressed
  kernel has a definition, but also the clang integrated assembler may
  consider the address of __force_order to be significant, resulting in
  a reference that requires a definition.

Fix this by:
- Using a memory clobber for the write functions to additionally prevent
  caching/reordering memory accesses across CRn writes.
- Using a dummy input operand with an arbitrary constant address for the
  read functions, instead of a global variable. This will prevent reads
  from being reordered across writes, while allowing memory loads to be
  cached/reordered across CRn reads, which should be safe.

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
Tested-by: Nathan Chancellor <natechancellor@gmail.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=82602
Link: https://lore.kernel.org/lkml/20200527135329.1172644-1-arnd@arndb.de/
---
 arch/x86/boot/compressed/pgtable_64.c |  9 ---------
 arch/x86/include/asm/special_insns.h  | 28 ++++++++++++++-------------
 arch/x86/kernel/cpu/common.c          |  4 ++--
 3 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/arch/x86/boot/compressed/pgtable_64.c b/arch/x86/boot/compressed/pgtable_64.c
index c8862696a47b..7d0394f4ebf9 100644
--- a/arch/x86/boot/compressed/pgtable_64.c
+++ b/arch/x86/boot/compressed/pgtable_64.c
@@ -5,15 +5,6 @@
 #include "pgtable.h"
 #include "../string.h"
 
-/*
- * __force_order is used by special_insns.h asm code to force instruction
- * serialization.
- *
- * It is not referenced from the code, but GCC < 5 with -fPIE would fail
- * due to an undefined symbol. Define it to make these ancient GCCs work.
- */
-unsigned long __force_order;
-
 #define BIOS_START_MIN		0x20000U	/* 128K, less than this is insane */
 #define BIOS_START_MAX		0x9f000U	/* 640K, absolute maximum */
 
diff --git a/arch/x86/include/asm/special_insns.h b/arch/x86/include/asm/special_insns.h
index 59a3e13204c3..d6e3bb9363d2 100644
--- a/arch/x86/include/asm/special_insns.h
+++ b/arch/x86/include/asm/special_insns.h
@@ -11,45 +11,47 @@
 #include <linux/jump_label.h>
 
 /*
- * Volatile isn't enough to prevent the compiler from reordering the
- * read/write functions for the control registers and messing everything up.
- * A memory clobber would solve the problem, but would prevent reordering of
- * all loads stores around it, which can hurt performance. Solution is to
- * use a variable and mimic reads and writes to it to enforce serialization
+ * The compiler should not reorder volatile asm statements with respect to each
+ * other: they should execute in program order. However GCC 4.9.x and 5.x have
+ * a bug (which was fixed in 8.1, 7.3 and 6.5) where they might reorder
+ * volatile asm. The write functions are not affected since they have memory
+ * clobbers preventing reordering. To prevent reads from being reordered with
+ * respect to writes, use a dummy memory operand.
  */
-extern unsigned long __force_order;
+
+#define __FORCE_ORDER "m"(*(unsigned int *)0x1000UL)
 
 void native_write_cr0(unsigned long val);
 
 static inline unsigned long native_read_cr0(void)
 {
 	unsigned long val;
-	asm volatile("mov %%cr0,%0\n\t" : "=r" (val), "=m" (__force_order));
+	asm volatile("mov %%cr0,%0\n\t" : "=r" (val) : __FORCE_ORDER);
 	return val;
 }
 
 static __always_inline unsigned long native_read_cr2(void)
 {
 	unsigned long val;
-	asm volatile("mov %%cr2,%0\n\t" : "=r" (val), "=m" (__force_order));
+	asm volatile("mov %%cr2,%0\n\t" : "=r" (val) : __FORCE_ORDER);
 	return val;
 }
 
 static __always_inline void native_write_cr2(unsigned long val)
 {
-	asm volatile("mov %0,%%cr2": : "r" (val), "m" (__force_order));
+	asm volatile("mov %0,%%cr2": : "r" (val) : "memory");
 }
 
 static inline unsigned long __native_read_cr3(void)
 {
 	unsigned long val;
-	asm volatile("mov %%cr3,%0\n\t" : "=r" (val), "=m" (__force_order));
+	asm volatile("mov %%cr3,%0\n\t" : "=r" (val) : __FORCE_ORDER);
 	return val;
 }
 
 static inline void native_write_cr3(unsigned long val)
 {
-	asm volatile("mov %0,%%cr3": : "r" (val), "m" (__force_order));
+	asm volatile("mov %0,%%cr3": : "r" (val) : "memory");
 }
 
 static inline unsigned long native_read_cr4(void)
@@ -64,10 +66,10 @@ static inline unsigned long native_read_cr4(void)
 	asm volatile("1: mov %%cr4, %0\n"
 		     "2:\n"
 		     _ASM_EXTABLE(1b, 2b)
-		     : "=r" (val), "=m" (__force_order) : "0" (0));
+		     : "=r" (val) : "0" (0), __FORCE_ORDER);
 #else
 	/* CR4 always exists on x86_64. */
-	asm volatile("mov %%cr4,%0\n\t" : "=r" (val), "=m" (__force_order));
+	asm volatile("mov %%cr4,%0\n\t" : "=r" (val) : __FORCE_ORDER);
 #endif
 	return val;
 }
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index c5d6f17d9b9d..178499f90366 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -359,7 +359,7 @@ void native_write_cr0(unsigned long val)
 	unsigned long bits_missing = 0;
 
 set_register:
-	asm volatile("mov %0,%%cr0": "+r" (val), "+m" (__force_order));
+	asm volatile("mov %0,%%cr0": "+r" (val) : : "memory");
 
 	if (static_branch_likely(&cr_pinning)) {
 		if (unlikely((val & X86_CR0_WP) != X86_CR0_WP)) {
@@ -378,7 +378,7 @@ void native_write_cr4(unsigned long val)
 	unsigned long bits_changed = 0;
 
 set_register:
-	asm volatile("mov %0,%%cr4": "+r" (val), "+m" (cr4_pinned_bits));
+	asm volatile("mov %0,%%cr4": "+r" (val) : : "memory");
 
 	if (static_branch_likely(&cr_pinning)) {
 		if (unlikely((val & cr4_pinned_mask) != cr4_pinned_bits)) {
-- 
2.28.0.402.g5ffc5be6b7-goog

