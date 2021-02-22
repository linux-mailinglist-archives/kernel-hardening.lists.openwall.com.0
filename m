Return-Path: <kernel-hardening-return-20786-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6D6CB321AEA
	for <lists+kernel-hardening@lfdr.de>; Mon, 22 Feb 2021 16:14:27 +0100 (CET)
Received: (qmail 23595 invoked by uid 550); 22 Feb 2021 15:13:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22450 invoked from network); 22 Feb 2021 15:13:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LLkuX0+ITGWZ/iVnAzMULSxwtPPckweuLMISePt9ssw=;
        b=BPykAZVvUp4icbQV3I8OKq3dgj9xE7I0bXvTLRa+lLFvT2T9S46GpK5rzpalk0vka7
         EMAebBc4xNncmRW0iYtFoKILmLT9xpNRKjXNkKgGb+RdrBDYrM86Ih0zaynkmOTCb5LP
         NaKo4wGex24T0J5JuUZcwofRPEBZMW4HusebFD6CYD7Muei1Q9Ep+FX3tFJoNNyi6fQ4
         vE8B0dAximKDBpReNOj1/mEWaFJRZGAdbJ6d3RmzX4lwPElZ4tQbzdIkzl+VgYesDdXm
         1qtG97aM1OEtTOrV6g9qGUbFcX4kZio/WjmW8dJAY8W54ikoDB+MgxYkLUCWt2nF9F/v
         xpkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LLkuX0+ITGWZ/iVnAzMULSxwtPPckweuLMISePt9ssw=;
        b=LdPNVkEL2hZuPqWYjUmpis3fO+TDt4MYmoMcKsrjPN6wrxbs+KwsBYkzTJp/QV19rN
         8ugG4BzaHGSrIAoSFU269N7xJptJNsMB48Pkaswuzv56cuD29PZTK3/UMz8eiiTEIgTI
         ZYI2F7TS0Tr6kIB9BBjZB3NsknO59oCE+E9K+Dnu/dAFtQ0PBqxMfMkNygyIvGTrE9g9
         BsNQfTh5zYlMvmYNe8KgUilEbaog51+o1bNrasbC6VWAysgaOEvJSBL4rP1rZFVgWF4L
         ifNT7XLS4pE9JSYFITvHqMGlwIONT3MxoWVUJJc2+mCyxKuvQulnlydcrAKp+qBd/dN2
         c1Gg==
X-Gm-Message-State: AOAM532AkKck16+WpI1KAxYSX6My1THGgyG9t1ywM4MhWsbSQTO5qbSg
	T1QfPa5rwjCbLoaS6HplrL8=
X-Google-Smtp-Source: ABdhPJxc30UcYQVY9SrjO7shc//rXjLfBfc8tuVxMSyonaZSmDzTDDA/bQLZBQpXRC/u5O+PvGH7Xw==
X-Received: by 2002:a1c:2094:: with SMTP id g142mr20921780wmg.101.1614006769655;
        Mon, 22 Feb 2021 07:12:49 -0800 (PST)
From: Romain Perier <romain.perier@gmail.com>
To: Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com,
	Mimi Zohar <zohar@linux.ibm.com>,
	Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Romain Perier <romain.perier@gmail.com>,
	linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 06/20] ima: Manual replacement of the deprecated strlcpy() with return values
Date: Mon, 22 Feb 2021 16:12:17 +0100
Message-Id: <20210222151231.22572-7-romain.perier@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210222151231.22572-1-romain.perier@gmail.com>
References: <20210222151231.22572-1-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The strlcpy() reads the entire source buffer first, it is dangerous if
the source buffer lenght is unbounded or possibility non NULL-terminated.
It can lead to linear read overflows, crashes, etc...

As recommended in the deprecated interfaces [1], it should be replaced
by strscpy.

This commit replaces all calls to strlcpy that handle the return values
by the corresponding strscpy calls with new handling of the return
values (as it is quite different between the two functions).

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy

Signed-off-by: Romain Perier <romain.perier@gmail.com>
---
 security/integrity/ima/ima_policy.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 9b45d064a87d..1a905b8b064f 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -790,8 +790,14 @@ static int __init ima_init_arch_policy(void)
 	for (rules = arch_rules, i = 0; *rules != NULL; rules++) {
 		char rule[255];
 		int result;
+		ssize_t len;
 
-		result = strlcpy(rule, *rules, sizeof(rule));
+		len = strscpy(rule, *rules, sizeof(rule));
+		if (len == -E2BIG) {
+			pr_warn("Internal copy of architecture policy rule '%s' "
+				"failed. Skipping.\n", *rules);
+			continue;
+		}
 
 		INIT_LIST_HEAD(&arch_policy_entry[i].list);
 		result = ima_parse_rule(rule, &arch_policy_entry[i]);

