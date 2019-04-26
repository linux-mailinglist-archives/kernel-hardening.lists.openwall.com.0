Return-Path: <kernel-hardening-return-15832-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id AC364B2EE
	for <lists+kernel-hardening@lfdr.de>; Sat, 27 Apr 2019 08:46:27 +0200 (CEST)
Received: (qmail 5289 invoked by uid 550); 27 Apr 2019 06:43:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5166 invoked from network); 27 Apr 2019 06:43:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=g3nO4xFM3yb0X+OIqTEtEp6LbffMj61RqStKCNeSSiM=;
        b=IhMsROzOX/uvsuQybijdR85Kqaxq4yWzjUoagIOqk1LVY6OLTEXQbjBmXHD5WxbAzP
         cmCoo1zMlycyEW/HfwZCgn/X+0dMFPFHyqqtEUKq6AZF6jWZrRVIUAiE8jxYjY0M9MT3
         Ik7ZKhQeM7kg+3gB06XcTjx2xBZpPGhS55GH7o8s674YL85Zg5fEINa05kjxM9iG+Kfo
         SEIwp8JxZ7vs+rhoqI+mg8MouUQf2Zul6cu4rspQPkk8FxQa/9RXPXX4OwkD3jy0+Z/+
         SBrns4/qvGYQvjrl9OPoH7DBVBfA0arFpsKvUBwFWEn4L2+Z7qiKOGh0M4x1w7s8Fe9M
         Y7uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=g3nO4xFM3yb0X+OIqTEtEp6LbffMj61RqStKCNeSSiM=;
        b=Z2ggl54odupGVs6OKbzLS8jN6yoOTIOcRE/GJnrZzA/rIN9pYwEI4JBrgqQhiyPVme
         oazVWWAwvupNkyWZOJwgVhWL6RKBSV9BPBqkXyA9W/dvqJnLdhtt5WX62/wL+OzXh5n3
         aEo8ciZwNlp4SblP5qVwU4TS5Uwg15aCit43EKFM26XGxvA1lGz6Cg0MThCugT6ePxyX
         TX7mF0jy4yEQWuS5gnCn7NnGAiJnYYPh9SqVq3NW25/L+iBOTXO0mV+yQErpMwTz8k6z
         7nbon/uMBxPrpSzQGjuQ11ulKmBoQTs4RvlmLqwgSjzdoG7HHXY4MWgWCpzOg1clhZtc
         f1UA==
X-Gm-Message-State: APjAAAX4m03PXb9y//wMeNuStX5qgowUsJUw0lCyzNfW20Jakv6sHn5O
	23BXGMoM6DNC+uQeR4izWyo=
X-Google-Smtp-Source: APXvYqyXozv8RJ3un5KRfku6J9oOZngaXmf1Y0t3bUJMwzL1TSTEhjmbFCgyEeDgaxJqumt2ZQ+7aA==
X-Received: by 2002:a62:5fc7:: with SMTP id t190mr50793424pfb.191.1556347403359;
        Fri, 26 Apr 2019 23:43:23 -0700 (PDT)
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
	Kees Cook <keescook@chromium.org>,
	Dave Hansen <dave.hansen@intel.com>,
	Masami Hiramatsu <mhiramat@kernel.org>
Subject: [PATCH v6 13/24] x86/jump-label: Remove support for custom poker
Date: Fri, 26 Apr 2019 16:22:52 -0700
Message-Id: <20190426232303.28381-14-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190426232303.28381-1-nadav.amit@gmail.com>
References: <20190426232303.28381-1-nadav.amit@gmail.com>

From: Nadav Amit <namit@vmware.com>

There are only two types of poking: early and breakpoint based. The use
of a function pointer to perform poking complicates the code and is
probably inefficient due to the use of indirect branches.

Cc: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kernel/jump_label.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index e7d8c636b228..e631c358f7f4 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -37,7 +37,6 @@ static void bug_at(unsigned char *ip, int line)
 
 static void __ref __jump_label_transform(struct jump_entry *entry,
 					 enum jump_label_type type,
-					 void *(*poker)(void *, const void *, size_t),
 					 int init)
 {
 	union jump_code_union jmp;
@@ -50,14 +49,6 @@ static void __ref __jump_label_transform(struct jump_entry *entry,
 	jmp.offset = jump_entry_target(entry) -
 		     (jump_entry_code(entry) + JUMP_LABEL_NOP_SIZE);
 
-	/*
-	 * As long as only a single processor is running and the code is still
-	 * not marked as RO, text_poke_early() can be used; Checking that
-	 * system_state is SYSTEM_BOOTING guarantees it.
-	 */
-	if (system_state == SYSTEM_BOOTING)
-		poker = text_poke_early;
-
 	if (type == JUMP_LABEL_JMP) {
 		if (init) {
 			expect = default_nop; line = __LINE__;
@@ -80,16 +71,19 @@ static void __ref __jump_label_transform(struct jump_entry *entry,
 		bug_at((void *)jump_entry_code(entry), line);
 
 	/*
-	 * Make text_poke_bp() a default fallback poker.
+	 * As long as only a single processor is running and the code is still
+	 * not marked as RO, text_poke_early() can be used; Checking that
+	 * system_state is SYSTEM_BOOTING guarantees it. It will be set to
+	 * SYSTEM_SCHEDULING before other cores are awaken and before the
+	 * code is write-protected.
 	 *
 	 * At the time the change is being done, just ignore whether we
 	 * are doing nop -> jump or jump -> nop transition, and assume
 	 * always nop being the 'currently valid' instruction
-	 *
 	 */
-	if (poker) {
-		(*poker)((void *)jump_entry_code(entry), code,
-			 JUMP_LABEL_NOP_SIZE);
+	if (init || system_state == SYSTEM_BOOTING) {
+		text_poke_early((void *)jump_entry_code(entry), code,
+				JUMP_LABEL_NOP_SIZE);
 		return;
 	}
 
@@ -101,7 +95,7 @@ void arch_jump_label_transform(struct jump_entry *entry,
 			       enum jump_label_type type)
 {
 	mutex_lock(&text_mutex);
-	__jump_label_transform(entry, type, NULL, 0);
+	__jump_label_transform(entry, type, 0);
 	mutex_unlock(&text_mutex);
 }
 
@@ -131,5 +125,5 @@ __init_or_module void arch_jump_label_transform_static(struct jump_entry *entry,
 			jlstate = JL_STATE_NO_UPDATE;
 	}
 	if (jlstate == JL_STATE_UPDATE)
-		__jump_label_transform(entry, type, text_poke_early, 1);
+		__jump_label_transform(entry, type, 1);
 }
-- 
2.17.1

