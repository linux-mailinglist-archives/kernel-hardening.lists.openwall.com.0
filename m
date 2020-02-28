Return-Path: <kernel-hardening-return-17993-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 66231172CB3
	for <lists+kernel-hardening@lfdr.de>; Fri, 28 Feb 2020 01:01:50 +0100 (CET)
Received: (qmail 21529 invoked by uid 550); 28 Feb 2020 00:01:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 20371 invoked from network); 28 Feb 2020 00:01:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fvhzUd6Qu7cjrcCOJttmYiBqe1hyVQ5v3hyhsFuyKi8=;
        b=R0fDgyKLTHQkfsWhWRkFBROySWE56w7r6inEPzUviguIQfBELPtivu7yY4Ik9lv7t7
         /nOIfMq8t2T13X1qgjHYJJ5cidxN2ymJ2qiAEIYtGpRaD6z6Ni0j6HvemLNDgKpXyqwv
         tyPUm4U3B3hIYcksrbm95hIv5aO+ZSAMYtXnc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fvhzUd6Qu7cjrcCOJttmYiBqe1hyVQ5v3hyhsFuyKi8=;
        b=iL9CN488pP72NIBiFXfARVMR8ZI7pT7H3YEHbwGORV0AA27+d/C4oCupelIRpg/U7X
         4SEX3ewJoMh0hG5PxO1seHxK9v5qY/dZ2QmIyXL6TgcYzluTAkgBEYZK9/qzCR6PBSMB
         CvH1YLz++tW1qY+63nIpokEoJ7vAYAA7oSmbizEKd5t7GP858RfEl0IOc9jZ2ujSJL2f
         n7JIcg+JfV24aiARfEJ8lKS4supujpiUrOMArXA8OGqAVmYxFTpZc/KrIwVPjYtE2bZ0
         nEgUGskyHm4QH9qDA938pRyrX7CmtSGrf6qxlbCzdKQJIE/cET7K/wSjk77k4RF/3qCq
         nQfQ==
X-Gm-Message-State: APjAAAWpOhUXl2K2UhELLQ/bCBdkwOKtTCLm9J7zLGrC+rH7Vu2GPa/0
	ki0OLALX0lvxA61Jkmw70sEk3djFp/Q=
X-Google-Smtp-Source: APXvYqwThB4LJ42cXGHIwD4VP+n+OceP9p72vw3hubV+kmuIORRSU7xn+cXTMOPaKk/qKAWgjHeHnQ==
X-Received: by 2002:a63:4e22:: with SMTP id c34mr1833461pgb.263.1582848073452;
        Thu, 27 Feb 2020 16:01:13 -0800 (PST)
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
	Peter Zijlstra <peterz@infradead.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Will Deacon <will@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v11 02/11] x86: Add macro to get symbol address for PIE support
Date: Thu, 27 Feb 2020 16:00:47 -0800
Message-Id: <20200228000105.165012-3-thgarnie@chromium.org>
X-Mailer: git-send-email 2.25.1.481.gfbce0eb801-goog
In-Reply-To: <20200228000105.165012-1-thgarnie@chromium.org>
References: <20200228000105.165012-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new _ASM_MOVABS macro to fetch a symbol address. Replace
"_ASM_MOV $<symbol>, %dst" code construct that are not compatible with
PIE.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
---
 arch/x86/include/asm/asm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/include/asm/asm.h b/arch/x86/include/asm/asm.h
index cd339b88d5d4..644bdbf149ee 100644
--- a/arch/x86/include/asm/asm.h
+++ b/arch/x86/include/asm/asm.h
@@ -32,6 +32,7 @@
 #define _ASM_ALIGN	__ASM_SEL(.balign 4, .balign 8)
 
 #define _ASM_MOV	__ASM_SIZE(mov)
+#define _ASM_MOVABS	__ASM_SEL(movl, movabsq)
 #define _ASM_INC	__ASM_SIZE(inc)
 #define _ASM_DEC	__ASM_SIZE(dec)
 #define _ASM_ADD	__ASM_SIZE(add)
-- 
2.25.1.481.gfbce0eb801-goog

