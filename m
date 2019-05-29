Return-Path: <kernel-hardening-return-16001-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6AD412E183
	for <lists+kernel-hardening@lfdr.de>; Wed, 29 May 2019 17:48:43 +0200 (CEST)
Received: (qmail 23985 invoked by uid 550); 29 May 2019 15:48:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23958 invoked from network); 29 May 2019 15:48:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F1v6CstyBUQQ32046WYaNZBkWpGqm4E3DdO+JI4/z6k=;
        b=Uq/T2YCZuyTQNQeIkxqsiz8hdWSnJDkKyyQY+hq8u6HlNCKLgz1UGBqkS+VFr95R4i
         x2rvmMoYddoQ+vV1xQYU2/hjtdTahw7iot+Iv/1ED+/r8NGBwKhwtxZU5JM87G4ru++z
         tls4WJ/aEKHR7SRCs7paDG7xfBirKUr1LqMqc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F1v6CstyBUQQ32046WYaNZBkWpGqm4E3DdO+JI4/z6k=;
        b=d5Wgg+Ajh4NhWXMsORBTqQ/W4CzIq8MxoPSC8TXwxk7gzkSlgbtPV8Q1hl7dQ16Bc3
         lVQhLhS0QYDzeKKqjKt9YgBoqLT4+HI9VhkShS2KDbZzyDUd+tmVBo9PlGXP3y7m5d9o
         sgViRSakeQ60RxYacR2jmemaejwyIZeAUxAl2xpgKC6NUL4hmXPZIbCiRiBFBZ+AMEUA
         J/7e+pCXoOW5Z2c21+HlEMQND42DXttMJ1Kerz555tvlGe0jgCrf3pOe+Z6KbI4vYlU2
         HDq39p0Wl6sbvwFVTdE612BNL9NVXHkAsKNC8JuB1CNHh6H6Z9zt6XEjhBCV3ndaLKQR
         ic4Q==
X-Gm-Message-State: APjAAAUcudT+LQ3jmjXKUtvk1XSja98SYfh5FC5v8O3kIgtmnEXt/Tzr
	J5edle0NDZ7Kb9LEVcue9Ge4zXbNfgc=
X-Google-Smtp-Source: APXvYqzxGMpGUfO/6BJfMKFVQoj/pJrqpm/Zasy9ynLjC5Zmps3gTrAI/78ljecsEtoltoRgg+P3jw==
X-Received: by 2002:a24:b303:: with SMTP id e3mr7295816itf.170.1559144902409;
        Wed, 29 May 2019 08:48:22 -0700 (PDT)
X-Received: by 2002:a02:b895:: with SMTP id p21mr89782634jam.80.1559144899977;
 Wed, 29 May 2019 08:48:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190520231948.49693-1-thgarnie@chromium.org> <20190520231948.49693-2-thgarnie@chromium.org>
 <20190521040634.GA32379@sol.localdomain> <CAJcbSZGekB9Uc8PUoSCND+ZaAN9V60uyVv1bBeBGDQ_pHxzVnw@mail.gmail.com>
 <20190522205524.GA183718@gmail.com>
