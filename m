Return-Path: <kernel-hardening-return-18592-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 447DE1B1BB8
	for <lists+kernel-hardening@lfdr.de>; Tue, 21 Apr 2020 04:16:51 +0200 (CEST)
Received: (qmail 20184 invoked by uid 550); 21 Apr 2020 02:15:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 20105 invoked from network); 21 Apr 2020 02:15:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SV1DVkULqNa+FuGbiBRMBHT4OnEsBDpzGAv6cWsD5ng=;
        b=e31q5D2LrF426GuLmKIN4uDuIUm2ZlLf+lRFsNEbELVTAOal8baaG14T9DuGBQz14r
         9Sto7/6FnMn7605IKHg2tf5tw7v+feFsEopk4mtmCip0yo8yDm7Sny62DxKqEH8EV614
         4cTMwKZcAj3aIykYJCFNeM2dddIQaDNfUJ6G5vsq6dSzq9a93ykfl7fWvHYOYeMBNO4G
         1AdylY/8z0uA5mBptLxCAUS/3ywEaqpAYW8Opd2HGdYzg2Ovv2fTec1epYlugUIrLtLa
         hSZOcKEYjSTr5Y6X4B5SgVnahzxKHNojuiY6qPK/Iwbq3wwfF8vt+aWPW3Ij55A/TxGv
         zh6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SV1DVkULqNa+FuGbiBRMBHT4OnEsBDpzGAv6cWsD5ng=;
        b=uZD6PspO71kC9Zf8aYVZMp4BHO+BWPgf6C5DABGUgZNzdDtZR22Q6HXVmKiYpIJhxM
         bRJ/q3BblyE3Z+fCvFbK4h7418FaErj9EPM6DWf1YekIgP6USGLF85QGSyFBbdGKxO7b
         xewmDOEiiLfgb6AI2D0qFKOGk23p8HIX7s8jfv7gS54m7toOlgdrmiyeUfBGoTgjz4Pw
         3UiWifYfCfjMmsg3XLfXpjpIGzOiFXvNkwzJx3vaA1jCSWiRKch34y9g5prJTjphInhK
         UUP3bu8dElS8wweIx/8hUJpfSlaQnqDzBmzlob3jSfurHhrEwIH2Fux0+JCJbqhrJuSp
         JGSg==
X-Gm-Message-State: AGi0Pua9Ocl541EYNe5tzld3JzFtM/EEIhOyUJTWkMgo/0LqVgjZeJdU
	Q8XiMXXUMvMhfRQtGpBTDHRFTWF6xok0jlyCC4c=
X-Google-Smtp-Source: APiQypJ9tTRXTUL1zr6rmczfjnjv8aBX2IxTWUoRDjJtoqdCJcveKeh8g26L37LntO5tp4a613singP8/fZsqc3oszc=
X-Received: by 2002:a17:90a:65c5:: with SMTP id i5mr2797895pjs.18.1587435319203;
 Mon, 20 Apr 2020 19:15:19 -0700 (PDT)
Date: Mon, 20 Apr 2020 19:14:50 -0700
In-Reply-To: <20200421021453.198187-1-samitolvanen@google.com>
Message-Id: <20200421021453.198187-10-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200421021453.198187-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v12 09/12] arm64: disable SCS for hypervisor code
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

Disable SCS for code that runs at a different exception level by
adding __noscs to __hyp_text.

Suggested-by: James Morse <james.morse@arm.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Acked-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_hyp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index fe57f60f06a8..875b106c5d98 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -13,7 +13,7 @@
 #include <asm/kvm_mmu.h>
 #include <asm/sysreg.h>
 
-#define __hyp_text __section(.hyp.text) notrace
+#define __hyp_text __section(.hyp.text) notrace __noscs
 
 #define read_sysreg_elx(r,nvh,vh)					\
 	({								\
-- 
2.26.1.301.g55bc3eb7cb9-goog

