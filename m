Return-Path: <kernel-hardening-return-16110-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9618A42D39
	for <lists+kernel-hardening@lfdr.de>; Wed, 12 Jun 2019 19:14:45 +0200 (CEST)
Received: (qmail 3784 invoked by uid 550); 12 Jun 2019 17:14:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 27901 invoked from network); 12 Jun 2019 17:11:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1560359509; x=1591895509;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mHyM8SWHlAfs7A/FW6SKOCGNM1rYZjxh4Tkjo7ZhY7U=;
  b=N6EO1lMP+S13ikCMLq9wuVr/9o55YpeOMMqzCsWkZCniRiPH5/nhDqLx
   n66awfKm3ZZUSdcMGW4t5jd9V7W8Cjk1zSlj89leuhJoWXV1v/YTbY9jE
   DVxNrp9/VPoUFKVDjydufi9H+55jb/vpwHKG0OMdGvv5SHZLlVaZ396Ac
   s=;
X-IronPort-AV: E=Sophos;i="5.62,366,1554768000"; 
   d="scan'208";a="406138085"
From: Marius Hillenbrand <mhillenb@amazon.de>
To: kvm@vger.kernel.org
Cc: Marius Hillenbrand <mhillenb@amazon.de>, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com, linux-mm@kvack.org,
        Alexander Graf <graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>
Subject: [RFC 06/10] kvm/x86: add support for storing vCPU state in process-local memory
Date: Wed, 12 Jun 2019 19:08:36 +0200
Message-Id: <20190612170834.14855-7-mhillenb@amazon.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190612170834.14855-1-mhillenb@amazon.de>
References: <20190612170834.14855-1-mhillenb@amazon.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The hidden KVM state will both contain guest state that is specific to
x86-64 as well as state specific to SVM or VMX, respectively. Thus,
allocate the hidden state in the code paths specific to SVM and VMX. For
the code that is shared between SVM and VMX, introduce a common struct
for hidden guest state.

Signed-off-by: Marius Hillenbrand <mhillenb@amazon.de>
Cc: Alexander Graf <graf@amazon.de>
Cc: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/include/asm/kvm_host.h |  9 ++++++++
 arch/x86/kvm/Kconfig            | 10 +++++++++
 arch/x86/kvm/svm.c              | 37 +++++++++++++++++++++++++++++++-
 arch/x86/kvm/vmx.c              | 38 ++++++++++++++++++++++++++++++++-
 arch/x86/kvm/x86.c              |  5 +++++
 5 files changed, 97 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 5772fba1c64e..41c7b06588f9 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -534,7 +534,16 @@ struct kvm_vcpu_hv {
 	cpumask_t tlb_flush;
 };
 
