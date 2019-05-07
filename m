Return-Path: <kernel-hardening-return-15894-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9A17616CD4
	for <lists+kernel-hardening@lfdr.de>; Tue,  7 May 2019 23:08:25 +0200 (CEST)
Received: (qmail 9514 invoked by uid 550); 7 May 2019 21:08:18 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9492 invoked from network); 7 May 2019 21:08:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NyT42HhZo+NoWlMcFfVHa74AFNvsodijHlMncKg590Q=;
        b=YehQViZvLM7Lmr9d7H2oBVwOnhxc/W7ZGb3C0R7fmfvEgavSj8wr0dWjHPOIOGCXVB
         ++EpCbZEDhD0i+6YXXoX1RK3f89W5kHuFQztGG9LtdCwHB6ZKLxVsTYZOa3dSuXWWfxY
         9ZMhyvs5cRAiCyhMUyX4IsaE2+u2EYpSjxKnk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NyT42HhZo+NoWlMcFfVHa74AFNvsodijHlMncKg590Q=;
        b=q1AF2/GaZ02aFYU2vaMwIXap5p1TdobFKZ1Ij6fNh1d+JjchiIputHJAcqXbEtLVXA
         v++eyuDeaMeluQ23XRW4lxxIH0PILfLrtAMAohlD3Lhm13xqmhrip0Fmarkl+NQ95ACP
         3FvCZKB/n7MgvfDJP2cp4wlS4odEWyuy1yP/br/B5HBJCCNje6JdWrb3f47sbv8Mx/P8
         LvJq1wWgJlwsI1p7Y+YP9dnHzmQYvODjxRX4wenOxGzq7e5cydEykNN38I7m+Mc09mQh
         bfvkY1pPS1fwGEF7NephxdTVxJXP0yQ2Xu43dqiTCSarG9eIwA0wTpmXbFpsTE7Lbwix
         XnCQ==
X-Gm-Message-State: APjAAAUuakXKoMPZNCtU8lbTzn9j5PFby1FQlzAuAm8647sKvNVXYOXo
	xfCNVfQxZpBUF11E2ifkRBIpbtDTIfk=
X-Google-Smtp-Source: APXvYqxdL9/G2YWq1d3dVCjAqRn05/IFoAkYnJMo+8fbnPvfGELw5Aq9oO5KZ6Pp/0FtG9K5xFUWrQ==
X-Received: by 2002:a1f:96d3:: with SMTP id y202mr15080283vkd.6.1557263284754;
        Tue, 07 May 2019 14:08:04 -0700 (PDT)
X-Received: by 2002:a67:dd95:: with SMTP id i21mr13304046vsk.48.1557263282871;
 Tue, 07 May 2019 14:08:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190507161321.34611-1-keescook@chromium.org> <20190507170039.GB1399@sol.localdomain>
In-Reply-To: <20190507170039.GB1399@sol.localdomain>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 7 May 2019 14:07:51 -0700
X-Gmail-Original-Message-ID: <CAGXu5jL7pWWXuJMinghn+3GjQLLBYguEtwNdZSQy++XGpGtsHQ@mail.gmail.com>
Message-ID: <CAGXu5jL7pWWXuJMinghn+3GjQLLBYguEtwNdZSQy++XGpGtsHQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] crypto: x86: Fix indirect function call casts
To: Eric Biggers <ebiggers@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Joao Moreira <jmoreira@suse.de>, 
	Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, 
	X86 ML <x86@kernel.org>, linux-crypto <linux-crypto@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, May 7, 2019 at 10:00 AM Eric Biggers <ebiggers@kernel.org> wrote:
> > Given the above, the current efforts to improve the Linux security,
> > and the upcoming kernel support to compilers with CFI features, this
> > creates macros to be used to build the needed function definitions,
> > to be used in camellia, cast6, serpent, twofish, and aesni.
>
> So why not change the function prototypes to be compatible with common_glue_*_t
> instead, rather than wrapping them with another layer of functions?  Is it
> because indirect calls into asm code won't be allowed with CFI?

I don't know why they're not that way to begin with. But given that
the casting was already happening, this is just moving it to a place
where CFI won't be angry. :)

> >   crypto: x86/crypto: Use new glue function macros
>
> This one should be "x86/serpent", not "x86/crypto".

Oops, yes, that's my typo. I'll fix for v4. Do the conversions
themselves look okay (the changes are pretty mechanical)? If so,
Herbert, do you want a v4 with the typo fix, or do you want to fix
that up yourself?

Thanks!

-- 
Kees Cook
