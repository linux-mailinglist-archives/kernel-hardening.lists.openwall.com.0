Return-Path: <kernel-hardening-return-16146-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 56780463B3
	for <lists+kernel-hardening@lfdr.de>; Fri, 14 Jun 2019 18:13:16 +0200 (CEST)
Received: (qmail 22007 invoked by uid 550); 14 Jun 2019 16:13:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 21964 invoked from network); 14 Jun 2019 16:13:09 -0000
Date: Fri, 14 Jun 2019 18:12:43 +0200
From: Denis 'GNUtoo' Carikli <GNUtoo@cyberdimension.org>
To: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>,
 Paul Kocialkowski <paul.kocialkowski@bootlin.com>, Kernel Hardening
 <kernel-hardening@lists.openwall.com>,
 linux-arm-kernel@lists.infradead.org, Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH] security: do not enable CONFIG_GCC_PLUGINS by default
Message-ID: <20190614181243.4430f0d4@primarylaptop.localdomain>
In-Reply-To: <CAG48ez30+VOj78rCiWMKtm0tHdVR67CcrHVCV-FFCfK-nRQTOw@mail.gmail.com>
References: <20190614145755.10926-1-GNUtoo@cyberdimension.org>
	<CAG48ez30+VOj78rCiWMKtm0tHdVR67CcrHVCV-FFCfK-nRQTOw@mail.gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; i686-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/eRFSdoapDA3WExTRXm6TK7t";
 protocol="application/pgp-signature"; micalg=pgp-sha256

--Sig_/eRFSdoapDA3WExTRXm6TK7t
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 14 Jun 2019 18:05:19 +0200
Jann Horn <jannh@google.com> wrote:

[...]
> STACKPROTECTOR_PER_TASK defaults to y and depends on GCC_PLUGINS, so
> is that perhaps what broke? Can you try whether disabling just that
> works for you?
I've tried that, and it's sufficient to make the device boot.

Denis.

--Sig_/eRFSdoapDA3WExTRXm6TK7t
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEeC+d2+Nrp/PU3kkGX138wUF34mMFAl0Dx3sACgkQX138wUF3
4mPiIRAAjxSgd1bWrHHohXd2qKq7auTlOOjw2UxuHT9++GucLfdr8BnQKr1xFpi1
gYlHqUUFtup0vmQ+xKeF/J8FBkqxcOTJPseGD7N0mPGMYU7On4t6dJgffpA8LZay
xLefS7qL9P/l8UQL9gK8hrdbLfEH0V+oo70y6v4cq0CCIqWaOFVovmE8+NlkxBtA
DNTJrytkwDgB8keaoIZXtl1j+hzS+GnmCM/Omp2//8nd1ipCatS5tbRssYX0l+zc
ESAnGwiZ0QCMH07afjEfGSAOWdNzWtn/ga1zRjSr+d+JbzyDFkRtALXhzhVCCpiu
0wqQBWzpf+jLEyQJWmJf1zdNMOJb5a0960d4J3Yne8IzcMvzBsrUnyFXa5aph/n2
XUvTakH5putFUYHUQxbpgsNL3ISIRF0gohwxWhQAQKaXr9r4GLMWowmQ9UT4MOAB
D4lPDeoqxRBDyqnQyUHwwF5xLIKRs4U7oZq2KEOouzp6yzKYA1HbIE7Tv8glgh7p
o3zTs/LV3+CTncgXhGBQSAOtnsBFjOAnpEfx99r0Lrrm4NyLPoYCQMC3WC7iNN61
lBo07Q0sHX2Uvuxo1Ef5FR8O1hT2dzffbS/6T883wlTASejQzd7QPlaqZo1v7xNz
JREgl5V18d9uXu7WC1bqILC4itXUwmQM8hjdoumu1la6kJOaXOk=
=qZz4
-----END PGP SIGNATURE-----

--Sig_/eRFSdoapDA3WExTRXm6TK7t--
