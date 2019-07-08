Return-Path: <kernel-hardening-return-16389-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A00666279F
	for <lists+kernel-hardening@lfdr.de>; Mon,  8 Jul 2019 19:50:39 +0200 (CEST)
Received: (qmail 28027 invoked by uid 550); 8 Jul 2019 17:49:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 27920 invoked from network); 8 Jul 2019 17:49:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3Eb3Hb6sMPNCVrucYh3+8MTfpr8uJqt0a1oSlG2FmzA=;
        b=Eh1Z2cY2TLITAWx2bANgQlukRumh7aQ8qMvjId2GjyNdQSlE4Akz5EQfSMUNs2dLbi
         rkR2NqSY4lMvwQf9S2DSQpCn+V6sCrXSfutHEtHfoKNwXdYMkVs+tvmlPiGyIMYHLTac
         U4GrH9ccvKqYgl5u99ugvBNsZsnU7+UIhA3VA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3Eb3Hb6sMPNCVrucYh3+8MTfpr8uJqt0a1oSlG2FmzA=;
        b=FeRhonSM2qP3E32J3cQZavZ9h454KD4DeK8CVTzuYrdp6prGSQB3gLyoKsL0ShU/An
         +iPwHqcPXvOVgYKXpi0PjLvz+DBnVn1an75TOFshilli3XtlOwpdhH5aLaklw6gsGXJe
         j2uvUU5k1osaDs8EFSxVSZvVdBQ9SB1su0nDqfr0pmvgEdyIrViuexUzwbtOvPAfXGFa
         qR1i0kavhSPFcpq4p36tn/Y3U0qlIrlcoDq9+GO2f6h1C6vLgWxGEsLWOpAhp33Cn+vT
         uMnD7ux0L8dVuFdjqduRMFotD84j6g+V8z3+xVt9eCHv58tK9DWasm2hPK0QiFATeCEN
         KXzA==
X-Gm-Message-State: APjAAAVTOiPsEgbCYwfbFPwuRklgNsNzSw9qgYj046S+ni/GY2BbtxL3
	k09GlivBuD0OenmDyTdSrbJcgm/Kzhg=
X-Google-Smtp-Source: APXvYqxUXc4eLmCK5ydeVvkEVQiap2JrFMI/RSqJ2b7/EDWXwmMFOd4atDt+r3lAjdEJ37qlAwbKDw==
X-Received: by 2002:a17:90a:3463:: with SMTP id o90mr27861911pjb.15.1562608173232;
        Mon, 08 Jul 2019 10:49:33 -0700 (PDT)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	keescook@chromium.org,
	Thomas Garnier <thgarnie@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v8 05/11] x86: pm-trace - Adapt assembly for PIE support
Date: Mon,  8 Jul 2019 10:48:58 -0700
Message-Id: <20190708174913.123308-6-thgarnie@chromium.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190708174913.123308-1-thgarnie@chromium.org>
References: <20190708174913.123308-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change assembly to use the new _ASM_MOVABS macro instead of _ASM_MOV for
the assembly to be PIE compatible.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 arch/x86/include/asm/pm-trace.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/pm-trace.h b/arch/x86/include/asm/pm-trace.h
index bfa32aa428e5..972070806ce9 100644
--- a/arch/x86/include/asm/pm-trace.h
+++ b/arch/x86/include/asm/pm-trace.h
@@ -8,7 +8,7 @@
 do {								\
 	if (pm_trace_enabled) {					\
 		const void *tracedata;				\
-		asm volatile(_ASM_MOV " $1f,%0\n"		\
+		asm volatile(_ASM_MOVABS " $1f,%0\n"		\
 			     ".section .tracedata,\"a\"\n"	\
 			     "1:\t.word %c1\n\t"		\
 			     _ASM_PTR " %c2\n"			\
-- 
2.22.0.410.gd8fdbe21b5-goog

