Return-Path: <kernel-hardening-return-17099-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4363CE3426
	for <lists+kernel-hardening@lfdr.de>; Thu, 24 Oct 2019 15:28:55 +0200 (CEST)
Received: (qmail 6138 invoked by uid 550); 24 Oct 2019 13:28:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 6119 invoked from network); 24 Oct 2019 13:28:48 -0000
Date: Thu, 24 Oct 2019 14:28:32 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Laura Abbott <labbott@redhat.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/18] add support for Clang's Shadow Call Stack (SCS)
Message-ID: <20191024132832.GG4300@lakrids.cambridge.arm.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-7-samitolvanen@google.com>
 <20191022162826.GC699@lakrids.cambridge.arm.com>
 <CABCJKudxvS9Eehr0dEFUR4H44K-PUULbjrh0i=pP_r5MGrKptA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCJKudxvS9Eehr0dEFUR4H44K-PUULbjrh0i=pP_r5MGrKptA@mail.gmail.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)

On Tue, Oct 22, 2019 at 12:26:02PM -0700, Sami Tolvanen wrote:
> On Tue, Oct 22, 2019 at 9:28 AM Mark Rutland <mark.rutland@arm.com> wrote:

> > > +config SHADOW_CALL_STACK
> > > +     bool "Clang Shadow Call Stack"
> > > +     depends on ARCH_SUPPORTS_SHADOW_CALL_STACK
> > > +     depends on CC_IS_CLANG && CLANG_VERSION >= 70000
> >
> > Is there a reason for an explicit version check rather than a
> > CC_HAS_<feature> check? e.g. was this available but broken in prior
> > versions of clang?
> 
> No, this feature was added in Clang 7. However,
> -fsanitize=shadow-call-stack might require architecture-specific
> flags, so a simple $(cc-option, -fsanitize=shadow-call-stack) in
> arch/Kconfig is not going to work. I could add something like this to
> arch/arm64/Kconfig though:
> 
> select ARCH_SUPPORTS_SHADOW_CALL_STACK if CC_HAVE_SHADOW_CALL_STACK
> ...
> config CC_HAVE_SHADOW_CALL_STACK
>        def_bool $(cc-option, -fsanitize=shadow-call-stack -ffixed-x18)
> 
> And then drop CC_IS_CLANG and version check entirely. Thoughts?

That sounds good to me, yes!

Thanks,
Mark.
