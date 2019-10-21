Return-Path: <kernel-hardening-return-17079-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 78354DF395
	for <lists+kernel-hardening@lfdr.de>; Mon, 21 Oct 2019 18:49:46 +0200 (CEST)
Received: (qmail 17741 invoked by uid 550); 21 Oct 2019 16:49:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17720 invoked from network); 21 Oct 2019 16:49:40 -0000
Date: Mon, 21 Oct 2019 17:49:04 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Jann Horn <jannh@google.com>, Will Deacon <will@kernel.org>,
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
	kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 18/18] arm64: implement Shadow Call Stack
Message-ID: <20191021164904.GD56589@lakrids.cambridge.arm.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-19-samitolvanen@google.com>
 <CAG48ez2Z8=0__eoQ+Ekp=EApawZXR4ec_xd2TVPQExLoyMwtRQ@mail.gmail.com>
 <20191018172309.GB18838@lakrids.cambridge.arm.com>
 <CABCJKue27Aba_MJqB68Bh282zyL=LSQSBXV5TAb-NfsOAqJRnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCJKue27Aba_MJqB68Bh282zyL=LSQSBXV5TAb-NfsOAqJRnQ@mail.gmail.com>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)

On Fri, Oct 18, 2019 at 10:35:49AM -0700, Sami Tolvanen wrote:
> On Fri, Oct 18, 2019 at 10:23 AM Mark Rutland <mark.rutland@arm.com> wrote:
> > I think scs_save() would better live in assembly in cpu_switch_to(),
> > where we switch the stack and current. It shouldn't matter whether
> > scs_load() is inlined or not, since the x18 value _should_ be invariant
> > from the PoV of the task.
> 
> Note that there's also a call to scs_save in cpu_die, because the
> current task's shadow stack pointer is only stored in x18 and we don't
> want to lose it.
> 
> > We just need to add a TSK_TI_SCS to asm-offsets.c, and then insert a
> > single LDR at the end:
> >
> >         mov     sp, x9
> >         msr     sp_el0, x1
> > #ifdef CONFIG_SHADOW_CALL_STACK
> >         ldr     x18, [x1, TSK_TI_SCS]
> > #endif
> >         ret
> 
> TSK_TI_SCS is already defined, so yes, we could move this to
> cpu_switch_to. I would still prefer to have the overflow check that's
> in scs_thread_switch though.

The only bit that I think needs to be in cpu_switch_to() is the install
of the next task's shadow addr into x18.

Having a separate scs_check_overflow() sounds fine to me, as that only
has to read from the shadow stack. IIUC that's also for the prev task,
not next, in the current patches.

Thanks,
Mark.
