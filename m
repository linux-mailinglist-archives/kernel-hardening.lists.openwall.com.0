Return-Path: <kernel-hardening-return-21735-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 2EED8927F4E
	for <lists+kernel-hardening@lfdr.de>; Fri,  5 Jul 2024 02:19:25 +0200 (CEST)
Received: (qmail 26473 invoked by uid 550); 5 Jul 2024 00:19:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 24200 invoked from network); 5 Jul 2024 00:18:17 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720138684;
	bh=5af+DRO8rWEXOnw6IOc48Ov2WwkK5joBTlWm01wXltM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VTICkINTStb85dDsvisEftl1X0r68/zfAO4xLYD7kb1F8/Z5ERt/7oqFMWp/Z79bR
	 FX1FDeXC4RuC6ECne5DIV1RFOg/M68nAs22Pdbv6HaFYgEot5lB4XEWHuYnmoad0Uz
	 fJQySERKu4g85/Pa20vCn/jPl5JSNmGUFT2BTH5yFQ3SC1h8dvuM9nn2eFSOXyQNTY
	 Ypn8Z9tbW5W5OvugpM6kDGWPviy6GjDMUM04+9PJ4IenEy1IIZ7eelPUOs1kNTmuiK
	 LzLsiTqYlZcCezV4AhZE+r3KHp3ZgANlcAclUNRPlIaJ95W28SmSDs7UyBwzonYAUU
	 K1CEAD7cNxMhg==
Date: Thu, 4 Jul 2024 17:18:04 -0700
From: Kees Cook <kees@kernel.org>
To: =?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Paul Moore <paul@paul-moore.com>, Theodore Ts'o <tytso@mit.edu>,
	Alejandro Colomar <alx.manpages@gmail.com>,
	Aleksa Sarai <cyphar@cyphar.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Christian Heimes <christian@python.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Eric Chiang <ericchiang@google.com>,
	Fan Wu <wufan@linux.microsoft.com>,
	Florian Weimer <fweimer@redhat.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	James Morris <jamorris@linux.microsoft.com>,
	Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Jordan R Abrahams <ajordanr@google.com>,
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
	Luca Boccassi <bluca@debian.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Matthew Wilcox <willy@infradead.org>,
	Miklos Szeredi <mszeredi@redhat.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	Xiaoming Ni <nixiaoming@huawei.com>,
	Yin Fengwei <fengwei.yin@intel.com>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH v19 2/5] security: Add new SHOULD_EXEC_CHECK and
 SHOULD_EXEC_RESTRICT securebits
Message-ID: <202407041711.B7CD16B2@keescook>
References: <20240704190137.696169-1-mic@digikod.net>
 <20240704190137.696169-3-mic@digikod.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240704190137.696169-3-mic@digikod.net>

On Thu, Jul 04, 2024 at 09:01:34PM +0200, Micka�l Sala�n wrote:
> Such a secure environment can be achieved with an appropriate access
> control policy (e.g. mount's noexec option, file access rights, LSM
> configuration) and an enlighten ld.so checking that libraries are
> allowed for execution e.g., to protect against illegitimate use of
> LD_PRELOAD.
> 
> Scripts may need some changes to deal with untrusted data (e.g. stdin,
> environment variables), but that is outside the scope of the kernel.

If the threat model includes an attacker sitting at a shell prompt, we
need to be very careful about how process perform enforcement. E.g. even
on a locked down system, if an attacker has access to LD_PRELOAD or a
seccomp wrapper (which you both mention here), it would be possible to
run commands where the resulting process is tricked into thinking it
doesn't have the bits set.

But this would be exactly true for calling execveat(): LD_PRELOAD or
seccomp policy could have it just return 0.

While I like AT_CHECK, I do wonder if it's better to do the checks via
open(), as was originally designed with O_MAYEXEC. Because then
enforcement is gated by the kernel -- the process does not get a file
descriptor _at all_, no matter what LD_PRELOAD or seccomp tricks it into
doing.

And this thinking also applies to faccessat() too: if a process can be
tricked into thinking the access check passed, it'll happily interpret
whatever. :( But not being able to open the fd _at all_ when O_MAYEXEC
is being checked seems substantially safer to me...

-- 
Kees Cook
