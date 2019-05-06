Return-Path: <kernel-hardening-return-15882-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id EC292155D4
	for <lists+kernel-hardening@lfdr.de>; Mon,  6 May 2019 23:54:52 +0200 (CEST)
Received: (qmail 9963 invoked by uid 550); 6 May 2019 21:54:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9942 invoked from network); 6 May 2019 21:54:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q8k4deF6LUSg0XMhZjIJsMDswCGChCG8LHJ6aCWS2+c=;
        b=Ccmwmu4KNXWaEjBHmOG8b3/Kt1J4Hyn+xX+ENKhZtIRrAZ25NJeBgAX99FQpDkzSQR
         Di1Vlgs8raV+O31O3C/y+HHwzVHNkMhOeXy1aZVu7yst0FzKfuH93SE3fxCGrHUMmMSf
         RXC9W7RvHmGAn0XChsIbR/1xqUtoRDv6gJcNA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q8k4deF6LUSg0XMhZjIJsMDswCGChCG8LHJ6aCWS2+c=;
        b=d6KeXZp8YWAn0UswjJEei2xotFeHG9s1uENdRUh1dkez5OBZdNAN9BaCzk6zT21TQC
         gVzi7F6daFqrnKKAMpUOaSQnNPCmBH/uH2BHMl6QcX4hjrJj/LM75Zpjx3+YjfAHNJcz
         EPzaSrU5k9TDWvWAJAmHiiRHFYtJkF+SboEB3nkFtZ3iRIAmudytYlgk9BJFlbIax998
         h4wdQQm25W3j+G/TfN+fvsd2qTCfgh4RU7hNDh82g9HB5SPJDBysRjmco6s/HfychQoM
         F+iSKTE7e7yV4x/TeKHmPlKoKLWEPOVg9HKrQzWuxx2OQqiTtusP/izBp/2f2VOowBp1
         rBxg==
X-Gm-Message-State: APjAAAW/FU/LPBAejlJ9wZ8+94NTgvEV0ZRRQKyGq9skk2OpwpFp9+OT
	yx60QUel/3+bO9+GcHdUQS+4RZvBsIQ=
X-Google-Smtp-Source: APXvYqzP1zyqXuIiQZK+Lq8ZaDxsxACgbmc7H+TbyyMqiDFDDvkR2ZiX63wAQ4we1WuN/gk/3lJ27w==
X-Received: by 2002:ab0:6419:: with SMTP id x25mr14262853uao.86.1557179672197;
        Mon, 06 May 2019 14:54:32 -0700 (PDT)
X-Received: by 2002:a1f:6604:: with SMTP id a4mr4576099vkc.13.1557179670399;
 Mon, 06 May 2019 14:54:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190506191950.9521-1-jmoreira@suse.de>
In-Reply-To: <20190506191950.9521-1-jmoreira@suse.de>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 6 May 2019 14:54:19 -0700
X-Gmail-Original-Message-ID: <CAGXu5jJ40OaniqR+rwu2npRNM4hGjbZoReWF=vhE99hB1Dqbow@mail.gmail.com>
Message-ID: <CAGXu5jJ40OaniqR+rwu2npRNM4hGjbZoReWF=vhE99hB1Dqbow@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] x86/crypto: Fix crypto function casts
To: Joao Moreira <jmoreira@suse.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, May 6, 2019 at 12:20 PM Joao Moreira <jmoreira@suse.de> wrote:
> It is possible to indirectly invoke functions with prototypes that do not
> match those of the respectively used function pointers by using void types.
> This feature is frequently used as a way of relaxing function invocation,
> making it possible that different data structures are passed to different
> functions through the same pointer.
>
> Despite the benefits, this can lead to a situation where functions with a
> given prototype are invoked by pointers with a different prototype, what is
> undesirable as it may prevent the use of heuristics such as prototype
> matching-based Control-Flow Integrity, which can be used to prevent
> ROP-based attacks.
>
> One way of fixing this situation is through the use of helper functions
> with prototypes that match the one in the respective invoking pointer.
>
> Given the above, the current efforts to improve the Linux security, and the
> upcoming kernel support to compilers with CFI features, fix the prototype
> casting of x86/crypto algorithms camellia, cast6, serpent and twofish with
> the use of a macro that generates the helper function.
>
> This patch does not introduce semantic changes to the cryptographic
> algorithms, yet, if someone finds relevant, the affected algorithms were
> tested with the help of tcrypt.ko without any visible harm.

Awesome; thanks for working on this! I'm looking through the patches
now and pondering solutions to the RFC in twofish. I'll send notes in
a bit...

-- 
Kees Cook
