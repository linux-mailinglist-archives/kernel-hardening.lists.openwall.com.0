Return-Path: <kernel-hardening-return-15999-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 915D92DF78
	for <lists+kernel-hardening@lfdr.de>; Wed, 29 May 2019 16:17:58 +0200 (CEST)
Received: (qmail 5353 invoked by uid 550); 29 May 2019 14:17:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 18055 invoked from network); 29 May 2019 12:38:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=OTSVci+9HQFGuKiIh59lqpYGkMYL4TSES3kfTgmqHdU=;
        b=QVUrmXjBtd4xAGA041VU9vn2Wo24J0G/ryDcfbSzyIaXXA9eT1e/5dNi0QJEzMBCWq
         fN3WkgM5gqMR9l0iwxBy9vH+tbNaCYmzc3eMgJngHj1kSa5AtgjWh5+5HjO/QfCZpvY6
         Jb+OfcJFPlWhCrVMcT9BX7VIzn5XFynOaCCkftBB3mbVd1JQuJaHm0m7kyXHACmQ9cgW
         9zAnA35gH0p0YX9UacAq6LYdKrQ3NUIsIStqgl+m5S9sxABy/LK6SgMc6qA6s4YfiEYT
         SjwPmB5DRuLJ/T8J4jYw4vuR8yqEzw06eiiDOGT9MuQeYfiVfkXQYF9mVBXb/uZL2taU
         nQYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=OTSVci+9HQFGuKiIh59lqpYGkMYL4TSES3kfTgmqHdU=;
        b=qKcMq7MxJut9K4aGgrdxvvGNDbpucBQyUqnnNjrjvqyM0kK3ix6DZUh5wKvjGpXlNa
         RhW3w9XO7dqEgGbe03JQt5CUn08bvwtJjL4c13ITqXuzOEktuQI7ObrpvMBEQ9RTIuPO
         3A5zGHHlEdUGUC7yPJO6t4I5l/eHYOC2zkLatMY46jwogoKJEdn4p0m3ZTUjQdSY1ThY
         5Scz5oBhSKwo8edHWAg1DxSdMomyIHTF0DgmCk8v8KDYh5j05aixGl7UmObYgfQJeW4b
         cXLhUcrC6JEvhHRw4h+dKlHn8tCGh8czUvr2PZfD6YOaV+wIMW9lMchIo3rrlvLTNuab
         zOuQ==
X-Gm-Message-State: APjAAAXbw5Ie4udIUmIXfwj8+6ZIZCPFx5b21CKJbaiyaepK8VNjNLTj
	ZKKVknEoIcfcUhODu8WZj5XmIVtpFAE=
X-Google-Smtp-Source: APXvYqyuj6WNrP123438HFtnTx32oR/o63x7jglpOtKNMGuuQ+g2SgRyW1Nxym/uXkKBa07I2QYAnrLim8k=
X-Received: by 2002:a05:620a:141a:: with SMTP id d26mr6791202qkj.32.1559133513103;
 Wed, 29 May 2019 05:38:33 -0700 (PDT)
Date: Wed, 29 May 2019 14:38:11 +0200
In-Reply-To: <20190529123812.43089-1-glider@google.com>
Message-Id: <20190529123812.43089-3-glider@google.com>
Mime-Version: 1.0
References: <20190529123812.43089-1-glider@google.com>
X-Mailer: git-send-email 2.22.0.rc1.257.g3120a18244-goog
Subject: [PATCH v5 2/3] mm: init: report memory auto-initialization features
 at boot time
From: Alexander Potapenko <glider@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>
Cc: Alexander Potapenko <glider@google.com>, Kees Cook <keescook@chromium.org>, 
	Dmitry Vyukov <dvyukov@google.com>, James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>, 
	Kostya Serebryany <kcc@google.com>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, Matthew Wilcox <willy@infradead.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Randy Dunlap <rdunlap@infradead.org>, 
	Sandeep Patil <sspatil@android.com>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Souptick Joarder <jrdr.linux@gmail.com>, Marco Elver <elver@google.com>, 
	kernel-hardening@lists.openwall.com, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org
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
Cc: Marco Elver <elver@google.com>
Cc: kernel-hardening@lists.openwall.com
Cc: linux-mm@kvack.org
Cc: linux-security-module@vger.kernel.org
---
 init/main.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/init/main.c b/init/main.c
index 66a196c5e4c3..9d63ff1d48f3 100644
--- a/init/main.c
+++ b/init/main.c
@@ -520,6 +520,29 @@ static inline void initcall_debug_enable(void)
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
@@ -530,6 +553,7 @@ static void __init mm_init(void)
 	 * bigger than MAX_ORDER unless SPARSEMEM.
 	 */
 	page_ext_init_flatmem();
+	report_meminit();
 	mem_init();
 	kmem_cache_init();
 	pgtable_init();
-- 
2.22.0.rc1.257.g3120a18244-goog

