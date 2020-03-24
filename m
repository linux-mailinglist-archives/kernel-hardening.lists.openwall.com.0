Return-Path: <kernel-hardening-return-18196-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4C2C3191B10
	for <lists+kernel-hardening@lfdr.de>; Tue, 24 Mar 2020 21:33:17 +0100 (CET)
Received: (qmail 17961 invoked by uid 550); 24 Mar 2020 20:32:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17674 invoked from network); 24 Mar 2020 20:32:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZpbSabNgeqQFGGWbdjXwu6Z/5tgvjlUVk+jmvcDMVbI=;
        b=UJ8E9FEM21rF2t4iJN9KMT1vZeOgYW14fs4KJlrdkYrKJPObtDcxrT3UbkXZ4CUJOk
         k5th1fbqGRozvVjSrW5ZXd88KFy9869kIJa1egEs+lGJlGxXxyC+gMfluZ8Ky7z1BhFG
         U4Ls0yMLPD3BnrUhkq067AdPvN+XlfPgSUjak=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZpbSabNgeqQFGGWbdjXwu6Z/5tgvjlUVk+jmvcDMVbI=;
        b=XV/j3RfEX4OL2N7mDYOYL4OWDmXZRgc9ezgELan7PpkKr0oTiBAxLtEVPCLIBok9+x
         EUdyqVEyRJ2GwSA1JYfoYq8nNEhOo7P0wXmPtopAWvG24bIzeijaaStqU6sakWqsg1DZ
         dvI3qyJN15t7VSFS2UCRgAMpI/LG0CtPhoQL99nT7AxXMK+WhrKMxlVT0VRsQAG2QC7E
         qw5h58lpHE4lx9vKR7kKtJbFqDPkuzqO7AzJci9lNEObpkJMjJP5bTHhkkJZLyv8Z1Br
         aO9Sh4+3KAXx0D7fFDo7KxhqFPTlQzNgvlmdiJzf8yRFOBMV7H8rI90ack0J3FflbIwU
         MCHw==
X-Gm-Message-State: ANhLgQ2A1tiiW56QFdS+kdWxcO+R4zRN2LodNRqU1Mv26/uksZvGaP1b
	dPVPZ+QialywaLlJ8QQcurGpjQ==
X-Google-Smtp-Source: ADFU+vssG85d9uw7w/dZYKVY8iWcX36ihTmaX9l/jn8ofzXnh2OIhkrrNAHbLEj4qRZelyfdl7DkKw==
X-Received: by 2002:a17:902:b703:: with SMTP id d3mr9747893pls.39.1585081959545;
        Tue, 24 Mar 2020 13:32:39 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Kees Cook <keescook@chromium.org>,
	Elena Reshetova <elena.reshetova@intel.com>,
	x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Potapenko <glider@google.com>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Jann Horn <jannh@google.com>,
	"Perla, Enrico" <enrico.perla@intel.com>,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/5] stack: Optionally randomize kernel stack offset each syscall
Date: Tue, 24 Mar 2020 13:32:29 -0700
Message-Id: <20200324203231.64324-4-keescook@chromium.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200324203231.64324-1-keescook@chromium.org>
References: <20200324203231.64324-1-keescook@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This provides the ability for architectures to enable kernel stack base
address offset randomization. This feature is controlled by the boot
param "randomize_kstack_offset=on/off", with its default value set by
CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT.

This feature is based on the original idea from the last public release
of PaX's RANDKSTACK feature: https://pax.grsecurity.net/docs/randkstack.txt
All the credit for the original idea goes to the PaX team. Note that
the design and implementation of this upstream randomize_kstack_offset
feature differs greatly from the RANDKSTACK feature (see below).

Reasoning for the feature:

This feature aims to make harder the various stack-based attacks that
rely on deterministic stack structure. We have had many such attacks in
past (just to name few):

https://jon.oberheide.org/files/infiltrate12-thestackisback.pdf
https://jon.oberheide.org/files/stackjacking-infiltrate11.pdf
https://googleprojectzero.blogspot.com/2016/06/exploiting-recursion-in-linux-kernel_20.html

As Linux kernel stack protections have been constantly improving
(vmap-based stack allocation with guard pages, removal of thread_info,
STACKLEAK), attackers have to find new ways for their exploits to work.
They have done so, continuing to rely on the kernel's stack determinism,
in situations where VMAP_STACK and THREAD_INFO_IN_TASK_STRUCT were not
relevant. For example, the following recent attacks would have been
hampered if the stack offset was non-deterministic between syscalls:

https://repositorio-aberto.up.pt/bitstream/10216/125357/2/374717.pdf
https://a13xp0p0v.github.io/2020/02/15/CVE-2019-18683.html

The main idea is that since the stack offset is randomized upon each
system call, it is hard for an attack to reliably land in any particular
place on the thread stack, even with address exposures, as the stack base
will change on the next syscall. Also, since randomization is performed
after placing pt_regs, the ptrace-based approach[1] to discover the
randomized offset during a long-running syscall should not be possible.

