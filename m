Return-Path: <kernel-hardening-return-15852-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 91E1FF5A0
	for <lists+kernel-hardening@lfdr.de>; Tue, 30 Apr 2019 13:30:42 +0200 (CEST)
Received: (qmail 21641 invoked by uid 550); 30 Apr 2019 11:30:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 7391 invoked from network); 30 Apr 2019 11:28:25 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x3UBRYXb1350369
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2019041745; t=1556623655;
	bh=3J+6Z6Kv0wPU0KZGkXia8Ke4yBkQoijiEqp8tgUmH0M=;
	h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
	b=sIwB0ZO/DpcNGCumGTBaXX/pYpm1GT0TwX/bZlZkV8H1TctbMr/RU3bKZ/hsSmdwM
	 SnBRJ4/krcn8ajKvDdtUYO8faNXCNd8IoMfmwRs4sWUWKl/afaS2/teeIrVO89GneC
	 shIPyyCJpoRrT4PVjnSyj+XtwQLcw16BLw6pIO93apHZMd0IYjzT2uA1Bbtq9EL4Zz
	 n8wQBvyL/k86TGzCByZvRxYe0C6tk5JQPcBwQ5789ZfA8ymvE+3TGTShVd1wnZWrt2
	 zwPfPMNoZIh0i2Ycib4gi6Bc9OMEsPjoFY0IGULunBIAcEFZnj9QCBCluLTP589Txp
	 8s3CrwkdL7Psg==
Date: Tue, 30 Apr 2019 04:27:33 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
Sender: tip tree robot <tipbot@zytor.com>
From: tip-bot for Rick Edgecombe <tipbot@zytor.com>
Message-ID: <tip-d53d2f78ceadba081fc7785570798c3c8d50a718@git.kernel.org>
Cc: peterz@infradead.org, daniel@iogearbox.net, will.deacon@arm.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        dave.hansen@linux.intel.com, bp@alien8.de, deneen.t.dock@intel.com,
        rick.p.edgecombe@intel.com, tglx@linutronix.de,
        kernel-hardening@lists.openwall.com, linux_dti@icloud.com,
        ard.biesheuvel@linaro.org, luto@kernel.org, mingo@kernel.org,
        hpa@zytor.com, riel@surriel.com, nadav.amit@gmail.com, ast@kernel.org,
        kristen@linux.intel.com, linux-kernel@vger.kernel.org
In-Reply-To: <20190426001143.4983-19-namit@vmware.com>
References: <20190426001143.4983-19-namit@vmware.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] bpf: Use vmalloc special flag
Git-Commit-ID: d53d2f78ceadba081fc7785570798c3c8d50a718
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from
 these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,BAYES_00,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	FREEMAIL_FORGED_REPLYTO,T_DATE_IN_FUTURE_96_Q autolearn=no
	autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on terminus.zytor.com

Commit-ID:  d53d2f78ceadba081fc7785570798c3c8d50a718
Gitweb:     https://git.kernel.org/tip/d53d2f78ceadba081fc7785570798c3c8d50a718
Author:     Rick Edgecombe <rick.p.edgecombe@intel.com>
AuthorDate: Thu, 25 Apr 2019 17:11:38 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2019 12:37:59 +0200

bpf: Use vmalloc special flag

Use new flag VM_FLUSH_RESET_PERMS for handling freeing of special
permissioned memory in vmalloc and remove places where memory was set RW
before freeing which is no longer needed. Don't track if the memory is RO
anymore because it is now tracked in vmalloc.

Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <akpm@linux-foundation.org>
Cc: <ard.biesheuvel@linaro.org>
Cc: <deneen.t.dock@intel.com>
Cc: <kernel-hardening@lists.openwall.com>
Cc: <kristen@linux.intel.com>
Cc: <linux_dti@icloud.com>
Cc: <will.deacon@arm.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nadav Amit <nadav.amit@gmail.com>
Cc: Rik van Riel <riel@surriel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190426001143.4983-19-namit@vmware.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
