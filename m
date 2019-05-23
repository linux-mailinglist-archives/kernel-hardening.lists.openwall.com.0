Return-Path: <kernel-hardening-return-15989-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8EFEF281D7
	for <lists+kernel-hardening@lfdr.de>; Thu, 23 May 2019 17:54:08 +0200 (CEST)
Received: (qmail 17646 invoked by uid 550); 23 May 2019 15:53:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 27996 invoked from network); 23 May 2019 12:42:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NCAxoLMPldvKQMidzNTr8hyOEHq1jSHIcOt+CxAESVs=;
        b=kwxaN5TXi2fzUmuexBBY0GXWxXPKI1jjIZBR+Z9tiHoEQ/9ujAqPr7MVyXRNhvSd9+
         AK6kCkOhJm5SbE0jSM+BNskxXce/VCkWz+Q+nhHVzGM9EiVIxQWQw6xGFRwc293n6pL6
         UjuOZc6NpSLuxS9lgkZ9YHgOqEJdb30RHbq5NVEGKZ2RrMvsO8eGym5LjADg9LCNz+Mj
         M2xn9+Ia0uIgVsD4bzKVJvdYZBbu08DtKLv/k2Kp238pWpoARR/ey5wwSaCTCcg+zg5u
         IdrKv4BJiVUrPXZyjmF08n8tXNbuPmuj2yNUQwZ+XjwO6HLAiarXc1mbTJcvhpLSEk3Y
         /qnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NCAxoLMPldvKQMidzNTr8hyOEHq1jSHIcOt+CxAESVs=;
        b=Y5bCHu8BQKboX2fmsmiB+h2+WBZyKoVdoQn76hwCe/lqDKr0CVkqBSiwfrJejHmFVt
         5Mwdq2kwhPuy02RuB9pauTRMny+W9ZgrAyXviKVSgosnfcziGPjGzQZgik7uAEgcipOc
         eR6ewT3sVeUwqqkqNNwTpTC5uxw8pFtKPz6t4JiwzEh/KzthnBCpvPWCyqyGrDk4rqFh
         +wvlkLHPI3yXlPT3DOkQ69RKfoD5GI80c37G1HerI8H2lzN+Ts5x53CMp6Cp8IkUGjk2
         YMZ5INGYH6pYgKmZgo+0OLdsQoInPmKoGJlVwwFuA8PRmlm6XRNImw9g+HFwKnUSibuR
         ku4Q==
X-Gm-Message-State: APjAAAWuWFPrbKKJG/bYd7h8UmJqtkAedVkL+TotpoxxoIKNWmE7zOyU
	v72OXln/YZUdlHVQMfssFA209Ql4O28=
X-Google-Smtp-Source: APXvYqyogFkZZsLOf7+neUZRBCYC8MGU1KnLcLqehoJt4hw5P+8oApijqvC8NaJniUHj65EbWsPUM/NXYM8=
X-Received: by 2002:a1f:944d:: with SMTP id w74mr1575300vkd.38.1558615355140;
 Thu, 23 May 2019 05:42:35 -0700 (PDT)
Date: Thu, 23 May 2019 14:42:15 +0200
In-Reply-To: <20190523124216.40208-1-glider@google.com>
Message-Id: <20190523124216.40208-3-glider@google.com>
Mime-Version: 1.0
References: <20190523124216.40208-1-glider@google.com>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
Subject: [PATCH 2/3] mm: init: report memory auto-initialization features at
 boot time
From: Alexander Potapenko <glider@google.com>
To: akpm@linux-foundation.org, cl@linux.com, keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>, 
	James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>, Kostya Serebryany <kcc@google.com>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, Matthew Wilcox <willy@infradead.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Randy Dunlap <rdunlap@infradead.org>, 
	Sandeep Patil <sspatil@android.com>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Souptick Joarder <jrdr.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Print the currently enabled stack and heap initialization modes.

The possible options for stack are:
 - "all" for CONFIG_INIT_STACK_ALL;
 - "byref_all" for CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL;
 - "byref" for CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF;
 - "__user" for CONFIG_GCC_PLUGIN_STRUCTLEAK_USER;
 - "off" otherwise.

Depending on the values of init_on_alloc and init_on_free boottime
options we also report "heap alloc" and "heap free" as "on"/"off".

In the init_on_free mode initializing pages at boot time may take some
time, so print a notice about that as well.

Signed-off-by: Alexander Potapenko <glider@google.com>
Suggested-by: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@linux.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: James Morris <jmorris@namei.org>
Cc: Jann Horn <jannh@google.com>
Cc: Kostya Serebryany <kcc@google.com>
Cc: Laura Abbott <labbott@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Sandeep Patil <sspatil@android.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Cc: kernel-hardening@lists.openwall.com
Cc: linux-mm@kvack.org
Cc: linux-security-module@vger.kernel.org
---
 init/main.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/init/main.c b/init/main.c
index 5a2c69b4d7b3..90f721c58e61 100644
--- a/init/main.c
+++ b/init/main.c
@@ -519,6 +519,29 @@ static inline void initcall_debug_enable(void)
 }
 #endif
 
+/* Report memory auto-initialization states for this boot. */
+void __init report_meminit(void)
+{
+	const char *stack;
+
+	if (IS_ENABLED(CONFIG_INIT_STACK_ALL))
+		stack = "all";
+	else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL))
+		stack = "byref_all";
+	else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF))
+		stack = "byref";
+	else if (IS_ENABLED(CONFIG_GCC_PLUGIN_STRUCTLEAK_USER))
+		stack = "__user";
+	else
+		stack = "off";
+
+	pr_info("mem auto-init: stack:%s, heap alloc:%s, heap free:%s\n",
+		stack, want_init_on_alloc(GFP_KERNEL) ? "on" : "off",
+		want_init_on_free() ? "on" : "off");
+	if (want_init_on_free())
+		pr_info("Clearing system memory may take some time...\n");
+}
+
 /*
  * Set up kernel memory allocators
  */
@@ -529,6 +552,7 @@ static void __init mm_init(void)
 	 * bigger than MAX_ORDER unless SPARSEMEM.
 	 */
 	page_ext_init_flatmem();
+	report_meminit();
 	mem_init();
 	kmem_cache_init();
 	pgtable_init();
-- 
2.21.0.1020.gf2820cf01a-goog

