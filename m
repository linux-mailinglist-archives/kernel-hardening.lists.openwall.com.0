Return-Path: <kernel-hardening-return-19773-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 781A225CE0B
	for <lists+kernel-hardening@lfdr.de>; Fri,  4 Sep 2020 00:46:04 +0200 (CEST)
Received: (qmail 15650 invoked by uid 550); 3 Sep 2020 22:45:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15614 invoked from network); 3 Sep 2020 22:45:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JXlymsrIbyM7AjGm/2rfdOYB0H1CVU1h4Svm00pvuI0=;
        b=DWsncKoXfy4PxyNvBSrYQCxtYjY8jyteneTwkz6mlHPPEZFF7gp7715SOKmC4/qkxD
         q+SYZYmla2S9Ys6tFjcp4ODWzXwDrV++MfFs8CcN+DqLmMxXFZakptYE6CAUTvkVC5UV
         20qyxQyoX4j38sYtCuXlnZbJ2RYy/taCcoWgs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JXlymsrIbyM7AjGm/2rfdOYB0H1CVU1h4Svm00pvuI0=;
        b=ZRDhBxnLasbXtnlsXzEtm6cw0FvS/Naotpl25u84fcN2uyX1MCKYmu5kSQNq6exJRj
         Mk5BneXy6cehAwN83OZBng5oamlWEXIe1VwwAQvQjXuXqm4RaTQCJHoH1+oSZlaKrHlW
         6TR44/a2Icr34pZ9PVChhQys0vcyOl5PNYCaXtHV802C4gzVA1Zbfr2EBzATnBz4Yna1
         EkGryFs70XQGtqcQAbw1/kNKlaMAfI56F9vGrpzdVAUF/KrabaaqXZ4aIjUPF5ffliWw
         SuOdDHP4CjVije3HKB8CX7A4E+QGIBqaqL5cj5cMP2VZ5vjcuZNuciUlC4PDjWpkVR3R
         eRLA==
X-Gm-Message-State: AOAM531dflNgIbmhUq6fCWWB3P1nlhFQ2yv7+qCmII5zESfR/0fmonr8
	bnTaMQt3+K8Lq/3aHrea1fRsnA==
X-Google-Smtp-Source: ABdhPJyzQQa+rbWQTOULGEXaVav+gnGRAy9CUx4utciFuxZtqNR92PboxBy66CUG56xUgxKlxz08hw==
X-Received: by 2002:a17:902:7609:: with SMTP id k9mr6059271pll.227.1599173146049;
        Thu, 03 Sep 2020 15:45:46 -0700 (PDT)
Date: Thu, 3 Sep 2020 15:45:44 -0700
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
Subject: Re: [PATCH v2 25/28] arm64: allow LTO_CLANG and THINLTO to be
 selected
Message-ID: <202009031545.559F27FAE@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-26-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-26-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:50PM -0700, Sami Tolvanen wrote:
> Allow CONFIG_LTO_CLANG and CONFIG_THINLTO to be enabled.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
