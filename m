Return-Path: <kernel-hardening-return-20502-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0192C2CAEAC
	for <lists+kernel-hardening@lfdr.de>; Tue,  1 Dec 2020 22:39:34 +0100 (CET)
Received: (qmail 20072 invoked by uid 550); 1 Dec 2020 21:37:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19997 invoked from network); 1 Dec 2020 21:37:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=D9wH7plBpsyKB7z0MJo6lESfcO9at50jK7OVp+0NdAo=;
        b=ty5f8H7kzpU+lvDsHXGI++1V0wurJB7DQJHEXEwufmtrCxIRoiPJOPP1X/3lLsz1Jb
         yjTR/AGDyQQn3kRjvvw2d88GiqDY8VcvMWomB5DuCrtNFFxHuktvMeKvMrFz+Xfk1Q77
         MRmeM7k7VctuQepKTW4pproEuOE+zIwcrFORj2gPW2IlyOU7IhN8JpWoK+mpfeUx5C/d
         ojaTkHbYjh10G7mgJCJekN588v9SPU5sVPQSTu4fzbRdcVzLgMGzXyAyI0u1gJhvAtr+
         L9s0tFmZLbeuu51bgQUHw9Ysitz1s+n7ja3zUrLOpDRRdxizWkaeqCKUaIf410z146BI
         /CXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=D9wH7plBpsyKB7z0MJo6lESfcO9at50jK7OVp+0NdAo=;
        b=CalhbjHn+wTZd0Xt1j15E2Dric/obIr/GBvddW2wZ+iBjpaBQoc6KJzm6LK5R93GI5
         5GC5TM67xb79pWTTgrP3S3L9gl1fdhuglHPs0km23uv3yk4vNCFGRX8geu1b9CgT0AaI
         4bHrU94jMVS6lEw7t4vfx2nn6g49nB2CINtGPMtD5LnGJk05MlF4I/qBt2UOyoK+Zru+
         aAkBTP8rwF083ssMvKzjuGXoL1uYISkVoKKtgJIpJNyCkd091wmM/2B6it5Pcu8vtP+P
         CadkXiI/Vk/A2sp7M6a+7d5aou5FqmVougHOA8FbXE1KpCXbU28DHsnelS8WeSJve+/j
         /vBA==
X-Gm-Message-State: AOAM532I6h37GrXufT2g/6DmjMeyuBeuOxvj+ReRRd4Lb9p521ctbm/B
	7SSsfzZ6cICRLHc65lMR5Hy58Z7PwmoXXUwxp6g=
X-Google-Smtp-Source: ABdhPJz0uxxT0ZlEK90fhImd7lL6Fuzds0C69/eAFTomtuQ0mN0EZEi1KhWi4R7wk6mCpdkDbecP4SoP9hzTb5uJL7A=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:ad4:4d84:: with SMTP id
 cv4mr5421264qvb.14.1606858664762; Tue, 01 Dec 2020 13:37:44 -0800 (PST)
Date: Tue,  1 Dec 2020 13:37:05 -0800
In-Reply-To: <20201201213707.541432-1-samitolvanen@google.com>
Message-Id: <20201201213707.541432-15-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH v8 14/16] arm64: vdso: disable LTO
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
point in using link-time optimization for the small amount of C code.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Will Deacon <will@kernel.org>
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
2.29.2.576.ga3fc446d84-goog

