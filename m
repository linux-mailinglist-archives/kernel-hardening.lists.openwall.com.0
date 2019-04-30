Return-Path: <kernel-hardening-return-15861-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id CA3D1F5AF
	for <lists+kernel-hardening@lfdr.de>; Tue, 30 Apr 2019 13:32:52 +0200 (CEST)
Received: (qmail 27674 invoked by uid 550); 30 Apr 2019 11:31:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 14096 invoked from network); 30 Apr 2019 11:21:13 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x3UBKijg1347492
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2019041745; t=1556623245;
	bh=C3t0slo8rzkJUyCXpbSIjvhOc4r5emWnLyOAWlZs5yE=;
	h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
	b=oP4zRwJ1czyBEH/vhk20eXQZMX4bvYf/RyvH0pwHj+FatGAIki+jZf7iKUXseE0+g
	 MmwvV3v6VShRpqHdTi4crfvklL9M8oMScw//xnGmZ4FZBv57s6OwjIBdUTChBQhegZ
	 xrd2drw0VE7S6xl0pGcc2zXYjycv4vU9tBGVi8CEpjkjeo51+b6gwwXJEWyA98qWyC
	 DXbonRhXXR7+kWfRcn8+0EtJZ97P3YRkSD6CtUYh0Oxz3HI4vzFmuQjbexLXBqmbdN
	 bSTWJQUAC2a35+xMFha0zPYYYtYk0wXkqTy5XsmIz9QxYlkVNHpOZTU+ylmhQB1Uwf
	 Nyb67qOnaaoew==
Date: Tue, 30 Apr 2019 04:20:43 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
Sender: tip tree robot <tipbot@zytor.com>
From: tip-bot for Nadav Amit <tipbot@zytor.com>
Message-ID: <tip-86a22057127d1c0462a18901421bf1ff89491392@git.kernel.org>
Cc: linux_dti@icloud.com, kristen@linux.intel.com, bp@alien8.de,
        deneen.t.dock@intel.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, akpm@linux-foundation.org, riel@surriel.com,
        namit@vmware.com, mingo@kernel.org, rick.p.edgecombe@intel.com,
        tglx@linutronix.de, dave.hansen@linux.intel.com,
        ard.biesheuvel@linaro.org, hpa@zytor.com,
        torvalds@linux-foundation.org, luto@kernel.org, will.deacon@arm.com,
        kernel-hardening@lists.openwall.com
In-Reply-To: <20190426001143.4983-9-namit@vmware.com>
References: <20190426001143.4983-9-namit@vmware.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/kgdb: Avoid redundant comparison of patched code
Git-Commit-ID: 86a22057127d1c0462a18901421bf1ff89491392
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

Commit-ID:  86a22057127d1c0462a18901421bf1ff89491392
Gitweb:     https://git.kernel.org/tip/86a22057127d1c0462a18901421bf1ff89491392
Author:     Nadav Amit <namit@vmware.com>
AuthorDate: Thu, 25 Apr 2019 17:11:28 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2019 12:37:53 +0200

x86/kgdb: Avoid redundant comparison of patched code

text_poke() already ensures that the written value is the correct one
and fails if that is not the case. There is no need for an additional
comparison. Remove it.

Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: <akpm@linux-foundation.org>
Cc: <ard.biesheuvel@linaro.org>
Cc: <deneen.t.dock@intel.com>
Cc: <kernel-hardening@lists.openwall.com>
Cc: <kristen@linux.intel.com>
Cc: <linux_dti@icloud.com>
Cc: <will.deacon@arm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190426001143.4983-9-namit@vmware.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/kgdb.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 2b203ee5b879..13b13311b792 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -747,7 +747,6 @@ void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
 int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
 {
 	int err;
-	char opc[BREAK_INSTR_SIZE];
 
 	bpt->type = BP_BREAKPOINT;
 	err = probe_kernel_read(bpt->saved_instr, (char *)bpt->bpt_addr,
@@ -766,11 +765,6 @@ int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
 		return -EBUSY;
 	text_poke_kgdb((void *)bpt->bpt_addr, arch_kgdb_ops.gdb_bpt_instr,
 		       BREAK_INSTR_SIZE);
-	err = probe_kernel_read(opc, (char *)bpt->bpt_addr, BREAK_INSTR_SIZE);
-	if (err)
-		return err;
-	if (memcmp(opc, arch_kgdb_ops.gdb_bpt_instr, BREAK_INSTR_SIZE))
-		return -EINVAL;
 	bpt->type = BP_POKE_BREAKPOINT;
 
 	return err;
@@ -778,9 +772,6 @@ int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
 
 int kgdb_arch_remove_breakpoint(struct kgdb_bkpt *bpt)
 {
-	int err;
-	char opc[BREAK_INSTR_SIZE];
-
 	if (bpt->type != BP_POKE_BREAKPOINT)
 		goto knl_write;
 	/*
@@ -791,10 +782,7 @@ int kgdb_arch_remove_breakpoint(struct kgdb_bkpt *bpt)
 		goto knl_write;
 	text_poke_kgdb((void *)bpt->bpt_addr, bpt->saved_instr,
 		       BREAK_INSTR_SIZE);
-	err = probe_kernel_read(opc, (char *)bpt->bpt_addr, BREAK_INSTR_SIZE);
-	if (err || memcmp(opc, bpt->saved_instr, BREAK_INSTR_SIZE))
-		goto knl_write;
-	return err;
+	return 0;
 
 knl_write:
 	return probe_kernel_write((char *)bpt->bpt_addr,
