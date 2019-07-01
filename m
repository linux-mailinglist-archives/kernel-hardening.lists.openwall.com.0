Return-Path: <kernel-hardening-return-16279-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 81D2957AD1
	for <lists+kernel-hardening@lfdr.de>; Thu, 27 Jun 2019 06:46:33 +0200 (CEST)
Received: (qmail 13564 invoked by uid 550); 27 Jun 2019 04:45:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13381 invoked from network); 27 Jun 2019 04:45:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561610716;
	bh=It8qNuorDHkN++30w/QRv2Qr7Cixz/gz1T4PqMIF4Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/S1g6tA36w5ZCGiw3DETjmxkhfWf0/8H4PK/ziyQkxVJCNMsRDQT/INUuLD/N/j/
	 vsRGwWDvAJ+aHq51RKzHWxsT6vVnXdZN9qZqIwHHw4E9mLLZa/tYI1tfURMEeUQ+P9
	 4OnNX7VYmYUw6ad95mECRjcB0g4vGLkbOjg+122c=
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
Subject: [PATCH v2 7/8] x86/vsyscall: Add __ro_after_init to global variables
Date: Wed, 26 Jun 2019 21:45:08 -0700
Message-Id: <a386925835e49d319e70c4d7404b1f6c3c2e3702.1561610354.git.luto@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1561610354.git.luto@kernel.org>
References: <cover.1561610354.git.luto@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The vDSO is only configurable by command-line options, so make its
global variables __ro_after_init.  This seems highly unlikely to
ever stop an exploit, but I think it's nice anyway.

Cc: Kees Cook <keescook@chromium.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 arch/x86/entry/vsyscall/vsyscall_64.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/entry/vsyscall/vsyscall_64.c b/arch/x86/entry/vsyscall/vsyscall_64.c
index 9c58ab807aeb..07003f3f1bfc 100644
--- a/arch/x86/entry/vsyscall/vsyscall_64.c
+++ b/arch/x86/entry/vsyscall/vsyscall_64.c
@@ -42,7 +42,7 @@
 #define CREATE_TRACE_POINTS
 #include "vsyscall_trace.h"
 
-static enum { EMULATE, XONLY, NONE } vsyscall_mode =
+static enum { EMULATE, XONLY, NONE } vsyscall_mode __ro_after_init =
 #ifdef CONFIG_LEGACY_VSYSCALL_NONE
 	NONE;
 #elif defined(CONFIG_LEGACY_VSYSCALL_XONLY)
@@ -305,7 +305,7 @@ static const char *gate_vma_name(struct vm_area_struct *vma)
 static const struct vm_operations_struct gate_vma_ops = {
 	.name = gate_vma_name,
 };
-static struct vm_area_struct gate_vma = {
+static struct vm_area_struct gate_vma __ro_after_init = {
 	.vm_start	= VSYSCALL_ADDR,
 	.vm_end		= VSYSCALL_ADDR + PAGE_SIZE,
 	.vm_page_prot	= PAGE_READONLY_EXEC,
-- 
2.21.0

