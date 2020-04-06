Return-Path: <kernel-hardening-return-18426-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5031919F859
	for <lists+kernel-hardening@lfdr.de>; Mon,  6 Apr 2020 16:57:24 +0200 (CEST)
Received: (qmail 8155 invoked by uid 550); 6 Apr 2020 14:57:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 30223 invoked from network); 6 Apr 2020 14:21:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Qhp3m1b9IbBxAsOO+Ozx0Szif5yojoV/Z059SssFS3g=;
        b=rfBxAaqGOqHoXIIyuHAfhNM12KzsX9lDvqAUWpv7ogQHVglpIb4E7usPER1Cyo2674
         wC7ZxSE97W7nyAmdxPR9+fzwgTGZzril1WYd5lN/AeEsH5fMVnDz8y9tOInyctMqnMZY
         vty/GJHpsvcHFo1TXouL3M3z3ogWSlsq8NQyFYxASsGNiGRk4oei03Jk1GdFHhzhr3zS
         wOYiPCQAbbixtFAa3Ff/xZVXyYWpQxlGUEpDAPt0jAkvn8JbG9jbu/GUFI6FGFA49Pg7
         HzR4GRS7OMjGvIupYgcjoRMMFFGHp5BDLJRWyQlEBNqn0fpORBysYiVxdf7ZMSqnyK0g
         8aeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Qhp3m1b9IbBxAsOO+Ozx0Szif5yojoV/Z059SssFS3g=;
        b=JR7twwkPJIqrxrAS1my8RIPj1FcgbeSC8Z0hEGxfs4NDMzRD/c5djqBF16u7HDhYcz
         1rwaiCHnKVT895mTXcNXxY+cEM+pvnvZCm72PrK7yuOqtdUszALG0oN+UA/oWKysmkzJ
         5yeXV58cWbBSgdQIt0QrUYFGzvhC21oDjGywC2z0qXTBwFeJ0raPB/ubryLBjBIwCb09
         KfkIEvUuybVRw+rJTkx5p2kpjxK6TTkqnk3AtYrCz7Nl1OqeBpBf5LezgNe6ZV2cxiiO
         HrDjuk5l1tD1LVZsPBlkjJByyVQk+veozS4wSx9smRfHlP2WpvqBLkZ58X2YQWb/jxVD
         HEiA==
X-Gm-Message-State: AGi0PubWcSo2DQKKBQv/dU+7e+xAS3503TXC6eTISvzctUOYPmi52Bvx
	4lFcPt2J5YA8mcbUcx5If0d+xWSucj+PQg==
X-Google-Smtp-Source: APiQypKrqY7poSkbhNh4hrT3mvpzzj9YwHWbRdgEWazIpEcKayMAbk7/wQLJMssEy24PtqobIOCNzg==
X-Received: by 2002:a5d:42c1:: with SMTP id t1mr11676014wrr.215.1586182881950;
        Mon, 06 Apr 2020 07:21:21 -0700 (PDT)
From: Lev Olshvang <levonshe@gmail.com>
To: arnd@arndb.de
Cc: kernel-hardening@lists.openwall.com,
	Lev Olshvang <levonshe@gmail.com>
Subject: [RFC PATCH 2/5] Prevent write to read-only pages from another process
Date: Mon,  6 Apr 2020 17:20:42 +0300
Message-Id: <20200406142045.32522-3-levonshe@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200406142045.32522-1-levonshe@gmail.com>
References: <20200406142045.32522-1-levonshe@gmail.com>

Signed-off-by: Lev Olshvang <levonshe@gmail.com>
---
 arch/unicore32/include/asm/mmu_context.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/unicore32/include/asm/mmu_context.h b/arch/unicore32/include/asm/mmu_context.h
index 388c0c811c68..caf240b8a748 100644
--- a/arch/unicore32/include/asm/mmu_context.h
+++ b/arch/unicore32/include/asm/mmu_context.h
@@ -92,7 +92,12 @@ static inline void arch_unmap(struct mm_struct *mm,
 static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
 		bool write, bool execute, bool foreign)
 {
+#ifdef CONFIG_PROTECT_READONLY_USER_MEMORY
+	/* Forbid write to PROT_READ pages of foreign process */
+	if (write && foreign && (!(vma->vm_flags & VM_WRITE)))
+		return false;
+#endif
 	/* by default, allow everything */
 	return true;
 }
-#endif
+#endif /*__UNICORE_MMU_CONTEXT_H__*/
--
2.17.1

