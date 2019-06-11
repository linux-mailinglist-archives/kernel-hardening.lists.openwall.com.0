Return-Path: <kernel-hardening-return-16103-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 79DE9421E6
	for <lists+kernel-hardening@lfdr.de>; Wed, 12 Jun 2019 12:01:53 +0200 (CEST)
Received: (qmail 25696 invoked by uid 550); 12 Jun 2019 10:01:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 11958 invoked from network); 11 Jun 2019 21:28:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dilger-ca.20150623.gappssmtp.com; s=20150623;
        h=from:message-id:mime-version:subject:date:in-reply-to:cc:to
         :references;
        bh=kHOmEXm44ofEStTL89clw86zKCfMK7pxZweKkVj60zc=;
        b=BNyH/I0aTFapdWvAUe1tA6vh4V7SGGnKW9i2iryYsCgfyNFoPcnfrRh6ENitI8pQJy
         ceJmUE14+hVNBM9WC+xAjbbK0ncjBtDNhZsREXS8wFJSFtJTAC+2kp/Gx/2pDb6cUMf8
         JpUjBxKEfOQvrL9m9kMePR3M4fWdfHCrRVaSTbbHZtX1SELIRUg9HXb/1sKatJNSwuF+
         QO1DomLI907tfm1bq218gSHTCncrOyxsRkBkmStrHKSsQYkjWyIsW3ZSK9J+lpNXxDiR
         oojDQ9O14TWNGl2rGOpuLibgYG5bNECymjz1Ygn5Bb6fBc1ArnndD5ref2xpl4j3WuJU
         Jxfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:message-id:mime-version:subject:date
         :in-reply-to:cc:to:references;
        bh=kHOmEXm44ofEStTL89clw86zKCfMK7pxZweKkVj60zc=;
        b=BP/gPBEZNsFfcJh724go8hIfA3lUXe8h7IBWbiTjkC8fJJZGmhlYraWbYOA0hOXwil
         tSCHYJg4MzKzl6U6l+mIyHA1mLI9nlAHORyKjSFRJ+JNi9/1dLZhIIs/BKNZWwnO7Fw0
         1RWAzSMDjhrORBLb5/dofwmgTEdBhnzKmaci9sEtbu7sTBaIma9yKI9yn8AgNhqNxvH7
         ok2y7worbRihO7SWmVFobkOT3gZBbgOOCqKL+GwMQXVBRvrIaOfl2QqEKw3gL61+8O0L
         i0g3P3aESUNrGJUvIz4zJiNaNlV+OzFv9h3HZKKF6QjODmndBoIHCoCBcxv0uGzvpdc0
         bZGw==
X-Gm-Message-State: APjAAAXc133hnT2Fc0GaU10rVlqgR1KPhlKF/qT3BZeCpgJV9xmeys34
	AfzpJVgx0gQ/9VZL5YKoj4lWcw==
X-Google-Smtp-Source: APXvYqx8fSWzb0HB5KPULCR4fAdvphiu+yCLRaPJ3mwALDMWZWEo99vzBDgf+T6A9kZ8B2J2ELLLxQ==
X-Received: by 2002:a17:90a:a505:: with SMTP id a5mr29364827pjq.27.1560288483342;
        Tue, 11 Jun 2019 14:28:03 -0700 (PDT)
From: Andreas Dilger <adilger@dilger.ca>
Message-Id: <315FEA4D-41B1-4C5B-89AA-7ABA93D66E0A@dilger.ca>
Content-Type: multipart/signed;
 boundary="Apple-Mail=_5B427BF6-3A60-46C7-A8F9-EE572E3F0487";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Subject: Re: [PATCH V2] include: linux: Regularise the use of FIELD_SIZEOF
 macro
Date: Tue, 11 Jun 2019 15:28:00 -0600
In-Reply-To: <20190611140907.899bebb12a3d731da24a9ad1@linux-foundation.org>
Cc: Shyam Saini <shyam.saini@amarulasolutions.com>,
 kernel-hardening@lists.openwall.com,
 linux-kernel@vger.kernel.org,
 keescook@chromium.org,
 linux-arm-kernel@lists.infradead.org,
 linux-mips@vger.kernel.org,
 intel-gvt-dev@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org,
 netdev@vger.kernel.org,
 linux-ext4 <linux-ext4@vger.kernel.org>,
 devel@lists.orangefs.org,
 linux-mm@kvack.org,
 linux-sctp@vger.kernel.org,
 bpf@vger.kernel.org,
 kvm@vger.kernel.org,
 mayhs11saini@gmail.com,
 Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
