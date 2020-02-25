Return-Path: <kernel-hardening-return-17917-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 1FAC316ECDE
	for <lists+kernel-hardening@lfdr.de>; Tue, 25 Feb 2020 18:42:08 +0100 (CET)
Received: (qmail 5373 invoked by uid 550); 25 Feb 2020 17:40:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5298 invoked from network); 25 Feb 2020 17:40:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=S6rjWX4zh65J8qRPSZGN8zFIqvl385Xc8XQW3COWMIA=;
        b=AG/N+nAHceAaZJA2t3Ejlewnc800yTOYWW+XxDFlkHuEYsEQXM8laR8JPO6q9sZexT
         Qx9MR9PKuF1TFGK9rO4WrVGkhDFRUGBo3nTHm42lh1aY7DKUsRdqOVC006GRSybPTBpy
         CwdI4+LxD7e+4hZQ2qE/GwtlmXo1ZC8r/ZErTUuiCdp5rmFmAgH5PeFSBDiA+eNFZEE1
         7vUfoZhf7+iQVtJY9b36r4K3TymVF9QDFXBobvvCwA1YLJK0qNYbbXNNu3MS1aQw9yMX
         I0P+8rGbiMpOXi6P0ZHT3Ij2kkgGsyVJDrLVC8dfHFUYAz5mItfFosYAxy/OwBsM9sCx
         TRAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=S6rjWX4zh65J8qRPSZGN8zFIqvl385Xc8XQW3COWMIA=;
        b=sGFev9YB671i79d8M36p7ZjTLKabgc8ZqXQZuONuYCYbKcWIJBJ8mIUJ/uQsTrjyp0
         NAZ0ZdQhpuIBJb+io6ZxCB0FKl8+ZOFRdheCCxYeg/15sFRZAIYMLHb/NCGsX8BZGTFi
         nqV2l3fuHn9GERQ2KRW5aMSlU05Tl0tmEO0jS5fGWldscX2Rv8iEM5LvmNwFOq9M4Ope
         0BvaAkB8VwfUg9wIgGk/R7WSJ2ZA7EepAHJMa+r+XFiBGbwiAKbc4ESY5r+0lKWP4LJ8
         SUhLfjO9cjJ13bkveEK0eGAS0OTqK0NoEhKZy1cu2plRxlUTIaAmEIrwDNIKzIBtUXkj
         E/MQ==
X-Gm-Message-State: APjAAAUCDpCiZRDeYEi1Mh7RAwbS3UI83WIRlY/WlWbc9kUnxw2dj4x8
	Va7EkmWx8yhgEYkprZZNv512am8Qcp8Tn9pKcck=
X-Google-Smtp-Source: APXvYqxga1IezAaj/7lzDoz6ajYcBY13ZBQ7EtWObgAVtXX9jDsYBp8jjd+EWNf7mvFW/jyX4NCc+z3bne5DtOlbYaQ=
X-Received: by 2002:a63:e044:: with SMTP id n4mr57741015pgj.338.1582652419605;
 Tue, 25 Feb 2020 09:40:19 -0800 (PST)
Date: Tue, 25 Feb 2020 09:39:33 -0800
In-Reply-To: <20200225173933.74818-1-samitolvanen@google.com>
Message-Id: <20200225173933.74818-13-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200225173933.74818-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH v9 12/12] efi/libstub: disable SCS
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
index 98a81576213d..ee5c37c401c9 100644
--- a/drivers/firmware/efi/libstub/Makefile
+++ b/drivers/firmware/efi/libstub/Makefile
@@ -30,6 +30,9 @@ KBUILD_CFLAGS			:= $(cflags-y) -DDISABLE_BRANCH_PROFILING \
 				   $(call cc-option,-fno-stack-protector) \
 				   -D__DISABLE_EXPORTS
 
+#  remove SCS flags from all objects in this directory
+KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
+
 GCOV_PROFILE			:= n
 KASAN_SANITIZE			:= n
 UBSAN_SANITIZE			:= n
-- 
2.25.0.265.gbab2e86ba0-goog

