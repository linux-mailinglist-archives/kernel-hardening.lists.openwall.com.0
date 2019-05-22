Return-Path: <kernel-hardening-return-15981-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BFCD726B7B
	for <lists+kernel-hardening@lfdr.de>; Wed, 22 May 2019 21:28:06 +0200 (CEST)
Received: (qmail 30373 invoked by uid 550); 22 May 2019 19:27:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 23663 invoked from network); 22 May 2019 19:22:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1558552960;
	bh=BtJ2PSA7lzUFglQbHDLlvlNIJuTaiwvd4PSRXSs8TB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5WYyBLIEAfogPVLNb8MlDYBrbocmIusxj2TnDPhBgS0upC3yra2a5SrttBryrvCH
	 C5JrH1fXvtGXbctXGT2ZxbD82jGrHA6f4FiNpFJLlGgfG3O9VvV38g8b8cbZx6CkTI
	 wKM0CPe5DRHzDtVcsd7wAI0G0mCs7239C5O6ET2E=
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Nadav Amit <namit@vmware.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	akpm@linux-foundation.org,
	ard.biesheuvel@linaro.org,
	deneen.t.dock@intel.com,
	kernel-hardening@lists.openwall.com,
	kristen@linux.intel.com,
	linux_dti@icloud.com,
	will.deacon@arm.com,
	Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.1 048/375] x86/ftrace: Set trampoline pages as executable
Date: Wed, 22 May 2019 15:15:48 -0400
Message-Id: <20190522192115.22666-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192115.22666-1-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Nadav Amit <namit@vmware.com>

[ Upstream commit 3c0dab44e22782359a0a706cbce72de99a22aa75 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/ftrace.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index ef49517f6bb24..53ba1aa3a01f8 100644
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
-- 
2.20.1

