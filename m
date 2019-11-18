Return-Path: <kernel-hardening-return-17395-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 72DED100A0F
	for <lists+kernel-hardening@lfdr.de>; Mon, 18 Nov 2019 18:16:43 +0100 (CET)
Received: (qmail 17570 invoked by uid 550); 18 Nov 2019 17:16:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17533 invoked from network); 18 Nov 2019 17:16:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=miX1DXaV6x+yVGMbDqZgtWXzaPsE3b4TkiwbU/0PTio=;
        b=b9HtcvwBVEGss8oXF9mNU9F2PDvB87dz3vYlPLIFYwqz8Zu+umj32pZQcqod5RS5Pp
         ZNXEg/wxQOa3MrwwK1IipS+7Elg8Bxj7geTup/FtXA8UFUyEUnJia72PlvGORdZzxMu5
         SoKDKClxmSbOM4lUvabRqjx3ibK6Jgw5e8ewM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=miX1DXaV6x+yVGMbDqZgtWXzaPsE3b4TkiwbU/0PTio=;
        b=ThmlfCxU7tp8FG4bIJ/q9mj7JtJ/hgnostwy8DOYGW/HejoXvGHGf6I7rMV42Xgxmt
         Y8SxkFZpVuBqk1K/UsJ/+6TH1Btl4C+mR2aFd1h9rzbN2fpxGlk+IJ3dgcS9d10vQQDP
         89DsyOc1WZV8ZdYCNSUmKQntvMbZtVkOStrIvfnvQf52sR4tqfzBJqOAID2Mo7OdGxoQ
         n6UYrr7fUekTdns8j0Efb4HNbabeOiighGkOEEYLxrcxeCU+WTFTbY7CMjx28eP1pv29
         onFXtny9BZLcS2dOV0d4QjKRtZXWMj6I1OrmKHHzzo+rLoKBisHCEjnnPFQZFky+cbbl
         rVoQ==
X-Gm-Message-State: APjAAAVPuFXHy4TOv5LIPxkFB/PYm8LZuKuUy6GC4dz/AeepdZl/RHi0
	RUduqhb0nbyKNpaEnbGU0UVy7pxd3Js=
X-Google-Smtp-Source: APXvYqyWnZPysVZKrND9OD7V9URmsQL50WHYwM8DGw7K0SNyDzBvLvmygnj46FsJF98BaO9ss+ijEw==
X-Received: by 2002:a17:902:ab87:: with SMTP id f7mr17059532plr.78.1574097382279;
        Mon, 18 Nov 2019 09:16:22 -0800 (PST)
Date: Mon, 18 Nov 2019 09:16:20 -0800
From: Kees Cook <keescook@chromium.org>
To: Peng Fan <peng.fan@nxp.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Subject: Re: contribute to KSPP
Message-ID: <201911180912.B860362F@keescook>
References: <AM0PR04MB4481EB76361DB1681D1F265488710@AM0PR04MB4481.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB4481EB76361DB1681D1F265488710@AM0PR04MB4481.eurprd04.prod.outlook.com>

On Thu, Nov 14, 2019 at 01:29:33AM +0000, Peng Fan wrote:
> Hi,

Hi! Welcome to the list!

> I work for NXP Linux Kernel team, my work are mostly ARM64/ARM SoC BSP,
> embedded virtualization, bootloader development.
> 
> I came across KSPP, find this is an attractive project. And would
> like to do some contribution.
> 
> Not sure https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Work
> is still up to date.

I've been slowly transitioning the TODO list to a github issue tracker
here:
https://github.com/KSPP/linux/issues/

> If you have any items not owned, please share me the info. Currently I am
> going through the kernel items, such as the following form ARM/ARM64:
> split thread_info off to kernel stack

https://github.com/KSPP/linux/issues/1

> move kernel stack to vmap area

https://github.com/KSPP/linux/issues/2

> KASLR for ARM

https://github.com/KSPP/linux/issues/3

> Protect ARM vector

https://github.com/KSPP/linux/issues/13


All four of those apply only to arm32. arm64 either has them already
(first three), or it doesn't apply (protect vector, IIUC, is
arm32-specific).

I'm not aware of anyone working on those currently, so they would be
very welcome! :)

Thanks for reaching out!

-- 
Kees Cook