In-Reply-To: <20190522205524.GA183718@gmail.com>
From: Thomas Garnier <thgarnie@chromium.org>
Date: Wed, 29 May 2019 08:48:08 -0700
X-Gmail-Original-Message-ID: <CAJcbSZFnHk1uh3kz4+mcyExwjR+p445p4FSnZbskFKKhgy0qVw@mail.gmail.com>
Message-ID: <CAJcbSZFnHk1uh3kz4+mcyExwjR+p445p4FSnZbskFKKhgy0qVw@mail.gmail.com>
Subject: Re: [PATCH v7 01/12] x86/crypto: Adapt assembly for PIE support
To: Eric Biggers <ebiggers@kernel.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Kristen Carlson Accardi <kristen@linux.intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, "the arch/x86 maintainers" <x86@kernel.org>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, May 22, 2019 at 1:55 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, May 22, 2019 at 01:47:07PM -0700, Thomas Garnier wrote:
> > On Mon, May 20, 2019 at 9:06 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > On Mon, May 20, 2019 at 04:19:26PM -0700, Thomas Garnier wrote:
> > > > diff --git a/arch/x86/crypto/sha256-avx2-asm.S b/arch/x86/crypto/sha256-avx2-asm.S
> > > > index 1420db15dcdd..2ced4b2f6c76 100644
> > > > --- a/arch/x86/crypto/sha256-avx2-asm.S
> > > > +++ b/arch/x86/crypto/sha256-avx2-asm.S
> > > > @@ -588,37 +588,42 @@ last_block_enter:
> > > >       mov     INP, _INP(%rsp)
> > > >
> > > >       ## schedule 48 input dwords, by doing 3 rounds of 12 each
> > > > -     xor     SRND, SRND
> > > > +     leaq    K256(%rip), SRND
> > > > +     ## loop1 upper bound
> > > > +     leaq    K256+3*4*32(%rip), INP
> > > >
> > > >  .align 16
> > > >  loop1:
> > > > -     vpaddd  K256+0*32(SRND), X0, XFER
> > > > +     vpaddd  0*32(SRND), X0, XFER
> > > >       vmovdqa XFER, 0*32+_XFER(%rsp, SRND)
> > > >       FOUR_ROUNDS_AND_SCHED   _XFER + 0*32
> > > >
> > > > -     vpaddd  K256+1*32(SRND), X0, XFER
> > > > +     vpaddd  1*32(SRND), X0, XFER
> > > >       vmovdqa XFER, 1*32+_XFER(%rsp, SRND)
> > > >       FOUR_ROUNDS_AND_SCHED   _XFER + 1*32
> > > >
> > > > -     vpaddd  K256+2*32(SRND), X0, XFER
> > > > +     vpaddd  2*32(SRND), X0, XFER
> > > >       vmovdqa XFER, 2*32+_XFER(%rsp, SRND)
> > > >       FOUR_ROUNDS_AND_SCHED   _XFER + 2*32
> > > >
> > > > -     vpaddd  K256+3*32(SRND), X0, XFER
> > > > +     vpaddd  3*32(SRND), X0, XFER
> > > >       vmovdqa XFER, 3*32+_XFER(%rsp, SRND)
> > > >       FOUR_ROUNDS_AND_SCHED   _XFER + 3*32
> > > >
> > > >       add     $4*32, SRND
> > > > -     cmp     $3*4*32, SRND
> > > > +     cmp     INP, SRND
> > > >       jb      loop1
> > > >
> > > > +     ## loop2 upper bound
> > > > +     leaq    K256+4*4*32(%rip), INP
> > > > +
> > > >  loop2:
> > > >       ## Do last 16 rounds with no scheduling
> > > > -     vpaddd  K256+0*32(SRND), X0, XFER
> > > > +     vpaddd  0*32(SRND), X0, XFER
> > > >       vmovdqa XFER, 0*32+_XFER(%rsp, SRND)
> > > >       DO_4ROUNDS      _XFER + 0*32
> > > >
> > > > -     vpaddd  K256+1*32(SRND), X1, XFER
> > > > +     vpaddd  1*32(SRND), X1, XFER
> > > >       vmovdqa XFER, 1*32+_XFER(%rsp, SRND)
> > > >       DO_4ROUNDS      _XFER + 1*32
> > > >       add     $2*32, SRND
> > > > @@ -626,7 +631,7 @@ loop2:
> > > >       vmovdqa X2, X0
> > > >       vmovdqa X3, X1
> > > >
> > > > -     cmp     $4*4*32, SRND
> > > > +     cmp     INP, SRND
> > > >       jb      loop2
> > > >
> > > >       mov     _CTX(%rsp), CTX
> > >
> > > There is a crash in sha256-avx2-asm.S with this patch applied.  Looks like the
> > > %rsi register is being used for two different things at the same time: 'INP' and
> > > 'y3'?  You should be able to reproduce by booting a kernel configured with:
> > >
> > >         CONFIG_CRYPTO_SHA256_SSSE3=y
> > >         # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> >
> > Thanks for testing the patch. I couldn't reproduce this crash, can you
> > share the whole .config or share any other specifics of your testing
> > setup?
> >
>
> I attached the .config I used.  It reproduces on v5.2-rc1 with just this patch
> applied.  The machine you're using does have AVX2 support, right?  If you're
> using QEMU, did you make sure to pass '-cpu host'?

Thanks for your help offline on this Eric. I was able to repro the
issue and fix it, it will be part of the next iteration. You were
right that esi was used later on, I simplified the code in this
context and ran more testing on all CONFIG_CRYPTO_* options.

>
> - Eric
