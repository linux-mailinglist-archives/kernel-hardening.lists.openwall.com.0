Return-Path: <kernel-hardening-return-19862-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2A940265088
	for <lists+kernel-hardening@lfdr.de>; Thu, 10 Sep 2020 22:22:09 +0200 (CEST)
Received: (qmail 20022 invoked by uid 550); 10 Sep 2020 20:21:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19944 invoked from network); 10 Sep 2020 20:21:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wJZHFZKfNNyC67jwisOmBZgnX1BFNcIrFx6Hk0CVZj0=;
        b=BA7gUYJDUrV86/gK5hnjBVttT9NwmYMFnA1+ImWoiBLcN5oOXU8QthOaJfPt9gc2ug
         B5tOcCRa23Jdbs1ij+K+aQKZUmgVALJupA7J8lhiEDDLKiF7mOFMbBz14LJWznBzsC5z
         XqB2DX5w0vVnuDESFdM8sqC7YdTMb8v+p7xZM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wJZHFZKfNNyC67jwisOmBZgnX1BFNcIrFx6Hk0CVZj0=;
        b=hmWCEQqlYxmMol0FFp7q+L65MN2oWT1k+L4rnNjck63R4JR4bQRL7jF9C6WMbca0Yf
         QIE/UDPZBd1zxzjgarQcEdCTy1jhrrG4c2hmwnVtylGoaf0lU4L3i6LsCUYvw1IRSfFC
         mZhWtkt0mtpjnfhAWrJf2tHcRzI9OA0QHLgti+LjW0zNGOuOG3tb7E+NaIYJq5XfFvBu
         0PG8idtfBDYCD49TYz19Sp0GSN+tkZrv8IqAZr1iPEwdxAzEknD3SnQbacY0/tD6KqVa
         S5dBWiIHDhKJCKQ6KQ2w9hGONFi2dXsmZcUYw3vPkkih+Dl4R14O4Bl8lCSsTMkaLmBh
         XVlA==
X-Gm-Message-State: AOAM5305cudvT/3Vq0d08h/XhKr5UBBxM728GmUUtCw7CBda9lr6lBQo
	Z3Waupx8wPKOA9b3aNR2wHQL5Q==
X-Google-Smtp-Source: ABdhPJy1DAtvKfpKmGtbdkGGrHoagYjMTqm33L0ZJJiXD+9dPEL9PIt+9mXnYTzSYOcasBfTp3U2vg==
X-Received: by 2002:a17:902:b901:: with SMTP id bf1mr6995903plb.153.1599769280963;
        Thu, 10 Sep 2020 13:21:20 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>,
	John Wood <john.wood@gmx.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Iurii Zaikin <yzaikin@google.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: [RFC PATCH 2/6] security/fbfam: Add the api to manage statistics
Date: Thu, 10 Sep 2020 13:21:03 -0700
Message-Id: <20200910202107.3799376-3-keescook@chromium.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910202107.3799376-1-keescook@chromium.org>
References: <20200910202107.3799376-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: John Wood <john.wood@gmx.com>

Create a statistical data structure to hold all the necessary
information involve in a fork brute force attack. This info is a
timestamp for the first fork or execve and the number of crashes since
then. Moreover, due to this statitistical data will be shared between
different tasks, a reference counter it is necessary.

For a correct management of an attack it is also necessary that all the
tasks hold statistical data. The same statistical data needs to be
shared between all the tasks that hold the same memory contents or in
other words, between all the tasks that have been forked without any
execve call.

When a forked task calls the execve system call, the memory contents are
set with new values. So, in this scenario the parent's statistical data
no need to be share. Instead, a new statistical data structure must be
allocated to start a new cycle.

The statistical data that every task holds needs to be clear when a task
exits. Due to this data is shared across multiples tasks, the reference
counter is useful to free the previous allocated data only when there
are not other pointers to the same data. Or in other words, when the
reference counter reaches zero.

So, based in all the previous information add the api to manage all the
commented cases.

Also, add to the struct task_struct a new field to point to the
statitistical data related to an attack. This way, all the tasks will
have access to this information.

