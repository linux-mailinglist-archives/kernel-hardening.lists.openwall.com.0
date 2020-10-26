Return-Path: <kernel-hardening-return-20276-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0176D2993C4
	for <lists+kernel-hardening@lfdr.de>; Mon, 26 Oct 2020 18:28:16 +0100 (CET)
Received: (qmail 5128 invoked by uid 550); 26 Oct 2020 17:28:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 28188 invoked from network); 26 Oct 2020 16:51:42 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603731089;
	bh=Xb2UwSkNcM9cbBM3zlY+jbuzH3M6a/pJtoQEPvBsp7k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n0OeLdOtic5bPMHrJNTDAZZk8om61ybbk/lRM2morVVr0p0gU5pxKpJ4ky+5XuUFC
	 Ueqjsz/CimTtIXrSzJ4EsJ+6cFUVL3htTzpmmNkqnHb/PeJeGrvVrRpv50GvRYw3O+
	 hsZProyK79R1Ngd6rjPchjVWWDcfW2JaFoFrTEA0=
Date: Mon, 26 Oct 2020 16:51:25 +0000
From: Mark Brown <broonie@kernel.org>
To: Dave Martin <Dave.Martin@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Topi Miettinen <toiwoton@gmail.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Salvatore Mesoraca <s.mesoraca16@gmail.com>,
	systemd-devel@lists.freedesktop.org,
	Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com,
	Will Deacon <will.deacon@arm.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Jeremy Linton <jeremy.linton@arm.com>,
	linux-hardening@vger.kernel.org, libc-alpha@sourceware.org,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
Subject: Re: BTI interaction between seccomp filters in systemd and glibc
 mprotect calls, causing service failures
Message-ID: <20201026165125.GF7402@sirena.org.uk>
References: <8584c14f-5c28-9d70-c054-7c78127d84ea@arm.com>
 <20201022075447.GO3819@arm.com>
 <78464155-f459-773f-d0ee-c5bdbeb39e5d@gmail.com>
 <202010221256.A4F95FD11@keescook>
 <20201023090232.GA25736@gaia>
 <cf655c11-d854-281a-17ae-262ddf0aaa08@gmail.com>
 <20201026145245.GD3117@gaia>
 <20201026155628.GA27285@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cpvLTH7QU4gwfq3S"
Content-Disposition: inline
In-Reply-To: <20201026155628.GA27285@arm.com>
X-Cookie: Safety Third.
User-Agent: Mutt/1.10.1 (2018-07-13)


--cpvLTH7QU4gwfq3S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 26, 2020 at 03:56:35PM +0000, Dave Martin wrote:
> On Mon, Oct 26, 2020 at 02:52:46PM +0000, Catalin Marinas via Libc-alpha wrote:

> > Now, if the dynamic loader silently ignores the mprotect() failure on
> > the main executable, is there much value in exposing a flag in the aux
> > vectors? It saves a few (one?) mprotect() calls but I don't think it
> > matters much. Anyway, I don't mind the flag.

> I don't see a problem with the aforementioned patch [2] to pre-set BTI
> on the pages of the main binary.

Me either FWIW.

--cpvLTH7QU4gwfq3S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAl+W/owACgkQJNaLcl1U
h9BOigf8CXtljKYe6CrS8pjN5GZ0G4Ck5VOuFDx7E+7wl6HjW0EnIfZJJ+R5GO4N
PgFC5QZ6B1Owa5cpdGcqRKoY17ZgkD6doR4DTvxdCUrquxRXYQIlOM9MtwGFhd1W
NzfCPYvUokn9d/y76Arklbzo+pFcrGI1Bo4y78S4mz6JOfsg1+8DQsyrPRqwIIbs
4xTXIyOfSsQph8bBbkR/BZdy+z40qGNDzw0YQRIwvIcxWDQM1+Tim5uAuZLuEe7M
V0giL+8RNDUFkBMCYwnlvtdnl/pUfcJ9QlWvSVJokUf3iWuDy1Gynj5Tau+/zzx0
Ch3k65pQs41XF6BKzS4lhttNnT6Rog==
=Rtx1
-----END PGP SIGNATURE-----

--cpvLTH7QU4gwfq3S--
