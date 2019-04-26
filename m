Return-Path: <kernel-hardening-return-15840-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4F75EB2F6
	for <lists+kernel-hardening@lfdr.de>; Sat, 27 Apr 2019 08:48:08 +0200 (CEST)
Received: (qmail 5918 invoked by uid 550); 27 Apr 2019 06:43:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5813 invoked from network); 27 Apr 2019 06:43:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PMP2Cxb893S0prGS0vCi085zHCDPTtmjtSNHdboWACs=;
        b=K41kvx1t6SFhhfzncmYY1HeK2Igm+/jVQYVM/IJLmHXShsg5nGe8rTKsYo4rZoZPC/
         6zju36lQj+i8uBKtds/aE0HT690JXiZHzsJ4iG2ZVbGtv1+m8Rexp2qGC4WzKGij4mJY
         pS0wLymSfhipDrS8/jIS0cMHQRk/GDuPBjL2K/M1OnR2vxv4YrIebnQ2xexSNHS3XdIV
         svsj4+MI3xf9ZC2zePDJQy6e/n2bUI0eeL3ftgtEvNDNqK6/0DUPSoZt2Ss6m6/VX3rn
         2cMMuSy1cr6XBfOuPS4wxZ/91yZ1FLcgw2kClZNZEQvPCdnBiT4UNc5YyXetyq58UhjO
         W5iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PMP2Cxb893S0prGS0vCi085zHCDPTtmjtSNHdboWACs=;
        b=hZ7ZvWpkTdPNCE1MrHK3i0Gj+gG57IpVuqMuj2HDenSSR1niqv6k7eNPHzXcg5ROyW
         umNAGM4ZbFqgk/sSJAdOCmMKDaeJjgqy91nROqyajhrtdhIdTNcsCG1k3mJPJlEZzxR3
         C4zNuu+1UmqygiGKmsEElgTNWEztbTk1oxWMDRSsd/SOVHkVZ1kN5aA3hg8lRUxVbYyg
         KiRH7f649ikabnW5+yz0t5yoHxz8d2OhR6eZY8irid3I8K4ZiGh/O57rfp6WbjqkBk1K
         70R3qNMewcO13AwFZ1FKP1Uw++4XJSeLl/TQsSvOHgOMSKJx6HUVxmHgdf3xnGc8r2A2
         5xig==
X-Gm-Message-State: APjAAAUqW4eLoe/1BrEhMCEv6SaYhr08xGbB1EtQEMFd0nP4dvTaiY6B
	GlJParvNkvw/BmY2lO9NZco=
X-Google-Smtp-Source: APXvYqzt81NaHzE4N6lgOn1CEEv66yygls114EGZnoMMrIlsI1R4+4jwMYRUYyyw4vMJxMCD0c6n8g==
X-Received: by 2002:a17:902:f094:: with SMTP id go20mr50490988plb.159.1556347414288;
        Fri, 26 Apr 2019 23:43:34 -0700 (PDT)
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
	Masami Hiramatsu <mhiramat@kernel.org>
Subject: [PATCH v6 21/24] x86/kprobes: Use vmalloc special flag
Date: Fri, 26 Apr 2019 16:23:00 -0700
Message-Id: <20190426232303.28381-22-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190426232303.28381-1-nadav.amit@gmail.com>
References: <20190426232303.28381-1-nadav.amit@gmail.com>

From: Rick Edgecombe <rick.p.edgecombe@intel.com>

Use new flag VM_FLUSH_RESET_PERMS for handling freeing of special
permissioned memory in vmalloc and remove places where memory was set NX
and RW before freeing which is no longer needed.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kernel/kprobes/core.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/arch/x86/kernel/kprobes/core.c b/arch/x86/kernel/kprobes/core.c
index 1591852d3ac4..136695e4434a 100644
--- a/arch/x86/kernel/kprobes/core.c
+++ b/arch/x86/kernel/kprobes/core.c
@@ -434,6 +434,7 @@ void *alloc_insn_page(void)
 	if (!page)
 		return NULL;
 
+	set_vm_flush_reset_perms(page);
 	/*
 	 * First make the page read-only, and only then make it executable to
 	 * prevent it from being W+X in between.
@@ -452,12 +453,6 @@ void *alloc_insn_page(void)
 /* Recover page to RW mode before releasing it */
 void free_insn_page(void *page)
 {
-	/*
-	 * First make the page non-executable, and only then make it writable to
-	 * prevent it from being W+X in between.
-	 */
-	set_memory_nx((unsigned long)page, 1);
-	set_memory_rw((unsigned long)page, 1);
 	module_memfree(page);
 }
 
-- 
2.17.1

