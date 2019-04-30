Return-Path: <kernel-hardening-return-15850-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9562FF599
	for <lists+kernel-hardening@lfdr.de>; Tue, 30 Apr 2019 13:30:08 +0200 (CEST)
Received: (qmail 5993 invoked by uid 550); 30 Apr 2019 11:28:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 10236 invoked from network); 30 Apr 2019 11:17:11 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x3UBFEt41346558
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2019041745; t=1556622915;
	bh=XYgoeYjtRGBWmjtJBHBeUqBDcK5YVuAc6FWnDPx/HOQ=;
	h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
	b=meG/Gu/lXrE/l4zwnMvymYjspiqwDdqz2joU3PT6uH4A2tbGM0Kp19RZ9sy1zpBPm
	 RWPrXo6Au3IbIoO4hl8ZkDqsUp9VDf3DR/3MStW8/THufv3M1DVqZFKLtVaqy5wke3
	 CPmqpseDkBX28BMoP7DyYIMAoiQYnyS2L43sOdgJr5er8rfy+PmFG9ApKXUhvBTsTG
	 ShgEpo3uKPxRdqP9PX7Rtzu9LtUM0eZbaYvUDe+c8gNUI3q7rALn8/oyGkr1aSVj99
	 TUNgfHxLtUymbYQQwr+RG2Ni+Xfsa+y3gdQ/AUFAPCiWAGMJIZV1QELrMOVwxXc9r3
	 /74FII+qqoScA==
Date: Tue, 30 Apr 2019 04:15:13 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
Sender: tip tree robot <tipbot@zytor.com>
From: tip-bot for Nadav Amit <tipbot@zytor.com>
Message-ID: <tip-c7b6f29b6257532792fc722b68fcc0e00b5a856c@git.kernel.org>
Cc: luto@kernel.org, namit@vmware.com, linux_dti@icloud.com,
        ard.biesheuvel@linaro.org, will.deacon@arm.com, jannh@google.com,
        riel@surriel.com, rick.p.edgecombe@intel.com,
        kernel-hardening@lists.openwall.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, daniel@iogearbox.net,
        deneen.t.dock@intel.com, tglx@linutronix.de, ast@kernel.org,
        akpm@linux-foundation.org, mingo@kernel.org, kristen@linux.intel.com,
        peterz@infradead.org, bp@alien8.de, hpa@zytor.com,
        dave.hansen@linux.intel.com
In-Reply-To: <20190426001143.4983-24-namit@vmware.com>
References: <20190426001143.4983-24-namit@vmware.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] bpf: Fail bpf_probe_write_user() while mm is switched
Git-Commit-ID: c7b6f29b6257532792fc722b68fcc0e00b5a856c
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

Commit-ID:  c7b6f29b6257532792fc722b68fcc0e00b5a856c
Gitweb:     https://git.kernel.org/tip/c7b6f29b6257532792fc722b68fcc0e00b5a856c
Author:     Nadav Amit <namit@vmware.com>
AuthorDate: Thu, 25 Apr 2019 17:11:43 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2019 12:37:48 +0200

bpf: Fail bpf_probe_write_user() while mm is switched

When using a temporary mm, bpf_probe_write_user() should not be able to
write to user memory, since user memory addresses may be used to map
kernel memory.  Detect these cases and fail bpf_probe_write_user() in
such cases.

Suggested-by: Jann Horn <jannh@google.com>
Reported-by: Jann Horn <jannh@google.com>
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
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190426001143.4983-24-namit@vmware.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/trace/bpf_trace.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index d64c00afceb5..94b0e37d90ef 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -14,6 +14,8 @@
 #include <linux/syscalls.h>
 #include <linux/error-injection.h>
 
+#include <asm/tlb.h>
+
 #include "trace_probe.h"
 #include "trace.h"
 
@@ -163,6 +165,10 @@ BPF_CALL_3(bpf_probe_write_user, void *, unsafe_ptr, const void *, src,
 	 * access_ok() should prevent writing to non-user memory, but in
 	 * some situations (nommu, temporary switch, etc) access_ok() does
 	 * not provide enough validation, hence the check on KERNEL_DS.
+	 *
+	 * nmi_uaccess_okay() ensures the probe is not run in an interim
+	 * state, when the task or mm are switched. This is specifically
+	 * required to prevent the use of temporary mm.
 	 */
 
 	if (unlikely(in_interrupt() ||
@@ -170,6 +176,8 @@ BPF_CALL_3(bpf_probe_write_user, void *, unsafe_ptr, const void *, src,
 		return -EPERM;
 	if (unlikely(uaccess_kernel()))
 		return -EPERM;
+	if (unlikely(!nmi_uaccess_okay()))
+		return -EPERM;
 	if (!access_ok(unsafe_ptr, size))
 		return -EPERM;
 
