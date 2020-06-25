Return-Path: <kernel-hardening-return-19155-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9B387209743
	for <lists+kernel-hardening@lfdr.de>; Thu, 25 Jun 2020 01:52:03 +0200 (CEST)
Received: (qmail 4041 invoked by uid 550); 24 Jun 2020 23:51:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 4009 invoked from network); 24 Jun 2020 23:51:57 -0000
IronPort-SDR: rffOolwPtVDSqaGb5QT7Llf4n55+tlKLXz1m5dIe0+r/kT7AQuOPSlespZUhApLNH9ar+jgx8c
 3vvn5J6/ZXWQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9662"; a="133107160"
X-IronPort-AV: E=Sophos;i="5.75,277,1589266800"; 
   d="scan'208";a="133107160"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
IronPort-SDR: aIRwRfjfYOdQKt3phW/InEgXxtOGI/IQstcHLZdz056+zuNv6rXZAztOwLlpT5Cd5ScDQD9lHH
 /YX4kqyPmgHA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,277,1589266800"; 
   d="scan'208";a="423544015"
Date: Wed, 24 Jun 2020 16:51:44 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 17/22] arm64: vdso: disable LTO
Message-ID: <20200624235144.GD818054@tassilo.jf.intel.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-18-samitolvanen@google.com>
 <CAKwvOdnEbCfYZ9o=OF51oswyqDvN4iP-9syWUDhxfueq4q0xcw@mail.gmail.com>
 <CAKwvOdm_EBfmV+GvDE-COoDwpEm9snea4_KtuFyorA5KEU6FbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdm_EBfmV+GvDE-COoDwpEm9snea4_KtuFyorA5KEU6FbQ@mail.gmail.com>

On Wed, Jun 24, 2020 at 02:09:40PM -0700, Nick Desaulniers wrote:
> On Wed, Jun 24, 2020 at 1:58 PM Nick Desaulniers
> <ndesaulniers@google.com> wrote:
> >
> > On Wed, Jun 24, 2020 at 1:33 PM Sami Tolvanen <samitolvanen@google.com> wrote:
> > >
> > > Filter out CC_FLAGS_LTO for the vDSO.
> >
> > Just curious about this patch (and the following one for x86's vdso),
> > do you happen to recall specifically what the issues with the vdso's
> > are?
> 
> + Andi (tangential, I actually have a bunch of tabs open with slides
> from http://halobates.de/ right now)
> 58edae3aac9f2
> 67424d5a22124
> $ git log -S DISABLE_LTO

I think I did it originally because the vDSO linker step didn't do
all the magic needed for gcc LTO. But it also doesn't seem to be
very useful for just a few functions that don't have complex
interactions, and somewhat risky for violating some assumptions.

-Andi
