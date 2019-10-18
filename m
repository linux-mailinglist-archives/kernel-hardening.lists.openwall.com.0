Return-Path: <kernel-hardening-return-17028-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E963EDCAAD
	for <lists+kernel-hardening@lfdr.de>; Fri, 18 Oct 2019 18:15:03 +0200 (CEST)
Received: (qmail 18385 invoked by uid 550); 18 Oct 2019 16:14:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 9956 invoked from network); 18 Oct 2019 16:11:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=+oBtFp6IQZ5946CFExp5BXllfwypP5AUtOYhvu+6eDg=;
        b=uErhWC3lFP8THQ9YjycpXkAl85COCd6lh+RqxQAfdCNUSVTiEfspc2alvbCgArV2fu
         ls4p2vGwJ3M8+8dC+pxUbBcocxnmbIOx1oZI7haycpR/idqzr0yRfNB9QU0r3L0Ad+LB
         AODIdu+bBRBco2jvuX999sV5JPTfKSeK6DQgqagm1V48qwgIQ9QQo3kPVBNgSxrwUzDc
         J7z1g1ZIddJjuwZ9NXT+KTuZuEnEru2YIfSdVRPO6N1MNFiWgJDAJs9A6AicwQY5z5mf
         Ozj1xQ9RCTG/l6zakh/4DEHsBfg5zP3zC8lFWduaZXJzlKOfJV8siLAxWkKPzGoNNYpY
         BIXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=+oBtFp6IQZ5946CFExp5BXllfwypP5AUtOYhvu+6eDg=;
        b=XoRABYusdRVQESPC/oOLNKmM7b15trDvk7bxhsgcBCsrnC7/VSnOKFUeQ7Lk1eEy9+
         E9K5g0HU+tWwDJy2nqpn4rKZpQAep/UOqy/CgsjCzezAb13wKW+ym4mJAzlKPqUJ/02y
         DVNw2Paklh8j/PPmcmh2iSnonUgwgtb7RLcMdOxxVaIs3koO1Veb3cq373DO+ux6HcJg
         3fMnCLr+7QeO6ynZ03Uog5OtLkhsMjE+DUdsS3n5Lbig+VF7tWWnJPpacnNh1Rv5c0t9
         zdAqlUVP44edNU5oCt4Z9zSRtG1hhn3QlI3IJl1iwUNqMZ2otckED2O/WLOzZe4PPHPk
         pTpg==
X-Gm-Message-State: APjAAAUVJ7fSbpGXA7++sJXokV644XkOU/Kh4DvgNzP4p7uqYTbIeHqN
	x9c4B9QqILxRlv8GVLoGM8RLTsL+5RRXGPvto5M=
X-Google-Smtp-Source: APXvYqxHqmmpD11MJRO6yuoyBvltYKFWJkQq7UxJVT4qvc6swUR9mDIPTvziXaDvcDGhe+mECq8Qr7PX0sGP/3daZE0=
X-Received: by 2002:a63:7845:: with SMTP id t66mr10836733pgc.31.1571415070584;
 Fri, 18 Oct 2019 09:11:10 -0700 (PDT)
Date: Fri, 18 Oct 2019 09:10:23 -0700
In-Reply-To: <20191018161033.261971-1-samitolvanen@google.com>
Message-Id: <20191018161033.261971-9-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH 08/18] scs: add support for stack usage debugging
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Implements CONFIG_DEBUG_STACK_USAGE for shadow stacks.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 kernel/scs.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/kernel/scs.c b/kernel/scs.c
index 0e3cba49ea1a..1ec5c5a8dfae 100644
--- a/kernel/scs.c
+++ b/kernel/scs.c
@@ -161,6 +161,44 @@ int scs_prepare(struct task_struct *tsk, int node)
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
@@ -175,6 +213,7 @@ void scs_release(struct task_struct *tsk)
 		return;
 
 	WARN_ON(scs_corrupted(tsk));
+	scs_check_usage(tsk);
 
 	scs_account(tsk, -1);
 	scs_task_init(tsk);
-- 
2.23.0.866.gb869b98d4c-goog

