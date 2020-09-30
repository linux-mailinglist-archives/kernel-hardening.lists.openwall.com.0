Return-Path: <kernel-hardening-return-20073-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0F6A227F49C
	for <lists+kernel-hardening@lfdr.de>; Wed, 30 Sep 2020 23:58:31 +0200 (CEST)
Received: (qmail 22453 invoked by uid 550); 30 Sep 2020 21:58:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22421 invoked from network); 30 Sep 2020 21:58:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=t4yHwQDoeC7Qpj3w+ohiUiQzIr7R18uaPZSHZDC/wBA=;
        b=LHz9Zcam7CeKHZ2FruDPRDuY0e07YHSqVvGalfh32T3Fuffnt2bHgr5rwgpKJmywr5
         vYYvj2pj3Prw08WL6qW4WlpRdEOLUCrT+9hncLjFVN1Ft8Md5FT+cXeVzwCbCclkl92o
         hiVEXzmM9WAhHeXPsScWmhH08ZPlqMeItatEG49WX1OQPxwmMQyfc2iYMB/Z7txm5yp9
         RRa0vfTlhSB0oEdLv191LDpEXlrqdDLR97VB59MmnkaiwZ4LOuqrpJLUtPF1GuZMwqmk
         sGSI3yP3GaxL9/tqCvhaOlXgx1uB7P44MkrgKvdzV+0gcVnwItyMO1mDDu9EjVXS5h+m
         ERsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=t4yHwQDoeC7Qpj3w+ohiUiQzIr7R18uaPZSHZDC/wBA=;
        b=M9WM3xXbifes8FX+IkW5dPpl1dlTgXi/MTykAviI2zH06M4lBfJ4TOKaPfbBfM5Qbk
         tj5HKouPqLfLwxEobnuokNASViDyaIG3C0SZxMq1esVbIlGdAbcfTq7ghijhZWZtvMd5
         fs+HzvB1YEouqsO2zVs7V2iUKKEB6rqvq6mjpfUqP2GWIDUsosU5FZse+v/yVCmZ1JoU
         mMHvwOfHLELAtPp/FF3vbQA1APbDDgS0hrmf1XKSt6R2Mb9HQ9pgKzqGGhL82d1lwbLG
         MPHe3w3xkWF9KZWxqJhgHMLXbG3uueEWElhNsn/xyhqywRlJr4MSiS6QmXIPnZI2HfyZ
         lp0Q==
X-Gm-Message-State: AOAM531n59UWfVbBRShetxTHxLdFIq2o2NH0wTkRwJzOKe667WHRMSm9
	wJBDanto0iHlHJj6mFIGiTrPdpSA+nbNkn1OFdMY+g==
X-Google-Smtp-Source: ABdhPJwzX9Viqx7zQJehaAJaWpHju7adBUzL4TnFBbDcXOlCvSY7YI0nAchHwIA2JZ5jrnbbiiAg20J+xNYGNfRzTkU=
X-Received: by 2002:a17:902:c40d:b029:d2:93e8:1f4b with SMTP id
 k13-20020a170902c40db02900d293e81f4bmr4327278plk.29.1601503091998; Wed, 30
 Sep 2020 14:58:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200929214631.3516445-1-samitolvanen@google.com>
In-Reply-To: <20200929214631.3516445-1-samitolvanen@google.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Wed, 30 Sep 2020 14:58:00 -0700
Message-ID: <CAKwvOdnYBkUx9YpY9XLONbNYFD7JrOfGbRFQ8ZTf-sa2GTgQdQ@mail.gmail.com>
Subject: Re: [PATCH v4 00/29] Add support for Clang LTO
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Sep 29, 2020 at 2:46 PM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> This patch series adds support for building x86_64 and arm64 kernels
> with Clang's Link Time Optimization (LTO).
>
> In addition to performance, the primary motivation for LTO is
> to allow Clang's Control-Flow Integrity (CFI) to be used in the
> kernel. Google has shipped millions of Pixel devices running three
> major kernel versions with LTO+CFI since 2018.
>
> Most of the patches are build system changes for handling LLVM
> bitcode, which Clang produces with LTO instead of ELF object files,
> postponing ELF processing until a later stage, and ensuring initcall
> ordering.

