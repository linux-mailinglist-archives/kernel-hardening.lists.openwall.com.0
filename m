Return-Path: <kernel-hardening-return-20397-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 99BA82B2897
	for <lists+kernel-hardening@lfdr.de>; Fri, 13 Nov 2020 23:34:47 +0100 (CET)
Received: (qmail 23744 invoked by uid 550); 13 Nov 2020 22:34:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23721 invoked from network); 13 Nov 2020 22:34:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1605306868;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8Rq1SwLUmuk5yTiT3dYLgLhG1v7f4gsVqDXVvnML+kQ=;
	b=HHZHs8oAPhAgKaCArEN5SwF8DPfVSX25N5UBC8yDVSLZcRa386K7GOa0SXuzjZCTQViJAt
	NTaw2gAMLvbamzJMQNULLsSNGm6Bl6Z+70lK7EPNnryt+Vt9tbhlx5B9qq0pUmwBEsBUys
	hfSoxN1cUdA2HJjZ4URu4TJHPdJnNW4=
X-MC-Unique: kgiX0vPEOgWkK_HzwNLmJg-1
Date: Fri, 13 Nov 2020 16:34:12 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	linux-kbuild <linux-kbuild@vger.kernel.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-pci@vger.kernel.org
Subject: Re: [PATCH v6 22/25] x86/asm: annotate indirect jumps
Message-ID: <20201113223412.inono2ekrs7ky7rm@treble>
References: <CABCJKucVjFtrOsw58kn4OnW5kdkUh8G7Zs4s6QU9s6O7soRiAA@mail.gmail.com>
 <20201021085606.GZ2628@hirez.programming.kicks-ass.net>
 <CABCJKufL6=FiaeD8T0P+mK4JeR9J80hhjvJ6Z9S-m9UnCESxVA@mail.gmail.com>
 <20201023173617.GA3021099@google.com>
 <CABCJKuee7hUQSiksdRMYNNx05bW7pWaDm4fQ__znGQ99z9-dEw@mail.gmail.com>
 <20201110022924.tekltjo25wtrao7z@treble>
 <20201110174606.mp5m33lgqksks4mt@treble>
 <CABCJKuf+Ev=hpCUfDpCFR_wBACr-539opJsSFrDcpDA9Ctp7rg@mail.gmail.com>
 <20201113195408.atbpjizijnhuinzy@treble>
 <CABCJKufA-aOcsOqb1NiMQeBGm9Q-JxjoPjsuNpHh0kL4LzfO0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABCJKufA-aOcsOqb1NiMQeBGm9Q-JxjoPjsuNpHh0kL4LzfO0w@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15

On Fri, Nov 13, 2020 at 12:24:32PM -0800, Sami Tolvanen wrote:
> > I still don't see this warning for some reason.
> 
> Do you have CONFIG_XEN enabled? I can reproduce this on ToT master as follows:
> 
> $ git rev-parse HEAD
> 585e5b17b92dead8a3aca4e3c9876fbca5f7e0ba
> $ make defconfig && \
> ./scripts/config -e HYPERVISOR_GUEST -e PARAVIRT -e XEN && \
> make olddefconfig && \
> make -j110
> ...
> $ ./tools/objtool/objtool check -arfld vmlinux.o 2>&1 | grep secondary
> vmlinux.o: warning: objtool: __startup_secondary_64()+0x2: return with
> modified stack frame
> 
> > Is it fixed by adding cpu_bringup_and_idle() to global_noreturns[] in
> > tools/objtool/check.c?
> 
> No, that didn't fix the warning. Here's what I tested:

I think this fixes it:

From: Josh Poimboeuf <jpoimboe@redhat.com>
Subject: [PATCH] x86/xen: Fix objtool vmlinux.o validation of xen hypercalls

Objtool vmlinux.o validation is showing warnings like the following:

  # tools/objtool/objtool check -barfld vmlinux.o
  vmlinux.o: warning: objtool: __startup_secondary_64()+0x2: return with modified stack frame
  vmlinux.o: warning: objtool:   xen_hypercall_set_trap_table()+0x0: <=== (sym)

Objtool falls through all the empty hypercall text and gets confused
when it encounters the first real function afterwards.  The empty unwind
hints in the hypercalls aren't working for some reason.  Replace them
with a more straightforward use of STACK_FRAME_NON_STANDARD.

Reported-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
---
 arch/x86/xen/xen-head.S | 9 ++++-----
 include/linux/objtool.h | 8 ++++++++
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
index 2d7c8f34f56c..3c538b1ff4a6 100644
--- a/arch/x86/xen/xen-head.S
+++ b/arch/x86/xen/xen-head.S
@@ -6,6 +6,7 @@
 
 #include <linux/elfnote.h>
 #include <linux/init.h>
+#include <linux/objtool.h>
 
 #include <asm/boot.h>
 #include <asm/asm.h>
@@ -67,14 +68,12 @@ SYM_CODE_END(asm_cpu_bringup_and_idle)
 .pushsection .text
 	.balign PAGE_SIZE
 SYM_CODE_START(hypercall_page)
-	.rept (PAGE_SIZE / 32)
-		UNWIND_HINT_EMPTY
-		.skip 32
-	.endr
+	.skip PAGE_SIZE
 
 #define HYPERCALL(n) \
 	.equ xen_hypercall_##n, hypercall_page + __HYPERVISOR_##n * 32; \
-	.type xen_hypercall_##n, @function; .size xen_hypercall_##n, 32
+	.type xen_hypercall_##n, @function; .size xen_hypercall_##n, 32; \
+	STACK_FRAME_NON_STANDARD xen_hypercall_##n
 #include <asm/xen-hypercalls.h>
 #undef HYPERCALL
 SYM_CODE_END(hypercall_page)
diff --git a/include/linux/objtool.h b/include/linux/objtool.h
index 577f51436cf9..746617265236 100644
--- a/include/linux/objtool.h
+++ b/include/linux/objtool.h
@@ -109,6 +109,12 @@ struct unwind_hint {
 	.popsection
 .endm
 
+.macro STACK_FRAME_NON_STANDARD func:req
+	.pushsection .discard.func_stack_frame_non_standard
+		.long \func - .
+	.popsection
+.endm
+
 #endif /* __ASSEMBLY__ */
 
 #else /* !CONFIG_STACK_VALIDATION */
@@ -123,6 +129,8 @@ struct unwind_hint {
 .macro UNWIND_HINT sp_reg:req sp_offset=0 type:req end=0
 .endm
 #endif
+.macro STACK_FRAME_NON_STANDARD func:req
+.endm
 
 #endif /* CONFIG_STACK_VALIDATION */
 
-- 
2.25.4

