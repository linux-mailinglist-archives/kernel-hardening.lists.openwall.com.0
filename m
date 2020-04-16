Return-Path: <kernel-hardening-return-18531-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id AFC7D1ACD02
	for <lists+kernel-hardening@lfdr.de>; Thu, 16 Apr 2020 18:13:40 +0200 (CEST)
Received: (qmail 32642 invoked by uid 550); 16 Apr 2020 16:13:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32559 invoked from network); 16 Apr 2020 16:13:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=0zoCAxwf9k6lfoo3cxV3l2Ts8Ighj8ILmpKvjJbqwvo=;
        b=oaXHw4OoNjSODYtqP+D86dNRDfH9pFvBIgL5AAghUBFYKnrbVWQbiCIYvMoV5G/92q
         eAijVWC8ga1IgT8f2InqqkXDfvnJOHAfEoJR4Tv3ygcBIFNB+3MRslx3FassUAy0Uatd
         KTgMwbBl3RKE4Te0j7hl6uSM+q2hHmXvTAE68O2Qqmw80ejmwBmIa/uQIk0Ea6awb4D/
         kiUfpIC642BpdAmbbEnAoxCTXQxQ62KaUPmVGWnjnutLyFbIJjdlfDx/bJhA/U7yXFFD
         en3fX1+ixzUBoNEWIbC1MibOBSiJdNjGY0/wQFmuEOqMPTQHYahJnCQZvu4lXlhPO+Ut
         3Uiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=0zoCAxwf9k6lfoo3cxV3l2Ts8Ighj8ILmpKvjJbqwvo=;
        b=bfFNTd2LKmx5kZa+RhzmbwLa7kKguwnvRi83IyWPABuK/RoATl7CSwJwQEfALmSs9q
         pdJjNwTrfmdpcQsabjt9w21spVQqmn2tITXOjafLCIfjVtasqRoH+BvF01NWcoQhMXUL
         GTKOQCdS3j7f++Pw2j7mSiW7I+GF67kwW8ogMKeMMUKC7cEE8vctCB3YT5irwfS36ltw
         8NVLPy3erw7tCO9TrMpFg7gI5aMAk2CInhYDawnyiIMqFFuM3Tjjqku/3s8HeUZ/M21C
         DsJyUWCrom6Z7mJw9zRqmooebkLdythhyq3RXty257xEsBS9o82+lmJIjqmKRXIRXr5Q
         OiQQ==
X-Gm-Message-State: AGi0PuZsGsTD//gMRgi9Xcpadt8NY974m3p+mD7FLGInU9q7Is+j2Qas
	BjLPgH24uz85VxW+Kc4jkcm3pMyYxpc16E7R8lQ=
X-Google-Smtp-Source: APiQypKIig2VehAviH0oXuxl4EJ3M3D8ILlWZ/6oWMjPFzuhTA+6Vu4jAmcNZSFI+UI1yW8xrivvKTZYZblKhvZz34o=
X-Received: by 2002:a63:d049:: with SMTP id s9mr30834027pgi.384.1587053577150;
 Thu, 16 Apr 2020 09:12:57 -0700 (PDT)
Date: Thu, 16 Apr 2020 09:12:36 -0700
In-Reply-To: <20200416161245.148813-1-samitolvanen@google.com>
Message-Id: <20200416161245.148813-4-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200416161245.148813-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v11 03/12] scs: add support for stack usage debugging
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

Implements CONFIG_DEBUG_STACK_USAGE for shadow stacks. When enabled,
also prints out the highest shadow stack usage per process.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 kernel/scs.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/kernel/scs.c b/kernel/scs.c
index 5245e992c692..ad74d13f2c0f 100644
--- a/kernel/scs.c
+++ b/kernel/scs.c
@@ -184,6 +184,44 @@ int scs_prepare(struct task_struct *tsk, int node)
 	return 0;
 }
 
+#ifdef CONFIG_DEBUG_STACK_USAGE
+static inline unsigned long scs_used(struct task_struct *tsk)
+{
+	unsigned long *p = __scs_base(tsk);
+	unsigned long *end = scs_magic(p);
+	unsigned long s = (unsigned long)p;
+
+	while (p < end && READ_ONCE_NOCHECK(*p))
+		p++;
+
+	return (unsigned long)p - s;
+}
+
+static void scs_check_usage(struct task_struct *tsk)
+{
+	static DEFINE_SPINLOCK(lock);
+	static unsigned long highest;
+	unsigned long used = scs_used(tsk);
+
+	if (used <= highest)
+		return;
+
+	spin_lock(&lock);
+
+	if (used > highest) {
+		pr_info("%s (%d): highest shadow stack usage: %lu bytes\n",
+			tsk->comm, task_pid_nr(tsk), used);
+		highest = used;
+	}
+
+	spin_unlock(&lock);
+}
+#else
+static inline void scs_check_usage(struct task_struct *tsk)
+{
+}
+#endif
+
 bool scs_corrupted(struct task_struct *tsk)
 {
 	unsigned long *magic = scs_magic(__scs_base(tsk));
@@ -200,6 +238,7 @@ void scs_release(struct task_struct *tsk)
 		return;
 
 	WARN_ON(scs_corrupted(tsk));
+	scs_check_usage(tsk);
 
 	scs_account(tsk, -1);
 	task_set_scs(tsk, NULL);
-- 
2.26.1.301.g55bc3eb7cb9-goog

