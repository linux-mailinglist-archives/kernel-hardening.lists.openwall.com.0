Return-Path: <kernel-hardening-return-19763-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E0C2525CD95
	for <lists+kernel-hardening@lfdr.de>; Fri,  4 Sep 2020 00:29:40 +0200 (CEST)
Received: (qmail 26510 invoked by uid 550); 3 Sep 2020 22:29:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26478 invoked from network); 3 Sep 2020 22:29:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TORQKLjaztafBoTASZ16yvu7ARDRy50kM4Q1p96biak=;
        b=KHsDbTkWXmQI1RfBgYlEulerevLWOO1sRzFxAKb+aNgp895tLmEdR1w+6sTjCDCZIQ
         EuJ90PfQiTWeI7WLS02zfZZUzAc4XMY1Bk6zzL4EiQ37vuCk2BKlfRTd+vxSIXZp2XCf
         dIa1eEmzbBXCJesqA0svHofYBt8jl9vdhwQP4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TORQKLjaztafBoTASZ16yvu7ARDRy50kM4Q1p96biak=;
        b=qtbDWigd02mPlFMz7Xdej7jZb+wnpEpF6GUAFMSyoLvpKlyj/BKeTxsToI3Y0V6z0g
         ZBBnX66BnhvjzqKNqMRkOS5mkSUaVarg5t5tsLevOBqHcesrYtH8Khkvd3qp/5BmgNDS
         C46n8wfwySsg3k/cUQTGsmeFu7CZhcFUaKDbOKmDUZu1uEWi+AcdHetDbRHHN7sC40KO
         EtrbsqK86NMBqwya7uhHLBop/JWZvWoa5JqUmNmbLwJwx4rp8JWV5AqFWCMyOwpvKW9v
         NgvibIbkttzYtb0Ld/+z9nM9RwOStgRR+0+GYDT+2UIok3lXqc7AM1zKI6C9rmb/r9rT
         +fsQ==
X-Gm-Message-State: AOAM5333s5eN6aQnNk16YdVMUd/lFA5tAvvVuEOtWpIHMrgqrguBzCoa
	sQP5Dk63EvnlgrbxhnuZHGdEAg==
X-Google-Smtp-Source: ABdhPJyg38PLw4/4AevyFkWAsUoEy3gRppS9+Cz/SI2Otq8bgnJU/k3kDNd4Q7TVX1+2h1rFxh2rAw==
X-Received: by 2002:a63:344f:: with SMTP id b76mr4554312pga.388.1599172163775;
        Thu, 03 Sep 2020 15:29:23 -0700 (PDT)
Date: Thu, 3 Sep 2020 15:29:21 -0700
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
Subject: Re: [PATCH v2 14/28] kbuild: lto: remove duplicate dependencies from
 .mod files
Message-ID: <202009031529.78A2DE9D8@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-15-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-15-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:39PM -0700, Sami Tolvanen wrote:
> With LTO, llvm-nm prints out symbols for each archive member
> separately, which results in a lot of duplicate dependencies in the
> .mod file when CONFIG_TRIM_UNUSED_SYMS is enabled. When a module
> consists of several compilation units, the output can exceed the
> default xargs command size limit and split the dependency list to
> multiple lines, which results in used symbols getting trimmed.
> 
> This change removes duplicate dependencies, which will reduce the
> probability of this happening and makes .mod files smaller and
> easier to read.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
