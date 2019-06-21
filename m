Return-Path: <kernel-hardening-return-16208-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 402D04E681
	for <lists+kernel-hardening@lfdr.de>; Fri, 21 Jun 2019 12:55:07 +0200 (CEST)
Received: (qmail 15973 invoked by uid 550); 21 Jun 2019 10:54:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15916 invoked from network); 21 Jun 2019 10:54:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bA6xn/f95JpkPY7v95rpxfkUmlaxqq25AxItIWbh9dw=;
        b=uGbYJSnct4eN5O7LoG6+oLmQzTQpXyGnM2JahjVpRoDvh5DiAul1stCYq2rJfBc/gm
         dtclCdep3JHlQfSzr9ZMCIA5hGyxmaekL37ULsf3Rp8GqHLxICAU3D4KAn51g4wLZ0J+
         U5LAs+TX/fA786/13GUjcCAFm4FA/QRMPpEHkVgL8RbrxAm6YRkJ69Q1yZDvDsqieRR6
         c8/xGpSasPsMw+TfD99WiAWkxQr0LwPSajkhawqF42O/i0zVk24n5B2KaKNj1lsg6DrK
         b664T/Skap8cwgrd7IkuPhmJZg68hgT9+1VOV9oggJ0Ig1LyTrqnSgIxgqRGckwpKC6G
         cuwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bA6xn/f95JpkPY7v95rpxfkUmlaxqq25AxItIWbh9dw=;
        b=RgQdaoZn3hr5HlsxjIEb0X+Aj+uujiyD+Dmdnuuf6nt9ONtSQBgT3NtUOw08O5qosB
         hGnBvKlyqChsvAgat4YhlCmNYTSOR+LSjhM1Tv4tbtwImEmT5SMiltTU3XAOh/6Na/kp
         q6maemuMBmqOKdycpxaY0o1SkQwo+UlQLfE6roapHThoVP5C1WR1/jUJNxc0Tr5ln2I6
         83b/EMkAEBJnMsr0nJE8/6TsenSS+pe/0uiAHKaBXhDRcBj3Gc2L63Zvqzh73q06s89c
         FQrwpsFEwtM83XrKbxVJdxip2MhlQ2yvySjDHhnNCOl1JUFz/VnpZg5MygeilJ8ecCap
         2tzQ==
X-Gm-Message-State: APjAAAXU/xFDdekoPmapZo+uf0AMeF++hC1ULkVl4fkG36oYEUkU0Y6q
	sOMAYf64CaN+mYil2JSLEWrNmv+HackjCdi81CI=
X-Google-Smtp-Source: APXvYqxd+3+TEYRI7qDr4YFRtfR1pmcYSlz4uYA2ZbkmyU7NvMlnvnVqUAHG7qzDoVhrU7v8h/LLcDK7HuLhULZte7k=
X-Received: by 2002:a17:90a:dd42:: with SMTP id u2mr5879605pjv.118.1561114485967;
 Fri, 21 Jun 2019 03:54:45 -0700 (PDT)
MIME-Version: 1.0
References: <CABgxDoLSzkVJ7Vh8mLiZySz6uS+VEu+GUxRqX8EWHKQDyz2fSg@mail.gmail.com>
 <201906200913.D2698BD0@keescook>
In-Reply-To: <201906200913.D2698BD0@keescook>
From: Romain Perier <romain.perier@gmail.com>
Date: Fri, 21 Jun 2019 12:54:34 +0200
Message-ID: <CABgxDoKQ4cnSS3p0sz8BgP65-R15U2Sr1AHVpU77ZGJu-Gvvvg@mail.gmail.com>
Subject: Re: Audit and fix all misuse of NLA_STRING: STATUS
To: Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi!

Yeah, I have found some inconsistencies, but I am not 100% sure for
all of these. I will double check and review the code closely.
I keep you in touch.

Regards,
Romain

Le jeu. 20 juin 2019 =C3=A0 18:15, Kees Cook <keescook@chromium.org> a =C3=
=A9crit :
>
> On Tue, Jun 18, 2019 at 07:56:42PM +0200, Romain Perier wrote:
> > Hi !
> >
> > Here a first review, you can get the complete list here:
> >
> > https://salsa.debian.org/rperier-guest/linux-tree/raw/next/STATUS
>
> Cool! You identified three issues:
>
> net/netfilter/nfnetlink_cthelper.c:
>         NF_CT_HELPER_NAME_LEN is used instead of NF_CT_EXP_POLICY_NAME_LE=
N
>
> net/netfilter/ipset/ip_set_list_set.c:
>         IPSET_ATTR_NAME and IPSET_ATTR_NAMEREF both have a len of
>         IPSET_MAXNAMELEN for a string of size IPSET_MAXNAMELEN
>
> net/openvswitch/conntrack.c:
>         maxlen of NF_CT_HELPER_NAME_LEN with a string of size
>         NF_CT_HELPER_NAME_LEN. maxlen of CTNL_TIMEOUT_NAME_MAX with a
>         string of size CTNL_TIMEOUT_NAME_MAX
>
> I haven't looked closely at this myself yet, but I think the next step
> would be to write patches for each of these. And while doing that, have
> an eye toward thinking about how each case could be made more robust in
> the future to avoid these kinds of flaws returning.
>
> Nice!
>
> --
> Kees Cook
