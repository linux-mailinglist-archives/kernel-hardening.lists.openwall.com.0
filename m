Return-Path: <kernel-hardening-return-16228-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E6A13554C6
	for <lists+kernel-hardening@lfdr.de>; Tue, 25 Jun 2019 18:44:12 +0200 (CEST)
Received: (qmail 25830 invoked by uid 550); 25 Jun 2019 16:43:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25728 invoked from network); 25 Jun 2019 16:43:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=YJ5KUR1dfyv4rmSUCZHkYKRX4GtcdsgVxRhZLAmM+D4=;
        b=omRUzgUbeRfiiY9zOgjk/BAEtzL0A9v+j/zRcn1e1Vbw/XcuiijMpQKq4bEiFON9+6
         6Z9SpuIxJCKZClD0xltP5ObmFl1ulNdJ+OfgMxoN6I8ATkeG/rZ1+KemQMKhNsXZ7XYE
         NLhmgkeh4Fobw87c9FVTJD6hr4CGsX/pzU71Vh1INAU9mvxwrz502Qrf8tx9GkAD8GUl
         oRpKAnOVUivXOabRkV3abBNbcNr2jkKUG/aQ5XtyewEORf1gpJmrL8P5CScoE1Srlo/4
         R/DKrI3xoarTwZo1h3qPqVdzzqk9zBaZ97ov8f9VlSAiBK0L0q7gsvAJMF9eAJMfSTDy
         xIEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=YJ5KUR1dfyv4rmSUCZHkYKRX4GtcdsgVxRhZLAmM+D4=;
        b=Ebor1nRNbqxD2ZQB3MzTFKPqKKxzOy9GWggAWVnAolrHucxGPhMZzG32lPMy/moz1z
         5qwLCW07s3OOgoUoDpfAPVPA1k1Z50y7HfjQHZJABXKWPyZQYeuKDMj+YE/zv6ISWyzk
         DTsGMg0YWXS2tmawuso1SYGgpSrv+JpCUO3e8okscjLt5Gc8vrs6kGSPJ0dON7FgLAAa
         RxuTm4Qp5U7vmKt2PJ3Hby4WAXEldwgtMXsNBSlkHwPeZe3qBh5zuUM4BFrOiFQ/ICd5
         /YbceowLOoUmfqKWbR2aeXs72lEthOeJkqmHBi5Us9yaJOj/Ou5XGCiF4MA/Myl4hlhK
         dIkQ==
X-Gm-Message-State: APjAAAWCvItaw1M0Pa+6q0s7tBzgkASiu13oBhc1d41DeuCSK+sqvp7R
	SeKzu5H7F5JsF/uT4UHnRtHrDSh6itKuzhwkk7c=
X-Google-Smtp-Source: APXvYqyrFgf07N5MXvo92RtuTmXRzmDHyMjVJnR7XQjpqpCg60w6uuAZ2YOzDgRlsVZuzvfz2LGfXlu9LfXM12Yd0zA=
X-Received: by 2002:a17:902:5c2:: with SMTP id f60mr154822345plf.61.1561480980480;
 Tue, 25 Jun 2019 09:43:00 -0700 (PDT)
MIME-Version: 1.0
References: <CABgxDoLSzkVJ7Vh8mLiZySz6uS+VEu+GUxRqX8EWHKQDyz2fSg@mail.gmail.com>
 <201906200913.D2698BD0@keescook> <CABgxDoKQ4cnSS3p0sz8BgP65-R15U2Sr1AHVpU77ZGJu-Gvvvg@mail.gmail.com>
In-Reply-To: <CABgxDoKQ4cnSS3p0sz8BgP65-R15U2Sr1AHVpU77ZGJu-Gvvvg@mail.gmail.com>
From: Romain Perier <romain.perier@gmail.com>
Date: Tue, 25 Jun 2019 18:42:48 +0200
Message-ID: <CABgxDoKTC1=5P=rnLmGzAgFs704+occs4Gw+6WyU99r4HwFBHA@mail.gmail.com>
Subject: Re: Audit and fix all misuse of NLA_STRING: STATUS
To: Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

I have double checked.

See, https://salsa.debian.org/rperier-guest/linux-tree/raw/next/STATUS

Nothing worrying, it seems.

Regards,
Romain

Le ven. 21 juin 2019 =C3=A0 12:54, Romain Perier <romain.perier@gmail.com> =
a =C3=A9crit :
>
> Hi!
>
> Yeah, I have found some inconsistencies, but I am not 100% sure for
> all of these. I will double check and review the code closely.
> I keep you in touch.
>
> Regards,
> Romain
>
> Le jeu. 20 juin 2019 =C3=A0 18:15, Kees Cook <keescook@chromium.org> a =
=C3=A9crit :
> >
> > On Tue, Jun 18, 2019 at 07:56:42PM +0200, Romain Perier wrote:
> > > Hi !
> > >
> > > Here a first review, you can get the complete list here:
> > >
> > > https://salsa.debian.org/rperier-guest/linux-tree/raw/next/STATUS
> >
> > Cool! You identified three issues:
> >
> > net/netfilter/nfnetlink_cthelper.c:
> >         NF_CT_HELPER_NAME_LEN is used instead of NF_CT_EXP_POLICY_NAME_=
LEN
> >
> > net/netfilter/ipset/ip_set_list_set.c:
> >         IPSET_ATTR_NAME and IPSET_ATTR_NAMEREF both have a len of
> >         IPSET_MAXNAMELEN for a string of size IPSET_MAXNAMELEN
> >
> > net/openvswitch/conntrack.c:
> >         maxlen of NF_CT_HELPER_NAME_LEN with a string of size
> >         NF_CT_HELPER_NAME_LEN. maxlen of CTNL_TIMEOUT_NAME_MAX with a
> >         string of size CTNL_TIMEOUT_NAME_MAX
> >
> > I haven't looked closely at this myself yet, but I think the next step
> > would be to write patches for each of these. And while doing that, have
> > an eye toward thinking about how each case could be made more robust in
> > the future to avoid these kinds of flaws returning.
> >
> > Nice!
> >
> > --
> > Kees Cook
