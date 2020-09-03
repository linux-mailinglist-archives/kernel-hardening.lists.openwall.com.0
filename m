Return-Path: <kernel-hardening-return-19768-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9C70725CDE0
	for <lists+kernel-hardening@lfdr.de>; Fri,  4 Sep 2020 00:43:37 +0200 (CEST)
Received: (qmail 7457 invoked by uid 550); 3 Sep 2020 22:43:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7419 invoked from network); 3 Sep 2020 22:43:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JQ91+76gyHMY3xv40LcJfL22rVwnSHEWIrs+JY61Lfw=;
        b=Gv/ffUiV4cHAcDklljNvHcMHuBcglanuZNKtn6NOLTMdAobfJFLi4S3XUK/VF0cMoa
         YCSlZMjLzO+hSp1mb2H+OVfbR2yXR8wtEPXnlt5uMI360+iCnjR0H3cIuzPcnksebXGK
         d93lpCoPbskfIrQ+gg8nraNFnKZGq6Pjaz6ts=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JQ91+76gyHMY3xv40LcJfL22rVwnSHEWIrs+JY61Lfw=;
        b=fnn4q3JpkK3DzR8YtqvN72cwXk4ssaNO/WjOhS0UAx3beqgifmHuq7vgayJDCY+1Qa
         a99e+IJuMK20hW7V6LxotAbVIZsF3PB0Q7bcHDyyYab1dZoIJpXgQ2ioO5A42AsGGeEr
         j8+Dv/UoCyNWTPPveuRvIku8paYOhu1ug7CmkPgST4zra2lKIjHFYV3AYt2VvzUsVoge
         ff1D6RD0m1q4ZzHNXv3xuQIBXONNUWL7bNbSCATKlh4xTdQHlHatsE4y98NphuUh+ybw
         c0zmZOvdfp1zdHJLO9gZmG9m+3G5tx+eAXNNk9cDge+hLnLAoA409C+I37P3XIFCJLjl
         eMDw==
X-Gm-Message-State: AOAM531XWEmJY1OlJgh368I7cT11uZyl8xoVk0MabTqaklrCKURcGU80
	4+36ab6YTfZuBXGZUxqJOqTNiA==
X-Google-Smtp-Source: ABdhPJzsDxL6JJKJu36vJnlttgHabnBSHn20nTl7ZGP5hdybfETsgZLi8FgY6Utuj7Ord6vXDPO70Q==
X-Received: by 2002:a62:4e49:: with SMTP id c70mr5965062pfb.100.1599172999617;
        Thu, 03 Sep 2020 15:43:19 -0700 (PDT)
Date: Thu, 3 Sep 2020 15:43:18 -0700
From: Kees Cook <keescook@chromium.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org
Subject: Re: [PATCH v2 19/28] scripts/mod: disable LTO for empty.c
Message-ID: <202009031543.A239909B@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-20-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-20-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:44PM -0700, Sami Tolvanen wrote:
> With CONFIG_LTO_CLANG, clang generates LLVM IR instead of ELF object
> files. As empty.o is used for probing target properties, disable LTO
> for it to produce an object file instead.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
