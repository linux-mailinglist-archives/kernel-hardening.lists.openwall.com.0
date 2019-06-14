Return-Path: <kernel-hardening-return-16145-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5114A4639C
	for <lists+kernel-hardening@lfdr.de>; Fri, 14 Jun 2019 18:06:06 +0200 (CEST)
Received: (qmail 12203 invoked by uid 550); 14 Jun 2019 16:05:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 12172 invoked from network); 14 Jun 2019 16:05:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Uc+JtWf7tjShWffGBpHhBR6sL8s2yKg1xyiiol0y6TU=;
        b=jNX16PwC7jFoacYJBbXHgDUaI8EEkt+toHx0bARDoPrn6Yb0mkvXjPVO3IkrWfqVjX
         SAgWyJGD7qe11HulyiUDTLWcoJYTRMtw/hRzJCW5H1y3BznhVaJyTk+EBh4SslWoqMu8
         uutE5qGiT6Mqq5/drcrwuzl6KYXez3+ZNfGbTu3Wc7tnftRgq42kcSXLdcW6oa+Gq5lF
         3keQDKiG0zVp9DX7m8humbrjMtrSbDbDD6L4zzDzgpQvjNy7Z4SyeMRYLF1USd5C34yW
         GT81fCt9qXkwZi4a8AUno2w8yKZfB2/tqeXJQgoF2OXOHaNudML8RtkEX+YuHtuYny5g
         yhsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Uc+JtWf7tjShWffGBpHhBR6sL8s2yKg1xyiiol0y6TU=;
        b=SaA0Rrmn0FvtSq8RQ1DWLg8A+6QCvBuzekh088XziIvULxQvEqviZTMOw37BnICsh9
         sKRT1w9v0+0213xhCV2uaSaGn9I9YviBQZ4EEKgsD9XL6UbjdESCkijS51uQb9MTz2b5
         UpXmBnB0i0zyZgZjw4+3izbMX70Ip0wAk5fXwh8XcBtWEi31Z/U/7mESAnfyglWA4+3P
         lK84lforqi23RzH0yYTRQ2RWwSl44YrPlwQf9quaXUDLpZ6VbjFl356fbzLAYtyGIqmk
         Amtp9iH/zLEvRf70mpTl8QKvhxblpfdy4xOhLxR2O/+1DvWRux9TtJfhYKw4E38RxgDD
         EFFw==
X-Gm-Message-State: APjAAAWy9D4OZfEW7TW8YT3qDj1rpiTStwZdlfhk+/ZEuXP5VDs3PFIQ
	Yvmt/xo3+LsdBEPS/tF0HB6dLIE+hj/dK5S5sArEKQ==
X-Google-Smtp-Source: APXvYqy1jMfHcpdvS7qiLT9q3NTNxL9C8ueJRGCVtvj+w2jRGYcmawLSzlsRzRHAUSICaj8u7FRJxJ+FX2xa32Ts36E=
X-Received: by 2002:aca:3dd7:: with SMTP id k206mr25745oia.47.1560528346412;
 Fri, 14 Jun 2019 09:05:46 -0700 (PDT)
MIME-Version: 1.0
References: <20190614145755.10926-1-GNUtoo@cyberdimension.org>
In-Reply-To: <20190614145755.10926-1-GNUtoo@cyberdimension.org>
From: Jann Horn <jannh@google.com>
Date: Fri, 14 Jun 2019 18:05:19 +0200
Message-ID: <CAG48ez30+VOj78rCiWMKtm0tHdVR67CcrHVCV-FFCfK-nRQTOw@mail.gmail.com>
Subject: Re: [PATCH] security: do not enable CONFIG_GCC_PLUGINS by default
To: "Denis 'GNUtoo' Carikli" <GNUtoo@cyberdimension.org>
Cc: Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, 
	Paul Kocialkowski <paul.kocialkowski@bootlin.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-arm-kernel@lists.infradead.org, 
	Russell King <linux@armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

+32-bit ARM folks

On Fri, Jun 14, 2019 at 5:10 PM Denis 'GNUtoo' Carikli
<GNUtoo@cyberdimension.org> wrote:
> On a Galaxy SIII (I9300), the patch mentioned below broke boot:
> - The display still had the bootloader logo, while with this
>   patch, the 4 Tux logo appears.
> - No print appeared on the serial port anymore after the kernel
>   was loaded, whereas with this patch, we have the serial
>   console working, and the device booting.
>
> Booting was broken by the following commit:
>   9f671e58159a ("security: Create "kernel hardening" config area")
>
> As the bootloader of this device enables the MMU, I had the following
> patch applied during the tests:
>   Author: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
>   Date:   Fri Nov 30 17:05:40 2012 -0800
>
>       ANDROID: arm: decompressor: Flush tlb before swiching domain 0 to c=
lient mode
>
>       If the bootloader used a page table that is incompatible with domai=
n 0
>       in client mode, and boots with the mmu on, then swithing domain 0 t=
o
>       client mode causes a fault if we don't flush the tlb after updating
>       the page table pointer.
>
>       v2: Add ISB before loading dacr.
>
>   diff --git a/arch/arm/boot/compressed/head.S b/arch/arm/boot/compressed=
/head.S
>   index 7135820f76d4..6e87ceda3b29 100644
>   --- a/arch/arm/boot/compressed/head.S
>   +++ b/arch/arm/boot/compressed/head.S
>   @@ -837,6 +837,8 @@ __armv7_mmu_cache_on:
>                   bic     r6, r6, #1 << 31        @ 32-bit translation sy=
stem
>                   bic     r6, r6, #(7 << 0) | (1 << 4)    @ use only ttbr=
0
>                   mcrne   p15, 0, r3, c2, c0, 0   @ load page table point=
er
>   +               mcrne   p15, 0, r0, c8, c7, 0   @ flush I,D TLBs
>   +               mcr     p15, 0, r0, c7, c5, 4   @ ISB
>                   mcrne   p15, 0, r1, c3, c0, 0   @ load domain access co=
ntrol
>                   mcrne   p15, 0, r6, c2, c0, 2   @ load ttb control
>    #endif
>
> Signed-off-by: Denis 'GNUtoo' Carikli <GNUtoo@cyberdimension.org>
> ---
>  scripts/gcc-plugins/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/scripts/gcc-plugins/Kconfig b/scripts/gcc-plugins/Kconfig
> index e9c677a53c74..afa1db3d3471 100644
> --- a/scripts/gcc-plugins/Kconfig
> +++ b/scripts/gcc-plugins/Kconfig
> @@ -18,7 +18,6 @@ config GCC_PLUGINS
>         bool
>         depends on HAVE_GCC_PLUGINS
>         depends on PLUGIN_HOSTCC !=3D ""
> -       default y
>         help
>           GCC plugins are loadable modules that provide extra features to=
 the
>           compiler. They are useful for runtime instrumentation and stati=
c analysis.

I don't think GCC_PLUGINS alone is supposed to generate any code? It
just makes it possible to enable a bunch of other kconfig flags that
can generate code.

STACKPROTECTOR_PER_TASK defaults to y and depends on GCC_PLUGINS, so
is that perhaps what broke? Can you try whether disabling just that
works for you?

My guess is that maybe there is some early boot code that needs to
have the stack protector disabled, or something like that.
