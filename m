Return-Path: <kernel-hardening-return-19139-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5C322207E64
	for <lists+kernel-hardening@lfdr.de>; Wed, 24 Jun 2020 23:21:17 +0200 (CEST)
Received: (qmail 24214 invoked by uid 550); 24 Jun 2020 21:21:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24182 invoked from network); 24 Jun 2020 21:21:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jL5/nBQ2OUP0iahePtvie+O7JpbFb9Sg2cWrP7q25CU=; b=tCg/wFYtRwvv+wLp9PXDSfPdmx
	05NfkblFR1fTK0rTrKIOXZGlXZ+JCANTa1zrKQbLvzxUN8BLw2M1X+2KYUk3piceBuyoZSqhQIJLX
	BmiRFl6Mw00wYlENMfdTE5tCN9J+uAiMiMhCC9zMR7poqnCgl97vg6/iexEfNsjUqD7YUz57hK5wa
	zUbF285iGX8+ETEk4lhuQ53Ajdkurwj1DNy8jcWRRbScXubcskSeUi6aAeV5gqR0NXzuqYeVfjl5W
	kuvvVNo2h26+DJDawt8+bqb0a15CxZeoBoHxXeE/9SI5cv/tVhPiBJvvk6jL6XXXVfZnkMsujW67G
	qNdoj+fQ==;
Date: Wed, 24 Jun 2020 23:20:55 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org, George Burgess IV <gbiv@google.com>
Subject: Re: [PATCH 06/22] kbuild: lto: limit inlining
Message-ID: <20200624212055.GU4817@hirez.programming.kicks-ass.net>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-7-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624203200.78870-7-samitolvanen@google.com>

On Wed, Jun 24, 2020 at 01:31:44PM -0700, Sami Tolvanen wrote:
> This change limits function inlining across translation unit
> boundaries in order to reduce the binary size with LTO.
> 
> The -import-instr-limit flag defines a size limit, as the number
> of LLVM IR instructions, for importing functions from other TUs.
> The default value is 100, and decreasing it to 5 reduces the size
> of a stripped arm64 defconfig vmlinux by 11%.

Is that also the right number for x86? What about the effect on
performance? What did 6 do? or 4?

> Suggested-by: George Burgess IV <gbiv@google.com>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> ---
>  Makefile | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Makefile b/Makefile
> index 3a7e5e5c17b9..ee66513a5b66 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -894,6 +894,10 @@ else
>  CC_FLAGS_LTO_CLANG := -flto
>  endif
>  CC_FLAGS_LTO_CLANG += -fvisibility=default
> +
> +# Limit inlining across translation units to reduce binary size
> +LD_FLAGS_LTO_CLANG := -mllvm -import-instr-limit=5
> +KBUILD_LDFLAGS += $(LD_FLAGS_LTO_CLANG)
>  endif
>  
>  ifdef CONFIG_LTO
> -- 
> 2.27.0.212.ge8ba1cc988-goog
> 
