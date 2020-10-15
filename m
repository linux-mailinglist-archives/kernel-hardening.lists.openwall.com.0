Return-Path: <kernel-hardening-return-20214-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 403E728F01A
	for <lists+kernel-hardening@lfdr.de>; Thu, 15 Oct 2020 12:22:48 +0200 (CEST)
Received: (qmail 27935 invoked by uid 550); 15 Oct 2020 10:22:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 27915 invoked from network); 15 Oct 2020 10:22:40 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rmt+w86dS/ArDl7p6coE3p1FQiRlDnETDOF85EAeo80=; b=H7urFq9tcKjVEHrGlgs6qqhDf4
	oQMvOJQ0ykGC0OUWm6j6P40c2ClfoS4N1iUdDzI7NszgLIB2YI4qMJ892z90AJsTn11EvwW+MtOVh
	ddVXM7uYTIl+ahd+gEQFvcaxfyuaPnkbEsTt/vmXLtStZfCQlSfc+oQ9GKbTIbh1QtEndZUFKS8iQ
	RG2CeCNJ8oLWOZ1j2VOtlC36cNeboOcj3IpHWd0dVqImsYZOp+GtYIoL4M+5SqxrBrt55upHkAlVA
	rdh+0h6U56l/Lqn5r2zQ2t0WOc1/OVeHC7M8/6/Im8NyIi7W3dDDZL1d8iqegaLUsqXcJBsUpBLPv
	pDxD+k8g==;
Date: Thu, 15 Oct 2020 12:22:16 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jann Horn <jannh@google.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
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
	linux-kbuild@vger.kernel.org,
	kernel list <linux-kernel@vger.kernel.org>,
	linux-pci@vger.kernel.org
Subject: Re: [PATCH v6 22/25] x86/asm: annotate indirect jumps
Message-ID: <20201015102216.GB2611@hirez.programming.kicks-ass.net>
References: <20201013003203.4168817-1-samitolvanen@google.com>
 <20201013003203.4168817-23-samitolvanen@google.com>
 <CAG48ez2baAvKDA0wfYLKy-KnM_1CdOwjU873VJGDM=CErjsv_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez2baAvKDA0wfYLKy-KnM_1CdOwjU873VJGDM=CErjsv_A@mail.gmail.com>

On Thu, Oct 15, 2020 at 01:23:41AM +0200, Jann Horn wrote:

> It would probably be good to keep LTO and non-LTO builds in sync about
> which files are subjected to objtool checks. So either you should be
> removing the OBJECT_FILES_NON_STANDARD annotations for anything that
> is linked into the main kernel (which would be a nice cleanup, if that
> is possible), 

This, I've had to do that for a number of files already for the limited
vmlinux.o passes we needed for noinstr validation.
