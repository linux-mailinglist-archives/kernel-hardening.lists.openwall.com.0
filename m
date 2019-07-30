Return-Path: <kernel-hardening-return-16640-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6512B7AF52
	for <lists+kernel-hardening@lfdr.de>; Tue, 30 Jul 2019 19:11:41 +0200 (CEST)
Received: (qmail 7402 invoked by uid 550); 30 Jul 2019 17:11:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7368 invoked from network); 30 Jul 2019 17:11:33 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DURkbxYpSyevpsa6R/8i8qyLSR7ch0xiZqDHE2fEsfE=;
        b=ZTsxU1jwWrAv6PbXiIIik3jf5/ft7LKcFvGYgVLnB4fPoQ3tvi3MKpyNrOPU21KDrh
         H5kP39SwZlpO3Akh/BlFqzi/NdJPb6xW6HfYfGoqkDiClLFgKYZab/gbg4ySHMYlMKkg
         D2KgzDmfBTZVzANTQ9UhE3pVRe6CTUc9yL+7c=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DURkbxYpSyevpsa6R/8i8qyLSR7ch0xiZqDHE2fEsfE=;
        b=XD61lOPn5A4epEUNXn1Co1GVhNDl2O6EoUArrfkx/rw4iSuUPVJtZPJwYa1K+nGgpR
         xPLCsok7Ie1DV7sxOJPkU/gIck84pELaNvuiAaJqA9/FAJYQBzNjJneHNHjyzqCOfcbg
         BwJdG2NySHaPRJ5JNZCE7qn9YM5akEaMQsf+YTdWbkT03qEIQemkP5+ch8MIHmI46Hwp
         6478/bSU7JS/yfYB1Kl2v+GxS9lp3oSIlKDyA5nJqUJ9d+gLc3lIVMGyZtzpmowCTje/
         d+3eQaGnP+skyCs6J12BoBA2pMK8W74TrEStEmfE5tMZXo7F+pU+jSN7dT7u/JxHlVOq
         B5Cw==
X-Gm-Message-State: APjAAAWOn25nEInuRBlYB2kJgSYQWnyYjFQG+jMrBukNKZDkPLAHKfpX
	0WjTdI2eKgKisG8ft197gH8z2VWTdYs=
X-Google-Smtp-Source: APXvYqwHgmNOnBJ+nNiMj7wuTK/9aMk3slfx8ycNwvFhZErCqiyZqyD06IveEHQuUMtNtFe1ybumrw==
X-Received: by 2002:a62:7890:: with SMTP id t138mr34060209pfc.238.1564506681840;
        Tue, 30 Jul 2019 10:11:21 -0700 (PDT)
Date: Tue, 30 Jul 2019 10:11:19 -0700
From: Kees Cook <keescook@chromium.org>
To: Joonwon Kang <kjw1627@gmail.com>
Cc: re.emese@gmail.com, kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] randstruct: fix a bug in is_pure_ops_struct()
Message-ID: <201907301008.622218EE5@keescook>
References: <20190727155841.GA13586@host>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190727155841.GA13586@host>

On Sun, Jul 28, 2019 at 12:58:41AM +0900, Joonwon Kang wrote:
> Before this, there were false negatives in the case where a struct
> contains other structs which contain only function pointers because
> of unreachable code in is_pure_ops_struct().

Ah, very true. Something like:

struct internal {
	void (*callback)(void);
};

struct wrapper {
	struct internal foo;
	void (*other_callback)(void);
};

would have not been detected as is_pure_ops_struct()?

How did you notice this? (Are there cases of this in the kernel?)

> Signed-off-by: Joonwon Kang <kjw1627@gmail.com>

Applied; thanks!

-Kees

> ---
>  scripts/gcc-plugins/randomize_layout_plugin.c | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
> index 6d5bbd31db7f..a123282a4fcd 100644
> --- a/scripts/gcc-plugins/randomize_layout_plugin.c
> +++ b/scripts/gcc-plugins/randomize_layout_plugin.c
> @@ -443,13 +443,12 @@ static int is_pure_ops_struct(const_tree node)
>  		if (node == fieldtype)
>  			continue;
>  
> -		if (!is_fptr(fieldtype))
> -			return 0;
> -
> -		if (code != RECORD_TYPE && code != UNION_TYPE)
> -			continue;
> +		if (code == RECORD_TYPE || code == UNION_TYPE) {
> +			if (!is_pure_ops_struct(fieldtype))
> +				return 0;
> +		}
>  
> -		if (!is_pure_ops_struct(fieldtype))
> +		if (!is_fptr(fieldtype))
>  			return 0;
>  	}
>  
> -- 
> 2.17.1
> 

-- 
Kees Cook
