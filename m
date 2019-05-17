Return-Path: <kernel-hardening-return-15935-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3A8C3211C1
	for <lists+kernel-hardening@lfdr.de>; Fri, 17 May 2019 03:26:43 +0200 (CEST)
Received: (qmail 22046 invoked by uid 550); 17 May 2019 01:26:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 22023 invoked from network); 17 May 2019 01:26:36 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+cJ2gxhZLau5gmuenPlTtxJhsl5TXn8iu9yGe1AQQrg=;
        b=QNQxNc5ypRwtdFSH6HpSYR0MThc0HpZETeuvrI6NSQk2We0nlIfd3RF8xLG1Ydb5Ni
         C7l69sF2b+zwXTu+27LDKNH02FrrDRkffXWwiX6s9n+JvtV+SEbf828xWCOVEFv3hlWv
         U1gbvwBvIrttUqNQjSQ0XLYWgiKZYmbIip2B8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+cJ2gxhZLau5gmuenPlTtxJhsl5TXn8iu9yGe1AQQrg=;
        b=p19+F0b30gyU24O5L09/JTqML0gu8EObb9nACWpTduO4p/vGhsPrju/6a5hXFrrlNX
         7jPwvo7N1BglvKKvBmc1+gBciSmv8HpGXWwXvH64VrtWQIQzircSs8DHPDlklOK8m1Rs
         dxFcPD48dWl1rAitGyGK7+MwYhIs5sH5ie0mHiplXLUCkHOpDZ4ZqYX7Qrkkr7Xu72ly
         Y4VHUVo2ClMAJjOQB9ppNCIAp7aH9KEEylf/s9vas8tgXd00HFJxWhXkRxYpKyZP222C
         vqQ6Ez9NelZV3TwmZAZUnLd8gs4S8TShk89Pa9PpZkdC3Pzol67LrK+GQwrgHq63yn7t
         /4WQ==
X-Gm-Message-State: APjAAAUHeTsiOaSBbtrVUrCwixP/nfyDUFXl2f1GJmwByAkBoLnBMteC
	KgTGm5cgF5fgfMct1M8wn9elqg==
X-Google-Smtp-Source: APXvYqz3bg5gRNoTrwMyo5+vXZ7qa4nbJU852Lnd6zCfw82/d5ftsiATgeUm4vLixEXP76pwv/yJLQ==
X-Received: by 2002:a63:1a03:: with SMTP id a3mr54079259pga.412.1558056384345;
        Thu, 16 May 2019 18:26:24 -0700 (PDT)
Date: Thu, 16 May 2019 18:26:22 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexander Potapenko <glider@google.com>
Cc: akpm@linux-foundation.org, cl@linux.com,
	kernel-hardening@lists.openwall.com,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Kostya Serebryany <kcc@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Sandeep Patil <sspatil@android.com>,
	Laura Abbott <labbott@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>,
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
	linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 1/4] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-ID: <201905161824.63B0DF0E@keescook>
References: <20190514143537.10435-1-glider@google.com>
 <20190514143537.10435-2-glider@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514143537.10435-2-glider@google.com>

On Tue, May 14, 2019 at 04:35:34PM +0200, Alexander Potapenko wrote:
> [...]
> diff --git a/mm/slab.h b/mm/slab.h
> index 43ac818b8592..24ae887359b8 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -524,4 +524,20 @@ static inline int cache_random_seq_create(struct kmem_cache *cachep,
> [...]
> +static inline bool slab_want_init_on_free(struct kmem_cache *c)
> +{
> +	if (static_branch_unlikely(&init_on_free))
> +		return !(c->ctor);

BTW, why is this checking for c->ctor here? Shouldn't it not matter for
the free case?

> +	else
> +		return false;
> +}

-- 
Kees Cook
