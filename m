Return-Path: <kernel-hardening-return-15829-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 89778B2EB
	for <lists+kernel-hardening@lfdr.de>; Sat, 27 Apr 2019 08:45:43 +0200 (CEST)
Received: (qmail 3809 invoked by uid 550); 27 Apr 2019 06:43:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3680 invoked from network); 27 Apr 2019 06:43:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=CLKl6NZzJuOK2yM4IgvyVy0XzBWA5gDBiZYSHfLNQ00=;
        b=LWiWMfB1NCPlUWHzx7KNU9QCQPe3RdgA8qCNPze1WHQjmMq2EnzDsMlPceyPd+MHEm
         QMnqsza7hwGkI6ZFGgTOeRjeOEfXCrRJYup1t+tZNnEBvqMdc01pTHEj2bJKvz7BRo7K
         E/q3JXY24fjwRSyZU/Tw4XNKZ1nfyh4euDeX0+jZD8/F9QgFlj4BNpu6QQplyXiEhS74
         PVZ8Bi1kj7P4bpKFaIDD7kzaPwPpjBstpFpZumGDsgFZsa4oA3jDKygoO8TIjMEYq1h+
         8j/kDmbTP0+sW4oBzq9jDl4H2CBcWV2hkh9XtxTKhVDjbhF8cy7tl1t7BO8Iros2slYv
         iP/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=CLKl6NZzJuOK2yM4IgvyVy0XzBWA5gDBiZYSHfLNQ00=;
        b=fpOIJqU6xKS4qAxVrGI5rXVfYZU8t7tAwdKOzIbv4qViBEzzpyMvoedkvTg3xDzjbe
         W8ksWMssyjuxR/+lxT3Y4g6NOnMA9jk83Fw16+tlUUuAhQmMNZeOH4lx9seJ+x2I51QX
         WviHXo21Aq0bmr6BfESssGAUQY0UfQlfDFBkyk4Z9cMbWs+AZnB0DXT98ukbDJAKVDWa
         yPI5H21Sv9dOlq8W+Wg5008lj6qbkF1tzPdQNS7xXUtKNvNYHaULEF9jqBRVmHC86zpk
         JWdfoh6G0yDG9xrPNiN1ZAtGma5N6ZJGuoO6uBhgKHHBdlYJQy4xfvBIbeKjKk0r+l5B
         wCGA==
X-Gm-Message-State: APjAAAXMJevUAL6CwgPxAHJH1yb4UtV0UQtKkjKajkjJlmmlBiFE9e3W
	N6+x6WKtvEN/7jRGt2CfFCU=
X-Google-Smtp-Source: APXvYqx8IDeCvv7F4Tl+g2zi6Qtjw6+CBIajqUbAMvc7uvXy5z6A8pYUXx0y0vJXO744BzKTEFFO2g==
X-Received: by 2002:aa7:91d6:: with SMTP id z22mr42068121pfa.242.1556347399283;
        Fri, 26 Apr 2019 23:43:19 -0700 (PDT)
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
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Nadav Amit <namit@vmware.com>
Subject: [PATCH v6 10/24] x86/ftrace: Set trampoline pages as executable
Date: Fri, 26 Apr 2019 16:22:49 -0700
Message-Id: <20190426232303.28381-11-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190426232303.28381-1-nadav.amit@gmail.com>
References: <20190426232303.28381-1-nadav.amit@gmail.com>

From: Nadav Amit <namit@vmware.com>

Since alloc_module() will not set the pages as executable soon, set
ftrace trampoline pages as executable after they are allocated.

For the time being, do not change ftrace to use the text_poke()
interface. As a result, ftrace still breaks W^X.

Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kernel/ftrace.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index ef49517f6bb2..53ba1aa3a01f 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -730,6 +730,7 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 	unsigned long end_offset;
 	unsigned long op_offset;
 	unsigned long offset;
+	unsigned long npages;
 	unsigned long size;
 	unsigned long retq;
 	unsigned long *ptr;
@@ -762,6 +763,7 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 		return 0;
 
 	*tramp_size = size + RET_SIZE + sizeof(void *);
+	npages = DIV_ROUND_UP(*tramp_size, PAGE_SIZE);
 
 	/* Copy ftrace_caller onto the trampoline memory */
 	ret = probe_kernel_read(trampoline, (void *)start_offset, size);
@@ -806,6 +808,12 @@ create_trampoline(struct ftrace_ops *ops, unsigned int *tramp_size)
 	/* ALLOC_TRAMP flags lets us know we created it */
 	ops->flags |= FTRACE_OPS_FL_ALLOC_TRAMP;
 
+	/*
+	 * Module allocation needs to be completed by making the page
+	 * executable. The page is still writable, which is a security hazard,
+	 * but anyhow ftrace breaks W^X completely.
+	 */
+	set_memory_x((unsigned long)trampoline, npages);
 	return (unsigned long)trampoline;
 fail:
 	tramp_free(trampoline, *tramp_size);
-- 
2.17.1

