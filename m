Return-Path: <kernel-hardening-return-19412-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 36F4E229ED6
	for <lists+kernel-hardening@lfdr.de>; Wed, 22 Jul 2020 19:58:57 +0200 (CEST)
Received: (qmail 29900 invoked by uid 550); 22 Jul 2020 17:58:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 29878 invoked from network); 22 Jul 2020 17:58:51 -0000
Date: Wed, 22 Jul 2020 13:58:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Masahiro Yamada
 <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, Kees
 Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>,
 clang-built-linux <clang-built-linux@googlegroups.com>, Kernel Hardening
 <kernel-hardening@lists.openwall.com>, linux-arch
 <linux-arch@vger.kernel.org>, linux-arm-kernel
 <linux-arm-kernel@lists.infradead.org>, linux-kbuild
 <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 linux-pci@vger.kernel.org, X86 ML <x86@kernel.org>, Josh Poimboeuf
 <jpoimboe@redhat.com>
Subject: Re: [RFC][PATCH] objtool,x86_64: Replace recordmcount with objtool
Message-ID: <20200722135829.7ca6fbc5@oasis.local.home>
In-Reply-To: <CABCJKucDrS9wNZLjtmN5qMbZBTHLvB1Z7WqTwT3b11-K4kNcyg@mail.gmail.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
	<20200624203200.78870-5-samitolvanen@google.com>
	<20200624212737.GV4817@hirez.programming.kicks-ass.net>
	<20200624214530.GA120457@google.com>
	<20200625074530.GW4817@hirez.programming.kicks-ass.net>
	<20200625161503.GB173089@google.com>
	<20200625200235.GQ4781@hirez.programming.kicks-ass.net>
	<20200625224042.GA169781@google.com>
	<20200626112931.GF4817@hirez.programming.kicks-ass.net>
	<CABCJKucSM7gqWmUtiBPbr208wB0pc25afJXc6yBQzJDZf4LSWA@mail.gmail.com>
	<20200717133645.7816c0b6@oasis.local.home>
	<CABCJKuda0AFCZ-1J2NTLc-M0xax007a9u-fzOoxmU2z60jvzbA@mail.gmail.com>
	<20200717140545.6f008208@oasis.local.home>
	<CABCJKucDrS9wNZLjtmN5qMbZBTHLvB1Z7WqTwT3b11-K4kNcyg@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 20 Jul 2020 09:52:37 -0700
Sami Tolvanen <samitolvanen@google.com> wrote:

> > Does x86 have a way to differentiate between the two that record mcount
> > can check?  
> 
> I'm not sure if looking at the relocation alone is sufficient on x86,
> we might also have to decode the instruction, which is what objtool
> does. Did you have any thoughts on Peter's patch, or my initial
> suggestion, which adds a __nomcount attribute to affected functions?

There's a lot of code in this thread. Can you give me the message-id of
Peter's patch in question.

Thanks,

-- Steve
