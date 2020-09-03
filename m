Return-Path: <kernel-hardening-return-19762-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 14D8B25CD6D
	for <lists+kernel-hardening@lfdr.de>; Fri,  4 Sep 2020 00:23:58 +0200 (CEST)
Received: (qmail 18034 invoked by uid 550); 3 Sep 2020 22:23:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 18002 invoked from network); 3 Sep 2020 22:23:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=H9pa3N3N+X5kZ3hnxzvQ5nbf/nL9Hg2di+HfYCma81c=;
        b=MDW/84QFAbUZu6t/g0TK/VAn9O+TVo4DzXtdS9Mhsj4QS/PE4e+Rn1k5NJYTcEw24e
         tNZS2BxVn/MJcmyK/CDSaMc4ViToYo9qGsGIvo5Wk1nGGaIuLIS6ugX3FalJIhONa1De
         fN3g8m6b4O4IAz78V2dpe1p5CqrvjqKDQ1UOY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H9pa3N3N+X5kZ3hnxzvQ5nbf/nL9Hg2di+HfYCma81c=;
        b=IYpZRw7UmMCP74fw79mHOBVbbQbnfVZkxLLqU39dw2aVPzSPXvSAXOgnsDFRq0lkAq
         Murx/KCD1WkiGzXwDj98MBRE7kESkMl1JKUkOfqlDjWTlIGLR8kF6Qm5xB+qSRA3yzaj
         ZuDT+oRtilJt6PYlkvEE/YQFK7HrGP+BkX/eTOZwf7xtr+MIQkt2h6Fka6gUEelmBI4I
         PUjMTSlZGtM/ZVxboYx/R3bG8msHqgElFZCn8Wl+ej/KXebIxXtZpsGYYTCy4NvbWwDr
         kIwZS4jQfTlE8Nxd0E2gT8WZeoMxVEMm1pwyucJT4NnkEF40HiYJ3ZslpTR1vNgeriTA
         IHyA==
X-Gm-Message-State: AOAM531SbxOzsJwt8myeFrjf7nUBMdpYtTQij9KqOyj9AOIqQhvN5XGh
	ueRAcL7hBNe1GoH7jZVPhrnHlg==
X-Google-Smtp-Source: ABdhPJxcY2j2KcoBxTS2ZsNzK0y4z5+F+CWnnaOAlqa994vL2EIo7Uflbx8UD2XsOoy0qHrpZNJapg==
X-Received: by 2002:aa7:9286:0:b029:13c:1611:66c1 with SMTP id j6-20020aa792860000b029013c161166c1mr4124056pfa.12.1599171819570;
        Thu, 03 Sep 2020 15:23:39 -0700 (PDT)
Date: Thu, 3 Sep 2020 15:23:37 -0700
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
Subject: Re: [PATCH v2 13/28] kbuild: lto: merge module sections
Message-ID: <202009031522.2BA9A035@keescook>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <20200903203053.3411268-14-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200903203053.3411268-14-samitolvanen@google.com>

On Thu, Sep 03, 2020 at 01:30:38PM -0700, Sami Tolvanen wrote:
> LLD always splits sections with LTO, which increases module sizes. This
> change adds a linker script that merges the split sections in the final
> module.
> 
> Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

We'll likely need to come back around to this for FGKASLR (to keep the
.text.* sections separated), but that's no different than the existing
concerns for FGKASLR on the main kernel.

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
