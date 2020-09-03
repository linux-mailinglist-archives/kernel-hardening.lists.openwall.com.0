Return-Path: <kernel-hardening-return-19770-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2701A25CDF5
	for <lists+kernel-hardening@lfdr.de>; Fri,  4 Sep 2020 00:44:38 +0200 (CEST)
Received: (qmail 10134 invoked by uid 550); 3 Sep 2020 22:44:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 10102 invoked from network); 3 Sep 2020 22:44:32 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=52NN7zmbWj8pqq618ReYhqgg44nUMSxhK8Ic7l6b9IQ=;
        b=MBK0WKmdN+VVS8ZrwY58Hlad4tCyZ5qwvoRKwdhpO5bHKBKJVYLTH6lKUS2u0lc/Bh
         8VA6LKlg81yIvhCjEQrBhESR4/qWsfETlF2eMA30SIkhfR/LjqzXlb1lgrKip62VobMn
         BSCke5Bwqm1qGde6q4c4/K9qre+J4wJi4pj1U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=52NN7zmbWj8pqq618ReYhqgg44nUMSxhK8Ic7l6b9IQ=;
        b=lsrW6lBQqM8LuKm+vdR2PGpjfu6X0i537lz7XyBwS4OCQyDCviKBVsy58ee7DFAa06
         Ar2X7kxMxOW15hdAy2atRCdh6Caif5kWe8EZasKBQ0sDZiUvwkFEEV0hps6b/LfbAMnQ
         CdPJP/iiKDfuHZK4qj4C7IxcSZVQd1SCpoYs8QL8N6XgKjD0/6snqAUbZtWGanUqsO6N
         gKb0jgcwOHdh9GQ/nAiXQeEp6OMvcnuP7SLNLTghX4YF1OK3YHg3c5dezs2NlzRkBLg2
         qiEcBw0p/BbLjCz5VZrCac9zMsr4psC+Wbph7JAMgpGuG/WIGhBXo3EbLk95qYrLyi7j
         NmCA==
X-Gm-Message-State: AOAM53384BTvf7aba8JK7ex3BAb1/xuC9dcSAerf8mPHRA1/INOeYFQN
	U9dFdfB+XkKPn5C2tOHpK0VIXA==
X-Google-Smtp-Source: ABdhPJy9dQk51yQ0UJxiuUPjBSPLNVfH7SoTa7H5YomZF3lQK5E4Z9WCG1DCkxj0GCE61YpXubg48g==
X-Received: by 2002:a17:902:121:: with SMTP id 30mr6136106plb.205.1599173060307;
        Thu, 03 Sep 2020 15:44:20 -0700 (PDT)
Date: Thu, 3 Sep 2020 15:44:18 -0700
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
Subject: Re: [PATCH v2 22/28] arm64: export CC_USING_PATCHABLE_FUNCTION_ENTRY
Message-ID: <202009031544.D66F02D407@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-23-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-23-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:47PM -0700, Sami Tolvanen wrote:
> Since arm64 does not use -pg in CC_FLAGS_FTRACE with
> DYNAMIC_FTRACE_WITH_REGS, skip running recordmcount by
> exporting CC_USING_PATCHABLE_FUNCTION_ENTRY.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

How stand-alone is this? Does it depend on the earlier mcount fixes?

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
