Return-Path: <kernel-hardening-return-19141-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 28241207E86
	for <lists+kernel-hardening@lfdr.de>; Wed, 24 Jun 2020 23:29:26 +0200 (CEST)
Received: (qmail 30270 invoked by uid 550); 24 Jun 2020 21:29:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30238 invoked from network); 24 Jun 2020 21:29:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8S7wdQVFSvGinNDpzeGeM5bOvAIHO3+dn7qtS4xKvV8=;
        b=QSb2yx30HozPwbE3cmDUoYnn/m54tkj1kAjJCdgJUPE9p9hcmMPBKaVPQ8nq6Bc1WJ
         qB9goQOthKh59QOfHEOB0pjBNCmP4PYV/LKAx2CJEjeYgcYLuigmtDK1rd0z3GBirbjf
         QT7+7vbSd+q2ZOzjXvTocpYNfGsOGa/P0watDoU+3ObHezue05cXmufnhVEm5Q3ZZmTa
         XCjrJbaX5IO0+0GeI80gfIvjmkaMIwYTVrZh2tjnwzLuU1tncROVGCLiilpUzqVPfzKM
         RIHYMVRhw56vrkubCQ6vuKEMInx200lTXE2eT3cyIagXjOxlrxuHoW9NFhenw6ZcgEPv
         QI4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=8S7wdQVFSvGinNDpzeGeM5bOvAIHO3+dn7qtS4xKvV8=;
        b=O86YjNMRhd4HsI2As/wJM/2TnohIkudEYaRs8g1F7VBC6x9ZPhMCAd5NL9ci4Y9P6Q
         XRjuf63YmsTFu3X3QATLye3ZHhpUrywxyOEjmhfJNpO3bPei9ZUlpzSI/V6Fq6lphajX
         hdTK0TdqmldANTn4YssethTOKol4LM/15PwHGPzSXPqWziIe3g6KK+TnqhWB3D26EPeq
         x1U63X5CkTZSbykEIwjjeJDxcwjtL1f9/ZK4N4znzC8nVX0VR9yXm8oICDwd5SorEntk
         CTc53jeffnbjODk3mlRu5dw9FxdhFvblUy2Stt8zOQ/oK0a4SDpTGmX+Y0T75tUhm1m/
         jVqg==
X-Gm-Message-State: AOAM531pMOiD0mryYiVoVZAmE9cDlk9oEILvQR4A9nd0C3e7FeqEQOsA
	bzau2BvjcmXPlT7hLGphJsqJuA==
X-Google-Smtp-Source: ABdhPJzNztQf4xK5/Zlp8kovh17ym7/QBwLnR6UiKFeUru/SjadRA2bRjfkD85Hht24sZeCqpm8n5Q==
X-Received: by 2002:a63:79c2:: with SMTP id u185mr6299836pgc.84.1593034148817;
        Wed, 24 Jun 2020 14:29:08 -0700 (PDT)
Date: Wed, 24 Jun 2020 14:29:02 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	Linux ARM <linux-arm-kernel@lists.infradead.org>,
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [PATCH 02/22] kbuild: add support for Clang LTO
Message-ID: <20200624212902.GA26253@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200624203200.78870-3-samitolvanen@google.com>
 <CAKwvOdm=sDLVvwOAc34Q8O85SCHL-NWFjkMeAeLZ4gYRr4aE9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdm=sDLVvwOAc34Q8O85SCHL-NWFjkMeAeLZ4gYRr4aE9A@mail.gmail.com>

On Wed, Jun 24, 2020 at 01:53:52PM -0700, Nick Desaulniers wrote:
> On Wed, Jun 24, 2020 at 1:32 PM Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > diff --git a/Makefile b/Makefile
> > index ac2c61c37a73..0c7fe6fb2143 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -886,6 +886,22 @@ KBUILD_CFLAGS      += $(CC_FLAGS_SCS)
> >  export CC_FLAGS_SCS
> >  endif
> >
> > +ifdef CONFIG_LTO_CLANG
> > +ifdef CONFIG_THINLTO
> > +CC_FLAGS_LTO_CLANG := -flto=thin $(call cc-option, -fsplit-lto-unit)
> 
> The kconfig change gates this on clang-11; do we still need the
> cc-option check here, or can we hardcode the use of -fsplit-lto-unit?
> Playing with the flag in godbolt, it looks like clang-8 had support
> for this flag.

True, we don't need cc-option here anymore. I'll remove it, thanks.

> > +KBUILD_LDFLAGS += --thinlto-cache-dir=.thinlto-cache
> 
> It might be nice to have `make distclean` or even `make clean` scrub
> the .thinlto-cache?  Also, I verified that the `.gitignore` rule for
> `.*` properly ignores this dir.

Sure, distclean sounds appropriate to me.

Sami
