Return-Path: <kernel-hardening-return-15828-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 582B1B2EA
	for <lists+kernel-hardening@lfdr.de>; Sat, 27 Apr 2019 08:45:27 +0200 (CEST)
Received: (qmail 3639 invoked by uid 550); 27 Apr 2019 06:43:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3471 invoked from network); 27 Apr 2019 06:43:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3mFI7V2IpbwOhuCcp+g9CO2dE2meFXsvyyAeb18NWyo=;
        b=JlRIHgbr6HB0GM/dfrBCsDnNLxTkOKzTB7qYCbAx4tDSjiPWdWErWZcgNMKz3646h4
         C8cKj9bZkmi6cPWikKj5uJAC7SrSg/qfrmI03cXhBRcOJHEMan3BYUSQ1ScXOsNa4u3Z
         IDQ4DfzWzmEsKN3rKTGM5uTvN695pUVNWWV4a8LMMvLzAhr7fWiHf2k7ZmkakgE11lMg
         wbrOSfmIb0CTjB/azGiS0/j+OjbriGytqXhtU6Bd27x2yAPLaWXYIt792EgmySvUAGOQ
         9VF/satnq8MCbRYyAQp+FRH27QsFCLaAp8PdnQobxJM8asT3n363jT4JX9FD5F/9ebkE
         0Uqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=3mFI7V2IpbwOhuCcp+g9CO2dE2meFXsvyyAeb18NWyo=;
        b=rMNEqX/JppVddZAr0sjRTuGuRiwPntdRmCu5UJkz4/UYz7Tv6QYUNPsRXp0aISG9xY
         NOVHmwxBwDsU9PYH1uYe1zmqNBxA7nmzYYRDX5MYT/ghqvF+YCPjP4H4TNmwqOjuo1X+
         B4mUUnfJx7yOVDsX5YXJEjOl97ocgO3LMDWxZbOhOI2xmTq3+foqXHu9YnoH6csRzM3T
         PUIrjdUvGW4zhpOIBNOeX7sRalCfkt0L0ohUEnP0KqfjA5WAkOI9lt74xIl9P6Yf4ugX
         ixae2tS/cwWAOqBPnXuCLRdeV4uPS2OWklvids6QTAUhhG4dqjlTIzOt6KtJAuolb+I9
         j66g==
X-Gm-Message-State: APjAAAUvlqf6IfLPvqfsS061ULytmAL3O424pdmT9kFUZT4qdWY0uRfP
	zntMURb4cG8QaUIgkRM8eW8=
X-Google-Smtp-Source: APXvYqx2WhBZnJIn8mqH1b7ixt4GF/6k4yp110M4lMdf7eXq6Mz7eqmVNfTsfdPSyk5JMfubTGyIEQ==
X-Received: by 2002:a17:902:2927:: with SMTP id g36mr48053244plb.6.1556347396829;
        Fri, 26 Apr 2019 23:43:16 -0700 (PDT)
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
	Nadav Amit <namit@vmware.com>
Subject: [PATCH v6 09/24] x86/kgdb: Avoid redundant comparison of patched code
Date: Fri, 26 Apr 2019 16:22:48 -0700
Message-Id: <20190426232303.28381-10-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190426232303.28381-1-nadav.amit@gmail.com>
References: <20190426232303.28381-1-nadav.amit@gmail.com>

From: Nadav Amit <namit@vmware.com>

text_poke() already ensures that the written value is the correct one
and fails if that is not the case. There is no need for an additional
comparison. Remove it.

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kernel/kgdb.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/arch/x86/kernel/kgdb.c b/arch/x86/kernel/kgdb.c
index 2b203ee5b879..13b13311b792 100644
--- a/arch/x86/kernel/kgdb.c
+++ b/arch/x86/kernel/kgdb.c
@@ -747,7 +747,6 @@ void kgdb_arch_set_pc(struct pt_regs *regs, unsigned long ip)
 int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
 {
 	int err;
-	char opc[BREAK_INSTR_SIZE];
 
 	bpt->type = BP_BREAKPOINT;
 	err = probe_kernel_read(bpt->saved_instr, (char *)bpt->bpt_addr,
@@ -766,11 +765,6 @@ int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
 		return -EBUSY;
 	text_poke_kgdb((void *)bpt->bpt_addr, arch_kgdb_ops.gdb_bpt_instr,
 		       BREAK_INSTR_SIZE);
-	err = probe_kernel_read(opc, (char *)bpt->bpt_addr, BREAK_INSTR_SIZE);
-	if (err)
-		return err;
-	if (memcmp(opc, arch_kgdb_ops.gdb_bpt_instr, BREAK_INSTR_SIZE))
-		return -EINVAL;
 	bpt->type = BP_POKE_BREAKPOINT;
 
 	return err;
@@ -778,9 +772,6 @@ int kgdb_arch_set_breakpoint(struct kgdb_bkpt *bpt)
 
 int kgdb_arch_remove_breakpoint(struct kgdb_bkpt *bpt)
 {
-	int err;
-	char opc[BREAK_INSTR_SIZE];
-
 	if (bpt->type != BP_POKE_BREAKPOINT)
 		goto knl_write;
 	/*
@@ -791,10 +782,7 @@ int kgdb_arch_remove_breakpoint(struct kgdb_bkpt *bpt)
 		goto knl_write;
 	text_poke_kgdb((void *)bpt->bpt_addr, bpt->saved_instr,
 		       BREAK_INSTR_SIZE);
-	err = probe_kernel_read(opc, (char *)bpt->bpt_addr, BREAK_INSTR_SIZE);
-	if (err || memcmp(opc, bpt->saved_instr, BREAK_INSTR_SIZE))
-		goto knl_write;
-	return err;
+	return 0;
 
 knl_write:
 	return probe_kernel_write((char *)bpt->bpt_addr,
-- 
2.17.1

