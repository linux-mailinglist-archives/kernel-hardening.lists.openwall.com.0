Return-Path: <kernel-hardening-return-20065-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 05B0E27E5D8
	for <lists+kernel-hardening@lfdr.de>; Wed, 30 Sep 2020 11:59:31 +0200 (CEST)
Received: (qmail 20432 invoked by uid 550); 30 Sep 2020 09:59:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 20397 invoked from network); 30 Sep 2020 09:59:25 -0000
Date: Wed, 30 Sep 2020 10:58:50 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v4 09/29] arm64: disable recordmcount with
 DYNAMIC_FTRACE_WITH_REGS
Message-ID: <20200930095850.GA68612@C02TD0UTHF1T.local>
References: <20200929214631.3516445-1-samitolvanen@google.com>
 <20200929214631.3516445-10-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929214631.3516445-10-samitolvanen@google.com>

Hi Sami,

On Tue, Sep 29, 2020 at 02:46:11PM -0700, Sami Tolvanen wrote:
> Select FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY to disable
> recordmcount when DYNAMIC_FTRACE_WITH_REGS is selected.

Could you please add an explanation as to /why/ this is necessary in the
commit message? I couldn't figure this out form the commit message
alone, and reading the cover letter also didn't help.

If the minimum required GCC version supports patchable-function-entry
I'd be happy to make that a requirement for dynamic ftrace on arm64, as
then we'd only need to support one mechanism, and can get rid of some
redundant code. We already default to it when present anyhow.

> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> ---
>  arch/arm64/Kconfig | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 6d232837cbee..ad522b021f35 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -155,6 +155,8 @@ config ARM64
>  	select HAVE_DYNAMIC_FTRACE
>  	select HAVE_DYNAMIC_FTRACE_WITH_REGS \
>  		if $(cc-option,-fpatchable-function-entry=2)
> +	select FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY \
> +		if DYNAMIC_FTRACE_WITH_REGS

This doesn't look quite right to me. Presumably we shouldn't allow
DYNAMIC_FTRACE_WITH_REGS to be selected if HAVE_DYNAMIC_FTRACE_WITH_REGS
isn't.

Thanks,
Mark.
