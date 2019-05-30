Return-Path: <kernel-hardening-return-16014-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 1645E30083
	for <lists+kernel-hardening@lfdr.de>; Thu, 30 May 2019 19:00:58 +0200 (CEST)
Received: (qmail 18211 invoked by uid 550); 30 May 2019 17:00:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 18174 invoked from network); 30 May 2019 17:00:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tycho-ws.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :content-transfer-encoding:user-agent;
        bh=uKe+49v3b67ABsa+3L0xMGvu+Nii/+mrlawAi5lp1Jc=;
        b=x0FM8L4yxR4R3vtuqbzr/oAAI9y1McVJmdsgpqquED87y7nSKrqyCmit9juuyMCbk8
         mfql7RtMpkLAsDmckIs4ORpdw8B3YkCQfA0qb7Wz9eDkILfhGamjdD30OIs0cYpYm2Xt
         Nsc6tuDOfY4rUQJC/3MvowGSQnTKc1gFzjJIycf+HSOI1H9oCVS7pVYZ6uTOqW/K+P+w
         8FYAyhY+zqtnvrHHgdYtTyERoYOKCcpmYwk/ejypkc/WXOflmre23sUMGCu/ToqHkDKL
         nkKwKFqIccMp5dWIPAh8AIAHcS3tteVoxnCwB8rAosoyFOdnzeTMMr+OMd3y2h2bNRZL
         IltQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:content-transfer-encoding:user-agent;
        bh=uKe+49v3b67ABsa+3L0xMGvu+Nii/+mrlawAi5lp1Jc=;
        b=KwlvysoNGx6J8Bq4Nebz0mcyClNJxBxpw3GctDsEKdAu1Io6jC++oBwV3me7XuTvz7
         A1ikRUBpJo7gf/m1NxG/tnO2Ia/8Tgf4WWMhqumH4oq+JaRzVShlaWdUabG8Yy3FmMo1
         nC/tCA8VIpaoIrcO8klhttrZKdp+th2hg85UQjAlqu7oP44a2s6Vk5Rs66WWu1iHr//Q
         Gd4DArG5yf7wP9w2pQl62djYh/xBFAJtqFWTSh6QieNseisHjUbxfPP1J4OgrGYlrGvu
         d8MmFlzuQ8g96bVugxDjhwZP0aoLduqhEx4CY4q6ozwb13zJKy+DM0swsMgM8fv59mF/
         8BeQ==
X-Gm-Message-State: APjAAAWYRyDKNCOJxQ+6uz48PReHdqC5zcLeZyYJqStRkmxmvC1+IQwt
	FoNceIwIhWEteTTD0xct05L2/g==
X-Google-Smtp-Source: APXvYqx6DASj753W7Uxf9HvC8bOswzFmwrFdt3+Xsh5HJy67pCX6j0Cd1Oolg0XUGZzorUz48gmK/w==
X-Received: by 2002:a37:9107:: with SMTP id t7mr4106431qkd.135.1559235637582;
        Thu, 30 May 2019 10:00:37 -0700 (PDT)
Date: Thu, 30 May 2019 11:00:33 -0600
From: Tycho Andersen <tycho@tycho.ws>
To: gcc@gcc.gnu.org
Cc: kernel-hardening@lists.openwall.com
Subject: unrecognizable insn generated in plugin?
Message-ID: <20190530170033.GA5739@cisco>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi all,

I've been trying to implement an idea Andy suggested recently for
preventing some kinds of ROP attacks. The discussion of the idea is
here:
https://lore.kernel.org/linux-mm/DFA69954-3F0F-4B79-A9B5-893D33D87E51@amacapital.net/

Right now I'm struggling to get my plugin to compile without crashing. The
basic idea is to insert some code before every "pop rbp" and "pop rsp"; I've
figured out how to find these instructions, and I'm inserting code using:

emit_insn(gen_rtx_XOR(DImode, gen_rtx_REG(DImode, HARD_FRAME_POINTER_REGNUM),
                      gen_rtx_MEM(DImode, gen_rtx_REG(DImode, HARD_FRAME_POINTER_REGNUM))));

The plugin completes successfully, but GCC complains later,

kernel/seccomp.c: In function ‘seccomp_check_filter’:
kernel/seccomp.c:242:1: error: unrecognizable insn:
 }
 ^
(insn 698 645 699 17 (xor:DI (reg:DI 6 bp)
        (mem:DI (reg:DI 6 bp) [0  S8 A8])) "kernel/seccomp.c":242 -1
     (nil))
during RTL pass: shorten
kernel/seccomp.c:242:1: internal compiler error: in insn_min_length, at config/i386/i386.md:14714

I assume this is because some internal metadata is screwed up, but I have no
clue as to what that is or how to fix it. My gcc version is 8.3.0, and
config/i386/i386.md:14714 of that tag looks mostly unrelated.

I had problems earlier because I was trying to run it after *clean_state which
is the thing that does init_insn_lengths(), but now I'm running it after
*stack_regs, so I thought it should be ok...

