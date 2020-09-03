Return-Path: <kernel-hardening-return-19774-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8305D25CE11
	for <lists+kernel-hardening@lfdr.de>; Fri,  4 Sep 2020 00:46:29 +0200 (CEST)
Received: (qmail 17470 invoked by uid 550); 3 Sep 2020 22:46:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17438 invoked from network); 3 Sep 2020 22:46:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5TqmD5EyVPuB9TiyITqacSmLzI3cDbmlqWUeyi+ujCg=;
        b=oZ5KzCEi7wKIrEEj86amUMkUmItIM2KtyMb6kJV1Bx2j+6SLbFuob0rHAOq9f5nYH0
         BvcS2/vu4CZRFtoI7y0Mt062eAYVzZTqZzFG2Iu7rRRlhQSIXmNmKgue9t4cr4gsNbj6
         cT+JilU0DZpxA7uH2zokAyWWmg9TpkmIfF0Qk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5TqmD5EyVPuB9TiyITqacSmLzI3cDbmlqWUeyi+ujCg=;
        b=KCMqcT/tg+a3MhD2ujCifDJzOEbdKde1koqLcFVSZbvdk8zZ0brkM/DbzAWKpXlZIe
         d476amiul0XDKhFe3kfplaSXAbZC+CB+FOONwHuxTToatnOQjFdAMkVKHd5a2vU8nk27
         5fQq/hjaLlJQNecm/O2R7uuWLg1DvQAUO4jxXVHv1rHWlkEYOeAKhqDr1XyEYCVAvGvM
         lHIkJ5CK+tLvAJJXI95Cs65O6h3g42tVdTCim8ExpBaU/Pn/P9D3/o7DgsXaWsQK431n
         2WghjSEEkkAGw1MvjlogFxNMWhvoIKkxSA/a//0kSluAw5PVgHhxY0kj66ejHYIIgc1+
         Hyew==
X-Gm-Message-State: AOAM530dOsBiKbFn+Pxe/4VCNTeu401xkprRjcnEgHo5MteKQ+PBmqb7
	NpHw5qXSB9JBCXXdZzlX+FLcUg==
X-Google-Smtp-Source: ABdhPJz0Cu4W/SGUiAG+2DPCBbmeCYnLc7352WExRrDx24NF8XVfzJeuLOmeQkS8ntOwly5Q8T3lkw==
X-Received: by 2002:a63:ca12:: with SMTP id n18mr4721941pgi.371.1599173171199;
        Thu, 03 Sep 2020 15:46:11 -0700 (PDT)
Date: Thu, 3 Sep 2020 15:46:09 -0700
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
Subject: Re: [PATCH v2 26/28] x86, vdso: disable LTO only for vDSO
Message-ID: <202009031546.98CA2EF4@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-27-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-27-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:51PM -0700, Sami Tolvanen wrote:
> Remove the undefined DISABLE_LTO flag from the vDSO, and filter out
> CC_FLAGS_LTO flags instead where needed. Note that while we could use
> Clang's LTO for the 64-bit vDSO, it won't add noticeable benefit for
> the small amount of C code.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Moar DISABLE_LTO...

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