Signed-off-by: John Wood <john.wood@gmx.com>
---
 include/fbfam/fbfam.h   |  18 +++++
 include/linux/sched.h   |   4 +
 security/Makefile       |   4 +
 security/fbfam/Makefile |   2 +
 security/fbfam/fbfam.c  | 163 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 191 insertions(+)
 create mode 100644 include/fbfam/fbfam.h
 create mode 100644 security/fbfam/Makefile
 create mode 100644 security/fbfam/fbfam.c

diff --git a/include/fbfam/fbfam.h b/include/fbfam/fbfam.h
new file mode 100644
index 000000000000..b5b7d1127a52
--- /dev/null
+++ b/include/fbfam/fbfam.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _FBFAM_H_
+#define _FBFAM_H_
+
+#include <linux/sched.h>
+
+#ifdef CONFIG_FBFAM
+int fbfam_fork(struct task_struct *child);
+int fbfam_execve(void);
+int fbfam_exit(void);
+#else
+static inline int fbfam_fork(struct task_struct *child) { return 0; }
+static inline int fbfam_execve(void) { return 0; }
+static inline int fbfam_exit(void) { return 0; }
+#endif
+
+#endif /* _FBFAM_H_ */
+
diff --git a/include/linux/sched.h b/include/linux/sched.h
index afe01e232935..00e1aa5e00cd 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1315,6 +1315,10 @@ struct task_struct {
 	struct callback_head		mce_kill_me;
 #endif
 
+#ifdef CONFIG_FBFAM
+	struct fbfam_stats		*fbfam_stats;
+#endif
+
 	/*
 	 * New fields for task_struct should be added above here, so that
 	 * they are included in the randomized portion of task_struct.
diff --git a/security/Makefile b/security/Makefile
index 3baf435de541..36dc4b536349 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -36,3 +36,7 @@ obj-$(CONFIG_BPF_LSM)			+= bpf/
 # Object integrity file lists
 subdir-$(CONFIG_INTEGRITY)		+= integrity
 obj-$(CONFIG_INTEGRITY)			+= integrity/
+
+# Object fbfam file lists
+subdir-$(CONFIG_FBFAM)			+= fbfam
+obj-$(CONFIG_FBFAM)			+= fbfam/
diff --git a/security/fbfam/Makefile b/security/fbfam/Makefile
new file mode 100644
index 000000000000..f4b9f0b19c44
--- /dev/null
+++ b/security/fbfam/Makefile
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_FBFAM) += fbfam.o
diff --git a/security/fbfam/fbfam.c b/security/fbfam/fbfam.c
new file mode 100644
index 000000000000..0387f95f6408
--- /dev/null
+++ b/security/fbfam/fbfam.c
@@ -0,0 +1,163 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <asm/current.h>
+#include <fbfam/fbfam.h>
+#include <linux/errno.h>
+#include <linux/gfp.h>
+#include <linux/jiffies.h>
+#include <linux/refcount.h>
+#include <linux/slab.h>
+
+/**
+ * struct fbfam_stats - Fork brute force attack mitigation statistics.
+ * @refc: Reference counter.
+ * @faults: Number of crashes since jiffies.
+ * @jiffies: First fork or execve timestamp.
+ *
+ * The purpose of this structure is to manage all the necessary information to
+ * compute the crashing rate of an application. So, it holds a first fork or
+ * execve timestamp and a number of crashes since then. This way the crashing
+ * rate in milliseconds per fault can be compute when necessary with the
+ * following formula:
+ *
+ * u64 delta_jiffies = get_jiffies_64() - fbfam_stats::jiffies;
+ * u64 delta_time = jiffies64_to_msecs(delta_jiffies);
+ * u64 crashing_rate = delta_time / (u64)fbfam_stats::faults;
+ *
+ * If the fbfam_stats::faults is zero, the above formula can't be used. In this
+ * case, the crashing rate is zero.
+ *
+ * Moreover, since the same allocated structure will be used in every fork
+ * since the first one or execve, it's also necessary a reference counter.
+ */
+struct fbfam_stats {
+	refcount_t refc;
+	unsigned int faults;
+	u64 jiffies;
+};
+
+/**
+ * fbfam_new_stats() - Allocation of new statistics structure.
+ *
+ * If the allocation is successful the reference counter is set to one to
+ * indicate that there will be one task that points to this structure. The
+ * faults field is initialize to zero and the timestamp for this moment is set.
+ *
+ * Return: NULL if the allocation fails. A pointer to the new allocated
+ *         statistics structure if it success.
+ */
+static struct fbfam_stats *fbfam_new_stats(void)
+{
+	struct fbfam_stats *stats = kmalloc(sizeof(struct fbfam_stats),
+					    GFP_KERNEL);
+
+	if (stats) {
+		refcount_set(&stats->refc, 1);
+		stats->faults = 0;
+		stats->jiffies = get_jiffies_64();
+	}
+
+	return stats;
+}
+
+/*
+ * fbfam_fork() - Fork management.
+ * @child: Pointer to the child task that will be created with the fork system
+ *         call.
+ *
+ * For a correct management of a fork brute force attack it is necessary that
+ * all the tasks hold statistical data. The same statistical data needs to be
+ * shared between all the tasks that hold the same memory contents or in other
+ * words, between all the tasks that have been forked without any execve call.
+ *
+ * To ensure this, if the current task doesn't have statistical data when forks
+ * (only possible in the first fork of the zero task), it is mandatory to
+ * allocate a new one. This way, the child task always will share the statistics
+ * with its parent.
+ *
+ * Return: -ENOMEN if the allocation of the new statistics structure fails.
+ *         Zero otherwise.
+ */
+int fbfam_fork(struct task_struct *child)
+{
+	struct fbfam_stats **stats = &current->fbfam_stats;
+
+	if (!*stats) {
+		*stats = fbfam_new_stats();
+		if (!*stats)
+			return -ENOMEM;
+	}
+
+	refcount_inc(&(*stats)->refc);
+	child->fbfam_stats = *stats;
+	return 0;
+}
+
+/**
+ * fbfam_execve() - Execve management.
+ *
+ * When a forked task calls the execve system call, the memory contents are set
+ * with new values. So, in this scenario the parent's statistical data no need
+ * to be share. Instead, a new statistical data structure must be allocated to
+ * start a new cycle. This condition is detected when the statistics reference
+ * counter holds a value greater than or equal to two (a fork always sets the
+ * statistics reference counter to two since the parent and the child task are
+ * sharing the same data).
+ *
+ * However, if the execve function is called immediately after another execve
+ * call, althought the memory contents are reset, there is no need to allocate
+ * a new statistical data structure. This is possible because at this moment
+ * only one task (the task that calls the execve function) points to the data.
+ * In this case, the previous allocation is used and only the faults and time
+ * fields are reset.
+ *
+ * Return: -ENOMEN if the allocation of the new statistics structure fails.
+ *         -EFAULT if the current task doesn't have statistical data. Zero
+ *         otherwise.
+ */
+int fbfam_execve(void)
+{
+	struct fbfam_stats **stats = &current->fbfam_stats;
+
+	if (!*stats)
+		return -EFAULT;
+
+	if (!refcount_dec_not_one(&(*stats)->refc)) {
+		/* execve call after an execve call */
+		(*stats)->faults = 0;
+		(*stats)->jiffies = get_jiffies_64();
+		return 0;
+	}
+
+	/* execve call after a fork call */
+	*stats = fbfam_new_stats();
+	if (!*stats)
+		return -ENOMEM;
+
+	return 0;
+}
+
+/**
+ * fbfam_exit() - Exit management.
+ *
+ * The statistical data that every task holds needs to be clear when a task
+ * exits. Due to this data is shared across multiples tasks, the reference
+ * counter is useful to free the previous allocated data only when there are
+ * not other pointers to the same data. Or in other words, when the reference
+ * counter reaches zero.
+ *
+ * Return: -EFAULT if the current task doesn't have statistical data. Zero
+ *         otherwise.
+ */
+int fbfam_exit(void)
+{
+	struct fbfam_stats *stats = current->fbfam_stats;
+
+	if (!stats)
+		return -EFAULT;
+
+	if (refcount_dec_and_test(&stats->refc))
+		kfree(stats);
+
+	return 0;
+}
+
-- 
2.25.1

