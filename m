Return-Path: <kernel-hardening-return-18537-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8F04B1ACD21
	for <lists+kernel-hardening@lfdr.de>; Thu, 16 Apr 2020 18:15:06 +0200 (CEST)
Received: (qmail 3134 invoked by uid 550); 16 Apr 2020 16:13:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 2028 invoked from network); 16 Apr 2020 16:13:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SV1DVkULqNa+FuGbiBRMBHT4OnEsBDpzGAv6cWsD5ng=;
        b=sLxFQroYETeBwkC7GL2sYyxH2hNaeokGKsdeLtXjhCO6cOtPj2JOlGsmapVVPWTSK1
         uZovYKEMjxeKiEqbJmm1N7h1ZuFNEWeqj4HZX6p71THvzQF8G9M+4JNKvHa1/tmuIfCm
         6EVESi0OEnWDzNouoomBEUVi/Rq0z+KDY6RjRyGUB3tsfFtJuEFP+col35MQzcyIEv98
         JSCbKVeCMC9JhoiaW1ka8ABAA/JedzZ9Vi0vS2OTLgQwsGeOmODa1mbGdE1L5+3CEz9R
         c0a2TlVnEXnb/0S7j/hvoXDbtLEn1ydd7L+LiJbescqWyWwpPatKM4QMw31dYxQHQmR6
         pJZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SV1DVkULqNa+FuGbiBRMBHT4OnEsBDpzGAv6cWsD5ng=;
        b=StXhxjdqiTrqxSzHV6/Rucl2hBTqwSmuIMv/mO8dv9n6FP/KpE2JNKz4CjIAY8zndl
         dWXxIMfW+xh61IL9PV6xNIJ7x7yRKA5k0Ch/Z/93nWVt+QLlIm+D51nzaOirKro7J5Ac
         jKBjGUjce5DZuOtXx+bdr7V2fOWWwDl2bBhSZqIFvTHo7mf0aVIS8ommdI/RMpgP57oo
         hdACrVO7s9bBzRJhQfSAEc8k60rIameb660ix88i07KGBwNH44QdRHyjnZcciALpXWmu
         jDFuJESUXB5gKPdTzgKVpa+jbQh7uyeRzFoT2fIDp1cTQW8vzgbSK+6h0lGV9JkMCZH1
         DVJQ==
X-Gm-Message-State: AGi0Pua07R+nFf1BfrF/UlJkyiaSEk0hSVx8ar274bXLR55SA4/vdd0u
	4tKHoPHiLype9u2tSNPHg34Ucg7LA17JHj/Tu3w=
X-Google-Smtp-Source: APiQypJNkpQBGKyIWPV2BtmwX/E/gHMUX9jAQmns+9eOAcaQtZAXVp0Bz90VtPtI2vifzdaZP44LMcdHl+FTfzmDINE=
X-Received: by 2002:a63:ca41:: with SMTP id o1mr33386721pgi.419.1587053591236;
 Thu, 16 Apr 2020 09:13:11 -0700 (PDT)
Date: Thu, 16 Apr 2020 09:12:42 -0700
In-Reply-To: <20200416161245.148813-1-samitolvanen@google.com>
Message-Id: <20200416161245.148813-10-samitolvanen@google.com>
Mime-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com> <20200416161245.148813-1-samitolvanen@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v11 09/12] arm64: disable SCS for hypervisor code
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

