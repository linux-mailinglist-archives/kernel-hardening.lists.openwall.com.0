Return-Path: <kernel-hardening-return-19439-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id EED4922CC41
	for <lists+kernel-hardening@lfdr.de>; Fri, 24 Jul 2020 19:37:16 +0200 (CEST)
Received: (qmail 32302 invoked by uid 550); 24 Jul 2020 17:37:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32282 invoked from network); 24 Jul 2020 17:37:10 -0000
Date: Fri, 24 Jul 2020 13:36:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Oscar Carter <oscar.carter@gmx.com>
Cc: Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
 linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Jann
 Horn <jannh@google.com>
Subject: Re: [PATCH v2 2/2] kernel/trace: Remove function callback casts
Message-ID: <20200724133656.76c75629@oasis.local.home>
In-Reply-To: <20200724171418.GB3123@ubuntu>
References: <20200719155033.24201-1-oscar.carter@gmx.com>
	<20200719155033.24201-3-oscar.carter@gmx.com>
	<20200721140545.445f0258@oasis.local.home>
	<20200724161921.GA3123@ubuntu>
	<20200724123528.36ea9c9e@oasis.local.home>
	<20200724171418.GB3123@ubuntu>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 24 Jul 2020 19:14:18 +0200
Oscar Carter <oscar.carter@gmx.com> wrote:

> > The linker trick should only affect architectures that don't implement
> > the needed features. I can make it so the linker trick is only applied
> > to those archs, and other archs that want more protection only need to
> > add these features to their architectures.
> 
> > It's much less intrusive than this patch.  
> 
> Sorry, but I don't understand your proposal. What features an arch need to
> add if want the CFI protection?

The better question is, what features should an arch add to not need
the linker trick ;-)

That is, they need to change it so that they add the two parameters
that is expected by the ftrace core code. Once they do that, then they
don't need to use the linker trick, and no function typecast is needed.

In other-words, if they support the ftrace_ops and regs passing, they
can define ARCH_SUPPORTS_FTRACE_OPS. Note, they don't even really need
to support the regs, (can just send NULL), if they don't have
HAVE_DYNAMIC_FTRACE_WITH_REGS.

Which BTW, is supported by the following architectures:

  arm
  arm64
  csky
  parisc
  powerpc
  riscv
  s390
  x86

All of the above architectures should not even be hitting the code that
does the function cast. What architecture are you doing all this for?

-- Steve
