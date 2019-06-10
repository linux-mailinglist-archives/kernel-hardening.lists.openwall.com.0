Return-Path: <kernel-hardening-return-16084-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 29DA93BD74
	for <lists+kernel-hardening@lfdr.de>; Mon, 10 Jun 2019 22:26:38 +0200 (CEST)
Received: (qmail 1890 invoked by uid 550); 10 Jun 2019 20:25:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1732 invoked from network); 10 Jun 2019 20:25:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560198339;
	bh=WF3B/aIvuBdm+TMuhD75MVtaeujW0nD0b49/HCAzAx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQ7uBkPmm2NRfTUnxryyvHfccHzhoRYcH+tt4Js/wI0zGOgLM4ihUQ6XTTPBDh3qz
	 zwVlymP8S6YM6g9EnnK1XBYMG2dVLTK5jP2fDHlHKkQ8mzWxDIy6E07dqrh56l+dXD
	 lIwZ9ETQix+o3sTzfsZnXeMoLHoHN/noZ4FdxeH8=
From: Andy Lutomirski <luto@kernel.org>
To: x86@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Borislav Petkov <bp@alien8.de>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 5/5] x86/vsyscall: Change the default vsyscall mode to xonly
Date: Mon, 10 Jun 2019 13:25:31 -0700
Message-Id: <25fd7036cefca16c68ecd990e05e05a8ad8fe8b2.1560198181.git.luto@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1560198181.git.luto@kernel.org>
References: <cover.1560198181.git.luto@kernel.org>
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
index 054033cc4b1b..e56f33e6b045 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2280,7 +2280,7 @@ config COMPAT_VDSO
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

