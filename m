Return-Path: <kernel-hardening-return-15824-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 167F7B2E6
	for <lists+kernel-hardening@lfdr.de>; Sat, 27 Apr 2019 08:44:34 +0200 (CEST)
Received: (qmail 3075 invoked by uid 550); 27 Apr 2019 06:43:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1902 invoked from network); 27 Apr 2019 06:43:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gMfxobg7i1AP5PQ14JM+oGjrmklNXXx9IUFM/PW54zo=;
        b=XKJ4fAeBY8aGdbJDn84dW83HzgSvQACPuhXWJHvF1CWt6rAKSo0+tUCXqeDEYn8KGx
         u3zXII+RSuYhdLmlbo5/0feDTgEEs6/tOmzti0w5Pevv/8Nua7dmelg2Hg1YTOM0HPNp
         IuB1XxBtPV5C1LDrt4HWOamCYTjBpu9Uc9bqXu6wh2x58Sr/Usj1f74P/vpY9jMFSCFS
         THBbi+fo5P15SNYnnZLc+khNDUp7StdyPifYfNcqKpXcU/HGBdU106YbtBqZ2gBNSvKt
         YTZSQ/QqPm8CwczIhg2BokKOhThemqJ36d1wwJl1ZB93G6rLPD545DygLOMnvs67gNXF
         w1Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gMfxobg7i1AP5PQ14JM+oGjrmklNXXx9IUFM/PW54zo=;
        b=oATs5081V8e8esjCNNQnXC7dxGY4KWZKEbYLMrHtcTj6UDE9L27HfBMS1mY7wMW2GV
         sXPuj9WWiRla3+Bn6tB/x4Ohgtr60WcRc5AIgmcrTppQW1hwaxbNErvI/2aifp+eywfD
         JPkdKwSGiET1YoJZ/VQq36QhpigN9IOoTi+78/juumgi4HqalzmYiWad5YfJwgPwRS5d
         a/wlPTtSbZEM2riPIhjlhT4Tlt7tlbnhJbeFSctI0njbNf6sFz6OlnLQT1b2igquS5js
         q/WXwXg6ADWxrCMYuW7T2mxYZ+AvUpCXXy6VEDWXRltjDZdFzABiGjXEq+qHKNsNwJQi
         6DQg==
X-Gm-Message-State: APjAAAXA5V6N8CiBP1ueuHlHKb3PNqd049GMzgeQ6kXuLwMW4SFrVwPI
	97SZmfZVhtzAhiHPKPG7EHw=
X-Google-Smtp-Source: APXvYqwk9lLXQyc9bNgKLLm6YtZMcI1PVJ4KR2rM1C+cN3nT9zotDQcbIXGbwEvAmUupbSpfYScE8w==
X-Received: by 2002:a17:902:a7:: with SMTP id a36mr50206141pla.111.1556347390037;
        Fri, 26 Apr 2019 23:43:10 -0700 (PDT)
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
	Nadav Amit <namit@vmware.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: [PATCH v6 05/24] uprobes: Initialize uprobes earlier
Date: Fri, 26 Apr 2019 16:22:44 -0700
Message-Id: <20190426232303.28381-6-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190426232303.28381-1-nadav.amit@gmail.com>
References: <20190426232303.28381-1-nadav.amit@gmail.com>

From: Nadav Amit <namit@vmware.com>

In order to have a separate address space for text poking, we need to
duplicate init_mm early during start_kernel(). This, however, introduces
a problem since uprobes functions are called from dup_mmap(), but
uprobes is still not initialized in this early stage.

Since uprobes initialization is necassary for fork, and since all the
dependant initialization has been done when fork is initialized (percpu
and vmalloc), move uprobes initialization to fork_init(). It does not
seem uprobes introduces any security problem for the poking_mm.

Crash and burn if uprobes initialization fails, similarly to other early
initializations. Change the init_probes() name to probes_init() to match
other early initialization functions name convention.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 include/linux/uprobes.h | 5 +++++
 kernel/events/uprobes.c | 8 +++-----
 kernel/fork.c           | 1 +
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index 103a48a48872..12bf0b68ed92 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -115,6 +115,7 @@ struct uprobes_state {
 	struct xol_area		*xol_area;
 };
 
+extern void __init uprobes_init(void);
 extern int set_swbp(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long vaddr);
 extern int set_orig_insn(struct arch_uprobe *aup, struct mm_struct *mm, unsigned long vaddr);
 extern bool is_swbp_insn(uprobe_opcode_t *insn);
@@ -154,6 +155,10 @@ extern void arch_uprobe_copy_ixol(struct page *page, unsigned long vaddr,
 struct uprobes_state {
 };
 
+static inline void uprobes_init(void)
+{
+}
+
 #define uprobe_get_trap_addr(regs)	instruction_pointer(regs)
 
 static inline int
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index c5cde87329c7..e6a0d6be87e3 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -2294,16 +2294,14 @@ static struct notifier_block uprobe_exception_nb = {
 	.priority		= INT_MAX-1,	/* notified after kprobes, kgdb */
 };
 
-static int __init init_uprobes(void)
+void __init uprobes_init(void)
 {
 	int i;
 
 	for (i = 0; i < UPROBES_HASH_SZ; i++)
 		mutex_init(&uprobes_mmap_mutex[i]);
 
-	if (percpu_init_rwsem(&dup_mmap_sem))
-		return -ENOMEM;
+	BUG_ON(percpu_init_rwsem(&dup_mmap_sem));
 
-	return register_die_notifier(&uprobe_exception_nb);
+	BUG_ON(register_die_notifier(&uprobe_exception_nb));
 }
-__initcall(init_uprobes);
diff --git a/kernel/fork.c b/kernel/fork.c
index 9dcd18aa210b..44fba5e5e916 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -815,6 +815,7 @@ void __init fork_init(void)
 #endif
 
 	lockdep_init_task(&init_task);
+	uprobes_init();
 }
 
 int __weak arch_dup_task_struct(struct task_struct *dst,
-- 
2.17.1

