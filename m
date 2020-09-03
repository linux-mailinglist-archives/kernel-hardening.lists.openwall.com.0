Return-Path: <kernel-hardening-return-19775-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3C4E125CE18
	for <lists+kernel-hardening@lfdr.de>; Fri,  4 Sep 2020 00:47:52 +0200 (CEST)
Received: (qmail 19500 invoked by uid 550); 3 Sep 2020 22:47:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 19468 invoked from network); 3 Sep 2020 22:47:46 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eFrstCXBN3HfrZebeISGA36KawHO68DuV5H+8+oCMrk=;
        b=UyJevSS3jZbv6N7QB5+swtwOzbQH8Mebfc6NiguMHEEa3zpvf2Fa8BOPsjRPafItrX
         94+boIdY0eIFAYNargKYhKvUD4q+qsol+8WhYmSNTTfQeUzQx66molHRZp0VKRR4pNjd
         TeTJKO1SkL6fNUa/+nF94zP8Ps5d09zjKGzZ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eFrstCXBN3HfrZebeISGA36KawHO68DuV5H+8+oCMrk=;
        b=PMtBqqTW8/mUDzdQLlDoOQf76aexinoca+YDEyTlb5txbdX00kuPWiX83YNzSRNNU0
         /yhstab5t7zL8284GHSl10/LoNzQE2I/q4uHcqNKsTK/Y4d2tjtzrgJewGCFt8XI83zI
         WbF/2vHVnLmxdP2ZBvOx3NI/o8rpXMpAxFyXMrWiyymoSImFa6h4i/aqT4IPYEXA89od
         7yfcr3G68d7XmVekZ/Ty2iaZ6YUjq7v2CstZKdHvSYaOx3SaPnzWlKyfiwEcY9E97uVZ
         eS+mOQDBE74M+vmgpPlo+wCw0o3uIL9wVGm0CUFbN1ViZ7/Bb1m0+P4Lvk0traxa3uKV
         TghQ==
X-Gm-Message-State: AOAM531JU2VJFv1GraunV2qTnEYSMQfkIQhu/oXAWGSjR9M6ujPDSF8x
	ZGRjknUsd5f1yLjcx2erEHlwZQ==
X-Google-Smtp-Source: ABdhPJxBUddtcfqLuFrofAmKe3Wkr2dCSnES8MsReM+zYAT8LfVgd6BWIelLMAoy/r1/rEVW2WoePA==
X-Received: by 2002:a17:90b:889:: with SMTP id bj9mr5382384pjb.101.1599173254469;
        Thu, 03 Sep 2020 15:47:34 -0700 (PDT)
Date: Thu, 3 Sep 2020 15:47:32 -0700
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
Subject: Re: [PATCH v2 27/28] x86, relocs: Ignore L4_PAGE_OFFSET relocations
Message-ID: <202009031546.4854633F7@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-28-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-28-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:52PM -0700, Sami Tolvanen wrote:
> L4_PAGE_OFFSET is a constant value, so don't warn about absolute
> relocations.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Any other details on this? I assume this is an ld.lld-ism. Any idea why
this is only a problem under LTO? (Or is this an LLVM integrated
assembler-ism?) Regardless, yes, let's nail it down:

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
