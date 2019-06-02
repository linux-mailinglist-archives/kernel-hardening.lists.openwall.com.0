Return-Path: <kernel-hardening-return-16037-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 489963224B
	for <lists+kernel-hardening@lfdr.de>; Sun,  2 Jun 2019 09:00:35 +0200 (CEST)
Received: (qmail 28409 invoked by uid 550); 2 Jun 2019 07:00:27 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28388 invoked from network); 2 Jun 2019 07:00:26 -0000
Date: Sun, 2 Jun 2019 09:00:14 +0200
From: Pavel Machek <pavel@denx.de>
To: "Joel Fernandes (Google)" <joel@joelfernandes.org>
Cc: linux-kernel@vger.kernel.org, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
	Bjorn Helgaas <bhelgaas@google.com>, Borislav Petkov <bp@alien8.de>,
	"David S. Miller" <davem@davemloft.net>, edumazet@google.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
	Josh Triplett <josh@joshtriplett.org>, keescook@chromium.org,
	kernel-hardening@lists.openwall.com,
	Lai Jiangshan <jiangshanlai@gmail.com>, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-pm@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, neilb@suse.com,
	netdev@vger.kernel.org, oleg@redhat.com,
	"Paul E. McKenney" <paulmck@linux.ibm.com>, peterz@infradead.org,
	"Rafael J. Wysocki" <rjw@rjwysocki.net>, rcu@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>, Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	"maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>
Subject: Re: [RFC 2/6] ipv4: add lockdep condition to fix for_each_entry
Message-ID: <20190602070014.GA543@amd>
References: <20190601222738.6856-1-joel@joelfernandes.org>
 <20190601222738.6856-3-joel@joelfernandes.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u3/rZRmxL6MmkK24"
Content-Disposition: inline
In-Reply-To: <20190601222738.6856-3-joel@joelfernandes.org>
User-Agent: Mutt/1.5.23 (2014-03-12)


--u3/rZRmxL6MmkK24
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat 2019-06-01 18:27:34, Joel Fernandes (Google) wrote:
> Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>

This really needs to be merged to previous patch, you can't break
compilation in middle of series...

Or probably you need hlist_for_each_entry_rcu_lockdep() macro with
additional argument, and switch users to it.
								Pavel

>  net/ipv4/fib_frontend.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
> index b298255f6fdb..ef7c9f8e8682 100644
> --- a/net/ipv4/fib_frontend.c
> +++ b/net/ipv4/fib_frontend.c
> @@ -127,7 +127,8 @@ struct fib_table *fib_get_table(struct net *net, u32 =
id)
>  	h =3D id & (FIB_TABLE_HASHSZ - 1);
> =20
>  	head =3D &net->ipv4.fib_table_hash[h];
> -	hlist_for_each_entry_rcu(tb, head, tb_hlist) {
> +	hlist_for_each_entry_rcu(tb, head, tb_hlist,
> +				 lockdep_rtnl_is_held()) {
>  		if (tb->tb_id =3D=3D id)
>  			return tb;
>  	}

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--u3/rZRmxL6MmkK24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlzzc/4ACgkQMOfwapXb+vLLpgCfQoWBSykNcFHCJ34MeV9TE4Es
/qIAn1NEzcdOi5m4WfplnoKX79226+10
=Uigu
-----END PGP SIGNATURE-----

--u3/rZRmxL6MmkK24--
