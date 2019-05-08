Return-Path: <kernel-hardening-return-15902-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C23651803E
	for <lists+kernel-hardening@lfdr.de>; Wed,  8 May 2019 21:09:38 +0200 (CEST)
Received: (qmail 3502 invoked by uid 550); 8 May 2019 19:09:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3480 invoked from network); 8 May 2019 19:09:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dX9oXO6R8RSoriR7UuMavFbYp9KwYJM8lFYFBoOuLJY=;
        b=m92uaGS7BzxI1wVpXXvaee5KcFPVbYEfR4QwuEzpRo01tnMlXnsfG1+9jSbDgVZcpc
         XNHNcYd8H5QtBO9qWK6wCVr9bpXIoXzsClBTyRoZZCbqfbL+fltIwZpitSG3qyPECNqE
         EJ6/PUuxsKSI0Z7dM32euMjjSJDl+Ux09evt4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dX9oXO6R8RSoriR7UuMavFbYp9KwYJM8lFYFBoOuLJY=;
        b=Dr+1NFG3p1OIQgg/5LKyZ6OHaZifohTIdQBVCFEfVzoF3hrekZrkNDpbsTdOU3Ot8p
         VOXpwQxs74UxI6sINfP68bSWaXVtLhDlsG4H5PSA6qwfDEDYr32Fm1sRxlPxT1MDfAFC
         LgriDkSdKC/kYyiD2nidqEwPldNxNJYnC2UM10/qhEoe5knH0ebN+QkH2r3sS36E0Yi7
         D7yzgIDhZpx2WTuCMputGhyupHKno7NgJQ1OSSaybhwfZnqCADo4IG73iPs9kK77BWDq
         h6K44m2Tqqi2nvPtDmpN9x8547VwVGxDYjYjDG0kebjuD6pLxbIBYcRPjOUXG5Z2eKD+
         ++QQ==
X-Gm-Message-State: APjAAAW5KVY2MUI94xmrthwwvJvNeKRfydgT5083Aq9aa4SEYdt3ZBER
	FLaXK/BIVu2uE5VDG8UoXJcYn9eASk8=
X-Google-Smtp-Source: APXvYqwND0AvV0WgE7+enx2TFgg0nX49NLWNF3A3YZHtBDAwwNBcgtx4Ksm3WHcWC/tJyXcxid1qOw==
X-Received: by 2002:a1f:302:: with SMTP id 2mr2056230vkd.90.1557342559443;
        Wed, 08 May 2019 12:09:19 -0700 (PDT)
X-Received: by 2002:a67:f849:: with SMTP id b9mr15808201vsp.188.1557342170854;
 Wed, 08 May 2019 12:02:50 -0700 (PDT)
MIME-Version: 1.0
References: <20190508153736.256401-1-glider@google.com> <20190508153736.256401-2-glider@google.com>
In-Reply-To: <20190508153736.256401-2-glider@google.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 8 May 2019 12:02:39 -0700
X-Gmail-Original-Message-ID: <CAGXu5jKfxYfRQS+CouYZc8-BMEWR1U3kwshu4892pM0pmmACGw@mail.gmail.com>
Message-ID: <CAGXu5jKfxYfRQS+CouYZc8-BMEWR1U3kwshu4892pM0pmmACGw@mail.gmail.com>
Subject: Re: [PATCH 1/4] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
To: Alexander Potapenko <glider@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, 
	Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, 
	Linux-MM <linux-mm@kvack.org>, 
	linux-security-module <linux-security-module@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Nick Desaulniers <ndesaulniers@google.com>, 
	Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>, 
	Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, May 8, 2019 at 8:38 AM Alexander Potapenko <glider@google.com> wrote:
> The new options are needed to prevent possible information leaks and
> make control-flow bugs that depend on uninitialized values more
> deterministic.

I like having this available on both alloc and free. This makes it
much more configurable for the end users who can adapt to their work
loads, etc.

> Linux build with -j12, init_on_free=1:  +24.42% sys time (st.err 0.52%)
> [...]
> Linux build with -j12, init_on_alloc=1: +0.57% sys time (st.err 0.40%)

Any idea why there is such a massive difference here? This seems to
high just for cache-locality effects of touching all the freed pages.

-- 
Kees Cook
