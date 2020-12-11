Return-Path: <kernel-hardening-return-20594-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id AEC562D7E77
	for <lists+kernel-hardening@lfdr.de>; Fri, 11 Dec 2020 19:48:43 +0100 (CET)
Received: (qmail 9575 invoked by uid 550); 11 Dec 2020 18:47:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9471 invoked from network); 11 Dec 2020 18:47:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=2x/zjVn7tqzzMwlgW94lOF/53GHge2qEfxVssZKSVKU=;
        b=sVh7pgdYPbhuziZ7RbVkNdr73qN77YcUUWXTQ1tAb3P7jqHRr2p1f5bPxlsX3TaJ0x
         NLRx4jH9CypSCESRGLRonyZ8+kkS3XNyERw+CW+BqWmKtawr0ILqseYbrw/qx5wrEH2B
         VqZ0x9qFDwfElGwb1vEdm1fnMLextKeSpBRqwLQXUche0e5kuofl1+h4UoBzhPS5Diu4
         EguLuAaf07YUp6KSWi5vK+lTKN+85JJaMCLDLqfd6UvMg+GduXve9RFsPVLp74nssXU5
         7G5z+jbgJYyIgkNTgNx96jpD1psInPt090dZnr/BEIQ4zT7bqAbfJUIq9iNE+/XzJIVu
         6Ing==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2x/zjVn7tqzzMwlgW94lOF/53GHge2qEfxVssZKSVKU=;
        b=YIuEG7+IIzOXVezqGck9sBkcL2PmvMb44qto1+8I8a+MIyWrtvuIZLlvizUj0WK4Mg
         Xemv9+NPoRJCtDWwFlYVgNezthizOhR/kGnUn/z+gUY6twqTRre2TA3YeyaS5GyoLES1
         UERNZMoN+pvGv1PI9kgZ8wIjId4NJRAW4+WZV4CbMmW3eM40QlfsSbgTDqitenSzLPSX
         ZYX72y0wWqAVOBFfz6tANBokrifMxAIYcNwBUCUZg9n6N9C5CY23SWW70fjVGmXNG8SH
         V/LzoGp306hGoZIjwg8nAgiwSgfhJnmxNH5j6bO582pp2ZmOsPpZJvxFWN9AX/qsCfJu
         apsw==
X-Gm-Message-State: AOAM531lx/uxidBl+vfXGRzEHLueEQ0Pz6+fWeDVrBLc+6b6hocnlOmJ
	UVEGElU7DxmTRxXOapQ3SzmPRmScc/NVMETgDuw=
X-Google-Smtp-Source: ABdhPJy6JuT0I8NnXRzTs2o4vn7H7iL4bg1V2c7l8tXurWBfldv/1YSed2IdWjWnqXB3B13fccdvqEaMosao7evXpYA=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a05:6214:a94:: with SMTP id
 ev20mr17352143qvb.56.1607712419531; Fri, 11 Dec 2020 10:46:59 -0800 (PST)
Date: Fri, 11 Dec 2020 10:46:29 -0800
In-Reply-To: <20201211184633.3213045-1-samitolvanen@google.com>
Message-Id: <20201211184633.3213045-13-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201211184633.3213045-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH v9 12/16] efi/libstub: disable LTO
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

With CONFIG_LTO_CLANG, we produce LLVM bitcode instead of ELF object
files. Since LTO is not really needed here and the Makefile assumes we
produce an object file, disable LTO for libstub.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 drivers/firmware/efi/libstub/Makefile | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
index 8a94388e38b3..c23466e05e60 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -38,6 +38,8 @@ KBUILD_CFLAGS			:= $(cflags-y) -Os -DDISABLE_BRANCH_PROFILING \
 
 # remove SCS flags from all objects in this directory
 KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
+# disable LTO
+KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_LTO), $(KBUILD_CFLAGS))
 
 GCOV_PROFILE			:= n
 # Sanitizer runtimes are unavailable and cannot be linked here.
-- 
2.29.2.576.ga3fc446d84-goog

