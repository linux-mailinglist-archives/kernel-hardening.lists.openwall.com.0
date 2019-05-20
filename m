Return-Path: <kernel-hardening-return-15969-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2F81F2443A
	for <lists+kernel-hardening@lfdr.de>; Tue, 21 May 2019 01:22:22 +0200 (CEST)
Received: (qmail 3846 invoked by uid 550); 20 May 2019 23:20:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3770 invoked from network); 20 May 2019 23:20:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1tp0hWg+Fv4tFS/1ogVPOUXaReV0m0NPqcPhlDEcA4M=;
        b=V2XT6VyD2+DXGZSgdKWFvfyai33es5DC+pNYfU1uPcQQUXoX4sf/c4bDjhULluZD/c
         MfaAquz2qQ7KJQkg9vWSvHcjVIvgRjEQ2Gqt453NVNd8pDuqKvbFpR3SRpLoo9Fhn3Bn
         YPOOGVv69va+6L6dfkLJtQqk9v+n5hsgQ/cqw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1tp0hWg+Fv4tFS/1ogVPOUXaReV0m0NPqcPhlDEcA4M=;
        b=tQy9k/ZBfv7Kv1kPG/rJoF6WKtaXp5aSeHc4ITWJC45inLGxkV+wv75xmRsom+AW+a
         RjET/+eaG6hJ8D51ndz/nwpri5y8007xaAic6u0LRi1XRsspdKoy7DTED9wKYZu3xwHy
         SeVGwKNt7RIEYabgghZlNVIDfNfGju6/xHtFYwbyARGC0qeQVAeHJBBetH8/dVK6LVDV
         3XoOgQpXm7nl7i/nPPribVEYF01KkuRkTC6sDl+kQFOr0mHlW+GpxuuJSXnnQY0Z3ZZI
         uL9nsV0Xf/MZbxGIvmgYEZm+zctgxlIkjenTzkH+j3mT6Jab76o5MShTEtVmTAQBJKa/
         eQGQ==
X-Gm-Message-State: APjAAAVz1HiZkAjR1asmknp3jJlcMlLOxbAMpuRn+A1asIXCzVgKc+rB
	ARp02k6NclsxpwIBMgingyayNKtMs5s=
X-Google-Smtp-Source: APXvYqzGnLop82FsJKmnNwPR3WWLt5KGSTjBnQrRed8+UZU4RsaefgYELhyIPHlFuCzzzBwKRGJPNA==
X-Received: by 2002:a17:902:9348:: with SMTP id g8mr36216437plp.174.1558394419565;
        Mon, 20 May 2019 16:20:19 -0700 (PDT)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	Thomas Garnier <thgarnie@google.com>,
	Pavel Machek <pavel@ucw.cz>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	linux-pm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 10/12] x86/power/64: Adapt assembly for PIE support
Date: Mon, 20 May 2019 16:19:35 -0700
Message-Id: <20190520231948.49693-11-thgarnie@chromium.org>
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
 arch/x86/power/hibernate_asm_64.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/power/hibernate_asm_64.S b/arch/x86/power/hibernate_asm_64.S
index 3008baa2fa95..9ed980efef72 100644
--- a/arch/x86/power/hibernate_asm_64.S
+++ b/arch/x86/power/hibernate_asm_64.S
@@ -24,7 +24,7 @@
 #include <asm/frame.h>
 
 ENTRY(swsusp_arch_suspend)
-	movq	$saved_context, %rax
+	leaq	saved_context(%rip), %rax
 	movq	%rsp, pt_regs_sp(%rax)
 	movq	%rbp, pt_regs_bp(%rax)
 	movq	%rsi, pt_regs_si(%rax)
@@ -115,7 +115,7 @@ ENTRY(restore_registers)
 	movq	%rax, %cr4;  # turn PGE back on
 
 	/* We don't restore %rax, it must be 0 anyway */
-	movq	$saved_context, %rax
+	leaq	saved_context(%rip), %rax
 	movq	pt_regs_sp(%rax), %rsp
 	movq	pt_regs_bp(%rax), %rbp
 	movq	pt_regs_si(%rax), %rsi
-- 
2.21.0.1020.gf2820cf01a-goog

