Return-Path: <kernel-hardening-return-17922-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5EFD216EE80
	for <lists+kernel-hardening@lfdr.de>; Tue, 25 Feb 2020 19:58:47 +0100 (CET)
Received: (qmail 23588 invoked by uid 550); 25 Feb 2020 18:58:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23552 invoked from network); 25 Feb 2020 18:58:41 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Iv8nu0Tmrew9fnUnqPnKjAEYAPCBJwm2aHqQgQlHcXI=;
        b=OTDHNKDTmnSxFLlKliRJJ9/P+0Gj67aV93Z9DkDKQSb5UBIv6Lf9hta72mOKzV7lCA
         hgdCJGHTBdyOTlwFrBh3IP1/RsLtfWq4kGje6VP73W5eFbI6N6Io/NJxgJdkF05efPs5
         m+mbix3wNRslURQ37RuZEZxFXo2t0g1SvssQ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Iv8nu0Tmrew9fnUnqPnKjAEYAPCBJwm2aHqQgQlHcXI=;
        b=YPLrxP6DqDX5WRpbOsLcqeYqsEGKJy/rx7blAO6wgzx31SZmrou7+1BE//ROZKw4Dx
         8RO/K3vlbmBdN/GT0vXWT5GRvjsu7NkzITRw1lJcZx10AbbmkeM9Mh3VKZRD3fN7Qer8
         DAKeq25fVwDSbr4RGMoSNPkT/Kbhp5N0BkWWa8rHkuFLL7ELXoQoSkzV9KU7Hz6nFN9y
         RE+v6CM6rUebl07/U6A7iZ2TF2To9ErPEhIy84K1UP12LnQrI38mq86paQIaKqVjD/gO
         ePY2l3aaw/pqXWddm2MJtuNqceMKv+AqNjFSsQ0gxpzcYFDC9bdwUasy9nQ8LjU74rJ8
         AqoQ==
X-Gm-Message-State: APjAAAWNnpd0R9zegTA32XYzj9g5YcQMpT56HEv1npUy8HE4CQY27c9j
	OTY2qdipwEsVovEM2Mt0vZP6wQ==
X-Google-Smtp-Source: APXvYqwlFhU6hPGfLFawa58hpajX7pM4HYhMZNF5+kHXg+q9Uo6O71/hbEkW5Dj1+zEZt+TbulmPgw==
X-Received: by 2002:a63:ce03:: with SMTP id y3mr62064239pgf.427.1582657109996;
        Tue, 25 Feb 2020 10:58:29 -0800 (PST)
Date: Tue, 25 Feb 2020 10:58:28 -0800
From: Kees Cook <keescook@chromium.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Masahiro Yamada <masahiroy@kernel.org>,
	Emese Revfy <re.emese@gmail.com>,
	Michal Marek <michal.lkml@markovi.net>,
	kernel-hardening@lists.openwall.com, linux-doc@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gcc-plugins: fix gcc-plugins directory path in
 documentation
Message-ID: <202002251057.C4E397A@keescook>
References: <20200213122410.1605-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213122410.1605-1-masahiroy@kernel.org>

On Thu, Feb 13, 2020 at 09:24:10PM +0900, Masahiro Yamada wrote:
> Fix typos "plgins" -> "plugins".
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>

Thanks!

Acked-by: Kees Cook <keescook@chromium.org>

Jon, can you take this?

-Kees

> ---
> 
>  Documentation/kbuild/reproducible-builds.rst | 2 +-
>  scripts/gcc-plugins/Kconfig                  | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/kbuild/reproducible-builds.rst b/Documentation/kbuild/reproducible-builds.rst
> index 503393854e2e..3b25655e441b 100644
> --- a/Documentation/kbuild/reproducible-builds.rst
> +++ b/Documentation/kbuild/reproducible-builds.rst
> @@ -101,7 +101,7 @@ Structure randomisation
>  
>  If you enable ``CONFIG_GCC_PLUGIN_RANDSTRUCT``, you will need to
>  pre-generate the random seed in
> -``scripts/gcc-plgins/randomize_layout_seed.h`` so the same value
> +``scripts/gcc-plugins/randomize_layout_seed.h`` so the same value
>  is used in rebuilds.
>  
>  Debug info conflicts
> diff --git a/scripts/gcc-plugins/Kconfig b/scripts/gcc-plugins/Kconfig
> index e3569543bdac..7b63c819610c 100644
> --- a/scripts/gcc-plugins/Kconfig
> +++ b/scripts/gcc-plugins/Kconfig
> @@ -86,7 +86,7 @@ config GCC_PLUGIN_RANDSTRUCT
>  	  source tree isn't cleaned after kernel installation).
>  
>  	  The seed used for compilation is located at
> -	  scripts/gcc-plgins/randomize_layout_seed.h.  It remains after
> +	  scripts/gcc-plugins/randomize_layout_seed.h.  It remains after
>  	  a make clean to allow for external modules to be compiled with
>  	  the existing seed and will be removed by a make mrproper or
>  	  make distclean.
> -- 
> 2.17.1
> 

-- 
Kees Cook
