Return-Path: <kernel-hardening-return-19767-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 259BF25CDDA
	for <lists+kernel-hardening@lfdr.de>; Fri,  4 Sep 2020 00:43:16 +0200 (CEST)
Received: (qmail 5644 invoked by uid 550); 3 Sep 2020 22:43:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5612 invoked from network); 3 Sep 2020 22:43:10 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QrnbZATBHBxQZ7fajeBTKOWCmjpG/tdsnBaMo8RMsl0=;
        b=arGEoVNcgRk6SvvgwhWybl2yTQQ/41JitWigdBdGhFS95Gmb9SWRyyuaVbLozcxhlL
         y6JEOwrroo7lJUf2OLWmcs3N8AyWgT7zx61RPK1c7lAmQb6YFg/HrUMlem7+hTwvS/bi
         td4g7TX1ItoN+b7bfyXxlkOCNCh28KvNVjWIM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QrnbZATBHBxQZ7fajeBTKOWCmjpG/tdsnBaMo8RMsl0=;
        b=VdntqwyKnq46e6wZmYI6f8aNRWm7xSN9eyGTZVn7ByBFuQalsANFj9q6wY7eWNIEJT
         sNKMECXigqpp+XWg6sU/MzfkFUVf421HJflxbYz5u54bpUqSbq/70jD67YEKzsMoaFPq
         JnBr3UB+dYomw+CvoYOO3W4VrQBpQJjZWj4pardYuoWaYi1iI+8RHQ4/hyVszguQv+ei
         TBi9V6vM3AJqW5txXO4ilYn1ZOSADSM6DQqNcz1NUwV0D8JO5TJz4bpSnHZnWydKeUW9
         l+vrUTGfsjqQ2blr9Fb7aw5sjC14KaxHnq/+1J6sxborbWp+OFMdTomO4T8hvjgS1KsS
         bD/g==
X-Gm-Message-State: AOAM533H85UzL176ZHOLCAHCfcdZAKBLqX0ifUjTgInDjVUQT2PV1e4B
	Neqs9tQE1RMG7AuBysb2BR5gWw==
X-Google-Smtp-Source: ABdhPJy5mdmPjJfruWrIY+6IxKRglw5a/F5w2SGFD8qLkoS56YGpVx+oFe/zdag2OFqeajEXIFLqFA==
X-Received: by 2002:a17:902:9a45:: with SMTP id x5mr6151434plv.208.1599172978633;
        Thu, 03 Sep 2020 15:42:58 -0700 (PDT)
Date: Thu, 3 Sep 2020 15:42:56 -0700
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
Subject: Re: [PATCH v2 18/28] modpost: lto: strip .lto from module names
Message-ID: <202009031542.1F8B3012FD@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-19-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-19-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:43PM -0700, Sami Tolvanen wrote:
> With LTO, everything is compiled into LLVM bitcode, so we have to link
> each module into native code before modpost. Kbuild uses the .lto.o
> suffix for these files, which also ends up in module information. This
> change strips the unnecessary .lto suffix from the module name.
> 
> Suggested-by: Bill Wendling <morbo@google.com>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
