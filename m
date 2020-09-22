Return-Path: <kernel-hardening-return-19960-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 64048274BB1
	for <lists+kernel-hardening@lfdr.de>; Tue, 22 Sep 2020 23:54:30 +0200 (CEST)
Received: (qmail 8109 invoked by uid 550); 22 Sep 2020 21:53:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7989 invoked from network); 22 Sep 2020 21:53:54 -0000
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com ABB0920C27C5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1600811622;
	bh=b+dZfSYt921SZbqVi9d6jmG8B2GKXdUDhoo8NhJxV+k=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=IYCw8eGIRinivB/mke9s56rfh0IoShsw0x+m1MrlH+ClEZT172gdzHmTznyb90Tlq
	 /1NbC1bWq19USuqC8IvAY4OPuW/L8149bG3rog5kNBYVZ9KhWZPbVxueJG13qcFrzs
	 gI20WK9s0lJaLwaZgnXOuao31fv/Ggt1KRH+IYYM=
From: madvenka@linux.microsoft.com
To: kernel-hardening@lists.openwall.com,
	linux-api@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	oleg@redhat.com,
	x86@kernel.org,
	luto@kernel.org,
	David.Laight@ACULAB.COM,
	fweimer@redhat.com,
	mark.rutland@arm.com,
	mic@digikod.net,
	pavel@ucw.cz,
	madvenka@linux.microsoft.com
Subject: [PATCH v2 4/4] [RFC] arm/trampfd: Provide support for the trampoline file descriptor
Date: Tue, 22 Sep 2020 16:53:26 -0500
Message-Id: <20200922215326.4603-5-madvenka@linux.microsoft.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200922215326.4603-1-madvenka@linux.microsoft.com>
References: <210d7cd762d5307c2aa1676705b392bd445f1baa>
 <20200922215326.4603-1-madvenka@linux.microsoft.com>

From: "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>

	- Define architecture specific register names
	- Architecture specific functions for:
		- system call init
		- code descriptor check
		- data descriptor check
	- Fill a page with a trampoline table,

Signed-off-by: Madhavan T. Venkataraman <madvenka@linux.microsoft.com>
---
 arch/arm/include/uapi/asm/ptrace.h |  21 +++++
 arch/arm/kernel/Makefile           |   1 +
 arch/arm/kernel/trampfd.c          | 124 +++++++++++++++++++++++++++++
 arch/arm/tools/syscall.tbl         |   1 +
 4 files changed, 147 insertions(+)
 create mode 100644 arch/arm/kernel/trampfd.c

