Return-Path: <kernel-hardening-return-15825-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3CB53B2E7
	for <lists+kernel-hardening@lfdr.de>; Sat, 27 Apr 2019 08:44:47 +0200 (CEST)
Received: (qmail 3249 invoked by uid 550); 27 Apr 2019 06:43:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3129 invoked from network); 27 Apr 2019 06:43:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PqX9u33LMatWrF2rdzOLAo8PTOZ3S7r/OUOEdwJc/wY=;
        b=dLUUcPucbWSjI0KF0GYdfa3//vc9Trf9GNL1Jxgol/lAzL/Qif+nwieAhan1enOtj9
         IEvF0toGPmi5evSU5LGqWY70kCiO3p7KKseN+96U+aK7PFiGt1LmM5YwgAU+lA6dRruQ
         txGFF06hrpSSsexZDBeyJTD8iZpafmkscb7dw3FJPuVKduR/83ccqIn9U64Bhl7mXai2
         QvPXBsrBhxIENhDIjXt5l8fioHpUH4RBLdAlGLQjejsyatNlX3PJPjeZX8AdLYgJMv+s
         txk3ENcm6pNvFPMHYkZ9djMndR8b2wvyhfIPdTbE4Wq/3iIH/ChGjSPLA1uzJUN9rbuN
         8qpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=PqX9u33LMatWrF2rdzOLAo8PTOZ3S7r/OUOEdwJc/wY=;
        b=D/S0UEAOToJjcb6o1vigYzKTlZnW6X+Ik06WYnIEdkX+TF2k5/nExwke2ReJ9yP8Jn
         kCcsUw/2YyJbePCmjBiJSbZJ+03FM0pxloeGfaoQYGsN6mcaJE3u0P22M6yae0ct++gN
         GsvxvPZJ9xE+TYkkSl0eqHkKBTw81GwFQsWh/bNPcUlppGixInQmhtxlYgDUQ46uyefw
         FE4BQX/mQmNf3JukyKURq6G4WpEewJr02kMNf6nOLCsnc7wc9BfY3E3LNv9UpBfohzEh
         fXp4rI9T8o4E402XGIa3fP6R+eCVpFe18HqVr66sqNk//UWDRrBeFZYrI0ekvPxe1gkp
         Gk9Q==
X-Gm-Message-State: APjAAAUY78vJNEzrwryP/2mS6adCyYx1LmewcSKZvv0rMLmmYGXYVAU5
	XHin2FEM92yrLcSwwuIxmfk=
X-Google-Smtp-Source: APXvYqwtiOYLXN6z+omvr9q5XmanCyE26RTxB/9RLJMeynpzcv4zb2Q6alFcE2kD+WU/ILJ0eVx92Q==
X-Received: by 2002:aa7:920b:: with SMTP id 11mr49825084pfo.3.1556347392003;
        Fri, 26 Apr 2019 23:43:12 -0700 (PDT)
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
	Kees Cook <keescook@chromium.org>,
	Dave Hansen <dave.hansen@intel.com>
Subject: [PATCH v6 06/24] fork: Provide a function for copying init_mm
Date: Fri, 26 Apr 2019 16:22:45 -0700
Message-Id: <20190426232303.28381-7-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190426232303.28381-1-nadav.amit@gmail.com>
References: <20190426232303.28381-1-nadav.amit@gmail.com>

From: Nadav Amit <namit@vmware.com>

Provide a function for copying init_mm. This function will be later used
for setting a temporary mm.

Cc: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
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
-- 
2.17.1

