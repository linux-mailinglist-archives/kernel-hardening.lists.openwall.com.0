Return-Path: <kernel-hardening-return-17578-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E485613F0DD
	for <lists+kernel-hardening@lfdr.de>; Thu, 16 Jan 2020 19:25:13 +0100 (CET)
Received: (qmail 9516 invoked by uid 550); 16 Jan 2020 18:25:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9496 invoked from network); 16 Jan 2020 18:25:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579199096;
	bh=Uvn4io9HRoCWehKj5QlRdjNGEEGcA1mRcdpz3dLBqGs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=0CKqRrAnK+geRIGoLgKnBDxnHagxynAqskFtIRJ9DfMZWKYtbc1dCbzt1+SfM2sjc
	 hnVnjWETX8zzmlDO2rucuD7erQEPcfSJVahwFRoGLWRtDIXk5QdfPs8irawGcLG9X7
	 3jkFCB+/ojXqzQSHWy0dF/yM2x/Ww6byyiuTepeA=
Date: Thu, 16 Jan 2020 18:24:50 +0000
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
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 00/15] add support for Clang's Shadow Call Stack
Message-ID: <20200116182449.GD22420@willie-the-truck>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191206221351.38241-1-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191206221351.38241-1-samitolvanen@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, Dec 06, 2019 at 02:13:36PM -0800, Sami Tolvanen wrote:
> This patch series adds support for Clang's Shadow Call Stack
> (SCS) mitigation, which uses a separately allocated shadow stack
> to protect against return address overwrites. More information
> can be found here:
> 
>   https://clang.llvm.org/docs/ShadowCallStack.html

I've queued the first four via arm64.

Will
