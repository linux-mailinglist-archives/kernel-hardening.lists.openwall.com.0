Return-Path: <kernel-hardening-return-17037-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BC07BDCAC1
	for <lists+kernel-hardening@lfdr.de>; Fri, 18 Oct 2019 18:16:48 +0200 (CEST)
Received: (qmail 24131 invoked by uid 550); 18 Oct 2019 16:15:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 11291 invoked from network); 18 Oct 2019 16:11:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=5u5MugUg2eXeQck5Unb3LYQo29vaVROeFk+dSkSebHA=;
        b=B7xenBDHHI7ayNn+BP1Q6X8wnTR9uTlyid2Lxqej61gj2k9iN/wuKOJNKBobLxaFjR
         hT53He9gZ81WBRA7k1srlE5y9pRls5zgdJRc8CkufohNb7pDylEtWxFwrE2uoJHPqVMe
         SXZ+LI2gVL3V+ZFsZVGAp19D4zWSpAGia2X5kfETCOjg6mYUy8e3oO5INhcW9tdCJs3Z
         R+qaaFeh57hjiYMhdf3zjE/30gJ8GCvzwq1j+lgdEDaXxK/SXne8U2YrUzyBDK25HLGv
         sScwvilKx4tvHpfuXY9/27TdPb7wP+y5Fbv94C3Elzkmapg0qVwLdFfipvrL/n4U5zdf
         mmCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=5u5MugUg2eXeQck5Unb3LYQo29vaVROeFk+dSkSebHA=;
        b=nBq1bD2S6LVAwNUaI7GDs8KBB+bbjmg4xXoeJR+0CFmYMKoPAIdzr5rn1+ONyodrmt
         qN56veud6b1TwuC7J6V1xbY61ousBjgWOuTiLaXKOwkdAP6DgK/JHoIqMeCCO+MM2Y7H
         9zmbGEOMSuoSOTSqAbCyEkttAr7W60+i9yJX9nanOKHOtKqRP53q4vBQ7fXyAtJaHQu2
         /ItGBTWLw2w0CtuvNMJD7jjv/D7cUFwknlKnzhx828g4jxx7RVvWCIWqM78CUvJU44AJ
         CvJRyjyos7AmIbkKzzBYyNTy+u/NJQCgV/05p32+RLUJCB6ys7odq2Gu6ToNqFcL/Hep
         iz+Q==
X-Gm-Message-State: APjAAAXWTiDleLzdRX93OoSXBGw1TC/7ORL8Gke37S6tFZ42hlxOuT+Z
	Hl64OPfPRQDz1IFj6pfJkfzyZeDgjxsZ8/0el/0=
X-Google-Smtp-Source: APXvYqzL1rNkHTnWVT3YklNHjYJF0z1ethJHe5MAlJ9H7HUMSZwkLdmWhiBEeQet4XLN4HbPHGGrf5qLcex/d/OTBLw=
X-Received: by 2002:a63:541e:: with SMTP id i30mr10990238pgb.130.1571415092950;
 Fri, 18 Oct 2019 09:11:32 -0700 (PDT)
Date: Fri, 18 Oct 2019 09:10:32 -0700
In-Reply-To: <20191018161033.261971-1-samitolvanen@google.com>
Message-Id: <20191018161033.261971-18-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH 17/18] arm64: disable SCS for hypervisor code
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/kvm/hyp/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index ea710f674cb6..96073d81cb3b 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -4,7 +4,8 @@
 #
 
 ccflags-y += -fno-stack-protector -DDISABLE_BRANCH_PROFILING \
-		$(DISABLE_STACKLEAK_PLUGIN)
+		$(DISABLE_STACKLEAK_PLUGIN) \
+		$(DISABLE_SCS)
 
 KVM=../../../../virt/kvm
 
-- 
2.23.0.866.gb869b98d4c-goog

