Return-Path: <kernel-hardening-return-17036-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8EF08DCABC
	for <lists+kernel-hardening@lfdr.de>; Fri, 18 Oct 2019 18:16:37 +0200 (CEST)
Received: (qmail 23582 invoked by uid 550); 18 Oct 2019 16:14:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 10235 invoked from network); 18 Oct 2019 16:11:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=21PQYFGMSyR0vWwlJoWUR0F8CwzgoNMVM1L0Pe6MFrQ=;
        b=XTGR5ysVCvFcDPfDZ2uRa4LSCFJbZwlyniF9TrCYGMBPbkIf0K085EjiQt4ffVYZbT
         yaiGK3y6faisAh6U9/CxmFlLU76VW2yJBLJXrJA65l2MTuNELcBcEAKKoaa0/ytobYt1
         fHBOBarOVqcb9kanEUVa8Ddgrfl9iIQEWkgSVtgsKdKE18WzVjzt/JiQzP1DlMT6n4jU
         kAXZNvTi8r9G3/D4MyaIAco80dTDl8K/TpV2nIA1UUazOM41jXMV5YIAb/W//1YPMnKI
         Y+DGVHPZ9eY1T49HNVfdlWN6taf0ZPGpl8IGYtJKJPC8pDOBJ6EMgatwO8Hvvq48VXqN
         DmCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=21PQYFGMSyR0vWwlJoWUR0F8CwzgoNMVM1L0Pe6MFrQ=;
        b=f7WSC0QL8yf6Qt2DHspQllsjjDR6N/zo50Qzzair0zUltS1rryv9cCphKoEdrfU0DS
         U7gXpE+7PYHKDl7LGeAbD2YcRS1yeT29/4MBHCrhBpQ2jiDCqD1T1JC6e6f8zahU493w
         psty14Rmd1XLrXGu0A5BthV0uOfhcendsFcDtXtyQDQtGXkAdy3lIdqTzznlow1e4YYC
         AZ4TjmKXN8DYI6D1R1uBV4YBCzTolhGJtoefdmcqTalT5depj/aQr1pKWBlKEOAiEyYo
         TKzjVPeSt0fsw2vuzHeeX/8+lyzj6Smjwv1+I3+MEHp8yXi8HSNnQPq5Ui9xOhFvSAQP
         YjIg==
X-Gm-Message-State: APjAAAXR1t8Oq/A57VWKUOhfI/rP04So1iO34Y//gKnEMW7xQ77NRVA+
	H6huCVqkiCVZoOwL6+Rej50fcF7gtqEBVqf5Lwo=
X-Google-Smtp-Source: APXvYqz2h3FK6fOLNjeif4Cg24fCITnU5ZQBquMxea8azTfQWEvOTaNE9xdQyiziN7s60FAxuGyTh4t3prrtUVRlSk8=
X-Received: by 2002:a63:1250:: with SMTP id 16mr10784356pgs.331.1571415090313;
 Fri, 18 Oct 2019 09:11:30 -0700 (PDT)
Date: Fri, 18 Oct 2019 09:10:31 -0700
In-Reply-To: <20191018161033.261971-1-samitolvanen@google.com>
Message-Id: <20191018161033.261971-17-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH 16/18] arm64: kprobes: fix kprobes without CONFIG_KRETPROBES
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

This allows CONFIG_KRETPROBES to be disabled without disabling
kprobes entirely.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/kernel/probes/kprobes.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/kprobes.c
index c4452827419b..98230ae979ca 100644
--- a/arch/arm64/kernel/probes/kprobes.c
+++ b/arch/arm64/kernel/probes/kprobes.c
@@ -551,6 +551,7 @@ void __kprobes __used *trampoline_probe_handler(struct pt_regs *regs)
 	return (void *)orig_ret_address;
 }
 
+#ifdef CONFIG_KRETPROBES
 void __kprobes arch_prepare_kretprobe(struct kretprobe_instance *ri,
 				      struct pt_regs *regs)
 {
@@ -564,6 +565,7 @@ int __kprobes arch_trampoline_kprobe(struct kprobe *p)
 {
 	return 0;
 }
+#endif
 
 int __init arch_init_kprobes(void)
 {
-- 
2.23.0.866.gb869b98d4c-goog

