Return-Path: <kernel-hardening-return-18638-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 41D731BA98A
	for <lists+kernel-hardening@lfdr.de>; Mon, 27 Apr 2020 18:01:12 +0200 (CEST)
Received: (qmail 11405 invoked by uid 550); 27 Apr 2020 16:00:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11338 invoked from network); 27 Apr 2020 16:00:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VMU4Dxx5VtpJ9uKOr46aqgBjHsAjXld8C2DfnSdv8zo=;
        b=pkChly/MR4gg1F/vqNKdS/sRvRHC9h2GTUAegFBSMak98utNlZ3ShOdFIbT8e3bAOS
         Qw8Q9Bej6lzq2ZoUHa9FOdVh6GHVnGPiKRrlCRqY56CqAwxR1tVy2B5KvqLQKlfr44mJ
         XzWmpehjC2j7wr+O0l2nKdIuS+q5brNPlRPb9CkFAGjYfLQjvqvg3b+3drlHjancStvP
         peyjrnBzg7WUQqKDslZ8rxgMPATe+dCJ7ChBdJXxt4UTJg1AoT2va9kPF7K74NEZshI8
         Tnhnhsr1OmuzskrQ5UhyDnyxXZggId4mQCkOufqIWd4kL7UJZzZOREaJQ/QmsfCBs6xr
         5oQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VMU4Dxx5VtpJ9uKOr46aqgBjHsAjXld8C2DfnSdv8zo=;
        b=a8EMFJD7Ru5ze0TZ8PW7Q0n8JU9CttgXFUgroWH60tqry3foEdgGKxlKbhXHK93Tcx
         xqs/iTZLfkybkzY7BWQD0ntsoHnXB47jRiFja5rB50B3WveLixrBbKp3IY+mJdMMz29R
         UqiVkf4rIEAbVBBS14NzRjntKD+oI4OUg27h/bQmNsAJ1vp9T8fgMbkQShPhzA0ShA8F
         yD/gcojtzuOw0DGit5tFSAhk3gYcuycpwFXtVgBhSOUWHnTYQ3zf8KBLxwE5ZYMq+2Ue
         rN7hKBbCt4mQ8PN15Avdf3j0VdLoPiONtdSbd7wOhlXx6dDvC2uABSQddxJ1ZMhmyMhK
         9zKQ==
X-Gm-Message-State: AGi0PubCtdXf4dpj9wj6Kvd36F4+3hR+xeCYTXLCxm62wsk/IfScOesh
	YpmYBtAYu4WnSnXIH1jXdKfOFIYmZ3xZ4tHj8Vo=
X-Google-Smtp-Source: APiQypIyrY142CMDGq82JJi1Gkln1wo6uLkxCKbOaTA9gyTh2SBuyrZ7K/0KHyeX6IkZStbpWE1vne7HEdDXyYcdEfs=
X-Received: by 2002:ad4:4b6b:: with SMTP id m11mr22911491qvx.130.1588003229016;
 Mon, 27 Apr 2020 09:00:29 -0700 (PDT)
Date: Mon, 27 Apr 2020 09:00:08 -0700
In-Reply-To: <20200427160018.243569-1-samitolvanen@google.com>
Message-Id: <20200427160018.243569-3-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200427160018.243569-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH v13 02/12] scs: add accounting
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	James Morse <james.morse@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Michal Marek <michal.lkml@markovi.net>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Jann Horn <jannh@google.com>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

