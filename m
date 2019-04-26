Return-Path: <kernel-hardening-return-15831-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BC468B2ED
	for <lists+kernel-hardening@lfdr.de>; Sat, 27 Apr 2019 08:46:14 +0200 (CEST)
Received: (qmail 5162 invoked by uid 550); 27 Apr 2019 06:43:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 4017 invoked from network); 27 Apr 2019 06:43:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=0/++kCIdz9NinK/+MFp07AkuSYwP6lr30tD8Xi+P1Ns=;
        b=c8S+0EigCS6E8XvKa358lLe6LCVfzSFVuNJOVAHrtcVTOWv87dH8gGM88UuaQDW1Ql
         IEkRJXiL08aosg7wFKjOifGHvdFqqFOyIVAPTy32+RTxwh4obVo1hvSc3VrfhbIWeRKu
         ZJA1hj0UwfXTRnrJeU5WqlBmd3LvGogakdG6r5O5HCHdIZ01YxMYWq3GzL7qFIqoHj+M
         ImxYzSZVWsC/5XsbT15MbduZoaGGNML2WLcc4snNS8OhI4V0R2fmhxvtsFVBQg8hBw68
         V9bB/2b3yhVaonMZdGNuWp1CujPDm/DoQRIcyXEO1I8gk21/7x6PmT++18rtH9HSkyQc
         PS4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=0/++kCIdz9NinK/+MFp07AkuSYwP6lr30tD8Xi+P1Ns=;
        b=acxe2OE4qruZCNB/DY14PTFmh2qDyHnB7g3ynwtj8uNyihnSi7KPDQnPA5CeK2Rs+V
         r6LoRTaLlLKp0RDnK2nesOM6+GBHsn6+Ml3V6EhuGw+gN5H8MJnGuygkyHdRq+MIre67
         yByu7WyS3p90EolakNGile86fDm1ufMpnG43593Q6eZQ+vuBDopAo8mWnL8/+Hc/qYRv
         XIZZoePm7yqGysq32kZJ+8o9y42gjW2PdKXV/Gpm0Qg+UsH0vcTSlYRvGTWiASc8g3vU
         6p5neFF3Ocfr4UA7Bv7LzWT4PV1BMsc/qCzIosLbo3RgodKjrc6btEZilMxIzHzlSCoo
         K7hA==
X-Gm-Message-State: APjAAAXT2DT2U3bo2HgBk6lNmNNYWpkVvR6qB8B6saZMaaqmG4cSDjr9
	4mowe7e74V4nUA0rImF65Fs=
X-Google-Smtp-Source: APXvYqwD3aMW9+fxSDptS7zjHtrUL6axD8ahdhvdTbAECEHQ3uOfUvnD7wIP6ssynsnm5EaQ/VhgYw==
X-Received: by 2002:a17:902:20c6:: with SMTP id v6mr48012719plg.276.1556347402023;
        Fri, 26 Apr 2019 23:43:22 -0700 (PDT)
From: nadav.amit@gmail.com
To: Peter Zijlstra <peterz@infradead.org>,
	Borislav Petkov <bp@alien8.de>,
	Andy Lutomirski <luto@kernel.org>,
	Ingo Molnar <mingo@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	x86@kernel.org,
	hpa@zytor.com,
	Thomas Gleixner <tglx@linutronix.de>,
	Nadav Amit <nadav.amit@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	linux_dti@icloud.com,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	akpm@linux-foundation.org,
	kernel-hardening@lists.openwall.com,
	linux-mm@kvack.org,
	will.deacon@arm.com,
	ard.biesheuvel@linaro.org,
	kristen@linux.intel.com,
	deneen.t.dock@intel.com,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Nadav Amit <namit@vmware.com>,
	Kees Cook <keescook@chromium.org>,
	Dave Hansen <dave.hansen@intel.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Jessica Yu <jeyu@kernel.org>
Subject: [PATCH v6 12/24] x86/module: Avoid breaking W^X while loading modules
Date: Fri, 26 Apr 2019 16:22:51 -0700
Message-Id: <20190426232303.28381-13-nadav.amit@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190426232303.28381-1-nadav.amit@gmail.com>
References: <20190426232303.28381-1-nadav.amit@gmail.com>

From: Nadav Amit <namit@vmware.com>

When modules and BPF filters are loaded, there is a time window in
which some memory is both writable and executable. An attacker that has
already found another vulnerability (e.g., a dangling pointer) might be
able to exploit this behavior to overwrite kernel code. Prevent having
writable executable PTEs in this stage.

