Return-Path: <kernel-hardening-return-17576-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D0A0013EFD2
	for <lists+kernel-hardening@lfdr.de>; Thu, 16 Jan 2020 19:18:44 +0100 (CET)
Received: (qmail 1739 invoked by uid 550); 16 Jan 2020 18:18:39 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1706 invoked from network); 16 Jan 2020 18:18:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579198706;
	bh=eK+zgsqPWz6GAYkJtti8rLXXAgfol0Ms7k1eGuEjvcg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uSA1/16Jv5t+QkTG5DUYDIw5GCOnYY7mMdMEHjQJg4sRtJx0p92p7BGyiz1r3y+zt
	 HIA5X6uhHXR8fQZhMAgOktn72OxXqWdijpihtIWgO3rxYSaNPqu/WwZgGkRoZGgc3f
	 iezAkiFdQPopG1zeb3Cek072wQSLs3i8/5I2lSlQ=
Date: Thu, 16 Jan 2020 18:18:20 +0000
From: Will Deacon <will@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Dave Martin <Dave.Martin@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Jann Horn <jannh@google.com>,
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 12/15] arm64: vdso: disable Shadow Call Stack
Message-ID: <20200116181820.GB22420@willie-the-truck>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191206221351.38241-1-samitolvanen@google.com>
 <20191206221351.38241-13-samitolvanen@google.com>
 <20200116174648.GE21396@willie-the-truck>
 <CABCJKucWusLEaLyq=Dv5pWjxcUX7Q9dL=fSstwNK4eJ_6k33=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCJKucWusLEaLyq=Dv5pWjxcUX7Q9dL=fSstwNK4eJ_6k33=w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Jan 16, 2020 at 10:14:24AM -0800, Sami Tolvanen wrote:
> On Thu, Jan 16, 2020 at 9:46 AM Will Deacon <will@kernel.org> wrote:
> > Should we be removing -ffixed-x18 too, or does that not propagate here
> > anyway?
> 
> No, we shouldn't touch -ffixed-x18 here. The vDSO is always built with
> x18 reserved since commit 98cd3c3f83fbb ("arm64: vdso: Build vDSO with
> -ffixed-x18").

Thanks, in which case:

Acked-by: Will Deacon <will@kernel.org>

Will
