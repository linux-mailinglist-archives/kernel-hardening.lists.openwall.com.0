Return-Path: <kernel-hardening-return-15848-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 73E23F596
	for <lists+kernel-hardening@lfdr.de>; Tue, 30 Apr 2019 13:29:40 +0200 (CEST)
Received: (qmail 5227 invoked by uid 550); 30 Apr 2019 11:28:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 9933 invoked from network); 30 Apr 2019 11:16:26 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x3UBFtfY1346626
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2019041745; t=1556622957;
	bh=zmLZXMki4lbtPnV30AcLo2TRv3iWX3LutwrOebnDquk=;
	h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
	b=HaUCoP9k1SflB6tBcu+WSHXQm1/wS4/SxliIH4EO+SC3Adruk3TQhNS2yymPX80n8
	 3LPM4RPLMwAzp+egdmv1G25h/TMrMTb4Q0AIVq61aEegYe0G+KJcOy5fhd3ZyPQ25H
	 dFdOcqdzqr219hTptXKIMkHx/UuR6NXIf3zMD8X1ShPmTNojeVDWqLQYHLcMgbcX+x
	 J7cycNwA+H5I2jyNXmdOAupWXfPFYXtDQUzThhJZxpug3evD2x2dL7q0Tbew+0QxCa
	 lML2a8lsSTe3A3pjTHhtuZBw0JvIGwQ7T5VcULwqK8HFSWzsaWCn3QwmAJwPnqb+Qr
	 x6K3fZJGEOlRg==
Date: Tue, 30 Apr 2019 04:15:55 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
Sender: tip tree robot <tipbot@zytor.com>
From: tip-bot for Nadav Amit <tipbot@zytor.com>
Message-ID: <tip-1fd8de46d01d95f875c12684a6a03559831e8b4c@git.kernel.org>
Cc: riel@surriel.com, akpm@linux-foundation.org,
        kernel-hardening@lists.openwall.com, torvalds@linux-foundation.org,
        hpa@zytor.com, mingo@kernel.org, linux-kernel@vger.kernel.org,
        dave.hansen@intel.com, kristen@linux.intel.com, bp@alien8.de,
        tglx@linutronix.de, linux_dti@icloud.com, will.deacon@arm.com,
        keescook@chromium.org, deneen.t.dock@intel.com, namit@vmware.com,
        mhiramat@kernel.org, rick.p.edgecombe@intel.com,
        ard.biesheuvel@linaro.org, peterz@infradead.org, luto@kernel.org
In-Reply-To: <20190426001143.4983-3-namit@vmware.com>
References: <20190426001143.4983-3-namit@vmware.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86/jump_label: Use text_poke_early() during early
 init
Git-Commit-ID: 1fd8de46d01d95f875c12684a6a03559831e8b4c
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

Commit-ID:  1fd8de46d01d95f875c12684a6a03559831e8b4c
Gitweb:     https://git.kernel.org/tip/1fd8de46d01d95f875c12684a6a03559831e8b4c
Author:     Nadav Amit <namit@vmware.com>
AuthorDate: Thu, 25 Apr 2019 17:11:22 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2019 12:37:49 +0200

x86/jump_label: Use text_poke_early() during early init

There is no apparent reason not to use text_poke_early() during
early-init, since no patching of code that might be on the stack is done
and only a single core is running.

This is required for the next patches that would set a temporary mm for
text poking, and this mm is only initialized after some static-keys are
enabled/disabled.

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
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190426001143.4983-3-namit@vmware.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/jump_label.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index f99bd26bd3f1..e7d8c636b228 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -50,7 +50,12 @@ static void __ref __jump_label_transform(struct jump_entry *entry,
 	jmp.offset = jump_entry_target(entry) -
 		     (jump_entry_code(entry) + JUMP_LABEL_NOP_SIZE);
 
-	if (early_boot_irqs_disabled)
+	/*
+	 * As long as only a single processor is running and the code is still
+	 * not marked as RO, text_poke_early() can be used; Checking that
+	 * system_state is SYSTEM_BOOTING guarantees it.
+	 */
+	if (system_state == SYSTEM_BOOTING)
 		poker = text_poke_early;
 
 	if (type == JUMP_LABEL_JMP) {
