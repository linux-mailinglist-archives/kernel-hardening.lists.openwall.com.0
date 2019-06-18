Return-Path: <kernel-hardening-return-16174-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 577DC49879
	for <lists+kernel-hardening@lfdr.de>; Tue, 18 Jun 2019 06:55:56 +0200 (CEST)
Received: (qmail 19900 invoked by uid 550); 18 Jun 2019 04:55:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19769 invoked from network); 18 Jun 2019 04:55:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qnStX17gprC4EO3JslfOKqvuRlw//DOp35gcW3WHxCs=;
        b=QFjbYmGJrCOeph3wo/lPROf1twpnMNCBoCurylkTc1w+8wzef3vU05t7FapRwubwqZ
         Ld2fdhXxahLeFTTSVZ2EQ8KnI1JjFdknbkYfZXN4dW2wR3ik0yl1ZEsbXa2nA/rxfUbT
         wPySjJ6fbla/F11m/fH6O6VN2PwJBuzlxdUTk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qnStX17gprC4EO3JslfOKqvuRlw//DOp35gcW3WHxCs=;
        b=hZ6X5DsHPLGSN2PGyXTacsR1aUWSsCqzxDQLZzbeEkRy6nv7Y0qdp0wPgFZoTxgzwk
         2wkh9oxV34VGurOBblwL0vc4XAZVEAt9MiLWGETlMchmG+0YcFCUtRIg5rLtDfEPpiKw
         SrcbMJImY3G9TuzB7wQphcwRRJ07E74E57pwfdkEzTeN3Ti/hvbAEFVZYyLZDYnb1xal
         geD19qf//wCT5PDsU8BegCfDMXg86CbLoseI77uT7xxPBdVHzViWksWoNf40TYYgVDWG
         BqsMHLcHR2sKZcvH/U4UQPaYrj8QGWJCn0qnfQglDovJKbNTymFrXjV7I3zXXEIaxAf9
         Kqfg==
X-Gm-Message-State: APjAAAWEsNtJX391i1YKY3BWzXM34yR+VqybzquNgKDIScGLoaznaG8v
	uo9uzIjgJQyrL/A+DB8obY8cRA==
X-Google-Smtp-Source: APXvYqzegS8FdaYYJ9tUvTEawroRiXm2ywlT9vgjrGEqGUYD2udBCjG/A1A/lyVqmE62G1Ui+eNFbQ==
X-Received: by 2002:aa7:86c6:: with SMTP id h6mr81450477pfo.51.1560833709869;
        Mon, 17 Jun 2019 21:55:09 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	x86@kernel.org,
	Peter Zijlstra <peterz@infradead.org>,
	Dave Hansen <dave.hansen@intel.com>,
	linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: [PATCH v3 1/3] lkdtm: Check for SMEP clearing protections
Date: Mon, 17 Jun 2019 21:55:01 -0700
Message-Id: <20190618045503.39105-2-keescook@chromium.org>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190618045503.39105-1-keescook@chromium.org>
References: <20190618045503.39105-1-keescook@chromium.org>

This adds an x86-specific test for pinned cr4 bits. A successful test
will validate pinning and check the ROP-style call-middle-of-function
defense, if needed. For example, in the case of native_write_cr4()
looking like this:

ffffffff8171bce0 <native_write_cr4>:
ffffffff8171bce0:       48 8b 35 79 46 f2 00    mov    0xf24679(%rip),%rsi
ffffffff8171bce7:       48 09 f7                or     %rsi,%rdi
ffffffff8171bcea:       0f 22 e7                mov    %rdi,%cr4
...
ffffffff8171bd5a:       c3                      retq

The UNSET_SMEP test will jump to ffffffff8171bcea (the mov to cr4)
instead of ffffffff8171bce0 (native_write_cr4() entry) to simulate a
direct-call bypass attempt.

Expected successful results:

  # echo UNSET_SMEP > /sys/kernel/debug/provoke-crash/DIRECT
  # dmesg
  [   79.594433] lkdtm: Performing direct entry UNSET_SMEP
  [   79.596459] lkdtm: trying to clear SMEP normally
  [   79.601810] ------------[ cut here ]------------
  [   79.603421] Attempt to unpin cr4 bits: 100000; bypass attack?!
  ...
  [   79.650170] ---[ end trace 2452ca0f6126242e ]---
  [   79.652281] lkdtm: ok: SMEP did not get cleared
  [   79.654344] lkdtm: trying to clear SMEP with call gadget
  [   79.655937] lkdtm: ok: SMEP removal was reverted

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/misc/lkdtm/bugs.c  | 66 ++++++++++++++++++++++++++++++++++++++
 drivers/misc/lkdtm/core.c  |  1 +
 drivers/misc/lkdtm/lkdtm.h |  1 +
 3 files changed, 68 insertions(+)

