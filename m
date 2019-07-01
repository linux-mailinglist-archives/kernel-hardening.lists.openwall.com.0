Return-Path: <kernel-hardening-return-15853-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4BCB3F5A6
	for <lists+kernel-hardening@lfdr.de>; Tue, 30 Apr 2019 13:31:16 +0200 (CEST)
Received: (qmail 21924 invoked by uid 550); 30 Apr 2019 11:30:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 12109 invoked from network); 30 Apr 2019 11:19:12 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x3UBIeWP1347157
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2019041745; t=1556623122;
	bh=ZhGa5Rw2An+g9Pm5bMaZJRBKLbUWU/FVeTI2VZxezKQ=;
	h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
	b=MytLcW5D5rC54iKa5hv8XWJ21/xogRmGGierAS8SWy8Fp6CDz+kkTEtbhujPGefJw
	 3rfxgycUOK3aIuSb+fTpgdFCOXboCHSb4/Nnn+qO/VExDNDKXzSmg7MjlsTDvqNqJw
	 s2Q8eCh+rT//3EdhYwjC6bB3hEa7BTdGPHkkjANdp3QbwHWuFsXgYHoTVyrzccO+UM
	 4bxOfzIDeM4sDRSKzAUmVsXIa63bjrDtqVCmP0Q/3mGVmn/dTBYa8yLRjsi7vcLLVU
	 yZpeeSLPiMMBvCGRGDTnyzJib/5N+MzwiirQ/jwBJFN3hhBwtbllqT454YRl3sNSwG
	 blhl0j03QEyLQ==
Date: Tue, 30 Apr 2019 04:18:40 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
Sender: tip tree robot <tipbot@zytor.com>
From: tip-bot for Nadav Amit <tipbot@zytor.com>
Message-ID: <tip-13585fa0668c724efab9635aaeef6ec390217415@git.kernel.org>
Cc: peterz@infradead.org, luto@kernel.org, mhiramat@kernel.org,
        kristen@linux.intel.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        deneen.t.dock@intel.com, namit@vmware.com, tglx@linutronix.de,
        torvalds@linux-foundation.org, dave.hansen@intel.com, mingo@kernel.org,
        linux_dti@icloud.com, kernel-hardening@lists.openwall.com,
        will.deacon@arm.com, rick.p.edgecombe@intel.com, riel@surriel.com,
        keescook@chromium.org, akpm@linux-foundation.org, bp@alien8.de,
        ard.biesheuvel@linaro.org
In-Reply-To: <20190426001143.4983-6-namit@vmware.com>
References: <20190426001143.4983-6-namit@vmware.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] fork: Provide a function for copying init_mm
Git-Commit-ID: 13585fa0668c724efab9635aaeef6ec390217415
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from
 these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,BAYES_00,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	FREEMAIL_FORGED_REPLYTO,T_DATE_IN_FUTURE_96_Q autolearn=no
	autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on terminus.zytor.com

Commit-ID:  13585fa0668c724efab9635aaeef6ec390217415
Gitweb:     https://git.kernel.org/tip/13585fa0668c724efab9635aaeef6ec390217415
Author:     Nadav Amit <namit@vmware.com>
AuthorDate: Thu, 25 Apr 2019 17:11:25 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 30 Apr 2019 12:37:51 +0200

fork: Provide a function for copying init_mm

Provide a function for copying init_mm. This function will be later used
for setting a temporary mm.

Tested-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: <akpm@linux-foundation.org>
Cc: <ard.biesheuvel@linaro.org>
Cc: <deneen.t.dock@intel.com>
Cc: <kernel-hardening@lists.openwall.com>
Cc: <kristen@linux.intel.com>
Cc: <linux_dti@icloud.com>
Cc: <will.deacon@arm.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190426001143.4983-6-namit@vmware.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/sched/task.h |  1 +
 kernel/fork.c              | 24 ++++++++++++++++++------
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index 2e97a2227045..f1227f2c38a4 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -76,6 +76,7 @@ extern void exit_itimers(struct signal_struct *);
 extern long _do_fork(unsigned long, unsigned long, unsigned long, int __user *, int __user *, unsigned long);
 extern long do_fork(unsigned long, unsigned long, unsigned long, int __user *, int __user *);
 struct task_struct *fork_idle(int);
+struct mm_struct *copy_init_mm(void);
 extern pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
 extern long kernel_wait4(pid_t, int __user *, int, struct rusage *);
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 44fba5e5e916..fbe9dfcd8680 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1299,13 +1299,20 @@ void mm_release(struct task_struct *tsk, struct mm_struct *mm)
 		complete_vfork_done(tsk);
 }
 
-/*
- * Allocate a new mm structure and copy contents from the
- * mm structure of the passed in task structure.
+/**
+ * dup_mm() - duplicates an existing mm structure
+ * @tsk: the task_struct with which the new mm will be associated.
+ * @oldmm: the mm to duplicate.
+ *
+ * Allocates a new mm structure and duplicates the provided @oldmm structure
+ * content into it.
+ *
+ * Return: the duplicated mm or NULL on failure.
  */
-static struct mm_struct *dup_mm(struct task_struct *tsk)
+static struct mm_struct *dup_mm(struct task_struct *tsk,
+				struct mm_struct *oldmm)
 {
-	struct mm_struct *mm, *oldmm = current->mm;
+	struct mm_struct *mm;
 	int err;
 
 	mm = allocate_mm();
@@ -1372,7 +1379,7 @@ static int copy_mm(unsigned long clone_flags, struct task_struct *tsk)
 	}
 
 	retval = -ENOMEM;
-	mm = dup_mm(tsk);
+	mm = dup_mm(tsk, current->mm);
 	if (!mm)
 		goto fail_nomem;
 
@@ -2187,6 +2194,11 @@ struct task_struct *fork_idle(int cpu)
 	return task;
 }
 
+struct mm_struct *copy_init_mm(void)
+{
+	return dup_mm(NULL, &init_mm);
+}
+
 /*
  *  Ok, this is the main fork-routine.
  *
