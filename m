Return-Path: <kernel-hardening-return-17192-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B0684EB5AE
	for <lists+kernel-hardening@lfdr.de>; Thu, 31 Oct 2019 18:00:18 +0100 (CET)
Received: (qmail 29975 invoked by uid 550); 31 Oct 2019 16:59:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 14225 invoked from network); 31 Oct 2019 16:47:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ISQCDuiClH+Ob0sv0IF5h/3w79WcDO0VBPNi/N63ddM=;
        b=L6nedrmEU6JvkHcsnA5dyzyzZUdFX15pwpo+PGFFiFEz0adILiGuaSNCBEk5zwayGV
         E9E9rgsrq5/1A2h2MtticPSYVLesH41cnymaor0lAwHnDlDWxTf5/4qQBQJbY1uWFtLZ
         C6sr+tdm50IQTwMHAjyoVlcXkjLcFiHznGojckMYMtDoi/bOtSH0IlV0Tnioy87094XS
         ezKAXvoCEbuRluKXTl7DxPY8VwUTSt5guCPWasnZX2NkFzFDs5i1SJLDNnu+b65KtE/0
         /kLy//TY9FnsnLxzNsp6fluwupXbn29fiFnAO1x5t8/AaHOuDntvEDf7xlit3hYA7ljG
         EZkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ISQCDuiClH+Ob0sv0IF5h/3w79WcDO0VBPNi/N63ddM=;
        b=uVr+pjwkDvHW9Dth7cPHs4NQdtyAQX7vDg59DlaIHPg+b/Acg7hUllOktAsWXewops
         9nip4e7l4/ZBxKKkjk/K4YvfVJDV20gCuPVjPj43d4KNKeDCSszIuWHYBADOWtlLttI9
         Bwhkt1E824IG4IKtARg04c+g1SMb3Z7+VOiMASXSDT4U+HHxyZXtpqrMtLBBc1ufDqc9
         GmGo5SXm6hhiK206V5PDazEWLlFJLyT/3hQi52ZWVSX0pDkJwoxEVm7N4RW1+Zsy0kO1
         wZ92Nw4KDNnjB+ZV85mecr0kS3WFsUZ2T1owDmFdHZdkwjfZhXhr2702qxNItnZHLvDR
         39Hg==
X-Gm-Message-State: APjAAAWMBuk3K/W0A94nltfKhlvxlx/QY6wbJ+H09wABnuPo4TX0xPoi
	q7SAHlN79H5E0dxwzHJH89pcInlv8PkHT1qA75w=
X-Google-Smtp-Source: APXvYqylBnOlY6J5yphs6OUfcffeYpoUMccmhuKdcTOrwjC05s5MJ0bhS5H4FPPnPRXOHEgt796GjMyXraMpNUfDtLU=
X-Received: by 2002:a0d:e987:: with SMTP id s129mr5018878ywe.111.1572540422670;
 Thu, 31 Oct 2019 09:47:02 -0700 (PDT)
Date: Thu, 31 Oct 2019 09:46:27 -0700
In-Reply-To: <20191031164637.48901-1-samitolvanen@google.com>
Message-Id: <20191031164637.48901-8-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191031164637.48901-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v3 07/17] scs: add support for stack usage debugging
From: samitolvanen@google.com
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Implements CONFIG_DEBUG_STACK_USAGE for shadow stacks.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 kernel/scs.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/kernel/scs.c b/kernel/scs.c
index 7780fc4e29ac..67c43af627d1 100644
--- a/kernel/scs.c
+++ b/kernel/scs.c
@@ -167,6 +167,44 @@ int scs_prepare(struct task_struct *tsk, int node)
 	return 0;
 }
 
+#ifdef CONFIG_DEBUG_STACK_USAGE
+static inline unsigned long scs_used(struct task_struct *tsk)
+{
+	unsigned long *p = __scs_base(tsk);
+	unsigned long *end = scs_magic(tsk);
+	uintptr_t s = (uintptr_t)p;
+
+	while (p < end && *p)
+		p++;
+
+	return (uintptr_t)p - s;
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
+		pr_info("%s: highest shadow stack usage %lu bytes\n",
+			__func__, used);
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
 	return *scs_magic(tsk) != SCS_END_MAGIC;
@@ -181,6 +219,7 @@ void scs_release(struct task_struct *tsk)
 		return;
 
 	WARN_ON(scs_corrupted(tsk));
+	scs_check_usage(tsk);
 
 	scs_account(tsk, -1);
 	task_set_scs(tsk, NULL);
-- 
2.24.0.rc0.303.g954a862665-goog

