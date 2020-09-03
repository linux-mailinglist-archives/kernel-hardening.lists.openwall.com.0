Return-Path: <kernel-hardening-return-19755-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 11F1025CCF4
	for <lists+kernel-hardening@lfdr.de>; Thu,  3 Sep 2020 23:58:48 +0200 (CEST)
Received: (qmail 16146 invoked by uid 550); 3 Sep 2020 21:58:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 16107 invoked from network); 3 Sep 2020 21:58:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zwlTSlngv7hk/k8joOBYJecRtutX3pQhWGRYHaQfHNc=;
        b=cfK1czkMgexKgeV+AniPDaw2RXSPRTJErK03aD3KyKL4Fgd4NeDHwP5V8Xl/FfVKCS
         6F+iqqs9u11jyJ00qYjcMmLzcZHnV9wHK2dvI7ZXa7ITGd9X9E1vU0dh9lPkAo/o/+N9
         ZlfpNW1hK+/ISGP4OP8u8wm5pAhXJBxxqUlTY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=zwlTSlngv7hk/k8joOBYJecRtutX3pQhWGRYHaQfHNc=;
        b=Jg3vh02uTCMbGTe1qdJTDPVVoLo061yO0Ql0Y9aMASCgEDQht3qyJk9EDTLDkDvkrE
         GZ5A9ec42XL2Mh15QQ88M50MvXr8a0yJER5/la5WvfYhiLAhCZJHfk5xNwvyV17eo0Ub
         EaxYFYHBKUlByVA8yWh0utP00+mt7uh7L02nymwNjL8GrcZiv/xDQ7lG/4d2z3d3wPwl
         la8ZWD481W0S0oBeZbkP1z12qMrgSsATUriY5hBaQrb97xNpnFU4Uxb4emRj0Dz8KHOQ
         k2wH8aZev4c/KucImFZQf0Cmq8UkVQPxMPDOuKf4gRmmQiEqaSbMNAZQON02/CRbVRuQ
         loAQ==
X-Gm-Message-State: AOAM533YOgg4exSZMCmfc29G+/VCG6oQy+Lp1AKzfiBmizVo91pTRuSh
	UmsplCLJwUH9vJCVn2SccrB2Jw==
X-Google-Smtp-Source: ABdhPJxsSBaVqKQu0Depn8jVU89HVsiUUr1gbeyokvUp0RXsPEsXdBRA9MTk7ZF9gX6Cd/pjcZAmmw==
X-Received: by 2002:a63:d70f:: with SMTP id d15mr4658855pgg.354.1599170310450;
        Thu, 03 Sep 2020 14:58:30 -0700 (PDT)
Date: Thu, 3 Sep 2020 14:58:28 -0700
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
Subject: Re: [PATCH v2 08/28] x86, build: use objtool mcount
Message-ID: <202009031456.C058EC4@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-9-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-9-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:33PM -0700, Sami Tolvanen wrote:
> Select HAVE_OBJTOOL_MCOUNT if STACK_VALIDATION is selected to use
> objtool to generate __mcount_loc sections for dynamic ftrace with
> Clang and gcc <5.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Am I right to understand that this fixes mcount for Clang generally
(i.e. it's not _strictly_ related to LTO, though LTO depends on this
change)? And does this mean mcount was working for gcc < 5?

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