References: <20190611193836.2772-1-shyam.saini@amarulasolutions.com>
 <20190611134831.a60c11f4b691d14d04a87e29@linux-foundation.org>
 <6DCAE4F8-3BEC-45F2-A733-F4D15850B7F3@dilger.ca>
 <20190611140907.899bebb12a3d731da24a9ad1@linux-foundation.org>
X-Mailer: Apple Mail (2.3273)


--Apple-Mail=_5B427BF6-3A60-46C7-A8F9-EE572E3F0487
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii

On Jun 11, 2019, at 3:09 PM, Andrew Morton <akpm@linux-foundation.org> =
wrote:
>=20
> On Tue, 11 Jun 2019 15:00:10 -0600 Andreas Dilger <adilger@dilger.ca> =
wrote:
>=20
>>>> to FIELD_SIZEOF
>>>=20
>>> As Alexey has pointed out, C structs and unions don't have fields -
>>> they have members.  So this is an opportunity to switch everything =
to
>>> a new member_sizeof().
>>>=20
>>> What do people think of that and how does this impact the patch =
footprint?
>>=20
>> I did a check, and FIELD_SIZEOF() is used about 350x, while =
sizeof_field()
>> is about 30x, and SIZEOF_FIELD() is only about 5x.
>=20
> Erk.  Sorry, I should have grepped.
>=20
>> That said, I'm much more in favour of "sizeof_field()" or =
"sizeof_member()"
>> than FIELD_SIZEOF().  Not only does that better match "offsetof()", =
with
>> which it is closely related, but is also closer to the original =
"sizeof()".
>>=20
>> Since this is a rather trivial change, it can be split into a number =
of
>> patches to get approval/landing via subsystem maintainers, and there =
is no
>> huge urgency to remove the original macros until the users are gone.  =
It
>> would make sense to remove SIZEOF_FIELD() and sizeof_field() quickly =
so
>> they don't gain more users, and the remaining FIELD_SIZEOF() users =
can be
>> whittled away as the patches come through the maintainer trees.
>=20
> In that case I'd say let's live with FIELD_SIZEOF() and remove
> sizeof_field() and SIZEOF_FIELD().

The real question is whether we want to live with a sub-standard macro =
for
the next 20 years rather than taking the opportunity to clean it up now?

> I'm a bit surprised that the FIELD_SIZEOF() definition ends up in
> stddef.h rather than in kernel.h where such things are normally
> defined.  Why is that?

Cheers, Andreas






--Apple-Mail=_5B427BF6-3A60-46C7-A8F9-EE572E3F0487
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - http://gpgtools.org

iQIzBAEBCAAdFiEEDb73u6ZejP5ZMprvcqXauRfMH+AFAl0AHOAACgkQcqXauRfM
H+BPvRAAvxlKWQUZz2tRSIBu/vtfIKMWVyY8fctru8Y1oH+Slx4hWvJ/xxYWjMIa
LJJgybj3MjwTd30FmSWmmQmKDyjo5oWGelOeLzVfueI8blZIaDcUYT1rrM9h7F4G
RD22ST6XCWjj5oAmVBW/XHxRIFD6uHtwOnby9a4LgkFOehdkDBhopfAMduEZrW7P
qNa2T0M660SXtmt8dy89Ynb+sge7iinnRyPKkxNaweIXYGVtZzoScRFNK0vSZjbm
TgVIKwFyLDbdX1bJFQHZDWnfchCRqQrrmHyIl+wAGTccpfen4bGhDqW0wU1+rQpv
G2RL1z+N2WiWwKx/TmdPatglD2Hqr73jKfvi7X+DzkJ0nJdYMKnNRpe3S2rZwFjf
MHpmP35Ql2/96bDulYuirHOVvSrrXF/RXZLUp6MuTu2rGankXETXgiP0lkKcmOZW
gvA0pFTKFD8YaGf0NU9jS/OUOjYpqhMkBSK2C3d0UdRMCQzRWAudLzM9quRH7vCm
SfRD6QWHQfOELlKMenRptxYEi8IM3+3R4G1g3VmR7YCegpayslXiSKpgnBAqw4W0
Z4q6nJ/YOwNTjwzs9ndgCZfGpW6JxKYY0DuQe7ld+ngnXNdVrH1X5pZz9ASV9Wli
CowwSgwFlqOSkmcy52L7pRGDGSI/yWwzl6QHtjT8o0e30S27eCs=
=UFIV
-----END PGP SIGNATURE-----

--Apple-Mail=_5B427BF6-3A60-46C7-A8F9-EE572E3F0487--
