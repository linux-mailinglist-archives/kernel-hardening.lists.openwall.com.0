Return-Path: <kernel-hardening-return-15860-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D0F4BF5BA
	for <lists+kernel-hardening@lfdr.de>; Tue, 30 Apr 2019 13:33:22 +0200 (CEST)
Received: (qmail 27652 invoked by uid 550); 30 Apr 2019 11:31:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 15613 invoked from network); 30 Apr 2019 11:22:21 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x3UBLOdF1347765
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2019041745; t=1556623285;
	bh=MXsBRDRKJauN6z5k6R/bDOZGULB2Ad+70N9h6P0ENtM=;
	h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
	b=wIbco+kaQEDNXehFk4GA8CAk2aOIV243zICGlYMC2RNLL3oYzybyEKRpqJv1/uYmI
	 s5wmqxv/JbdeCxyuOj4TkvLRaXFPy+4XJFOHy/j1zTupASaYNktOYkJgsCbYjaZGDB
	 Q9o+s9+fTMz3lUbojDi43QnrFR3y/66WOOXx48bFUG7NAXj/lOiu89NbN7OGSj3hpT
	 2YxT0eIrwjRgQO8onIu0AFuQc+odnovb3Nd8CgEJEj0muP3+aiA5cmiUUT8mzdjUYZ
	 8cYPh8vgEkWnvfmPq4mKYGs+5sUmaSH1+NOrtnBvEBbGLva/TLHPtqFiqE5EfH7f6p
	 M3Dai51YDslBw==
Date: Tue, 30 Apr 2019 04:21:23 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
Sender: tip tree robot <tipbot@zytor.com>
From: tip-bot for Nadav Amit <tipbot@zytor.com>
Message-ID: <tip-3c0dab44e22782359a0a706cbce72de99a22aa75@git.kernel.org>
Cc: bp@alien8.de, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com, luto@kernel.org,
        ard.biesheuvel@linaro.org, akpm@linux-foundation.org,
        linux_dti@icloud.com, dave.hansen@linux.intel.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, rick.p.edgecombe@intel.com,
        will.deacon@arm.com, rostedt@goodmis.org, namit@vmware.com,
        deneen.t.dock@intel.com, kristen@linux.intel.com, peterz@infradead.org,
        mingo@kernel.org, hpa@zytor.com, riel@surriel.com
In-Reply-To: <20190426001143.4983-10-namit@vmware.com>
References: <20190426001143.4983-10-namit@vmware.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/ftrace: Set trampoline pages as executable
Git-Commit-ID: 3c0dab44e22782359a0a706cbce72de99a22aa75
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

Commit-ID:  3c0dab44e22782359a0a706cbce72de99a22aa75
Gitweb:     https://git.kernel.org/tip/3c0dab44e22782359a0a706cbce72de99a22aa75
Author:     Nadav Amit <namit@vmware.com>
AuthorDate: Thu, 25 Apr 2019 17:11:29 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2019 12:37:53 +0200

x86/ftrace: Set trampoline pages as executable

Since alloc_module() will not set the pages as executable soon, set
ftrace trampoline pages as executable after they are allocated.

For the time being, do not change ftrace to use the text_poke()
interface. As a result, ftrace still breaks W^X.

Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
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
Link: https://lkml.kernel.org/r/20190426001143.4983-10-namit@vmware.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/ftrace.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index ef49517f6bb2..53ba1aa3a01f 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -730,6 +730,7 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 	unsigned long end_offset;
 	unsigned long op_offset;
 	unsigned long offset;
+	unsigned long npages;
 	unsigned long size;
 	unsigned long retq;
 	unsigned long *ptr;
@@ -762,6 +763,7 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 		return 0;
 
 	*tramp_size = size + RET_SIZE + sizeof(void *);
+	npages = DIV_ROUND_UP(*tramp_size, PAGE_SIZE);
 
 	/* Copy ftrace_caller onto the trampoline memory */
 	ret = probe_kernel_read(trampoline, (void *)start_offset, size);
@@ -806,6 +808,12 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 	/* ALLOC_TRAMP flags lets us know we created it */
 	ops->flags |= FTRACE_OPS_FL_ALLOC_TRAMP;
 
+	/*
+	 * Module allocation needs to be completed by making the page
+	 * executable. The page is still writable, which is a security hazard,
+	 * but anyhow ftrace breaks W^X completely.
+	 */
+	set_memory_x((unsigned long)trampoline, npages);
 	return (unsigned long)trampoline;
 fail:
 	tramp_free(trampoline, *tramp_size);