Design description:

During most of the kernel's execution, it runs on the "thread stack",
which is allocated at fork.c/dup_task_struct() and stored in a per-task
variable (tsk->stack). Since stack is growing downward, the stack
top can be always calculated using task_top_of_stack(tsk) function,
which essentially returns an address of tsk->stack + stack size. When
VMAP_STACK is enabled, the thread stack is allocated from vmalloc space.

The thread stack is pretty deterministic in its structure -- fixed in
size, and upon every entry from a userspace to kernel on a syscall the
thread stack is started to be constructed from an address fetched from a
per-cpu cpu_current_top_of_stack variable. The first element to be pushed
to the thread stack is the pt_regs struct that stores all required CPU
registers and syscall parameters.

The goal of randomize_kstack_offset feature is to add a random offset
after the pt_regs has been pushed to the stack and the rest of thread
stack (used during the syscall processing) every time a process issues
a syscall. The source of randomness is currently arch-defined (but x86
is using the low byte of rdtsc()). Future improvements for different
entropy sources is possible, but out of scope for this patch. The offset
is added using alloca() call since it helps avoiding changes in assembly
syscall entry code and unwinder, and provides correct stack alignment
as defined by the compiler.

In order to make this available by default with zero performance impact
for those that don't want it, now it is selectable with static branches.
This way, if the overhead is not wanted, it can just be turned off.

Using the per-cpu variable as the entropy source and __builtin_alloc()
for stack adjustment and alignment, the generated assembly for x86_64
with GCC looks like this:

...
ffffffff81003977: 65 8b 05 02 ea 00 7f  mov %gs:0x7f00ea02(%rip),%eax
					    # 12380 <kstack_offset>
ffffffff8100397e: 25 ff 03 00 00        and $0x3ff,%eax
ffffffff81003983: 48 83 c0 0f           add $0xf,%rax
ffffffff81003987: 25 f8 07 00 00        and $0x7f8,%eax
ffffffff8100398c: 48 29 c4              sub %rax,%rsp
ffffffff8100398f: 48 8d 44 24 0f        lea 0xf(%rsp),%rax
ffffffff81003994: 48 83 e0 f0           and $0xfffffffffffffff0,%rax
...

As a result of the above stack alignment, this patch introduces about
5 bits of randomness after pt_regs is spilled to the thread stack on
x86_64, and 6 bits on x86_32 (since its has 1 fewer bits required for
stack alignment). The amount of entropy could be adjusted based on how
much of the stack space we wish to trade for security.

My measure of syscall performance overhead (on x86_64):

lmbench: /usr/lib/lmbench/bin/x86_64-linux-gnu/lat_syscall -N 10000 null
    randomize_kstack_offset=y	Simple syscall: 0.7082 microseconds
    randomize_kstack_offset=n	Simple syscall: 0.7016 microseconds

So, roughly 0.9% overhead growth for a no-op syscall, which is very
manageable. And for people that don't want this, it's off by default.

Comparison to PaX RANDKSTACK feature:

The RANDKSTACK feature randomizes the location of the stack start
(cpu_current_top_of_stack), i.e. including the location of pt_regs
structure itself on the stack. Initially this patch followed the same
approach, but during the recent discussions[2], it has been determined
to be of a little value since, if ptrace functionality is available for
an attacker, they can use PTRACE_PEEKUSR/PTRACE_POKEUSR to read/write
different offsets in the pt_regs struct, observe the cache behavior of
the pt_regs accesses, and figure out the random stack offset. Another
difference is that the random offset is stored in a per-cpu variable,
rather than having it be per-thread. As a result, these implementations
differ a fair bit in their implementation details and results, though
obviously the intent is similar.

[1] https://lore.kernel.org/kernel-hardening/2236FBA76BA1254E88B949DDB74E612BA4BC57C1@IRSMSX102.ger.corp.intel.com/
[2] https://lore.kernel.org/kernel-hardening/20190329081358.30497-1-elena.reshetova@intel.com/

Co-developed-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Link: https://lore.kernel.org/r/20190415060918.3766-1-elena.reshetova@intel.com
Signed-off-by: Kees Cook <keescook@chromium.org>
---
v2:
- move to per-cpu rdtsc() saved on syscall exit
- add static branches for zero-cost dynamic enabling
- Kconfig just selects the default state of static branch
- __builtin_alloca() produces ugly asm without -fno-stack-clash-protection
- made arch agnostic
rfc: https://lore.kernel.org/kernel-hardening/20190329081358.30497-1-elena.reshetova@intel.com/
---
 Makefile                         |  4 ++++
 arch/Kconfig                     | 19 +++++++++++++++
 include/linux/randomize_kstack.h | 40 ++++++++++++++++++++++++++++++++
 init/main.c                      | 23 ++++++++++++++++++
 4 files changed, 86 insertions(+)
 create mode 100644 include/linux/randomize_kstack.h

