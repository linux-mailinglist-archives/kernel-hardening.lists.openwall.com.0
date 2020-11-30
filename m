Return-Path: <kernel-hardening-return-20468-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0D7062C8399
	for <lists+kernel-hardening@lfdr.de>; Mon, 30 Nov 2020 12:59:28 +0100 (CET)
Received: (qmail 5732 invoked by uid 550); 30 Nov 2020 11:59:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5704 invoked from network); 30 Nov 2020 11:59:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1606737549;
	bh=jcKRnTY2A7tTxLUEBA4FhjDB78+vG8Uu58hBCNu3Qs8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XbGPLq/Gdk/ASCNBy/7/E3wrn5zqLDESpvoy2UNHGZHuuXFZQPCXO7FbliCo+KTjL
	 dcpgEk4JxaUXIYiMKN86igCiutZADLzLXf9whER7tpQ4rNqnS6qJKWRrApd0RwpCLA
	 mDCVfehaZ+02umT+yBR6tKxGFcK/pkEQRrCuPSVg=
Date: Mon, 30 Nov 2020 11:59:03 +0000
From: Will Deacon <will@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH v7 16/17] arm64: disable recordmcount with
 DYNAMIC_FTRACE_WITH_REGS
Message-ID: <20201130115902.GD24563@willie-the-truck>
References: <20201118220731.925424-1-samitolvanen@google.com>
 <20201118220731.925424-17-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118220731.925424-17-samitolvanen@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Nov 18, 2020 at 02:07:30PM -0800, Sami Tolvanen wrote:
> DYNAMIC_FTRACE_WITH_REGS uses -fpatchable-function-entry, which makes
> running recordmcount unnecessary as there are no mcount calls in object
> files, and __mcount_loc doesn't need to be generated.
> 
> While there's normally no harm in running recordmcount even when it's
> not strictly needed, this won't work with LTO as we have LLVM bitcode
> instead of ELF objects.
> 
> This change selects FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY, which
> disables recordmcount when patchable function entries are used instead.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> ---
>  arch/arm64/Kconfig | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index 1515f6f153a0..c7f07978f5b6 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -158,6 +158,8 @@ config ARM64
>  	select HAVE_DYNAMIC_FTRACE
>  	select HAVE_DYNAMIC_FTRACE_WITH_REGS \
>  		if $(cc-option,-fpatchable-function-entry=2)
> +	select FTRACE_MCOUNT_USE_PATCHABLE_FUNCTION_ENTRY \
> +		if DYNAMIC_FTRACE_WITH_REGS

I don't really understand why this is in the arch header file, rather
than have the core code check for "fpatchable-function-entry=2" and expose
a CC_HAS_PATCHABLE_FUNCTION_ENTRY, but in the interest of making some
progress on this series:

Acked-by: Will Deacon <will@kernel.org>

Will
