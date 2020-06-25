Return-Path: <kernel-hardening-return-19169-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 1C09820A508
	for <lists+kernel-hardening@lfdr.de>; Thu, 25 Jun 2020 20:34:21 +0200 (CEST)
Received: (qmail 31776 invoked by uid 550); 25 Jun 2020 18:34:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 31744 invoked from network); 25 Jun 2020 18:34:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=y2Ojs6irYhJzJUoW2yptAyQ6Kl6zMJCInJSngjbNQ4k=; b=wPU1z5k3Ml8/8VR2O2qUXsjcNX
	mwQyLG6nIg2KWHEaauq336GU71DYcaC9fvteoGwgeztFDz+Qr+r6qYGmD/h1awSbcjBNTa20+pV6y
	wYcQ+rBbyT/ESBejKPeACzRUe0tyI8DcJ0dIdxGgfa433lwF9MVVPvBuCkOeqsrHvE3S3cA1Nz/Ca
	FSlJ8vacxd5Qd9Wf7xj4ooDjY4ZrKPiqnlnnECSxhDYxqkmaq8sTmK5uPCsLm/Pzg+Q828mmI0YcN
	Qzx9rXsE0ZNx9BqNpDrRqgox7b3W7tCQDeiBGKY3wQj+ESadCWScGah7We+H4zNleZYjJk6D6gMss
	cNde5s6g==;
Date: Thu, 25 Jun 2020 20:33:51 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH 05/22] kbuild: lto: postpone objtool
Message-ID: <20200625183351.GH4800@hirez.programming.kicks-ass.net>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-6-samitolvanen@google.com>
 <20200624211908.GT4817@hirez.programming.kicks-ass.net>
 <20200624214925.GB120457@google.com>
 <20200625074716.GX4817@hirez.programming.kicks-ass.net>
 <20200625162226.GC173089@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625162226.GC173089@google.com>

On Thu, Jun 25, 2020 at 09:22:26AM -0700, Sami Tolvanen wrote:
> On Thu, Jun 25, 2020 at 09:47:16AM +0200, Peter Zijlstra wrote:

> > Right, then we need to make --no-vmlinux work properly when
> > !DEBUG_ENTRY, which I think might be buggered due to us overriding the
> > argument when the objname ends with "vmlinux.o".
> 
> Right. Can we just remove that and  pass --vmlinux to objtool in
> link-vmlinux.sh, or is the override necessary somewhere else?

Think we can remove it; it was just convenient when running manually.

> > > > > +ifdef CONFIG_STACK_VALIDATION
> > > > > +ifneq ($(SKIP_STACK_VALIDATION),1)
> > > > > +cmd_ld_ko_o +=								\
> > > > > +	$(objtree)/tools/objtool/objtool				\
> > > > > +		$(if $(CONFIG_UNWINDER_ORC),orc generate,check)		\
> > > > > +		--module						\
> > > > > +		$(if $(CONFIG_FRAME_POINTER),,--no-fp)			\
> > > > > +		$(if $(CONFIG_GCOV_KERNEL),--no-unreachable,)		\
> > > > > +		$(if $(CONFIG_RETPOLINE),--retpoline,)			\
> > > > > +		$(if $(CONFIG_X86_SMAP),--uaccess,)			\
> > > > > +		$(@:.ko=$(prelink-ext).o);
> > > > > +
> > > > > +endif # SKIP_STACK_VALIDATION
> > > > > +endif # CONFIG_STACK_VALIDATION
> > > > 
> > > > What about the objtool invocation from link-vmlinux.sh ?
> > > 
> > > What about it? The existing objtool_link invocation in link-vmlinux.sh
> > > works fine for our purposes as well.
> > 
> > Well, I was wondering why you're adding yet another objtool invocation
> > while we already have one.
> 
> Because we can't run objtool until we have compiled bitcode to native
> code, so for modules, we're need another invocation after everything has
> been compiled.

Well, that I understand, my question was why we need one in
scripts/link-vmlinux.sh and an additional one. I think we're just
talking past one another and agree we only need one.
