Return-Path: <kernel-hardening-return-20099-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B792A2842E7
	for <lists+kernel-hardening@lfdr.de>; Tue,  6 Oct 2020 01:20:15 +0200 (CEST)
Received: (qmail 29800 invoked by uid 550); 5 Oct 2020 23:20:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 29763 invoked from network); 5 Oct 2020 23:20:08 -0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
	:Reply-To:Content-ID:Content-Description;
	bh=3dkgBq1qJtxgLyx9+tBsIFE95GO9iyOEhFVm523gukA=; b=z8efRSmFDpD5L7nXtku/8y34Y6
	ejLdBXR27axDg2oOicufIfAbleAFPB1r5QWNAZFfJQu9B71HOrfkewH6v5y0ZjCdnelz9nj+F4fo1
	8lhtoQyifoeHU2wNbuB3bApHClgEHMzKFi8osBBneUVwnRZI+9lFmNLn2paxExRkSw6qv47DQQVtf
	z6204WOOQJMvdDyK1KsWQdNhW9kutQF3T5S5ynrH0sFi+49XRIlyJa1mJZAp2mQ46VaTL56njPTLe
	ymLxANsjCJbjaruDNRPeF0gXbYmUo00JwqbhQ3ZBzvkPsaLYxxThXFYOhsnn9AiFatQVHeW+kp6Pt
	kdrxy3Pw==;
Subject: Re: [PATCH] MAINTAINERS: Change hardening mailing list
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, "Tobin C. Harding" <me@tobin.cc>,
 Tycho Andersen <tycho@tycho.pizza>, Jonathan Corbet <corbet@lwn.net>,
 Andrew Morton <akpm@linux-foundation.org>, linux-hardening@vger.kernel.org,
 kernel-hardening@lists.openwall.com
References: <20201005225319.2699826-1-keescook@chromium.org>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <f1935658-97d3-2f6e-8643-522f9b6227cc@infradead.org>
Date: Mon, 5 Oct 2020 16:19:49 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201005225319.2699826-1-keescook@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit

On 10/5/20 3:53 PM, Kees Cook wrote:
> As more email from git history gets aimed at the OpenWall
> kernel-hardening@ list, there has been a desire to separate "new topics"
> from "on-going" work. To handle this, the superset of hardening email
> topics are now to be directed to linux-hardening@vger.kernel.org. Update
> the MAINTAINTERS file and the .mailmap to accomplish this, so that

      MAINTAINERS

> linux-hardening@ can be treated like any other regular upstream kernel
> development list.
> 
> Link: https://lore.kernel.org/linux-hardening/202010051443.279CC265D@keescook/
> Link: https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Get_Involved
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> I intend to include this in one of my trees, unless akpm or jon want it?
> ---
>  .mailmap    | 1 +
>  MAINTAINERS | 4 ++--
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/.mailmap b/.mailmap
> index 50096b96c85d..91cea2d9a6a3 100644
> --- a/.mailmap
> +++ b/.mailmap
> @@ -184,6 +184,7 @@ Leon Romanovsky <leon@kernel.org> <leonro@nvidia.com>
>  Linas Vepstas <linas@austin.ibm.com>
>  Linus Lüssing <linus.luessing@c0d3.blue> <linus.luessing@ascom.ch>
>  Linus Lüssing <linus.luessing@c0d3.blue> <linus.luessing@web.de>
> +<linux-hardening@vger.kernel.org> <kernel-hardening@lists.openwall.com>
>  Li Yang <leoyang.li@nxp.com> <leoli@freescale.com>
>  Li Yang <leoyang.li@nxp.com> <leo@zh-kernel.org>
>  Lukasz Luba <lukasz.luba@arm.com> <l.luba@partner.samsung.com>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index adc4f0619b19..44d97693b6f3 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -7216,7 +7216,7 @@ F:	drivers/staging/gasket/
>  GCC PLUGINS
>  M:	Kees Cook <keescook@chromium.org>
>  R:	Emese Revfy <re.emese@gmail.com>
> -L:	kernel-hardening@lists.openwall.com
> +L:	linux-hardening@lists.openwall.com

?? confusing.

>  S:	Maintained
>  F:	Documentation/kbuild/gcc-plugins.rst
>  F:	scripts/Makefile.gcc-plugins
> @@ -9776,7 +9776,7 @@ F:	drivers/scsi/53c700*
>  LEAKING_ADDRESSES
>  M:	Tobin C. Harding <me@tobin.cc>
>  M:	Tycho Andersen <tycho@tycho.pizza>
> -L:	kernel-hardening@lists.openwall.com
> +L:	linux-hardening@lists.openwall.com

??

>  S:	Maintained
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tobin/leaks.git
>  F:	scripts/leaking_addresses.pl
> 


-- 
~Randy

