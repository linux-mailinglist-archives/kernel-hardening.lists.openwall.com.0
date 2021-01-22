Return-Path: <kernel-hardening-return-20698-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 584EA300C75
	for <lists+kernel-hardening@lfdr.de>; Fri, 22 Jan 2021 20:34:03 +0100 (CET)
Received: (qmail 27811 invoked by uid 550); 22 Jan 2021 19:33:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 27776 invoked from network); 22 Jan 2021 19:33:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PRHYirbpaVjReacEED4lbaCE3EfoPDnBMgBWDqUdb1M=;
        b=jcbK3Jb+1ldTw8xuHGcbe/WyAd9rzEWhNsbjwzL7GUFNO0kBbs7g9+lznqTJXv5guQ
         ThmJrhp8cBtmrAw3PicbPDCzSDRMsMTXouV2Ed/Soxu0Aianbna8t6Eyn8vx3xOUitbj
         /UrYMZXa4Z2WVDt0h6nszyYChGEcP/Gw8IFgQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PRHYirbpaVjReacEED4lbaCE3EfoPDnBMgBWDqUdb1M=;
        b=o34HIhrLOvTywSYUFk1rsQjCXrj8lQ/BJtTLtfb6dmWu2UHwKDX2lbvd8WizcibDo8
         Sh86Y95EuoJKcExc2HYE7wJj4Ic4BhsdZ1DJQy0A1PwvHF6Z+zm66d1Fk8TM7Ekci/RU
         W0y1XcVUKmtM8mdXD56YwJ8U8prqtA2Lw+bDTWgkl9rUfk6aYciqWo7fdRSgaixJxFZk
         Ld68W80ZRy5wP0Ywjwwa7TJt/bDZ0jQ1QGDB6/CNWyO3YvDBpo6PAHrEYSb9PKiqCAXP
         oS1jCouS0AzXuflLCaodmrJp5YdmQ21YYmk9V5I355pJY96BRzovsBBcMe6pCTYJbs1h
         YV/w==
X-Gm-Message-State: AOAM530RaemIJb4Hoj/6/wNr3SBpWGPazAjvrRGEGKYEa93+j/4gbIyq
	TxlKQSR1UL2t8wwGB7RtaKe2Tw==
X-Google-Smtp-Source: ABdhPJzSZ+w9Sa36H0s07wBdXa3HqO3jCZJZAhirfObi0OICrHS6njgn1JnYamu9MMLKfJqtYJ237g==
X-Received: by 2002:a63:1e1e:: with SMTP id e30mr1322451pge.156.1611344023652;
        Fri, 22 Jan 2021 11:33:43 -0800 (PST)
Date: Fri, 22 Jan 2021 11:33:41 -0800
From: Kees Cook <keescook@chromium.org>
To: Alexander Lobakin <alobakin@pm.me>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Michal Marek <michal.lkml@markovi.net>,
	kernel-hardening@lists.openwall.com,
	linux-hardening@vger.kernel.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH kspp-next] kbuild: prevent CC_FLAGS_LTO self-bloating on
 recursive rebuilds
Message-ID: <202101221133.389539337D@keescook>
References: <20210121184544.659998-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210121184544.659998-1-alobakin@pm.me>

On Thu, Jan 21, 2021 at 06:45:55PM +0000, Alexander Lobakin wrote:
> CC_FLAGS_LTO gets initialized only via +=, never with := or =.
> When building with CONFIG_TRIM_UNUSED_KSYMS, Kbuild may perform
> several kernel rebuilds to satisfy symbol dependencies. In this
> case, value of CC_FLAGS_LTO is concatenated each time, which
> triggers a full rebuild.
> Initialize it with := to fix this.
> 
> Fixes: dc5723b02e52 ("kbuild: add support for Clang LTO")
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>

Ah-ha, good catch; thanks!

I'll get this into the tree.

-Kees

> ---
>  Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 668909e7a460..2233951666f7 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -895,10 +895,10 @@ endif
>  
>  ifdef CONFIG_LTO_CLANG
>  ifdef CONFIG_LTO_CLANG_THIN
> -CC_FLAGS_LTO	+= -flto=thin -fsplit-lto-unit
> +CC_FLAGS_LTO	:= -flto=thin -fsplit-lto-unit
>  KBUILD_LDFLAGS	+= --thinlto-cache-dir=$(extmod-prefix).thinlto-cache
>  else
> -CC_FLAGS_LTO	+= -flto
> +CC_FLAGS_LTO	:= -flto
>  endif
>  CC_FLAGS_LTO	+= -fvisibility=hidden
>  
> -- 
> 2.30.0
> 
> 

-- 
Kees Cook
