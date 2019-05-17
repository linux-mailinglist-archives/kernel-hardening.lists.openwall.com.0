Return-Path: <kernel-hardening-return-15949-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9BFA821B14
	for <lists+kernel-hardening@lfdr.de>; Fri, 17 May 2019 18:00:00 +0200 (CEST)
Received: (qmail 9840 invoked by uid 550); 17 May 2019 15:59:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9821 invoked from network); 17 May 2019 15:59:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=INvyXgRgpc11QEZcWPLU82BNdrovIrWqBF0OwWnNsfE=;
        b=OzkQiwAzJuMdG5Dif12dSl+nTEipCyWX7+SdFof6s8LaG66yLc+ruN0gDAGBN3TefY
         bbuIBXARgwmT4asXLVzMmCU0JRbt6/7DH9DwiCiJAnIJzLM1zPJP0ntHL5Ncxor2ZBxm
         kAshtNmIfG7mixRQlpwxZ/vwWgWZBCTFL4juE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=INvyXgRgpc11QEZcWPLU82BNdrovIrWqBF0OwWnNsfE=;
        b=EUS8hxV41yWa7QG8WcLGtdZb3bYdFYniaKTP4GynnbbleYCTXxVtIUm+A9Ky73Ksep
         VBwGikirhquXwEV4qcSyJaoxwnI2Nd96BkR9cy3sLE6Pc+jLqFtLmK5ZlCk8IoGEsfOe
         CPCsl01HfTGfhpEWgHfvm5SdungMA0vn5GUfkr7ctDtJoPrlqjee5/YWI8vp8qlZZ6rZ
         qryD9sELSFjpJgp9X7pvzWsGqTvmaoLQRbczvit+yw1/W/TJ8BYNcnxamZNj0FqfDta3
         wKw2uMyoWbQIWPB1wkMLaYpO94qvHMvhznUODwVFYW/EcXpo/fIMJsW4MOmqTqX6ObjN
         Ki9A==
X-Gm-Message-State: APjAAAV4kd8qFLx+nkEeo9xc3P+3I1EQ9qxt6TrT1KhFLfiMd8SXiIMM
	sBMawHib7U1aBQXLuXmWWB1DtA==
X-Google-Smtp-Source: APXvYqxjjymERosAhEH8xGgc+gUj/iwHDQd5pedl+FQfW0PvQNBci/Cem9LJMaQfelInYHey+/OBlA==
X-Received: by 2002:a17:902:7892:: with SMTP id q18mr12777643pll.163.1558108781558;
        Fri, 17 May 2019 08:59:41 -0700 (PDT)
Date: Fri, 17 May 2019 08:59:39 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Kostya Serebryany <kcc@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Sandeep Patil <sspatil@android.com>,
	Laura Abbott <labbott@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 5/4] mm: Introduce SLAB_NO_FREE_INIT and mark excluded
 caches
Message-ID: <201905170858.CE4109E77@keescook>
References: <20190514143537.10435-5-glider@google.com>
 <201905161746.16E885F@keescook>
 <CAG_fn=W41zDac9DN9qVB_EwJG89f2cNBQYNyove4oO3dwe6d5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG_fn=W41zDac9DN9qVB_EwJG89f2cNBQYNyove4oO3dwe6d5Q@mail.gmail.com>

On Fri, May 17, 2019 at 10:34:26AM +0200, Alexander Potapenko wrote:
> On Fri, May 17, 2019 at 2:50 AM Kees Cook <keescook@chromium.org> wrote:
> >
> > In order to improve the init_on_free performance, some frequently
> > freed caches with less sensitive contents can be excluded from the
> > init_on_free behavior.
> Did you see any notable performance improvement with this patch?
> A similar one gave me only 1-2% on the parallel Linux build.

Yup, that's in the other thread. I saw similar. But 1-2% on a 5% hit is
a lot. ;)

-- 
Kees Cook
