Return-Path: <kernel-hardening-return-17078-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B2932DF26E
	for <lists+kernel-hardening@lfdr.de>; Mon, 21 Oct 2019 18:07:18 +0200 (CEST)
Received: (qmail 30626 invoked by uid 550); 21 Oct 2019 16:07:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30602 invoked from network); 21 Oct 2019 16:07:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JE8U2Fghv6YjjweCRTqDn5FZUlMFhhM8tZP7QTcsL4M=;
        b=BXwbjyQHcxJWNiy0iXKopawMWLVVLer31/iixLJkLYJrr0DN6W/g3Yxd8AhYLMw4GY
         yaOOYp6clpQlM8wBCeAsr7WNscSUW0a/CNbCltgSRmtM67DKbQ4DtyJUrsqntno1wI5y
         6L8iL7u4BsmyrJM63Dgery3dZ3UK4EZQgDH+w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JE8U2Fghv6YjjweCRTqDn5FZUlMFhhM8tZP7QTcsL4M=;
        b=Wx2AxnVazB39bkkgqXeMdlbeNXK1Myac5txQTKiZaAs5wRPKYHZguTNFszcm+aRt+w
         Go/L1Tbi69Jo3v8tenGdH7ZHc0WAUO38kOhO34bQvXkZGejl9uzaAm2Qk6hPrWu/v9CM
         R3sUIszWXj1Udlc+i1I6DWno0XrREtVe0hA9Kf3k6BLYQIPp2d3qRmedd+TE0Uf3PhDA
         LrRyt4nWohKBOtSNYt8YKVN5XdjaoE3ksuaOIyjMPboUfMF9HOW02zED2i/Jv2qVjC2L
         4PLo1/I8CqAjsF+bFpwVwamu+QlxAnVTmIwKxA4Q7TBewNk76Vr872D92qu/enADkBD3
         69uA==
X-Gm-Message-State: APjAAAVmV+gI9UGQ1c3SE7QfBI3Zlu1i1e11xJYqCzmz42ihQPw/9r+V
	5XWfI2ChjPKzRe0Ye+So4qA8rg==
X-Google-Smtp-Source: APXvYqwJTcp7CnYya1sildKDZQhELifTwgg5siNr/xx7tKpVABk+cPNBC7anzYKvXWswmQ1TD7x5Qg==
X-Received: by 2002:aa7:96a9:: with SMTP id g9mr23757769pfk.147.1571674020135;
        Mon, 21 Oct 2019 09:07:00 -0700 (PDT)
Date: Mon, 21 Oct 2019 09:06:58 -0700
From: Kees Cook <keescook@chromium.org>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Dave Martin <Dave.Martin@arm.com>,
	Laura Abbott <labbott@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 16/18] arm64: kprobes: fix kprobes without
 CONFIG_KRETPROBES
Message-ID: <201910210905.7494C5C@keescook>
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-17-samitolvanen@google.com>
 <CAKv+Gu-88USO+fbjBgj35B4fUQ7A_t9nHO_swyN=T1q1G2wViA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-88USO+fbjBgj35B4fUQ7A_t9nHO_swyN=T1q1G2wViA@mail.gmail.com>

On Mon, Oct 21, 2019 at 08:21:48AM +0200, Ard Biesheuvel wrote:
> On Fri, 18 Oct 2019 at 18:11, Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > This allows CONFIG_KRETPROBES to be disabled without disabling
> > kprobes entirely.
> >
> > Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> 
> Can we make kretprobes work with the shadow call stack instead?

I've been viewing that as "next steps". This series is the first step:
actually gaining the feature and clearly indicating where future
improvements can live.

-- 
Kees Cook
