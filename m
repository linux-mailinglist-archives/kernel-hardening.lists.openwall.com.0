Return-Path: <kernel-hardening-return-19743-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7048125CAE3
	for <lists+kernel-hardening@lfdr.de>; Thu,  3 Sep 2020 22:36:21 +0200 (CEST)
Received: (qmail 26373 invoked by uid 550); 3 Sep 2020 20:31:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26278 invoked from network); 3 Sep 2020 20:31:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=2NV0P0BZEhFeVXK5NU1s/CPB7b09hharJKRKaO0KUAA=;
        b=iQC3MXcnnX2MJeVDml9r32koVHGM9fCnhlqFyGQpI4kg6N+GAVi3eGpcReIyaQtftv
         +8hQOVada7+yAvDv+aDU/EX2lefZWBlI9dX0gvIJ8Kui/Wbd4nfao83zED/RIwUOKlUV
         gA5DFOuDkiclAAdzZ1/RROkyKMSuawdisMFROE1LrIYELe2IjMVIt9K4CTCeZdrJwu4h
         7qDCOjod/u5pLmt4qqLI/ZOb622Ix0toxovXCmz8FD3st43YIbEjbKdrQpK4ZVWgCZs1
         02Yx3hYWMaTbxLOVDZUON1042qKsUxlBQ0eLPqPtOoYsRyCMeWYMt5KLAQ1gBbndPuHD
         TPKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2NV0P0BZEhFeVXK5NU1s/CPB7b09hharJKRKaO0KUAA=;
        b=KkqcAhln5tBsnCrGW+GH5IeYO9gmx4W3AXlIKWUGpqETYUMjga9R3gG7OTXBVxq4f7
         pYyI9/49agK873lpXFcuE4TatUcJuz5rTTVi27Fe7qGr/0K/lmRT9vEjxbc7f+AeSI2P
         YFAj005Cv+wdi0+raNouplVwLvtW1+j6OOw7zcvv2qZKxJfjh4t6qB15y7Zp8A7b2fZM
         aIt8bavrid13ckLzZtV5gTyvYS+PmPXbL1Sgm24LI2ncXaZO/BUgWfKMzc9mJKArbtT1
         MRktuNyH6+Ko18qJsQ5uNN8QVVWKvaLd0aol8C/Pd28wzYK8WOgEb83fiGjTK91QDYze
         HEig==
X-Gm-Message-State: AOAM531Gt9/HxELWt/xVTly4gee5zwDGJLcnA5HvHZ2Ws5qdvUfQaXhP
	MP+uZeC0id29jMycU0qYfdpqkDXMMAbYWDtOxcU=
X-Google-Smtp-Source: ABdhPJxXEiK8iQgluE8U1P9eVcF55qIItGQI+hRRjVeMXkeZ98njIjZMcmdWbshQtzwoU58/viNSLC1erEh/riMVVr4=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a62:e107:0:b029:13c:1611:658b with
 SMTP id q7-20020a62e1070000b029013c1611658bmr3713577pfh.8.1599165105298; Thu,
 03 Sep 2020 13:31:45 -0700 (PDT)
Date: Thu,  3 Sep 2020 13:30:49 -0700
In-Reply-To: <20200903203053.3411268-1-samitolvanen@google.com>
Message-Id: <20200903203053.3411268-25-samitolvanen@google.com>
Mime-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com> <20200903203053.3411268-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH v2 24/28] KVM: arm64: disable LTO for the nVHE directory
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

We use objcopy to manipulate ELF binaries for the nvhe code,
which fails with LTO as the compiler produces LLVM bitcode
instead. Disable LTO for this code to allow objcopy to be used.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/kvm/hyp/nvhe/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index aef76487edc2..c903c8f31280 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -45,9 +45,9 @@ quiet_cmd_hypcopy = HYPCOPY $@
 		   --rename-section=.text=.hyp.text			\
 		   $< $@
 
-# Remove ftrace and Shadow Call Stack CFLAGS.
+# Remove ftrace, LTO, and Shadow Call Stack CFLAGS.
 # This is equivalent to the 'notrace' and '__noscs' annotations.
-KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
+KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_FTRACE) $(CC_FLAGS_LTO) $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
 
 # KVM nVHE code is run at a different exception code with a different map, so
 # compiler instrumentation that inserts callbacks or checks into the code may
-- 
2.28.0.402.g5ffc5be6b7-goog