diff --git a/drivers/misc/lkdtm/bugs.c b/drivers/misc/lkdtm/bugs.c
index 7eebbdfbcacd..3edf4464b9fc 100644
--- a/drivers/misc/lkdtm/bugs.c
+++ b/drivers/misc/lkdtm/bugs.c
@@ -255,3 +255,69 @@ void lkdtm_STACK_GUARD_PAGE_TRAILING(void)
 
 	pr_err("FAIL: accessed page after stack!\n");
 }
+
+void lkdtm_UNSET_SMEP(void)
+{
+#ifdef CONFIG_X86_64
+#define MOV_CR4_DEPTH	64
+	void (*direct_write_cr4)(unsigned long val);
+	unsigned char *insn;
+	unsigned long cr4;
+	int i;
+
+	cr4 = native_read_cr4();
+
+	if ((cr4 & X86_CR4_SMEP) != X86_CR4_SMEP) {
+		pr_err("FAIL: SMEP not in use\n");
+		return;
+	}
+	cr4 &= ~(X86_CR4_SMEP);
+
+	pr_info("trying to clear SMEP normally\n");
+	native_write_cr4(cr4);
+	if (cr4 == native_read_cr4()) {
+		pr_err("FAIL: pinning SMEP failed!\n");
+		cr4 |= X86_CR4_SMEP;
+		pr_info("restoring SMEP\n");
+		native_write_cr4(cr4);
+		return;
+	}
+	pr_info("ok: SMEP did not get cleared\n");
+
+	/*
+	 * To test the post-write pinning verification we need to call
+	 * directly into the the middle of native_write_cr4() where the
+	 * cr4 write happens, skipping the pinning. This searches for
+	 * the cr4 writing instruction.
+	 */
+	insn = (unsigned char *)native_write_cr4;
+	for (i = 0; i < MOV_CR4_DEPTH; i++) {
+		/* mov %rdi, %cr4 */
+		if (insn[i] == 0x0f && insn[i+1] == 0x22 && insn[i+2] == 0xe7)
+			break;
+		/* mov %rdi,%rax; mov %rax, %cr4 */
+		if (insn[i]   == 0x48 && insn[i+1] == 0x89 &&
+		    insn[i+2] == 0xf8 && insn[i+3] == 0x0f &&
+		    insn[i+4] == 0x22 && insn[i+5] == 0xe0)
+			break;
+	}
+	if (i >= MOV_CR4_DEPTH) {
+		pr_info("ok: cannot locate cr4 writing call gadget\n");
+		return;
+	}
+	direct_write_cr4 = (void *)(insn + i);
+
+	pr_info("trying to clear SMEP with call gadget\n");
+	direct_write_cr4(cr4);
+	if (native_read_cr4() & X86_CR4_SMEP) {
+		pr_info("ok: SMEP removal was reverted\n");
+	} else {
+		pr_err("FAIL: cleared SMEP not detected!\n");
+		cr4 |= X86_CR4_SMEP;
+		pr_info("restoring SMEP\n");
+		native_write_cr4(cr4);
+	}
+#else
+	pr_err("FAIL: this test is x86_64-only\n");
+#endif
+}
diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
index b51cf182b031..58cfd713f8dc 100644
--- a/drivers/misc/lkdtm/core.c
+++ b/drivers/misc/lkdtm/core.c
@@ -123,6 +123,7 @@ static const struct crashtype crashtypes[] = {
 	CRASHTYPE(CORRUPT_LIST_ADD),
 	CRASHTYPE(CORRUPT_LIST_DEL),
 	CRASHTYPE(CORRUPT_USER_DS),
+	CRASHTYPE(UNSET_SMEP),
 	CRASHTYPE(CORRUPT_STACK),
 	CRASHTYPE(CORRUPT_STACK_STRONG),
 	CRASHTYPE(STACK_GUARD_PAGE_LEADING),
diff --git a/drivers/misc/lkdtm/lkdtm.h b/drivers/misc/lkdtm/lkdtm.h
index b69ee004a3f7..d7eb5a8f1da4 100644
--- a/drivers/misc/lkdtm/lkdtm.h
+++ b/drivers/misc/lkdtm/lkdtm.h
@@ -26,6 +26,7 @@ void lkdtm_CORRUPT_LIST_DEL(void);
 void lkdtm_CORRUPT_USER_DS(void);
 void lkdtm_STACK_GUARD_PAGE_LEADING(void);
 void lkdtm_STACK_GUARD_PAGE_TRAILING(void);
+void lkdtm_UNSET_SMEP(void);
 
 /* lkdtm_heap.c */
 void lkdtm_OVERWRITE_ALLOCATION(void);
-- 
2.17.1

