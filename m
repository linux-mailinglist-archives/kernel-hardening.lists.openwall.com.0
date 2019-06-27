Return-Path: <kernel-hardening-return-16309-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2DF5D58DBB
	for <lists+kernel-hardening@lfdr.de>; Fri, 28 Jun 2019 00:13:55 +0200 (CEST)
Received: (qmail 5191 invoked by uid 550); 27 Jun 2019 22:13:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5148 invoked from network); 27 Jun 2019 22:13:47 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 terminus.zytor.com x5RMDAoA472374
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2019061801; t=1561673591;
	bh=oNQW3R0Fq1NiXUpePESWOXF0yCeNhTbXhZSMVXdz8tQ=;
	h=Date:From:Cc:Reply-To:In-Reply-To:References:To:Subject:From;
	b=y2XCS2jvCKiQNHlwVKe5dqb3OTgDqs9KY+hVzZnPmh4mVzsHSeD4xYsVSIcqJkBp1
	 KxWoX82FRud2RH/hS0zTiQL8sYJdr8yp8O23xWWpza+65fIX8fiXXUKBdMpaACUtIn
	 brRmeOTVUzmXcfYTRgeqCtoPOKTi11OdyNEXAMlHMaPa8ltVgw2glK6j0Vc2olsP1V
	 cXTeZc2S+6W9GDwMnGqLcuyxTz2tgldtH20K+ekzx4vx3sRHXfUdiOnPAPF9uWRcJF
	 7yRT1PpOTb/hGzn5o9hOb4ELwIEsRoU1aeSiam8f32gALbrpZhRjNH4bPsqeGjza0o
	 HyD51RpVPFNeA==
Date: Thu, 27 Jun 2019 15:13:09 -0700
X-Authentication-Warning: terminus.zytor.com: tipbot set sender to tipbot@zytor.com using -f
Sender: tip tree robot <tipbot@zytor.com>
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-d974ffcfb7447db5f29a4b662a3eaf99a4e1109e@git.kernel.org>
Cc: bp@alien8.de, fweimer@redhat.com, jannh@google.com, hpa@zytor.com,
        kernel-hardening@lists.openwall.com, mingo@kernel.org, luto@kernel.org,
        tglx@linutronix.de, keescook@chromium.org,
        linux-kernel@vger.kernel.org, peterz@infradead.org
In-Reply-To: <d77c7105eb4c57c1a95a95b6a5b8ba194a18e764.1561610354.git.luto@kernel.org>
References: <d77c7105eb4c57c1a95a95b6a5b8ba194a18e764.1561610354.git.luto@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/entry] Documentation/admin: Remove the vsyscall=native
 documentation
Git-Commit-ID: d974ffcfb7447db5f29a4b662a3eaf99a4e1109e
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

Commit-ID:  d974ffcfb7447db5f29a4b662a3eaf99a4e1109e
Gitweb:     https://git.kernel.org/tip/d974ffcfb7447db5f29a4b662a3eaf99a4e1109e
Author:     Andy Lutomirski <luto@kernel.org>
AuthorDate: Wed, 26 Jun 2019 21:45:02 -0700
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Fri, 28 Jun 2019 00:04:38 +0200

Documentation/admin: Remove the vsyscall=native documentation

The vsyscall=native feature is gone -- remove the docs.

Fixes: 076ca272a14c ("x86/vsyscall/64: Drop "native" vsyscalls")
Signed-off-by: Andy Lutomirski <luto@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Kees Cook <keescook@chromium.org>
Cc: Florian Weimer <fweimer@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: stable@vger.kernel.org
Cc: Borislav Petkov <bp@alien8.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lkml.kernel.org/r/d77c7105eb4c57c1a95a95b6a5b8ba194a18e764.1561610354.git.luto@kernel.org

---
 Documentation/admin-guide/kernel-parameters.txt | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 138f6664b2e2..0082d1e56999 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5102,12 +5102,6 @@
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
