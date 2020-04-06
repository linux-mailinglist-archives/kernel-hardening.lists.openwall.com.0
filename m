Return-Path: <kernel-hardening-return-18442-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8044019FA8B
	for <lists+kernel-hardening@lfdr.de>; Mon,  6 Apr 2020 18:44:03 +0200 (CEST)
Received: (qmail 29760 invoked by uid 550); 6 Apr 2020 16:42:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 29703 invoked from network); 6 Apr 2020 16:42:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=Y7rlrv2nhrkBeB3yxrt1isCdPASfC8dC7N7qsaqIYpI=;
        b=uzysDj83wFfvyx5+xHx53APFuGywhQGNYTYnY3+lbcNA+3qpT2RyVCtTCzOVWuYtrd
         IJ7VKcld7TMSS+B4Duop178kHp3dnyyCbFCaQG30nNlIZu2qp3pd8gPvWCQ/vh5UCVNI
         qYZP5lzEpIK9s82LrNfMVTyGg0YHy+wtBcdXCYONK5VtuSr/B+ie2tXtTLyaJ9IPy1+g
         3D+xo+ACBtd8mKECNNqIvX1PJ+oInNfLa3VP4gJ7IaAStMJAKw0/1v2sPcOcrSw5vqh7
         xI4vpzaPpkYp+bSxRgABVKY3EorsZQeCB4tyb7kBdLZS86i8LGqxeDzzj01uFZHbP3SR
         Lm4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Y7rlrv2nhrkBeB3yxrt1isCdPASfC8dC7N7qsaqIYpI=;
        b=hwBgqKQga9qZHG0aMRjrYwuW/kLjUwHx4LFItdZHflf70GDyhX2yflFMlu9ykM0X3C
         4BaTVEfw1he32P+pZNghH6nciPyrLv7vcM4/oQpEEXviv/2Elm/zupr2lwniVZo3ZF3b
         9U9u0jJ6GmJ4PkYDuBcrKy1aOZrqN2QtKyBFMCws4dkhuSvwuSOXdoYZ+Qk4mADdkyvY
         kdqSo/+gX5FgS79srOrdEE/vR8/QkO4LkouAwDJxrmBznUeTCeiPGjPJ9u6Y3AAZuI88
         6SawrO0XBCfG8iIkTITZkrnIWGSrSqPycy3gqztMrYcA03sxJmKno4JKRg1tX+S41zWc
         8UFg==
X-Gm-Message-State: AGi0PuYf7uZRRzCsf95wSBWEPMXA8TFntqgOEq0WwQrGqY3k+hL2YKxn
	MdNjyfnZUDI/5YvLs3RhzAEqoVJWFGZ5fG1gWjk=
X-Google-Smtp-Source: APiQypIq6K+/6sNFF07UPysJVLbTskXzuAKdx/I5NBmymQNj01YODUpkepZADD3StGdWVd8jEygPyA4Kk1CGRFm+W3w=
X-Received: by 2002:a37:4d88:: with SMTP id a130mr21585753qkb.443.1586191332817;
 Mon, 06 Apr 2020 09:42:12 -0700 (PDT)
Date: Mon,  6 Apr 2020 09:41:21 -0700
In-Reply-To: <20200406164121.154322-1-samitolvanen@google.com>
Message-Id: <20200406164121.154322-13-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200406164121.154322-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.0.292.g33ef6b2f38-goog
Subject: [PATCH v10 12/12] efi/libstub: disable SCS
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	James Morse <james.morse@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Mark Rutland <mark.rutland@arm.com>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Shadow stacks are not available in the EFI stub, filter out SCS flags.

Suggested-by: James Morse <james.morse@arm.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 drivers/firmware/efi/libstub/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 094eabdecfe6..fa0bb64f93d6 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -32,6 +32,9 @@ KBUILD_CFLAGS			:= $(cflags-y) -DDISABLE_BRANCH_PROFILING \
 				   $(call cc-option,-fno-stack-protector) \
 				   -D__DISABLE_EXPORTS
 
+#  remove SCS flags from all objects in this directory
+KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
+
 GCOV_PROFILE			:= n
 KASAN_SANITIZE			:= n
 UBSAN_SANITIZE			:= n
-- 
2.26.0.292.g33ef6b2f38-goog

