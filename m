Return-Path: <kernel-hardening-return-16583-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id EE8BB74811
	for <lists+kernel-hardening@lfdr.de>; Thu, 25 Jul 2019 09:26:36 +0200 (CEST)
Received: (qmail 20268 invoked by uid 550); 25 Jul 2019 07:26:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 20230 invoked from network); 25 Jul 2019 07:26:30 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,306,1559545200"; 
   d="scan'208";a="369045294"
From: "Gote, Nitin R" <nitin.r.gote@intel.com>
To: Joe Perches <joe@perches.com>, Kees Cook <keescook@chromium.org>
CC: "corbet@lwn.net" <corbet@lwn.net>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "apw@canonical.com" <apw@canonical.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Subject: RE: [PATCH v5] Documentation/checkpatch: Prefer strscpy/strscpy_pad
 over strcpy/strlcpy/strncpy
Thread-Topic: [PATCH v5] Documentation/checkpatch: Prefer
 strscpy/strscpy_pad over strcpy/strlcpy/strncpy
Thread-Index: AQHVPFiM9cWMTc5Km0imVXiG0lTtQKbWkWuAgAAC7gCAAUjQQIACQMYQ//+ojoCAASyA8A==
Date: Thu, 25 Jul 2019 07:26:14 +0000
Message-ID: <12356C813DFF6F479B608F81178A561587AF87@BGSMSX101.gar.corp.intel.com>
References: <20190717043005.19627-1-nitin.r.gote@intel.com>
	 <201907221029.B0CBED4F@keescook>
	 <28404b52d58efa0a3e85ce05ce0b210049ed6050.camel@perches.com>
	 <12356C813DFF6F479B608F81178A561587ABA9@BGSMSX101.gar.corp.intel.com>
	 <12356C813DFF6F479B608F81178A561587AE45@BGSMSX101.gar.corp.intel.com>
 <0d69778626901a841108ae024b8a105da679d9af.camel@perches.com>
In-Reply-To: <0d69778626901a841108ae024b8a105da679d9af.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNjA2MmU2MDMtODE1OS00Y2ZlLTg1OTctYzBlYjYzZTY3ZmZjIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiT3lwQWZjNG1Mam05elRjRlwvNkdNaWFXTWRRMDBMZlBVZlpJZlVlK1hYRW1XNkZIUStFMzJTVXkrMUtkeFJ4c0MifQ==
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0


> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Wednesday, July 24, 2019 11:59 PM
> To: Gote, Nitin R <nitin.r.gote@intel.com>; Kees Cook
> <keescook@chromium.org>
> Cc: corbet@lwn.net; akpm@linux-foundation.org; apw@canonical.com;
> linux-doc@vger.kernel.org; kernel-hardening@lists.openwall.com
> Subject: Re: [PATCH v5] Documentation/checkpatch: Prefer
> strscpy/strscpy_pad over strcpy/strlcpy/strncpy
>=20
> On Wed, 2019-07-24 at 18:17 +0000, Gote, Nitin R wrote:
> > Hi,
>=20
> Hi again.
>=20
> []
> > > > > > 3. Deprecate strncpy() in favor of strscpy() or strscpy_pad().
>=20
> Please remember there does not exist a single actual use of strscpy_pad i=
n
> the kernel sources and no apparent real need for it.  I don't find one an=
yway.
>

Thanks for clarification. I will remove strscpy_pad() from patch.=20

> > Could you please give your opinion on below comment.
> >
> > > But, if the destination buffer needs extra NUL-padding for remaining
> > > size of destination, then safe replacement is strscpy_pad().  Right?
> > > If yes, then what is your opinion on below change :
> > >
> > >         "strncpy" =3D> "strscpy, strcpy_pad - for non-NUL-terminated
> > > uses,
> > > strncpy() dst should be __nonstring",
> > >
> > If you agree on this, then I will include this change in next patch ver=
sion.
>=20
> Two things:
>=20
> The kernel-doc documentation uses dest not dst.

Noted. I will correct this.

> I think stracpy should be preferred over strscpy.
>=20

Agreed.=20
I will use stracpy() instead of strscpy().

Thanks,
Nitin
 =20