In addition, avoiding having W+X mappings can also slightly simplify the
patching of modules code on initialization (e.g., by alternatives and
static-key), as would be done in the next patch. This was actually the
main motivation for this patch.

To avoid having W+X mappings, set them initially as RW (NX) and after
they are set as RO set them as X as well. Setting them as executable is
done as a separate step to avoid one core in which the old PTE is cached
(hence writable), and another which sees the updated PTE (executable),
which would break the W^X protection.

Cc: Kees Cook <keescook@chromium.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Jessica Yu <jeyu@kernel.org>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Suggested-by: Andy Lutomirski <luto@amacapital.net>
Signed-off-by: Nadav Amit <namit@vmware.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kernel/alternative.c | 28 +++++++++++++++++++++-------
 arch/x86/kernel/module.c      |  2 +-
 include/linux/filter.h        |  1 +
 kernel/module.c               |  5 +++++
 4 files changed, 28 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index 599203876c32..3d2b6b6fb20c 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -668,15 +668,29 @@ void __init alternative_instructions(void)
  * handlers seeing an inconsistent instruction while you patch.
  */
 void *__init_or_module text_poke_early(void *addr, const void *opcode,
-					      size_t len)
+				       size_t len)
 {
 	unsigned long flags;
-	local_irq_save(flags);
-	memcpy(addr, opcode, len);
-	local_irq_restore(flags);
-	sync_core();
-	/* Could also do a CLFLUSH here to speed up CPU recovery; but
-	   that causes hangs on some VIA CPUs. */
+
+	if (boot_cpu_has(X86_FEATURE_NX) &&
+	    is_module_text_address((unsigned long)addr)) {
+		/*
+		 * Modules text is marked initially as non-executable, so the
+		 * code cannot be running and speculative code-fetches are
+		 * prevented. Just change the code.
+		 */
+		memcpy(addr, opcode, len);
+	} else {
+		local_irq_save(flags);
+		memcpy(addr, opcode, len);
+		local_irq_restore(flags);
+		sync_core();
+
+		/*
+		 * Could also do a CLFLUSH here to speed up CPU recovery; but
+		 * that causes hangs on some VIA CPUs.
+		 */
+	}
 	return addr;
 }
 
diff --git a/arch/x86/kernel/module.c b/arch/x86/kernel/module.c
index b052e883dd8c..cfa3106faee4 100644
--- a/arch/x86/kernel/module.c
+++ b/arch/x86/kernel/module.c
@@ -87,7 +87,7 @@ void *module_alloc(unsigned long size)
 	p = __vmalloc_node_range(size, MODULE_ALIGN,
 				    MODULES_VADDR + get_module_load_offset(),
 				    MODULES_END, GFP_KERNEL,
-				    PAGE_KERNEL_EXEC, 0, NUMA_NO_NODE,
+				    PAGE_KERNEL, 0, NUMA_NO_NODE,
 				    __builtin_return_address(0));
 	if (p && (kasan_module_alloc(p, size) < 0)) {
 		vfree(p);
diff --git a/include/linux/filter.h b/include/linux/filter.h
index 6074aa064b54..14ec3bdad9a9 100644
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -746,6 +746,7 @@ static inline void bpf_prog_unlock_ro(struct bpf_prog *fp)
 static inline void bpf_jit_binary_lock_ro(struct bpf_binary_header *hdr)
 {
 	set_memory_ro((unsigned long)hdr, hdr->pages);
+	set_memory_x((unsigned long)hdr, hdr->pages);
 }
 
 static inline void bpf_jit_binary_unlock_ro(struct bpf_binary_header *hdr)
diff --git a/kernel/module.c b/kernel/module.c
index 0b9aa8ab89f0..2b2845ae983e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1950,8 +1950,13 @@ void module_enable_ro(const struct module *mod, bool after_init)
 		return;
 
 	frob_text(&mod->core_layout, set_memory_ro);
+	frob_text(&mod->core_layout, set_memory_x);
+
 	frob_rodata(&mod->core_layout, set_memory_ro);
+
 	frob_text(&mod->init_layout, set_memory_ro);
+	frob_text(&mod->init_layout, set_memory_x);
+
 	frob_rodata(&mod->init_layout, set_memory_ro);
 
 	if (after_init)
-- 
2.17.1

