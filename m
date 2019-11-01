Return-Path: <kernel-hardening-return-17249-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A2D03ECB71
	for <lists+kernel-hardening@lfdr.de>; Fri,  1 Nov 2019 23:36:33 +0100 (CET)
Received: (qmail 30044 invoked by uid 550); 1 Nov 2019 22:36:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30024 invoked from network); 1 Nov 2019 22:36:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VOVEnixRZLxQkCHgEpMJYKVl9naG8q4Bhsey3a4BJyw=;
        b=Bli3xmuBt9/GwnfhQ+WLZeBpC+LGylrKEihKmG9wDJcaF6w3L/ZQ8vt3GI4YPWXFJQ
         5Om7iCdkbv/lP18+LV92eRVs401olXcWreQAxfwPfepVtiVSDh9+nHAn2/3d+gfz9UVm
         yMWAVezWZJNqsbBLHANyYxJW6QpG5vniX1o53MF1dl5bc0zwLsqDDWKMYaMNZ47JDbyE
         v0XCStgcgsGwANfNW7O2l7MqWzWiGoQksAS9QIjgoVFUAhEy6735xDLs92DbjUK8gYCH
         q+fHcZwm6Ytrc4SrW8PPtsChFVdCSMaGofeTewgiaGn6jHXy73Odpndaqn2pcpxNkMKy
         K1qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VOVEnixRZLxQkCHgEpMJYKVl9naG8q4Bhsey3a4BJyw=;
        b=psL9f3qhp6ZirO81wBCPR9JzyKNRqfYybz4SdYOkl3k20VU0zAOPusr4VeYvaR3mV2
         zkRz/HmGVvvjEbtGypCZ5PrlU2B7YdrqxOllDDTuJQv93XVzJUsS6JROuD48oQYy2PDG
         uGw0him6pd6C7P6dlwAlrxFrBB0tlQ8gueb6yEUlkcVEyv6TxM0WOqyhb+OdKWXVS+Pw
         4OMi2yFuL1JqzUojUl2EDBWyNezn7U8CO34dU/k8s4ux5rlT0zimGXEL2vzWOAs0yocX
         LounRS+502mShob3iQIvdlheuHfeGDCYSMU4XswmkW3V3+6bbP8nyP6jflm35J8K0kz7
         EIwg==
X-Gm-Message-State: APjAAAWPnyFB00BS3LHY6fGjxEl+3uNQlwmCWJhjw80dkFaH2Bl8H43c
	whDq4+sMuxUKMhTDifFkpKDkyOsjWaNl2Jsm3Do=
X-Google-Smtp-Source: APXvYqy3a3LpygwD50Ud81Z6exZF+LaVqLS3Tw+hEBAZP5UzR+Yt5u6jie3UaWjeMgSpzygcRllXXMsmSmfSgwH5eE4=
X-Received: by 2002:a2e:8852:: with SMTP id z18mr9873721ljj.230.1572647776833;
 Fri, 01 Nov 2019 15:36:16 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191101221150.116536-1-samitolvanen@google.com> <20191101221150.116536-6-samitolvanen@google.com>
In-Reply-To: <20191101221150.116536-6-samitolvanen@google.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Fri, 1 Nov 2019 23:36:05 +0100
Message-ID: <CANiq72=Z285XTHguDoL5Eq_7XRcounmBfscquFPRWk3BH5kLvA@mail.gmail.com>
Subject: Re: [PATCH v4 05/17] add support for Clang's Shadow Call Stack (SCS)
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, Nov 1, 2019 at 11:12 PM Sami Tolvanen <samitolvanen@google.com> wrote:
>
> This change adds generic support for Clang's Shadow Call Stack,
> which uses a shadow stack to protect return addresses from being
> overwritten by an attacker. Details are available here:
>
>   https://clang.llvm.org/docs/ShadowCallStack.html
>
> Note that security guarantees in the kernel differ from the
> ones documented for user space. The kernel must store addresses
> of shadow stacks used by other tasks and interrupt handlers in
> memory, which means an attacker capable reading and writing
> arbitrary memory may be able to locate them and hijack control
> flow by modifying shadow stacks that are not currently in use.
>
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>

Reviewed-by: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>

Cheers,
Miguel
