Return-Path: <kernel-hardening-return-20418-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id AA7C02B878A
	for <lists+kernel-hardening@lfdr.de>; Wed, 18 Nov 2020 23:09:49 +0100 (CET)
Received: (qmail 5772 invoked by uid 550); 18 Nov 2020 22:08:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5683 invoked from network); 18 Nov 2020 22:08:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=4XuhSBro4JmbEzc1ahwEF0ocfPBDRGYBwGKNTvA6UGE=;
        b=sYNH5IySg/OAzl6C1030j5KrdvL/TknJ66ncYZZ0VJfRnkJWabJqF72HyVEtrFqsuV
         xHZDm78BMKoevfVrShC34UAWPm7inA3f5NPp/T5mwxJWNUaUEmUhisnupmkn6fu/2Gwc
         kjHvUXUV8ClEbbYTv/sJSHv6xAYf/ZgciW+HWWd1Obttcn34VOfLfUiaEuwE1mBQcIyI
         J7VEKckt5CvBwsRjuSRuQDHCbWNKrS0m4sNytF7pqSs/Xbr+4gRn0wdtIjpFJpzvj09z
         m7KNcyrQeKkKkgoq4NE1+LYU1VECryxaLniuQ5P+UABuyCF4PafQeFexbMmZ21dv9FUI
         l/PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4XuhSBro4JmbEzc1ahwEF0ocfPBDRGYBwGKNTvA6UGE=;
        b=scnGzxol7s8Y3PsSKGRDfeUpvVlN7paxtOI4S2pBdGBBNrj0uybKMohTC0JqNgodgI
         OSc2Q3/kerv18XihOuPxT86IxQJAdZ5T2Sr2dBm0fWLvdhUm926nwOkVFEr+unqRWm8s
         nFgYpzNe6+I4oJQfRumvOysmAdcP1hqvdw5WSD7oBwCRCsGhJnaH73c9aY3krC2arHdk
         sUSPAmribY0417pU5GjFUaKN76wbF6MwR0yKBwE0lRiJh5jv+GT5/OTNeZpZXy6TeBoU
         6LwjNvT/pRMzr3YkgUEPbhxRPMpeVLNOJTdANp2Y9X/mOzaLBv02qa7qdCeTFQjQTn97
         JfvA==
X-Gm-Message-State: AOAM530UGscwusXjPt3al8DaDijx1tXHm0iCr8T2IR578IyfiNx5S5pX
	1l6H6DvvqmccEWoOmsgiPa9WNJq32/G9BnBqfs0=
X-Google-Smtp-Source: ABdhPJz+m+xG4KrpgdWsllrU16+uPERUb2CyF3GRyM+22sZfjEXDruR1i7vglehue0hFGlNRVCYfCWncFBgvChpJLaQ=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a0c:e790:: with SMTP id
 x16mr7088555qvn.21.1605737280219; Wed, 18 Nov 2020 14:08:00 -0800 (PST)
Date: Wed, 18 Nov 2020 14:07:26 -0800
In-Reply-To: <20201118220731.925424-1-samitolvanen@google.com>
Message-Id: <20201118220731.925424-13-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201118220731.925424-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.454.gaff20da3a2-goog
Subject: [PATCH v7 12/17] efi/libstub: disable LTO
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
2.29.2.299.gdc1121823c-goog

