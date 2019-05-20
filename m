Return-Path: <kernel-hardening-return-15967-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D7C6B24437
	for <lists+kernel-hardening@lfdr.de>; Tue, 21 May 2019 01:21:55 +0200 (CEST)
Received: (qmail 3604 invoked by uid 550); 20 May 2019 23:20:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3516 invoked from network); 20 May 2019 23:20:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YRvbySHDI9m79O10tEqKVbu0RDekXOTbO/NzB7rAlEs=;
        b=CSmbns2X94WFkKq63CfNfv64datLbczpyGYxten2MqFzl49yU9bBmWzG/njavZRAwJ
         0ptKNku1Fb/sEofgaG4sshjeJnGMSSLIxHORCS7RiYtPv3XAuNZQJR5AVladjzb5vItU
         DtHVyuGOLOroVp/jhzFq4ol6wGf8brRUd2fK0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YRvbySHDI9m79O10tEqKVbu0RDekXOTbO/NzB7rAlEs=;
        b=A4pL23pAgmK3fQZKGnGAF9G03OJIG6ATn0IIKs3/Wyg/4san+t2nQS1FLYaWdDHOWe
         ULAEHNKN06aNu0L1yI5tN1wEsp2c9C/hdY7I89NP4THLakow9lc8rSGbE8eNOM0fsoGL
         a2D6IS/tMW5QgWAcT3jnOKBRSaRccEz3a4y7CjgGxg10RdWEamZpBv0naIybnSa3anWu
         0pjWhQLlT8DYMjXD7nTztlEjHekyEU5zpNzRineE9U1TEbKZu/0lo/mfddqPXV6DPGxh
         L2UYWhgGmstYb/8b08k6ig/5t2ujGUBSDThzyOCX1mziDDrBaNZJkUovzGScE767MX+V
         3sHA==
X-Gm-Message-State: APjAAAW7CQWlRf9thT1hdca0fYGDAE0LB/lynxVKP7GVU1Ei5PjJlI9A
	nTXkyfrMo21x4Q0QLQtKmjAHJq5eMkw=
X-Google-Smtp-Source: APXvYqy24KzqCuoCNaR5XV9MVxMB4poHoGqwCpe+ByXG7wLsxEczPxh3xQpdXoqp2nLas6twp7+gtg==
X-Received: by 2002:a17:902:9693:: with SMTP id n19mr78284329plp.92.1558394416511;
        Mon, 20 May 2019 16:20:16 -0700 (PDT)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	Thomas Garnier <thgarnie@google.com>,
	Pavel Machek <pavel@ucw.cz>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Len Brown <len.brown@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 08/12] x86/acpi: Adapt assembly for PIE support
Date: Mon, 20 May 2019 16:19:33 -0700
Message-Id: <20190520231948.49693-9-thgarnie@chromium.org>
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
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 arch/x86/kernel/acpi/wakeup_64.S | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kernel/acpi/wakeup_64.S b/arch/x86/kernel/acpi/wakeup_64.S
index 510fa12aab73..e080e943e295 100644
--- a/arch/x86/kernel/acpi/wakeup_64.S
+++ b/arch/x86/kernel/acpi/wakeup_64.S
@@ -14,7 +14,7 @@
 	 * Hooray, we are in Long 64-bit mode (but still running in low memory)
 	 */
 ENTRY(wakeup_long64)
-	movq	saved_magic, %rax
+	movq	saved_magic(%rip), %rax
 	movq	$0x123456789abcdef0, %rdx
 	cmpq	%rdx, %rax
 	jne	bogus_64_magic
@@ -25,14 +25,14 @@ ENTRY(wakeup_long64)
 	movw	%ax, %es
 	movw	%ax, %fs
 	movw	%ax, %gs
-	movq	saved_rsp, %rsp
+	movq	saved_rsp(%rip), %rsp
 
-	movq	saved_rbx, %rbx
-	movq	saved_rdi, %rdi
-	movq	saved_rsi, %rsi
-	movq	saved_rbp, %rbp
+	movq	saved_rbx(%rip), %rbx
+	movq	saved_rdi(%rip), %rdi
+	movq	saved_rsi(%rip), %rsi
+	movq	saved_rbp(%rip), %rbp
 
-	movq	saved_rip, %rax
+	movq	saved_rip(%rip), %rax
 	jmp	*%rax
 ENDPROC(wakeup_long64)
 
@@ -45,7 +45,7 @@ ENTRY(do_suspend_lowlevel)
 	xorl	%eax, %eax
 	call	save_processor_state
 
-	movq	$saved_context, %rax
+	leaq	saved_context(%rip), %rax
 	movq	%rsp, pt_regs_sp(%rax)
 	movq	%rbp, pt_regs_bp(%rax)
 	movq	%rsi, pt_regs_si(%rax)
@@ -64,13 +64,14 @@ ENTRY(do_suspend_lowlevel)
 	pushfq
 	popq	pt_regs_flags(%rax)
 
-	movq	$.Lresume_point, saved_rip(%rip)
+	leaq	.Lresume_point(%rip), %rax
+	movq	%rax, saved_rip(%rip)
 
-	movq	%rsp, saved_rsp
-	movq	%rbp, saved_rbp
-	movq	%rbx, saved_rbx
-	movq	%rdi, saved_rdi
-	movq	%rsi, saved_rsi
+	movq	%rsp, saved_rsp(%rip)
+	movq	%rbp, saved_rbp(%rip)
+	movq	%rbx, saved_rbx(%rip)
+	movq	%rdi, saved_rdi(%rip)
+	movq	%rsi, saved_rsi(%rip)
 
 	addq	$8, %rsp
 	movl	$3, %edi
@@ -82,7 +83,7 @@ ENTRY(do_suspend_lowlevel)
 	.align 4
 .Lresume_point:
 	/* We don't restore %rax, it must be 0 anyway */
-	movq	$saved_context, %rax
+	leaq	saved_context(%rip), %rax
 	movq	saved_context_cr4(%rax), %rbx
 	movq	%rbx, %cr4
 	movq	saved_context_cr3(%rax), %rbx
-- 
2.21.0.1020.gf2820cf01a-goog

