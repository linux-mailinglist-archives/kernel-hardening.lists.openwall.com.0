Return-Path: <kernel-hardening-return-17835-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7F4FC16382F
	for <lists+kernel-hardening@lfdr.de>; Wed, 19 Feb 2020 01:09:55 +0100 (CET)
Received: (qmail 1219 invoked by uid 550); 19 Feb 2020 00:09:09 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1125 invoked from network); 19 Feb 2020 00:09:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VaL1LZE8ycQeC44ksYepx5tOKr2VfyNgExyF+AnjA94=;
        b=cePll/TraKAUtAJ9SZ2Ia3LSLdgIxY1+FH9CeJe/Js8mU6ZMYsSLXkd7mkxW/sP5DZ
         KJT+Ei4X/Kieg25Nl3ijU9ilrBU19coqFUri04BfLyqK5EuVRfmB30gu2bmvAalUS6LN
         IMbhUPvGvYnYBxafAZ3iZSnwZoQLD7C4koK0IuRjhEPW0oZ2TaiJ9hz4upmRG6/Ns0dh
         UTADf0Yy7wZKSoYV844RlPmV80QoHhyiDwRwibkak3UTghfYE1JKAvnv9As5XVJ0WJ7a
         4rEss8BdwPK/XsciPHFcrXzGvsX8Q30c1NJSo5SBc2z3lUGDDitPI+TJwEDkMrNctWZh
         TcLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=VaL1LZE8ycQeC44ksYepx5tOKr2VfyNgExyF+AnjA94=;
        b=IQIeUiaz2Jvkr57ERXqcf4pohXtYqz8P3elsFB3mujBWZXUyvJi7Yqst183v3Rs0uQ
         2Dw4xsp/Dgg/aBKjYPbTv303xVhBGv7sg2wy6DlPKFC/Ve2Cyho5HwH4Ze56dN42NUA1
         ufR7hWRbS81nzyqAHUuIC5StNBKaLOKaiQZX0D9CwTxuspIu85KOwHWmM0gI/jExhwx9
         s5BDufdMNwc+eP6Kik2FeadUraQkyrbwcFa/u/Yz+iQ9ZBVvY/Q14CB5bkvrHW26ylOV
         1iagc8Z+mwV09r+XfjMGk6k4zq9pKQLrjSjVaiNvUdSUAvVR4xkmGiXOq/5+bg+QIPge
         3u/A==
X-Gm-Message-State: APjAAAVEEEcDkie8mVsPIUI4yynWjTr0xT76SCzNw+PHCL1UI0oVq+8K
	7GLIzvfpvASpNUI9kD4hM7pgrj9FfKXATvdJW0o=
X-Google-Smtp-Source: APXvYqzYgoNmANIZrWEkIv02R5SWh6hiOCKzMRDH3zyUcr6xB+/h3Rs6ymsqIKfuYLDLk6+SeJ73cy3XJLHa4n8oA1M=
X-Received: by 2002:a63:c846:: with SMTP id l6mr25182558pgi.144.1582070936327;
 Tue, 18 Feb 2020 16:08:56 -0800 (PST)
Date: Tue, 18 Feb 2020 16:08:14 -0800
In-Reply-To: <20200219000817.195049-1-samitolvanen@google.com>
Message-Id: <20200219000817.195049-10-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200219000817.195049-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
Subject: [PATCH v8 09/12] arm64: disable SCS for hypervisor code
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mark Rutland <mark.rutland@arm.com>, james.morse@arm.com
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Disable SCS for code that runs at a different exception level by
adding __noscs to __hyp_text.

Suggested-by: James Morse <james.morse@arm.com>
Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index a3a6a2ba9a63..0f0603f55ea0 100644
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
2.25.0.265.gbab2e86ba0-goog

