Return-Path: <kernel-hardening-return-18456-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 96FA21A0D2C
	for <lists+kernel-hardening@lfdr.de>; Tue,  7 Apr 2020 14:00:43 +0200 (CEST)
Received: (qmail 14083 invoked by uid 550); 7 Apr 2020 12:00:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 14057 invoked from network); 7 Apr 2020 12:00:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586260825;
	bh=Uqf4rhYga9NNaBB0Dvwp58Stj1GsGS4Ihxkd+ju3McQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=E935JBusz1dhcXd3k8A7zx8suuSJMLf0ayQTBsmc45RUI8lyhrdrtTnNAJzYj5xNA
	 xLcqMb2m5Wkp9tmsyPfaUElwuRYUAtn0Uzc3nJVlsN0CeeXhByB1bPusMB8jCgB2DI
	 L1XZSs/zEpyiinCUV/kxNIp6wYGvhhMxZuAOTsN8=
X-Gm-Message-State: AGi0PuZ8C7rnKMyMe5zaf3I/3We2o+YEkykAWjjY6vgPHEs2AwP9t7/7
	jAjrD32GU3jRvRAnRABdLXM+hSoYtxOfJrzh9EqdNA==
X-Google-Smtp-Source: APiQypJI+zUUJefqkI1wPoN1P7O6CrZHHpERpheNKfgg8qCaXTmeul5CgCiQbYpjls0Awj/83RzxNXZ+ny+VOSB9RbA=
X-Received: by 2002:a05:6000:1002:: with SMTP id a2mr2399545wrx.151.1586260823114;
 Tue, 07 Apr 2020 05:00:23 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20200406164121.154322-1-samitolvanen@google.com> <20200406164121.154322-13-samitolvanen@google.com>
In-Reply-To: <20200406164121.154322-13-samitolvanen@google.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 7 Apr 2020 14:00:12 +0200
X-Gmail-Original-Message-ID: <CAKv+Gu9psVBSdUvcRWNrEvjK4ckyA-vGKmZ33O2NUm-Pt4eJig@mail.gmail.com>
Message-ID: <CAKv+Gu9psVBSdUvcRWNrEvjK4ckyA-vGKmZ33O2NUm-Pt4eJig@mail.gmail.com>
Subject: Re: [PATCH v10 12/12] efi/libstub: disable SCS
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	James Morse <james.morse@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 6 Apr 2020 at 18:42, Sami Tolvanen <samitolvanen@google.com> wrote:
>
> Shadow stacks are not available in the EFI stub, filter out SCS flags.
>
> Suggested-by: James Morse <james.morse@arm.com>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  drivers/firmware/efi/libstub/Makefile | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/drivers/firmware/efi/libstub/Makefile b/drivers/firmware/efi/libstub/Makefile
> index 094eabdecfe6..fa0bb64f93d6 100644
> --- a/drivers/firmware/efi/libstub/Makefile
> +++ b/drivers/firmware/efi/libstub/Makefile
> @@ -32,6 +32,9 @@ KBUILD_CFLAGS                 := $(cflags-y) -DDISABLE_BRANCH_PROFILING \
>                                    $(call cc-option,-fno-stack-protector) \
>                                    -D__DISABLE_EXPORTS
>
> +#  remove SCS flags from all objects in this directory
> +KBUILD_CFLAGS := $(filter-out $(CC_FLAGS_SCS), $(KBUILD_CFLAGS))
> +
>  GCOV_PROFILE                   := n
>  KASAN_SANITIZE                 := n
>  UBSAN_SANITIZE                 := n
> --
> 2.26.0.292.g33ef6b2f38-goog
>
