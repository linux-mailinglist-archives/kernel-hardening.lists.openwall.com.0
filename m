Return-Path: <kernel-hardening-return-17124-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6611AE474D
	for <lists+kernel-hardening@lfdr.de>; Fri, 25 Oct 2019 11:31:58 +0200 (CEST)
Received: (qmail 24171 invoked by uid 550); 25 Oct 2019 09:31:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 21533 invoked from network); 25 Oct 2019 01:43:14 -0000
Date: Thu, 24 Oct 2019 21:42:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave
 Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, Laura
 Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Nick
 Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, Miguel
 Ojeda <miguel.ojeda.sandonis@gmail.com>, clang-built-linux
 <clang-built-linux@googlegroups.com>, Kernel Hardening
 <kernel-hardening@lists.openwall.com>, linux-arm-kernel
 <linux-arm-kernel@lists.infradead.org>, Linux Kernel Mailing List
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 16/17] arm64: disable SCS for hypervisor code
Message-ID: <20191024214259.1b37535c@gandalf.local.home>
In-Reply-To: <CAK7LNATPpL-B0APPXFcWPCR6ZTSrXv-v_ZkdFqjKJ4pwUpcWug@mail.gmail.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
	<20191024225132.13410-1-samitolvanen@google.com>
	<20191024225132.13410-17-samitolvanen@google.com>
	<CAK7LNATPpL-B0APPXFcWPCR6ZTSrXv-v_ZkdFqjKJ4pwUpcWug@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 25 Oct 2019 10:29:47 +0900
Masahiro Yamada <yamada.masahiro@socionext.com> wrote:

> On Fri, Oct 25, 2019 at 7:52 AM <samitolvanen@google.com> wrote:
> >
> > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> > ---
> >  arch/arm64/kvm/hyp/Makefile | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/arch/arm64/kvm/hyp/Makefile b/arch/arm64/kvm/hyp/Makefile
> > index ea710f674cb6..8289ea086e5e 100644
> > --- a/arch/arm64/kvm/hyp/Makefile
> > +++ b/arch/arm64/kvm/hyp/Makefile
> > @@ -28,3 +28,6 @@ GCOV_PROFILE  := n
> >  KASAN_SANITIZE := n
> >  UBSAN_SANITIZE := n
> >  KCOV_INSTRUMENT        := n
> > +
> > +ORIG_CFLAGS := $(KBUILD_CFLAGS)
> > +KBUILD_CFLAGS = $(subst $(CC_FLAGS_SCS),,$(ORIG_CFLAGS))  
> 
> 
> $(subst ... ) is not the correct use here.
> 
> It works like sed,   s/$(CC_CFLAGS_SCS)//
> instead of matching by word.
> 
> 
> 
> 
> KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
> 
> is more correct, and simpler.

I guess that would work too. Not sure why I never used it. I see mips
used it for their -pg flags.

-- Steve
