Return-Path: <kernel-hardening-return-16114-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 27C4442D41
	for <lists+kernel-hardening@lfdr.de>; Wed, 12 Jun 2019 19:15:37 +0200 (CEST)
Received: (qmail 7315 invoked by uid 550); 12 Jun 2019 17:14:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 28488 invoked from network); 12 Jun 2019 17:12:43 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1560359563; x=1591895563;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1l13rRWuFlC2jtnumLOMqJEjamUkvWPQRDS+qbpg+64=;
  b=igHipRcgajngrJ38vVH3Wu6VyTde7HgwBK3+l5Cq2h/TLJt6FggojYPm
   IpngpiCnGwgm6HY1hXeonzGbQdp6lVkAoaPKyAswq6AkTaTzqpik070Ua
   b/Z/GNh1u5JuZArxkPaFoF76njAyGOLIMc9DHF/l9bY40ApImw839G3J9
   o=;
X-IronPort-AV: E=Sophos;i="5.62,366,1554768000"; 
   d="scan'208";a="805048939"
From: Marius Hillenbrand <mhillenb@amazon.de>
To: kvm@vger.kernel.org
Cc: Marius Hillenbrand <mhillenb@amazon.de>, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com, linux-mm@kvack.org,
        Alexander Graf <graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>,
        Julian Stecklina <js@alien8.de>
Subject: [RFC 10/10] kvm, x86: move guest FPU state into process local memory
Date: Wed, 12 Jun 2019 19:08:44 +0200
Message-Id: <20190612170834.14855-11-mhillenb@amazon.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190612170834.14855-1-mhillenb@amazon.de>
References: <20190612170834.14855-1-mhillenb@amazon.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

FPU registers contain guest data and must be protected from information
leak vulnerabilities in the kernel.

FPU register state for vCPUs are allocated from the globally-visible
kernel heap. Change this to use process-local memory instead and thus
prevent access (or prefetching) in any other context in the kernel.

Signed-off-by: Marius Hillenbrand <mhillenb@amazon.de>
Inspired-by: Julian Stecklina <js@alien8.de> (while jsteckli@amazon.de)
Cc: Alexander Graf <graf@amazon.de>
Cc: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  8 ++++++++
 arch/x86/kvm/x86.c              | 24 ++++++++++++------------
 2 files changed, 20 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 4896ecde1c11..b3574217b011 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -36,6 +36,7 @@
 #include <asm/asm.h>
 #include <asm/kvm_page_track.h>
 #include <asm/hyperv-tlfs.h>
+#include <asm/proclocal.h>
 
 #define KVM_MAX_VCPUS 288
 #define KVM_SOFT_MAX_VCPUS 240
@@ -545,6 +546,7 @@ struct kvm_vcpu_arch_hidden {
 	 * kvm_{register,rip}_{read,write} functions.
 	 */
 	kvm_arch_regs_t regs;
+	struct fpu guest_fpu;
 };
 #endif
 
