Return-Path: <kernel-hardening-return-17098-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9A759E328F
	for <lists+kernel-hardening@lfdr.de>; Thu, 24 Oct 2019 14:41:47 +0200 (CEST)
Received: (qmail 21566 invoked by uid 550); 24 Oct 2019 12:41:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 9278 invoked from network); 24 Oct 2019 12:04:33 -0000
Date: Thu, 24 Oct 2019 08:04:18 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Masahiro Yamada
 <yamada.masahiro@socionext.com>, Will Deacon <will@kernel.org>, Catalin
 Marinas <catalin.marinas@arm.com>, Ard Biesheuvel
 <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, Kees Cook
 <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, Nick
 Desaulniers <ndesaulniers@google.com>, clang-built-linux
 <clang-built-linux@googlegroups.com>, Kernel Hardening
 <kernel-hardening@lists.openwall.com>, linux-arm-kernel
 <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/18] add support for Clang's Shadow Call Stack (SCS)
Message-ID: <20191024080418.35423b36@gandalf.local.home>
In-Reply-To: <CABCJKudsD6jghk4i8Tp4aJg0d7skt6sU=gQ3JXqW8sjkUuX7vA@mail.gmail.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
	<20191018161033.261971-7-samitolvanen@google.com>
	<20191022162826.GC699@lakrids.cambridge.arm.com>
	<CABCJKudsD6jghk4i8Tp4aJg0d7skt6sU=gQ3JXqW8sjkUuX7vA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 23 Oct 2019 09:59:09 -0700
Sami Tolvanen <samitolvanen@google.com> wrote:

> On Tue, Oct 22, 2019 at 9:28 AM Mark Rutland <mark.rutland@arm.com> wrote:
> > I think it would be preferable to follow the example of CC_FLAGS_FTRACE
> > so that this can be filtered out, e.g.
> >
> > ifdef CONFIG_SHADOW_CALL_STACK
> > CFLAGS_SCS := -fsanitize=shadow-call-stack
> > KBUILD_CFLAGS += $(CFLAGS_SCS)
> > export CC_FLAGS_SCS
> > endif
> >
> > ... with removal being:
> >
> > CFLAGS_REMOVE := $(CC_FLAGS_SCS)
> >
> > ... or:
> >
> > CFLAGS_REMOVE_obj.o := $(CC_FLAGS_SCS)
> >
> > That way you only need to define the flags once, so the enable and
> > disable falgs remain in sync by construction.  
> 
> CFLAGS_REMOVE appears to be only implemented for objects, which means
> there's no convenient way to filter out flags for everything in
> arch/arm64/kvm/hyp, for example. I could add a CFLAGS_REMOVE
> separately for each object file, or we could add something like
> ccflags-remove-y to complement ccflags-y, which should be relatively
> simple. Masahiro, do you have any suggestions?
> 

You can remove a CFLAGS for a whole directory. lib, kernel/trace and
others do this. Look at kernel/trace/Makefile, we have:

ORIG_CFLAGS := $(KBUILD_CFLAGS)
KBUILD_CFLAGS = $(subst $(CC_FLAGS_FTRACE),,$(ORIG_CFLAGS))

Where it removes CC_FLAGS_FTRACE from CFLAGS for all objects in the
directory.

-- Steve
