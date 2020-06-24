Return-Path: <kernel-hardening-return-19132-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B6F52207DC7
	for <lists+kernel-hardening@lfdr.de>; Wed, 24 Jun 2020 22:57:40 +0200 (CEST)
Received: (qmail 3939 invoked by uid 550); 24 Jun 2020 20:57:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3907 invoked from network); 24 Jun 2020 20:57:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2UVd4Vpuu4Hnm6XlHGR5cRrZnqXWEFfAzghKkxqA5PE=;
        b=BPMaWjSiHqVF8vi4hiTlzAVhVpOBnqRB11zTq0lEeedJqVV+du+PNZ4KmaMlIsirPC
         R928oKYPPNEK406mCXXrFo5ILeh9cKok03PTJz6JfAnRQKQCv1Rh1SMBWeCtT9nOL0oJ
         lryLagao4wnwA1qFmJ4sPzSNGD7lPYGa8eVmfocCRrLBf+dhWLYjqG85ZdT9LeohIlOb
         2EmJnnhlOHrRKj1PGL5sVH9SaXtWzsmYftW61LHVwvnNA7wui7tFGXqcFXutnYBMCItr
         GdL2Vo1Q7hX8hrKDrgkMAaZk/eo83KbXysC70mpN3P9EzjPp00OuZYiGpwRBnkB00cCL
         l6nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2UVd4Vpuu4Hnm6XlHGR5cRrZnqXWEFfAzghKkxqA5PE=;
        b=QIPnM7Ah5j83Hlw6Aot7R+i6QUcjzdChNOsxdwYM4TxuOwOQRlHdW/uuI41C1SMveu
         TNpV480NIHg0uKB30DbvoWUo3ccMBSRZt2T6De/egI7+YlVGYbhDbxeESCI0bnt7jSTM
         9SMhElTSojncOnqlwqwqit0wvTErzAhUjAWO2qMTaUOuzfzki1jhElY9GaBCRD0MjmiZ
         k5JfVOmw11+oyrwb5Wps+pOKU5o1D/AKSp+Tq7CwBaADo1TEak5vFaC3s9fpUHupazTD
         BHmedoOcD8w0jiwHJrFT+qyKEYmYGOBw+Zwv2+LtedCJZa4cKQJEEtmPDzFBmdxDPKk7
         8GgQ==
X-Gm-Message-State: AOAM530m52fDauSWPnK0ETvxef9epPl7+UUWGY9AYH/4q5UY6GZanB+h
	G0tT1XaVb5y9RgvigMKhx/1erFCiWzxuFCl1jMG1/w==
X-Google-Smtp-Source: ABdhPJwqdv1zjA72U6Y+yinTpL4jIF0WvT5OjmcvgBRWy2HcW+N17omaHs7u2Al3ueQuo5czHPS48NLDnn5YbwyPtt8=
X-Received: by 2002:a63:a119:: with SMTP id b25mr22841048pgf.10.1593032243514;
 Wed, 24 Jun 2020 13:57:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200624203200.78870-1-samitolvanen@google.com> <20200624203200.78870-14-samitolvanen@google.com>
In-Reply-To: <20200624203200.78870-14-samitolvanen@google.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Wed, 24 Jun 2020 13:57:11 -0700
Message-ID: <CAKwvOd=XxsGowjitcqDrw6g-cxB=kqAsvRS+PyaMrYWnPgjqbg@mail.gmail.com>
Subject: Re: [PATCH 13/22] scripts/mod: disable LTO for empty.c
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Will Deacon <will@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org, 
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jun 24, 2020 at 1:33 PM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> With CONFIG_LTO_CLANG, clang generates LLVM IR instead of ELF object
> files. As empty.o is used for probing target properties, disable LTO
> for it to produce an object file instead.
>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

> ---
>  scripts/mod/Makefile | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/scripts/mod/Makefile b/scripts/mod/Makefile
> index 296b6a3878b2..b6e3b40c6eeb 100644
> --- a/scripts/mod/Makefile
> +++ b/scripts/mod/Makefile
> @@ -1,5 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0
>  OBJECT_FILES_NON_STANDARD := y
> +CFLAGS_REMOVE_empty.o += $(CC_FLAGS_LTO)
>
>  hostprogs      := modpost mk_elfconfig
>  always-y       := $(hostprogs) empty.o
> --
> 2.27.0.212.ge8ba1cc988-goog
>


-- 
Thanks,
~Nick Desaulniers