Sami, thanks for continuing to drive the series. I encourage you to
keep resending with fixes accumulated or dropped on a weekly cadence.

The series worked well for me on arm64, but for x86_64 on mainline I
saw a stream of new objtool warnings:

testing your LTO series; x86_64 defconfig + CONFIG_THINLTO:
``` LTO vmlinux.o OBJTOOL vmlinux.o vmlinux.o: warning: objtool:
wakeup_long64()+0x61: indirect jump found in RETPOLINE build
vmlinux.o: warning: objtool: .text+0x308a: indirect jump found in
RETPOLINE build vmlinux.o: warning: objtool: .text+0x30c5: indirect
jump found in RETPOLINE build vmlinux.o: warning: objtool:
copy_user_enhanced_fast_string() falls through to next function
copy_user_generic_unrolled() vmlinux.o: warning: objtool:
__memcpy_mcsafe() falls through to next function mcsafe_handle_tail()
vmlinux.o: warning: objtool: memset() falls through to next function
memset_erms() vmlinux.o: warning: objtool: __memcpy() falls through to
next function memcpy_erms() vmlinux.o: warning: objtool:
__x86_indirect_thunk_rax() falls through to next function
__x86_retpoline_rax() vmlinux.o: warning: objtool:
__x86_indirect_thunk_rbx() falls through to next function
__x86_retpoline_rbx() vmlinux.o: warning: objtool:
__x86_indirect_thunk_rcx() falls through to next function
__x86_retpoline_rcx() vmlinux.o: warning: objtool:
__x86_indirect_thunk_rdx() falls through to next function
__x86_retpoline_rdx() vmlinux.o: warning: objtool:
__x86_indirect_thunk_rsi() falls through to next function
__x86_retpoline_rsi() vmlinux.o: warning: objtool:
__x86_indirect_thunk_rdi() falls through to next function
__x86_retpoline_rdi() vmlinux.o: warning: objtool:
__x86_indirect_thunk_rbp() falls through to next function
__x86_retpoline_rbp() vmlinux.o: warning: objtool:
__x86_indirect_thunk_r8() falls through to next function
__x86_retpoline_r8() vmlinux.o: warning: objtool:
__x86_indirect_thunk_r9() falls through to next function
__x86_retpoline_r9() vmlinux.o: warning: objtool:
__x86_indirect_thunk_r10() falls through to next function
__x86_retpoline_r10() vmlinux.o: warning: objtool:
__x86_indirect_thunk_r11() falls through to next function
__x86_retpoline_r11() vmlinux.o: warning: objtool:
__x86_indirect_thunk_r12() falls through to next function
__x86_retpoline_r12() vmlinux.o: warning: objtool:
__x86_indirect_thunk_r13() falls through to next function
__x86_retpoline_r13() vmlinux.o: warning: objtool:
__x86_indirect_thunk_r14() falls through to next function
__x86_retpoline_r14() vmlinux.o: warning: objtool:
__x86_indirect_thunk_r15() falls through to next function
__x86_retpoline_r15() ```

I think those should be resolved before I provide any kind of tested
by tag.  My other piece of feedback was that I like the default
ThinLTO, but I think the help text in the Kconfig which is visible
during menuconfig could be improved by informing the user the
tradeoffs.  For example, if CONFIG_THINLTO is disabled, it should be
noted that full LTO will be used instead.  Also, that full LTO may
produce slightly better optimized binaries than ThinLTO, at the cost
of not utilizing multiple cores when linking and thus significantly
slower to link.

Maybe explaining that setting it to "n" implies a full LTO build,
which will be much slower to link but possibly slightly faster would
be good?  It's not visible unless LTO_CLANG and ARCH_SUPPORTS_THINLTO
is enabled, so I don't think you need to explain that THINLTO without
those is *not* full LTO.  I'll leave the precise wording to you. WDYT?

Also, when I look at your treewide DISABLE_LTO patch, I think "does
that need to be a part of this series, or is it a cleanup that can
stand on its own?"  I think it may be the latter?  Maybe it would help
shed one more patch than to have to carry it to just send it?  Or did
I miss something as to why it should remain a part of this series?
-- 
Thanks,
~Nick Desaulniers
