Return-Path: <kernel-hardening-return-20420-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 192682B878D
	for <lists+kernel-hardening@lfdr.de>; Wed, 18 Nov 2020 23:10:11 +0100 (CET)
Received: (qmail 7326 invoked by uid 550); 18 Nov 2020 22:08:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7214 invoked from network); 18 Nov 2020 22:08:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=sjtbZ3xOlxTCeGDsc49y7blbydcHA97ATmZyW4gNXi8=;
        b=bQOrgmvmWPVazHRiU7Sq4QuzywMs/XRdYpwqWAsr3kHc03SbDyK5DTQWLtd8FK91y3
         MW3u4WbsCuRU0vzooO+H4s9QpGHpW389VzEmQRcj4VcXdnUgwjt45eFo8ZBzXnE4fKeD
         r0bhLti12UpA9An41fbHwFUR8/vhwYOYVyPxJIh/IPwza3kbBFdHqpR6/KeizFCtTGWX
         6/8rBV+yRiy2gN2o7bFZ9jXivGRW7HEGEIIsWwtKVPHuDHa6XLj84LP/w+Xd2MEQ2bks
         50uwuy6B0tkC4/TW0Wy9OY8x1oFS6B2Qj3ExbMLuC+o5odwx/ZCNGDq1GT0ZZq/1Fcim
         a9Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=sjtbZ3xOlxTCeGDsc49y7blbydcHA97ATmZyW4gNXi8=;
        b=jyoU00v3ZKUfmT6vBZqUSMGrE4klz8dAfhMQPXcl/nyAYMHz4IipS+AK1KdfSkAXZy
         MtObhdCx87kUb7f/QKTte67r4zoQfngYZks6D03VWQKMzz3eIlUD3+SU+cqwJLTyS5WV
         Xpopy1Vo25MqLkNxyzgNeiKUNJcYRLoY1Ij9tjEsmLeDrtfklbKF5VLV99EajRos1/tX
         hd8Wj0wlmd65omXq9PEdFp+HQg7Y+HJyeuqHnFcLdAzlN3ptxg+pB9SvUZb0ylCp6hC+
         Hycbe6mxEXHVpi4Px5PPFm2xXUwQfI1bI3k+Mp0gTNCrC316hurbHusadQLmLpN0tRN1
         izuQ==
X-Gm-Message-State: AOAM531TpWkntlaIwBHrRCsaZWGO1bfN0KaSNd9vYM7Ci8suy4zHugcv
	Zxtr3E7NjuXbnpA8DRwV/xTtVzVeQn1RAjQ8zDw=
X-Google-Smtp-Source: ABdhPJwxDtudTv+lhKifrPzdR3GIyaaL24pwI7bpI9IrG2vb633hmg0Jt18S95SjawSbFeAc/hQylLYmz77E0BMzIoQ=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a05:6214:c8e:: with SMTP id
 r14mr7292366qvr.21.1605737285331; Wed, 18 Nov 2020 14:08:05 -0800 (PST)
Date: Wed, 18 Nov 2020 14:07:28 -0800
In-Reply-To: <20201118220731.925424-1-samitolvanen@google.com>
Message-Id: <20201118220731.925424-15-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201118220731.925424-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH v7 14/17] arm64: vdso: disable LTO
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

Disable LTO for the vDSO by filtering out CC_FLAGS_LTO, as there's no
point in using link-time optimization for the small about of C code.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/arm64/kernel/vdso/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
index d65f52264aba..50fe49fb4d95 100644
--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -30,7 +30,8 @@ ldflags-y := -shared -nostdlib -soname=linux-vdso.so.1 --hash-style=sysv	\
 ccflags-y := -fno-common -fno-builtin -fno-stack-protector -ffixed-x18
 ccflags-y += -DDISABLE_BRANCH_PROFILING
 
-CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os $(CC_FLAGS_SCS) $(GCC_PLUGINS_CFLAGS)
+CFLAGS_REMOVE_vgettimeofday.o = $(CC_FLAGS_FTRACE) -Os $(CC_FLAGS_SCS) $(GCC_PLUGINS_CFLAGS) \
+				$(CC_FLAGS_LTO)
 KASAN_SANITIZE			:= n
 UBSAN_SANITIZE			:= n
 OBJECT_FILES_NON_STANDARD	:= y
-- 
2.29.2.299.gdc1121823c-goog

