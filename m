Return-Path: <kernel-hardening-return-16314-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B13FF58DD5
	for <lists+kernel-hardening@lfdr.de>; Fri, 28 Jun 2019 00:18:03 +0200 (CEST)
Received: (qmail 15777 invoked by uid 550); 27 Jun 2019 22:17:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15753 invoked from network); 27 Jun 2019 22:17:57 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x5RMHR9x473034
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2019061801; t=1561673848;
	bh=JBzb6pQKsbydbEJm8hq0OG91D9DJ0InbaEh+vbPMXJg=;
	h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
	b=eSGaSNOm0UNdafn2VkL1dMEP4pU++yyH/vqk0XjuxU3GNf+6PygP2I3ImzQON3ikN
	 VhPuyK1e4bIl7WZO/R4ilrmDwYx7OTTu/Bc9zyZuVxGkIai8zLdU8c3bW2sPJS9HqI
	 AeEnCWewhQc8cfStO8W3TT11rQqbdIZu81NnVAYqx6z9b8AdkmciucOi8t9n8E6eH0
	 A+R5iBtwY2NLEFzBxjXzD2A0DHvNK4FQLQPhjGVvWL8+/7UG6K4oOKPUXDv/n2IjDo
	 FbgusiJLg/DbNSpgyRl4Ns6JfvjjQUubpYS/TLzteC8YdHPrjSHspu2bQ5K6fwtToK
	 AH7HFukdTkkZQ==
Date: Thu, 27 Jun 2019 15:17:27 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
Sender: tip tree robot <tipbot@zytor.com>
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-441cedab2dfca18fe4983cbc795de04536ed421e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org, tglx@linutronix.de,
        fweimer@redhat.com, luto@kernel.org, peterz@infradead.org,
        bp@alien8.de, hpa@zytor.com, mingo@kernel.org,
        kernel-hardening@lists.openwall.com, jannh@google.com
In-Reply-To: <a386925835e49d319e70c4d7404b1f6c3c2e3702.1561610354.git.luto@kernel.org>
References: <a386925835e49d319e70c4d7404b1f6c3c2e3702.1561610354.git.luto@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/entry] x86/vsyscall: Add __ro_after_init to global
 variables
Git-Commit-ID: 441cedab2dfca18fe4983cbc795de04536ed421e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from
 these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Spam-Status: No, score=0.1 required=5.0 tests=ALL_TRUSTED,BAYES_00,
	DATE_IN_FUTURE_12_24,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	DKIM_VALID_EF autolearn=no autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on terminus.zytor.com

Commit-ID:  441cedab2dfca18fe4983cbc795de04536ed421e
Gitweb:     https://git.kernel.org/tip/441cedab2dfca18fe4983cbc795de04536ed421e
Author:     Andy Lutomirski <luto@kernel.org>
AuthorDate: Wed, 26 Jun 2019 21:45:08 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 28 Jun 2019 00:04:40 +0200

x86/vsyscall: Add __ro_after_init to global variables

The vDSO is only configurable by command-line options, so make its
global variables __ro_after_init.  This seems highly unlikely to
ever stop an exploit, but it's nicer anyway.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lkml.kernel.org/r/a386925835e49d319e70c4d7404b1f6c3c2e3702.1561610354.git.luto@kernel.org

---
 arch/x86/entry/vsyscall/vsyscall_64.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/entry/vsyscall/vsyscall_64.c b/arch/x86/entry/vsyscall/vsyscall_64.c
index 9c58ab807aeb..07003f3f1bfc 100644
--- a/arch/x86/entry/vsyscall/vsyscall_64.c
+++ b/arch/x86/entry/vsyscall/vsyscall_64.c
@@ -42,7 +42,7 @@
 #define CREATE_TRACE_POINTS
 #include "vsyscall_trace.h"
 
-static enum { EMULATE, XONLY, NONE } vsyscall_mode =
+static enum { EMULATE, XONLY, NONE } vsyscall_mode __ro_after_init =
 #ifdef CONFIG_LEGACY_VSYSCALL_NONE
 	NONE;
 #elif defined(CONFIG_LEGACY_VSYSCALL_XONLY)
@@ -305,7 +305,7 @@ static const char *gate_vma_name(struct vm_area_struct *vma)
 static const struct vm_operations_struct gate_vma_ops = {
 	.name = gate_vma_name,
 };
-static struct vm_area_struct gate_vma = {
+static struct vm_area_struct gate_vma __ro_after_init = {
 	.vm_start	= VSYSCALL_ADDR,
 	.vm_end		= VSYSCALL_ADDR + PAGE_SIZE,
 	.vm_page_prot	= PAGE_READONLY_EXEC,
