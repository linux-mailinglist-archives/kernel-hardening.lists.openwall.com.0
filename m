Return-Path: <kernel-hardening-return-16063-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 77C6438714
	for <lists+kernel-hardening@lfdr.de>; Fri,  7 Jun 2019 11:29:37 +0200 (CEST)
Received: (qmail 4029 invoked by uid 550); 7 Jun 2019 09:29:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 30693 invoked from network); 7 Jun 2019 08:55:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=7sAcFhzm9//uuWPzvmk6JGPNvQAtroDUafFgbzLm/yQ=;
        b=rdCdjwMg3gY0shibBU1Y00zUYQIbtOM1x+c+yT+bFe7iBq5B+DoGdkjBVtzSVU+VH4
         pP96pPCG+Y973PP3O/lWES1n/UCOKtZa3RNHsidIfwLMPCrenvyWFxRyRqzXyZsOsCjr
         qSODaba6lZJocr0BUenu+4ZEbh1HblpWCFTpj73QuxvyUjbyJLZFozdmYeqn4HCfWCGh
         /AMfOsdrVXar7zg8+8htj5UxeyZr5izHf4MgEsCAHA6hwcqCH0BBWjwFe+k9QgjrSEmp
         U+n4drC9Dr/6Kek1dfT2CT1N1chYQ3TylncKuorf8JsVOifT/sDp1sYcXeCWD0MPL07+
         5kBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=7sAcFhzm9//uuWPzvmk6JGPNvQAtroDUafFgbzLm/yQ=;
        b=qMDf1zYc6PPtzz9TgO0tjRyME/XZUz2T+MsgJYSyDR5Orb6RYasxF/+SI9RH3aD5sj
         Kjzj4oIzdiQ4hxVBKIDUV7m3+eEoSKIOYbzhtB/tj7lgZz57IviH9nHrMbOQNO2YCutd
         Xai6wt/VkJCd9Qz1rqCXiS64snHl6Ggbr+2B4sGeBmmKlRjFkPBPlxbKamPKmPtnjpDD
         BDtNLcqedllmFARUDPSn9UM7iGI7b2jP/2y1jXaye1mse1ST1EQ23pHGw0hS+GmxGyFJ
         icqdK1/VqsYlAUvmLESo62AzfXqZsg4GbsQuy3/2bNrYlF6LimTch4XRVGMJ9+gR8jMa
         dDmg==
X-Gm-Message-State: APjAAAUQ/M/B4du/4FfgTm2oMNAZzShkRjRX7ZRAr+f+KTFfGLUEa8IE
	GUwgbKQ+H7A0lRrG9CfZwPb4jgKpk5k=
X-Google-Smtp-Source: APXvYqxl2fR/kTIk2qghgxJ9BB+AYD6tf6ZHiB+nSiWLpCvBpXZOF6k/lSrBGI83j05i6uqHwLil+lUnGI4=
X-Received: by 2002:a1f:e906:: with SMTP id g6mr514895vkh.25.1559897742846;
 Fri, 07 Jun 2019 01:55:42 -0700 (PDT)
Date: Thu,  6 Jun 2019 18:48:44 +0200
In-Reply-To: <20190606164845.179427-1-glider@google.com>
Message-Id: <20190606164845.179427-3-glider@google.com>
Mime-Version: 1.0
References: <20190606164845.179427-1-glider@google.com>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
Subject: [PATCH v6 2/3] mm: init: report memory auto-initialization features
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
about these hardening measures in one place.

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
Cc: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Cc: kernel-hardening@lists.openwall.com
Cc: linux-mm@kvack.org
Cc: linux-security-module@vger.kernel.org
---
 v6:
 - update patch description, fixed message about clearing memory
---
 init/main.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/init/main.c b/init/main.c
index 66a196c5e4c3..e68ef1f181f9 100644
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
2.22.0.rc1.311.g5d7573a151-goog

