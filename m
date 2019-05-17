Return-Path: <kernel-hardening-return-15953-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D61CA21BBC
	for <lists+kernel-hardening@lfdr.de>; Fri, 17 May 2019 18:38:02 +0200 (CEST)
Received: (qmail 15886 invoked by uid 550); 17 May 2019 16:37:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15863 invoked from network); 17 May 2019 16:37:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VgMR8fw/3btcfeCqUg+SAAzIGGZgPBuWMbQyEv64ZSw=;
        b=VsbWyvJhK63OLyZtQo8OaklsBhS46OZmNozcVmNGar+obQPJhvlUBVqOtwGNUSk1eg
         XQLDrD2d4ySpIj+jC/9WTu8arAVvxo1JKc+nmnC7ij3hJEvOBgk1CqWeKXnT7VCYKeoC
         VGVRU6vvl7th23Ka2qGEjSEJ0XcL1IbV/xwEs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VgMR8fw/3btcfeCqUg+SAAzIGGZgPBuWMbQyEv64ZSw=;
        b=gaUem0yvYxnohg8XJMxA8sdB5J4XxqGM8wcCWC0o0O95TyL4LpwXAKlyn6IJOQZqUx
         YdPhVRHBZz9NjNc3+fFT9WMQExzz60zJ1Y8Xl5aC5Xht2epQTPcxnfMDA/FS/ms2WVVE
         sV4kUEa9OVjuUGUfqqst47EYZ4KrEx8sI+KMriqbtLlb8eglgfzK2PSAoT+/XA7LQK2r
         Gjx0vcCM9uyx6dBpxKsZZJEXODNDHW9xX6RlPFUxWu7J/BG1iPj6bghobHZVigCKuLA8
         ChTE2kiLG3jtCtpFCWK1IzccLq7jpNnE8LADXLbnUFKI4MX7NdwiY2+kXdVJPhCXGCAy
         GmAA==
X-Gm-Message-State: APjAAAUNXbsQ5CAXOfBlpqRBEujL+Mm7892021fts5F07kS1JGqLla0H
	r1gDbmmi8U2xtyWBMWX/Ugv00A==
X-Google-Smtp-Source: APXvYqwFidnBAPTL+woN/ou51mJsyoX35Z9berovyuDT4vsLcTEwjuG1xg0yIHCeu2pFUSIcHbV0oQ==
X-Received: by 2002:a63:4342:: with SMTP id q63mr57175169pga.435.1558111065442;
        Fri, 17 May 2019 09:37:45 -0700 (PDT)
Date: Fri, 17 May 2019 09:37:43 -0700
From: Kees Cook <keescook@chromium.org>
To: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@linux.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Kostya Serebryany <kcc@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Sandeep Patil <sspatil@android.com>,
	Laura Abbott <labbott@redhat.com>, Jann Horn <jannh@google.com>,
	Linux Memory Management List <linux-mm@kvack.org>,
	linux-security-module <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v2 2/4] lib: introduce test_meminit module
Message-ID: <201905170937.7A1E646F61@keescook>
References: <20190514143537.10435-1-glider@google.com>
 <20190514143537.10435-3-glider@google.com>
 <201905151752.2BD430A@keescook>
 <CAG_fn=VVZ1FBygbAeTbdo2U2d2Zga6Z7wVitkqZB0YffCKYzag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG_fn=VVZ1FBygbAeTbdo2U2d2Zga6Z7wVitkqZB0YffCKYzag@mail.gmail.com>

On Fri, May 17, 2019 at 05:51:17PM +0200, Alexander Potapenko wrote:
> On Thu, May 16, 2019 at 3:02 AM Kees Cook <keescook@chromium.org> wrote:
> >
> > On Tue, May 14, 2019 at 04:35:35PM +0200, Alexander Potapenko wrote:
> > > Add tests for heap and pagealloc initialization.
> > > These can be used to check init_on_alloc and init_on_free implementations
> > > as well as other approaches to initialization.
> >
> > This is nice! Easy way to test the results. It might be helpful to show
> > here what to expect when loading this module:
>
> Do you want me to add the expected output to the patch description?

Yes, I think it's worth having, as a way to show people what to expect
when running the test, without having to actually enable, build, and
run it themselves.

-- 
Kees Cook
