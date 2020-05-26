Return-Path: <kernel-hardening-return-18527-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C99D31ACC54
	for <lists+kernel-hardening@lfdr.de>; Thu, 16 Apr 2020 18:00:00 +0200 (CEST)
Received: (qmail 21606 invoked by uid 550); 16 Apr 2020 15:59:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 20467 invoked from network); 16 Apr 2020 15:59:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=EyWqZ7hLeTwAxCmAHhXqoT3byDRCujEgtxXaTdSM01c=;
        b=j80u4NF4ZrVNIkHZrnWJbX/dPRimWVyRh/G0n2GMQogVwj2wIIFXrfSPJ+0qtYu3ZP
         QP4amvFEyBkrJmdLciKc/g1KPzCGup/qnSN268M4+cnYkHCllA4g7q3XxWH5XE/RlpFF
         OucO1FrpXcU9tu5w8tkvfeCfh7qQykBGwVMF1strEOMBPxIgPMotvh4r/8fR8gXDSYKC
         Rezg8pJ3QeDQWScxHnmZPLXMbsBKUrQYxTv+6Ig+4Q4f/f6LEPN1uKo2HDw7riANbe+v
         v//okxUSGYLfhgQQN9S7K7XJk9CYOatO/F2rPIOM7e7pIwZI8RdqYXUfZCLO7qhSVKgw
         YN6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=EyWqZ7hLeTwAxCmAHhXqoT3byDRCujEgtxXaTdSM01c=;
        b=gDJkGWP/kuzlALJd6Vxw9ZDaTUtzhF6O25tiZSYszDNkUc+7gkAmD7n71lnmzpeMBp
         6IjMFrRnfOJqAv2faarugK9V0qBsihwmy4h0ucnLTeQFNVu0E8kkqJt3tkQJHyfRQx1n
         AYTkw5zdUoSRziM4bN+5PYK0Due0befRUgZYrUaqcauqKzfKgDP6o3zyebNfXlqgmJac
         eyj1twxn3cw9QVb7mSbChPqcZsywnWB7IkNP/VyGWRrkU73w8g1K734+i8YzmtVJ7QTw
         /Z0Id3T7Odf+XxrS37PkvMzCxIMzzru/AA5fMZ+Kzp0x7KuJIA3saWU894PMlbAQcIZr
         3Xuw==
X-Gm-Message-State: AGi0Pub5NzReDZFIUVU/P0eOPz4QhnMKtNjwBnLm4IxqfjQofRK2IYZG
	jCnufAWHfpAUzUuF0CNxapU=
X-Google-Smtp-Source: APiQypKIbfLydTSfT2xZsShrBVkLA4X8NfZSPa02j8B4nfddNNYY/wOY4Wf+kDzH8H1uHrdufo3a7w==
X-Received: by 2002:a1c:48c:: with SMTP id 134mr5183449wme.47.1587052764830;
        Thu, 16 Apr 2020 08:59:24 -0700 (PDT)
From: Lev Olshvang <levonshe@gmail.com>
To: keescook@chromium.org
Cc: kernel-hardening@lists.openwall.com,
	Lev Olshvang <levonshe@gmail.com>
Subject: [PATCH v4 2/2] Hardening x86: Forbid writes to read-only memory pages of a process
Date: Thu, 16 Apr 2020 18:59:17 +0300
Message-Id: <20200416155917.28536-3-levonshe@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200416155917.28536-1-levonshe@gmail.com>
References: <20200416155917.28536-1-levonshe@gmail.com>

Signed-off-by: Lev Olshvang <levonshe@gmail.com>
---
 arch/x86/include/asm/mmu_context.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 4e55370e48e8..e9b820780424 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -216,6 +216,11 @@ static inline void arch_unmap(struct mm_struct *mm, unsigned long start,
 static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
 		bool write, bool execute, bool foreign)
 {
+	if (unlikely(!vma_write_allowed(vma, write, foreign))) {
+		pr_err_once("Error : PID[%d] %s writes to read only memory\n",
+			    current->pid, current->comm);
+		return false;
+	}
 	/* pkeys never affect instruction fetches */
 	if (execute)
 		return true;
-- 
2.17.1

