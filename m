Return-Path: <kernel-hardening-return-16550-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C0BA371510
	for <lists+kernel-hardening@lfdr.de>; Tue, 23 Jul 2019 11:26:48 +0200 (CEST)
Received: (qmail 1308 invoked by uid 550); 23 Jul 2019 09:26:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1272 invoked from network); 23 Jul 2019 09:26:40 -0000
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,298,1559545200"; 
   d="scan'208";a="344686884"
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
Thread-Index: AQHVPFiM9cWMTc5Km0imVXiG0lTtQKbWkWuAgAAC7gCAAUjQQA==
Date: Tue, 23 Jul 2019 09:26:23 +0000
Message-ID: <12356C813DFF6F479B608F81178A561587ABA9@BGSMSX101.gar.corp.intel.com>
References: <20190717043005.19627-1-nitin.r.gote@intel.com>
	 <201907221029.B0CBED4F@keescook>
 <28404b52d58efa0a3e85ce05ce0b210049ed6050.camel@perches.com>
In-Reply-To: <28404b52d58efa0a3e85ce05ce0b210049ed6050.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-version: 11.0.600.7
dlp-reaction: no-action
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiMjBhMDJiYjQtNTEzYy00MzQ5LTlkYTktNTRlZThhY2JhNjhlIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiOW9FcGxDcGpvbTJ1eHdcLzRvWURPVXdVWTZ4MDh4OXVpbkFrd2h1WGFjaDg5aUhRYmhJV1g0WkFaNVFJSUkxVTQifQ==
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0


> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Monday, July 22, 2019 11:11 PM
> To: Kees Cook <keescook@chromium.org>; Gote, Nitin R
> <nitin.r.gote@intel.com>
> Cc: corbet@lwn.net; akpm@linux-foundation.org; apw@canonical.com;
> linux-doc@vger.kernel.org; kernel-hardening@lists.openwall.com
> Subject: Re: [PATCH v5] Documentation/checkpatch: Prefer
> strscpy/strscpy_pad over strcpy/strlcpy/strncpy
>=20
> On Mon, 2019-07-22 at 10:30 -0700, Kees Cook wrote:
> > On Wed, Jul 17, 2019 at 10:00:05AM +0530, NitinGote wrote:
> > > From: Nitin Gote <nitin.r.gote@intel.com>
> > >
> > > Added check in checkpatch.pl to
> > > 1. Deprecate strcpy() in favor of strscpy().
> > > 2. Deprecate strlcpy() in favor of strscpy().
> > > 3. Deprecate strncpy() in favor of strscpy() or strscpy_pad().
> > >
> > > Updated strncpy() section in Documentation/process/deprecated.rst
> > > to cover strscpy_pad() case.
> > >
> > > Signed-off-by: Nitin Gote <nitin.r.gote@intel.com>
> >
> > Reviewed-by: Kees Cook <keescook@chromium.org>
> >
> > Joe, does this address your checkpatch concerns?
>=20
> Well, kinda.
>=20
> strscpy_pad isn't used anywhere in the kernel.
>=20
> And
>=20
> +        "strncpy"				=3D> "strscpy, strscpy_pad or for non-
> NUL-terminated strings, strncpy() can still be used, but destinations sho=
uld
> be marked with __nonstring",
>=20
> is a bit verbose.  This could be simply:
>=20
> +        "strncpy" =3D> "strscpy - for non-NUL-terminated uses, strncpy()=
 dst
> should be __nonstring",
>=20

But, if the destination buffer needs extra NUL-padding for remaining size o=
f destination,=20
then safe replacement is strscpy_pad().  Right?  If yes, then what is your =
opinion on below change :

        "strncpy" =3D> "strscpy, strcpy_pad - for non-NUL-terminated uses, =
strncpy() dst
should be __nonstring",


> And I still prefer adding stracpy as it
> reduces code verbosity and eliminates defects.
>=20

-Nitin
