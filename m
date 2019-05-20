Return-Path: <kernel-hardening-return-15964-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BF10624433
	for <lists+kernel-hardening@lfdr.de>; Tue, 21 May 2019 01:21:17 +0200 (CEST)
Received: (qmail 2042 invoked by uid 550); 20 May 2019 23:20:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1870 invoked from network); 20 May 2019 23:20:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k9WR796a769X9J4h5bze31x1W8OGsoWfxSCDq+b4bjQ=;
        b=DZY3byJTKsHTOJbQbyjbYDYJC7o1tExaJVvL5UoXYwmejQldkGgfn8J2FCkvJpGphE
         CeouX7pzk5IbV3210hHH2vAPmXKE35GpfFRaHq1ZV/gIzEMjZN2LGTQ0dTpoGxkYs3Xi
         z7ErB7H/BQN5PZy/d2YvNqRgQj2ApPshSaVls=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k9WR796a769X9J4h5bze31x1W8OGsoWfxSCDq+b4bjQ=;
        b=DiSIl2uZZ86wLjb3JTJV46EEgWp0lJQ896/mtUj/DsX0RL/lNKd5TEVXR1haUCRivr
         sM4mZL5ArMHywJQvV5CqwWbWHhYIIGrPe/yEsCeYwhZcZmTuxfZacXAEtxJtEsQdmFvo
         R3UDTstjc7sEfALUHJ2y8oM8DIAF9phuLQ/Tj3kHnNxFsj3TnDsa7lIJyvpZzJ9pTV7y
         ES/C0AZiOJD472j2GYA02T4XbHs82WGqosGR1axg3iuMIr8GOxrPZRGFPD9MGn/W9GTz
         +MHR9om6xrTooXbO/av4NztpT/Fxf3WS62spP/t7FXXWVRc08Pe6WWgyz/oCr0CKXQTO
         ht8A==
X-Gm-Message-State: APjAAAWuiFeay/JIGztMBBzHs0xFVJ+xehAKWOlnowVP4RYa4kpV6sDc
	6Z46OEf6nUSgK49rnrQ1PZ4rmiqpEVY=
X-Google-Smtp-Source: APXvYqxGuZNjeh1amat9jqj306pSHnIg2I7yAJfVSCaE5txAVQxasyESMs/o/eB1nTUWBJ2/UWizAA==
X-Received: by 2002:a63:d04b:: with SMTP id s11mr78740681pgi.187.1558394410230;
        Mon, 20 May 2019 16:20:10 -0700 (PDT)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	Thomas Garnier <thgarnie@google.com>,
	Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 05/12] x86/entry/64: Adapt assembly for PIE support
Date: Mon, 20 May 2019 16:19:30 -0700
Message-Id: <20190520231948.49693-6-thgarnie@chromium.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
In-Reply-To: <20190520231948.49693-1-thgarnie@chromium.org>
References: <20190520231948.49693-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Thomas Garnier <thgarnie@google.com>

Change the assembly code to use only relative references of symbols for the
kernel to be PIE compatible.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/entry/entry_64.S | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/arch/x86/entry/entry_64.S b/arch/x86/entry/entry_64.S
index 20e45d9b4e15..e99b3438aa9b 100644
--- a/arch/x86/entry/entry_64.S
+++ b/arch/x86/entry/entry_64.S
@@ -1268,7 +1268,8 @@ ENTRY(error_entry)
 	movl	%ecx, %eax			/* zero extend */
 	cmpq	%rax, RIP+8(%rsp)
 	je	.Lbstep_iret
-	cmpq	$.Lgs_change, RIP+8(%rsp)
+	leaq	.Lgs_change(%rip), %rcx
+	cmpq	%rcx, RIP+8(%rsp)
 	jne	.Lerror_entry_done
 
 	/*
@@ -1465,10 +1466,10 @@ ENTRY(nmi)
 	 * resume the outer NMI.
 	 */
 
-	movq	$repeat_nmi, %rdx
+	leaq	repeat_nmi(%rip), %rdx
 	cmpq	8(%rsp), %rdx
 	ja	1f
-	movq	$end_repeat_nmi, %rdx
+	leaq	end_repeat_nmi(%rip), %rdx
 	cmpq	8(%rsp), %rdx
 	ja	nested_nmi_out
 1:
@@ -1522,7 +1523,8 @@ nested_nmi:
 	pushq	%rdx
 	pushfq
 	pushq	$__KERNEL_CS
-	pushq	$repeat_nmi
+	leaq	repeat_nmi(%rip), %rdx
+	pushq	%rdx
 
 	/* Put stack back */
 	addq	$(6*8), %rsp
@@ -1561,7 +1563,11 @@ first_nmi:
 	addq	$8, (%rsp)	/* Fix up RSP */
 	pushfq			/* RFLAGS */
 	pushq	$__KERNEL_CS	/* CS */
-	pushq	$1f		/* RIP */
+	pushq	$0		/* Futur return address */
+	pushq	%rax		/* Save RAX */
+	leaq	1f(%rip), %rax	/* RIP */
+	movq    %rax, 8(%rsp)   /* Put 1f on return address */
+	popq	%rax		/* Restore RAX */
 	iretq			/* continues at repeat_nmi below */
 	UNWIND_HINT_IRET_REGS
 1:
-- 
2.21.0.1020.gf2820cf01a-goog

