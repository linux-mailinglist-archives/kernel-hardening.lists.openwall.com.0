Return-Path: <kernel-hardening-return-16277-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 31B3C57ACE
	for <lists+kernel-hardening@lfdr.de>; Thu, 27 Jun 2019 06:46:13 +0200 (CEST)
Received: (qmail 11652 invoked by uid 550); 27 Jun 2019 04:45:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11547 invoked from network); 27 Jun 2019 04:45:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561610716;
	bh=p0mSFH+GsDKccYokNQY9U5gFq0x5WNQ6S5PD+LrfzU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uTh283EjoVkYy8NYAmHw6r4YbdNzOsWbgk48fBEV6zvVhTbiIdzHO+cnht4qUMwtD
	 zk40Sv7qMUg18O4CIkzLoc1SPy570E0YH+DLSt55jrWGUF0kG2pR9AABVMR6EAHz/Q
	 EVlF5gCHp6nSkDa08EkHw7r8W3hop8vqnwjaCus4=
From: Andy Lutomirski <luto@kernel.org>
To: x86@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Florian Weimer <fweimer@redhat.com>,
	Jann Horn <jannh@google.com>,
	Andy Lutomirski <luto@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2 6/8] x86/vsyscall: Change the default vsyscall mode to xonly
Date: Wed, 26 Jun 2019 21:45:07 -0700
Message-Id: <30539f8072d2376b9c9efcc07e6ed0d6bf20e882.1561610354.git.luto@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1561610354.git.luto@kernel.org>
References: <cover.1561610354.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The use case for full emulation over xonly is very esoteric.  Let's
change the default to the safer xonly mode.

Cc: Kees Cook <keescook@chromium.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0182d2c67590..32028edc1b0e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2285,7 +2285,7 @@ config COMPAT_VDSO
 choice
 	prompt "vsyscall table for legacy applications"
 	depends on X86_64
-	default LEGACY_VSYSCALL_EMULATE
+	default LEGACY_VSYSCALL_XONLY
 	help
 	  Legacy user code that does not know how to find the vDSO expects
 	  to be able to issue three syscalls by calling fixed addresses in
-- 
2.21.0

