Return-Path: <kernel-hardening-return-15927-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id CA0031FCE6
	for <lists+kernel-hardening@lfdr.de>; Thu, 16 May 2019 03:02:22 +0200 (CEST)
Received: (qmail 32624 invoked by uid 550); 16 May 2019 01:02:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32600 invoked from network); 16 May 2019 01:02:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kB1kmUsnU0wPfFGEdIrU26lZ3ENdFfZVOF7R429DJpY=;
        b=leKX6iwd+E3ikfGY1//ltoNgIH4UsQxaJiOP4LVdzgDaHwTPnmCflqgZj3iMSpPogi
         PgC4m5zp6O/OVfdH+hwsuGJbVzzncxBPRxzYWSA2cFKS10nMMGAdTlvTBBz9PRWqBtXG
         0IY/4ObX8iKZI38lWxYnqS+6NDlXUzJI3O9zY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kB1kmUsnU0wPfFGEdIrU26lZ3ENdFfZVOF7R429DJpY=;
        b=AKtTuhA1ZtItg6xdEkvyFft3ijflfrIhBAk38FwVLrFax4GMB4daAk0LqHOWjHXkPV
         1jguHwi0N7PEs7XS9bVkHeUnxHsBFlm7snKI1ahE/NPKIynUMmwhXUFAyDulrf7BVrdR
         qZVHnd4yOiq2XvcULBCxkiHsYnvGoAjIoWgnFdsmWhz3rujzW38vsQo0mQr2IMcahf7E
         cic74p7sKo+e6AJoJXmIYRsoyJMA+6fm/Fv40HGXV5gH8PgdUnllJtCZeC6vsnPBxykZ
         9yJWJcaY35cpSPn59CXZiDR+v7vmnuZB7FeqyA3gGYS79ZFhQqztW3GXjPQiJnOoip1R
         9B3A==
X-Gm-Message-State: APjAAAUfirZhScse0cEjXzGMqSZ105u9cDkvIczK2besXlQz9Tdarb5N
	YEhhdqqRyQV1oSuyotw8Y23Naw==
X-Google-Smtp-Source: APXvYqwVz17Dgzf/syT6+WT0zM62IWrmEQAWI9YG2skem8A0ptTGY41DM3GMUa2e6NgcM+k+1vVkWw==
X-Received: by 2002:a63:c046:: with SMTP id z6mr47778396pgi.387.1557968522985;
        Wed, 15 May 2019 18:02:02 -0700 (PDT)
Date: Wed, 15 May 2019 18:02:00 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexander Potapenko <glider@google.com>
Cc: akpm@linux-foundation.org, cl@linux.com,
	kernel-hardening@lists.openwall.com,
	Nick Desaulniers <ndesaulniers@google.com>,
	Kostya Serebryany <kcc@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Sandeep Patil <sspatil@android.com>,
	Laura Abbott <labbott@redhat.com>, Jann Horn <jannh@google.com>,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2 2/4] lib: introduce test_meminit module
Message-ID: <201905151752.2BD430A@keescook>
References: <20190514143537.10435-1-glider@google.com>
 <20190514143537.10435-3-glider@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514143537.10435-3-glider@google.com>

On Tue, May 14, 2019 at 04:35:35PM +0200, Alexander Potapenko wrote:
> Add tests for heap and pagealloc initialization.
> These can be used to check init_on_alloc and init_on_free implementations
> as well as other approaches to initialization.

This is nice! Easy way to test the results. It might be helpful to show
here what to expect when loading this module:

with either init_on_alloc=1 or init_on_free=1, I happily see:

	test_meminit: all 10 tests in test_pages passed
	test_meminit: all 40 tests in test_kvmalloc passed
	test_meminit: all 20 tests in test_kmemcache passed
	test_meminit: all 70 tests passed!

and without:

	test_meminit: test_pages failed 10 out of 10 times
	test_meminit: test_kvmalloc failed 40 out of 40 times
	test_meminit: test_kmemcache failed 10 out of 20 times
	test_meminit: failures: 60 out of 70


> 
> Signed-off-by: Alexander Potapenko <glider@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>
Tested-by: Kees Cook <keescook@chromium.org>

note below...

> [...]
> diff --git a/lib/test_meminit.c b/lib/test_meminit.c
> new file mode 100644
> index 000000000000..67d759498030
> --- /dev/null
> +++ b/lib/test_meminit.c
> @@ -0,0 +1,205 @@
> +// SPDX-License-Identifier: GPL-2.0
> [...]
> +module_init(test_meminit_init);

I get a warning at build about missing the license:

WARNING: modpost: missing MODULE_LICENSE() in lib/test_meminit.o

So, following the SPDX line, just add:

MODULE_LICENSE("GPL");

-- 
Kees Cook
