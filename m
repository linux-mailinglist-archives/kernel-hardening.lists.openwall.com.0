Return-Path: <kernel-hardening-return-16724-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4BCAC833CE
	for <lists+kernel-hardening@lfdr.de>; Tue,  6 Aug 2019 16:19:01 +0200 (CEST)
Received: (qmail 25711 invoked by uid 550); 6 Aug 2019 14:18:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 3730 invoked from network); 6 Aug 2019 14:00:31 -0000
Date: Tue, 6 Aug 2019 09:59:42 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Thomas Garnier <thgarnie@chromium.org>,
	kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
	keescook@chromium.org, Andy Lutomirski <luto@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 04/11] x86/entry/64: Adapt assembly for PIE support
Message-ID: <20190806135942.xnuovr4vbanbxneb@home.goodmis.org>
References: <20190730191303.206365-1-thgarnie@chromium.org>
 <20190730191303.206365-5-thgarnie@chromium.org>
 <20190805172854.GF18785@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805172854.GF18785@zn.tnic>
User-Agent: NeoMutt/20170113 (1.7.2)

On Mon, Aug 05, 2019 at 07:28:54PM +0200, Borislav Petkov wrote:
> >  1:
> > @@ -1571,7 +1572,8 @@ nested_nmi:
> >  	pushq	%rdx
> >  	pushfq
> >  	pushq	$__KERNEL_CS
> > -	pushq	$repeat_nmi
> > +	leaq	repeat_nmi(%rip), %rdx
> > +	pushq	%rdx
> >  
> >  	/* Put stack back */
> >  	addq	$(6*8), %rsp
> > @@ -1610,7 +1612,11 @@ first_nmi:
> >  	addq	$8, (%rsp)	/* Fix up RSP */
> >  	pushfq			/* RFLAGS */
> >  	pushq	$__KERNEL_CS	/* CS */
> > -	pushq	$1f		/* RIP */
> > +	pushq	$0		/* Future return address */
> > +	pushq	%rax		/* Save RAX */
> > +	leaq	1f(%rip), %rax	/* RIP */
> > +	movq    %rax, 8(%rsp)   /* Put 1f on return address */
> > +	popq	%rax		/* Restore RAX */
> 
> Can't you just use a callee-clobbered reg here instead of preserving
> %rax?

As Peter stated later in this thread, we only have the IRQ stack frame saved
here, because we just took an NMI, and this is the logic to determine if it
was a nested NMI or not (where we have to be *very* careful about touching the
stack!)

That said, the code modified here is to test the NMI nesting logic (only
enabled with CONFIG_DEBUG_ENTRY), and what it is doing is re-enabling NMIs
before calling the first NMI handler, to help trigger nested NMIs without the
need of a break point or page fault (iret enables NMIs again).

This code is in the path of the "first nmi" (we confirmed that this is not
nested), which means that it should be safe to push onto the stack.

Yes, we need to save and restore whatever reg we used. The only comment I
would make is to use %rdx instead of %rax as that has been our "scratch"
register used before saving pt_regs. Just to be consistent.

-- Steve


