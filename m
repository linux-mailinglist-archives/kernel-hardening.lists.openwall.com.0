Return-Path: <kernel-hardening-return-16313-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F24C658DD2
	for <lists+kernel-hardening@lfdr.de>; Fri, 28 Jun 2019 00:17:18 +0200 (CEST)
Received: (qmail 13726 invoked by uid 550); 27 Jun 2019 22:17:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13706 invoked from network); 27 Jun 2019 22:17:13 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x5RMGj8G472980
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2019061801; t=1561673805;
	bh=VFPlr7z446ew55w9RrWZ1FYQcMz8mUVYmeBMeGKrGqU=;
	h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
	b=jMoOlj3q2n+hhV4eg4/pdyrOT3L/z8e4WkCmbilmkMfnmUQIWyx2iEQZjeiMYgqa2
	 JHcRJ4lkb4/hZXmot+S4eNqIXlrUPIlz53sNEBoMPINvQjvirSOyAvVLgnn265vZcb
	 OQ/PTtB3fyV7GSASxVOp3UgU1LA6KfDyRe4VB8TlEHhQasyKIg37knQdCK2313lx/n
	 5ST9TjuqvOzMoizFacGQdAGsW7/9u/aYiUbvt3GMBiV17S342h3AaKcUt3VN867dDV
	 scRgkAwEhx8xNDxll4a9j2xW4atcEePI8Ys1AhJnJVpWEAM7Kid7K4BfjDq/cWZdij
	 ZQShZzNAKF1kA==
Date: Thu, 27 Jun 2019 15:16:44 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
Sender: tip tree robot <tipbot@zytor.com>
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-625b7b7f79c66626fb2b7687fc1a58309a57edd5@git.kernel.org>
Cc: hpa@zytor.com, luto@kernel.org, peterz@infradead.org, tglx@linutronix.de,
        bp@alien8.de, fweimer@redhat.com, kernel-hardening@lists.openwall.com,
        mingo@kernel.org, linux-kernel@vger.kernel.org, keescook@chromium.org,
        jannh@google.com
In-Reply-To: <30539f8072d2376b9c9efcc07e6ed0d6bf20e882.1561610354.git.luto@kernel.org>
References: <30539f8072d2376b9c9efcc07e6ed0d6bf20e882.1561610354.git.luto@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/entry] x86/vsyscall: Change the default vsyscall mode to
 xonly
Git-Commit-ID: 625b7b7f79c66626fb2b7687fc1a58309a57edd5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from
 these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Spam-Status: No, score=0.1 required=5.0 tests=ALL_TRUSTED,BAYES_00,
	DATE_IN_FUTURE_12_24,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	DKIM_VALID_EF autolearn=no autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on terminus.zytor.com

Commit-ID:  625b7b7f79c66626fb2b7687fc1a58309a57edd5
Gitweb:     https://git.kernel.org/tip/625b7b7f79c66626fb2b7687fc1a58309a57edd5
Author:     Andy Lutomirski <luto@kernel.org>
AuthorDate: Wed, 26 Jun 2019 21:45:07 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 28 Jun 2019 00:04:39 +0200

x86/vsyscall: Change the default vsyscall mode to xonly

The use case for full emulation over xonly is very esoteric, e.g. magic
instrumentation tools.

Change the default to the safer xonly mode.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lkml.kernel.org/r/30539f8072d2376b9c9efcc07e6ed0d6bf20e882.1561610354.git.luto@kernel.org

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