Anyway, the full plugin draft is below. You can run it by adding
CONFIG_GCC_PLUGIN_HEAPLEAP=y to your kernel config.

Thanks!

Tycho


From 83b0631f14784ce11362ebd64e40c8d25c0decee Mon Sep 17 00:00:00 2001
From: Tycho Andersen <tycho@tycho.ws>
Date: Fri, 19 Apr 2019 19:24:58 -0600
Subject: [PATCH] heapleap

Signed-off-by: Tycho Andersen <tycho@tycho.ws>
---
 scripts/Makefile.gcc-plugins          |   8 ++
 scripts/gcc-plugins/Kconfig           |   4 +
 scripts/gcc-plugins/heapleap_plugin.c | 189 ++++++++++++++++++++++++++
 3 files changed, 201 insertions(+)

diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
index 5f7df50cfe7a..283b81dc5742 100644
--- a/scripts/Makefile.gcc-plugins
+++ b/scripts/Makefile.gcc-plugins
@@ -44,6 +44,14 @@ ifdef CONFIG_GCC_PLUGIN_ARM_SSP_PER_TASK
 endif
 export DISABLE_ARM_SSP_PER_TASK_PLUGIN
 
+gcc-plugin-$(CONFIG_GCC_PLUGIN_HEAPLEAP)	+= heapleap_plugin.so
+gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_HEAPLEAP)		\
+			+= -DHEAPLEAP_PLUGIN
+ifdef CONFIG_GCC_PLUGIN_HEAPLEAP
+    DISABLE_HEAPLEAP_PLUGIN += -fplugin-arg-heapleap_plugin-disable
+endif
+export DISABLE_HEAPLEAP_PLUGIN
+
 # All the plugin CFLAGS are collected here in case a build target needs to
 # filter them out of the KBUILD_CFLAGS.
 GCC_PLUGINS_CFLAGS := $(strip $(addprefix -fplugin=$(objtree)/scripts/gcc-plugins/, $(gcc-plugin-y)) $(gcc-plugin-cflags-y))
diff --git a/scripts/gcc-plugins/Kconfig b/scripts/gcc-plugins/Kconfig
index 74271dba4f94..491b9cd5df1a 100644
--- a/scripts/gcc-plugins/Kconfig
+++ b/scripts/gcc-plugins/Kconfig
@@ -226,4 +226,8 @@ config GCC_PLUGIN_ARM_SSP_PER_TASK
 	bool
 	depends on GCC_PLUGINS && ARM
 
+config GCC_PLUGIN_HEAPLEAP
+	bool "Prevent 'pop esp' type instructions from loading an address in the heap"
+	depends on GCC_PLUGINS
+
 endif
