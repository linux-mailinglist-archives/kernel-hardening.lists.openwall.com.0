Return-Path: <kernel-hardening-return-17073-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BC5A5DE790
	for <lists+kernel-hardening@lfdr.de>; Mon, 21 Oct 2019 11:14:02 +0200 (CEST)
Received: (qmail 13579 invoked by uid 550); 21 Oct 2019 09:13:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13558 invoked from network); 21 Oct 2019 09:13:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571649223;
	bh=yqmr6bE4HTCk/kWaRLnlRHb3aZ8M5nE1t+SHzsWkT0c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dILlMHxsapCwB/RkiKFBJRcDoTVeP8uZtjnYn4j8HijxhFuviJQGK9RLJptUZVwle
	 rvnrlg/U39zZmz9e7H77HIsAXzMEN5hihlW58hLy52HHm+Ms7Lddmy2Cs/TeA0Xfw2
	 af0VNH2gjKVSuPOS00xFIi5Vol9q+2hboQvET6FM=
Date: Mon, 21 Oct 2019 18:13:37 +0900
From: Masami Hiramatsu <mhiramat@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Ard Biesheuvel
 <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, Kees Cook
 <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, Mark Rutland
 <mark.rutland@arm.com>, Nick Desaulniers <ndesaulniers@google.com>,
 clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, Masami
 Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH 10/18] kprobes: fix compilation without
 CONFIG_KRETPROBES
Message-Id: <20191021181337.a1f886fa62b400023c576be0@kernel.org>
In-Reply-To: <20191018130257.3376e397@gandalf.local.home>
References: <20191018161033.261971-1-samitolvanen@google.com>
	<20191018161033.261971-11-samitolvanen@google.com>
	<20191018130257.3376e397@gandalf.local.home>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 18 Oct 2019 13:02:57 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> 
> Added Masami who's the maintainer of kprobes.
> 
> -- Steve
> 
> 
> On Fri, 18 Oct 2019 09:10:25 -0700
> Sami Tolvanen <samitolvanen@google.com> wrote:
> 
> > kprobe_on_func_entry and arch_kprobe_on_func_entry need to be available
> > even if CONFIG_KRETPROBES is not selected.

Good catch! Since nowadays all arch supports kretprobes, I've missed to
test it.

Acked-by: Masami Hiramatsu <mhiramat@kernel.org>

Thank you,

> > 
> > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> > ---
> >  kernel/kprobes.c | 38 +++++++++++++++++++-------------------
> >  1 file changed, 19 insertions(+), 19 deletions(-)
> > 
> > diff --git a/kernel/kprobes.c b/kernel/kprobes.c
> > index 53534aa258a6..b5e20a4669b8 100644
> > --- a/kernel/kprobes.c
> > +++ b/kernel/kprobes.c
> > @@ -1829,6 +1829,25 @@ unsigned long __weak arch_deref_entry_point(void *entry)
> >  	return (unsigned long)entry;
> >  }
> >  
> > +bool __weak arch_kprobe_on_func_entry(unsigned long offset)
> > +{
> > +	return !offset;
> > +}
> > +
> > +bool kprobe_on_func_entry(kprobe_opcode_t *addr, const char *sym, unsigned long offset)
> > +{
> > +	kprobe_opcode_t *kp_addr = _kprobe_addr(addr, sym, offset);
> > +
> > +	if (IS_ERR(kp_addr))
> > +		return false;
> > +
> > +	if (!kallsyms_lookup_size_offset((unsigned long)kp_addr, NULL, &offset) ||
> > +						!arch_kprobe_on_func_entry(offset))
> > +		return false;
> > +
> > +	return true;
> > +}
> > +
> >  #ifdef CONFIG_KRETPROBES
> >  /*
> >   * This kprobe pre_handler is registered with every kretprobe. When probe
> > @@ -1885,25 +1904,6 @@ static int pre_handler_kretprobe(struct kprobe *p, struct pt_regs *regs)
> >  }
> >  NOKPROBE_SYMBOL(pre_handler_kretprobe);
> >  
> > -bool __weak arch_kprobe_on_func_entry(unsigned long offset)
> > -{
> > -	return !offset;
> > -}
> > -
> > -bool kprobe_on_func_entry(kprobe_opcode_t *addr, const char *sym, unsigned long offset)
> > -{
> > -	kprobe_opcode_t *kp_addr = _kprobe_addr(addr, sym, offset);
> > -
> > -	if (IS_ERR(kp_addr))
> > -		return false;
> > -
> > -	if (!kallsyms_lookup_size_offset((unsigned long)kp_addr, NULL, &offset) ||
> > -						!arch_kprobe_on_func_entry(offset))
> > -		return false;
> > -
> > -	return true;
> > -}
> > -
> >  int register_kretprobe(struct kretprobe *rp)
> >  {
> >  	int ret = 0;
> 


-- 
Masami Hiramatsu <mhiramat@kernel.org>
