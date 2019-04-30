Return-Path: <kernel-hardening-return-15847-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 70823F592
	for <lists+kernel-hardening@lfdr.de>; Tue, 30 Apr 2019 13:29:25 +0200 (CEST)
Received: (qmail 5138 invoked by uid 550); 30 Apr 2019 11:28:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 9719 invoked from network); 30 Apr 2019 11:16:05 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x3UBEWJS1346292
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2019041745; t=1556622874;
	bh=uxzQMi0Dx0Blq16DFl0L8XGG5v6oUGdkcJLD6bZuKWM=;
	h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
	b=GhhGn8yync+2L4iYJzMthwN6liGoEtRrDBgPDsoIwNPTYspcCcWypv0+U+e+RDPnO
	 BwDku7rDgSxdiE2To26QcqvSw2X32gSe0IqdHu4Vwr91wuu7Qzx8HCpjAgTPiqqLeq
	 g47cjF5/XW59c+QljLbNkx/0+DHGlLhjRCWsYLSq/4zbYbx+no3hpxpwf2G6AoSi5q
	 DEemCkCuat/KNgrYpnqXmZlmvqH4T16+gsqt0Ok4fx7LeeSrEfZPOMwEKY4jfX5GRf
	 9qHT7jdwDJDdcxiP1/721ATH6yEjRsiu569ZFV/mZVF36oHryx5bzLeHn4aGLxmdmc
	 67oX1m8lQ8T8w==
Date: Tue, 30 Apr 2019 04:14:32 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
Sender: tip tree robot <tipbot@zytor.com>
From: tip-bot for Nadav Amit <tipbot@zytor.com>
Message-ID: <tip-5932c9fd19e6e5ac84756c5c32fe5155d9a6b458@git.kernel.org>
Cc: namit@vmware.com, torvalds@linux-foundation.org, akpm@linux-foundation.org,
        hpa@zytor.com, peterz@infradead.org, ard.biesheuvel@linaro.org,
        dave.hansen@linux.intel.com, kristen@linux.intel.com,
        linux_dti@icloud.com, kernel-hardening@lists.openwall.com,
        bp@alien8.de, riel@surriel.com, rick.p.edgecombe@intel.com,
        mingo@kernel.org, will.deacon@arm.com, tglx@linutronix.de,
        luto@kernel.org, linux-kernel@vger.kernel.org, deneen.t.dock@intel.com
In-Reply-To: <20190426001143.4983-23-namit@vmware.com>
References: <20190426001143.4983-23-namit@vmware.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] mm/tlb: Provide default nmi_uaccess_okay()
Git-Commit-ID: 5932c9fd19e6e5ac84756c5c32fe5155d9a6b458
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

Commit-ID:  5932c9fd19e6e5ac84756c5c32fe5155d9a6b458
Gitweb:     https://git.kernel.org/tip/5932c9fd19e6e5ac84756c5c32fe5155d9a6b458
Author:     Nadav Amit <namit@vmware.com>
AuthorDate: Thu, 25 Apr 2019 17:11:42 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2019 12:37:48 +0200

mm/tlb: Provide default nmi_uaccess_okay()

x86 has an nmi_uaccess_okay(), but other architectures do not.
Arch-independent code might need to know whether access to user
addresses is ok in an NMI context or in other code whose execution
context is unknown.  Specifically, this function is needed for
bpf_probe_write_user().

Add a default implementation of nmi_uaccess_okay() for architectures
that do not have such a function.

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
Link: https://lkml.kernel.org/r/20190426001143.4983-23-namit@vmware.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/include/asm/tlbflush.h | 2 ++
 include/asm-generic/tlb.h       | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index f4204bf377fc..e9eae3d6ef02 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -274,6 +274,8 @@ static inline bool nmi_uaccess_okay(void)
 	return true;
 }
 
+#define nmi_uaccess_okay nmi_uaccess_okay
+
 /* Initialize cr4 shadow for this CPU. */
 static inline void cr4_init_shadow(void)
 {
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index 6be86c1c5c58..075b353cae86 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -20,6 +20,15 @@
 #include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 
+/*
+ * Blindly accessing user memory from NMI context can be dangerous
+ * if we're in the middle of switching the current user task or switching
+ * the loaded mm.
+ */
+#ifndef nmi_uaccess_okay
+# define nmi_uaccess_okay() true
+#endif
+
 #ifdef CONFIG_MMU
 
 #ifdef CONFIG_HAVE_RCU_TABLE_FREE
