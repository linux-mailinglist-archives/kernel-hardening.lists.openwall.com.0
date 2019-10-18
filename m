Return-Path: <kernel-hardening-return-17052-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 945D8DCD18
	for <lists+kernel-hardening@lfdr.de>; Fri, 18 Oct 2019 19:54:59 +0200 (CEST)
Received: (qmail 13416 invoked by uid 550); 18 Oct 2019 17:54:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 23949 invoked from network); 18 Oct 2019 17:11:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XATsmiiQ65kT4ODqJ8G67gOZ75F3gzeYi1y9XLQaIlM=;
        b=NFaKn8K/6s2O1InStTL9sLz1AskGb0puzLhWcn2tdgY8ZmCLY7XOJRYveX8vbFZU0f
         AivKBQvkf/pODzLL5A4lcri/koO4kVh6iykeyqn4iKMkTaY1LVSs0gwEl9DJOigy8q8Q
         WPtHpYV0+uIe6amcTjkQLuADzSGPUx4rs/QmPrhO0WC+aS/VPjA8tDxGnOE6xkLGpQLv
         lTimTCE/K9U0RF4C039OIDi0j2iIowkJYeW6TPrBZBYFSBCJ9uXp+uP1gTWL63kz/VIn
         F7pEhz3ucREkKYmQDI91cCQ4B4+VGr1SMl0Byq8KA2sUVL6ZDahv6K/J2fUilePUK8ER
         3UWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XATsmiiQ65kT4ODqJ8G67gOZ75F3gzeYi1y9XLQaIlM=;
        b=p+QIgNfrrsiM28r2O3rVCGKmbE8jwV4LZVi5C91PeN6U7DrVCp6FSeNSeUkQyRIGUW
         la3osIvfA49lSC/hCk/T+IlOqcVBJhuqqfdLwqORivk9FU7cOTW9P4FoZI2mftrxqlqG
         d7Rq2FKbBupisaozp3cMd3lUInOvpXyxukReTWHyaQIK9JIDH4xmb64UmdJnhAMJWccx
         kdMSL6XEzujQ9SOa+lClOzVl/ZpN23RXQWNWgjKFlwR4XGYmy0PaOIzjmRqRZh4vdPfO
         eA7YNSk3ZF5a1yv/ZuaFAtjCXOfU8Icod2X9Xx4LFhoKfMjRm9lmehW/bjK5a3ueYq2V
         rVCg==
X-Gm-Message-State: APjAAAW9NFyn8lghHI59dM5TaYuNSOF/pBnyYKhGX7T8Dn23q5yQ/P13
	qVl3IZRw/zuni/18JzD3bdvP5sDnnC9bc3BuV9Rpcw==
X-Google-Smtp-Source: APXvYqxbFqx52fMmsudugE6XC0yz5SmZysXaFv9YWU7egAQ4sBR35UABj4n5x4ayDTqcJ+9yTIIHMtatlqnJPxGnKEw=
X-Received: by 2002:a67:ed8b:: with SMTP id d11mr6025118vsp.104.1571418687239;
 Fri, 18 Oct 2019 10:11:27 -0700 (PDT)
MIME-Version: 1.0
References: <20191018161033.261971-1-samitolvanen@google.com>
 <20191018161033.261971-7-samitolvanen@google.com> <CAKwvOd=z3RxvJeNV1sBE=Y1b6HgXdnT4M9bwMrUNZcvcSOqwTw@mail.gmail.com>
In-Reply-To: <CAKwvOd=z3RxvJeNV1sBE=Y1b6HgXdnT4M9bwMrUNZcvcSOqwTw@mail.gmail.com>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 18 Oct 2019 10:11:16 -0700
Message-ID: <CABCJKud6+F=yhTo6xTXkHhtLWcSE99K=NcfKW_5E4swS4seKMw@mail.gmail.com>
Subject: Re: [PATCH 06/18] add support for Clang's Shadow Call Stack (SCS)
To: Nick Desaulniers <ndesaulniers@google.com>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Dave Martin <Dave.Martin@arm.com>, Kees Cook <keescook@chromium.org>, 
	Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>, 
	Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Oct 18, 2019 at 10:08 AM 'Nick Desaulniers' via Clang Built
Linux <clang-built-linux@googlegroups.com> wrote:
> > diff --git a/include/linux/compiler-clang.h b/include/linux/compiler-clang.h
> > index 333a6695a918..9af08391f205 100644
> > --- a/include/linux/compiler-clang.h
> > +++ b/include/linux/compiler-clang.h
> > @@ -42,3 +42,5 @@
> >   * compilers, like ICC.
> >   */
> >  #define barrier() __asm__ __volatile__("" : : : "memory")
> > +
> > +#define __noscs                __attribute__((no_sanitize("shadow-call-stack")))
>
> It looks like this attribute, (and thus a requirement to use this
> feature), didn't exist until Clang 7.0: https://godbolt.org/z/p9u1we
> (as noted above)
>
> I think it's better to put __noscs behind a __has_attribute guard in
> include/linux/compiler_attributes.h.  Otherwise, what will happen when
> Clang 6.0 sees __noscs, for example? (-Wunknown-sanitizers will
> happen).

Good point, I'll fix this in v2. Thanks.

Sami
