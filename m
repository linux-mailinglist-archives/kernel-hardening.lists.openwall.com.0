Return-Path: <kernel-hardening-return-18029-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9A583174A66
	for <lists+kernel-hardening@lfdr.de>; Sun,  1 Mar 2020 01:22:27 +0100 (CET)
Received: (qmail 26037 invoked by uid 550); 1 Mar 2020 00:22:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26004 invoked from network); 1 Mar 2020 00:22:22 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qshFldRB8YPASr29CwNccF5JOuFD0I3kQPBmVUj9i3E=;
        b=kGWGDfl25/JO4dpXbl7GULhracgi7nTXlZDO0uiSJvmUMCVcivrUzQJqzkWH6rVWW3
         rEdtxI8FxDXK4X5gN+oio4a+oxHUTnXz42x5cwXQOjngn2EwqotPKjK/WfPdZEUPzKDY
         2GGQrg4tLfzYWNPcq2z+pkGYZYqCNNvAXGJDwl11/lY+TAlx07iubV3DUlScw67KVS1G
         8zvB0+tDmtRD4WPzcLlFr9E6JZGD90sN4pK3+Or+e6U5wDpRJJMnDuZ5UgiZYpq3AKcF
         J39Hgg1w9o3BTeAroAdZDHWr6hDohHe3RvfZdJBmecPIKaNDM1X0y+dobwC29bsyKyDu
         XhXw==
X-Gm-Message-State: APjAAAVNYFy+r5LxzFr9veuD1aSU/fRhmYijn8PDzcAk6uhrc1qWKjNp
	bzk20crYY3o6xFlNLYp4ppM=
X-Google-Smtp-Source: APXvYqy3Vwc9teClEAbXOadl2PZOUAAd2uQthzN2aseTpywQ2ge+HlEu+sb5gkYPpSps4VMPEx1Yog==
X-Received: by 2002:aed:218f:: with SMTP id l15mr9944317qtc.247.1583022130405;
        Sat, 29 Feb 2020 16:22:10 -0800 (PST)
From: Arvind Sankar <nivedita@alum.mit.edu>
To: "Tobin C . Harding" <me@tobin.cc>,
	Tycho Andersen <tycho@tycho.ws>
Cc: kernel-hardening@lists.openwall.com,
	Kees Cook <keescook@chromium.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] x86/mm/init_32: Stop printing the virtual memory layout
Date: Sat, 29 Feb 2020 19:22:09 -0500
Message-Id: <20200301002209.1304982-1-nivedita@alum.mit.edu>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <202002291534.ED372CC@keescook>
References: <202002291534.ED372CC@keescook>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For security, don't display the kernel's virtual memory layout.

Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
---
 arch/x86/mm/init_32.c | 38 --------------------------------------
 1 file changed, 38 deletions(-)

diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 23df4885bbed..8ae0272c1c51 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -788,44 +788,6 @@ void __init mem_init(void)
 	x86_init.hyper.init_after_bootmem();
 
 	mem_init_print_info(NULL);
-	printk(KERN_INFO "virtual kernel memory layout:\n"
-		"    fixmap  : 0x%08lx - 0x%08lx   (%4ld kB)\n"
-		"  cpu_entry : 0x%08lx - 0x%08lx   (%4ld kB)\n"
-#ifdef CONFIG_HIGHMEM
-		"    pkmap   : 0x%08lx - 0x%08lx   (%4ld kB)\n"
-#endif
-		"    vmalloc : 0x%08lx - 0x%08lx   (%4ld MB)\n"
-		"    lowmem  : 0x%08lx - 0x%08lx   (%4ld MB)\n"
-		"      .init : 0x%08lx - 0x%08lx   (%4ld kB)\n"
-		"      .data : 0x%08lx - 0x%08lx   (%4ld kB)\n"
-		"      .text : 0x%08lx - 0x%08lx   (%4ld kB)\n",
-		FIXADDR_START, FIXADDR_TOP,
-		(FIXADDR_TOP - FIXADDR_START) >> 10,
-
-		CPU_ENTRY_AREA_BASE,
-		CPU_ENTRY_AREA_BASE + CPU_ENTRY_AREA_MAP_SIZE,
-		CPU_ENTRY_AREA_MAP_SIZE >> 10,
-
-#ifdef CONFIG_HIGHMEM
-		PKMAP_BASE, PKMAP_BASE+LAST_PKMAP*PAGE_SIZE,
-		(LAST_PKMAP*PAGE_SIZE) >> 10,
-#endif
-
-		VMALLOC_START, VMALLOC_END,
-		(VMALLOC_END - VMALLOC_START) >> 20,
-
-		(unsigned long)__va(0), (unsigned long)high_memory,
-		((unsigned long)high_memory - (unsigned long)__va(0)) >> 20,
-
-		(unsigned long)&__init_begin, (unsigned long)&__init_end,
-		((unsigned long)&__init_end -
-		 (unsigned long)&__init_begin) >> 10,
-
-		(unsigned long)&_etext, (unsigned long)&_edata,
-		((unsigned long)&_edata - (unsigned long)&_etext) >> 10,
-
-		(unsigned long)&_text, (unsigned long)&_etext,
-		((unsigned long)&_etext - (unsigned long)&_text) >> 10);
 
 	/*
 	 * Check boundaries twice: Some fundamental inconsistencies can
-- 
2.24.1

