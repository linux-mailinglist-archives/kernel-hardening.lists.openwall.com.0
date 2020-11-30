Return-Path: <kernel-hardening-return-20469-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 50A592C83A3
	for <lists+kernel-hardening@lfdr.de>; Mon, 30 Nov 2020 13:00:46 +0100 (CET)
Received: (qmail 7778 invoked by uid 550); 30 Nov 2020 12:00:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7746 invoked from network); 30 Nov 2020 12:00:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1606737627;
	bh=HBOIO8GaCg6xuTGjJaH9CwIBSnKPzHwxyZUymO54yi0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=yzM9f+2t0xm2UaSKWFUKTi0QtGsVMKXqHXBS1Z7u81tBEmBY8l8f7Hsa1i2mw4qyd
	 fvd85qZ6OMwkW1qqkN71XY+4V/XfXkDnI1y+duNB0L2COvyVv3mGOw0HVIw6ROw3sk
	 6KhUBLTX11sbbhPwamUk+q9jexDlZ968PrKAzHsg=
Date: Mon, 30 Nov 2020 12:00:21 +0000
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
Subject: Re: [PATCH v7 17/17] arm64: allow LTO_CLANG and THINLTO to be
 selected
Message-ID: <20201130120021.GE24563@willie-the-truck>
References: <20201118220731.925424-1-samitolvanen@google.com>
 <20201118220731.925424-18-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201118220731.925424-18-samitolvanen@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Nov 18, 2020 at 02:07:31PM -0800, Sami Tolvanen wrote:
> Allow CONFIG_LTO_CLANG and CONFIG_THINLTO to be enabled.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/arm64/Kconfig | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
> index c7f07978f5b6..56bd83a764f4 100644
> --- a/arch/arm64/Kconfig
> +++ b/arch/arm64/Kconfig
> @@ -73,6 +73,8 @@ config ARM64
>  	select ARCH_USE_SYM_ANNOTATIONS
>  	select ARCH_SUPPORTS_MEMORY_FAILURE
>  	select ARCH_SUPPORTS_SHADOW_CALL_STACK if CC_HAVE_SHADOW_CALL_STACK
> +	select ARCH_SUPPORTS_LTO_CLANG
> +	select ARCH_SUPPORTS_THINLTO

Acked-by: Will Deacon <will@kernel.org>

Will
