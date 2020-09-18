Return-Path: <kernel-hardening-return-19934-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 246082706D0
	for <lists+kernel-hardening@lfdr.de>; Fri, 18 Sep 2020 22:17:52 +0200 (CEST)
Received: (qmail 20464 invoked by uid 550); 18 Sep 2020 20:15:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 20377 invoked from network); 18 Sep 2020 20:15:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=XxAfB/P/jhgYhoVgUFO0krm50APtT+WWyqbk+4ioXTk=;
        b=DmFIi1OVxsFoFg92oFWH2VPRTDu4wE9Rmg6s0bvmp2TuRAbHoKv6/fPJl1fuBdrjn7
         VWzTK0IQDIyNMi23xcASGWrTPyHk0S7e0w5yoc9SZ/pQdToneOnD9OdIiO2v+KW9gj7y
         9zlTW9p+FprZHdCq5rpUHZD/0n8xUda24onsLXZ66jqtU8LkEkm1FqYFsbOXQY9gVmIy
         ib61pYrKwyraXm+h5krhXzdEdTlzkFDCT45b4X7mDBl5iBONcOD1ksa0s/BExbykYGIB
         wn/5Ms/kn3W2LpKihjogJj5qO+B0a2gDh6bG4SxQfn0sDbgdsmBBEBBNuSsdj96B5Er/
         uLBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XxAfB/P/jhgYhoVgUFO0krm50APtT+WWyqbk+4ioXTk=;
        b=A8d/7HqscrJ4Spb/4eHMHAZLUt5jMF6oshbNkGQp/epgTIqkf9D0HT/N049OGDq5XQ
         NR4o3W7f2gK27LNhXFT/hUChMxKZNvup2h4XnypPjByr5SFkoJsA67BXKXHYB9ni1LJX
         6nebUZ0tjfxbZk9XlByLkMsA+qXKkbNyBaFAYt4yZ4rxW6hchWgvgI6VjoNLt05Vb1VF
         xNV5qyVWEOXTlNnMci3KdWiaU9cJJ3rLamxYoqrXzvjfGk2wRODXSHQbEdNwXHkIr9ZT
         nRXHhHxHHI96pkGpZlpC+nEH2FhNv+JbXAZO/K0LwNBwMVgR10E6iP13fAIFXky9+Hsx
         8yNQ==
X-Gm-Message-State: AOAM532Z+j5n+ik+LMBqoWVM0trXjfz6ol4x3VeEyEarupxI331iTyzs
	OnmVKrdn+H0C+XKEfE8oEnZhNxyDipMP0WxkPac=
X-Google-Smtp-Source: ABdhPJy2KjHLDlLlwF3FZGYG4YjeDAk7DNS4RO40Qo5O+7UwvN2wgXBj6NsmIvpwMLwrVraEYVu5qDWHVwe1uVR3arc=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:e009:: with SMTP id
 x9mr6392448ybg.373.1600460121392; Fri, 18 Sep 2020 13:15:21 -0700 (PDT)
Date: Fri, 18 Sep 2020 13:14:24 -0700
In-Reply-To: <20200918201436.2932360-1-samitolvanen@google.com>
Message-Id: <20200918201436.2932360-19-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200918201436.2932360-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v3 18/30] init: lto: fix PREL32 relocations
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

With LTO, the compiler can rename static functions to avoid global
naming collisions. As initcall functions are typically static,
renaming can break references to them in inline assembly. This
change adds a global stub with a stable name for each initcall to
fix the issue when PREL32 relocations are used.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 include/linux/init.h | 31 +++++++++++++++++++++++++++----
 1 file changed, 27 insertions(+), 4 deletions(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index af638cd6dd52..cea63f7e7705 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -209,26 +209,49 @@ extern bool initcall_debug;
  */
 #define __initcall_section(__sec, __iid)			\
 	#__sec ".init.." #__iid
+
+/*
+ * With LTO, the compiler can rename static functions to avoid
+ * global naming collisions. We use a global stub function for
+ * initcalls to create a stable symbol name whose address can be
+ * taken in inline assembly when PREL32 relocations are used.
+ */
+#define __initcall_stub(fn, __iid, id)				\
+	__initcall_name(initstub, __iid, id)
+
+#define __define_initcall_stub(__stub, fn)			\
+	int __init __stub(void);				\
+	int __init __stub(void)					\
+	{ 							\
+		return fn();					\
+	}							\
+	__ADDRESSABLE(__stub)
 #else
 #define __initcall_section(__sec, __iid)			\
 	#__sec ".init"
+
+#define __initcall_stub(fn, __iid, id)	fn
+
+#define __define_initcall_stub(__stub, fn)			\
+	__ADDRESSABLE(fn)
 #endif
 
 #ifdef CONFIG_HAVE_ARCH_PREL32_RELOCATIONS
-#define ____define_initcall(fn, __name, __sec)			\
-	__ADDRESSABLE(fn)					\
+#define ____define_initcall(fn, __stub, __name, __sec)		\
+	__define_initcall_stub(__stub, fn)			\
 	asm(".section	\"" __sec "\", \"a\"		\n"	\
 	    __stringify(__name) ":			\n"	\
-	    ".long	" #fn " - .			\n"	\
+	    ".long	" __stringify(__stub) " - .	\n"	\
 	    ".previous					\n");
 #else
-#define ____define_initcall(fn, __name, __sec)			\
+#define ____define_initcall(fn, __unused, __name, __sec)	\
 	static initcall_t __name __used 			\
 		__attribute__((__section__(__sec))) = fn;
 #endif
 
 #define __unique_initcall(fn, id, __sec, __iid)			\
 	____define_initcall(fn,					\
+		__initcall_stub(fn, __iid, id),			\
 		__initcall_name(initcall, __iid, id),		\
 		__initcall_section(__sec, __iid))
 
-- 
2.28.0.681.g6f77f65b4e-goog

