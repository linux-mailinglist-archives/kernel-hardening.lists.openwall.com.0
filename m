Return-Path: <kernel-hardening-return-15963-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 32EEC2442A
	for <lists+kernel-hardening@lfdr.de>; Tue, 21 May 2019 01:21:05 +0200 (CEST)
Received: (qmail 1869 invoked by uid 550); 20 May 2019 23:20:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1811 invoked from network); 20 May 2019 23:20:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=nGg2Bf2w3MsVGdZaS2JSU4wTchs3K+c20QEWcpV3rEI=;
        b=ERQB0e/P/lRXortlWIvM98+deOc4OBxaHJswmyMJMwN9AnRICP7O7xG5wHxdekxpip
         dVMA+/UHxaBWcNsOnnphQV7FP76TIavW2uK/wSid2a3PiFEtLKfG07ueDAPodcbMKcY9
         hB/qqPWjpM+LkCjxrt8yNsfc/gHSs5GoTKR+4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nGg2Bf2w3MsVGdZaS2JSU4wTchs3K+c20QEWcpV3rEI=;
        b=tJtnus3TN3XbGAyZwx/vsu3j84QEkbzboJZ8jOhX7Tq+I24uwPy3b5l6ZqC730VD2H
         1EuRJB09z/JxIzNcWZnxKkF+zYI9hkQshbM8SLggrtVzQMgPTkw9ZfG9bwdKiNuObQBm
         ks20mLlCpUzouHS0JwmIl/3C404v73rBGtCCVnpZVJjsALzWR77y7fyfjjyLZCcR2oo1
         8/cH+m5twxbMeRZmey8Y8WfumtKRI53N7aPSWjCTs8ywh87rC0PTLUjJ5EP7xAfjjlGo
         jBVpeW1LmFpgwn71ExyVypEnh9kUybk2sq6k0A8u/dyM8ScwYCnVdnTeZgyNtYZ8iQHR
         MNQQ==
X-Gm-Message-State: APjAAAWiig9IZzkXppEO39mWfPUz2biiHqSOGcKX6xHvr6W/5j7ie5OW
	qPSFCY+8aqgj8o41y/NoBp4eDqAs0aY=
X-Google-Smtp-Source: APXvYqwCz/NeyhSKhhkjC1U3Pv0Ghct2bpZ0T1Gy0WqWYRztBFt7DlYc23EJLLkNN75S8gKKS6khNQ==
X-Received: by 2002:a62:e201:: with SMTP id a1mr82910863pfi.67.1558394409379;
        Mon, 20 May 2019 16:20:09 -0700 (PDT)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	Thomas Garnier <thgarnie@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 04/12] x86: relocate_kernel - Adapt assembly for PIE support
Date: Mon, 20 May 2019 16:19:29 -0700
Message-Id: <20190520231948.49693-5-thgarnie@chromium.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
In-Reply-To: <20190520231948.49693-1-thgarnie@chromium.org>
References: <20190520231948.49693-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Thomas Garnier <thgarnie@google.com>

Change the assembly code to use only absolute references of symbols for the
kernel to be PIE compatible.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/kernel/relocate_kernel_64.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/relocate_kernel_64.S b/arch/x86/kernel/relocate_kernel_64.S
index 11eda21eb697..3320368b6ec9 100644
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -208,7 +208,7 @@ identity_mapped:
 	movq	%rax, %cr3
 	lea	PAGE_SIZE(%r8), %rsp
 	call	swap_pages
-	movq	$virtual_mapped, %rax
+	movabsq	$virtual_mapped, %rax
 	pushq	%rax
 	ret
 
-- 
2.21.0.1020.gf2820cf01a-goog

