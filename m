Return-Path: <kernel-hardening-return-15838-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id AF5D9B2F4
	for <lists+kernel-hardening@lfdr.de>; Sat, 27 Apr 2019 08:47:45 +0200 (CEST)
Received: (qmail 5860 invoked by uid 550); 27 Apr 2019 06:43:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5680 invoked from network); 27 Apr 2019 06:43:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=03x8MyH4ONo6RL8TDAuJcYQYBUTk8Xfu5EMEl5vv8zs=;
        b=Q470hKxCA0zkhL+IQMRmPe5UQg42Gi+l2RRmW947taZyL//Jesf10pqg7iknajn5cM
         6MahwRUBormFC9ROtXZzOCBPO1osFE8XuHCncIgLvsCHxLcNuXntyLIPTNUxNKWwnbuS
         YivKpxFXT45f055xbj7gqKyZeZCL6izznlo4y+QcynGiNpgPJSJn6cIDoQUEWR8q3NIV
         QQ28y5mhdxTCv3ZGyzW3vgvH+5eRIAil3M9uo1sFkym+2/eXjUEbYhGGuoRIn6PGQ204
         szqozT+L1TEHgWXr+gjrabBNVx0fQWsxwFBogU0RCWe7qqaev2wbboj0cmVtOcpDQP9M
         I7SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=03x8MyH4ONo6RL8TDAuJcYQYBUTk8Xfu5EMEl5vv8zs=;
        b=NBjXLgr4g1hFQ9fygVdhfLVjqFpBh6x3hRpd1s78vtj1il6G6qiXolf/9ZNOI1lViH
         /oCOfBIYu6HapzG7bSE9Pl/5SsaAMQqA9pPpPVh7NQSDIbnTEN4Haokic2KdJWRrEApW
         45OLRM/fBHATgFIowWUk/eE6GlIXIAsUnQJtlMXN9AwwX6cYc/pzyDUZwulXWaHccS+2
         fIPdHqMLUYH/iwz1aj8dXfQcKFUNCzEpOBPTHFQy0M7v5GZq+UIpUCCb0T/vtZN7AvFC
         ImnDL225tAoNwTDBjROHUky6x68SGqnSDlQBJOrbPlOrGHgMtREEga9lNys8bF1EJW+I
         wWlA==
X-Gm-Message-State: APjAAAVq0fXOZJa1zdIJRt7or5s3+ieW72AiEqQcl4Y7KLyJd3W8aFCF
	h2lrImlbiUXViX4iHLwvGDQ=
X-Google-Smtp-Source: APXvYqwS9mBb6vrC0DhVyMmyRT5ZRdKwezrJErmAVG/FEmt+6AsmQkMSAz9lRez80K2MggQYstDNlg==
X-Received: by 2002:a17:902:bd0c:: with SMTP id p12mr17355851pls.50.1556347411683;
        Fri, 26 Apr 2019 23:43:31 -0700 (PDT)
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
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH v6 19/24] bpf: Use vmalloc special flag
Date: Fri, 26 Apr 2019 16:22:58 -0700
Message-Id: <20190426232303.28381-20-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190426232303.28381-1-nadav.amit@gmail.com>
References: <20190426232303.28381-1-nadav.amit@gmail.com>

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

Use new flag VM_FLUSH_RESET_PERMS for handling freeing of special
permissioned memory in vmalloc and remove places where memory was set RW
before freeing which is no longer needed. Don't track if the memory is RO
anymore because it is now tracked in vmalloc.

Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 include/linux/filter.h | 17 +++--------------
 kernel/bpf/core.c      |  1 -
 2 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/include/linux/filter.h b/include/linux/filter.h
index 14ec3bdad9a9..7d3abde3f183 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -20,6 +20,7 @@
 #include <linux/set_memory.h>
 #include <linux/kallsyms.h>
 #include <linux/if_vlan.h>
+#include <linux/vmalloc.h>
 
 #include <net/sch_generic.h>
 
@@ -503,7 +504,6 @@ struct bpf_prog {
 	u16			pages;		/* Number of allocated pages */
 	u16			jited:1,	/* Is our filter JIT'ed? */
 				jit_requested:1,/* archs need to JIT the prog */
-				undo_set_mem:1,	/* Passed set_memory_ro() checkpoint */
 				gpl_compatible:1, /* Is filter GPL compatible? */
 				cb_access:1,	/* Is control block accessed? */
 				dst_needed:1,	/* Do we need dst entry? */
@@ -733,27 +733,17 @@ bpf_ctx_narrow_access_ok(u32 off, u32 size, u32 size_default)
 
 static inline void bpf_prog_lock_ro(struct bpf_prog *fp)
 {
-	fp->undo_set_mem = 1;
+	set_vm_flush_reset_perms(fp);
 	set_memory_ro((unsigned long)fp, fp->pages);
 }
 
-static inline void bpf_prog_unlock_ro(struct bpf_prog *fp)
-{
-	if (fp->undo_set_mem)
-		set_memory_rw((unsigned long)fp, fp->pages);
-}
-
 static inline void bpf_jit_binary_lock_ro(struct bpf_binary_header *hdr)
 {
+	set_vm_flush_reset_perms(hdr);
 	set_memory_ro((unsigned long)hdr, hdr->pages);
 	set_memory_x((unsigned long)hdr, hdr->pages);
 }
 
-static inline void bpf_jit_binary_unlock_ro(struct bpf_binary_header *hdr)
-{
-	set_memory_rw((unsigned long)hdr, hdr->pages);
-}
-
 static inline struct bpf_binary_header *
 bpf_jit_binary_hdr(const struct bpf_prog *fp)
 {
@@ -789,7 +779,6 @@ void __bpf_prog_free(struct bpf_prog *fp);
 
 static inline void bpf_prog_unlock_free(struct bpf_prog *fp)
 {
-	bpf_prog_unlock_ro(fp);
 	__bpf_prog_free(fp);
 }
 
diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index ff09d32a8a1b..c605397c79f0 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -848,7 +848,6 @@ void __weak bpf_jit_free(struct bpf_prog *fp)
 	if (fp->jited) {
 		struct bpf_binary_header *hdr = bpf_jit_binary_hdr(fp);
 
-		bpf_jit_binary_unlock_ro(hdr);
 		bpf_jit_binary_free(hdr);
 
 		WARN_ON_ONCE(!bpf_prog_kallsyms_verify_off(fp));
-- 
2.17.1

