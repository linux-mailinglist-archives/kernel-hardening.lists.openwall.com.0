Return-Path: <kernel-hardening-return-15830-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2D113B2EC
	for <lists+kernel-hardening@lfdr.de>; Sat, 27 Apr 2019 08:46:00 +0200 (CEST)
Received: (qmail 3909 invoked by uid 550); 27 Apr 2019 06:43:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3812 invoked from network); 27 Apr 2019 06:43:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yNv4uuWY37+QDIo+8eJ5Cs1RQKFygWuhu/mUpTFc+50=;
        b=qfcv0jVylRwgUSdFp0yVo6y3SoCAOjol9XbR7W5+lwraaEg2QoXyt+VrAjGp9wzdAn
         BOm9G9cC4mrsWbrKkWfeWua0CLcUhNFX2UYmr160CAGJNRPhpKunjycWCJnpjaUptQXK
         FymoezD52jYoCa9vw1d8DrTtNcDpUD3gesH2ZoYEwsgq0bZE6tTukM9zPOscjJPRRiHd
         0d0EQKT1ASnMLtYxkgiq4MVCWAUZf/kjKC/u6ibFbPlbEhDhs/jBfSTvPAadE2T4MBPs
         yoHMRLVUDfJJ0O31Q2uS3OPiszz2lAVHUHfzcDpTk8KxpsBn4aqr0vTCALbdk7a/EPYd
         2uWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yNv4uuWY37+QDIo+8eJ5Cs1RQKFygWuhu/mUpTFc+50=;
        b=D5xaIKYht8SzqD+gXl6Tt0SXQyoSGSdMHoW8A+pWsZzdcGrrYYSNPFUTJ1LPhBreQn
         dLI7SDZ4PaxCE0UPfIdN60xpZte6xyJPQ4QWCR62AZt7fH1mYkS29JeVkmIK5KQBS8l7
         R4aQrgLW49UK2MIFvrM/mvymbtAYYSVjUySQQmLkSDTNlR7DTAToRGLu1yhRiVqBZQz9
         VtfKK3rnfpFTOHzFWoEVjhMsH/djtmlYIHxDvjR6ZEXEjLmM6ekYYagP4t1VA2yU5gHE
         N8GlUAL5JWjC8jqT+OsxR1DAj8UJtn2uJuqVbTHdUKHYrcIl28PAPBslj6kO81ui5MGV
         IBAA==
X-Gm-Message-State: APjAAAUwBkxX7YE3xVppNud8Lkcfyfr1kF88yrlGRp318jSe1vczpvmo
	FwK3yNAM2HJhQzG/iGpAAqI=
X-Google-Smtp-Source: APXvYqxCgMCnuubydaHXfJIDthz2u46RkKoNrhpM9xg9spe5Zm1Eq7YBRg8tloTlDMLwvkBDrQMPvQ==
X-Received: by 2002:a63:7f0b:: with SMTP id a11mr44847434pgd.234.1556347400564;
        Fri, 26 Apr 2019 23:43:20 -0700 (PDT)
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
Subject: [PATCH v6 11/24] x86/kprobes: Set instruction page as executable
Date: Fri, 26 Apr 2019 16:22:50 -0700
Message-Id: <20190426232303.28381-12-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190426232303.28381-1-nadav.amit@gmail.com>
References: <20190426232303.28381-1-nadav.amit@gmail.com>

From: Nadav Amit <namit@vmware.com>

Set the page as executable after allocation.  This patch is a
preparatory patch for a following patch that makes module allocated
pages non-executable.

While at it, do some small cleanup of what appears to be unnecessary
masking.

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kernel/kprobes/core.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index a034cb808e7e..1591852d3ac4 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -431,8 +431,20 @@ void *alloc_insn_page(void)
 	void *page;
 
 	page = module_alloc(PAGE_SIZE);
-	if (page)
-		set_memory_ro((unsigned long)page & PAGE_MASK, 1);
+	if (!page)
+		return NULL;
+
+	/*
+	 * First make the page read-only, and only then make it executable to
+	 * prevent it from being W+X in between.
+	 */
+	set_memory_ro((unsigned long)page, 1);
+
+	/*
+	 * TODO: Once additional kernel code protection mechanisms are set, ensure
+	 * that the page was not maliciously altered and it is still zeroed.
+	 */
+	set_memory_x((unsigned long)page, 1);
 
 	return page;
 }
@@ -440,8 +452,12 @@ void *alloc_insn_page(void)
 /* Recover page to RW mode before releasing it */
 void free_insn_page(void *page)
 {
-	set_memory_nx((unsigned long)page & PAGE_MASK, 1);
-	set_memory_rw((unsigned long)page & PAGE_MASK, 1);
+	/*
+	 * First make the page non-executable, and only then make it writable to
+	 * prevent it from being W+X in between.
+	 */
+	set_memory_nx((unsigned long)page, 1);
+	set_memory_rw((unsigned long)page, 1);
 	module_memfree(page);
 }
 
-- 
2.17.1

