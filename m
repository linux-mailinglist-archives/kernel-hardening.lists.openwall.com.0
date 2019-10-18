Return-Path: <kernel-hardening-return-17035-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 76AD5DCABB
	for <lists+kernel-hardening@lfdr.de>; Fri, 18 Oct 2019 18:16:26 +0200 (CEST)
Received: (qmail 22348 invoked by uid 550); 18 Oct 2019 16:14:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 10202 invoked from network); 18 Oct 2019 16:11:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=kAZH5b29Q7ARe7ApEbNubNt6T6v1C763yQTiGjc3PQk=;
        b=MU3xv8ySUWa8q2gpjX+qFLOwCKhVBxOWHnEJ3R9sBKpRssnEcrJMlv2k41DcBabefp
         YGOIRyOHtuLqhQjP/H6UeJPJ31HbWh9EpsVg0P4HVVdbNapzd4whA6CQO0jcE6HFqrZI
         pgFlyp8aklTxhdiWcaDBLc5CpmFKJZswMRP/d6udWasrZrb61oeIxbFInJG3ZOTF4sVk
         8JrRWRNQEQR/efYLvQF070upFjEKFVFMcnO8HN9mWGmqJ5+afIdNL+vr/Zp/pbDcSsCQ
         e4yhuM2R8kT/imgzLMvhUd7v/AWzMuvSo0KChcal0UxqcYxBSXGTsqlDEDweUlIG3qti
         24Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=kAZH5b29Q7ARe7ApEbNubNt6T6v1C763yQTiGjc3PQk=;
        b=DroDlMPIDjIWWCkx30tyj1Z8S08LmfFePpetvGkK/jhBnZUSX/eHVEd2PXN4z5dZz4
         9ou3ZQR9gosCYOlf7MChv/RFFI7ix88Rqkmb6gCwpUnZBNGagLOGA5XWk0t1id7NqR4L
         tTu1vdLSnfSmpw7Eu1+C0gnXCO800qm1m+ZWOfBUGT+JJrFlJREUv7wTM23A9PZQTScK
         WZl6MsyHjq5Qvuud0dEyfP6QTxzkmGsJ94+/+xjRrzeXQwzhGZ0QBjyBDk739rtsE5iC
         xgciTqQ3u9GLQdOfjyYscyn05CJXth1uFlQktaPJ+LbGFOQkUQOBpo+wbg5GsCzRysdI
         2Kqw==
X-Gm-Message-State: APjAAAWBM0Pxp+ay4xUo1UbffMUBxUc9EeSKpo9FuwF64/F1sfXVAWfs
	t9fYt3tfV2EGKSoXGJx1akT7B0SDGDm4fG0YHUc=
X-Google-Smtp-Source: APXvYqxrZ7wEgagooCPTAQmdCRYdis4uNkIIYm64oppMcYVDpcyhHuDu43I31sdZRydHODqHUlaqbmkndVluNi8asAA=
X-Received: by 2002:a63:ff08:: with SMTP id k8mr10900425pgi.8.1571415087691;
 Fri, 18 Oct 2019 09:11:27 -0700 (PDT)
Date: Fri, 18 Oct 2019 09:10:30 -0700
In-Reply-To: <20191018161033.261971-1-samitolvanen@google.com>
Message-Id: <20191018161033.261971-16-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH 15/18] arm64: vdso: disable Shadow Call Stack
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/kernel/vdso/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/vdso/Makefile b/arch/arm64/kernel/vdso/Makefile
index dd2514bb1511..b23c963dd8df 100644
--- a/arch/arm64/kernel/vdso/Makefile
+++ b/arch/arm64/kernel/vdso/Makefile
@@ -19,7 +19,7 @@ obj-vdso := $(addprefix $(obj)/, $(obj-vdso))
 
 ldflags-y := -shared -nostdlib -soname=linux-vdso.so.1 --hash-style=sysv \
 		--build-id -n -T
-
+ccflags-y += $(DISABLE_SCS)
 ccflags-y := -fno-common -fno-builtin -fno-stack-protector -ffixed-x18
 ccflags-y += -DDISABLE_BRANCH_PROFILING
 
-- 
2.23.0.866.gb869b98d4c-goog

