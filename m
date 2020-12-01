Return-Path: <kernel-hardening-return-20494-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 82F612CAEA3
	for <lists+kernel-hardening@lfdr.de>; Tue,  1 Dec 2020 22:38:19 +0100 (CET)
Received: (qmail 16028 invoked by uid 550); 1 Dec 2020 21:37:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15953 invoked from network); 1 Dec 2020 21:37:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Ioq5snZDZDriQbZnteUYOvtfB50kdQ3NzmE0Bt/uZj4=;
        b=cTOyof8D27Eb15ctHFkguMw8fQJTDxevhAv86xzy/JyHIKohwC9kcPozSDGX4ZvhjH
         hv1rR4G53Z3ln+Cmqb9RjUK77Rma8WI1knxtAcMzXLo7jpqZX03s3IjAuAKcPGe698IA
         tqCRwqNReUE6+2DHbVXsqGEAH3DKihfcNiemIM2g7zH4vjz4yRgdtjEGOxPucEoKGI7o
         TP0NKml15Zj0kVGxkNppCMBBYfw5RCgEPqWu/IFdSOVZwRHRqv5Cob9LcnhewWjKXfLJ
         uxIRAby/D2ArEQUd3zLg1F9Be0crsc+S/9EwAcR/g6vVudxNV4zhBdGhHukse6etLm6r
         ljAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Ioq5snZDZDriQbZnteUYOvtfB50kdQ3NzmE0Bt/uZj4=;
        b=Dg8zcllXc2K4dVxJqSFXZkTf15YoOqr76SnzB9ZTwkKjHAViIwHvtWtVwAJeExPBL1
         M46jU77f0na7q2voFE+BCQK2CfKU5+sZM0WyseaeB8+CWXL1MLZ49DYuySPwelqwY+Z5
         3EMgIPlqHIVkbj2ifjPeN5ljUSgFIXNWp1iXQv5l0iHWmb7DjMCYQmFdwABvteT5g7CH
         F7edkzUDtlLHAdpoE873JZORIL8XkZ5h9j1gNtUq597AxGftD16oFZgccctzD9XGI2BU
         tY22IchECbKay3gIym4y5PwX0m0DWO1Onilzc+AwNCdQ2rev3tNDgmWmX+z2NhcTJpwI
         qgLg==
X-Gm-Message-State: AOAM5313LfrQfZnVQA7A2qZs68FbGjYm+DUJIz65X1ESE9eXRH7UbqDi
	XvLoCgJUHNAevBcSbhKIIBy0TVxCyORbiBKRfEo=
X-Google-Smtp-Source: ABdhPJys1KC5O8D1Yq/SB6UjKKBqwmwFlcdQVBXthpLtwbdm6607CxLE6p9eN4XkDXwUu6B0iPn5A0SVU7zu7mNfSPU=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:4051:: with SMTP id
 r17mr5301753qvp.39.1606858644813; Tue, 01 Dec 2020 13:37:24 -0800 (PST)
Date: Tue,  1 Dec 2020 13:36:57 -0800
In-Reply-To: <20201201213707.541432-1-samitolvanen@google.com>
Message-Id: <20201201213707.541432-7-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH v8 06/16] kbuild: lto: remove duplicate dependencies from .mod files
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Will Deacon <will@kernel.org>
Cc: Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-pci@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

With LTO, llvm-nm prints out symbols for each archive member
separately, which results in a lot of duplicate dependencies in the
.mod file when CONFIG_TRIM_UNUSED_SYMS is enabled. When a module
consists of several compilation units, the output can exceed the
default xargs command size limit and split the dependency list to
multiple lines, which results in used symbols getting trimmed.

This change removes duplicate dependencies, which will reduce the
probability of this happening and makes .mod files smaller and
easier to read.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 scripts/Makefile.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index eae2f5386a03..f80ada58271d 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -281,7 +281,7 @@ endef
 
 # List module undefined symbols (or empty line if not enabled)
 ifdef CONFIG_TRIM_UNUSED_KSYMS
-cmd_undef_syms = $(NM) $< | sed -n 's/^  *U //p' | xargs echo
+cmd_undef_syms = $(NM) $< | sed -n 's/^  *U //p' | sort -u | xargs echo
 else
 cmd_undef_syms = echo
 endif
-- 
2.29.2.576.ga3fc446d84-goog

