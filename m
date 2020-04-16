Return-Path: <kernel-hardening-return-18533-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E5CB01ACD05
	for <lists+kernel-hardening@lfdr.de>; Thu, 16 Apr 2020 18:14:07 +0200 (CEST)
Received: (qmail 1367 invoked by uid 550); 16 Apr 2020 16:13:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1292 invoked from network); 16 Apr 2020 16:13:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=jhbZSy8N7pmIKGLCoqfuWjSb1n91/ddT1S0YkqMO/sE=;
        b=aGvQz7rpj1gmlNot9DGOyVfFExMSMhcz9FOTIfJbSo6J2eaS4Q9EvaTX97Nd1b7Is2
         Bi/uzVXKD8nyy0gdnni7g4rNQaOUONSHCDbXi1JxVmjuSDUSR9C3hyS6ONRIgdqe5A7o
         KRFqaiwPkP7F+S6duXdhRB2xtAeRc18dKkptU+TW+VkoS72brWS3gLP1uLJyWKMa1apq
         6GOIGu4r7BbAhSSQiEldxlhfcpZpwS7Ujq6MBf2bUhjBlcqdRF1nhMsPi7t9S8NV1SxC
         8eUuHSdrmpT1WtCHfSF0mYe/M0/QauT7xIFnKzHxZWJuc08m/q50qVVerwI3cu0X+K2t
         149A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=jhbZSy8N7pmIKGLCoqfuWjSb1n91/ddT1S0YkqMO/sE=;
        b=Tzjz+uz0kRwAIKSltlOrXoYy/PLmQemSY9PITXWk18e1ERy4xXpA2VrqDA85Ige2cx
         Pzu8xmlVNIsL4F9mKESBCBwnPOjZOAwFrT9LQtxDWiOCh9u92p8InTlLs6hpJoMDCDk+
         gY2e27FSr5KqThIpA9hlDWBX7I8a4HQeDLePq7/GaMl5uFSXbJiHHO6UA+GzpXf09UjO
         sG5fhjYL3jrYPXmZi32udNWHuGyb7ftNuOUVDWbzYH5hIVvvQkqqYqCE9C6otImT9IoV
         TcD6NiXif0bstbA2YQtYruhu+lUNUUC56LzX7mO4uZRdVANVjvnqxBXSXQ6jiItp9mKR
         1h7w==
X-Gm-Message-State: AGi0PuZScacwHK3UsgploBVFwg4IbBDyZNq2G2R72q3Ohsn8DGIMFSqp
	VV4GK6/L/vCJmWRaDobcDrUEtjwvBfneAEpnaOs=
X-Google-Smtp-Source: APiQypL8a8EcwgkAdr2i3smmJxOyKHY3RiUFRcgoCxLBedFlxJV/kyUEcY4a7Jl+ITX16xXqRHQjeNwR/jbT4qE4WrI=
X-Received: by 2002:a65:68c7:: with SMTP id k7mr33098346pgt.248.1587053582058;
 Thu, 16 Apr 2020 09:13:02 -0700 (PDT)
Date: Thu, 16 Apr 2020 09:12:38 -0700
In-Reply-To: <20200416161245.148813-1-samitolvanen@google.com>
Message-Id: <20200416161245.148813-6-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200416161245.148813-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v11 05/12] arm64: reserve x18 from general allocation with SCS
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	James Morse <james.morse@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, 
	Masahiro Yamada <masahiroy@kernel.org>, Michal Marek <michal.lkml@markovi.net>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Jann Horn <jannh@google.com>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Reserve the x18 register from general allocation when SCS is enabled,
because the compiler uses the register to store the current task's
shadow stack pointer. Note that all external kernel modules must also be
compiled with -ffixed-x18 if the kernel has SCS enabled.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Will Deacon <will@kernel.org>
---
 arch/arm64/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 85e4149cc5d5..409a6c1be8cc 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -81,6 +81,10 @@ endif
 
 KBUILD_CFLAGS += $(branch-prot-flags-y)
 
+ifeq ($(CONFIG_SHADOW_CALL_STACK), y)
+KBUILD_CFLAGS	+= -ffixed-x18
+endif
+
 ifeq ($(CONFIG_CPU_BIG_ENDIAN), y)
 KBUILD_CPPFLAGS	+= -mbig-endian
 CHECKFLAGS	+= -D__AARCH64EB__
-- 
2.26.1.301.g55bc3eb7cb9-goog