+#ifdef CONFIG_KVM_PROCLOCAL
+struct kvm_vcpu_arch_hidden {
+	u64 placeholder;
+};
+#endif
+
 struct kvm_vcpu_arch {
+#ifdef CONFIG_KVM_PROCLOCAL
+	struct kvm_vcpu_arch_hidden *hidden;
+#endif
 	/*
 	 * rip and regs accesses must go through
 	 * kvm_{register,rip}_{read,write} functions.
diff --git a/arch/x86/kvm/Kconfig b/arch/x86/kvm/Kconfig
index 80abc68b3e90..a3640e2f1a32 100644
--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -97,6 +97,16 @@ config KVM_MMU_AUDIT
 	 This option adds a R/W kVM module parameter 'mmu_audit', which allows
 	 auditing of KVM MMU events at runtime.
 
+config KVM_PROCLOCAL
+	bool "Use process-local allocation for KVM"
+	depends on KVM && PROCLOCAL
+	---help---
+	  Use process-local memory for storing vCPU state in KVM. This
+	  option removes assets from the kernel's global direct mapping
+	  of physical memory and stores them only in the address space
+	  of the process hosting a VM.
+
+
 # OK, it's a little counter-intuitive to do this, but it puts it neatly under
 # the virtualization menu.
 source drivers/vhost/Kconfig
diff --git a/arch/x86/kvm/svm.c b/arch/x86/kvm/svm.c
index cb202c238de2..af66b93902e5 100644
--- a/arch/x86/kvm/svm.c
+++ b/arch/x86/kvm/svm.c
@@ -41,6 +41,7 @@
 #include <linux/file.h>
 #include <linux/pagemap.h>
 #include <linux/swap.h>
+#include <linux/proclocal.h>
 
 #include <asm/apic.h>
 #include <asm/perf_event.h>
@@ -190,9 +191,20 @@ static u32 msrpm_offsets[MSRPM_OFFSETS] __read_mostly;
  */
 static uint64_t osvw_len = 4, osvw_status;
 
+#ifdef CONFIG_KVM_PROCLOCAL
+struct vcpu_svm_hidden {
+	struct { /* mimic topology in vcpu_svm: */
+		struct kvm_vcpu_arch_hidden arch;
+	} vcpu;
+};
+#endif
+
 struct vcpu_svm {
 	struct kvm_vcpu vcpu;
 	struct vmcb *vmcb;
+#ifdef CONFIG_KVM_PROCLOCAL
+	struct vcpu_svm_hidden *hidden;
+#endif
 	unsigned long vmcb_pa;
 	struct svm_cpu_data *svm_data;
 	uint64_t asid_generation;
@@ -2129,9 +2141,18 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 		goto out;
 	}
 
+#ifdef CONFIG_KVM_PROCLOCAL
+	svm->hidden = kzalloc_proclocal(sizeof(struct vcpu_svm_hidden));
+	if (!svm->hidden) {
+		err = -ENOMEM;
+		goto free_svm;
+	}
+	svm->vcpu.arch.hidden = &svm->hidden->vcpu.arch;
+#endif
+
 	err = kvm_vcpu_init(&svm->vcpu, kvm, id);
 	if (err)
-		goto free_svm;
+		goto free_hidden;
 
 	err = -ENOMEM;
 	page = alloc_page(GFP_KERNEL);
@@ -2187,7 +2208,11 @@ static struct kvm_vcpu *svm_create_vcpu(struct kvm *kvm, unsigned int id)
 	__free_page(page);
 uninit:
 	kvm_vcpu_uninit(&svm->vcpu);
+free_hidden:
+#ifdef CONFIG_KVM_PROCLOCAL
+	kfree_proclocal(svm->hidden);
 free_svm:
+#endif
 	kmem_cache_free(kvm_vcpu_cache, svm);
 out:
 	return ERR_PTR(err);
@@ -2205,6 +2230,16 @@ static void svm_free_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
+#ifdef CONFIG_KVM_PROCLOCAL
+	/*
+	 * note that the hidden vCPU state in a process-local allocation is
+	 * already cleaned up, because a process's mm is torn down before files
+	 * are closed. make any access in the cleanup code very visible.
+	 */
+	svm->hidden = (struct vcpu_svm_hidden *)POISON_POINTER_DELTA;
+	svm->vcpu.arch.hidden = (struct kvm_vcpu_arch_hidden *)POISON_POINTER_DELTA;
+#endif
+
 	/*
 	 * The vmcb page can be recycled, causing a false negative in
 	 * svm_vcpu_load(). So, ensure that no logical CPU has this
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index f9a4faf2d1bc..6f59a6ad7835 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -37,6 +37,8 @@
 #include <linux/hrtimer.h>
 #include <linux/frame.h>
 #include <linux/nospec.h>
+#include <linux/proclocal.h>
+
 #include "kvm_cache_regs.h"
 #include "x86.h"
 
@@ -975,8 +977,19 @@ struct vmx_msrs {
 	struct vmx_msr_entry	val[NR_AUTOLOAD_MSRS];
 };
 
+#ifdef CONFIG_KVM_PROCLOCAL
+struct vcpu_vmx_hidden {
+	struct { /* mimic topology in vcpu_svm: */
+		struct kvm_vcpu_arch_hidden arch;
+	} vcpu;
+};
+#endif
+
 struct vcpu_vmx {
 	struct kvm_vcpu       vcpu;
+#ifdef CONFIG_KVM_PROCLOCAL
+	struct vcpu_vmx_hidden *hidden;
+#endif
 	unsigned long         host_rsp;
 	u8                    fail;
 	u8		      msr_bitmap_mode;
@@ -11756,6 +11769,16 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
+#ifdef CONFIG_KVM_PROCLOCAL
+	/*
+	 * note that the hidden vCPU state in a process-local allocation is
+	 * already cleaned up, because a process's mm is torn down before files
+	 * are closed. make any access in the cleanup code very visible.
+	 */
+	vmx->hidden = (struct vcpu_vmx_hidden *)POISON_POINTER_DELTA;
+	vmx->vcpu.arch.hidden = (struct kvm_vcpu_arch_hidden *)POISON_POINTER_DELTA;
+#endif
+
 	if (enable_pml)
 		vmx_destroy_pml_buffer(vmx);
 	free_vpid(vmx->vpid);
@@ -11777,11 +11800,20 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	if (!vmx)
 		return ERR_PTR(-ENOMEM);
 
+#ifdef CONFIG_KVM_PROCLOCAL
+	vmx->hidden = kzalloc_proclocal(sizeof(struct vcpu_vmx_hidden));
+	if (!vmx->hidden) {
+		err = -ENOMEM;
+		goto free_vcpu;
+	}
+	vmx->vcpu.arch.hidden = &vmx->hidden->vcpu.arch;
+#endif
+
 	vmx->vpid = allocate_vpid();
 
 	err = kvm_vcpu_init(&vmx->vcpu, kvm, id);
 	if (err)
-		goto free_vcpu;
+		goto free_hidden;
 
 	err = -ENOMEM;
 
@@ -11868,7 +11900,11 @@ static struct kvm_vcpu *vmx_create_vcpu(struct kvm *kvm, unsigned int id)
 	vmx_destroy_pml_buffer(vmx);
 uninit_vcpu:
 	kvm_vcpu_uninit(&vmx->vcpu);
+free_hidden:
+#ifdef CONFIG_KVM_PROCLOCAL
+	kfree_proclocal(vmx->hidden);
 free_vcpu:
+#endif
 	free_vpid(vmx->vpid);
 	kmem_cache_free(kvm_vcpu_cache, vmx);
 	return ERR_PTR(err);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 371d98422631..2cfb96ca8cc8 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -9309,6 +9309,11 @@ void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu)
 	free_page((unsigned long)vcpu->arch.pio_data);
 	if (!lapic_in_kernel(vcpu))
 		static_key_slow_dec(&kvm_no_apic_vcpu);
+	/*
+	 * note that the hidden vCPU state in a process-local allocation is
+	 * already cleaned up at this point, because a process's mm is torn down
+	 * before files are closed.
+	 */
 }
 
 void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu)
-- 
2.21.0

