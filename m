Return-Path: <kernel-hardening-return-20400-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5B1E82B2933
	for <lists+kernel-hardening@lfdr.de>; Sat, 14 Nov 2020 00:32:05 +0100 (CET)
Received: (qmail 19961 invoked by uid 550); 13 Nov 2020 23:31:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19936 invoked from network); 13 Nov 2020 23:31:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AJStHOY5Qh2DGFTroegyQhWYQ1MmCmTEUHWIJvas+7M=;
        b=jSNVZO0K7wzWNgivPRsTS23unTlL5xu3JAtfH6tP3wTtqKXHTFxKLDpXglVNKVogCS
         6GN3EBqfM/ZUBQPh9/KXRac8yN3VH0HlBG3quWK6QtaxtiL1rK8O5VK7VVHqo6J7Rt/X
         pLPxkZTYuxt9e7KMQUlSjLI7JuuwGE0+gzwfrHa+KQQiFj8lluSMbarMau3hHsSH1/Ly
         I1ayeKXU+HZyBmmdWsN2DNObwSk0A53WftOV1KjCprrJHCY1GRvxqs5hu+HPHBc4Mr91
         nRjSltnInqcTuCWkLRcwZA5Rf8Mmi9P0lK2FChkaNPICHq6O3gumsgzJMmBvO66F5HQu
         PNWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AJStHOY5Qh2DGFTroegyQhWYQ1MmCmTEUHWIJvas+7M=;
        b=q2i+SyveEItO7v+G6I6UuWKaDv38XZAFI8NtfrNpds1dvR61iTulFDl7QaaXa63dHO
         xC7kAF+72Z730osqABI2aCShGPqx33Ia/4jXm+NJNkVC1G2BlCuGq5j7rgnn93etTm7H
         vqnLLBp3mSvDLjwJWCUKKdEJ9uv+ihMbtGe1IoKD+PAt1tIfeKpyia7wS/zttQlM9bOx
         8l8H1ft8Vkov6AWFTGHXMGt0v7RFFomTFQfwGIsNTUu1ymTEiyvzX5l2xoshIXCXDdgV
         Z//ihHl22aPu2wL29f0Rh5Q7jQdIbr5olTjkNC2yNWdamI1sy0IMgDYzhhg5V96ffE6U
         igtQ==
X-Gm-Message-State: AOAM5308Nc0VKlfoQAqHYMw1pIUns2cLv1eUy4+2RtRLm4dxaS5DQQyv
	X2DAkEnJKrd7XuXOQ9KflNPC2bEdgoGrIDuN6hT8YQ==
X-Google-Smtp-Source: ABdhPJxSW9RODWqSRFIxVh02sljFGIxaFmVwff0K0MDsmxDUSocAvDQCNoKIe2vb8EcMsPSHfR3I4Mur2BV/pt3dnso=
X-Received: by 2002:a67:ee93:: with SMTP id n19mr3267175vsp.36.1605310306224;
 Fri, 13 Nov 2020 15:31:46 -0800 (PST)
MIME-Version: 1.0
References: <CABCJKucVjFtrOsw58kn4OnW5kdkUh8G7Zs4s6QU9s6O7soRiAA@mail.gmail.com>
 <20201021085606.GZ2628@hirez.programming.kicks-ass.net> <CABCJKufL6=FiaeD8T0P+mK4JeR9J80hhjvJ6Z9S-m9UnCESxVA@mail.gmail.com>
 <20201023173617.GA3021099@google.com> <CABCJKuee7hUQSiksdRMYNNx05bW7pWaDm4fQ__znGQ99z9-dEw@mail.gmail.com>
 <20201110022924.tekltjo25wtrao7z@treble> <20201110174606.mp5m33lgqksks4mt@treble>
 <CABCJKuf+Ev=hpCUfDpCFR_wBACr-539opJsSFrDcpDA9Ctp7rg@mail.gmail.com>
 <20201113195408.atbpjizijnhuinzy@treble> <CABCJKufA-aOcsOqb1NiMQeBGm9Q-JxjoPjsuNpHh0kL4LzfO0w@mail.gmail.com>
 <20201113223412.inono2ekrs7ky7rm@treble>