diff --git a/arch/arm/include/uapi/asm/ptrace.h b/arch/arm/include/uapi/asm/ptrace.h
index e61c65b4018d..598047768f9b 100644
--- a/arch/arm/include/uapi/asm/ptrace.h
+++ b/arch/arm/include/uapi/asm/ptrace.h
@@ -151,6 +151,27 @@ struct pt_regs {
 #define ARM_r0		uregs[0]
 #define ARM_ORIG_r0	uregs[17]
 
+/*
+ * These register names are to be used by 32-bit applications.
+ */
+enum reg_32_name {
+	arm_min,
+	arm_r0 = arm_min,
+	arm_r1,
+	arm_r2,
+	arm_r3,
+	arm_r4,
+	arm_r5,
+	arm_r6,
+	arm_r7,
+	arm_r8,
+	arm_r9,
+	arm_r10,
+	arm_r11,
+	arm_r12,
+	arm_max,
+};
+
 /*
  * The size of the user-visible VFP state as seen by PTRACE_GET/SETVFPREGS
  * and core dumps.
diff --git a/arch/arm/kernel/Makefile b/arch/arm/kernel/Makefile
index 89e5d864e923..652c54c2f19a 100644
--- a/arch/arm/kernel/Makefile
+++ b/arch/arm/kernel/Makefile
@@ -105,5 +105,6 @@ obj-$(CONFIG_SMP)		+= psci_smp.o
 endif
 
 obj-$(CONFIG_HAVE_ARM_SMCCC)	+= smccc-call.o
+obj-$(CONFIG_TRAMPFD)		+= trampfd.o
 
 extra-y := $(head-y) vmlinux.lds
diff --git a/arch/arm/kernel/trampfd.c b/arch/arm/kernel/trampfd.c
new file mode 100644
index 000000000000..45146ed489e8
--- /dev/null
+++ b/arch/arm/kernel/trampfd.c
@@ -0,0 +1,124 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Trampoline FD - ARM support.
+ *
+ * Author: Madhavan T. Venkataraman (madvenka@linux.microsoft.com)
+ *
+ * Copyright (c) 2020, Microsoft Corporation.
+ */
+
+#include <linux/thread_info.h>
+#include <linux/trampfd.h>
+
+#define TRAMPFD_CODE_SIZE		28
+
+/*
+ * trampfd syscall.
+ */
+void trampfd_arch(struct trampfd_info *info)
+{
+	info->code_size = TRAMPFD_CODE_SIZE;
+	info->ntrampolines = PAGE_SIZE / info->code_size;
+	info->code_offset = TRAMPFD_CODE_PGOFF << PAGE_SHIFT;
+	info->reserved = 0;
+}
+
+/*
+ * trampfd code descriptor check.
+ */
+int trampfd_code_arch(struct trampfd_code *code)
+{
+	int	ntrampolines;
+	int	min, max;
+
+	min = arm_min;
+	max = arm_max;
+	ntrampolines = PAGE_SIZE / TRAMPFD_CODE_SIZE;
+
+	if (code->reg < min || code->reg >= max)
+		return -EINVAL;
+
+	if (!code->ntrampolines || code->ntrampolines > ntrampolines)
+		return -EINVAL;
+	return 0;
+}
+
+/*
+ * trampfd data descriptor check.
+ */
+int trampfd_data_arch(struct trampfd_data *data)
+{
+	int	min, max;
+
+	min = arm_min;
+	max = arm_max;
+
+	if (data->reg < min || data->reg >= max)
+		return -EINVAL;
+	return 0;
+}
+
+#define MOVW(ins, reg, imm32)						\
+{									\
+	u16	*_imm16 = (u16 *) &(imm32);	/* little endian */	\
+	int	_hw, _opcode;						\
+									\
+	for (_hw = 0; _hw < 2; _hw++) {					\
+		/* movw or movt */					\
+		_opcode = _hw ? 0xe3400000 : 0xe3000000;		\
+		*ins++ = _opcode | (_imm16[_hw] >> 12) << 16 |		\
+			 (reg) << 12 | (_imm16[_hw] & 0xFFF);		\
+	}								\
+}
+
+#define LDR(ins, reg)							\
+{									\
+	*ins++ = 0xe5900000 | (reg) << 16 | (reg) << 12;		\
+}
+
+#define BX(ins, reg)							\
+{									\
+	*ins++ = 0xe12fff10 | (reg);					\
+}
+
+void trampfd_code_fill(struct trampfd *trampfd, char *addr)
+{
+	char		*eaddr = addr + PAGE_SIZE;
+	int		creg = trampfd->code_reg - arm_min;
+	int		dreg = trampfd->data_reg - arm_min;
+	u32		*code = trampfd->code;
+	u32		*data = trampfd->data;
+	u32		*instruction = (u32 *) addr;
+	int		i;
+
+	for (i = 0; i < trampfd->ntrampolines; i++, code++, data++) {
+		/*
+		 * movw creg, code & 0xFFFF
+		 * movt creg, code >> 16
+		 */
+		MOVW(instruction, creg, code);
+
+		/*
+		 * ldr	creg, [creg]
+		 */
+		LDR(instruction, creg);
+
+		/*
+		 * movw dreg, data & 0xFFFF
+		 * movt dreg, data >> 16
+		 */
+		MOVW(instruction, dreg, data);
+
+		/*
+		 * ldr	dreg, [dreg]
+		 */
+		LDR(instruction, dreg);
+
+		/*
+		 * bx	creg
+		 */
+		BX(instruction, creg);
+	}
+	addr = (char *) instruction;
+	memset(addr, 0, eaddr - addr);
+}
diff --git a/arch/arm/tools/syscall.tbl b/arch/arm/tools/syscall.tbl
index d5cae5ffede0..85dcbc9e08ee 100644
--- a/arch/arm/tools/syscall.tbl
+++ b/arch/arm/tools/syscall.tbl
@@ -452,3 +452,4 @@
 437	common	openat2				sys_openat2
 438	common	pidfd_getfd			sys_pidfd_getfd
 439	common	faccessat2			sys_faccessat2
+440	common	trampfd				sys_trampfd
-- 
2.17.1

