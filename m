Return-Path: <kernel-hardening-return-19970-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D62F5275B74
	for <lists+kernel-hardening@lfdr.de>; Wed, 23 Sep 2020 17:18:56 +0200 (CEST)
Received: (qmail 28287 invoked by uid 550); 23 Sep 2020 15:18:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28246 invoked from network); 23 Sep 2020 15:18:49 -0000
Date: Wed, 23 Sep 2020 17:18:35 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Solar Designer <solar@openwall.com>
Cc: madvenka@linux.microsoft.com, kernel-hardening@lists.openwall.com,
	linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
	oleg@redhat.com, x86@kernel.org, luto@kernel.org,
	David.Laight@ACULAB.COM, fweimer@redhat.com, mark.rutland@arm.com,
	mic@digikod.net, Rich Felker <dalias@libc.org>
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
Message-ID: <20200923151835.GA32555@duo.ucw.cz>
References: <20200922215326.4603-1-madvenka@linux.microsoft.com>
 <20200923081426.GA30279@amd>
 <20200923091456.GA6177@openwall.com>
 <20200923141102.GA7142@openwall.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fUYQa+Pmc3FrFX/N"
Content-Disposition: inline
In-Reply-To: <20200923141102.GA7142@openwall.com>
User-Agent: Mutt/1.10.1 (2018-07-13)


--fUYQa+Pmc3FrFX/N
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > > > The W^X implementation today is not complete. There exist many user=
 level
> > > > tricks that can be used to load and execute dynamic code. E.g.,
> > > >=20
> > > > - Load the code into a file and map the file with R-X.
> > > >=20
> > > > - Load the code in an RW- page. Change the permissions to R--. Then,
> > > >   change the permissions to R-X.
> > > >=20
> > > > - Load the code in an RW- page. Remap the page with R-X to get a se=
parate
> > > >   mapping to the same underlying physical page.
> > > >=20
> > > > IMO, these are all security holes as an attacker can exploit them t=
o inject
> > > > his own code.
> > >=20
> > > IMO, you are smoking crack^H^H very seriously misunderstanding what
> > > W^X is supposed to protect from.
> > >=20
> > > W^X is not supposed to protect you from attackers that can already do
> > > system calls. So loading code into a file then mapping the file as R-X
> > > is in no way security hole in W^X.
> > >=20
> > > If you want to provide protection from attackers that _can_ do system
> > > calls, fine, but please don't talk about W^X and please specify what
> > > types of attacks you want to prevent and why that's good thing.
> >=20
> > On one hand, Pavel is absolutely right.  It is ridiculous to say that
> > "these are all security holes as an attacker can exploit them to inject
> > his own code."
>=20
> I stand corrected, due to Brad's tweet and follow-ups here:
>=20
> https://twitter.com/spendergrsec/status/1308728284390318082
>=20
> It sure does make sense to combine ret2libc/ROP to mprotect() with one's
> own injected shellcode.  Compared to doing everything from ROP, this is
> easier and more reliable across versions/builds if the desired
> payload

Ok, so this starts to be a bit confusing.

I thought W^X is to protect from attackers that have overflowed buffer
somewhere, but can not to do arbitrary syscalls, yet.

You are saying that there's important class of attackers that can do
some syscalls but not arbitrary ones.

I'd like to see definition of that attacker (and perhaps description
of the system the protection is expected to be useful on -- if it is
not close to common Linux distros).

Best regards,

									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--fUYQa+Pmc3FrFX/N
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX2tnSwAKCRAw5/Bqldv6
8i65AKCaFokdFtwbykoqIQdSHvCvSHOLDQCdFG4dtfWtOuYiT5+Qq+ozWoM46eM=
=Ferp
-----END PGP SIGNATURE-----

--fUYQa+Pmc3FrFX/N--
