Return-Path: <kernel-hardening-return-20500-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C06F22CAEAA
	for <lists+kernel-hardening@lfdr.de>; Tue,  1 Dec 2020 22:39:15 +0100 (CET)
Received: (qmail 19600 invoked by uid 550); 1 Dec 2020 21:37:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19522 invoked from network); 1 Dec 2020 21:37:52 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=2x/zjVn7tqzzMwlgW94lOF/53GHge2qEfxVssZKSVKU=;
        b=N2hjZ+w1m+tzNKULGFriHMyI0W/WLxUEDGY1DnBMXxPtD5xhjPfovZ1l0CpNo2iRQO
         +tTomPyUoponyE1362CelbbrDZwWrvZ66ad2D/JxuGm1GX6gaUseX8hQbfi3OUGkhp0H
         9SmgV/+6Q7Bt3K0LuNqv/RrzRFY59diqYwZBhEZG9fnh7VFPaEUCT6hXis0JB7dm8/Jq
         tWSPkyod8RuoKjamef9WjpoKLdp1BdmoMZ4kk/XBfD1LF2w8eoyA6CMmckQwNxU7jj5H
         YD9zFativ+Sd8bT4A5VYcPCPPXLEbmnubfljTsMu/1a5ZsRn5Qy9mkUKuq9Y0tLJtllx
         jchQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=2x/zjVn7tqzzMwlgW94lOF/53GHge2qEfxVssZKSVKU=;
        b=mjAXHba7cjCpCIzWrlSPEuMItLUL3gQeV0tVgQFMszfav2oq2/LWvuj8vpR3uPAgMK
         e7Hg0sEN6YvjEw3YdWDy+gprfkdAbmFIKzvPdljy5mDXk3gcT7NHCEHpe1CGdwmYc02W
         ecMZQbL1mzlvOmg1e+e09FNz5pqlWQUkn3Bv6+lDst4TCjKmIqjsWeiS/vBOERUU/DCL
         a8nJe+/qPXzqhF3WSzv6mfrLF2YUGQSiTQtq6olDEnh5PnR+uJId2CSj3IsC0C48+kx7
         0SJzviTlX8/+xw2J9fdbkvHzO2Uq07r/gh9OduOFoQTpwh2uwNk6oMsMNxoqM/iZ1q+d
         6+8Q==
X-Gm-Message-State: AOAM530xKoZnUe9vzaEOsM21QQyGYZjcCL9rQnDh2kC95uPZ32j+xSFO
	7o8NK4cZ3W9kEVEVovDukBJ7kWHq83H+ecEEtoU=
X-Google-Smtp-Source: ABdhPJxHcUCj2mucLF7aE1IOS9CUSMZkQ+YtaXx/Kwh7BPBYbWWQuO91AIxxkwqaFlZSB+yJbXqZO28tnCnqith2Mko=
Sender: "samitolvanen via sendgmr" <samitolvanen@samitolvanen1.mtv.corp.google.com>
X-Received: from samitolvanen1.mtv.corp.google.com ([2620:15c:201:2:f693:9fff:fef4:1b6d])
 (user=samitolvanen job=sendgmr) by 2002:a25:c106:: with SMTP id
 r6mr7621086ybf.519.1606858660290; Tue, 01 Dec 2020 13:37:40 -0800 (PST)
Date: Tue,  1 Dec 2020 13:37:03 -0800
In-Reply-To: <20201201213707.541432-1-samitolvanen@google.com>
Message-Id: <20201201213707.541432-13-samitolvanen@google.com>
Mime-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.29.2.576.ga3fc446d84-goog
Subject: [PATCH v8 12/16] efi/libstub: disable LTO
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

