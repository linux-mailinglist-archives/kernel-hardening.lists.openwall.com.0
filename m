Return-Path: <kernel-hardening-return-18542-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 27F0F1AE024
	for <lists+kernel-hardening@lfdr.de>; Fri, 17 Apr 2020 16:46:54 +0200 (CEST)
Received: (qmail 7606 invoked by uid 550); 17 Apr 2020 14:46:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7583 invoked from network); 17 Apr 2020 14:46:45 -0000
Date: Fri, 17 Apr 2020 15:46:21 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v11 04/12] scs: disable when function graph tracing is
 enabled
Message-ID: <20200417144620.GA9529@lakrids.cambridge.arm.com>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200416161245.148813-1-samitolvanen@google.com>
 <20200416161245.148813-5-samitolvanen@google.com>
 <20200417100039.GS20730@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417100039.GS20730@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)

Hi Peter,

On Fri, Apr 17, 2020 at 12:00:39PM +0200, Peter Zijlstra wrote:
> On Thu, Apr 16, 2020 at 09:12:37AM -0700, Sami Tolvanen wrote:
> > The graph tracer hooks returns by modifying frame records on the
> > (regular) stack, but with SCS the return address is taken from the
> > shadow stack, and the value in the frame record has no effect. As we
> > don't currently have a mechanism to determine the corresponding slot
> > on the shadow stack (and to pass this through the ftrace
> > infrastructure), for now let's disable SCS when the graph tracer is
> > enabled.
> > 
> > With SCS the return address is taken from the shadow stack and the
> > value in the frame record has no effect. The mcount based graph tracer
> > hooks returns by modifying frame records on the (regular) stack, and
> > thus is not compatible. The patchable-function-entry graph tracer
> > used for DYNAMIC_FTRACE_WITH_REGS modifies the LR before it is saved
> > to the shadow stack, and is compatible.
> > 
> > Modifying the mcount based graph tracer to work with SCS would require
> > a mechanism to determine the corresponding slot on the shadow stack
> > (and to pass this through the ftrace infrastructure), and we expect
> > that everyone will eventually move to the patchable-function-entry
> > based graph tracer anyway, so for now let's disable SCS when the
> > mcount-based graph tracer is enabled.
> > 
> > SCS and patchable-function-entry are both supported from LLVM 10.x.
> 
> SCS would actually provide another way to do return hooking. An arguably
> much saner model at that.
> 
> The 'normal' way is to (temporary) replace the on-stack return value,
> and then replace it back in the return handler. This is because we can't
> simply push a fake return on the stack, because that would wreck the
> expected stack layout of the regular function.
> 
> But there is nothing that would stop us from pushing an extra entry on
> the SCS. It would in fact be a much cleaner solution. The entry hook
> sticks an extra entry on the SCS, the function ignores what's on the
> normal stack and pops from the SCS, we return to the exit handler, which
> in turn pops from the SCS stack at which point we're back to regular.

For background: on arm64 we wanted to use DYNAMIC_FTRACE_WITH_REGS since
we already have to use that to handle pointer authentication, and didn't
want to gain more ways of implementing ftrace.

Arguably we should move the dependency into the arm64 Kconfig for
ARCH_SUPPORTS_SHADOW_CALL_STACK.

> The only 'funny' is that the exit handler itself should not push to the
> SCS, or we should frob the return-to-exit-handler such that it lands
> after the push.
> 
> > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> > Reviewed-by: Mark Rutland <mark.rutland@arm.com>
> > ---
> >  arch/Kconfig | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/arch/Kconfig b/arch/Kconfig
> > index 691a552c2cc3..c53cb9025ad2 100644
> > --- a/arch/Kconfig
> > +++ b/arch/Kconfig
> > @@ -542,6 +542,7 @@ config ARCH_SUPPORTS_SHADOW_CALL_STACK
> >  
> >  config SHADOW_CALL_STACK
> >  	bool "Clang Shadow Call Stack"
> > +	depends on DYNAMIC_FTRACE_WITH_REGS || !FUNCTION_GRAPH_TRACER
> >  	depends on ARCH_SUPPORTS_SHADOW_CALL_STACK
> >  	help
> >  	  This option enables Clang's Shadow Call Stack, which uses a
 
> AFAICT you also need to kill KRETPROBES, which plays similar games.

Hmm... how does KREPROBES work? If you can only mess with the return
address when probing the first instruction in the function, it'll just
work for SCS or pointer authentication, as the LR is used at that
instant. If KRETPROBES tries to mess with the return address elsewhere
it'd be broken today...

> And doesn't BPF also do stuff like this?

Can BPF mess with return addresses now!?

Thanks,
Mark.
