Return-Path: <kernel-hardening-return-19153-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4B78C209737
	for <lists+kernel-hardening@lfdr.de>; Thu, 25 Jun 2020 01:37:49 +0200 (CEST)
Received: (qmail 26028 invoked by uid 550); 24 Jun 2020 23:37:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25995 invoked from network); 24 Jun 2020 23:37:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=mo7Dwe07kJhP63QLmOzciNFvW218NBaVIlEPp4HbWlg=;
        b=ghe0LNHZStIXrutzWngNn1w8HnVKxzkKAANg+f3UNbpWa1VXDLTQLRRUxQiw0ETxf1
         8IwO0ripMH+IKCR86WNY+ysG11jZ8MVO51xum9mEa475UtB+fdRpajYIKrof1LeRnhfw
         q/KZy9ALnBT7rcr/zSWyqYTnZ3OeY5pBxENZEDhKneGeIxS3jxNDb3T6z60V1Qc+Vdy6
         OTaykXWX6WKsBL92+Zu8AYSrqkunkoROSncALDdIHd5jRSMEYzkTx2v4nRNz4Z77j4S9
         tRCzT7qVWnXl4XZ9bSsfQVqiYUdUQyfJWFL+rlMfK7ACBBFVz6umkgQZxUMxIfkAgDuf
         rFfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=mo7Dwe07kJhP63QLmOzciNFvW218NBaVIlEPp4HbWlg=;
        b=avw103sWgehrDZARhdGa8gwOYOoBo2ufo5Ml7ebWOH7MNojooKkWngY4y3BtVr5bcb
         /sgzm0nMOF2KhHhWA7TdaCoLsY38U1EFmthMG6t+w7Odw4My+q7YWVVohVJq9pT9aWVI
         05X3yKJ3HXez2UnEkiFTYajBsYQ0OIw1pdX+OASQbti4iq9xpJ0mSE8TIHFKT8ac8Pa3
         vlW54QN1lV7lYimUxAwHNa8btfq5MVXQEumjMcTphd3DUHdpUlzSzUE4UfndplFBN/Yj
         0T4vv6IO/16sBBkqJVuypOqAdsI7SnolvOta/t5rqbYXg9+EsJUFW2oMJ5NF4yX8Zyva
         Zrwg==
X-Gm-Message-State: AOAM532CSqP/6wRgEXUAmFQjohHHxOlW8he/nv6dbhGISTUqbmmqHILb
	xMp0W4BwbK0f/DHBl6IEcrfdTw==
X-Google-Smtp-Source: ABdhPJzbL+A8YRu6cQqMhEnH4JVMHPuZevDUkJdMyUg1rfNtOurVArWJG2BoYxI9g7/QXZLvtzZHnQ==
X-Received: by 2002:a17:90a:9d8b:: with SMTP id k11mr267919pjp.10.1593041850610;
        Wed, 24 Jun 2020 16:37:30 -0700 (PDT)
Date: Wed, 24 Jun 2020 16:37:24 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux@googlegroups.com,
	kernel-hardening@lists.openwall.com, linux-arch@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kbuild@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
	x86@kernel.org, George Burgess IV <gbiv@google.com>
Subject: Re: [PATCH 06/22] kbuild: lto: limit inlining
Message-ID: <20200624233724.GA94769@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-7-samitolvanen@google.com>
 <20200624212055.GU4817@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200624212055.GU4817@hirez.programming.kicks-ass.net>

On Wed, Jun 24, 2020 at 11:20:55PM +0200, Peter Zijlstra wrote:
> On Wed, Jun 24, 2020 at 01:31:44PM -0700, Sami Tolvanen wrote:
> > This change limits function inlining across translation unit
> > boundaries in order to reduce the binary size with LTO.
> > 
> > The -import-instr-limit flag defines a size limit, as the number
> > of LLVM IR instructions, for importing functions from other TUs.
> > The default value is 100, and decreasing it to 5 reduces the size
> > of a stripped arm64 defconfig vmlinux by 11%.
> 
> Is that also the right number for x86? What about the effect on
> performance? What did 6 do? or 4?

This is the size limit we decided on for Android after testing on
arm64, but the number is obviously a compromise between code size
and performance. I'd be happy to benchmark this further once other
concerns have been resolved.

Sami
