Return-Path: <kernel-hardening-return-17032-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8F928DCAB5
	for <lists+kernel-hardening@lfdr.de>; Fri, 18 Oct 2019 18:15:50 +0200 (CEST)
Received: (qmail 20417 invoked by uid 550); 18 Oct 2019 16:14:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 10106 invoked from network); 18 Oct 2019 16:11:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=K1ZhNofnBR/XSzepuNm2GXj6CjTITzvlb/GIVw7T7D4=;
        b=sClupJ7s2vyir/7TQw4u1wskJ40f2afok9L62g3bdETWOSrvPIoJbt2TUVhCDZl2Ll
         jSD1Pe1pU7jtmC4+A/khfQCqIGy7o+x3Glnf1WXjzHqx9iAelj7PV0FH9T6XgXbpgXPr
         QmyFwYa7yB+qCqYypJwWf511MkYFKNAU+aHSUjTgdgKc/LGoN7I1EdcPjslTcJn6Nsnh
         zpS9sYd2YqSiWR32qZg1jO6XyvMv14Qmysa4U0MKWEQOtGZOZsv14zS5QNAzrCYTZwhv
         xDZy49ncrITpJUlYkIIuqsGVZMQ4LMcDek2uuDnjzpOLCvDTsilhXvrJN1MvHxPElje/
         wDsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=K1ZhNofnBR/XSzepuNm2GXj6CjTITzvlb/GIVw7T7D4=;
        b=PwGOJbPJ7eEhOE+YMPvdwc4t3mHCPjNRn6pO2IcEm7tVoqSg3zaPzxprslBc12ENRy
         guLetuKURXHGS9co5D8fEeefu7I3aw5AjYeclct90xVIRDIcTagFFrMD+s6mnN+7R7wN
         iftA712BLJjveY06HaHMxO8g/gSilEKtdHFHCCTIfLCUVvHOkalJ8QiE6fVyeLVWANsd
         7tFOhbwDoYiINDycbmJtCJSOCJqsiE1mpUq1oCX3RwO/sbOecTPEADpVdVp4jtLBrqfZ
         1ZNghJkvVY0xWO/MU7d8twq+YSMGR+TYeiUf0wDpY4FXFEOK0d93UVULH2VK0Y9DUcmL
         GUPg==
X-Gm-Message-State: APjAAAUzKhXZyfqSPt9P+LfDgtJY6Z0KMiVQ3SLzTLOQ0BoWc/2SzDz+
	R6t6Mp5FfeYFVSK4b5AzRgB7NXaH7hCc8nU+tb4=
X-Google-Smtp-Source: APXvYqxQZgJ8+dUeSHjL/X4r9AY12JB0O/dDMacaQgZEGqyCDds26CgWDH7ZPg+xHY8lSTXkA3/VdzbOvvEqn3IOjDM=
X-Received: by 2002:a63:eb52:: with SMTP id b18mr10634742pgk.205.1571415080458;
 Fri, 18 Oct 2019 09:11:20 -0700 (PDT)
Date: Fri, 18 Oct 2019 09:10:27 -0700
In-Reply-To: <20191018161033.261971-1-samitolvanen@google.com>
Message-Id: <20191018161033.261971-13-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH 12/18] arm64: reserve x18 only with Shadow Call Stack
From: Sami Tolvanen <samitolvanen@google.com>
To: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, clang-built-linux@googlegroups.com, 
	kernel-hardening@lists.openwall.com, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, Sami Tolvanen <samitolvanen@google.com>
Content-Type: text/plain; charset="UTF-8"

Only reserve x18 with CONFIG_SHADOW_CALL_STACK. Note that all external
kernel modules must also have x18 reserved if the kernel uses SCS.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
---
 arch/arm64/Makefile | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/Makefile b/arch/arm64/Makefile
index 1c7b276bc7c5..ef76101201b2 100644
--- a/arch/arm64/Makefile
+++ b/arch/arm64/Makefile
@@ -55,7 +55,7 @@ endif
 
 KBUILD_CFLAGS	+= -mgeneral-regs-only $(lseinstr) $(brokengasinst)	\
 		   $(compat_vdso) $(cc_has_k_constraint)
-KBUILD_CFLAGS	+= -fno-asynchronous-unwind-tables -ffixed-x18
+KBUILD_CFLAGS	+= -fno-asynchronous-unwind-tables
 KBUILD_CFLAGS	+= $(call cc-disable-warning, psabi)
 KBUILD_AFLAGS	+= $(lseinstr) $(brokengasinst) $(compat_vdso)
 
@@ -72,6 +72,10 @@ stack_protector_prepare: prepare0
 					include/generated/asm-offsets.h))
 endif
 
+ifeq ($(CONFIG_SHADOW_CALL_STACK), y)
+KBUILD_CFLAGS	+= -ffixed-x18
+endif
+
 ifeq ($(CONFIG_CPU_BIG_ENDIAN), y)
 KBUILD_CPPFLAGS	+= -mbig-endian
 CHECKFLAGS	+= -D__AARCH64EB__
-- 
2.23.0.866.gb869b98d4c-goog

