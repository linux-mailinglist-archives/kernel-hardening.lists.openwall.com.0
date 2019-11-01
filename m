Return-Path: <kernel-hardening-return-17227-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 07D5DEC6B6
	for <lists+kernel-hardening@lfdr.de>; Fri,  1 Nov 2019 17:28:51 +0100 (CET)
Received: (qmail 13887 invoked by uid 550); 1 Nov 2019 16:28:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13864 invoked from network); 1 Nov 2019 16:28:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cugJW9F3kTAr1l84/vLpT5yr86XijpMcBnCXxXWK4UA=;
        b=ai3N6Ic4RRGuSAsXlls5IzMaslA5Wbr/HVntf4UgHRgBb1znSgpSqTQDhgWkXAk5oM
         H0TMkU5NqeJqmaviuucs+F/wv2mYGbxw4p/TlWjmTA7nxtnYoIewy1UZepA7s1zvqFi+
         J0gxVuzM5VGToU0Rd8Mze3tyCLh7RZ7qRdkeI4u+x2bACiJuZjdPOS6PF5wclT402Cyl
         E4V47Z+G3JNyTOeTMcNM9nltwL7iNcdGY46YKNmZkjxzRh51T0x1vup1917ckL2zPFgG
         WhafP3q/o/Aolmq4VvLO1/E0Za4fVCa/z+d1jFfQQJXZNS7+zE2mjM1J0A4RaF2Z5bp3
         En0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cugJW9F3kTAr1l84/vLpT5yr86XijpMcBnCXxXWK4UA=;
        b=QaSOKCKIObLDOnOoqW830cV4xXL9Lq38/nAB5++daaajaNuEqP/9auC+19gnlraKMR
         MtBeD/opk0Bdk1TyJBw4OtcauR552d/4RGWBT6rAEK6tMEgoTNoPqK4k0/Mom65TV52I
         H3KhYC4TNaZzHt8TCR7fxYpF4plStoqpTvJcRw/IUBbNm07kxD5L7UAXl5DePRQLcaNx
         OQqL6mzJudh9/kRPhcn5qZjeH9NvdsoNbN8EZoAogUqA7DRkoexxNHF5CfMVTuXVvH6C
         aA8xBUSOIu7GRAxywLCB+N6tqwYjjNgtOuIu93Sw08tVhspE+RqQBgyEh8zi0M74Qjqm
         EN0A==
X-Gm-Message-State: APjAAAUM2Oh0Yy+rXJwJw16a+bWSJ7dLFYphg72hvQAj/CoMf1UoFZXi
	kqgq+Y2TgUu3a5xtdZEbxoBrfBIyQKyoybieeBf0bQ==
X-Google-Smtp-Source: APXvYqz0PMfInUZYTnVA7QuGr/acGPXLqC8RP/nrNkyeFglf9nt3ZmPDMS4W5mUNYn60Yk/KFVXZFpuxRp6NFZg7Kqc=
X-Received: by 2002:ab0:2381:: with SMTP id b1mr5975220uan.106.1572625713398;
 Fri, 01 Nov 2019 09:28:33 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191031164637.48901-1-samitolvanen@google.com> <20191031164637.48901-6-samitolvanen@google.com>
 <201910312050.C538F8F3@keescook>
In-Reply-To: <201910312050.C538F8F3@keescook>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 1 Nov 2019 09:28:21 -0700
Message-ID: <CABCJKueLtOJsq+k-ywyUCOU+QCqxjKN2bO76Te4U43g0Xp9g-A@mail.gmail.com>
Subject: Re: [PATCH v3 05/17] add support for Clang's Shadow Call Stack (SCS)
To: Kees Cook <keescook@chromium.org>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	Nick Desaulniers <ndesaulniers@google.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 31, 2019 at 8:51 PM Kees Cook <keescook@chromium.org> wrote:
> > +/* A random number to mark the end of the shadow stack. */
> > +#define SCS_END_MAGIC        0xaf0194819b1635f6UL
>
> Is 0xaf.... non-canonical for arm64? While "random", it should also
> likely be an "impossible" value to find on the call stack.

Agreed, and yes, this is non-canonical for arm64 and AFAIK all 64-bit
architectures the kernel supports. I'll add a note about it.

Sami