diff --git a/scripts/gcc-plugins/heapleap_plugin.c b/scripts/gcc-plugins/heapleap_plugin.c
new file mode 100644
index 000000000000..5051b96d79f4
--- /dev/null
+++ b/scripts/gcc-plugins/heapleap_plugin.c
@@ -0,0 +1,189 @@
+/*
+ * This is based on an idea from Andy Lutomirski described here:
+ * https://lore.kernel.org/linux-mm/DFA69954-3F0F-4B79-A9B5-893D33D87E51@amacapital.net/
+ *
+ * unsigned long offset = *rsp - rsp;
+ * offset >>= THREAD_SHIFT;
+ * if (unlikely(offset))
+ * 	BUG();
+ * POP RSP;
+ */
+
+#include "gcc-common.h"
+
+__visible int plugin_is_GPL_compatible;
+static bool disable = false;
+
+static struct plugin_info heapleap_plugin_info = {
+	.version = "1",
+	.help = "disable\t\tdo not activate the plugin\n"
+};
+
+static bool heapleap_gate(void)
+{
+	tree section;
+
+	/*
+	 * Similar to stackleak, we only do this for user code for now.
+	 */
+	section = lookup_attribute("section",
+				   DECL_ATTRIBUTES(current_function_decl));
+	if (section && TREE_VALUE(section)) {
+		section = TREE_VALUE(TREE_VALUE(section));
+
+		if (!strncmp(TREE_STRING_POINTER(section), ".init.text", 10))
+			return false;
+		if (!strncmp(TREE_STRING_POINTER(section), ".devinit.text", 13))
+			return false;
+		if (!strncmp(TREE_STRING_POINTER(section), ".cpuinit.text", 13))
+			return false;
+		if (!strncmp(TREE_STRING_POINTER(section), ".meminit.text", 13))
+			return false;
+	}
+
+	return !disable;
+}
+
+/*
+ * Check that:
+ *
+ * unsigned long offset = *rbp - rbp;
+ * offset >>= THREAD_SHIFT;
+ * if (unlikely(offset))
+ * 	BUG();
+ * pop rbp;
+ *
+ * (we should probably do the same for rsp?)
+ */
+static void heapleap_add_check(rtx_insn *insn)
+{
+	rtx_insn *seq_head;
+
+	fprintf(stderr, "adding heapleap check\n");
+	print_rtl_single(stderr, insn);
+
+	start_sequence();
+
+	/* xor ebp [ebp] */
+	emit_insn(gen_rtx_XOR(DImode, gen_rtx_REG(DImode, HARD_FRAME_POINTER_REGNUM),
+			      gen_rtx_MEM(DImode, gen_rtx_REG(DImode, HARD_FRAME_POINTER_REGNUM))));
+
+	/* ebp >> THREAD_SHIFT */
+	/*
+	 * TODO: THREAD_SHIFT isn't defined for every arch, including x86.
+	 * THREAD_SIZE for x86_64 is 4096 * 2, so THREAD_SHIFT would be 13
+	 * there. We should at least compute this from THREAD_SIZE though.
+	 */
+	emit_insn(gen_rtx_LSHIFTRT(DImode, gen_rtx_REG(DImode, HARD_FRAME_POINTER_REGNUM),
+				   GEN_INT(13)));
+
+	/*
+	 * We're inserting right before the final pass, and we're adding some
+	 * kind of jump, thus splitting the basic block that is the epilogue.
+	 * That probably causes problems, and currently gcc crashes when doing
+	 * the final pass after we emit this, so we probably need to do better.
+	 */
+	emit_insn(gen_rtx_IF_THEN_ELSE(DImode,
+			gen_rtx_NE(DImode,
+				gen_rtx_REG(DImode, HARD_FRAME_POINTER_REGNUM),
+				GEN_INT(0)),
+			/*
+			 * we're really not supposed to BUG() for this stuff;
+			 * maybe we should figure out how to call WARN()? might
+			 * be painful.
+			 */
+			gen_ud2(),
+			/* poor man's no-op, i.e. how do i do this better? */
+			gen_rtx_SET(gen_rtx_REG(DImode, HARD_FRAME_POINTER_REGNUM),
+				    gen_rtx_REG(DImode, HARD_FRAME_POINTER_REGNUM))));
+	seq_head = get_insns();
+	end_sequence();
+
+	emit_insn_before(seq_head, insn);
+}
+
+static unsigned int heapleap_execute(void)
+{
+	rtx_insn *insn, *next;
+
+	if (strcmp(IDENTIFIER_POINTER(DECL_NAME(cfun->decl)), "seccomp_check_filter"))
+		return 0;
+
+	for (insn = get_insns(); insn; insn = next) {
+		rtx body, set, lhs, rhs;
+		int i;
+
+		next = NEXT_INSN(insn);
+		if (!next)
+			continue;
+
+		if (!RTX_FRAME_RELATED_P(next) || !NONJUMP_INSN_P(next))
+			continue;
+
+		/*
+		 * I don't understand why we need this; but PATTERN(insn) is a
+		 * CODE_LABEL, so...
+		 */
+		body = XEXP(insn, 1);
+		set = PATTERN(body);
+		if (GET_CODE(set) != SET)
+			continue;
+
+		/* TODO: use SET_DEST() here instead? */
+		lhs = XEXP(set, 0);
+		/* TODO: ebp vs esp? esp only occurs twice in my linked kernel */
+		if (GET_CODE(lhs) != REG || REGNO(lhs) != HARD_FRAME_POINTER_REGNUM)
+			continue;
+
+		/* TODO: use SET_SRC() here instead? */
+		rhs = XEXP(set, 1);
+		if (GET_CODE(rhs) != MEM)
+			continue;
+
+		heapleap_add_check(next);
+	}
+
+	return 0;
+}
+
+#define PASS_NAME heapleap
+#include "gcc-generate-rtl-pass.h"
+
+__visible int plugin_init(struct plugin_name_args *plugin_info,
+			  struct plugin_gcc_version *version)
+{
+	const char * const plugin_name = plugin_info->base_name;
+	const int argc = plugin_info->argc;
+	const struct plugin_argument * const argv = plugin_info->argv;
+	int i;
+
+	/*
+	 * *clean_state is the pass that does init_insn_lengths(), so we can't
+	 * do anything after this, because gcc fails there's not a length for
+	 * every instruction in the final pass
+	 */
+	PASS_INFO(heapleap, "*stack_regs", 1, PASS_POS_INSERT_AFTER);
+
+	if (!plugin_default_version_check(version, &gcc_version)) {
+		error(G_("incompatible gcc/plugin versions"));
+		return 1;
+	}
+
+	for (i = 0; i < argc; i++) {
+		if (!strcmp(argv[i].key, "disable")) {
+			disable = true;
+			return 0;
+		} else {
+			error(G_("unknown option '-fplugin-arg-%s-%s'"),
+					plugin_name, argv[i].key);
+			return 1;
+		}
+	}
+
+	register_callback(plugin_name, PLUGIN_INFO, NULL,
+						&heapleap_plugin_info);
+
+	register_callback(plugin_name, PLUGIN_PASS_MANAGER_SETUP, NULL,
+					&heapleap_pass_info);
+	return 0;
+}
-- 
2.20.1

