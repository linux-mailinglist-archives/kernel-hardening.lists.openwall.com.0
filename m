Return-Path: <kernel-hardening-return-19163-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id ACB9E209B4B
	for <lists+kernel-hardening@lfdr.de>; Thu, 25 Jun 2020 10:27:29 +0200 (CEST)
Received: (qmail 23716 invoked by uid 550); 25 Jun 2020 08:27:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23684 invoked from network); 25 Jun 2020 08:27:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593073632;
	bh=GncOVRnsRbmrObVuGed/d33M2KDkzxTcEILATAJbLBA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KLWf/lD9VcylMACtq8p1wJiRL0bWr2kYSku0VKCkfSWkCAqHKhXHxHOSwvWTS7j3l
	 w9u9NiMdpF5uccefpWlPwAM4Q9i0V+Qe7aZAsJdNvHebMPPRWYp9leOEenbVEgwE27
	 4Y8WoUS9Iu/d8VHbgPuJp11WLopn88ZGoDVDvOts=
Date: Thu, 25 Jun 2020 09:27:06 +0100
From: Will Deacon <will@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH 00/22] add support for Clang LTO
Message-ID: <20200625082706.GA7584@willie-the-truck>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624211540.GS4817@hirez.programming.kicks-ass.net>
 <20200624213014.GB26253@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624213014.GB26253@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Jun 24, 2020 at 02:30:14PM -0700, Sami Tolvanen wrote:
> On Wed, Jun 24, 2020 at 11:15:40PM +0200, Peter Zijlstra wrote:
> > On Wed, Jun 24, 2020 at 01:31:38PM -0700, Sami Tolvanen wrote:
> > > This patch series adds support for building x86_64 and arm64 kernels
> > > with Clang's Link Time Optimization (LTO).
> > > 
> > > In addition to performance, the primary motivation for LTO is to allow
> > > Clang's Control-Flow Integrity (CFI) to be used in the kernel. Google's
> > > Pixel devices have shipped with LTO+CFI kernels since 2018.
> > > 
> > > Most of the patches are build system changes for handling LLVM bitcode,
> > > which Clang produces with LTO instead of ELF object files, postponing
> > > ELF processing until a later stage, and ensuring initcall ordering.
> > > 
> > > Note that first objtool patch in the series is already in linux-next,
> > > but as it's needed with LTO, I'm including it also here to make testing
> > > easier.
> > 
> > I'm very sad that yet again, memory ordering isn't addressed. LTO vastly
> > increases the range of the optimizer to wreck things.
> 
> I believe Will has some thoughts about this, and patches, but I'll let
> him talk about it.

Thanks for reminding me! I will get patches out ASAP (I've been avoiding the
rebase from hell, but this is the motivation I need).

Will
