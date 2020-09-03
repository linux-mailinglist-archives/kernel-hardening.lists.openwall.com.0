Return-Path: <kernel-hardening-return-19779-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C55AA25CE78
	for <lists+kernel-hardening@lfdr.de>; Fri,  4 Sep 2020 01:42:36 +0200 (CEST)
Received: (qmail 17559 invoked by uid 550); 3 Sep 2020 23:42:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17523 invoked from network); 3 Sep 2020 23:42:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Buf4pyI8QjmO6EzkejoF7rJNgrRLPFkG+pFmWeqNXSU=;
        b=LPBJX9YYiLdzfuvHhhApORKkjEcCokH8S7S+ixf/lb6PKyLameB2R/hO1MnJZ8lfjk
         RccIntdXKYJgeoTeIUtHPwlFVqlLK41Ye4qgM7C8a0Dl1XuqkWA/EbQaEDzvjYVM9Hem
         hXNDGnNCBxAUmwKqqrZTo5Z/pkPOaE+IU8GFh1uCzHl1RfLknP0FL1YAO1qizXvgdhoV
         jmGJqRqmzLQ/4JKXNZnVHBJKIv2uY/AATQNPFgyOPe5n3lAtj8q8KQIY8t8e6ZIeqzLb
         hUxL86tW8/dBzbuxUwIdIX/bzmz1jVTQI4jTiffCrlo0tyEZPNJWWfn9FXi7SgOBoEwA
         YQjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Buf4pyI8QjmO6EzkejoF7rJNgrRLPFkG+pFmWeqNXSU=;
        b=ZXEp127J6G1+G7xu7idsboO6Ee7+fd36h52kX1fJTvgMxvmtLyVXijsdOTXUL/QR4v
         9TyQTq0TWvla2FZmqdyYoY695cAyoAAz3hSW1PoYbsHuEc1v1BpfIhA2AoV9Pwif3rbV
         ziHvUN2w7t0x5d01rOYv3vsphEGsAz+56NUhfgJW8fZ0dKazjykC+TnSFwplDgMETKFT
         hft0x3ZdDUm97F8Kwnolvb0oXtR1tfSGzLSjlA6vWS7L5FHf45zKCaSAsMAdIpinLZay
         nlHIYEHDAMWOepqCSXlqI2P87z0XYzORaZstBMCjOmsb8palJNXvaLAqiTLq2RJLihRN
         Xgqw==
X-Gm-Message-State: AOAM531V3318+36h9SIryctfb0YO20ZcFOTO4+gbBoJbfv+ES/Ws+76L
	Hg7/5XLGGk2iUzbBmmBrv0I=
X-Google-Smtp-Source: ABdhPJwk7xSMHZgBS2KIiKPpibl4+puFeN+IUbUk1MnxASjO8ffXMYr1LuHhmFwUKcYtabk7P9z+Ww==
X-Received: by 2002:a37:4c4:: with SMTP id 187mr5768921qke.40.1599176538868;
        Thu, 03 Sep 2020 16:42:18 -0700 (PDT)
Sender: Arvind Sankar <niveditas98@gmail.com>
From: Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date: Thu, 3 Sep 2020 19:42:15 -0400
To: Kees Cook <keescook@chromium.org>
Cc: Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org, Arvind Sankar <nivedita@alum.mit.edu>
Subject: Re: [PATCH v2 01/28] x86/boot/compressed: Disable relocation
 relaxation
Message-ID: <20200903234215.GA106172@rani.riverdale.lan>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-2-samitolvanen@google.com>
 <202009031444.F2ECA89E@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202009031444.F2ECA89E@keescook>

On Thu, Sep 03, 2020 at 02:44:41PM -0700, Kees Cook wrote:
> On Thu, Sep 03, 2020 at 01:30:26PM -0700, Sami Tolvanen wrote:
> > From: Arvind Sankar <nivedita@alum.mit.edu>
> > 
> > Patch series [4] is a solution to allow the compressed kernel to be
> > linked with -pie unconditionally, but even if merged is unlikely to be
> > backported. As a simple solution that can be applied to stable as well,
> > prevent the assembler from generating the relaxed relocation types using
> > the -mrelax-relocations=no option. For ease of backporting, do this
> > unconditionally.
> > 
> > [0] https://gitlab.com/x86-psABIs/x86-64-ABI/-/blob/master/x86-64-ABI/linker-optimization.tex#L65
> > [1] https://lore.kernel.org/lkml/20200807194100.3570838-1-ndesaulniers@google.com/
> > [2] https://github.com/ClangBuiltLinux/linux/issues/1121
> > [3] https://reviews.llvm.org/rGc41a18cf61790fc898dcda1055c3efbf442c14c0
> > [4] https://lore.kernel.org/lkml/20200731202738.2577854-1-nivedita@alum.mit.edu/
> > 
> > Reported-by: Nick Desaulniers <ndesaulniers@google.com>
> > Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 
> -- 
> Kees Cook

Note that since [4] is now in tip, assuming it doesn't get dropped for
some reason, this patch isn't necessary unless you need to backport this
LTO series to 5.9 or below.

Thanks.
