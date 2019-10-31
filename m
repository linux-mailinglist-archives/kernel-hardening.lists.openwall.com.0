Return-Path: <kernel-hardening-return-17205-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 827DBEB61D
	for <lists+kernel-hardening@lfdr.de>; Thu, 31 Oct 2019 18:27:57 +0100 (CET)
Received: (qmail 7566 invoked by uid 550); 31 Oct 2019 17:27:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7534 invoked from network); 31 Oct 2019 17:27:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=46AmydREw6SfU27IOaxxeyDyoZWG9jeVi2WIEFhrMqA=;
        b=uKrGepNXzPXDPzJbvbemKuf7R6S5LOyd1Myup06RKzLSP2nrNd0gQdYUKo5Mow3DAS
         +SE7IfD6gsDwY0qy8BSl0pYU8GPWYV87yKCwXeFmUj8tfcvjCxE6XCZvWViSX7BLJr2h
         JeRICf0gxuCWKgnMwiCuZSLMzerlDUIsThoYOFbNVmV4Iio6o99JIWYLgpdzR7oI4BDx
         tISF+YHwsfL5BB8DS6m0YqBcFdYRIfZsqtAtZCMGUCUGgOjGgmE4qf5gvZ9MBWNon0hF
         l2JKhPx8hF2es29OTb38GxXTjoyqOeNJvDE0LRnzacnT1nPR0db8A8Us17QUjMd2B+Rn
         jUDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=46AmydREw6SfU27IOaxxeyDyoZWG9jeVi2WIEFhrMqA=;
        b=K5RBC7V/byjIlzeFYiND2Bif2AxJmeXraPSzxCf4ss7TD52JJj8KE2mR8YecQrBG14
         JZ3Iuc2fQ15YLnBcfwkobf/coAcpj9/iLvs2Att2mnRpQal2Lb8NGM5db6ZT3ldEKpky
         goxW53sYkKMGZhQeTD4CoAKIZ8Trd7fCr/kd6tUkudr+TfvJAfeQO8ZZZ7bhK2YLcx+O
         6ApM3m0bZ+QZlgOfMfegCk5cQLdfcmuE4BRC7S6kyZV5zoTTg+R2UKWfjaQj1tSEMYO6
         4Z5RqNSLErWi3SyJxYkGjj6g/bTFzOPG4I0vnOi2Dj4m2XrrmaxRlrfaysIWWHIl7P+4
         1x0w==
X-Gm-Message-State: APjAAAVDEn0CNNd15I2kQ+UDBpskrq56TIbukOvH8M6wxWQrFziG3KD/
	zSw7SLEuD+x3i843VI68dYjHPaESxkn07S5zUOJ7MA==
X-Google-Smtp-Source: APXvYqwHBpr5C3UNKE6XLzBUe1Jy/aZ4Jd12qOfI93i2wDsaUH2oAUrgK4KH1mAvPJ/zcWPVngS0f/6vsb1FU+PAYk8=
X-Received: by 2002:a9f:3772:: with SMTP id a47mr3382097uae.53.1572542858440;
 Thu, 31 Oct 2019 10:27:38 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191031164637.48901-1-samitolvanen@google.com> <20191031164637.48901-14-samitolvanen@google.com>
 <CAKwvOd=kcPS1CU=AUjOPr7SAipPFhs-v_mXi=AbqW5Vp9XUaiw@mail.gmail.com>
In-Reply-To: <CAKwvOd=kcPS1CU=AUjOPr7SAipPFhs-v_mXi=AbqW5Vp9XUaiw@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Thu, 31 Oct 2019 10:27:26 -0700
Message-ID: <CABCJKudb2_OH5CRFm64rxv-VVnuOrO-ZOrXRHg8hR98Vj+BzVw@mail.gmail.com>
Subject: Re: [PATCH v3 13/17] arm64: preserve x18 when CPU is suspended
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, Dave Martin <Dave.Martin@arm.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Mark Rutland <mark.rutland@arm.com>, Jann Horn <jannh@google.com>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Oct 31, 2019 at 10:18 AM Nick Desaulniers
<ndesaulniers@google.com> wrote:
> > +#ifdef CONFIG_SHADOW_CALL_STACK
> > +       ldr     x18, [x0, #96]
> > +       str     xzr, [x0, #96]
>
> How come we zero out x0+#96, but not for other offsets? Is this str necessary?

It clears the shadow stack pointer from the sleep state buffer, which
is not strictly speaking necessary, but leaves one fewer place to find
it.

Sami
