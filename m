Return-Path: <kernel-hardening-return-15823-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 90A85B2E5
	for <lists+kernel-hardening@lfdr.de>; Sat, 27 Apr 2019 08:44:24 +0200 (CEST)
Received: (qmail 1888 invoked by uid 550); 27 Apr 2019 06:43:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1817 invoked from network); 27 Apr 2019 06:43:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=wqvLZPneRcLgxY6Wjfk6EEQBPauaGcOxn9fq0yjJ9xE=;
        b=vdYahecrwl2Sp5UawSR3og0bnv/oKfDwV/Dqodp6SG75rtt3oI1BxkHqScjMRc/B0U
         ndpm0CSM99X5DI5nXyZ0qilWlZ5y+YmffvE0rzTsPOh9Lg0wVC5gzIbXO3T2rI/43jKw
         dSv/fQEMrgklgF9DfRp0UTkxOOmbTA2q76DVrniyNWh8V594RE3EBRYYfPR9C72DIbVe
         QvUfF6WjCix52aEKKarcvG6J8JGMJ6kiAHPNxAecwgyTiM6P6ST8UlxjffLYXWC/UN5g
         Hhv9thRtl94b6Emad3qIhmqwC571N8N4kkx/zbp3oEc24WAmffQk4ZXiiSSJrBGsI7VY
         gu0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=wqvLZPneRcLgxY6Wjfk6EEQBPauaGcOxn9fq0yjJ9xE=;
        b=r4MB4mvf5KgyrIxkfgkdwMlwVF1bLj89PBDeQPeocEjBz3cPqMpIPsrmoGQ3sb2HI5
         0/aIv5tjHQ+WBSsHafF9vxT+kdrS4GfhyE79xiV+P1lCwFiCdv79m6EzgdyEmTjoPjKz
         R/nXtNdwY7yV8U+UjmYShQ0hcivpTxJ8Q9hrpNfA6no2IPfzCJe4OB8gY1IltdNRqXkd
         WKgz2VHWjrJ/QcibC9Cb8le0picr0Sqew4zW8eRJ46mzL7NkDRfX4mMRabl0txHMkPgb
         N4dOSc+MgIGzmcdgba1foyuX9rnE9yArxq3VDawXuQJWVPWgA7E+wiZRavpYf4U84KPs
         i8Qg==
X-Gm-Message-State: APjAAAWSugiKXWHtAQ2qyRLWcMyoJ3nkcFBMFbTOQoazVEuUkXleYhbf
	i/HX8JMDAOQXuIhau3NzWJU=
X-Google-Smtp-Source: APXvYqyiprnnWU4rXtsHhhC4I5UqVMx78ccNfm1X35wazpAaZSJma1EHcKW1CFUxAhCYo5lEBNcLEA==
X-Received: by 2002:a17:902:aa83:: with SMTP id d3mr8074837plr.108.1556347388411;
        Fri, 26 Apr 2019 23:43:08 -0700 (PDT)
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
Subject: [PATCH v6 04/24] x86/mm: Save debug registers when loading a temporary mm
Date: Fri, 26 Apr 2019 16:22:43 -0700
Message-Id: <20190426232303.28381-5-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190426232303.28381-1-nadav.amit@gmail.com>
References: <20190426232303.28381-1-nadav.amit@gmail.com>

From: Nadav Amit <namit@vmware.com>

Prevent user watchpoints from mistakenly firing while the temporary mm
is being used. As the addresses of the temporary mm might overlap those
of the user-process, this is necessary to prevent wrong signals or worse
things from happening.

Cc: Andy Lutomirski <luto@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/include/asm/mmu_context.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index 24dc3b810970..93dff1963337 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -13,6 +13,7 @@
 #include <asm/tlbflush.h>
 #include <asm/paravirt.h>
 #include <asm/mpx.h>
+#include <asm/debugreg.h>
 
 extern atomic64_t last_mm_ctx_id;
 
@@ -380,6 +381,21 @@ static inline temp_mm_state_t use_temporary_mm(struct mm_struct *mm)
 	lockdep_assert_irqs_disabled();
 	temp_state.mm = this_cpu_read(cpu_tlbstate.loaded_mm);
 	switch_mm_irqs_off(NULL, mm, current);
+
+	/*
+	 * If breakpoints are enabled, disable them while the temporary mm is
+	 * used. Userspace might set up watchpoints on addresses that are used
+	 * in the temporary mm, which would lead to wrong signals being sent or
+	 * crashes.
+	 *
+	 * Note that breakpoints are not disabled selectively, which also causes
+	 * kernel breakpoints (e.g., perf's) to be disabled. This might be
+	 * undesirable, but still seems reasonable as the code that runs in the
+	 * temporary mm should be short.
+	 */
+	if (hw_breakpoint_active())
+		hw_breakpoint_disable();
+
 	return temp_state;
 }
 
@@ -387,6 +403,13 @@ static inline void unuse_temporary_mm(temp_mm_state_t prev_state)
 {
 	lockdep_assert_irqs_disabled();
 	switch_mm_irqs_off(NULL, prev_state.mm, current);
+
+	/*
+	 * Restore the breakpoints if they were disabled before the temporary mm
+	 * was loaded.
+	 */
+	if (hw_breakpoint_active())
+		hw_breakpoint_restore();
 }
 
 #endif /* _ASM_X86_MMU_CONTEXT_H */
-- 
2.17.1