This change adds accounting for the memory allocated for shadow stacks.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Will Deacon <will@kernel.org>
---
 drivers/base/node.c    |  6 ++++++
 fs/proc/meminfo.c      |  4 ++++
 include/linux/mmzone.h |  3 +++
 kernel/scs.c           | 15 +++++++++++++++
 mm/page_alloc.c        |  6 ++++++
 mm/vmstat.c            |  3 +++
 6 files changed, 37 insertions(+)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 10d7e818e118..50b8c0d43859 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -415,6 +415,9 @@ static ssize_t node_read_meminfo(struct device *dev,
 		       "Node %d AnonPages:      %8lu kB\n"
 		       "Node %d Shmem:          %8lu kB\n"
 		       "Node %d KernelStack:    %8lu kB\n"
+#ifdef CONFIG_SHADOW_CALL_STACK
+		       "Node %d ShadowCallStack:%8lu kB\n"
+#endif
 		       "Node %d PageTables:     %8lu kB\n"
 		       "Node %d NFS_Unstable:   %8lu kB\n"
 		       "Node %d Bounce:         %8lu kB\n"
@@ -438,6 +441,9 @@ static ssize_t node_read_meminfo(struct device *dev,
 		       nid, K(node_page_state(pgdat, NR_ANON_MAPPED)),
 		       nid, K(i.sharedram),
 		       nid, sum_zone_node_page_state(nid, NR_KERNEL_STACK_KB),
+#ifdef CONFIG_SHADOW_CALL_STACK
+		       nid, sum_zone_node_page_state(nid, NR_KERNEL_SCS_KB),
+#endif
 		       nid, K(sum_zone_node_page_state(nid, NR_PAGETABLE)),
 		       nid, K(node_page_state(pgdat, NR_UNSTABLE_NFS)),
 		       nid, K(sum_zone_node_page_state(nid, NR_BOUNCE)),
diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index 8c1f1bb1a5ce..09cd51c8d23d 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -103,6 +103,10 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 	show_val_kb(m, "SUnreclaim:     ", sunreclaim);
 	seq_printf(m, "KernelStack:    %8lu kB\n",
 		   global_zone_page_state(NR_KERNEL_STACK_KB));
+#ifdef CONFIG_SHADOW_CALL_STACK
+	seq_printf(m, "ShadowCallStack:%8lu kB\n",
+		   global_zone_page_state(NR_KERNEL_SCS_KB));
+#endif
 	show_val_kb(m, "PageTables:     ",
 		    global_zone_page_state(NR_PAGETABLE));
 
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 1b9de7d220fb..acffc3bc6178 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -156,6 +156,9 @@ enum zone_stat_item {
 	NR_MLOCK,		/* mlock()ed pages found and moved off LRU */
 	NR_PAGETABLE,		/* used for pagetables */
 	NR_KERNEL_STACK_KB,	/* measured in KiB */
+#if IS_ENABLED(CONFIG_SHADOW_CALL_STACK)
+	NR_KERNEL_SCS_KB,	/* measured in KiB */
+#endif
 	/* Second 128 byte cacheline */
 	NR_BOUNCE,
 #if IS_ENABLED(CONFIG_ZSMALLOC)
diff --git a/kernel/scs.c b/kernel/scs.c
index 43624be9ad90..8769016c714c 100644
--- a/kernel/scs.c
+++ b/kernel/scs.c
@@ -6,8 +6,10 @@
  */
 
 #include <linux/kasan.h>
+#include <linux/mm.h>
 #include <linux/scs.h>
 #include <linux/slab.h>
+#include <linux/vmstat.h>
 #include <asm/scs.h>
 
 static struct kmem_cache *scs_cache;
@@ -40,6 +42,17 @@ void __init scs_init(void)
 	scs_cache = kmem_cache_create("scs_cache", SCS_SIZE, 0, 0, NULL);
 }
 
+static struct page *__scs_page(struct task_struct *tsk)
+{
+	return virt_to_page(task_scs(tsk));
+}
+
+static void scs_account(struct task_struct *tsk, int account)
+{
+	mod_zone_page_state(page_zone(__scs_page(tsk)), NR_KERNEL_SCS_KB,
+		account * (SCS_SIZE / 1024));
+}
+
 int scs_prepare(struct task_struct *tsk, int node)
 {
 	void *s;
@@ -50,6 +63,7 @@ int scs_prepare(struct task_struct *tsk, int node)
 
 	task_scs(tsk) = s;
 	task_scs_offset(tsk) = 0;
+	scs_account(tsk, 1);
 
 	return 0;
 }
@@ -64,5 +78,6 @@ void scs_release(struct task_struct *tsk)
 
 	WARN_ON(scs_corrupted(tsk));
 
+	scs_account(tsk, -1);
 	scs_free(s);
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 69827d4fa052..83743d7a6177 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5411,6 +5411,9 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 			" managed:%lukB"
 			" mlocked:%lukB"
 			" kernel_stack:%lukB"
+#ifdef CONFIG_SHADOW_CALL_STACK
+			" shadow_call_stack:%lukB"
+#endif
 			" pagetables:%lukB"
 			" bounce:%lukB"
 			" free_pcp:%lukB"
@@ -5433,6 +5436,9 @@ void show_free_areas(unsigned int filter, nodemask_t *nodemask)
 			K(zone_managed_pages(zone)),
 			K(zone_page_state(zone, NR_MLOCK)),
 			zone_page_state(zone, NR_KERNEL_STACK_KB),
+#ifdef CONFIG_SHADOW_CALL_STACK
+			zone_page_state(zone, NR_KERNEL_SCS_KB),
+#endif
 			K(zone_page_state(zone, NR_PAGETABLE)),
 			K(zone_page_state(zone, NR_BOUNCE)),
 			K(free_pcp),
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 96d21a792b57..2435d2c24657 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1119,6 +1119,9 @@ const char * const vmstat_text[] = {
 	"nr_mlock",
 	"nr_page_table_pages",
 	"nr_kernel_stack",
+#if IS_ENABLED(CONFIG_SHADOW_CALL_STACK)
+	"nr_shadow_call_stack",
+#endif
 	"nr_bounce",
 #if IS_ENABLED(CONFIG_ZSMALLOC)
 	"nr_zspages",
-- 
2.26.2.303.gf8c07b1a785-goog

