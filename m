Return-Path: <kernel-hardening-return-18500-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3E3051A68E6
	for <lists+kernel-hardening@lfdr.de>; Mon, 13 Apr 2020 17:33:39 +0200 (CEST)
Received: (qmail 19636 invoked by uid 550); 13 Apr 2020 15:32:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19507 invoked from network); 13 Apr 2020 15:32:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xn7OprT8wPCkg7aj43eoXaV9EgIHAs0o3lL8DycAkbE=;
        b=K3qw7GFby1PNOvs2S59LnmpZ7DnQelyRvUSUMvUWosklORSxFsEvlZocFPQvSRJbXk
         ucXfGi1d4M42FkTKa64xWRe2ETwgQNowkfX8c6yXT2eyaImcb1Ufcqy4Re5S4LthntZ9
         rGnKCiOM6k6Vlnw/kOUA3h2RE3rpKK5Wlpo94saOWsz7hyN9JRPVko0d6FZbUFHjZRUd
         lsz792xADhUD/euDASowFpD9nT/ldRLs0UXIOTNsa1dfS0zgBdvEfdilxwNJovDCykCh
         x2J8dp2cmDUv1VK3h/nSbuPgMKvrjt7NR4EkILppd5HMbfeYHaArPFQrCCJYApNTxLU5
         oEbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xn7OprT8wPCkg7aj43eoXaV9EgIHAs0o3lL8DycAkbE=;
        b=eRzE1nkIzmu+ogF7kl/M4D8vBVkfsU9gMNxPHnAo0weqlaqZxwWVgtINC/gYj2Ry49
         ZGiukpxM83x58GNtLx4wmP1Paq9Tz9I6FmjFP38BsX4JoOfJ4MlyAWD1whGwRVnzJ+Ue
         xxunOsm9qxLIsYgLQngxi/hGNL6zZgudLDl3iuAFY/8CFGhQvzH10Jr8mwugy4Jh6W7I
         NfwKelo4DwaDIOjsjx31IgGUQAysXrb6DnUbAbaKPE1p1dJhQ0qihm2tZ7hwQfvp/vM4
         4hSVv3tuZ18NbRko8IXNMdq4KKWWUem9QsvwGcfWJcyvlHSpk/GZCx45AJZZReny2rE/
         KSFg==
X-Gm-Message-State: AGi0PuZKYb9Ai6eAqYqQoZdGeSTCpGUxwmVt/8joxVwqdr6RFfBRo5+n
	2inD84zYd4l7fC3hpXO3+JI=
X-Google-Smtp-Source: APiQypIbrOKof9nl/IbdDj+hsJVxERTDX7BiwWanAYrXFk0KSFojMZwUIWGNH2t6sthYtlo+cK3MQA==
X-Received: by 2002:a1c:dc8b:: with SMTP id t133mr19440396wmg.117.1586791954591;
        Mon, 13 Apr 2020 08:32:34 -0700 (PDT)
From: Lev Olshvang <levonshe@gmail.com>
To: keescook@chromium.orh
Cc: kernel-hardening@lists.openwall.com,
	Lev Olshvang <levonshe@gmail.com>
Subject: [PATCH v3 5/5] Hardening : PPC book3s64: Forbid writes to read-only memory pages of a process
Date: Mon, 13 Apr 2020 18:32:11 +0300
Message-Id: <20200413153211.29876-6-levonshe@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200413153211.29876-1-levonshe@gmail.com>
References: <20200413153211.29876-1-levonshe@gmail.com>

Signed-off-by: Lev Olshvang <levonshe@gmail.com>
---
 arch/powerpc/mm/book3s64/pkeys.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/pkeys.c b/arch/powerpc/mm/book3s64/pkeys.c
index 4c537af6ab01..1199fc2bfaec 100644
--- a/arch/powerpc/mm/book3s64/pkeys.c
+++ b/arch/powerpc/mm/book3s64/pkeys.c
@@ -384,11 +384,6 @@ bool arch_pte_access_permitted(u64 pte, bool write, bool execute)
 bool arch_vma_access_permitted(struct vm_area_struct *vma, bool write,
 			       bool execute, bool foreign)
 {
-	if (unlikely(!vma_write_allowed(vma, write, execute, foreign))) {
-		pr_err_once("Error : PID[%d] %s writes to read only memory\n",
-			current->tgid, current->comm);
-		return false;
-	}
 	if (static_branch_likely(&pkey_disabled))
 		return true;
 	/*
-- 
2.17.1

