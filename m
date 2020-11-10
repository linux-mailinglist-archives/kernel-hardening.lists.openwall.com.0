Return-Path: <kernel-hardening-return-20378-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8B93F2ADD50
	for <lists+kernel-hardening@lfdr.de>; Tue, 10 Nov 2020 18:46:42 +0100 (CET)
Received: (qmail 13401 invoked by uid 550); 10 Nov 2020 17:46:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13380 invoked from network); 10 Nov 2020 17:46:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1605030383;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iLppkAldaglNseeA1mLxrkn09RICx19onIxN5TInB1E=;
	b=dsK+SVxdCN9uBhZak8u5QSkGQBNp63uIubpBsNu7wgSv1FZM1YEeY8AGv2ptbGEZafh7eZ
	zT5JgPb0cOdjknTg/a1f9K1VA3VCw11P4F2z2tP7WZ/f83HsZGp+aUoCAu66dZ8yzszAjv
	340P2TtI8eq8D9Zo3Xh4Jur9taO/ZpU=
X-MC-Unique: k_d5_NtXO2qoXW_XbKINLw-1
Date: Tue, 10 Nov 2020 11:46:06 -0600
From: Josh Poimboeuf <jpoimboe@redhat.com>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
	the arch/x86 maintainers <x86@kernel.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	linux-kbuild <linux-kbuild@vger.kernel.org>,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-pci@vger.kernel.org
Subject: Re: [PATCH v6 22/25] x86/asm: annotate indirect jumps
Message-ID: <20201110174606.mp5m33lgqksks4mt@treble>
References: <20201015102216.GB2611@hirez.programming.kicks-ass.net>
 <20201015203942.f3kwcohcwwa6lagd@treble>
 <CABCJKufDLmBCwmgGnfLcBw_B_4U8VY-R-dSNNp86TFfuMobPMw@mail.gmail.com>
 <20201020185217.ilg6w5l7ujau2246@treble>
 <CABCJKucVjFtrOsw58kn4OnW5kdkUh8G7Zs4s6QU9s6O7soRiAA@mail.gmail.com>
 <20201021085606.GZ2628@hirez.programming.kicks-ass.net>
 <CABCJKufL6=FiaeD8T0P+mK4JeR9J80hhjvJ6Z9S-m9UnCESxVA@mail.gmail.com>
 <20201023173617.GA3021099@google.com>
 <CABCJKuee7hUQSiksdRMYNNx05bW7pWaDm4fQ__znGQ99z9-dEw@mail.gmail.com>
 <20201110022924.tekltjo25wtrao7z@treble>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201110022924.tekltjo25wtrao7z@treble>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15

On Mon, Nov 09, 2020 at 08:29:24PM -0600, Josh Poimboeuf wrote:
> On Mon, Nov 09, 2020 at 03:11:41PM -0800, Sami Tolvanen wrote:
> > CONFIG_XEN
> > 
> > __switch_to_asm()+0x0: undefined stack state
> >   xen_hypercall_set_trap_table()+0x0: <=== (sym)

With your branch + GCC 9 I can recreate all the warnings except this
one.

Will do some digging on the others...

-- 
Josh

