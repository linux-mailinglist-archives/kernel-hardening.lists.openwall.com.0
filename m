Return-Path: <kernel-hardening-return-15839-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E98C7B2F5
	for <lists+kernel-hardening@lfdr.de>; Sat, 27 Apr 2019 08:47:58 +0200 (CEST)
Received: (qmail 5878 invoked by uid 550); 27 Apr 2019 06:43:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5731 invoked from network); 27 Apr 2019 06:43:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=RIE66crRSFais2XMEreovT7cuc4aWzwk2c6XjFrsy1k=;
        b=pYvgo9ZCfUCHvRHlTxheTL9ZRQVp4fim5mJ1MwWcKR1lA8y1aUP/jaFmmW0gvaWJ7S
         zVzA0PQ2EURS5SWk/peFTu1A3/0LRw7DZYQoG4uzOziiwhPRGPxHOWrU2FLz8xJKPBlh
         /zuS4kFNlrBUqnzlR10WasNuwWxPh6kwUkYfWX2HNs3YXw+waJ/qMVcWCQyEr/PXxH6M
         ipIVs/0XiprUGYbGWdjj/stD10SwODP6rYxbEpQWhHBNTSo8/W1+lQ5k//iDxItfsPxn
         hO3NCZNloR7//+m6Eozd9KTmliFtML7SM01N4FLmt+HleGXZ2gYxUmzOYvSuD2G1W0Lp
         NyOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=RIE66crRSFais2XMEreovT7cuc4aWzwk2c6XjFrsy1k=;
        b=l4IS+IX1N2uniQwCxQU1ZjEJIi5tcvhtUkx8lmm4fx9YARa0DekVO+ApDhTFtIVt2P
         Yvpx4N6WUY5JvStgH87tNpnDyJ072Iayukof6kT+LQ5SH1P9nXrqZSrrMT4oCGhUYNib
         btc6yy2Lq8ghKbLCqGlgoJMfseY2VFXFQGrUigNZnQf4k4G7ed8XnWnR59Ml6mLqJQaD
         unCi27mT9hiUjrpNsSI+WfKnuvawItnSHzqoGNlF54e41MrJuMb/oMwdspr3KYF3n1NX
         LXurrIPmeZao3QmkVPRe06T8SEYFTwxmYY/o9fGpusWJGmBcB3o7GI3Uravux4NNw62i
         EaUg==
X-Gm-Message-State: APjAAAWEOIzpkWVOT/49TFKFznRHHe2rU6tOJXPc5RLe9EKBPfgAGiUg
	rClBQFEpRV4hFAZTESp9F60=
X-Google-Smtp-Source: APXvYqwLfbRywYDBLBkn2s5QjOy7Ake8UGyhjw6r9cFTnOHwE2KsORvL/Fy4JLKSQeWsUj9Okam5Jg==
X-Received: by 2002:a17:902:b68e:: with SMTP id c14mr52282678pls.49.1556347412993;
        Fri, 26 Apr 2019 23:43:32 -0700 (PDT)
From: nadav.amit@gmail.com
To: Peter Zijlstra <peterz@infradead.org>,
	Borislav Petkov <bp@alien8.de>,
	Andy Lutomirski <luto@kernel.org>,
	Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	hpa@zytor.com,
	Thomas Gleixner <tglx@linutronix.de>,
	Nadav Amit <nadav.amit@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux_dti@icloud.com,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	akpm@linux-foundation.org,
	kernel-hardening@lists.openwall.com,
	linux-mm@kvack.org,
	will.deacon@arm.com,
	ard.biesheuvel@linaro.org,
	kristen@linux.intel.com,
	deneen.t.dock@intel.com,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Subject: [PATCH v6 20/24] x86/ftrace: Use vmalloc special flag
Date: Fri, 26 Apr 2019 16:22:59 -0700
Message-Id: <20190426232303.28381-21-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190426232303.28381-1-nadav.amit@gmail.com>
References: <20190426232303.28381-1-nadav.amit@gmail.com>

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

Use new flag VM_FLUSH_RESET_PERMS for handling freeing of special
permissioned memory in vmalloc and remove places where memory was set NX
and RW before freeing which is no longer needed.

Acked-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Tested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kernel/ftrace.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 53ba1aa3a01f..0caf8122d680 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -678,12 +678,8 @@ static inline void *alloc_tramp(unsigned long size)
 {
 	return module_alloc(size);
 }
-static inline void tramp_free(void *tramp, int size)
+static inline void tramp_free(void *tramp)
 {
-	int npages = PAGE_ALIGN(size) >> PAGE_SHIFT;
-
-	set_memory_nx((unsigned long)tramp, npages);
-	set_memory_rw((unsigned long)tramp, npages);
 	module_memfree(tramp);
 }
 #else
@@ -692,7 +688,7 @@ static inline void *alloc_tramp(unsigned long size)
 {
 	return NULL;
 }
-static inline void tramp_free(void *tramp, int size) { }
+static inline void tramp_free(void *tramp) { }
 #endif
 
 /* Defined as markers to the end of the ftrace default trampolines */
@@ -808,6 +804,8 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 	/* ALLOC_TRAMP flags lets us know we created it */
 	ops->flags |= FTRACE_OPS_FL_ALLOC_TRAMP;
 
+	set_vm_flush_reset_perms(trampoline);
+
 	/*
 	 * Module allocation needs to be completed by making the page
 	 * executable. The page is still writable, which is a security hazard,
@@ -816,7 +814,7 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 	set_memory_x((unsigned long)trampoline, npages);
 	return (unsigned long)trampoline;
 fail:
-	tramp_free(trampoline, *tramp_size);
+	tramp_free(trampoline);
 	return 0;
 }
 
@@ -947,7 +945,7 @@ void arch_ftrace_trampoline_free(struct ftrace_ops *ops)
 	if (!ops || !(ops->flags & FTRACE_OPS_FL_ALLOC_TRAMP))
 		return;
 
-	tramp_free((void *)ops->trampoline, ops->trampoline_size);
+	tramp_free((void *)ops->trampoline);
 	ops->trampoline = 0;
 }
 
-- 
2.17.1

