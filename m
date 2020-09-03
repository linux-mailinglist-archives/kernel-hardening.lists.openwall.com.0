Return-Path: <kernel-hardening-return-19725-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id DA38525CA73
	for <lists+kernel-hardening@lfdr.de>; Thu,  3 Sep 2020 22:32:10 +0200 (CEST)
Received: (qmail 19503 invoked by uid 550); 3 Sep 2020 20:31:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 18375 invoked from network); 3 Sep 2020 20:31:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=wK1JwNZBEF40N5fcic2drFAc7pvy5JBQESDnmBr5608=;
        b=b5tk49KKD8j0uO3HReOPELDX6rYUucGnG4IzHyDxn6fDckayxGEUatWRFd27ufwbN3
         LjHaKo6hawTTCLkFq/jB8M9122OZSHcLgzaa1kZ5TFxETy4pPx2LsDP8oo9eOYjDXBz7
         gNpyQkQIvkYvnL5+EjfoeJN95WFjivWmiIbSp2qvJ03cyGsJSq1lYlWvaFOZhIdNaq+5
         j6+vcEESIOZXWOu6Is/sHhbycCztGA5Mt6Pgiu+Wg6bUXf3c+poWdfZZ6+6srlaCIaFO
         pcBRWSF8ZbXrir1GVg/PkMsK2/dchsv3U7ph0bwwq2vz87O6fqdiQ1ehoBzkWoRkVWQL
         mL3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wK1JwNZBEF40N5fcic2drFAc7pvy5JBQESDnmBr5608=;
        b=un2ypuvjAkW4fPsP6OpG9aOUCwnWmMAdEEAV6Ot976T8H77l2luP2pb1YHdYm7Xd0G
         b/POGC5MIERtZLMK9v+fJ1WaYu8EQZPDeGPOnCux1UP5+nrhUTL6ceb9PWQdpI18DOIz
         AbsSs0QV7fxNnixtz9wvqwMHpaY3wzclRdnQKUWj39SgCeeOIWsvR2l32qys6YcmKnJB
         baXl5jGj+OSFoFJmDAlbvBGITgOa+7bz5vIbHgQMb3umsjrqpuveKARuMxz3RGVzJbCn
         1Tjo42ttK97+l3SQvDPzf5YsPrtJRjM2oiDScC7JbrhhmVLxt9OveuSmoOsztsbfp3Xc
         tW6A==
X-Gm-Message-State: AOAM532bCsPI14IpD7n+YhJl4zurjVVRi9wmp52QTcxb9HEL/wF2I077
	R1uo9xJn2izYCFWHwK+ST2cgRbKsNyaSEV6+xbQ=
X-Google-Smtp-Source: ABdhPJz4POZjDvj1G4FCKsXnFupG7AWZGi6zga2my5XWqYNc1MAqG6z13ElXHTlIUNSUYKf3wk2VH6yuqmwJK87vTpw=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a0c:f982:: with SMTP id
 t2mr3575617qvn.5.1599165067207; Thu, 03 Sep 2020 13:31:07 -0700 (PDT)
Date: Thu,  3 Sep 2020 13:30:31 -0700
In-Reply-To: <20200903203053.3411268-1-samitolvanen@google.com>
Message-Id: <20200903203053.3411268-7-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com> <20200903203053.3411268-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH v2 06/28] objtool: Don't autodetect vmlinux.o
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

With LTO, we run objtool on vmlinux.o, but don't want noinstr
validation. This change requires --vmlinux to be passed to objtool
explicitly.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 scripts/link-vmlinux.sh       |  2 +-
 tools/objtool/builtin-check.c | 10 +---------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index e6e2d9e5ff48..372c3719f94c 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -64,7 +64,7 @@ objtool_link()
 	local objtoolopt;
 
 	if [ -n "${CONFIG_VMLINUX_VALIDATION}" ]; then
-		objtoolopt="check"
+		objtoolopt="check --vmlinux"
 		if [ -z "${CONFIG_FRAME_POINTER}" ]; then
 			objtoolopt="${objtoolopt} --no-fp"
 		fi
diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index 71595cf4946d..eaa06eb18690 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -41,18 +41,10 @@ const struct option check_options[] = {
 
 int cmd_check(int argc, const char **argv)
 {
-	const char *objname, *s;
-
 	argc = parse_options(argc, argv, check_options, check_usage, 0);
 
 	if (argc != 1)
 		usage_with_options(check_usage, check_options);
 
-	objname = argv[0];
-
-	s = strstr(objname, "vmlinux.o");
-	if (s && !s[9])
-		vmlinux = true;
-
-	return check(objname, false);
+	return check(argv[0], false);
 }
-- 
2.28.0.402.g5ffc5be6b7-goog

