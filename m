Return-Path: <kernel-hardening-return-18000-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 15B4E172CBE
	for <lists+kernel-hardening@lfdr.de>; Fri, 28 Feb 2020 01:02:55 +0100 (CET)
Received: (qmail 23565 invoked by uid 550); 28 Feb 2020 00:01:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22435 invoked from network); 28 Feb 2020 00:01:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kBSUTQnCJbQV5pLuilITF26DLiWa2/2BRxaonElBTNQ=;
        b=ffRKFmzsputibNvCgTe4Pi3ww1xoPkHdMAQDjclUSxqmZY4+B8q2nf8RNjriw9Jun8
         QhjORrkShnXbbpqxKBG/5Su6vB1b54AxLYFiIWsapbzv3qhMKXOF8fcrqkG/eiTa+yHW
         WFQkVpmaUq0W/I2eBjsIlKnDUM+QUKxZzz2Ck=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kBSUTQnCJbQV5pLuilITF26DLiWa2/2BRxaonElBTNQ=;
        b=D0p2XeVlEvUE8yQ7FYUkbf5sfWZB0FknXLwUsFcv0keoybVDWhZg1OF3VrwIkiG9H+
         PLajkPDH3R6YHavLVLfxDKR+AL46CsGG5ST/8hm1co1+BS3doyQyg9mNzoquC+daSxAO
         2HTTOW33Z0iDpMh14xSkFUfAhEiqs2APH6j9xUTGCSqSHUvzuoHqk3LokB8DZpo6fDg2
         A4XLncRRrGVc8HWdQZ5dBUzZ7fHS1g6u+nRJwdwQ/cGX38EGXJ52dkSCNqE6YnqYdtgS
         PPLsux/EOFE9fOCtIKV2XIxEfBz4b7Cv12pIyzCvieP9FdVgqiWrl19AL06icj2QJBBj
         U9aA==
X-Gm-Message-State: APjAAAUz6p780LSM0BLHE9GD+8CwxfWsBSpoZbL4GooH09y7Y/n3/H6o
	kpGbsSuo7E01Ty0RbzUF6tZBXpOF8PA=
X-Google-Smtp-Source: APXvYqzDwLydiJZoarH5wzoZjhL6Dn3ngsWTMAguCr0uuaAVQX0qWk1h8b0wS+NGFKCGYWdFG0VCCg==
X-Received: by 2002:a17:90a:da01:: with SMTP id e1mr1626609pjv.100.1582848085161;
        Thu, 27 Feb 2020 16:01:25 -0800 (PST)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	keescook@chromium.org,
	Thomas Garnier <thgarnie@chromium.org>,
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
Subject: [PATCH v11 09/11] x86/power/64: Adapt assembly for PIE support
Date: Thu, 27 Feb 2020 16:00:54 -0800
Message-Id: <20200228000105.165012-10-thgarnie@chromium.org>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
In-Reply-To: <20200228000105.165012-1-thgarnie@chromium.org>
References: <20200228000105.165012-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change the assembly code to use only relative references of symbols for the
kernel to be PIE compatible.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
Acked-by: Pavel Machek <pavel@ucw.cz>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/power/hibernate_asm_64.S | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/power/hibernate_asm_64.S b/arch/x86/power/hibernate_asm_64.S
index 7918b8415f13..977b8ae85045 100644
--- a/arch/x86/power/hibernate_asm_64.S
+++ b/arch/x86/power/hibernate_asm_64.S
@@ -23,7 +23,7 @@
 #include <asm/frame.h>
 
 SYM_FUNC_START(swsusp_arch_suspend)
-	movq	$saved_context, %rax
+	leaq	saved_context(%rip), %rax
 	movq	%rsp, pt_regs_sp(%rax)
 	movq	%rbp, pt_regs_bp(%rax)
 	movq	%rsi, pt_regs_si(%rax)
@@ -116,7 +116,7 @@ SYM_FUNC_START(restore_registers)
 	movq	%rax, %cr4;  # turn PGE back on
 
 	/* We don't restore %rax, it must be 0 anyway */
-	movq	$saved_context, %rax
+	leaq	saved_context(%rip), %rax
 	movq	pt_regs_sp(%rax), %rsp
 	movq	pt_regs_bp(%rax), %rbp
 	movq	pt_regs_si(%rax), %rsi
-- 
2.25.1.481.gfbce0eb801-goog