In-Reply-To: <20201113223412.inono2ekrs7ky7rm@treble>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 13 Nov 2020 15:31:34 -0800
Message-ID: <CABCJKueeL+1ydcZsm2BS4qrX4Wxy7zY7FUQdoN_WLuUxFfqcmQ@mail.gmail.com>
Subject: Re: [PATCH v6 22/25] x86/asm: annotate indirect jumps
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, Nov 13, 2020 at 2:34 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> On Fri, Nov 13, 2020 at 12:24:32PM -0800, Sami Tolvanen wrote:
> > > I still don't see this warning for some reason.
> >
> > Do you have CONFIG_XEN enabled? I can reproduce this on ToT master as follows:
> >
> > $ git rev-parse HEAD
> > 585e5b17b92dead8a3aca4e3c9876fbca5f7e0ba
> > $ make defconfig && \
> > ./scripts/config -e HYPERVISOR_GUEST -e PARAVIRT -e XEN && \
> > make olddefconfig && \
> > make -j110
> > ...
> > $ ./tools/objtool/objtool check -arfld vmlinux.o 2>&1 | grep secondary
> > vmlinux.o: warning: objtool: __startup_secondary_64()+0x2: return with
> > modified stack frame
> >
> > > Is it fixed by adding cpu_bringup_and_idle() to global_noreturns[] in
> > > tools/objtool/check.c?
> >
> > No, that didn't fix the warning. Here's what I tested:
>
> I think this fixes it:
>
> From: Josh Poimboeuf <jpoimboe@redhat.com>
> Subject: [PATCH] x86/xen: Fix objtool vmlinux.o validation of xen hypercalls
>
> Objtool vmlinux.o validation is showing warnings like the following:
>
>   # tools/objtool/objtool check -barfld vmlinux.o
>   vmlinux.o: warning: objtool: __startup_secondary_64()+0x2: return with modified stack frame
>   vmlinux.o: warning: objtool:   xen_hypercall_set_trap_table()+0x0: <=== (sym)
>
> Objtool falls through all the empty hypercall text and gets confused
> when it encounters the first real function afterwards.  The empty unwind
> hints in the hypercalls aren't working for some reason.  Replace them
> with a more straightforward use of STACK_FRAME_NON_STANDARD.
>
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> ---
>  arch/x86/xen/xen-head.S | 9 ++++-----
>  include/linux/objtool.h | 8 ++++++++
>  2 files changed, 12 insertions(+), 5 deletions(-)
>
> diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
> index 2d7c8f34f56c..3c538b1ff4a6 100644
> --- a/arch/x86/xen/xen-head.S
> +++ b/arch/x86/xen/xen-head.S
> @@ -6,6 +6,7 @@
>
>  #include <linux/elfnote.h>
>  #include <linux/init.h>
> +#include <linux/objtool.h>
>
>  #include <asm/boot.h>
>  #include <asm/asm.h>
> @@ -67,14 +68,12 @@ SYM_CODE_END(asm_cpu_bringup_and_idle)
>  .pushsection .text
>         .balign PAGE_SIZE
>  SYM_CODE_START(hypercall_page)
> -       .rept (PAGE_SIZE / 32)
> -               UNWIND_HINT_EMPTY
> -               .skip 32
> -       .endr
> +       .skip PAGE_SIZE
>
>  #define HYPERCALL(n) \
>         .equ xen_hypercall_##n, hypercall_page + __HYPERVISOR_##n * 32; \
> -       .type xen_hypercall_##n, @function; .size xen_hypercall_##n, 32
> +       .type xen_hypercall_##n, @function; .size xen_hypercall_##n, 32; \
> +       STACK_FRAME_NON_STANDARD xen_hypercall_##n
>  #include <asm/xen-hypercalls.h>
>  #undef HYPERCALL
>  SYM_CODE_END(hypercall_page)
> diff --git a/include/linux/objtool.h b/include/linux/objtool.h
> index 577f51436cf9..746617265236 100644
> --- a/include/linux/objtool.h
> +++ b/include/linux/objtool.h
> @@ -109,6 +109,12 @@ struct unwind_hint {
>         .popsection
>  .endm
>
> +.macro STACK_FRAME_NON_STANDARD func:req
> +       .pushsection .discard.func_stack_frame_non_standard
> +               .long \func - .
> +       .popsection
> +.endm
> +
>  #endif /* __ASSEMBLY__ */
>
>  #else /* !CONFIG_STACK_VALIDATION */
> @@ -123,6 +129,8 @@ struct unwind_hint {
>  .macro UNWIND_HINT sp_reg:req sp_offset=0 type:req end=0
>  .endm
>  #endif
> +.macro STACK_FRAME_NON_STANDARD func:req
> +.endm

This macro needs to be before the #endif, so it's defined only for
assembly code. This breaks my arm64 builds even though x86 curiously
worked just fine.

Sami
