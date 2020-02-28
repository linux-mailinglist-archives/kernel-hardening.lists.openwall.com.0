Return-Path: <kernel-hardening-return-17999-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id CAAEC172CBD
	for <lists+kernel-hardening@lfdr.de>; Fri, 28 Feb 2020 01:02:44 +0100 (CET)
Received: (qmail 22380 invoked by uid 550); 28 Feb 2020 00:01:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22302 invoked from network); 28 Feb 2020 00:01:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FFmbceD7QHP2G9Ca/GnJtf4RpKTt/GJIPcRUSUwSzaM=;
        b=cPSt7bG5f9am1KrbI/3idQAzXifp6xRIa4U46unWv7iH/cibsg+eZ8l1rB6LPI4A3J
         8rCXT984f0GR9+WFpo9bKN6sz8MJaqhBVXKhhhDkItlzI97jFLioOsVRSWGgtH1SyOcq
         nZKW7rm5ajlWmnAvixODO9wGmSW1zN7cSoBKQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FFmbceD7QHP2G9Ca/GnJtf4RpKTt/GJIPcRUSUwSzaM=;
        b=UGyyJHsKrFu5rA1GMm973xmZf1ZRb3y0U5GN8v7GbqfgQZMk6SPHxCQoYdywTuQ7Ys
         TGkWCT+9wdJFnTLLxXeTgxxd6Ld/+MRdF4HUnndzeMuPjKFLuo5kds38q/ihXySSogCO
         NU74cdIf9vwq/ga0Jpl2eDliLFTWzYxQl8RO3PsEp75VhOl8D73UN4GPy42EXnpUT9b+
         RSOmyRDu/yRXs3WpkdMWLzck/46e1Ty+0kwydD1M+WmKBT01yV+TXa9s1xiJML5QQscc
         cNUjLEoA+2jQWZ8izjKSU2QkXmFPi6ldMMg4lHUvgyStTsmaZFmV5NYb5JbW4MDJtgDc
         5hVg==
X-Gm-Message-State: APjAAAVAjMlIVtchSOosRAMWCK6nBBjF3OomZ5l4Jc8UhC5yTV7OQSHy
	Zn/z1EppEpo4k94urJQmdSSTE5cvZPg=
X-Google-Smtp-Source: APXvYqxzxq/RTsPVyBecAqne+dw68kSQHDmNiBFv21TtsNfqzjAmpUojokc1C1FJiTR3aVdLqW7w3Q==
X-Received: by 2002:a17:902:708c:: with SMTP id z12mr1371193plk.0.1582848084250;
        Thu, 27 Feb 2020 16:01:24 -0800 (PST)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	keescook@chromium.org,
	Thomas Garnier <thgarnie@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	Jiri Slaby <jslaby@suse.cz>,
	Peter Zijlstra <peterz@infradead.org>,
	Cao jin <caoj.fnst@cn.fujitsu.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v11 08/11] x86/boot/64: Adapt assembly for PIE support
Date: Thu, 27 Feb 2020 16:00:53 -0800
Message-Id: <20200228000105.165012-9-thgarnie@chromium.org>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
In-Reply-To: <20200228000105.165012-1-thgarnie@chromium.org>
References: <20200228000105.165012-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change the assembly code to use absolute reference for transition
between address spaces and relative references when referencing global
variables in the same address space. Ensure the kernel built with PIE
references the correct addresses based on context.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/kernel/head_64.S | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index 4bbc770af632..40a467f8e116 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -87,7 +87,8 @@ SYM_CODE_START_NOALIGN(startup_64)
 	popq	%rsi
 
 	/* Form the CR3 value being sure to include the CR3 modifier */
-	addq	$(early_top_pgt - __START_KERNEL_map), %rax
+	movabs  $(early_top_pgt - __START_KERNEL_map), %rcx
+	addq    %rcx, %rax
 	jmp 1f
 SYM_CODE_END(startup_64)
 
@@ -119,7 +120,8 @@ SYM_CODE_START(secondary_startup_64)
 	popq	%rsi
 
 	/* Form the CR3 value being sure to include the CR3 modifier */
-	addq	$(init_top_pgt - __START_KERNEL_map), %rax
+	movabs	$(init_top_pgt - __START_KERNEL_map), %rcx
+	addq    %rcx, %rax
 1:
 
 	/* Enable PAE mode, PGE and LA57 */
@@ -137,7 +139,7 @@ SYM_CODE_START(secondary_startup_64)
 	movq	%rax, %cr3
 
 	/* Ensure I am executing from virtual addresses */
-	movq	$1f, %rax
+	movabs  $1f, %rax
 	ANNOTATE_RETPOLINE_SAFE
 	jmp	*%rax
 1:
@@ -234,11 +236,12 @@ SYM_CODE_START(secondary_startup_64)
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
 SYM_CODE_END(secondary_startup_64)
-- 
2.25.1.481.gfbce0eb801-goog

