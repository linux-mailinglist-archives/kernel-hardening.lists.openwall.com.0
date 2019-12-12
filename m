Return-Path: <kernel-hardening-return-17499-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 257C311C627
	for <lists+kernel-hardening@lfdr.de>; Thu, 12 Dec 2019 08:00:25 +0100 (CET)
Received: (qmail 32576 invoked by uid 550); 12 Dec 2019 07:00:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 19646 invoked from network); 12 Dec 2019 04:52:42 -0000
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-04.nifty.com xBC4q23I008316
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
	s=dec2015msa; t=1576126323;
	bh=TyTFhnCKN2YT9bgwjekkQfef7OcPW8tA1OCfAFWZK7Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=A7yKkfSAcs9WjoquxzLh7cMFno8KGaAwFSH0NIn9ESuM6QSL/TUGtVFFbTa8/xu0r
	 wQVmdp/Pe9koFAp6WKmBLh3ri+Kl32LgSe8/nZ/SMkRf44czRfl6X3ZcGUSrXDa+Mn
	 oWW1ouviggHFzlGX53/yURcUMqqueqGKosTv0OZ45wjBVfTjwjF6Y4nRnEIS9p4yLd
	 6LXBVMLZH3Yfr4SVlGxe6+4SxWgBxDzjlRKpTAp0QvK6vpue1IzqMBBfmO/qKsz6/J
	 IHf8jAfgfV4pGvwPlGtVfoy2SCebW0f/u4ssKUQpcIk0cJC+miKFQW2VdBnFpvfn0q
	 jGcgniX76NfKQ==
X-Nifty-SrcIP: [209.85.222.54]
X-Gm-Message-State: APjAAAW2dX9lcMP6yld2VFbdhHQdYzNl3WhnSgM+rDh+EQzuzwjMav9y
	RMEAvYgXWZbA/bS16xHeb/c9ANHdQHDkzlv+4Tk=
X-Google-Smtp-Source: APXvYqz/xKbHHZjwUWVynvq0LAVaNNjyZIbkX3XCyi5Zubq0qkD3LmQSy2gKjjpQPjA4me5ky2NjvvlFXvzrYZyE/Xw=
X-Received: by 2002:ab0:6509:: with SMTP id w9mr6474644uam.121.1576126321925;
 Wed, 11 Dec 2019 20:52:01 -0800 (PST)
MIME-Version: 1.0
References: <20191211133951.401933-1-arnd@arndb.de>
In-Reply-To: <20191211133951.401933-1-arnd@arndb.de>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Thu, 12 Dec 2019 13:51:26 +0900
X-Gmail-Original-Message-ID: <CAK7LNASeyPxgQczSvEN4S3Ae7fRtYyynhU9kJ=96VX34S4TECA@mail.gmail.com>
Message-ID: <CAK7LNASeyPxgQczSvEN4S3Ae7fRtYyynhU9kJ=96VX34S4TECA@mail.gmail.com>
Subject: Re: [PATCH] gcc-plugins: make it possible to disable
 CONFIG_GCC_PLUGINS again
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Dec 11, 2019 at 10:40 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> I noticed that randconfig builds with gcc no longer produce a lot of
> ccache hits, unlike with clang, and traced this back to plugins
> now being enabled unconditionally if they are supported.
>
> I am now working around this by adding
>
>    export CCACHE_COMPILERCHECK=/usr/bin/size -A %compiler%
>
> to my top-level Makefile. This changes the heuristic that ccache uses
> to determine whether the plugins are the same after a 'make clean'.
>
> However, it also seems that being able to just turn off the plugins is
> generally useful, at least for build testing it adds noticeable overhead
> but does not find a lot of bugs additional bugs, and may be easier for
> ccache users than my workaround.
>
> Fixes: 9f671e58159a ("security: Create "kernel hardening" config area")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---

Reviewed-by: Masahiro Yamada <masahiroy@kernel.org>


-- 
Best Regards
Masahiro Yamada
