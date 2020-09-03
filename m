Return-Path: <kernel-hardening-return-19752-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7205F25CCC8
	for <lists+kernel-hardening@lfdr.de>; Thu,  3 Sep 2020 23:51:30 +0200 (CEST)
Received: (qmail 9226 invoked by uid 550); 3 Sep 2020 21:51:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 8162 invoked from network); 3 Sep 2020 21:51:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qXpu71ctdlh3mEQbznjWlLLlQUw5P2bBw2F3vq4Wzjo=;
        b=ZyZZKeIpcpI80+hejxzxlgql178wdYHMLgxxEcNsZP5DgNheiVVnTG3N+eHQ6nQdTA
         Niu4Mm24mQzd8zXiPCHvu1WgPl9pvcZLM7dK+CVMgSnMSoSLzj6aaeKFz4fN5yjD378D
         otR7uM4FcmoQ6MxJYzFRJSwnOdQ8bNb3OFeq4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qXpu71ctdlh3mEQbznjWlLLlQUw5P2bBw2F3vq4Wzjo=;
        b=l4ISLMre+WPCoDkE5eZo9Y7naLnU2ZMpk9zN2+W51AoQCuiMES0eoLpsyCTyJnel3J
         3yNzBDGy3ZoG0DV/w/7lD/YzPHPtJWgFiZf3YdXznZrF9s6XZ9X/imL2AcKCmPhDIXD9
         u10ciok+cqjhJFYRODH/eOlaSGVroT2SVcbpITpiMFl9gNooZWZtjLL9VYiGbVdNYhRd
         RGba3yVClBPNP46eQrM0BKMClMAjpP00nWycmNq30xqGbN7ay9xIeAf5HbQBaJ69owsU
         d1dXwAXFNKHsD/RUh1LR84os8+H59j8nF3Bx1c9p6TvBd7AHvrVHcnzVr05EL6SfzYoB
         DpWQ==
X-Gm-Message-State: AOAM532rTaATkQzgFAfEzzveNzBPmCrVEgT5LkFVBtLDJnctF3a74nk4
	djbCfcokyleEYnSt8OwQ5CASJQ==
X-Google-Smtp-Source: ABdhPJykQhA773Y/RsqqBh6IkXbjxUAGr+2WNPNkmamwrqnCASrzuPNLdRBsNJk4iZWq6CDQhSD6fA==
X-Received: by 2002:a17:90a:950a:: with SMTP id t10mr5013648pjo.107.1599169872611;
        Thu, 03 Sep 2020 14:51:12 -0700 (PDT)
Date: Thu, 3 Sep 2020 14:51:10 -0700
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
Subject: Re: [PATCH v2 05/28] objtool: Add a pass for generating __mcount_loc
Message-ID: <202009031450.31C71DB@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-6-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-6-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:30PM -0700, Sami Tolvanen wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> Add the --mcount option for generating __mcount_loc sections
> needed for dynamic ftrace. Using this pass requires the kernel to
> be compiled with -mfentry and CC_USING_NOP_MCOUNT to be defined
> in Makefile.
> 
> Link: https://lore.kernel.org/lkml/20200625200235.GQ4781@hirez.programming.kicks-ass.net/
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>

Hmm, I'm not sure why this hasn't gotten picked up yet. Is this expected
to go through -tip or something else?

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
