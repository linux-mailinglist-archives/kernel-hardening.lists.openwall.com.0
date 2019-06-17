Return-Path: <kernel-hardening-return-16157-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 462FF486B9
	for <lists+kernel-hardening@lfdr.de>; Mon, 17 Jun 2019 17:12:54 +0200 (CEST)
Received: (qmail 7183 invoked by uid 550); 17 Jun 2019 15:12:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 3952 invoked from network); 17 Jun 2019 15:11:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=J2xlT5BkG4PHe/4/nJk7BmFqwoJl9sRtUfXxrBXjMCQ=;
        b=p3ae0HY/O3HHcM6wSMM9Tz76pUtauWYXmpaYWMuj4cFJ05HA65ucJNAlfWzvMGlmaS
         lxOyugNBCdTPBRgvKdpVxDPPMXLwju022Pe2+adIc0cy/7WN15Piv/GRhyXgOlK1N9zO
         Qt2SUknDwSdhIbbMc5QJx9l8NVVrJY3o1UR5JRK4IgEsJvZln9vb6KepjjdnvNbApfcs
         9jLqp/1MVZVCrmLGqeLqmR5Z+Lsh9JlA14qkOfLbd3vfbUIUl6HfJLDZnERhBTPjT9L6
         HBY80N8ck39V/TG1wmfxgzmwWsr1L0U03y9/v2GIsZIlHX+iQS46D3BFyn2y3Orggm40
         ws8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=J2xlT5BkG4PHe/4/nJk7BmFqwoJl9sRtUfXxrBXjMCQ=;
        b=oJNZMKfNyeU5piLIdORxt8qQxIDxbvZkh4Mfy/VwTUaoa3FAoTdCVCaUvi1feaqNry
         U3KpL6iYwkX6/3XcdOvywTbdNDWF+TvLNd6m52zXPVQz0o9/xWfLAlU0nbzDekleAT34
         D2zayxGxA0Kiqg23dfmM8yy1FxZuJl6tCdh+5wIlP/AIsZW8/KAcf9don/q67UCdxR6j
         3IVuNV4qzSGKaAh/gpPNeUIcG5dqrXo4+GnQrNBSEvl4Bcjy8pwvSRZ1z9MuQ/y/smkf
         FPj7j+8j/DXrclmJlUNXCNcgaNXfjKX6a6v+kENG5OfmlY614pb9pPx2tJDpqEinupCS
         lsVA==
X-Gm-Message-State: APjAAAUbQq9+ASC6ASNVjC+qWWWaCI9A25rpvTmuFWZO/x5FxTmITpmX
	fjFE6iFDo96NQpGH+scjSEJsO5f66bU=
X-Google-Smtp-Source: APXvYqwW8bb+vtL/Lysm9EpPCmcTXzOQ2ut1uDpyQmfhMuaCptVMX9tFM6WT2buC0hsqYxHSzW//c6xIsSk=
X-Received: by 2002:ac8:394b:: with SMTP id t11mr73550464qtb.286.1560784265391;
 Mon, 17 Jun 2019 08:11:05 -0700 (PDT)
Date: Mon, 17 Jun 2019 17:10:50 +0200
In-Reply-To: <20190617151050.92663-1-glider@google.com>
Message-Id: <20190617151050.92663-3-glider@google.com>
Mime-Version: 1.0
References: <20190617151050.92663-1-glider@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH v7 2/2] mm: init: report memory auto-initialization features
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
	Kaiwan N Billimoria <kaiwan@kaiwantech.com>, kernel-hardening@lists.openwall.com, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Print the currently enabled stack and heap initialization modes.

Stack initialization is enabled by a config flag, while heap
initialization is configured at boot time with defaults being set
in the config. It's more convenient for the user to have all information
about these hardening measures in one place at boot, so the user can
reason about the expected behavior of the running system.

The possible options for stack are:
 - "all" for CONFIG_INIT_STACK_ALL;
 - "byref_all" for CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL;
 - "byref" for CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF;
 - "__user" for CONFIG_GCC_PLUGIN_STRUCTLEAK_USER;
 - "off" otherwise.

Depending on the values of init_on_alloc and init_on_free boottime
options we also report "heap alloc" and "heap free" as "on"/"off".

In the init_on_free mode initializing pages at boot time may take a
while, so print a notice about that as well. This depends on how much
memory is installed, the memory bandwidth, etc.
On a relatively modern x86 system, it takes about 0.75s/GB to wipe all
memory:

  [    0.418722] mem auto-init: stack:byref_all, heap alloc:off, heap free:on
  [    0.419765] mem auto-init: clearing system memory may take some time...
  [   12.376605] Memory: 16408564K/16776672K available (14339K kernel code, 1397K rwdata, 3756K rodata, 1636K init, 11460K bss, 368108K reserved, 0K cma-reserved)

Signed-off-by: Alexander Potapenko <glider@google.com>
Suggested-by: Kees Cook <keescook@chromium.org>
Acked-by: Kees Cook <keescook@chromium.org>
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
Cc: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Cc: kernel-hardening@lists.openwall.com
Cc: linux-mm@kvack.org
Cc: linux-security-module@vger.kernel.org
---
 v6:
 - update patch description, fixed message about clearing memory
 v7:
 - rebase the patch, add the Acked-by: tag;
 - more description updates as suggested by Kees;
 - make report_meminit() static.
---
 init/main.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/init/main.c b/init/main.c
index 66a196c5e4c3..ff5803b0841c 100644
--- a/init/main.c
+++ b/init/main.c
@@ -520,6 +520,29 @@ static inline void initcall_debug_enable(void)
 }
 #endif
 
+/* Report memory auto-initialization states for this boot. */
+static void __init report_meminit(void)
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
+		pr_info("mem auto-init: clearing system memory may take some time...\n");
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
2.22.0.410.gd8fdbe21b5-goog

