Return-Path: <kernel-hardening-return-21527-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4EA85485660
	for <lists+kernel-hardening@lfdr.de>; Wed,  5 Jan 2022 17:03:25 +0100 (CET)
Received: (qmail 3674 invoked by uid 550); 5 Jan 2022 16:03:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3651 invoked from network); 5 Jan 2022 16:03:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1641398583;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=u480/OJwej/j4wzpGe245oMyGEylv5FGLU/iblhaqfE=;
	b=DBIiaMpLbObhJg+8kvMUlW6avXSq7VRHEpPFcr329lqR7+sjhd1HEx/xHxFIatSS6G+qW8
	XYx6LX5liF5CeIW1pdgaFvcaNlV/x3l9NDAyaexz1QaI+QPFuRaa4EOO2RClmPV2C8CVqt
	sA8F0wfJOkhFFvcE2NRS+zvWuhbuiFA=
X-MC-Unique: t5IN1CUtOdmuiemFARbXUw-1
From: Florian Weimer <fweimer@redhat.com>
To: "Andy Lutomirski" <luto@kernel.org>
Cc: linux-arch@vger.kernel.org,
        "Linux API" <linux-api@vger.kernel.org>,
        linux-x86_64@vger.kernel.org, kernel-hardening@lists.openwall.com,
        linux-mm@kvack.org, "the arch/x86 maintainers" <x86@kernel.org>,
        musl@lists.openwall.com, <libc-alpha@sourceware.org>,
        <linux-kernel@vger.kernel.org>,
        "Dave Hansen" <dave.hansen@intel.com>,
        "Kees Cook" <keescook@chromium.org>, Andrei Vagin <avagin@gmail.com>
Subject: [PATCH v3 1/3] x86: Implement arch_prctl(ARCH_VSYSCALL_CONTROL) to
 disable vsyscall
X-From-Line: 3a1c8280967b491bf6917a18fbff6c9b52e8df24 Mon Sep 17 00:00:00 2001
Message-Id: <3a1c8280967b491bf6917a18fbff6c9b52e8df24.1641398395.git.fweimer@redhat.com>
Date: Wed, 05 Jan 2022 17:02:48 +0100
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11

Distributions struggle with changing the default for vsyscall
emulation because it is a clear break of userspace ABI, something
that should not happen.

The legacy vsyscall interface is supposed to be used by libcs only,
not by applications.  This commit adds a new arch_prctl request,
ARCH_VSYSCALL_CONTROL, with one argument.  If the argument is 0,
executing vsyscalls will cause the process to terminate.  Argument 1
turns vsyscall back on (this is mostly for a largely theoretical
CRIU use case).

Newer libcs can use a zero ARCH_VSYSCALL_CONTROL at startup to disable
vsyscall for the process.  Legacy libcs do not perform this call, so
vsyscall remains enabled for them.  This approach should achieves
backwards compatibility (perfect compatibility if the assumption that
only libcs use vsyscall is accurate), and it provides full hardening
for new binaries.

The chosen value of ARCH_VSYSCALL_CONTROL should avoid conflicts
with other x86-64 arch_prctl requests.  The fact that with
vsyscall=emulate, reading the vsyscall region is still possible
even after a zero ARCH_VSYSCALL_CONTROL is considered limitation
in the current implementation and may change in a future kernel
version.

Future arch_prctls requests commonly used at process startup can imply
ARCH_VSYSCALL_CONTROL with a zero argument, so that a separate system
call for disabling vsyscall is avoided.

Signed-off-by: Florian Weimer <fweimer@redhat.com>
Acked-by: Andrei Vagin <avagin@gmail.com>
---
v3: Remove warning log message.  Split out test.
v2: ARCH_VSYSCALL_CONTROL instead of ARCH_VSYSCALL_LOCKOUT.  New tests
    for the toggle behavior.  Implement hiding [vsyscall] in
    /proc/PID/maps and test it.  Various other test fixes cleanups
    (e.g., fixed missing second argument to gettimeofday).

arch/x86/entry/vsyscall/vsyscall_64.c | 7 ++++++-
 arch/x86/include/asm/mmu.h            | 6 ++++++
 arch/x86/include/uapi/asm/prctl.h     | 2 ++
 arch/x86/kernel/process_64.c          | 7 +++++++
 4 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/vsyscall/vsyscall_64.c b/arch/x86/entry/vsyscall/vsyscall_64.c
index fd2ee9408e91..6fc524b9f232 100644
--- a/arch/x86/entry/vsyscall/vsyscall_64.c
+++ b/arch/x86/entry/vsyscall/vsyscall_64.c
@@ -174,6 +174,9 @@ bool emulate_vsyscall(unsigned long error_code,
 
 	tsk = current;
 
+	if (tsk->mm->context.vsyscall_disabled)
+		goto sigsegv;
+
 	/*
 	 * Check for access_ok violations and find the syscall nr.
 	 *
@@ -316,8 +319,10 @@ static struct vm_area_struct gate_vma __ro_after_init = {
 
 struct vm_area_struct *get_gate_vma(struct mm_struct *mm)
 {
+	if (!mm || mm->context.vsyscall_disabled)
+		return NULL;
 #ifdef CONFIG_COMPAT
-	if (!mm || !(mm->context.flags & MM_CONTEXT_HAS_VSYSCALL))
+	if (!(mm->context.flags & MM_CONTEXT_HAS_VSYSCALL))
 		return NULL;
 #endif
 	if (vsyscall_mode == NONE)
diff --git a/arch/x86/include/asm/mmu.h b/arch/x86/include/asm/mmu.h
index 5d7494631ea9..3934d6907910 100644
--- a/arch/x86/include/asm/mmu.h
+++ b/arch/x86/include/asm/mmu.h
@@ -41,6 +41,12 @@ typedef struct {
 #ifdef CONFIG_X86_64
 	unsigned short flags;
 #endif
+#ifdef CONFIG_X86_VSYSCALL_EMULATION
+	/*
+	 * Changed by arch_prctl(ARCH_VSYSCALL_CONTROL).
+	 */
+	bool vsyscall_disabled;
+#endif
 
 	struct mutex lock;
 	void __user *vdso;			/* vdso base address */
diff --git a/arch/x86/include/uapi/asm/prctl.h b/arch/x86/include/uapi/asm/prctl.h
index 754a07856817..aad0bcfbf49f 100644
--- a/arch/x86/include/uapi/asm/prctl.h
+++ b/arch/x86/include/uapi/asm/prctl.h
@@ -18,4 +18,6 @@
 #define ARCH_MAP_VDSO_32	0x2002
 #define ARCH_MAP_VDSO_64	0x2003
 
+#define ARCH_VSYSCALL_CONTROL	0x5001
+
 #endif /* _ASM_X86_PRCTL_H */
diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 3402edec236c..834bad068211 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -816,6 +816,13 @@ long do_arch_prctl_64(struct task_struct *task, int option, unsigned long arg2)
 		ret = put_user(base, (unsigned long __user *)arg2);
 		break;
 	}
+#ifdef CONFIG_X86_VSYSCALL_EMULATION
+	case ARCH_VSYSCALL_CONTROL:
+		if (unlikely(arg2 > 1))
+			return -EINVAL;
+		current->mm->context.vsyscall_disabled = !arg2;
+		break;
+#endif
 
 #ifdef CONFIG_CHECKPOINT_RESTORE
 # ifdef CONFIG_X86_X32_ABI

base-commit: c9e6606c7fe92b50a02ce51dda82586ebdf99b48
-- 
2.33.1


