Return-Path: <kernel-hardening-return-17461-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 52760113886
	for <lists+kernel-hardening@lfdr.de>; Thu,  5 Dec 2019 01:11:28 +0100 (CET)
Received: (qmail 28305 invoked by uid 550); 5 Dec 2019 00:10:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28224 invoked from network); 5 Dec 2019 00:10:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7yE3ZHkR69UGcsqSedpJxhASD5SeB0FinXe1byG56UQ=;
        b=f/EVziDY7KK0UVtP07zeQE8P/OZC24lNIxT+R0yrkPhKCRQlrqlzCOrH5fi8fvczJ5
         bhXqfRmivbfuDr2Tu6VTuKi28nf92jc1ge/UxVZlXwVOvxwsjHB0e4vv9oMBJYuLmvcB
         d+qDYPPdtKxm9l1gNlaJYeQGZJZ06L4X45ZUM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7yE3ZHkR69UGcsqSedpJxhASD5SeB0FinXe1byG56UQ=;
        b=PksUano7lnQ00nm5G1XXqXUOdUDeGoug2ucteLIYFX/zz4F/SiR1SbkmuN/BJp/uY2
         JpFZ0wmBoM9USJpJKyBFj1Up4tmIcTQ7jeVwhfReRYif3UjKb2VXeixvFASaZCKODtL2
         CFmox5ste+US6ujaxb3vi27r0+lluGm8PZGH4JFeSXXioRCaMNY1KOVejTl21sB/YMFF
         iPdGYtLLTnDYpStY1AGJaTj2ilbmuoLNBX/tJgKmJbgW1hyJTChqDB9vuS9SlWGdnCJd
         qIjEPQyv1CtnkTt0V6NhieqFujadKbVfZIAGE8ZYRhKr0+qYCA+HxGea5ti/G7qVnb0T
         NmAw==
X-Gm-Message-State: APjAAAWQxt2FppJ/aQWTuAnzrY8oYUJkkue9uus71+yOdgzVO9hTdnvc
	izoRaJvLSEFcxJvFZSQatQqieWFEChU=
X-Google-Smtp-Source: APXvYqwCkYksA3H9gQM8Dd/UpM0c4sw+LmMk/E0hmNMYq/n4Q5BnskCCI0QZYAt9KoQF8+EThAaDog==
X-Received: by 2002:a63:3f4f:: with SMTP id m76mr6186602pga.353.1575504619867;
        Wed, 04 Dec 2019 16:10:19 -0800 (PST)
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
	Andy Lutomirski <luto@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Len Brown <len.brown@intel.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v10 06/11] x86/CPU: Adapt assembly for PIE support
Date: Wed,  4 Dec 2019 16:09:43 -0800
Message-Id: <20191205000957.112719-7-thgarnie@chromium.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
In-Reply-To: <20191205000957.112719-1-thgarnie@chromium.org>
References: <20191205000957.112719-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Change the assembly code to use only relative references of symbols for the
kernel to be PIE compatible.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
---
 arch/x86/include/asm/processor.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 0340aad3f2fc..77fa291a60bb 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -742,11 +742,13 @@ static inline void sync_core(void)
 		"pushfq\n\t"
 		"mov %%cs, %0\n\t"
 		"pushq %q0\n\t"
-		"pushq $1f\n\t"
+		"leaq 1f(%%rip), %q0\n\t"
+		"pushq %q0\n\t"
 		"iretq\n\t"
 		UNWIND_HINT_RESTORE
 		"1:"
-		: "=&r" (tmp), ASM_CALL_CONSTRAINT : : "cc", "memory");
+		: "=&r" (tmp), ASM_CALL_CONSTRAINT
+		: : "cc", "memory");
 #endif
 }
 
-- 
2.24.0.393.g34dc348eaf-goog

