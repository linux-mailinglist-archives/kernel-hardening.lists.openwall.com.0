Return-Path: <kernel-hardening-return-15841-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 1EB8BB2F7
	for <lists+kernel-hardening@lfdr.de>; Sat, 27 Apr 2019 08:48:25 +0200 (CEST)
Received: (qmail 5998 invoked by uid 550); 27 Apr 2019 06:43:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5869 invoked from network); 27 Apr 2019 06:43:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Mq726et3FUsm8L5SG93p+KUhd7ShOgthVM8qUN29ytY=;
        b=ZcHDpG5oI881U7Ra0/L2O5huO2cwDn2YrdsQ5hiAWkm6WdBzN67nlkJvfLDLJC5q+X
         UOCeP+9RydbCT4dO6iGp4lZQdm3+sXHNSQC0G0grGB6NOlnyKbwZn5NdDqZwDHIXRDud
         3mNZu1J6RFiZozyuuSJ7f0wBAoiYQFhmUfj5tGkTm8jduQKjEFGn6AF04k5qQYjIWsXY
         4YzLX+ZgfiYxaYFVUDUXXbJdfkkMMJKkcbeIB+VGTLlKKEI2dS4TTD29m/lBt3TdxyYa
         a4fp8LYLp6QEbTAIinVcBUAwlwg+TwtnzyGC3pPfhsUXM3/E24y9pQ9Ah5nWVdchzhK2
         LMJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Mq726et3FUsm8L5SG93p+KUhd7ShOgthVM8qUN29ytY=;
        b=oAQWjpSciax+TzbTXU51s2v8Btlf7mVOVDvaMFDjM9OimhL4DDXcvfB1XUSfEQppSk
         NQuauI+oY5GP3At+CeRFeOh4NnsLLo/PubNZbSLT0Gw2oC7Nel+DxwCeGnpv6yJ/6YJ+
         idg17dZOhj1Xl1E2bZBByUJ1dlLa27RSV7UJe7xWu6IjmWt3o9AmnGb1jEiBpfPT3/yo
         iZnRF/EfzB/or5yg0nMbVEymWceGXfUrGRyL1uJ99Nx2v1RhWrbAjD8Kqih6RTCPEwUA
         gIiE08kok59cc9p6++0JEIqk3kVvxUWKSj1NxI5tD7Nh8qLdnehCHYP2qOHC5BELssHB
         vUuQ==
X-Gm-Message-State: APjAAAUvQ6YGQUvw/zSh0fqy9JG7LqPkk55n8eXSbupmGZDfvnvLzVNm
	spn5CKyJwMADD97M76uEiEY=
X-Google-Smtp-Source: APXvYqz6QdLKu0nIIJYQFhptNQ/c9BRHYqidvmm2brorovTM3Ggu9E591UYxGE1lKlV0dGgfmeOtWg==
X-Received: by 2002:a63:e051:: with SMTP id n17mr5092049pgj.19.1556347415619;
        Fri, 26 Apr 2019 23:43:35 -0700 (PDT)
From: nadav.amit@gmail.com
To: Peter Zijlstra <peterz@infradead.org>,
	Borislav Petkov <bp@alien8.de>,
	Andy Lutomirski <luto@kernel.org>,
	Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	hpa@zytor.com,
	Thomas Gleixner <tglx@linutronix.de>,
	Nadav Amit <nadav.amit@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux_dti@icloud.com,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	akpm@linux-foundation.org,
	kernel-hardening@lists.openwall.com,
	linux-mm@kvack.org,
	will.deacon@arm.com,
	ard.biesheuvel@linaro.org,
	kristen@linux.intel.com,
	deneen.t.dock@intel.com,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Nadav Amit <namit@vmware.com>,
	Masami Hiramatsu <mhiramat@kernel.org>
Subject: [PATCH v6 22/24] x86/alternative: Comment about module removal races
Date: Fri, 26 Apr 2019 16:23:01 -0700
Message-Id: <20190426232303.28381-23-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190426232303.28381-1-nadav.amit@gmail.com>
References: <20190426232303.28381-1-nadav.amit@gmail.com>

From: Nadav Amit <namit@vmware.com>

Add a comment to clarify that users of text_poke() must ensure that
no races with module removal take place.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kernel/alternative.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 18f959975ea0..7b9b49dfc05a 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -810,6 +810,11 @@ static void *__text_poke(void *addr, const void *opcode, size_t len)
  * It means the size must be writable atomically and the address must be aligned
  * in a way that permits an atomic write. It also makes sure we fit on a single
  * page.
+ *
+ * Note that the caller must ensure that if the modified code is part of a
+ * module, the module would not be removed during poking. This can be achieved
+ * by registering a module notifier, and ordering module removal and patching
+ * trough a mutex.
  */
 void *text_poke(void *addr, const void *opcode, size_t len)
 {
-- 
2.17.1

