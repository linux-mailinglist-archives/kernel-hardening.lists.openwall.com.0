Return-Path: <kernel-hardening-return-20075-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 06CFC27FFE0
	for <lists+kernel-hardening@lfdr.de>; Thu,  1 Oct 2020 15:17:27 +0200 (CEST)
Received: (qmail 18025 invoked by uid 550); 1 Oct 2020 13:17:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 18005 invoked from network); 1 Oct 2020 13:17:19 -0000
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Date: Thu, 1 Oct 2020 15:17:07 +0200 (CEST)
From: Miroslav Benes <mbenes@suse.cz>
To: Sami Tolvanen <samitolvanen@google.com>
cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
    Steven Rostedt <rostedt@goodmis.org>, 
    Peter Zijlstra <peterz@infradead.org>, 
    Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
    "Paul E. McKenney" <paulmck@kernel.org>, Kees Cook <keescook@chromium.org>, 
    Nick Desaulniers <ndesaulniers@google.com>, 
    clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com, 
    linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
    linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
    linux-pci@vger.kernel.org, x86@kernel.org, jthierry@redhat.com, 
    jpoimboe@redhat.com
Subject: Re: [PATCH v4 04/29] objtool: Add a pass for generating
 __mcount_loc
In-Reply-To: <20200929214631.3516445-5-samitolvanen@google.com>
Message-ID: <alpine.LSU.2.21.2010011504340.6689@pobox.suse.cz>
References: <20200929214631.3516445-1-samitolvanen@google.com> <20200929214631.3516445-5-samitolvanen@google.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi Sami,

On Tue, 29 Sep 2020, Sami Tolvanen wrote:

> From: Peter Zijlstra <peterz@infradead.org>
> 
> Add the --mcount option for generating __mcount_loc sections
> needed for dynamic ftrace. Using this pass requires the kernel to
> be compiled with -mfentry and CC_USING_NOP_MCOUNT to be defined
> in Makefile.
> 
> Link: https://lore.kernel.org/lkml/20200625200235.GQ4781@hirez.programming.kicks-ass.net/
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> [Sami: rebased to mainline, dropped config changes, fixed to actually use
>        --mcount, and wrote a commit message.]
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>

I am sorry to reply on v4. Should have been sooner.

Julien has been sending patches to make objtool's check functionality 
arch-agnostic as much as possible. So it seems to me that the patch should 
be based on the effort

I also wonder about making 'mcount' command separate from 'check'. Similar 
to what is 'orc' now. But that could be done later.

See tip-tree/objtool/core for both.

Thanks
Miroslav
