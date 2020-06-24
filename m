Return-Path: <kernel-hardening-return-19119-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 198A9207D28
	for <lists+kernel-hardening@lfdr.de>; Wed, 24 Jun 2020 22:34:47 +0200 (CEST)
Received: (qmail 32652 invoked by uid 550); 24 Jun 2020 20:33:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32546 invoked from network); 24 Jun 2020 20:33:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=p5Zjwl0fzbxC+wniz47UyXQT+jPezYAnZAW9sm53Gyo=;
        b=I3ECgl1rBLWOyBs5RtnQDte2DTgBK8OvV3bMelQO3YzMeXJZPelqzsYzrwhg4KISwq
         Q8EP/5Rt6Nxpn5jlDw36BbBCGJdZtB2lqDV3jxoCeZsxATVA/6EywW70IFQ8KMkMtwcs
         8ERi7Vnp6AvUX047q7Y6jPhoYIU9tYESBFs78HyX/W7KrPxM3sHVTb3fYIZB+7Vx8nAt
         TaK2/xswynOZBsPbNiwRJQVa2aWgCfk+6/lVEiWQobeXdeiVAy43gwzfUDm/34ApF0Y4
         fmT1yzxDDHGNjYUCuAffxFCE77GVNDIobyJaeYAtR60VuSJZiMITgzBrUO93ylah82EN
         IIkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=p5Zjwl0fzbxC+wniz47UyXQT+jPezYAnZAW9sm53Gyo=;
        b=fe4jWqfL5M5EEv6HNs3T3A7tdVovNgpHJCU+qubOtta7zGzBjoKAYemxhSBgMHMtJv
         9MPVvmBPsOIJ9AXOKnZYQ8R+rwL2pk9gcXJq+J+mAP5TaGgSHxZ7tj5KbsEFsGrfCJSZ
         EtI6BuDDSd59OAh0dMKsWtiTzOi6MuiocZJqiaEetfIJDnPJhXGVTo7p6c1ijrpI4wzy
         TgFJxoq4048ouztw2WC5QM/xPaKFfOIMCMiXeh2LXyQxIv82DB10ZEDqK0sW96pSa5Zf
         n9DEajO2UmeXk9zrzfWfdQ5WbZTrxYmA948Ea1fwANsloSMc1fhL3NfElZ9tfFlvO0Xx
         vpaA==
X-Gm-Message-State: AOAM531yKEbdc7NFH9dJYJ16/I4qoIogdnuzOYYmEx9B/h2D0giDjmf+
	fT9VwFs343VNRaQeP9TYzBGGbZRYQ8nJMJslYC8=
X-Google-Smtp-Source: ABdhPJyshGcPxjTPdha6DvqMYpNo5yMpiv1hRNsXXOAKSMJ35QF93WrzoPN7b85RoUoCmPb47/iApkRUf/bzOcmqP9w=
X-Received: by 2002:ad4:4526:: with SMTP id l6mr8754125qvu.16.1593030798020;
 Wed, 24 Jun 2020 13:33:18 -0700 (PDT)
Date: Wed, 24 Jun 2020 13:31:49 -0700
In-Reply-To: <20200624203200.78870-1-samitolvanen@google.com>
Message-Id: <20200624203200.78870-12-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH 11/22] pci: lto: fix PREL32 relocations
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

With LTO, the compiler can rename static functions to avoid global
naming collisions. As PCI fixup functions are typically static,
renaming can break references to them in inline assembly. This
change adds a global stub to DECLARE_PCI_FIXUP_SECTION to fix the
issue when PREL32 relocations are used.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 include/linux/pci.h | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/pci.h b/include/linux/pci.h
index c79d83304e52..1e65e16f165a 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1909,19 +1909,24 @@ enum pci_fixup_pass {
 };
 
 #ifdef CONFIG_HAVE_ARCH_PREL32_RELOCATIONS
-#define __DECLARE_PCI_FIXUP_SECTION(sec, name, vendor, device, class,	\
-				    class_shift, hook)			\
-	__ADDRESSABLE(hook)						\
+#define ___DECLARE_PCI_FIXUP_SECTION(sec, name, vendor, device, class,	\
+				    class_shift, hook, stub)		\
+	void stub(struct pci_dev *dev) { hook(dev); }			\
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
2.27.0.212.ge8ba1cc988-goog

