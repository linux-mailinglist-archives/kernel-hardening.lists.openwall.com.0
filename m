Return-Path: <kernel-hardening-return-17087-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id AF0F7E0822
	for <lists+kernel-hardening@lfdr.de>; Tue, 22 Oct 2019 18:00:52 +0200 (CEST)
Received: (qmail 16073 invoked by uid 550); 22 Oct 2019 16:00:47 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 16052 invoked from network); 22 Oct 2019 16:00:46 -0000
Date: Tue, 22 Oct 2019 17:00:10 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Sami Tolvanen <samitolvanen@google.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Laura Abbott <labbott@redhat.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/18] arm64: reserve x18 only with Shadow Call Stack
Message-ID: <20191022160010.GB699@lakrids.cambridge.arm.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-13-samitolvanen@google.com>
 <CAKwvOd=rU2cC7C3a=8D2WBEmS49YgR7=aCriE31JQx7ExfQZrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOd=rU2cC7C3a=8D2WBEmS49YgR7=aCriE31JQx7ExfQZrg@mail.gmail.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)

On Fri, Oct 18, 2019 at 02:23:10PM -0700, Nick Desaulniers wrote:
> On Fri, Oct 18, 2019 at 9:11 AM 'Sami Tolvanen' via Clang Built Linux
> <clang-built-linux@googlegroups.com> wrote:
> >
> > Only reserve x18 with CONFIG_SHADOW_CALL_STACK. Note that all external
> > kernel modules must also have x18 reserved if the kernel uses SCS.
> 
> Ah, ok.  The tradeoff for maintainers to consider, either:
> 1. one less GPR for ALL kernel code or
> 2. remember not to use x18 in inline as lest you potentially break SCS

This option only affects compiler-generated code, so I don't think that
matters.

I think it's fine to say that we should always avoid the use of x18 in
hand-written assembly (with manual register allocation), while also
allowing the compiler to use x18 if we're not using SCS.

This can be folded into the earlier patch which always reserved x18.

> This patch is 2 (the earlier patch was 1).  Maybe we don't write
> enough inline asm that this will be hard to remember, and we do have
> CI in Android to watch for this (on mainline, not sure about -next).

I think that we can trust the set of people who regularly review arm64
assembly to remember this. We could also document this somewhere -- we
might need to document other constraints or conventions for assembly
in preparation for livepatching and so on.

If we wanted to, we could periodically grep for x18 to find any illicit
usage.

Thanks,
Mark.
