Return-Path: <kernel-hardening-return-17902-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3C57A16B8DC
	for <lists+kernel-hardening@lfdr.de>; Tue, 25 Feb 2020 06:14:10 +0100 (CET)
Received: (qmail 7582 invoked by uid 550); 25 Feb 2020 05:13:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7493 invoked from network); 25 Feb 2020 05:13:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QU6tarMcleK7JZEKv6NGFcAaaMn8J85o/O86pl2boI8=;
        b=DcHSUo+5uhomdqc7fCqlU3p2aWJnrlaigJaUEKSmf+9FQuRxJNZKzo7AgMVRkj+enj
         PYAibvmj1Z4N2moDH7SYmegC9w9CQ+j3GWVpJV9v6+s1bSScng2s38DzUzJ80Wqsf+5R
         8k71AqQfgLS9wzWOi0XFRsHjemnvNdL8m/Jzs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QU6tarMcleK7JZEKv6NGFcAaaMn8J85o/O86pl2boI8=;
        b=BVW+YHmUwortsYp7SjT5wiolRp1EMOqW1y0SlAMubXlIb/bQAcYP7IE/t0kddjj0W1
         bMpiWcwVm7IQ8RVnAgR33PpbKNnsHz5knRRop9c36r9IVB6mbNh+yaFkLarIQMEIyfwj
         aZFM6BB+Z+5vrh+wDYPum9jPE4Z0KDqesjpdrYBx56IgT3nWwciwoHpvFFn2GYVgt7j0
         KSmKk1rsq5ZxhrD8ZPwtLnuxd2eNkB0mwO+bfo2UTg+egKHYFuMiGrcRYs7TMmUcJvQR
         nhORxX06YINcWDxy9bOWKT8dALzxVLKlPjQhWs+4i7iwXGsLssRsaWL3Y/mIceYDK3VZ
         oT4w==
X-Gm-Message-State: APjAAAXRqiK0bOYT/seaAF2uREG7e3NBpdEavSJZ5R0oWE1HFhXiTEXT
	O7WZIaQ55UEAb87PVXdTTbNopQ==
X-Google-Smtp-Source: APXvYqzirNh6rCEGPBMMTd96cFvNHpeUqARTXcwmJmqfs1UtEUIGNuIRJqZRDNbnRdSDNFi3a6YNbQ==
X-Received: by 2002:aa7:9e0b:: with SMTP id y11mr57940549pfq.182.1582607595420;
        Mon, 24 Feb 2020 21:13:15 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Kees Cook <keescook@chromium.org>,
	Jason Gunthorpe <jgg@mellanox.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Hector Marco-Gisbert <hecmargi@upv.es>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Russell King <linux@armlinux.org.uk>,
	Will Deacon <will@kernel.org>,
	Jann Horn <jannh@google.com>,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 4/6] arm32/64, elf: Add tables to document READ_IMPLIES_EXEC
Date: Mon, 24 Feb 2020 21:13:05 -0800
Message-Id: <20200225051307.6401-5-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200225051307.6401-1-keescook@chromium.org>
References: <20200225051307.6401-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add tables to document the current behavior of READ_IMPLIES_EXEC in
preparation for changing the behavior for both arm64 and arm.

Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm/kernel/elf.c        | 24 +++++++++++++++++++++---
 arch/arm64/include/asm/elf.h | 20 ++++++++++++++++++++
 2 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/elf.c b/arch/arm/kernel/elf.c
index 182422981386..2f69cf978fe3 100644
--- a/arch/arm/kernel/elf.c
+++ b/arch/arm/kernel/elf.c
@@ -78,9 +78,27 @@ void elf_set_personality(const struct elf32_hdr *x)
 EXPORT_SYMBOL(elf_set_personality);
 
 /*
- * Set READ_IMPLIES_EXEC if:
- *  - the binary requires an executable stack
- *  - we're running on a CPU which doesn't support NX.
+ * An executable for which elf_read_implies_exec() returns TRUE will
+ * have the READ_IMPLIES_EXEC personality flag set automatically.
+ *
+ * The decision process for determining the results are:
+ *
+ *              CPU: | lacks NX*  | has NX     |
+ * ELF:              |            |            |
+ * -------------------------------|------------|
+ * missing GNU_STACK | exec-all   | exec-all   |
+ * GNU_STACK == RWX  | exec-all   | exec-all   |
+ * GNU_STACK == RW   | exec-all   | exec-none  |
+ *
+ *  exec-all  : all PROT_READ user mappings are executable, except when
+ *              backed by files on a noexec-filesystem.
+ *  exec-none : only PROT_EXEC user mappings are executable.
+ *
+ *  *this column has no architectural effect: NX markings are ignored by
+ *   hardware, but may have behavioral effects when "wants X" collides with
+ *   "cannot be X" constraints in memory permission flags, as in
+ *   https://lkml.kernel.org/r/20190418055759.GA3155@mellanox.com
+ *
  */
 int arm_elf_read_implies_exec(int executable_stack)
 {
diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index b618017205a3..7fc779e3f1ec 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -96,6 +96,26 @@
  */
 #define elf_check_arch(x)		((x)->e_machine == EM_AARCH64)
 
+/*
+ * An executable for which elf_read_implies_exec() returns TRUE will
+ * have the READ_IMPLIES_EXEC personality flag set automatically.
+ *
+ * The decision process for determining the results are:
+ *
+ *             CPU*: | arm32      | arm64      |
+ * ELF:              |            |            |
+ * -------------------------------|------------|
+ * missing GNU_STACK | exec-all   | exec-all   |
+ * GNU_STACK == RWX  | exec-all   | exec-all   |
+ * GNU_STACK == RW   | exec-none  | exec-none  |
+ *
+ *  exec-all  : all PROT_READ user mappings are executable, except when
+ *              backed by files on a noexec-filesystem.
+ *  exec-none : only PROT_EXEC user mappings are executable.
+ *
+ *  *all arm64 CPUs support NX, so there is no "lacks NX" column.
+ *
+ */
 #define elf_read_implies_exec(ex,stk)	(stk != EXSTACK_DISABLE_X)
 
 #define CORE_DUMP_USE_REGSET
-- 
2.20.1

