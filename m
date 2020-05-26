Return-Path: <kernel-hardening-return-18497-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id CF4E51A68E2
	for <lists+kernel-hardening@lfdr.de>; Mon, 13 Apr 2020 17:33:05 +0200 (CEST)
Received: (qmail 18265 invoked by uid 550); 13 Apr 2020 15:32:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 18119 invoked from network); 13 Apr 2020 15:32:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pHg9EWKPbNBBMGp5VoNYjztBo4ZfL98OtrCqd91ILkc=;
        b=B0tF3oLqeQJe0iTqpkMyKEG9OEibAekbRFkwrxU2ha+JuyB5jTe6Ekt/phJe45wjjO
         z+PxYXqzBqIaWxb9m/9q9/PCNZwsdDFgXCnXnxwcEjd/WSb+9vXabd/NcMQJUT/i4x9/
         KWfuxAFO3IYOMwLK3RjVaY2/DluJlwxwrkJbc2DHdbgP3PT5geVLeq7xJbzuEnjh1mK5
         KVrnFMW4oeiyaRhwz+3/EH0JwfyztGIYiMcpReaMDrGqc85yW5ooFrfWeU8V99j5C4zd
         gBT9hyykTrahrmr+NUZWorbG1eDm9owD4Sh5P3eaUb+Xs9wV1da00J70gubkVPjpCIzi
         /WcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pHg9EWKPbNBBMGp5VoNYjztBo4ZfL98OtrCqd91ILkc=;
        b=MXzsMVceUkwl4lxO8mVWQ+G+UObaozU0XofMwTmiEfUFkje+BSXRM2sDOi0940SWN3
         lq/dZAvQezPLkhb0APoVkGEwVxndpedxm4jERwqI9yDd2x5xfCJymlMdwxjtL+tmieKy
         8Soa0cfBCyoNHJrLPgAfZKBfTThe39jPeMIxeeG7oW8fIfaC3aCHrARInWbH2UvQYyGl
         Vmt1e6szrqB9NO9tn29EEAYQIrZg5/2yn6elSNCzJrkxaXFYF9Smp07MNSB9lPMa8Lgb
         tsB1lGLTmu2Qh6bsfVS2Bu8P69jpjFJ3zJpchoN7U+3doclCkxkkwpiqkb9ZIgzttt3e
         Sb4Q==
X-Gm-Message-State: AGi0PubQY2v5DIdfaeuSLD6XGu6WWU1hCRGxump+kdwU0aqlvdE4xEfR
	5HgZ+Ghhplm0hVYPx5iKTJw=
X-Google-Smtp-Source: APiQypK/cPyKTuOfa19vvosuEr9CSi7r+YSoN2CjlOdfqqnePkf6NJquq0r6LEkC9T04jFpAxfPM4Q==
X-Received: by 2002:adf:edd0:: with SMTP id v16mr18806087wro.113.1586791951108;
        Mon, 13 Apr 2020 08:32:31 -0700 (PDT)
From: Lev Olshvang <levonshe@gmail.com>
To: keescook@chromium.orh
Cc: kernel-hardening@lists.openwall.com,
	Lev Olshvang <levonshe@gmail.com>
Subject: [PATCH v3 2/5] Hardening PowerPC: Forbid writes to read-only memory pages of a process
Date: Mon, 13 Apr 2020 18:32:08 +0300
Message-Id: <20200413153211.29876-3-levonshe@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200413153211.29876-1-levonshe@gmail.com>
References: <20200413153211.29876-1-levonshe@gmail.com>

Signed-off-by: Lev Olshvang <levonshe@gmail.com>
---
 arch/powerpc/include/asm/mmu_context.h | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/powerpc/include/asm/mmu_context.h b/arch/powerpc/include/asm/mmu_context.h
index ddd6d01dd2a1..f4b6b44e304c 100644
--- a/arch/powerpc/include/asm/mmu_context.h
+++ b/arch/powerpc/include/asm/mmu_context.h
@@ -10,7 +10,6 @@
 #include <asm/mmu.h>
 #include <asm/cputable.h>
 #include <asm/cputhreads.h>
-#include <linux/sched.h>
 
 /*
  * Most if the context management is out of line
@@ -248,15 +247,9 @@ static inline bool arch_vma_access_permitted(struct vm_area_struct *vma,
 		bool write, bool execute, bool foreign)
 {
 	/* by default, allow everything */
-	if (likely(vma_write_allowed(vma, write, execute, foreign)))
-		return true;
-
-	pr_err_once("Error : PID[%d] %s writes to read only memory\n",
-			current->tgid, current->comm);
-	return false;
+	return true;
 }
 
-#endif
 #define pkey_mm_init(mm)
 #define thread_pkey_regs_save(thread)
 #define thread_pkey_regs_restore(new_thread, old_thread)
-- 
2.17.1

