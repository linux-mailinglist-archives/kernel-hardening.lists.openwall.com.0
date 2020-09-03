Return-Path: <kernel-hardening-return-19769-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5901125CDE7
	for <lists+kernel-hardening@lfdr.de>; Fri,  4 Sep 2020 00:43:57 +0200 (CEST)
Received: (qmail 9274 invoked by uid 550); 3 Sep 2020 22:43:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9234 invoked from network); 3 Sep 2020 22:43:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=x2xuRKyyLJWi/1UackWdCkMB4cqQZJ4+/7t+T3jGKh8=;
        b=lJIfcDz7WioC0cxPF2mcu4r4CpHJqN+NQMfhDVOZMDBJjVlbujjOIztvgAAg+FLLZl
         OQLArQHvfuAUFWnT+Br9hn0eKYi/T1OqGrNfJkgbHQQkXC6PnVXOP14VrZKCoiAx6sGj
         N08DlYuf2tSmgQZcy/X6jmQw8+vZKntUZzYMc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=x2xuRKyyLJWi/1UackWdCkMB4cqQZJ4+/7t+T3jGKh8=;
        b=W+SX4NBP1k9sRuNK4oWMxAz30ZHoRWISWLWS4xro0F6EZzQVkdluuwppPkfVk5YXTZ
         7E8MDdFXvdqO/J6CDOHMS5Cx8Lmr3oHIRikoJ9vWMH96/BiptnGY7xjqXr4VkxVWUeEa
         kZRjAkNgOFWumdw3eVeacnnG5iTrYeUxG9KHN6JMmv+BovraoQgF06Fx3FeKmzu6tmKi
         sG7pa42veP71APiTqbI97GxF+TfH82qHVLqNsC8eTK6AXu7tFu1w5toVf3ah+RlUNf2a
         9zHuccNmXIKalVsqGuhmO+aDZgVhw6a4u6tnNNTWgWEpevFKimji4chTL2lM7LrUcXLa
         4czA==
X-Gm-Message-State: AOAM531aXbLMz0MLeAw5k579hr5VWp9RakBF4FNdOVoDMkA9SSe+IYQI
	48YDbH2vnAGyvoLMTymMixbpOQ==
X-Google-Smtp-Source: ABdhPJxsKeiM9lZAcQ/0JJhv0k/hyo346z/156yZaTdrOqzHtGfq/qkV1ZHNDgZ+unL1v+eZfT0LrA==
X-Received: by 2002:a17:902:326:: with SMTP id 35mr6096909pld.1.1599173018675;
        Thu, 03 Sep 2020 15:43:38 -0700 (PDT)
Date: Thu, 3 Sep 2020 15:43:37 -0700
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
Subject: Re: [PATCH v2 20/28] efi/libstub: disable LTO
Message-ID: <202009031543.47CF616F@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-21-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-21-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:45PM -0700, Sami Tolvanen wrote:
> With CONFIG_LTO_CLANG, we produce LLVM bitcode instead of ELF object
> files. Since LTO is not really needed here and the Makefile assumes we
> produce an object file, disable LTO for libstub.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
