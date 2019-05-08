Return-Path: <kernel-hardening-return-15904-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E50BF1817C
	for <lists+kernel-hardening@lfdr.de>; Wed,  8 May 2019 23:08:59 +0200 (CEST)
Received: (qmail 1463 invoked by uid 550); 8 May 2019 21:08:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1442 invoked from network); 8 May 2019 21:08:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=85jAqiZ3rdqGfRvDGF/DUutEfAhFjbADqQZ1rKThcjI=;
        b=UwXq7RG5GbFeEc83Dhtk4yt40YEVN6o9JoBGv+9ERexPqq8oo2r5vW6MQbaxvQJruM
         qVzsMwdsJFIKh1gnJ1TchbHrGKlvv65iFVA+AjaqqHluvK1ywrlFGVWuNt/JOMxqwlQU
         IDVJi+FZd3XpMZTQkuqI4l6ltLywx1nG4LFLI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=85jAqiZ3rdqGfRvDGF/DUutEfAhFjbADqQZ1rKThcjI=;
        b=Oq9+28UaRedX8ndBvBYU8wGI52BxC/VzxnRiS/2EQrhtJ0IeaxUUR/Mu7HFocWbSae
         gJVHlu3u+ip4lskmPSdliVWoD7vv0VsdorVQkhwApvH9D1Bx3zD7V2kRXCnlIB9cS+gJ
         2J+/YbnKqszt+ALiFo1Vad0q59gZUZ3fzVV5E+eMX7lTSPOnwF7QrlL8OWhyLmnyRhAs
         KbCPNWgcFqVkgBuHjfTEKfykBj6OETjSfqAwMv+HyEXvZDHZ6VEXUv52/U5NYpCfLKpt
         rVZd58rqgXOcY6O7pA6FVT5XBk+1fCQXeNuhx2e2JohzkBnoUa3wQ1th34bOXRM+zvcs
         PpJw==
X-Gm-Message-State: APjAAAXwD3+P5tUq0uEgj0rPWI6w9Ve6o8rgM0yXrj+l5F9AqiOVM8j5
	bS8zsnl5qLHb/JyPYhC2VPFjdwnlhIw=
X-Google-Smtp-Source: APXvYqzgj2qo3m8w+pD9oq7DKHSxVK310HazeDnqhlQ+qbwe+Pq2q1tzBSQnL4m+bLsnfL7sxY3TXA==
X-Received: by 2002:a67:bd18:: with SMTP id y24mr251704vsq.36.1557349721291;
        Wed, 08 May 2019 14:08:41 -0700 (PDT)
X-Received: by 2002:a67:7c8a:: with SMTP id x132mr251877vsc.172.1557349719455;
 Wed, 08 May 2019 14:08:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190507161321.34611-1-keescook@chromium.org> <20190507170039.GB1399@sol.localdomain>
 <CAGXu5jL7pWWXuJMinghn+3GjQLLBYguEtwNdZSQy++XGpGtsHQ@mail.gmail.com>
 <20190507215045.GA7528@sol.localdomain> <20190508133606.nsrzthbad5kynavp@gondor.apana.org.au>
In-Reply-To: <20190508133606.nsrzthbad5kynavp@gondor.apana.org.au>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 8 May 2019 14:08:25 -0700
X-Gmail-Original-Message-ID: <CAGXu5jKdsuzX6KF74zAYw3PpEf8DExS9P0Y_iJrJVS+goHFbcA@mail.gmail.com>
Message-ID: <CAGXu5jKdsuzX6KF74zAYw3PpEf8DExS9P0Y_iJrJVS+goHFbcA@mail.gmail.com>
Subject: Re: [PATCH v3 0/7] crypto: x86: Fix indirect function call casts
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Eric Biggers <ebiggers@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Joao Moreira <jmoreira@suse.de>, Ingo Molnar <mingo@redhat.com>, 
	Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, X86 ML <x86@kernel.org>, 
	linux-crypto <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, May 8, 2019 at 6:36 AM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> On Tue, May 07, 2019 at 02:50:46PM -0700, Eric Biggers wrote:
> >
> > I don't know yet.  It's difficult to read the code with 2 layers of macros.
> >
> > Hence why I asked why you didn't just change the prototypes to be compatible.
>
> I agree.  Kees, since you're changing this anyway please make it
> look better not worse.

Do you mean I should use the typedefs in the new macros? I'm not aware
of a way to use a typedef to declare a function body, so I had to
repeat them. I'm open to suggestions!

As far as "fixing the prototypes", the API is agnostic of the context
type, and uses void *. And also it provides a way to call the same
function with different pointer types on the other arguments:

For example, quoting the existing code:

asmlinkage void twofish_dec_blk(struct twofish_ctx *ctx, u8 *dst,
                                const u8 *src);

Which is used for ecb and cbc:

#define GLUE_FUNC_CAST(fn) ((common_glue_func_t)(fn))
#define GLUE_CBC_FUNC_CAST(fn) ((common_glue_cbc_func_t)(fn))
...
static const struct common_glue_ctx twofish_dec = {
...
                .fn_u = { .ecb = GLUE_FUNC_CAST(twofish_dec_blk) }

static const struct common_glue_ctx twofish_dec_cbc = {
...
                .fn_u = { .cbc = GLUE_CBC_FUNC_CAST(twofish_dec_blk) }

which have different prototypes:

typedef void (*common_glue_func_t)(void *ctx, u8 *dst, const u8 *src);
typedef void (*common_glue_cbc_func_t)(void *ctx, u128 *dst, const u128 *src);
...
struct common_glue_func_entry {
        unsigned int num_blocks; /* number of blocks that @fn will process */
        union {
                common_glue_func_t ecb;
                common_glue_cbc_func_t cbc;
                common_glue_ctr_func_t ctr;
                common_glue_xts_func_t xts;
        } fn_u;
};

What CFI dislikes is calling a func(void *ctx, ...) when the actual
function is, for example, func(struct twofish_ctx *ctx, ...).

This needs to be fixed at the call site, not the static initializers,
and since the call site is void, there needs to be a static inline
that will satisfy the types.

I'm open to suggestions! :)

Thanks,

-- 
Kees Cook
