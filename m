Return-Path: <kernel-hardening-return-15968-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E96CB24438
	for <lists+kernel-hardening@lfdr.de>; Tue, 21 May 2019 01:22:08 +0200 (CEST)
Received: (qmail 3787 invoked by uid 550); 20 May 2019 23:20:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3704 invoked from network); 20 May 2019 23:20:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ONzLx8copuFlv9pFt6ADTFJUuBuIxgCmzCGCG/RdIgo=;
        b=V/b5UP+FcE4d2e4MWXezl3uUdVXP+/4i56SZjUcx2yGPGkZjECQSxkRgvLzwD3RJmQ
         cE9XtYTwwWYFZvgpeP4jA5/+3jwtbgXhtWSf3/W6gs3UhvfKr19knIh9vqDZ7hR+tI3A
         lBMJDYKsrpyO7lh+2qQArup3WoLVnvi6e49lk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ONzLx8copuFlv9pFt6ADTFJUuBuIxgCmzCGCG/RdIgo=;
        b=rNe3UqFkA2EyF2p62DrWBiGQUBj+RGMKb+b/cls03OPxpZz//Rez/ahbIVC1AGHmg1
         kKBiwQvTsVGozv6n6xOMda91DIei7MWtohUirPpjrJOQO49Un2ywH0cPIkLZjwa4io9O
         hztrqfC4c1rXg10MQOEWiy7IHCA6wlfKu1IGQcbfuB9fOIGPmgdR1mzwYUdIT4GDMpF2
         Fq4EWLs9Jjs0ETfFZgS/wdZlcAlzufEtZosz/9WAzNu4U8zMhYMYEMhUn+vLbYRehS0t
         MCjOZ+WFTOlZLFgiz6fxEGnrWVljPEbwKerp9TwsRmfXPDys4ljvUU3ftb3OFCDLZfB4
         9HiQ==
X-Gm-Message-State: APjAAAXK8XrtUgyhuN0HjOoFyuam9c2YldhUZVOjEGx5wKimYYSWMn2g
	hZF0gNqbuQKpkUa+6KWq7C5F1hjk1Ew=
X-Google-Smtp-Source: APXvYqx1QPTzMDZloi/cuDWG9ySjuBIhqqqFhJ+cbduVxoKXqU6NNipLlJPVOZyuKBaoGJkrxkDo5w==
X-Received: by 2002:a62:ea0a:: with SMTP id t10mr82844553pfh.236.1558394418619;
        Mon, 20 May 2019 16:20:18 -0700 (PDT)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	Thomas Garnier <thgarnie@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Juergen Gross <jgross@suse.com>,
	Feng Tang <feng.tang@intel.com>,
	Maran Wilson <maran.wilson@oracle.com>,
	Jan Beulich <JBeulich@suse.com>,
	Andy Lutomirski <luto@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 09/12] x86/boot/64: Adapt assembly for PIE support
Date: Mon, 20 May 2019 16:19:34 -0700
Message-Id: <20190520231948.49693-10-thgarnie@chromium.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
In-Reply-To: <20190520231948.49693-1-thgarnie@chromium.org>
References: <20190520231948.49693-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Thomas Garnier <thgarnie@google.com>

Change the assembly code to use only relative references of symbols for the
kernel to be PIE compatible.

Early at boot, the kernel is mapped at a temporary address while preparing
the page table. To know the changes needed for the page table with KASLR,
the boot code calculate the difference between the expected address of the
kernel and the one chosen by KASLR. It does not work with PIE because all
symbols in code are relatives. Instead of getting the future relocated
virtual address, you will get the current temporary mapping.
Instructions were changed to have absolute 64-bit references.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/kernel/head_64.S | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index bcd206c8ac90..64a4f0a22b20 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -90,8 +90,10 @@ startup_64:
 	popq	%rsi
 
 	/* Form the CR3 value being sure to include the CR3 modifier */
-	addq	$(early_top_pgt - __START_KERNEL_map), %rax
+	movabs  $(early_top_pgt - __START_KERNEL_map), %rcx
+	addq    %rcx, %rax
 	jmp 1f
+
 ENTRY(secondary_startup_64)
 	UNWIND_HINT_EMPTY
 	/*
@@ -120,7 +122,8 @@ ENTRY(secondary_startup_64)
 	popq	%rsi
 
 	/* Form the CR3 value being sure to include the CR3 modifier */
-	addq	$(init_top_pgt - __START_KERNEL_map), %rax
+	movabs	$(init_top_pgt - __START_KERNEL_map), %rcx
+	addq    %rcx, %rax
 1:
 
 	/* Enable PAE mode, PGE and LA57 */
@@ -138,7 +141,7 @@ ENTRY(secondary_startup_64)
 	movq	%rax, %cr3
 
 	/* Ensure I am executing from virtual addresses */
-	movq	$1f, %rax
+	movabs  $1f, %rax
 	ANNOTATE_RETPOLINE_SAFE
 	jmp	*%rax
 1:
@@ -235,11 +238,12 @@ ENTRY(secondary_startup_64)
 	 *	REX.W + FF /5 JMP m16:64 Jump far, absolute indirect,
 	 *		address given in m16:64.
 	 */
-	pushq	$.Lafter_lret	# put return address on stack for unwinder
+	movabs  $.Lafter_lret, %rax
+	pushq	%rax		# put return address on stack for unwinder
 	xorl	%ebp, %ebp	# clear frame pointer
-	movq	initial_code(%rip), %rax
+	leaq	initial_code(%rip), %rax
 	pushq	$__KERNEL_CS	# set correct cs
-	pushq	%rax		# target address in negative space
+	pushq	(%rax)		# target address in negative space
 	lretq
 .Lafter_lret:
 END(secondary_startup_64)
-- 
2.21.0.1020.gf2820cf01a-goog

