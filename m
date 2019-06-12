Return-Path: <kernel-hardening-return-16112-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9E89F42D3E
	for <lists+kernel-hardening@lfdr.de>; Wed, 12 Jun 2019 19:15:09 +0200 (CEST)
Received: (qmail 5587 invoked by uid 550); 12 Jun 2019 17:14:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 28102 invoked from network); 12 Jun 2019 17:12:09 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
  t=1560359529; x=1591895529;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=y0y2fCtE+zaOH2XT3643VHxhFHXbECws0ZTrhMzBQQU=;
  b=baP9bdjesY7ARwXbOgbDG2VS1GR6kL4xj/dVe4caaTROuG3y+gDBRrfW
   W4Qruq7PKXIsLq2Ugh670r/ufoM3rYiu2avB+dXf4YTNt2F4Wemk5cCoM
   sIp71KCKgPXEUut6GMxFkB0Kf4lo37R0hLMD9YnAcUhDs74/kOOcb1iga
   E=;
X-IronPort-AV: E=Sophos;i="5.62,366,1554768000"; 
   d="scan'208";a="805048839"
From: Marius Hillenbrand <mhillenb@amazon.de>
To: kvm@vger.kernel.org
Cc: Marius Hillenbrand <mhillenb@amazon.de>, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com, linux-mm@kvack.org,
        Alexander Graf <graf@amazon.de>, David Woodhouse <dwmw@amazon.co.uk>,
        Julian Stecklina <jsteckli@amazon.de>
Subject: [RFC 08/10] kvm, vmx: move register clearing out of assembly path
Date: Wed, 12 Jun 2019 19:08:40 +0200
Message-Id: <20190612170834.14855-9-mhillenb@amazon.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190612170834.14855-1-mhillenb@amazon.de>
References: <20190612170834.14855-1-mhillenb@amazon.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Julian Stecklina <jsteckli@amazon.de>

Split the security related register clearing out of the large inline
assembly VM entry path. This results in two slightly less complicated
inline assembly statements, where it is clearer what each one does.

Signed-off-by: Julian Stecklina <jsteckli@amazon.de>
[rebased to 4.20; note that the purpose of this patch is to make the
changes in the next commit more readable. we will drop this patch when
rebasing to 5.x, since major refactoring of KVM makes it redundant.]
Signed-off-by: Marius Hillenbrand <mhillenb@amazon.de>
Cc: Alexander Graf <graf@amazon.de>
Cc: David Woodhouse <dwmw@amazon.co.uk>
---
 arch/x86/kvm/vmx.c | 46 +++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 16a383635b59..0fe9a4ab8268 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -11582,24 +11582,7 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 		"mov %%r13, %c[r13](%0) \n\t"
 		"mov %%r14, %c[r14](%0) \n\t"
 		"mov %%r15, %c[r15](%0) \n\t"
-		/*
-		* Clear host registers marked as clobbered to prevent
-		* speculative use.
-		*/
-		"xor %%r8d,  %%r8d \n\t"
-		"xor %%r9d,  %%r9d \n\t"
-		"xor %%r10d, %%r10d \n\t"
-		"xor %%r11d, %%r11d \n\t"
-		"xor %%r12d, %%r12d \n\t"
-		"xor %%r13d, %%r13d \n\t"
-		"xor %%r14d, %%r14d \n\t"
-		"xor %%r15d, %%r15d \n\t"
 #endif
-
-		"xor %%eax, %%eax \n\t"
-		"xor %%ebx, %%ebx \n\t"
-		"xor %%esi, %%esi \n\t"
-		"xor %%edi, %%edi \n\t"
 		"pop  %%" _ASM_BP "; pop  %%" _ASM_DX " \n\t"
 		".pushsection .rodata \n\t"
 		".global vmx_return \n\t"
@@ -11636,6 +11619,35 @@ static void __noclone vmx_vcpu_run(struct kvm_vcpu *vcpu)
 #endif
 	      );
 
+	/*
+         * Explicitly clear (in addition to marking them as clobbered) all GPRs
+         * that have not been loaded with host state to prevent speculatively
+         * using the guest's values.
+         */
+	asm volatile (
+		"xor %%eax, %%eax \n\t"
+		"xor %%ebx, %%ebx \n\t"
+		"xor %%esi, %%esi \n\t"
+		"xor %%edi, %%edi \n\t"
+#ifdef CONFIG_X86_64
+		"xor %%r8d,  %%r8d \n\t"
+		"xor %%r9d,  %%r9d \n\t"
+		"xor %%r10d, %%r10d \n\t"
+		"xor %%r11d, %%r11d \n\t"
+		"xor %%r12d, %%r12d \n\t"
+		"xor %%r13d, %%r13d \n\t"
+		"xor %%r14d, %%r14d \n\t"
+		"xor %%r15d, %%r15d \n\t"
+#endif
+		::: "cc"
+#ifdef CONFIG_X86_64
+		 , "rax", "rbx", "rsi", "rdi"
+		 , "r8", "r9", "r10", "r11", "r12", "r13", "r14", "r15"
+#else
+		 , "eax", "ebx", "esi", "edi"
+#endif
+		);
+
 	/*
 	 * We do not use IBRS in the kernel. If this vCPU has used the
 	 * SPEC_CTRL MSR it may have left it on; save the value and
-- 
2.21.0

