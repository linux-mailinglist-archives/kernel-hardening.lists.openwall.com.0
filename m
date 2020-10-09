Return-Path: <kernel-hardening-return-20141-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3081C288E66
	for <lists+kernel-hardening@lfdr.de>; Fri,  9 Oct 2020 18:16:00 +0200 (CEST)
Received: (qmail 3966 invoked by uid 550); 9 Oct 2020 16:14:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3891 invoked from network); 9 Oct 2020 16:14:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=ztcBj6t8pjAS3LbObumIb/+V5CA4S8dHRhfv01gqym4=;
        b=vT+mTaGZGDPhdzxTH6aWsWKYJ8GfvtcJ/2HmWU2LhgIWMy82u5Z6QUfhXUvwaPyTBj
         ES73XLSVdGK6yJ76Epy3GjQIuu9WyLmzmgisaAP3Br/g2bNFftKa67tkwVYJdFpgnTLf
         EbT2nqt10KbkCMX7GRODg17OseusSN0f7gvEjsLTRNZfEWxeWxVzSkIwO6sm5pXc51Jw
         hz9L988TU7gGwKEkJt8Od5T3abYFFfEPGiICNjg7HfdoFxOA6Qw889AWsZNyq+/ACi2x
         YRZ5xH0ksgTHHKwZarwPaQTpLf1iqNz7gepaEBsaJnbJqVzO+jDFi+LPsnIKf9PJdYql
         U+LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ztcBj6t8pjAS3LbObumIb/+V5CA4S8dHRhfv01gqym4=;
        b=rn6tBZeB1niZhMSHM+dYF7E2aYi6eTDmtqGjtRiiGkdoeWqD1IdP874aqgmm6yRpPg
         9lpg0yxRzFHhxcgH0hr4xcV3bVfT5Rmd3Mo6eSsfl9aoFacdyRnthmjztt023WcYOT+H
         E3czbB47TRVpPoXleGKNWlXIDiCHnTeDboD/wYnp4IaUUSUsVsjfRcRQ4g7lK/LLL9pv
         1oaNguES7qCSRzWCNHkI3hSwo6Aw6rO18Crpf5sjm4/CWkNlpx++FsrPEU2hVmzWYEmf
         ZeXzaXimCMV2DPepvTLQc/m17zC9Us6Qlrj2QnGD1enF1NOFvcStyfYz7ClFAcfx8J/W
         rEGQ==
X-Gm-Message-State: AOAM5333CzBSdAR0S4F8RGfBmU8L6ykEnQ8FRgRkbPQ/vMS4jOpSrF4x
	+jll9p/xuBAZi/NvGRS/3xplaGbOZsDnCZ1Q8WA=
X-Google-Smtp-Source: ABdhPJzWAYkCs8T5xws7qBavU2jEj9A1PqFK42w3Sy5EPVcUdSFBJQ+8vSfZo190tW1V6fLsej3xJUbGxSYiDIoBYjs=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a5b:cce:: with SMTP id
 e14mr18878394ybr.37.1602260041271; Fri, 09 Oct 2020 09:14:01 -0700 (PDT)
Date: Fri,  9 Oct 2020 09:13:19 -0700
In-Reply-To: <20201009161338.657380-1-samitolvanen@google.com>
Message-Id: <20201009161338.657380-11-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201009161338.657380-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.1011.ga647a8990f-goog
Subject: [PATCH v5 10/29] objtool: Split noinstr validation from --vmlinux
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, x86@kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

This change adds a --noinstr flag to objtool to allow us to specify
that we're processing vmlinux.o without also enabling noinstr
validation. This is needed to avoid false positives with LTO when we
run objtool on vmlinux.o without CONFIG_DEBUG_ENTRY.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 scripts/link-vmlinux.sh                 | 2 +-
 tools/objtool/builtin-check.c           | 3 ++-
 tools/objtool/check.c                   | 2 +-
 tools/objtool/include/objtool/builtin.h | 2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index 1a48ef525f46..5ace1dc43993 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -92,7 +92,7 @@ objtool_link()
 	local objtoolopt;
 
 	if [ -n "${CONFIG_VMLINUX_VALIDATION}" ]; then
-		objtoolopt="check --vmlinux"
+		objtoolopt="check --vmlinux --noinstr"
 		if [ -z "${CONFIG_FRAME_POINTER}" ]; then
 			objtoolopt="${objtoolopt} --no-fp"
 		fi
diff --git a/tools/objtool/builtin-check.c b/tools/objtool/builtin-check.c
index ff4d7f5c0e80..c3a85d8f6c5c 100644
--- a/tools/objtool/builtin-check.c
+++ b/tools/objtool/builtin-check.c
@@ -18,7 +18,7 @@
 #include <objtool/builtin.h>
 #include <objtool/objtool.h>
 
-bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats, validate_dup, vmlinux, mcount;
+bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats, validate_dup, vmlinux, mcount, noinstr;
 
 static const char * const check_usage[] = {
 	"objtool check [<options>] file.o",
@@ -34,6 +34,7 @@ const struct option check_options[] = {
 	OPT_BOOLEAN('a', "uaccess", &uaccess, "enable uaccess checking"),
 	OPT_BOOLEAN('s', "stats", &stats, "print statistics"),
 	OPT_BOOLEAN('d', "duplicate", &validate_dup, "duplicate validation for vmlinux.o"),
+	OPT_BOOLEAN('n', "noinstr", &noinstr, "noinstr validation for vmlinux.o"),
 	OPT_BOOLEAN('l', "vmlinux", &vmlinux, "vmlinux.o validation"),
 	OPT_BOOLEAN('M', "mcount", &mcount, "generate __mcount_loc"),
 	OPT_END(),
diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index 61dcd80feec5..0c05d58608b0 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -245,7 +245,7 @@ static void init_insn_state(struct insn_state *state, struct section *sec)
 	 * not correctly determine insn->call_dest->sec (external symbols do
 	 * not have a section).
 	 */
-	if (vmlinux && sec)
+	if (vmlinux && noinstr && sec)
 		state->noinstr = sec->noinstr;
 }
 
diff --git a/tools/objtool/include/objtool/builtin.h b/tools/objtool/include/objtool/builtin.h
index 94565a72b701..2502bb27de17 100644
--- a/tools/objtool/include/objtool/builtin.h
+++ b/tools/objtool/include/objtool/builtin.h
@@ -8,7 +8,7 @@
 #include <subcmd/parse-options.h>
 
 extern const struct option check_options[];
-extern bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats, validate_dup, vmlinux, mcount;
+extern bool no_fp, no_unreachable, retpoline, module, backtrace, uaccess, stats, validate_dup, vmlinux, mcount, noinstr;
 
 extern int cmd_check(int argc, const char **argv);
 extern int cmd_orc(int argc, const char **argv);
-- 
2.28.0.1011.ga647a8990f-goog

