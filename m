Return-Path: <kernel-hardening-return-16111-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2E42E42D3A
	for <lists+kernel-hardening@lfdr.de>; Wed, 12 Jun 2019 19:14:57 +0200 (CEST)
Received: (qmail 4016 invoked by uid 550); 12 Jun 2019 17:14:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 27976 invoked from network); 12 Jun 2019 17:11:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1560359517; x=1591895517;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BCwbtGWRrYM8rpdyPautZ9rurvQMH3lCItd7cCuySww=;
  b=oKUqUccD5KQyQuNO0yjZx1rlDMI0I2peJsx9DhvSXHUq1FV8Qmr/b31o
   DkUtZ3lThsgyMbDnbgN5hJrQRbFG9Vs/LK5eQnanTVleZjtQUvzMYFm13
   XfWhMqDufBZUBQO+Bph2Sh+HYPPSLlz+nKltPrj5FCMmrTgJhKvC7x0oa
   U=;
X-IronPort-AV: E=Sophos;i="5.62,366,1554768000"; 
   d="scan'208";a="770066910"
From: Marius Hillenbrand <mhillenb@amazon.de>
To: kvm@vger.kernel.org
Cc: Marius Hillenbrand <mhillenb@amazon.de>, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com, linux-mm@kvack.org,
        Alexander Graf <graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>,
        Julian Stecklina <jsteckli@amazon.de>
Subject: [RFC 07/10] kvm, vmx: move CR2 context switch out of assembly path
Date: Wed, 12 Jun 2019 19:08:38 +0200
Message-Id: <20190612170834.14855-8-mhillenb@amazon.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190612170834.14855-1-mhillenb@amazon.de>
References: <20190612170834.14855-1-mhillenb@amazon.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Julian Stecklina <jsteckli@amazon.de>

The VM entry/exit path is a giant inline assembly statement. Simplify it
by doing CR2 context switching in plain C. Move CR2 restore behind IBRS
clearing, so we reduce the amount of code we execute with IBRS on.

Using {read,write}_cr2() means KVM will use pv_mmu_ops instead of open
coding native_{read,write}_cr2(). The CR2 code has been done in
assembly since KVM's genesis[1], which predates the addition of the
paravirt ops[2], i.e. KVM isn't deliberately avoiding the paravirt
ops.

[1] Commit 6aa8b732ca01 ("[PATCH] kvm: userspace interface")
[2] Commit d3561b7fa0fb ("[PATCH] paravirt: header and stubs for paravirtualisation")

Signed-off-by: Julian Stecklina <jsteckli@amazon.de>
[rebased; note that this patch mainly improves the readability of
subsequent patches; we will drop it when rebasing to 5.x, since major
refactoring of KVM makes this patch redundant.]
Signed-off-by: Marius Hillenbrand <mhillenb@amazon.de>
Cc: Alexander Graf <graf@amazon.de>
Cc: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/vmx.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 6f59a6ad7835..16a383635b59 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -11513,6 +11513,9 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	evmcs_rsp = static_branch_unlikely(&enable_evmcs) ?
 		(unsigned long)&current_evmcs->host_rsp : 0;
 
+	if (read_cr2() != vcpu->arch.cr2)
+		write_cr2(vcpu->arch.cr2);
+
 	if (static_branch_unlikely(&vmx_l1d_should_flush))
 		vmx_l1d_flush(vcpu);
 
@@ -11532,13 +11535,6 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		"2: \n\t"
 		__ex("vmwrite %%" _ASM_SP ", %%" _ASM_DX) "\n\t"
 		"1: \n\t"
-		/* Reload cr2 if changed */
-		"mov %c[cr2](%0), %%" _ASM_AX " \n\t"
-		"mov %%cr2, %%" _ASM_DX " \n\t"
-		"cmp %%" _ASM_AX ", %%" _ASM_DX " \n\t"
-		"je 3f \n\t"
-		"mov %%" _ASM_AX", %%cr2 \n\t"
-		"3: \n\t"
 		/* Check if vmlaunch of vmresume is needed */
 		"cmpl $0, %c[launched](%0) \n\t"
 		/* Load guest registers.  Don't clobber flags. */
@@ -11599,8 +11595,6 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		"xor %%r14d, %%r14d \n\t"
 		"xor %%r15d, %%r15d \n\t"
 #endif
-		"mov %%cr2, %%" _ASM_AX "   \n\t"
-		"mov %%" _ASM_AX ", %c[cr2](%0) \n\t"
 
 		"xor %%eax, %%eax \n\t"
 		"xor %%ebx, %%ebx \n\t"
@@ -11632,7 +11626,6 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		[r14]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_R14])),
 		[r15]"i"(offsetof(struct vcpu_vmx, vcpu.arch.regs[VCPU_REGS_R15])),
 #endif
-		[cr2]"i"(offsetof(struct vcpu_vmx, vcpu.arch.cr2)),
 		[wordsize]"i"(sizeof(ulong))
 	      : "cc", "memory"
 #ifdef CONFIG_X86_64
@@ -11666,6 +11659,8 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	/* Eliminate branch target predictions from guest mode */
 	vmexit_fill_RSB();
 
+	vcpu->arch.cr2 = read_cr2();
+
 	/* All fields are clean at this point */
 	if (static_branch_unlikely(&enable_evmcs))
 		current_evmcs->hv_clean_fields |=
-- 
2.21.0

