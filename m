Return-Path: <kernel-hardening-return-17899-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BEFD416B8D5
	for <lists+kernel-hardening@lfdr.de>; Tue, 25 Feb 2020 06:13:45 +0100 (CET)
Received: (qmail 7435 invoked by uid 550); 25 Feb 2020 05:13:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7359 invoked from network); 25 Feb 2020 05:13:25 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xtFhZmUGg25ckYL+Nj/gQvxOaU7nm2sSSfbBJDheRi8=;
        b=cYoKF8t4ZKo9npvA7QP9XflS8FuxXhlRBK6xAEmgOI8SDB3qsyrUamZa+IZxIQeHEl
         hic9kuq1J+X/MvlwBhVTB5UE5AibQJRe0f4VCVIgnILVgGTTdcdSXyNKEVybEbiEpVNI
         KIqP3vXsNrYdk9Oin86blNR1kimWfFn+e1wBs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xtFhZmUGg25ckYL+Nj/gQvxOaU7nm2sSSfbBJDheRi8=;
        b=TBGKJi4pKBDf3sfZH5DYR4ehjHULMrTeNH7GowodgMDzFyqC/pnd0LlNb7hQX97hiA
         c4ABLCf4rqp+wdmglJRwVo7OIE+Kbs96RJWC8vvPvH8s8miaAaCnuuTf0ClUCfgQwdP7
         2K81I+bLVGd/UDTpuX9xgTb741+pdpd2Tk1mKKq0pRFF/sAi7c/VOmnoBwwJnUEYz8Vp
         FfC6dt4FXF6Z/guL0xgr5cgXAAoB1p6slDmWS1OX3n9qM2Yp/v+VUMl0CW+1YJ03aE/w
         dGtNt1N44+riN2HGCqTPFWNk9vpUvQH2vx/HqsLgRHvvINbS3hjaz9ANdd3UlIsmyG19
         Jz9Q==
X-Gm-Message-State: APjAAAUX0A2/lOxcHkdl360dKSU6alnosFUKEMmJRGGIHEOCRa6p6mta
	/fwOhiD1ZrkqJdoWyb+rIB5uiA==
X-Google-Smtp-Source: APXvYqwODtU4FUfT5WxcMcB9c17YZwUi3dfzZeLH4lgWsLytNLFPaPcQmbSyyLc8Ik4xhECJhuDusg==
X-Received: by 2002:a63:d40d:: with SMTP id a13mr57785788pgh.9.1582607593779;
        Mon, 24 Feb 2020 21:13:13 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Kees Cook <keescook@chromium.org>,
	Hector Marco-Gisbert <hecmargi@upv.es>,
	Jason Gunthorpe <jgg@mellanox.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Russell King <linux@armlinux.org.uk>,
	Will Deacon <will@kernel.org>,
	Jann Horn <jannh@google.com>,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 2/6] x86/elf: Split READ_IMPLIES_EXEC from executable GNU_STACK
Date: Mon, 24 Feb 2020 21:13:03 -0800
Message-Id: <20200225051307.6401-3-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200225051307.6401-1-keescook@chromium.org>
References: <20200225051307.6401-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The READ_IMPLIES_EXEC work-around was designed for old toolchains that
lacked the ELF PT_GNU_STACK marking under the assumption that toolchains
that couldn't specify executable permission flags for the stack may not
know how to do it correctly for any memory region.

This logic is sensible for having ancient binaries coexist in a system
with possibly NX memory, but was implemented in a way that equated having
a PT_GNU_STACK marked executable as being as "broken" as lacking the
PT_GNU_STACK marking entirely. Things like unmarked assembly and stack
trampolines may cause PT_GNU_STACK to need an executable bit, but they
do not imply all mappings must be executable.

This confusion has led to situations where modern programs with explicitly
marked executable stack are forced into the READ_IMPLIES_EXEC state when
no such thing is needed. (And leads to unexpected failures when mmap()ing
regions of device driver memory that wish to disallow VM_EXEC[1].)

In looking for other reasons for the READ_IMPLIES_EXEC behavior, Jann
Horn noted that glibc thread stacks have always been marked RWX (until
2003 when they started tracking the PT_GNU_STACK flag instead[2]). And
musl doesn't support executable stacks at all[3]. As such, no breakage
for multithreaded applications is expected from this change.

[1] https://lkml.kernel.org/r/20190418055759.GA3155@mellanox.com
[2] https://sourceware.org/git/?p=glibc.git;a=commitdiff;h=54ee14b3882
[3] https://lkml.kernel.org/r/20190423192534.GN23599@brightrain.aerifal.cx

Suggested-by: Hector Marco-Gisbert <hecmargi@upv.es>
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
---
 arch/x86/include/asm/elf.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/elf.h b/arch/x86/include/asm/elf.h
index 733f69c2b053..a7035065377c 100644
--- a/arch/x86/include/asm/elf.h
+++ b/arch/x86/include/asm/elf.h
@@ -288,12 +288,13 @@ extern u32 elf_hwcap2;
  * ELF:              |            |                  |                |
  * -------------------------------|------------------|----------------|
  * missing GNU_STACK | exec-all   | exec-all         | exec-all       |
- * GNU_STACK == RWX  | exec-all   | exec-all         | exec-all       |
+ * GNU_STACK == RWX  | exec-stack | exec-stack       | exec-stack     |
  * GNU_STACK == RW   | exec-none  | exec-none        | exec-none      |
  *
  *  exec-all  : all PROT_READ user mappings are executable, except when
  *              backed by files on a noexec-filesystem.
  *  exec-none : only PROT_EXEC user mappings are executable.
+ *  exec-stack: only the stack and PROT_EXEC user mappings are executable.
  *
  *  *this column has no architectural effect: NX markings are ignored by
  *   hardware, but may have behavioral effects when "wants X" collides with
@@ -302,7 +303,7 @@ extern u32 elf_hwcap2;
  *
  */
 #define elf_read_implies_exec(ex, executable_stack)	\
-	(executable_stack != EXSTACK_DISABLE_X)
+	(executable_stack == EXSTACK_DEFAULT)
 
 struct task_struct;
 
-- 
2.20.1

