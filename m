Return-Path: <kernel-hardening-return-19950-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E15A8270838
	for <lists+kernel-hardening@lfdr.de>; Fri, 18 Sep 2020 23:27:55 +0200 (CEST)
Received: (qmail 16068 invoked by uid 550); 18 Sep 2020 21:27:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 16036 invoked from network); 18 Sep 2020 21:27:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oyniRHLrev38PACfE6ROOUQ+EtF7xvXESn3D/FnfQhc=;
        b=Gd/q8cwdBNkyNhv65cXruSk7HmCBZyI0NM7/ouCTg5QPQHOOZqp4RghCLzMgzPGftR
         JznBjuFSKtHMubNl4QKBoWync+IMmD9ROTiROxQcWGORDHNeeJVuAmzGTG0krZ6EZ2uK
         mjIm+rW2vxoQGJLpOdD9TRJhgE5O7gUyhRSpQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oyniRHLrev38PACfE6ROOUQ+EtF7xvXESn3D/FnfQhc=;
        b=A6w4jDD4oj7k9qcc38fxWJKUeptvsiXKYUlYOvhJICl0hSPNY2Wqcas9pKL0F9pPBv
         F3DvaKI7Z1kJFQL03oeF2cg1CChoggas1SHa/uVHdXQ6iQpCyLcYxN4yHils0eeB9pHV
         NOHmSd1SFhWHTyuVCS7m4UHRGl8SVXLV7IXW7LNjChib5HM7zxdg+2eNVmHkVKfueUGt
         9g2PkzNfSUPMg3ToIAdaiM8Q9vMgEmmmFgHAtVYinVd4vIWqSufAxKPg6G9AOWJ0NQdT
         wysFpluL9uRMon6vuJaqmVyUBP4Y3LHEuP61VdaBxzbqPGxxEmjCIlUB3NERRQdMxgV4
         fVNw==
X-Gm-Message-State: AOAM532iLmPl9EfLkTmOT9kG62yLCO9Zdh+WZHQ5ecMLbrbzzHNSKGzB
	euR08FblmQNMoXmd+LMvbRqRrA==
X-Google-Smtp-Source: ABdhPJwQRHrvTU2iqmtduKsBEnDA5AQ9wnRrMouN20yhgYE7G4D0CEMvV1m3BHMubfbdZMtqWREQzQ==
X-Received: by 2002:a17:90b:50e:: with SMTP id r14mr14380487pjz.230.1600464457018;
        Fri, 18 Sep 2020 14:27:37 -0700 (PDT)
Date: Fri, 18 Sep 2020 14:27:34 -0700
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
Subject: Re: [PATCH v3 13/30] kbuild: lto: postpone objtool
Message-ID: <202009181427.86DE61B@keescook>
References: <20200918201436.2932360-1-samitolvanen@google.com>
 <20200918201436.2932360-14-samitolvanen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918201436.2932360-14-samitolvanen@google.com>

On Fri, Sep 18, 2020 at 01:14:19PM -0700, Sami Tolvanen wrote:
> With LTO, LLVM bitcode won't be compiled into native code until
> modpost_link, or modfinal for modules. This change postpones calls
> to objtool until after these steps, and moves objtool_args to
> Makefile.lib, so the arguments can be reused in Makefile.modfinal.
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Thanks for reorganizing this!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
