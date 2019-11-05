Return-Path: <kernel-hardening-return-17313-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B80B5F0ABB
	for <lists+kernel-hardening@lfdr.de>; Wed,  6 Nov 2019 00:58:30 +0100 (CET)
Received: (qmail 28170 invoked by uid 550); 5 Nov 2019 23:57:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28102 invoked from network); 5 Nov 2019 23:57:04 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SBPjjox/K0nQBp9p/UReaX06mOCKZA5VG5oKrHSRp3U=;
        b=p/+qormWzpAk/hn6fTIAq1GD6e0WQRag5NF7NjqAhGo5V+9tCeqWxMigwtXWt/lGNp
         q9buszXWKYVWoziPQLZS51iBSuLA1nUdgVLAfYt05cUtAWebiilSqti+DjDN8Q0UKshx
         57MAdb8441Kh4kMQAc47B2g6uSc/jktWoSENQoAO1SfBArC0JfH71OE1ZC9X88wFzf7D
         1zKwIMNiGpyq7Ox2PdBV9bj7qpbfLeuEOQjRxH+b5fzmSdlQBlgmJqQb6wUCW+t/kkJd
         W22heVjnv5z8zfiAr2e8BVc/Krx9f9PGp3snmyjgH+VW1d5sU1rFDMtHZ42LB6knm6uR
         i+NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SBPjjox/K0nQBp9p/UReaX06mOCKZA5VG5oKrHSRp3U=;
        b=ToT881aPJP7hY4OVbMlO4a5xfay+CQsXxdWgAqyhgrFxEWKQq7IssXb8jEqTSmvZ2i
         yLGQN5tc82KuIXbAzPlSwoQBU1bJZJ7QLtCvgGHiF0OyCQZUkH7TQm4E3oBnXuS5kWnR
         exhP+I6JruAWiYjEYjDN/kEyJa3Awjngrh340ul8GuJyOMaNp+zNM9PEHNKb1YeE7o35
         yvHL8VVQQy3lFAuWtcoC/3kYsfZO60wcIUp2RpMHtvfi97NYXMtJEbpyUSMcZZVoq9D+
         yBN7gMKHxtFOC/gIPz2wAb5QSj4DbfmEt0l+mhWZ1/tppZgzuQo9QP7KE9sUkpppw/kB
         L/5A==
X-Gm-Message-State: APjAAAXsTfMU6wKphWbdIkI+iW8NaKNa+0zbwn8eVJHquEp/r120DUy+
	5bNyXooMUS5a67Hjcm5L/QuhYlG4RCcbvOp+2qU=
X-Google-Smtp-Source: APXvYqwMtHOZMoB23ssF7JNCZzaMw12LgXJO1Cx/fyHqurm8wqZn755XqIGbFFeB1mv3cEwMcIBCpgy6byzfZbrNKqg=
X-Received: by 2002:a63:6483:: with SMTP id y125mr5619534pgb.444.1572998212169;
 Tue, 05 Nov 2019 15:56:52 -0800 (PST)
Date: Tue,  5 Nov 2019 15:56:07 -0800
In-Reply-To: <20191105235608.107702-1-samitolvanen@google.com>
Message-Id: <20191105235608.107702-14-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20191105235608.107702-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.24.0.rc1.363.gb1bccd3e3d-goog
Subject: [PATCH v5 13/14] arm64: disable SCS for hypervisor code
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Filter out CC_FLAGS_SCS for code that runs at a different exception
level.

Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/arm64/kvm/hyp/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
index ea710f674cb6..17ea3da325e9 100644
--- a/arch/arm64/kvm/hyp/Makefile
+++ b/arch/arm64/kvm/hyp/Makefile
@@ -28,3 +28,6 @@ GCOV_PROFILE	:= n
 KASAN_SANITIZE	:= n
 UBSAN_SANITIZE	:= n
 KCOV_INSTRUMENT	:= n
+
+# remove the SCS flags from all objects in this directory
+KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

