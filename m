Return-Path: <kernel-hardening-return-15970-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E48962443B
	for <lists+kernel-hardening@lfdr.de>; Tue, 21 May 2019 01:22:33 +0200 (CEST)
Received: (qmail 3993 invoked by uid 550); 20 May 2019 23:20:33 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3847 invoked from network); 20 May 2019 23:20:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M1E8RaUn9zcJYuZZG/7uL4HyNdEDRlNB8oeiw9QadoE=;
        b=BcEzpaCtHDeErP/BWLjRyK7fBTLMOKLcQuvK1NL+Ewf75ZVTEmchKagvJas138fFpL
         etBB19RzMP4xlK44gIOaNkXNur2K5KlwyPYFy+UCAR8CYMqPnPkHC5ZRIuwT9tVZI1X7
         SEpRCJTIhgZIMaMDFFfQ6unPUoEFaArraP16M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M1E8RaUn9zcJYuZZG/7uL4HyNdEDRlNB8oeiw9QadoE=;
        b=RKzi9XNyy0/Qkv/7UWc7nR4P5QwovwpUZF0bm2KXeqlmmVG8NtyfHFwz/2eOwsy4vJ
         kg0L5O8yrd3/PTYDTVzN47hS8eUOU2LvEyITl1xt6xh7ACdwAUj54hnAKXB/t+7jBilY
         PKdDfjiXgpPb14kg/459JI6m5qQYZVw/Sx280wqhTWqa0Cw6fk8BCWEyF5wToJYlhrVP
         Tq9Y85YqZBkE310DAjG/8Sp0ZjgJMt+/p4agXmjbPLA0hTVDu4o9fKSxxSdk8fhs1Oq4
         nykjkl5dqlszvejW5nYN9dzCpXyDzM9Ns56H2Q9YnOsKIJhcP/xLmk6DDTSoppZ7kCnY
         DGWQ==
X-Gm-Message-State: APjAAAWf8M7urf1AAGomdVEJmoc5feW3n9OTBOWAVcQglJ0i0ZRqNGpm
	WEIjwbRH95o3Zm37ct/OUugLjq6yfKc=
X-Google-Smtp-Source: APXvYqyT2kryQV+6jF2IYoOf+x3y5b6AlPsCieYaesFkPafg3IMH+szJ+l/D5ocyk156zDt8vQJpkA==
X-Received: by 2002:a63:730f:: with SMTP id o15mr78268823pgc.315.1558394420454;
        Mon, 20 May 2019 16:20:20 -0700 (PDT)
From: Thomas Garnier <thgarnie@chromium.org>
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com,
	Thomas Garnier <thgarnie@google.com>,
	Juergen Gross <jgross@suse.com>,
	Alok Kataria <akataria@vmware.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org,
	virtualization@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 11/12] x86/paravirt: Adapt assembly for PIE support
Date: Mon, 20 May 2019 16:19:36 -0700
Message-Id: <20190520231948.49693-12-thgarnie@chromium.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
In-Reply-To: <20190520231948.49693-1-thgarnie@chromium.org>
References: <20190520231948.49693-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Thomas Garnier <thgarnie@google.com>

if PIE is enabled, switch the paravirt assembly constraints to be
compatible. The %c/i constrains generate smaller code so is kept by
default.

Position Independent Executable (PIE) support will allow to extend the
KASLR randomization range below 0xffffffff80000000.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/x86/include/asm/paravirt_types.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
index 2474e434a6f7..93be18bdb63e 100644
--- a/arch/x86/include/asm/paravirt_types.h
+++ b/arch/x86/include/asm/paravirt_types.h
@@ -343,9 +343,17 @@ extern struct paravirt_patch_template pv_ops;
 #define PARAVIRT_PATCH(x)					\
 	(offsetof(struct paravirt_patch_template, x) / sizeof(void *))
 
+#ifdef CONFIG_X86_PIE
+#define paravirt_opptr_call "a"
+#define paravirt_opptr_type "p"
+#else
+#define paravirt_opptr_call "c"
+#define paravirt_opptr_type "i"
+#endif
+
 #define paravirt_type(op)				\
 	[paravirt_typenum] "i" (PARAVIRT_PATCH(op)),	\
-	[paravirt_opptr] "i" (&(pv_ops.op))
+	[paravirt_opptr] paravirt_opptr_type (&(pv_ops.op))
 #define paravirt_clobber(clobber)		\
 	[paravirt_clobber] "i" (clobber)
 
@@ -393,7 +401,7 @@ int paravirt_disable_iospace(void);
  */
 #define PARAVIRT_CALL					\
 	ANNOTATE_RETPOLINE_SAFE				\
-	"call *%c[paravirt_opptr];"
+	"call *%" paravirt_opptr_call "[paravirt_opptr];"
 
 /*
  * These macros are intended to wrap calls through one of the paravirt
-- 
2.21.0.1020.gf2820cf01a-goog

