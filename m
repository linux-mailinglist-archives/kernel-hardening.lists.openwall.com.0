Return-Path: <kernel-hardening-return-15842-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id CF857B2F8
	for <lists+kernel-hardening@lfdr.de>; Sat, 27 Apr 2019 08:48:39 +0200 (CEST)
Received: (qmail 6027 invoked by uid 550); 27 Apr 2019 06:43:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5943 invoked from network); 27 Apr 2019 06:43:48 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=p6XVxxmeId6Fyrw7m3B0ifgQzW6nhwdk5H1SAhfRKS0=;
        b=JScJif310IMh72ZohwOauSCAwdoUkuEv8bR6xdhJcKtk1RynLwO3Yk/O8uL4tZE53n
         NrQxpNK4N1uzjciA1sdkWWtPp8ycpHXFn7qqLzJr7tYIRLsxhiosMqxmPVmHzIChx8+N
         dySb7k6fhrhmrpcilrlJoW9blvaY3Q+PCSiONh6FBKvoxbL7qSMy7/IzPS7lXjYYk3R/
         KYc3BtX2zUuYUpbQToVTJQ3xLcXFtZGa0gKnazTNuB9oRgES+e5Dt6lyOMWvmuEim8L6
         0oOzDDk8SIoEGUBtvVZ7G2upgHOvvdwFGoH6Y4DMveFflSyOioLkC8F7etEF6M59+eVc
         h1Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=p6XVxxmeId6Fyrw7m3B0ifgQzW6nhwdk5H1SAhfRKS0=;
        b=e9b/3NjnP81EDhT74+OlRW2b/cpxLTTW4Lmv+2sG2uuy7KaSSI963qV1U1GoFdYCA5
         p1y1YUIkiLFj5fWpayizOymBWldzPvwWoayvw5sld7buV7ntUmrGFXtVDm5alhzyKD9h
         8miTaxZHUI0Q8nBNecSslEh6RXKIqa0YT4IaQZThXlzRqMHG95lRxv3tG36oq4WaIbVI
         OIwWnZCITkJzJIfINqfpymneI045Gzf5JsLNjnA75wt3DSS8E4RcjsJFfcmJgpNh8MME
         QdGGGpWHlddjNNqtAEJMYqS6uI4oYm8ll5/3z8gwuhabw2Nk55JXr0AKnribsElLghs0
         uZdg==
X-Gm-Message-State: APjAAAUbTQcH6TAUBxxkNLORJqodHT+DuZXPVYamfG47ftANYbnAnll3
	3yYtpamrs/4rgidH05we/HY=
X-Google-Smtp-Source: APXvYqy73yIN4FITPLecL8eRrrVFTQfYnIM8wwU5XCBZXYl3CE93cW/V+JNeu8zKe2r7aDykFyaZUg==
X-Received: by 2002:a17:902:d83:: with SMTP id 3mr52113119plv.125.1556347416975;
        Fri, 26 Apr 2019 23:43:36 -0700 (PDT)
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
Subject: [PATCH v6 23/24] mm/tlb: Provide default nmi_uaccess_okay()
Date: Fri, 26 Apr 2019 16:23:02 -0700
Message-Id: <20190426232303.28381-24-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190426232303.28381-1-nadav.amit@gmail.com>
References: <20190426232303.28381-1-nadav.amit@gmail.com>

From: Nadav Amit <namit@vmware.com>

x86 has an nmi_uaccess_okay(), but other architectures do not.
Arch-independent code might need to know whether access to user
addresses is ok in an NMI context or in other code whose execution
context is unknown.  Specifically, this function is needed for
bpf_probe_write_user().

Add a default implementation of nmi_uaccess_okay() for architectures
that do not have such a function.

Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/tlbflush.h | 2 ++
 include/asm-generic/tlb.h       | 9 +++++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflush.h
index 90926e8dd1f8..dee375831962 100644
--- a/arch/x86/include/asm/tlbflush.h
+++ b/arch/x86/include/asm/tlbflush.h
@@ -274,6 +274,8 @@ static inline bool nmi_uaccess_okay(void)
 	return true;
 }
 
+#define nmi_uaccess_okay nmi_uaccess_okay
+
 /* Initialize cr4 shadow for this CPU. */
 static inline void cr4_init_shadow(void)
 {
diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index b9edc7608d90..480e5b2a5748 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -21,6 +21,15 @@
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
 
+/*
+ * Blindly accessing user memory from NMI context can be dangerous
+ * if we're in the middle of switching the current user task or switching
+ * the loaded mm.
+ */
+#ifndef nmi_uaccess_okay
+# define nmi_uaccess_okay() true
+#endif
+
 #ifdef CONFIG_MMU
 
 /*
-- 
2.17.1