diff --git a/Makefile b/Makefile
index 171f2b004c8a..c99463406522 100644
--- a/Makefile
+++ b/Makefile
@@ -779,6 +779,10 @@ ifdef CONFIG_INIT_STACK_ALL
 KBUILD_CFLAGS	+= -ftrivial-auto-var-init=pattern
 endif
 
+# While VLAs have been removed, GCC produces unreachable stack probes
+# for the random_kstack_offset feature. Disable it for all compilers.
+KBUILD_CFLAGS	+= $(call cc-option,-fno-stack-clash-protection,)
+
 DEBUG_CFLAGS	:= $(call cc-option, -fno-var-tracking-assignments)
 
 ifdef CONFIG_DEBUG_INFO
diff --git a/arch/Kconfig b/arch/Kconfig
index 17fe351cdde0..619a56da4b76 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -854,6 +854,25 @@ config VMAP_STACK
 	  virtual mappings with real shadow memory, and KASAN_VMALLOC must
 	  be enabled.
 
+config HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
+	def_bool n
+	help
+	  An arch should select this symbol if it can support kernel stack
+	  offset randomization with calls to add_random_kstack_offset()
+	  during syscall entry and choose_random_kstack_offset() during
+	  syscall exit.
+
+config RANDOMIZE_KSTACK_OFFSET_DEFAULT
+	bool "Randomize kernel stack offset on syscall entry"
+	depends on HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
+	help
+	  The kernel stack offset can be randomized (after pt_regs) by
+	  roughly 5 bits of entropy, frustrating memory corruption
+	  attacks that depend on stack address determinism or
+	  cross-syscall address exposures. This feature is controlled
+	  by kernel boot param "randomize_kstack_offset=on/off", and this
+	  config chooses the default boot state.
+
 config ARCH_OPTIONAL_KERNEL_RWX
 	def_bool n
 
diff --git a/include/linux/randomize_kstack.h b/include/linux/randomize_kstack.h
new file mode 100644
index 000000000000..651ba9504568
--- /dev/null
+++ b/include/linux/randomize_kstack.h
@@ -0,0 +1,40 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _LINUX_RANDOMIZE_KSTACK_H
+#define _LINUX_RANDOMIZE_KSTACK_H
+
+#include <linux/kernel.h>
+#include <linux/jump_label.h>
+#include <linux/percpu-defs.h>
+
+DECLARE_STATIC_KEY_MAYBE(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,
+			 randomize_kstack_offset);
+DECLARE_PER_CPU(u32, kstack_offset);
+
+/*
+ * Do not use this anywhere else in the kernel. This is used here because
+ * it provides an arch-agnostic way to grow the stack with correct
+ * alignment. Also, since this use is being explicitly masked to a max of
+ * 10 bits, stack-clash style attacks are unlikely. For more details see
+ * "VLAs" in Documentation/process/deprecated.rst
+ */
+void *__builtin_alloca(size_t size);
+
+#define add_random_kstack_offset() do {					\
+	if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,	\
+				&randomize_kstack_offset)) {		\
+		u32 offset = this_cpu_read(kstack_offset);		\
+		char *ptr = __builtin_alloca(offset & 0x3FF);		\
+		asm volatile("" : "=m"(*ptr));				\
+	}								\
+} while (0)
+
+#define choose_random_kstack_offset(rand) do {				\
+	if (static_branch_maybe(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,	\
+				&randomize_kstack_offset)) {		\
+		u32 offset = this_cpu_read(kstack_offset);		\
+		offset ^= (rand);					\
+		this_cpu_write(kstack_offset, offset);			\
+	}								\
+} while (0)
+
+#endif
diff --git a/init/main.c b/init/main.c
index ee4947af823f..78fe3aea00b0 100644
--- a/init/main.c
+++ b/init/main.c
@@ -777,6 +777,29 @@ static void __init mm_init(void)
 	pti_init();
 }
 
+#ifdef CONFIG_HAVE_ARCH_RANDOMIZE_KSTACK_OFFSET
+DEFINE_STATIC_KEY_MAYBE_RO(CONFIG_RANDOMIZE_KSTACK_OFFSET_DEFAULT,
+			   randomize_kstack_offset);
+DEFINE_PER_CPU(u32, kstack_offset);
+
+static int __init early_randomize_kstack_offset(char *buf)
+{
+	int ret;
+	bool bool_result;
+
+	ret = kstrtobool(buf, &bool_result);
+	if (ret)
+		return ret;
+
+	if (bool_result)
+		static_branch_enable(&randomize_kstack_offset);
+	else
+		static_branch_disable(&randomize_kstack_offset);
+	return 0;
+}
+early_param("randomize_kstack_offset", early_randomize_kstack_offset);
+#endif
+
 void __init __weak arch_call_rest_init(void)
 {
 	rest_init();
-- 
2.20.1

