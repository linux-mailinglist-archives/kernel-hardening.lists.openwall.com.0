Return-Path: <kernel-hardening-return-15866-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 821CEF5C0
	for <lists+kernel-hardening@lfdr.de>; Tue, 30 Apr 2019 13:34:25 +0200 (CEST)
Received: (qmail 32064 invoked by uid 550); 30 Apr 2019 11:31:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 20373 invoked from network); 30 Apr 2019 11:30:05 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x3UBTYcg1350551
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2019041745; t=1556623775;
	bh=tzqP+K1slI+8lkDw9KMmwPxdNB3wF9JoSTcYZ2Gu0vA=;
	h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
	b=FwPL4LRMUuEAkydDlPd1E2tmpB2Wz+cFAGQ8iuBCXrf1UHvBTIKRb08kBW2MA7rYe
	 3hn5medFE5dY3fi/RVgosqJUekt604V5rFP9oICVSj1b0Si70I4r+jNkSGQP6BUcVP
	 K5pNEvPCQgMksBlchjeVH1mvw4qdTBA1FUPBDR9w+vnMVlwEP07z2+jmuiqBdNo+/L
	 c345GsfdV9BBMwy9KXIErqdli6/Yx7SR43xwlTeWrq2jp2rjt5GmdSmwLvHsJiq8Z2
	 tR61NjmdL9zwouHRUzTNCvHYTugnnCl0OKu3wxPf6p2iQ0e4nVG0rZYqamNinNygmz
	 Uece1pV0p2yrQ==
Date: Tue, 30 Apr 2019 04:29:34 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
Sender: tip tree robot <tipbot@zytor.com>
From: tip-bot for Nadav Amit <tipbot@zytor.com>
Message-ID: <tip-3950746d9d8ef981c1cb842384e0e86e8d1aad76@git.kernel.org>
Cc: ard.biesheuvel@linaro.org, bp@alien8.de, dave.hansen@linux.intel.com,
        linux_dti@icloud.com, riel@surriel.com, akpm@linux-foundation.org,
        deneen.t.dock@intel.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, kristen@linux.intel.com, hpa@zytor.com,
        will.deacon@arm.com, mingo@kernel.org, mhiramat@kernel.org,
        tglx@linutronix.de, rick.p.edgecombe@intel.com, luto@kernel.org,
        kernel-hardening@lists.openwall.com, peterz@infradead.org,
        namit@vmware.com
In-Reply-To: <20190426001143.4983-22-namit@vmware.com>
References: <20190426001143.4983-22-namit@vmware.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/alternatives: Add comment about module removal
 races
Git-Commit-ID: 3950746d9d8ef981c1cb842384e0e86e8d1aad76
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

Commit-ID:  3950746d9d8ef981c1cb842384e0e86e8d1aad76
Gitweb:     https://git.kernel.org/tip/3950746d9d8ef981c1cb842384e0e86e8d1aad76
Author:     Nadav Amit <namit@vmware.com>
AuthorDate: Thu, 25 Apr 2019 17:11:41 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2019 12:38:01 +0200

x86/alternatives: Add comment about module removal races

Add a comment to clarify that users of text_poke() must ensure that
no races with module removal take place.

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
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190426001143.4983-22-namit@vmware.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/alternative.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 18f959975ea0..7b9b49dfc05a 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -810,6 +810,11 @@ static void *__text_poke(void *addr, const void *opcode, size_t len)
  * It means the size must be writable atomically and the address must be aligned
  * in a way that permits an atomic write. It also makes sure we fit on a single
  * page.
+ *
+ * Note that the caller must ensure that if the modified code is part of a
+ * module, the module would not be removed during poking. This can be achieved
+ * by registering a module notifier, and ordering module removal and patching
+ * trough a mutex.
  */
 void *text_poke(void *addr, const void *opcode, size_t len)
 {
