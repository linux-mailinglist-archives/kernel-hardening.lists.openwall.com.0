Return-Path: <kernel-hardening-return-15821-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 532B7B2E3
	for <lists+kernel-hardening@lfdr.de>; Sat, 27 Apr 2019 08:44:04 +0200 (CEST)
Received: (qmail 1715 invoked by uid 550); 27 Apr 2019 06:43:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1557 invoked from network); 27 Apr 2019 06:43:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Y4ax2hOd4Buhijx/oNSuXPhWpslJbmlh2LJYha9eHFk=;
        b=RYKIYvXmL5tJ4u/bU0iLk60YO+Ox59zCcKmrYcUn0L0mc7KUA8ZtJ2R4XNYjQk2a8B
         DcQM399thIjNSjXHuZQ6k7afM/SMh1l1QYkf2D0hRQ+1xwvUSHZnrIJ4UJtkR2NL1yLe
         l1RYwwd0hroNUCsKi5IV5ZZNm8YzK8J7h42F1sPN4gG9Y1ehTjsd+VC718e5LdQep+gS
         k/OhJCSCkHRbcX+8zk8NtqDpMNtIV6Cqdz0zcbSsIjK/yzdPAJzadIJkFTsIuXX0ujKs
         CagOndVrfBrJnKlvTuPVqrDmZeIo9JxoUR6B70xI9bSBAuYLVmprrE1fKIlJc4O0C9hS
         uf2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Y4ax2hOd4Buhijx/oNSuXPhWpslJbmlh2LJYha9eHFk=;
        b=XhErT59klaaU5Jw406PTC0i+CO/VHjT6MAjTdFKqLXTk01ypY6WwskWhCJFZ7zSoOO
         LYD0dIhExIFQXj0fHo2X2DcZ8nL/Mm9H35su/qUF0adBlxgZJQvdPvyiaK9Hc/9Gf3CE
         ZUcRjU03yB0YsktVQNKo9w+lsh5cVnKBlID8MnqARIrL3LJK4f2Yxlh5vfmT08bQeaBh
         ma0YyocWio08BdHefvhK8YPuGy5pgvFZufOAN0x4kPbZnqOycEtEjuGbj81H0zKpWUon
         9gcVa+YtJP/h3IX6+8jPh94yKig44qz1V//IYy67oaU5woQe+YYXEtI4d9jdfC7khmHP
         O0UQ==
X-Gm-Message-State: APjAAAUb7Jj/MsxmICO2/Yf3Jrzy6VxR8il2ihL5A57XHz7QWHZtvajy
	W6AF5xE/spL7pBXGRgajDNg=
X-Google-Smtp-Source: APXvYqzYil+3Ftso1TWpSV8095HGNQL/URTfcLD+HpGX4LAA48WZkM07V5HZ0EJt2GuXBL8qYa+EnA==
X-Received: by 2002:a63:b0b:: with SMTP id 11mr12676888pgl.445.1556347385725;
        Fri, 26 Apr 2019 23:43:05 -0700 (PDT)
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
Subject: [PATCH v6 02/24] x86/jump_label: Use text_poke_early() during early init
Date: Fri, 26 Apr 2019 16:22:41 -0700
Message-Id: <20190426232303.28381-3-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190426232303.28381-1-nadav.amit@gmail.com>
References: <20190426232303.28381-1-nadav.amit@gmail.com>

From: Nadav Amit <namit@vmware.com>

There is no apparent reason not to use text_poke_early() during
early-init, since no patching of code that might be on the stack is done
and only a single core is running.

This is required for the next patches that would set a temporary mm for
text poking, and this mm is only initialized after some static-keys are
enabled/disabled.

Cc: Andy Lutomirski <luto@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kernel/jump_label.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/jump_label.c b/arch/x86/kernel/jump_label.c
index f99bd26bd3f1..e7d8c636b228 100644
--- a/arch/x86/kernel/jump_label.c
+++ b/arch/x86/kernel/jump_label.c
@@ -50,7 +50,12 @@ static void __ref __jump_label_transform(struct jump_entry *entry,
 	jmp.offset = jump_entry_target(entry) -
 		     (jump_entry_code(entry) + JUMP_LABEL_NOP_SIZE);
 
-	if (early_boot_irqs_disabled)
+	/*
+	 * As long as only a single processor is running and the code is still
+	 * not marked as RO, text_poke_early() can be used; Checking that
+	 * system_state is SYSTEM_BOOTING guarantees it.
+	 */
+	if (system_state == SYSTEM_BOOTING)
 		poker = text_poke_early;
 
 	if (type == JUMP_LABEL_JMP) {
-- 
2.17.1

