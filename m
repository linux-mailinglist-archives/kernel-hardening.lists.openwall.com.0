Return-Path: <kernel-hardening-return-19511-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 036AC2356CF
	for <lists+kernel-hardening@lfdr.de>; Sun,  2 Aug 2020 13:56:29 +0200 (CEST)
Received: (qmail 8051 invoked by uid 550); 2 Aug 2020 11:56:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 8026 invoked from network); 2 Aug 2020 11:56:20 -0000
Date: Sun, 2 Aug 2020 13:56:01 +0200
From: Pavel Machek <pavel@ucw.cz>
To: David Laight <David.Laight@ACULAB.COM>
Cc: 'Andy Lutomirski' <luto@kernel.org>,
	"madvenka@linux.microsoft.com" <madvenka@linux.microsoft.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux API <linux-api@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	linux-integrity <linux-integrity@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	LSM List <linux-security-module@vger.kernel.org>,
	Oleg Nesterov <oleg@redhat.com>, X86 ML <x86@kernel.org>
Subject: Re: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
Message-ID: <20200802115600.GB1162@bug>
References: <20200728131050.24443-1-madvenka@linux.microsoft.com>
 <CALCETrVy5OMuUx04-wWk9FJbSxkrT2vMfN_kANinudrDwC4Cig@mail.gmail.com>
 <b9879beef3e740c0aeb1af73485069a8@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b9879beef3e740c0aeb1af73485069a8@AcuMS.aculab.com>
User-Agent: Mutt/1.5.23 (2014-03-12)

Hi!

> > This is quite clever, but now I???m wondering just how much kernel help
> > is really needed. In your series, the trampoline is an non-executable
> > page.  I can think of at least two alternative approaches, and I'd
> > like to know the pros and cons.
> > 
> > 1. Entirely userspace: a return trampoline would be something like:
> > 
> > 1:
> > pushq %rax
> > pushq %rbc
> > pushq %rcx
> > ...
> > pushq %r15
> > movq %rsp, %rdi # pointer to saved regs
> > leaq 1b(%rip), %rsi # pointer to the trampoline itself
> > callq trampoline_handler # see below
> 
> For nested calls (where the trampoline needs to pass the
> original stack frame to the nested function) I think you
> just need a page full of:
> 	mov	$0, scratch_reg; jmp trampoline_handler

I believe you could do with mov %pc, scratch_reg; jmp ...

That has advantage of being able to share single physical page across multiple virtual pages...


									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
