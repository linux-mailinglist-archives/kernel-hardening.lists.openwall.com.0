Return-Path: <kernel-hardening-return-17086-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8146EE07C7
	for <lists+kernel-hardening@lfdr.de>; Tue, 22 Oct 2019 17:47:57 +0200 (CEST)
Received: (qmail 8158 invoked by uid 550); 22 Oct 2019 15:47:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 8137 invoked from network); 22 Oct 2019 15:47:50 -0000
Date: Tue, 22 Oct 2019 16:47:08 +0100
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
Subject: Re: [PATCH 13/18] arm64: preserve x18 when CPU is suspended
Message-ID: <20191022154708.GA699@lakrids.cambridge.arm.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-14-samitolvanen@google.com>
 <20191021165649.GE56589@lakrids.cambridge.arm.com>
 <CABCJKucm2ETxe2dgJhb4Ruzq72psFMGsx=0D6TVnJ-_DL2FgfA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCJKucm2ETxe2dgJhb4Ruzq72psFMGsx=0D6TVnJ-_DL2FgfA@mail.gmail.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)

On Mon, Oct 21, 2019 at 03:43:14PM -0700, Sami Tolvanen wrote:
> On Mon, Oct 21, 2019 at 9:56 AM Mark Rutland <mark.rutland@arm.com> wrote:
> > This should have a corresponding change to cpu_suspend_ctx in
> > <asm/suspend.h>. Otherwise we're corrupting a portion of the stack.
> 
> Ugh, correct. I'll fix this in the next version. Thanks.

It's probably worth extending the comment above cpu_do_suspend to say:

| This must be kept in sync with struct cpu_suspend_ctx in
| <asm/suspend.h>

... to match what we have above struct cpu_suspend_ctx, and make this
more obvious in future.

Thanks,
Mark.
