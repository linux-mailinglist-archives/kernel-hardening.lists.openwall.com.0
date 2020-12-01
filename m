Return-Path: <kernel-hardening-return-20497-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id CA04B2CAEA7
	for <lists+kernel-hardening@lfdr.de>; Tue,  1 Dec 2020 22:38:47 +0100 (CET)
Received: (qmail 17807 invoked by uid 550); 1 Dec 2020 21:37:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17717 invoked from network); 1 Dec 2020 21:37:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=B5HJdqCXUeL43UIVLVZJnxtwrYZ/thw26FrV4EWKXXk=;
        b=gzp1vYR/oXkNJrTfyPC+gU9AshMDJf17d4hXlEixyq63WSCsKKx3kDXJjLE3705Nyq
         Fo5ieQYTx2JVLwmaGskMvm1+jyZULJ03SfEv9yykRb2g73uRagV1yTPJy+ahrYRV99Qs
         VfiuyAzo5OTZaK2vNHAaDjnnZkvg7bkbVueCSfy5zymqb9Zl9C2ZImkyynaqirPNK6ba
         e2o6MqYUTsj7xpc/+jQAgUOMDI+fKOFd22bNsjjuBqWiITez5IABxAqzwCC3dIQDnjj5
         6X3ijsy0/J/N0HG3BH/CFt5ycSFf4nlbPH4Q6tCHT2m9Fj3AbeddPFsPWCTDAPwl02q1
         wRIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=B5HJdqCXUeL43UIVLVZJnxtwrYZ/thw26FrV4EWKXXk=;
        b=jVeUmG4r0To4pMEzuJPoASO065s7dWVcZrcwIrK8OM0sQMJaAd1pujiVg24hDi+4Wt
         p0xGbwgM7Ol48LYzIarZ9Exfe85N/m2enD9NplGs9cPy8M1jn2H3EYlNJBxRDlss4Hbh
         VXK3Juc0NI8eMZp3lIf3QN38YmBB9rpIXMCte0zXub4J2dCe0NHRZ8z69dQeA8EbPAWc
         ed2e8k2t0Xs6XgQFL+plniqUOfN62b9UNB5nRnEQ+jdKnMr7JHu88fR22nvYsJkQ0BB6
         CtRkQHtJqPcrrKM5pkINpUnT1RQH4YG5Imn9c2ytahoXvnVUvQTnGLcgMSPppXMnFs+d
         8+qw==
X-Gm-Message-State: AOAM532uIoH3/bKvp8tpyf+y+m6yQRU1laPaQMaqb0F3TnuA64Qyr3X1
	pbSl0AqnK3fVyi42wMYZ8aQZVHUZClpU31ZpEro=
X-Google-Smtp-Source: ABdhPJyOyTY3dsog0bEyrf8FQNmA+LgDAtxW1LSmGP4jpoGSceI7DnRj4mOHZ3s0UwiUKjNjBIGpuS4DR9GRfrOYGf0=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:4189:: with SMTP id
 o131mr7599389yba.95.1606858652596; Tue, 01 Dec 2020 13:37:32 -0800 (PST)
Date: Tue,  1 Dec 2020 13:37:00 -0800
In-Reply-To: <20201201213707.541432-1-samitolvanen@google.com>
Message-Id: <20201201213707.541432-10-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH v8 09/16] PCI: Fix PREL32 relocations for LTO
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

With Clang's Link Time Optimization (LTO), the compiler can rename
static functions to avoid global naming collisions. As PCI fixup
functions are typically static, renaming can break references
to them in inline assembly. This change adds a global stub to
DECLARE_PCI_FIXUP_SECTION to fix the issue when PREL32 relocations
are used.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 include/linux/pci.h | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index 22207a79762c..5b8505a5ca5f 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1912,19 +1912,28 @@ enum pci_fixup_pass {
 };
 
 #ifdef CONFIG_HAVE_ARCH_PREL32_RELOCATIONS
-#define __DECLARE_PCI_FIXUP_SECTION(sec, name, vendor, device, class,	\
-				    class_shift, hook)			\
-	__ADDRESSABLE(hook)						\
+#define ___DECLARE_PCI_FIXUP_SECTION(sec, name, vendor, device, class,	\
+				    class_shift, hook, stub)		\
+	void stub(struct pci_dev *dev);					\
+	void stub(struct pci_dev *dev)					\
+	{ 								\
+		hook(dev); 						\
+	}								\
 	asm(".section "	#sec ", \"a\"				\n"	\
 	    ".balign	16					\n"	\
 	    ".short "	#vendor ", " #device "			\n"	\
 	    ".long "	#class ", " #class_shift "		\n"	\
-	    ".long "	#hook " - .				\n"	\
+	    ".long "	#stub " - .				\n"	\
 	    ".previous						\n");
+
+#define __DECLARE_PCI_FIXUP_SECTION(sec, name, vendor, device, class,	\
+				  class_shift, hook, stub)		\
+	___DECLARE_PCI_FIXUP_SECTION(sec, name, vendor, device, class,	\
+				  class_shift, hook, stub)
 #define DECLARE_PCI_FIXUP_SECTION(sec, name, vendor, device, class,	\
 				  class_shift, hook)			\
 	__DECLARE_PCI_FIXUP_SECTION(sec, name, vendor, device, class,	\
-				  class_shift, hook)
+				  class_shift, hook, __UNIQUE_ID(hook))
 #else
 /* Anonymous variables would be nice... */
 #define DECLARE_PCI_FIXUP_SECTION(section, name, vendor, device, class,	\
-- 
2.29.2.576.ga3fc446d84-goog

