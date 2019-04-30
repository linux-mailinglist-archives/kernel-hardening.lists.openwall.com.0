Return-Path: <kernel-hardening-return-15864-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2F334F5BE
	for <lists+kernel-hardening@lfdr.de>; Tue, 30 Apr 2019 13:33:55 +0200 (CEST)
Received: (qmail 28086 invoked by uid 550); 30 Apr 2019 11:31:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 15857 invoked from network); 30 Apr 2019 11:22:37 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x3UBM7bF1347865
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2019041745; t=1556623328;
	bh=eW2QjPgcBOv7jb4+wi9OFyDTbQHiXsewLb8jvdcZt7Y=;
	h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
	b=g6o3owfUu+onMF7rUKsdIIIt443sw2VqCbd70IsLIgZaWT6fvFobjEeoF6YUauR/a
	 O1Eyu1HdlCtRnNvg2GhMkaz03x2sj75Kp8G5IcG41YOrpyP583yIjnmRq4BDicjSLQ
	 jjGyBTPsoH5kbhM8tSg0djlgp8acvnTYTeFi6r1g1U6L+JBSWBsxWDgvB7NH2vaMVC
	 nFwwx2JeKaxcsR3lJxj5FJ0uz8uhIA9Mu468teylfcHpS8WwraXtmDYNpANE5iV14o
	 kxAzzzx3YBSes4C+LjbqkaCyxUQeQUlPZ2xP13mrLgzHJDhJzh4mJ8fyYhzDhRhdIQ
	 RdBvk5ejT8MYQ==
Date: Tue, 30 Apr 2019 04:22:06 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
Sender: tip tree robot <tipbot@zytor.com>
From: tip-bot for Nadav Amit <tipbot@zytor.com>
Message-ID: <tip-7298e24f904224fa79eb8fd7e0fbd78950ccf2db@git.kernel.org>
Cc: peterz@infradead.org, namit@vmware.com, mingo@kernel.org,
        akpm@linux-foundation.org, tglx@linutronix.de,
        rick.p.edgecombe@intel.com, hpa@zytor.com, ard.biesheuvel@linaro.org,
        dave.hansen@linux.intel.com, torvalds@linux-foundation.org,
        kristen@linux.intel.com, linux_dti@icloud.com, bp@alien8.de,
        deneen.t.dock@intel.com, riel@surriel.com, luto@kernel.org,
        will.deacon@arm.com, kernel-hardening@lists.openwall.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20190426001143.4983-11-namit@vmware.com>
References: <20190426001143.4983-11-namit@vmware.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/kprobes: Set instruction page as executable
Git-Commit-ID: 7298e24f904224fa79eb8fd7e0fbd78950ccf2db
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

Commit-ID:  7298e24f904224fa79eb8fd7e0fbd78950ccf2db
Gitweb:     https://git.kernel.org/tip/7298e24f904224fa79eb8fd7e0fbd78950ccf2db
Author:     Nadav Amit <namit@vmware.com>
AuthorDate: Thu, 25 Apr 2019 17:11:30 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2019 12:37:54 +0200

x86/kprobes: Set instruction page as executable

Set the page as executable after allocation.  This patch is a
preparatory patch for a following patch that makes module allocated
pages non-executable.

While at it, do some small cleanup of what appears to be unnecessary
masking.

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
Link: https://lkml.kernel.org/r/20190426001143.4983-11-namit@vmware.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/kprobes/core.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index fed46ddb1eef..06058c44ab57 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -431,8 +431,20 @@ void *alloc_insn_page(void)
 	void *page;
 
 	page = module_alloc(PAGE_SIZE);
-	if (page)
-		set_memory_ro((unsigned long)page & PAGE_MASK, 1);
+	if (!page)
+		return NULL;
+
+	/*
+	 * First make the page read-only, and only then make it executable to
+	 * prevent it from being W+X in between.
+	 */
+	set_memory_ro((unsigned long)page, 1);
+
+	/*
+	 * TODO: Once additional kernel code protection mechanisms are set, ensure
+	 * that the page was not maliciously altered and it is still zeroed.
+	 */
+	set_memory_x((unsigned long)page, 1);
 
 	return page;
 }
@@ -440,8 +452,12 @@ void *alloc_insn_page(void)
 /* Recover page to RW mode before releasing it */
 void free_insn_page(void *page)
 {
-	set_memory_nx((unsigned long)page & PAGE_MASK, 1);
-	set_memory_rw((unsigned long)page & PAGE_MASK, 1);
+	/*
+	 * First make the page non-executable, and only then make it writable to
+	 * prevent it from being W+X in between.
+	 */
+	set_memory_nx((unsigned long)page, 1);
+	set_memory_rw((unsigned long)page, 1);
 	module_memfree(page);
 }
 
