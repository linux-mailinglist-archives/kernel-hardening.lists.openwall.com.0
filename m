Return-Path: <kernel-hardening-return-16080-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 072E83BD69
	for <lists+kernel-hardening@lfdr.de>; Mon, 10 Jun 2019 22:26:01 +0200 (CEST)
Received: (qmail 1702 invoked by uid 550); 10 Jun 2019 20:25:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1652 invoked from network); 10 Jun 2019 20:25:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1560198337;
	bh=mMMMbSywgNKmt8zD+czRSCY41kftddjxk0jgfQZgDoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ry+dHPkohHJXU/EtZM/nMdvNPZ3LdPqY7AkC9L21t/ULnbWtaQDx0klPtiCpQOj5t
	 FI3blDhYWzaZzdU3T42yaXASzTtKsTlgWh8mIwK56TcEBaBCCfYMOFuOWVERoJU0Ts
	 MQoAPkLD/6yijkUNela25mdzoFq8aSc402ks7Zwo=
From: Andy Lutomirski <luto@kernel.org>
To: x86@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	stable@vger.kernel.org,
	Kees Cook <keescook@chromium.org>,
	Borislav Petkov <bp@alien8.de>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 1/5] x86/vsyscall: Remove the vsyscall=native documentation
Date: Mon, 10 Jun 2019 13:25:27 -0700
Message-Id: <a94d462c458a165bfa6ff3a5da4e9d744e917c09.1560198181.git.luto@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1560198181.git.luto@kernel.org>
References: <cover.1560198181.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The vsyscall=native feature is gone -- remove the docs.

Fixes: 076ca272a14c ("x86/vsyscall/64: Drop "native" vsyscalls")
Cc: stable@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 43176340c73d..e1a3525d07f2 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5086,12 +5086,6 @@
 			emulate     [default] Vsyscalls turn into traps and are
 			            emulated reasonably safely.
 
-			native      Vsyscalls are native syscall instructions.
-			            This is a little bit faster than trapping
-			            and makes a few dynamic recompilers work
-			            better than they would in emulation mode.
-			            It also makes exploits much easier to write.
-
 			none        Vsyscalls don't work at all.  This makes
 			            them quite hard to use for exploits but
 			            might break your system.
-- 
2.21.0

