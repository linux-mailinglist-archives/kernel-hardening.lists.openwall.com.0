Return-Path: <kernel-hardening-return-20230-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 01E56294286
	for <lists+kernel-hardening@lfdr.de>; Tue, 20 Oct 2020 20:52:51 +0200 (CEST)
Received: (qmail 13501 invoked by uid 550); 20 Oct 2020 18:52:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13478 invoked from network); 20 Oct 2020 18:52:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1603219953;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oyUoHsRQhW9Pp4iIO9savPkdYtOE6vEjDDEEmlMww18=;
	b=KRf3NvWHkK2GE7nXgomITyNOOrR7WuvachroMvY5YU5nP+WSwLX8FqQ46zzbOF1EH8RNct
	fc/gMptPgis+R1LRcfOazl6ugjpbCXppnc+B5yHujXsvsbiQ3WvXs8QkljAyZg+le2eVBF
	DVqksy0pPDl8OFLG7UUS/2znGUWj/Fc=
X-MC-Unique: K36-fE2_MKaUTN0-WM3Zrg-1
Date: Tue, 20 Oct 2020 13:52:17 -0500
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
Message-ID: <20201020185217.ilg6w5l7ujau2246@treble>
References: <20201013003203.4168817-1-samitolvanen@google.com>
 <20201013003203.4168817-23-samitolvanen@google.com>
 <CAG48ez2baAvKDA0wfYLKy-KnM_1CdOwjU873VJGDM=CErjsv_A@mail.gmail.com>
 <20201015102216.GB2611@hirez.programming.kicks-ass.net>
 <20201015203942.f3kwcohcwwa6lagd@treble>
 <CABCJKufDLmBCwmgGnfLcBw_B_4U8VY-R-dSNNp86TFfuMobPMw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABCJKufDLmBCwmgGnfLcBw_B_4U8VY-R-dSNNp86TFfuMobPMw@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11

On Tue, Oct 20, 2020 at 09:45:06AM -0700, Sami Tolvanen wrote:
> On Thu, Oct 15, 2020 at 1:39 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
> >
> > On Thu, Oct 15, 2020 at 12:22:16PM +0200, Peter Zijlstra wrote:
> > > On Thu, Oct 15, 2020 at 01:23:41AM +0200, Jann Horn wrote:
> > >
> > > > It would probably be good to keep LTO and non-LTO builds in sync about
> > > > which files are subjected to objtool checks. So either you should be
> > > > removing the OBJECT_FILES_NON_STANDARD annotations for anything that
> > > > is linked into the main kernel (which would be a nice cleanup, if that
> > > > is possible),
> > >
> > > This, I've had to do that for a number of files already for the limited
> > > vmlinux.o passes we needed for noinstr validation.
> >
> > Getting rid of OBJECT_FILES_NON_STANDARD is indeed the end goal, though
> > I'm not sure how practical that will be for some of the weirder edge
> > case.
> >
> > On a related note, I have some old crypto cleanups which need dusting
> > off.
> 
> Building allyesconfig with this series and LTO enabled, I still see
> the following objtool warnings for vmlinux.o, grouped by source file:
> 
> arch/x86/entry/entry_64.S:
> __switch_to_asm()+0x0: undefined stack state
> .entry.text+0xffd: sibling call from callable instruction with
> modified stack frame
> .entry.text+0x48: stack state mismatch: cfa1=7-8 cfa2=-1+0

Not sure what this one's about, there's no OBJECT_FILES_NON_STANDARD?

> arch/x86/entry/entry_64_compat.S:
> .entry.text+0x1754: unsupported instruction in callable function
> .entry.text+0x1634: redundant CLD
> .entry.text+0x15fd: stack state mismatch: cfa1=7-8 cfa2=-1+0
> .entry.text+0x168c: stack state mismatch: cfa1=7-8 cfa2=-1+0

Ditto.

> arch/x86/kernel/head_64.S:
> .head.text+0xfb: unsupported instruction in callable function

Ditto.

> arch/x86/kernel/acpi/wakeup_64.S:
> do_suspend_lowlevel()+0x116: sibling call from callable instruction
> with modified stack frame

We'll need to look at how to handle this one.

> arch/x86/crypto/camellia-aesni-avx2-asm_64.S:
> camellia_cbc_dec_32way()+0xb3: stack state mismatch: cfa1=7+520 cfa2=7+8
> camellia_ctr_32way()+0x1a: stack state mismatch: cfa1=7+520 cfa2=7+8

I can clean off my patches for all the crypto warnings.

> arch/x86/lib/retpoline.S:
> __x86_retpoline_rdi()+0x10: return with modified stack frame
> __x86_retpoline_rdi()+0x0: stack state mismatch: cfa1=7+32 cfa2=7+8
> __x86_retpoline_rdi()+0x0: stack state mismatch: cfa1=7+32 cfa2=-1+0

Is this with upstream?  I thought we fixed that with
UNWIND_HINT_RET_OFFSET.

> Josh, Peter, any thoughts on what would be the preferred way to fix
> these, or how to tell objtool to ignore this code?

One way or another, the patches need to be free of warnings before
getting merged.  I can help, though I'm traveling and only have limited
bandwidth for at least the rest of the month.

Ideally we'd want to have objtool understand everything, with no
whitelisting, but some cases (e.g. suspend code) can be tricky.

I wouldn't be opposed to embedding the whitelist in the binary, in a
discardable section.  It should be relatively easy, but as I mentioned I
may or may not have time to work on it for a bit.  I'm working half
days, and now the ocean beckons from the window of my camper.

-- 
Josh

