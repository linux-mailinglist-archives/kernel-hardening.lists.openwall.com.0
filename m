Return-Path: <kernel-hardening-return-16175-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D28DF4988F
	for <lists+kernel-hardening@lfdr.de>; Tue, 18 Jun 2019 07:08:00 +0200 (CEST)
Received: (qmail 7637 invoked by uid 550); 18 Jun 2019 05:07:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7608 invoked from network); 18 Jun 2019 05:07:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jnbiF6PM75BR23D0fug4o/KmiVF/a7iA4ZJbUbk0ou8=;
        b=le3JAsoW0dSW819/UcwrgN8EH4ftLCyDsaZAgc7BOsWEPsmUX0qr3b1uAwcH5U9Ht1
         rYLqymUfXJnabzvyyX1WX3d/KTwGSvrT8fnKeDa6nGKyqmaAbpptt0uOXdARKhOgLrZp
         er1miUtYnUqo/19kfQnQOzsv/7Dso4BiTuyW0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jnbiF6PM75BR23D0fug4o/KmiVF/a7iA4ZJbUbk0ou8=;
        b=d1ZTK0eUGjPG4TdxzV/qg6tBGUIHd2ctrg0WszPp8PlEpJI+DsAVbleOth/FA/KkWo
         nB81q82dgeK5XeaBCt6wMWrhVeK+SaQfyb65T5Ey/EVgCxYgk7d9dx60HBgkCkrCG2OP
         MBaMFvA59hv3hDM9+PYT47qTjh6NoKUUYdkqcFx3Y5sZXpkZ2h1Qt5mAYiMgDhYN7yY3
         7UAcqSusAh8XWTaPFa6GM/wXl9riKL7IJdOTj+1jQ5EgsfaT1Vi3RgDKDG3m56OylTGh
         b93kSsVH0kEWU++1hKIMenr0UfZZaHOW6JUcjKTu8yS+XojiYOultqUzJW05hV4vv3c7
         pBuQ==
X-Gm-Message-State: APjAAAX5VMq4tmjKzmY9alWm5Yn12G6lXJqOw1be6OYhahWIK+f/r16o
	YnFr0+SreM8FJQmRg1ZEMwruhz/IXGMeYg==
X-Google-Smtp-Source: APXvYqzorbbiv4F/V5ltmPIt8/jvpUkr2OK7EJlOoHFOkJ7aNwm7NJJnDee7dkk++naciFbEgk4+6w==
X-Received: by 2002:a17:902:704a:: with SMTP id h10mr4439628plt.337.1560834463257;
        Mon, 17 Jun 2019 22:07:43 -0700 (PDT)
Date: Mon, 17 Jun 2019 22:07:41 -0700
From: Kees Cook <keescook@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>,
	Christoph Lameter <cl@linux.com>,
	Masahiro Yamada <yamada.masahiro@socionext.com>,
	Michal Hocko <mhocko@kernel.org>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Kostya Serebryany <kcc@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Sandeep Patil <sspatil@android.com>,
	Laura Abbott <labbott@redhat.com>,
	Randy Dunlap <rdunlap@infradead.org>, Jann Horn <jannh@google.com>,
	Mark Rutland <mark.rutland@arm.com>, Marco Elver <elver@google.com>,
	linux-mm@kvack.org, linux-security-module@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v7 1/2] mm: security: introduce init_on_alloc=1 and
 init_on_free=1 boot options
Message-ID: <201906172157.8E88196@keescook>
References: <20190617151050.92663-1-glider@google.com>
 <20190617151050.92663-2-glider@google.com>
 <20190617151027.6422016d74a7dc4c7a562fc6@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190617151027.6422016d74a7dc4c7a562fc6@linux-foundation.org>

On Mon, Jun 17, 2019 at 03:10:27PM -0700, Andrew Morton wrote:
> On Mon, 17 Jun 2019 17:10:49 +0200 Alexander Potapenko <glider@google.com> wrote:
> 
> > Slowdown for the new features compared to init_on_free=0,
> > init_on_alloc=0:
> > 
> > hackbench, init_on_free=1:  +7.62% sys time (st.err 0.74%)
> > hackbench, init_on_alloc=1: +7.75% sys time (st.err 2.14%)
> 
> Sanity check time.  Is anyone really going to use this?  Seriously,
> honestly, for real?  If "yes" then how did we determine that?

Absolutely! This is expected to be on-by-default on Android and Chrome
OS. And it gives the opportunity for anyone else to use it under distros
too via the boot args. (The init_on_free feature is regularly requested
by folks where memory forensics is included in their thread models.)

As for the performance implications, the request during review was to
do that separately.

> Also, a bit of a nit: "init_on_alloc" and "init_on_free" aren't very
> well chosen names for the boot options - they could refer to any kernel
> object at all, really.  init_pages_on_alloc would be better?  I don't think
> this matters much - the boot options are already chaotic.  But still...

I agree; it's awkward. It covers both the page allocator and the slab
allocator, though, so naming it "page" seems not great. It's part of
a larger effort to auto-initialize all memory (stack auto-init has
been around in a few forms with the Clang support now in Linus's tree
for v5.2), and the feature has kind of ended up with the short name
of "meminit". As this is the "heap" side of "meminit", what about
"meminit.alloc=..." and "meminit.free=..." as alternative straw-men?

-- 
Kees Cook
