Return-Path: <kernel-hardening-return-19923-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E890427066C
	for <lists+kernel-hardening@lfdr.de>; Fri, 18 Sep 2020 22:15:59 +0200 (CEST)
Received: (qmail 15749 invoked by uid 550); 18 Sep 2020 20:15:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15641 invoked from network); 18 Sep 2020 20:15:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=TOBnIZLn7hTmqm3x2JBReVnrcc+31akc4aFm1uMW9E4=;
        b=kOFoCTd2FrUUKnCgnEw8fv7o1qa+wmfRKSJE7DESuzOriLdT6KRMVuJelBjZTPWmjv
         hcDMZ6eRTe3iEYXYYraJYirqopgmczBB1BvP5hOrngWEf/fJbpBz7Sj2ruTbsoRETl29
         O7E7brX0kO22gIX86Vdn9SrCa3mebEscFAw0lojJhTqtnAkLGvP02ofXmERBjubIHHQK
         t7UD4ZZSX0u9/8uvxMAjisPSz3BRkcsoaicvmVdgo3PttZXSpnN03wSqMqeZkfmkBk2J
         sEFprVm9QM8nc23vRgjZ+UPh4svXmTbLma/ZToJN6dcDACCd3xjRpcEHrZhhhibZCAUO
         2qfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=TOBnIZLn7hTmqm3x2JBReVnrcc+31akc4aFm1uMW9E4=;
        b=Tt0mfTzpxj3R9r7ciAYF0W8+qQDmnNJU6mRZZ3v4n0ljpGtlOb8wCowvA6MQBYucg2
         EXYDSeYKgT8b8xARDNP6cuc0bANpu9QZU6O2sl5dBCftFY2sNXoxXDiqvuPaHQ7kyjGy
         uJqtXqHILVNVmRqlXJWN9OSy9mVkoZ9QeNoUpK2BZycM7xoCBo3KBeNtZRNrblyZdnoL
         i8zr212E+rYUPZzsBYdGAFeNsvHKPBZ/w+9CChLQ1CcJqj/PUp2FZcU69y2Qv3bSFJFm
         h8ShdxcH1mTdjVdBxiDTuicb1+97xn2zh/ngQzcO7pChWswAxRwe/ZFrGVmLGAlIkY8Y
         SUZQ==
X-Gm-Message-State: AOAM530nwi9k1znYC5Y3FrpvQKgY67YmU+f7Q9Bk2OgHi4T5VTgGWWP6
	7KR/EQghKgK+53VxdSnt1rInwyBtcPNk0U2zWZs=
X-Google-Smtp-Source: ABdhPJwPfv5GKIky8nZ4/qO1HfgSl+GRdDXQT/EDjzvo193fwzx6dbwv1k7QAc3pOuPuB6s1Frhn6PBXdOnzsCVgbLU=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:be13:: with SMTP id
 h19mr55802534ybk.50.1600460094899; Fri, 18 Sep 2020 13:14:54 -0700 (PDT)
Date: Fri, 18 Sep 2020 13:14:13 -0700
In-Reply-To: <20200918201436.2932360-1-samitolvanen@google.com>
Message-Id: <20200918201436.2932360-8-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200918201436.2932360-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH v3 07/30] objtool: Don't autodetect vmlinux.o
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
Reviewed-by: Kees Cook <keescook@chromium.org>
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
2.28.0.681.g6f77f65b4e-goog