@@ -631,9 +633,15 @@ struct kvm_vcpu_arch {
 	 * it is switched out separately at VMENTER and VMEXIT time. The
 	 * "guest_fpu" state here contains the guest FPU context, with the
 	 * host PRKU bits.
+	 *
+	 * With process-local memory, the guest FPU state will be hidden in
+	 * kvm_vcpu_arch_hidden. Thus, access to this struct must go through
+	 * kvm_vcpu_arch_state(vcpu).
 	 */
 	struct fpu user_fpu;
+#ifndef CONFIG_KVM_PROCLOCAL
 	struct fpu guest_fpu;
+#endif
 
 	u64 xcr0;
 	u64 guest_supported_xcr0;
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 35e41a772807..480b4ed438ae 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3792,7 +3792,7 @@ static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,
 
 static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
 {
-	struct xregs_state *xsave = &vcpu->arch.guest_fpu.state.xsave;
+	struct xregs_state *xsave = &kvm_vcpu_arch_state(&vcpu->arch)->guest_fpu.state.xsave;
 	u64 xstate_bv = xsave->header.xfeatures;
 	u64 valid;
 
@@ -3834,7 +3834,7 @@ static void fill_xsave(u8 *dest, struct kvm_vcpu *vcpu)
 
 static void load_xsave(struct kvm_vcpu *vcpu, u8 *src)
 {
-	struct xregs_state *xsave = &vcpu->arch.guest_fpu.state.xsave;
+	struct xregs_state *xsave = &kvm_vcpu_arch_state(&vcpu->arch)->guest_fpu.state.xsave;
 	u64 xstate_bv = *(u64 *)(src + XSAVE_HDR_OFFSET);
 	u64 valid;
 
@@ -3882,7 +3882,7 @@ static void kvm_vcpu_ioctl_x86_get_xsave(struct kvm_vcpu *vcpu,
 		fill_xsave((u8 *) guest_xsave->region, vcpu);
 	} else {
 		memcpy(guest_xsave->region,
-			&vcpu->arch.guest_fpu.state.fxsave,
+			&kvm_vcpu_arch_state(&vcpu->arch)->guest_fpu.state.fxsave,
 			sizeof(struct fxregs_state));
 		*(u64 *)&guest_xsave->region[XSAVE_HDR_OFFSET / sizeof(u32)] =
 			XFEATURE_MASK_FPSSE;
@@ -3912,7 +3912,7 @@ static int kvm_vcpu_ioctl_x86_set_xsave(struct kvm_vcpu *vcpu,
 		if (xstate_bv & ~XFEATURE_MASK_FPSSE ||
 			mxcsr & ~mxcsr_feature_mask)
 			return -EINVAL;
-		memcpy(&vcpu->arch.guest_fpu.state.fxsave,
+		memcpy(&kvm_vcpu_arch_state(&vcpu->arch)->guest_fpu.state.fxsave,
 			guest_xsave->region, sizeof(struct fxregs_state));
 	}
 	return 0;
@@ -8302,7 +8302,7 @@ static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 	preempt_disable();
 	copy_fpregs_to_fpstate(&vcpu->arch.user_fpu);
 	/* PKRU is separately restored in kvm_x86_ops->run.  */
-	__copy_kernel_to_fpregs(&vcpu->arch.guest_fpu.state,
+	__copy_kernel_to_fpregs(&kvm_vcpu_arch_state(&vcpu->arch)->guest_fpu.state,
 				~XFEATURE_MASK_PKRU);
 	preempt_enable();
 	trace_kvm_fpu(1);
@@ -8312,7 +8312,7 @@ static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 static void kvm_put_guest_fpu(struct kvm_vcpu *vcpu)
 {
 	preempt_disable();
-	copy_fpregs_to_fpstate(&vcpu->arch.guest_fpu);
+	copy_fpregs_to_fpstate(&kvm_vcpu_arch_state(&vcpu->arch)->guest_fpu);
 	copy_kernel_to_fpregs(&vcpu->arch.user_fpu.state);
 	preempt_enable();
 	++vcpu->stat.fpu_reload;
@@ -8807,7 +8807,7 @@ int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 
 	vcpu_load(vcpu);
 
-	fxsave = &vcpu->arch.guest_fpu.state.fxsave;
+	fxsave = &kvm_vcpu_arch_state(&vcpu->arch)->guest_fpu.state.fxsave;
 	memcpy(fpu->fpr, fxsave->st_space, 128);
 	fpu->fcw = fxsave->cwd;
 	fpu->fsw = fxsave->swd;
@@ -8827,7 +8827,7 @@ int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
 
 	vcpu_load(vcpu);
 
-	fxsave = &vcpu->arch.guest_fpu.state.fxsave;
+	fxsave = &kvm_vcpu_arch_state(&vcpu->arch)->guest_fpu.state.fxsave;
 
 	memcpy(fxsave->st_space, fpu->fpr, 128);
 	fxsave->cwd = fpu->fcw;
@@ -8883,9 +8883,9 @@ static int sync_regs(struct kvm_vcpu *vcpu)
 
 static void fx_init(struct kvm_vcpu *vcpu)
 {
-	fpstate_init(&vcpu->arch.guest_fpu.state);
+	fpstate_init(&kvm_vcpu_arch_state(&vcpu->arch)->guest_fpu.state);
 	if (boot_cpu_has(X86_FEATURE_XSAVES))
-		vcpu->arch.guest_fpu.state.xsave.header.xcomp_bv =
+		kvm_vcpu_arch_state(&vcpu->arch)->guest_fpu.state.xsave.header.xcomp_bv =
 			host_xcr0 | XSTATE_COMPACTION_ENABLED;
 
 	/*
@@ -9009,11 +9009,11 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 		 */
 		if (init_event)
 			kvm_put_guest_fpu(vcpu);
-		mpx_state_buffer = get_xsave_addr(&vcpu->arch.guest_fpu.state.xsave,
+		mpx_state_buffer = get_xsave_addr(&kvm_vcpu_arch_state(&vcpu->arch)->guest_fpu.state.xsave,
 					XFEATURE_MASK_BNDREGS);
 		if (mpx_state_buffer)
 			memset(mpx_state_buffer, 0, sizeof(struct mpx_bndreg_state));
-		mpx_state_buffer = get_xsave_addr(&vcpu->arch.guest_fpu.state.xsave,
+		mpx_state_buffer = get_xsave_addr(&kvm_vcpu_arch_state(&vcpu->arch)->guest_fpu.state.xsave,
 					XFEATURE_MASK_BNDCSR);
 		if (mpx_state_buffer)
 			memset(mpx_state_buffer, 0, sizeof(struct mpx_bndcsr));
-- 
2.21.0

