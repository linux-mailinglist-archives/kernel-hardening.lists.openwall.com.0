Return-Path: <kernel-hardening-return-16040-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6227F328AD
	for <lists+kernel-hardening@lfdr.de>; Mon,  3 Jun 2019 08:42:32 +0200 (CEST)
Received: (qmail 4022 invoked by uid 550); 3 Jun 2019 06:42:25 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 4000 invoked from network); 3 Jun 2019 06:42:25 -0000
Date: Mon, 3 Jun 2019 08:42:12 +0200
From: Pavel Machek <pavel@denx.de>
To: Joel Fernandes <joel@joelfernandes.org>
Cc: Pavel Machek <pavel@denx.de>, LKML <linux-kernel@vger.kernel.org>,
	Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Kees Cook <keescook@chromium.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
	Linux PM <linux-pm@vger.kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Neil Brown <neilb@suse.com>, netdev <netdev@vger.kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.ibm.com>,
	Peter Zilstra <peterz@infradead.org>,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>, rcu <rcu@vger.kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [RFC 2/6] ipv4: add lockdep condition to fix for_each_entry
Message-ID: <20190603064212.GA7400@amd>
References: <20190601222738.6856-1-joel@joelfernandes.org>
 <20190601222738.6856-3-joel@joelfernandes.org>
 <20190602070014.GA543@amd>
 <CAEXW_YT3t4Hb6wKsjXPGng+YbA5rhNRa7OSdZwdN4AKGfVkX3g@mail.gmail.com>
 <CAEXW_YSM2wwah2Q7LKmUO1Dp7GG62ciQA1nZ7GLw3m6cyuXXTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="SLDf9lqlvOQaIe6s"
Content-Disposition: inline
In-Reply-To: <CAEXW_YSM2wwah2Q7LKmUO1Dp7GG62ciQA1nZ7GLw3m6cyuXXTw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)


--SLDf9lqlvOQaIe6s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun 2019-06-02 08:24:35, Joel Fernandes wrote:
> On Sun, Jun 2, 2019 at 8:20 AM Joel Fernandes <joel@joelfernandes.org> wr=
ote:
> >
> > On Sun, Jun 2, 2019 at 3:00 AM Pavel Machek <pavel@denx.de> wrote:
> > >
> > > On Sat 2019-06-01 18:27:34, Joel Fernandes (Google) wrote:
> > > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > >
> > > This really needs to be merged to previous patch, you can't break
> > > compilation in middle of series...
> > >
> > > Or probably you need hlist_for_each_entry_rcu_lockdep() macro with
> > > additional argument, and switch users to it.
> >
> > Good point. I can also just add a temporary transition macro, and then
> > remove it in the last patch. That way no new macro is needed.
>=20
> Actually, no. There is no compilation break so I did not follow what
> you mean. The fourth argument to the hlist_for_each_entry_rcu is
> optional. The only thing that happens is new lockdep warnings will
> arise which later parts of the series fix by passing in that fourth
> argument.

Sorry, I missed that subtlety. Might be worth it enabling the lockdep
warning last in the series...

								Pavel
--=20
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--SLDf9lqlvOQaIe6s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlz0wUQACgkQMOfwapXb+vJZhACeMv6qy1KMl8fpAmSRbXsFU5yP
LY8Ani5H9/TBihxu13cOJbn7mJJ9RWkQ
=hotv
-----END PGP SIGNATURE-----

--SLDf9lqlvOQaIe6s--
