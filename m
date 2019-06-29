Return-Path: <kernel-hardening-return-16326-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0FC815AC79
	for <lists+kernel-hardening@lfdr.de>; Sat, 29 Jun 2019 18:16:07 +0200 (CEST)
Received: (qmail 32302 invoked by uid 550); 29 Jun 2019 16:16:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32243 invoked from network); 29 Jun 2019 16:16:00 -0000
Date: Sat, 29 Jun 2019 18:15:37 +0200
From: Stephen Kitt <steve@sk2.org>
To: Nitin Gote <nitin.r.gote@intel.com>
Cc: keescook@chromium.org, jannh@google.com,
 kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] checkpatch: Added warnings in favor of strscpy().
Message-ID: <20190629181537.7d524f7d@sk2.org>
In-Reply-To: <1561722948-28289-1-git-send-email-nitin.r.gote@intel.com>
References: <1561722948-28289-1-git-send-email-nitin.r.gote@intel.com>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
 boundary="Sig_/_cViOR74jii5Ku9ubhA07dL"; protocol="application/pgp-signature"

--Sig_/_cViOR74jii5Ku9ubhA07dL
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 28 Jun 2019 17:25:48 +0530, Nitin Gote <nitin.r.gote@intel.com> wro=
te:
> 1. Deprecate strcpy() in favor of strscpy().

This isn=E2=80=99t a comment =E2=80=9Cagainst=E2=80=9D this patch, but some=
thing I=E2=80=99ve been wondering
recently and which raises a question about how to handle strcpy=E2=80=99s d=
eprecation
in particular. There is still one scenario where strcpy is useful: when GCC
replaces it with its builtin, inline version...

Would it be worth introducing a macro for strcpy-from-constant-string, which
would check that GCC=E2=80=99s builtin is being used (when building with GC=
C), and
fall back to strscpy otherwise?

Regards,

Stephen

--Sig_/_cViOR74jii5Ku9ubhA07dL
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEnPVX/hPLkMoq7x0ggNMC9Yhtg5wFAl0XjqkACgkQgNMC9Yht
g5zF5BAAmickD5awGm9aYdq+oHUCHgQwYlHYOogKH00ehV8yp7i+y4EFC/SbJgQ1
Um85vZSsHfXP04Qn7Ppb2SnVTSsgRzHaZXS1WKeQEn6E31kNxye/Ddra/8ZS/kyN
LnRGk04HxktuD5rJY20JShrauUIIy5hIn9vnf90/VqAiTh/R4txnUu/c23dLW9OP
hdu8J2GwAxbp49WsrbqRh8O+eJ3quOJntk6uAOCt5qCe9sdDOnkAWJcdkC8yFrEX
irsorqhEgr9o0hcObRkCprQh3qNm/W9rPS0aP5SHhlG1N11N1JjtwEZdWTqlY2Re
SgcT23lhq8GdQVWLTNC4GI6sRs3UGjPrmwCuLWPJVRfMwrQkZx75eBMqY0BS/7OI
5NCuoye198NN/yPIESq1+6vt0ziunMU43WtvTyVvtdbyi4cKh7kfsQFu1VeB9aq2
uM39gBw7Ruf8uD7Lj83iKaWjWiFpM1Sj5PL8kC+CfLDdZFx7LuXNaZCe7G+99Tbw
l1aDC4Zd5a5/3pxqlmIqJJF9cpnjUIINB11VwWYkivKNw45WdqLcLBmGF86xee1B
yql6u99yh+U+R03hkn6njghrM2wXV4VBOLx4KCM5O/uuBcEhlH2/LrElvfmKAsDJ
+VKvHPdwlrqcNfl55kZiePuwDlLbDucmn5lSJ87j131/QM0ZOvc=
=VOH/
-----END PGP SIGNATURE-----

--Sig_/_cViOR74jii5Ku9ubhA07dL--
