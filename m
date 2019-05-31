Return-Path: <kernel-hardening-return-16017-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2F38F30CB8
	for <lists+kernel-hardening@lfdr.de>; Fri, 31 May 2019 12:37:50 +0200 (CEST)
Received: (qmail 30706 invoked by uid 550); 31 May 2019 10:37:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30673 invoked from network); 31 May 2019 10:37:42 -0000
Date: Fri, 31 May 2019 12:37:30 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Thomas Gleixner <tglx@linutronix.de>,
	Andy Lutomirski <luto@amacapital.net>,
	Nadav Amit <namit@vmware.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	akpm@linux-foundation.org, ard.biesheuvel@linaro.org,
	deneen.t.dock@intel.com, kernel-hardening@lists.openwall.com,
	kristen@linux.intel.com, linux_dti@icloud.com, will.deacon@arm.com,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Jessica Yu <jeyu@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Rik van Riel <riel@surriel.com>, Ingo Molnar <mingo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 4.19 079/276] x86/modules: Avoid breaking W^X while
 loading modules
Message-ID: <20190531103730.GB9685@amd>
References: <20190530030523.133519668@linuxfoundation.org>
 <20190530030531.331779845@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kORqDWCi7qDJ0mEj"
Content-Disposition: inline
In-Reply-To: <20190530030531.331779845@linuxfoundation.org>
User-Agent: Mutt/1.5.23 (2014-03-12)


--kORqDWCi7qDJ0mEj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> [ Upstream commit f2c65fb3221adc6b73b0549fc7ba892022db9797 ]
>=20
> When modules and BPF filters are loaded, there is a time window in
> which some memory is both writable and executable. An attacker that has
> already found another vulnerability (e.g., a dangling pointer) might be
> able to exploit this behavior to overwrite kernel code. Prevent having
> writable executable PTEs in this stage.
>=20
> In addition, avoiding having W+X mappings can also slightly simplify the
> patching of modules code on initialization (e.g., by alternatives and
> static-key), as would be done in the next patch. This was actually the
> main motivation for this patch.
>=20
> To avoid having W+X mappings, set them initially as RW (NX) and after
> they are set as RO set them as X as well. Setting them as executable is
> done as a separate step to avoid one core in which the old PTE is cached
> (hence writable), and another which sees the updated PTE (executable),
> which would break the W^X protection.

First, is this stable material? Yes, it changes something.

But if you assume attacker can write into kernel memory during module
load, what prevents him to change the module as he sees fit while it
is not executable, simply waiting for system to execute it?

I don't see security benefit here.

> +++ b/arch/x86/kernel/alternative.c
> @@ -662,15 +662,29 @@ void __init alternative_instructions(void)
>   * handlers seeing an inconsistent instruction while you patch.
>   */
>  void *__init_or_module text_poke_early(void *addr, const void *opcode,
> -					      size_t len)
> +				       size_t len)
>  {
>  	unsigned long flags;
> -	local_irq_save(flags);
> -	memcpy(addr, opcode, len);
> -	local_irq_restore(flags);
> -	sync_core();
> -	/* Could also do a CLFLUSH here to speed up CPU recovery; but
> -	   that causes hangs on some VIA CPUs. */
> +
> +	if (boot_cpu_has(X86_FEATURE_NX) &&
> +	    is_module_text_address((unsigned long)addr)) {
> +		/*
> +		 * Modules text is marked initially as non-executable, so the
> +		 * code cannot be running and speculative code-fetches are
> +		 * prevented. Just change the code.
> +		 */
> +		memcpy(addr, opcode, len);
> +	} else {
> +		local_irq_save(flags);
> +		memcpy(addr, opcode, len);
> +		local_irq_restore(flags);
> +		sync_core();
> +
> +		/*
> +		 * Could also do a CLFLUSH here to speed up CPU recovery; but
> +		 * that causes hangs on some VIA CPUs.
> +		 */

I don't get it. If code can not be running here, it can not be running
in the !NX case, either, and we are free to just change
it. Speculative execution should not be a problem, either, as CPUs are
supposed to mask it, and there are no known bugs in that area. (Plus,
I'd not be surprise if speculative execution ignored NX... just saying
:-) )


									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--kORqDWCi7qDJ0mEj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlzxA+oACgkQMOfwapXb+vLr3ACfXR35weobKMdqgY0y0BNSOmZy
/aQAn0UtRPHtQSj7n1zWV39kDx1eOTVE
=nkcI
-----END PGP SIGNATURE-----

--kORqDWCi7qDJ0mEj--
