Return-Path: <kernel-hardening-return-20591-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4D1A42D7E6B
	for <lists+kernel-hardening@lfdr.de>; Fri, 11 Dec 2020 19:48:15 +0100 (CET)
Received: (qmail 7980 invoked by uid 550); 11 Dec 2020 18:47:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7900 invoked from network); 11 Dec 2020 18:47:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=B5HJdqCXUeL43UIVLVZJnxtwrYZ/thw26FrV4EWKXXk=;
        b=CI1Z1ksraZ9iV323F1+iZqU11ohoR7PeCXzqdRVa+VPq1uQ3aVlILlGyCMggutWSZh
         toLJVqMi1M53AWHDdaW4XL+FYrTYFeGJoBHf5coo7gwbFzOhZJL8v1qpLIOTb3z8aV1q
         LU62sjLP3/2xVwScgJOjKxlGys5dCTJXM7F9pbwXc3Us7y1Bms4nmyLFiAyAGs8raRLu
         mCsKDkGu/2yqUolqiz63Y9CA2BRHkf8FRGTon8/JBgKj4dTg9k2vBkMRQRW0bWup9J5Z
         B9KEUS2NCp+GN2iFEIoblQjbVITiJ1piXgw1hDZ29L9ZLU1esZxkERsW394RCsQNRyy0
         8b3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=B5HJdqCXUeL43UIVLVZJnxtwrYZ/thw26FrV4EWKXXk=;
        b=KjY7E+mnLBknrMxRTL+F+SVoNsVqPyW8zZ1+D67kZjKtsIoYn20VLOaXylrxfoKeH8
         gSJSxaE2N4daqnvg514TYyJD2zOL7yJf6fdocI6Ys5wwShOh9CfDG1ehmP8wZS0NOYRf
         5kyVHNpFznzzLNrloZjGyPe582oCJJ0+RYZFgzOBZ74CfyvI8UUOOC9peobgdsrX4Vhf
         jVYOd6JQq294SscT1cZH0cdHiO3YHxF/HP4eZF7tY2U7p+9JBYFqC1oSJiYsvlTd6RRW
         meJ+zqVmlSC+o0M9jxlzn24lZuCnZToPuKC5VmrRQvoT7VTVEbVXvv9emEUNS5nudhvO
         ZS6A==
X-Gm-Message-State: AOAM533wBfvneZk+VQqF2saP6x8InFPQ87iI4rGhDdUcYd85vyjN7fx/
	GLWom++HlfEUllA5z+Qur1pS5B384JQAjTUUfUM=
X-Google-Smtp-Source: ABdhPJwrma1lcyBdkKY9Fn3d/aj96Xjbcqm6ANOmxB5F+S78NXSz4LS+Jidn8aXBd6ggUskWzgWXGBBPQ7DVfOBFzGY=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a0c:e312:: with SMTP id
 s18mr17700151qvl.60.1607712413271; Fri, 11 Dec 2020 10:46:53 -0800 (PST)
Date: Fri, 11 Dec 2020 10:46:26 -0800
In-Reply-To: <20201211184633.3213045-1-samitolvanen@google.com>
Message-Id: <20201211184633.3213045-10-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201211184633.3213045-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH v9 09/16] PCI: Fix PREL32 relocations for LTO
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

