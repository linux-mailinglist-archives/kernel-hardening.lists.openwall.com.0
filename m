Return-Path: <kernel-hardening-return-18428-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 1F9EC19F865
	for <lists+kernel-hardening@lfdr.de>; Mon,  6 Apr 2020 16:59:43 +0200 (CEST)
Received: (qmail 13438 invoked by uid 550); 6 Apr 2020 14:59:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 30321 invoked from network); 6 Apr 2020 14:21:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=o8/4Ampi2v7APZtRMp9JzLDX7caJGR52iBn4UwilYK4=;
        b=TKCWs0U0Qxr7aIN8E0B5fdEM92OGC+xx5Jwom/PbScpAwFphX7/+cqnydx7BBQYLYN
         lP+4qWVR/8rGZE1TFEP9ZiePtF6Z5DXTp3dNV+glbIbbQyisu6RcHnFs6o1uIFZ+SlnK
         KUYZt9vHw57oDHcsdSVC0Iv0FmxWB5+NTznUZqKo2W87jAYwS3mxMQH5u62ltWTQtrr3
         NT0YSGOEzHZ2Tg7qbyjKJ5/TG1i571SljJyYiHqUZspL5Y1RZhoMn1cg3EHDybqMLXxG
         hf2VDxulRE1aO9btrFgW+zEfm3Oe14ByODOErQEo8PRifAJOKM8qS8JpxZhvcCXXgcoN
         SFEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=o8/4Ampi2v7APZtRMp9JzLDX7caJGR52iBn4UwilYK4=;
        b=ASrjn7orixQbte0Twf0CYLQX+Q1xbEo2Lir10Va5qHsFSdTxOJYHmr4YJsg0u38gQ7
         L/PQ9SXdHvZzCfa3TEtpqFpEowWlK5sA2nZS98k0S9CxkCskTQc7ye8YZgVNCsVIvfU7
         bHrQW2UwheGeegstoG0AicNxWYVS3L1Y2wueZkEQPzW6U1Za+xHl+hN1U66CGVEmtF2U
         C2SzYwP+Xci39+HAemoaNrBgrqcosQPcDtW3ViuETto+TaK9LLLsLBaC3RLX31npibRr
         izfaLi8Al4wtdugk/A16N+9+Sf3N4JBUUQMgBMyNZ+cPyPLUdG5+hCOOqCWJHbryTJ6u
         SBAA==
X-Gm-Message-State: AGi0Pua16QC9isyCWckPdtW4ZpW7pWN15RZLvCzmdO8qEcmS2kdxsiVC
	EvsjJ/glE+QJrtPHVxpa/64=
X-Google-Smtp-Source: APiQypJY+JzmSvrJxMZc5lcePc20QV2ywBpQAu1ekVEs8wTE334dwK8BaLdqMJt0xMHcs2nSE3huyQ==
X-Received: by 2002:a05:600c:2f81:: with SMTP id t1mr1796125wmn.77.1586182884458;
        Mon, 06 Apr 2020 07:21:24 -0700 (PDT)
From: Lev Olshvang <levonshe@gmail.com>
To: arnd@arndb.de
Cc: kernel-hardening@lists.openwall.com,
	Lev Olshvang <levonshe@gmail.com>
Subject: [RFC PATCH 4/5] X86:Prevent write to read-only pages :text, PLT/GOT tables from another process
Date: Mon,  6 Apr 2020 17:20:44 +0300
Message-Id: <20200406142045.32522-5-levonshe@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200406142045.32522-1-levonshe@gmail.com>
References: <20200406142045.32522-1-levonshe@gmail.com>

Signed-off-by: Lev Olshvang <levonshe@gmail.com>
---
 arch/x86/include/asm/mmu_context.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 4e55370e48e8..708135112d95 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -216,12 +216,19 @@ static inline void arch_unmap(struct mm_struct *mm, unsigned long start,
 static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
 		bool write, bool execute, bool foreign)
 {
-	/* pkeys never affect instruction fetches */
+#ifdef CONFIG_PROTECT_READONLY_USER_MEMORY
+	/* Forbid write to PROT_READ pages of foreign process */
+	if (write && foreign && (!(vma->vm_flags & VM_WRITE)))
+		return false;
+#endif
+	/* Don't check PKRU since pkeys never affect instruction fetches */
 	if (execute)
 		return true;
+
 	/* allow access if the VMA is not one from this process */
 	if (foreign || vma_is_foreign(vma))
 		return true;
+
 	return __pkru_allows_pkey(vma_pkey(vma), write);
 }

--
2.17.1

