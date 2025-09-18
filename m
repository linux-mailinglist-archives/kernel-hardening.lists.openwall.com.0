Return-Path: <kernel-hardening-return-21986-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id AF3D5B37FEA
	for <lists+kernel-hardening@lfdr.de>; Wed, 27 Aug 2025 12:30:19 +0200 (CEST)
Received: (qmail 17800 invoked by uid 550); 27 Aug 2025 10:30:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17769 invoked from network); 27 Aug 2025 10:30:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cyphar.com; s=MBO0001;
	t=1756290599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=m6kfYmEF60frm5ESfpqkpSIWm2QXtU3dm6hKsbfysq8=;
	b=bL/I88CmRYJ0Ggq1FHXs6ULLcJ/6/cCF893rzC33wQuoMO7fgAYlRJvmJHgkiJMMA7amV7
	SyptXzg8agcA2szr8KRoHtPzi6AVHAiushOPKtAFEvlJ4YECDJCPOG9it6zxTM8TmxXOxU
	9EWrueILRyWBPgBd1/GomMLB5oaJpL4NnsQJrcwwcUhnys3p+nWCw9br7FCw8b2jkD061V
	JO5DsolO7kNGc3pnuvTcEk34Fn4MagnYML/AQQolng4gmmFRqXo6HRv69O0tFhdtI4cyMe
	SgOvy8acEtwhXDLNG/4OggYt/N9uUq4IMoxa86NsyvEh++Z+OgBynbsrb7EQkg==
Date: Wed, 27 Aug 2025 20:29:38 +1000
From: Aleksa Sarai <cyphar@cyphar.com>
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <serge@hallyn.com>, 
	Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Heimes <christian@python.org>, Dmitry Vyukov <dvyukov@google.com>, 
	Elliott Hughes <enh@google.com>, Fan Wu <wufan@linux.microsoft.com>, 
	Florian Weimer <fweimer@redhat.com>, Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jordan R Abrahams <ajordanr@google.com>, 
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, Luca Boccassi <bluca@debian.org>, 
	Matt Bobrowski <mattbobrowski@google.com>, Miklos Szeredi <mszeredi@redhat.com>, 
	Mimi Zohar <zohar@linux.ibm.com>, Nicolas Bouchinet <nicolas.bouchinet@oss.cyber.gouv.fr>, 
	Robert Waite <rowait@microsoft.com>, Roberto Sassu <roberto.sassu@huawei.com>, 
	Scott Shell <scottsh@microsoft.com>, Steve Dower <steve.dower@python.org>, 
	Steve Grubb <sgrubb@redhat.com>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, 
	Jeff Xu <jeffxu@chromium.org>
Subject: Re: [RFC PATCH v1 1/2] fs: Add O_DENY_WRITE
Message-ID: <2025-08-27-needy-drab-puritan-rebates-tHEaFw@cyphar.com>
References: <20250822170800.2116980-1-mic@digikod.net>
 <20250822170800.2116980-2-mic@digikod.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="psrvdihhhcwoejuq"
Content-Disposition: inline
In-Reply-To: <20250822170800.2116980-2-mic@digikod.net>


--psrvdihhhcwoejuq
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC PATCH v1 1/2] fs: Add O_DENY_WRITE
MIME-Version: 1.0

On 2025-08-22, Micka=EBl Sala=FCn <mic@digikod.net> wrote:
> Add a new O_DENY_WRITE flag usable at open time and on opened file (e.g.
> passed file descriptors).  This changes the state of the opened file by
> making it read-only until it is closed.  The main use case is for script
> interpreters to get the guarantee that script' content cannot be altered
> while being read and interpreted.  This is useful for generic distros
> that may not have a write-xor-execute policy.  See commit a5874fde3c08
> ("exec: Add a new AT_EXECVE_CHECK flag to execveat(2)")
>=20
> Both execve(2) and the IOCTL to enable fsverity can already set this
> property on files with deny_write_access().  This new O_DENY_WRITE make
> it widely available.  This is similar to what other OSs may provide
> e.g., opening a file with only FILE_SHARE_READ on Windows.
>=20
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Jeff Xu <jeffxu@chromium.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Paul Moore <paul@paul-moore.com>
> Cc: Serge Hallyn <serge@hallyn.com>
> Reported-by: Robert Waite <rowait@microsoft.com>
> Signed-off-by: Micka=EBl Sala=FCn <mic@digikod.net>
> Link: https://lore.kernel.org/r/20250822170800.2116980-2-mic@digikod.net
> ---
>  fs/fcntl.c                       | 26 ++++++++++++++++++++++++--
>  fs/file_table.c                  |  2 ++
>  fs/namei.c                       |  6 ++++++
>  include/linux/fcntl.h            |  2 +-
>  include/uapi/asm-generic/fcntl.h |  4 ++++
>  5 files changed, 37 insertions(+), 3 deletions(-)
>=20
> diff --git a/fs/fcntl.c b/fs/fcntl.c
> index 5598e4d57422..0c80c0fbc706 100644
> --- a/fs/fcntl.c
> +++ b/fs/fcntl.c
> @@ -34,7 +34,8 @@
> =20
>  #include "internal.h"
> =20
> -#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | O_DIRECT | O_NOAT=
IME)
> +#define SETFL_MASK (O_APPEND | O_NONBLOCK | O_NDELAY | O_DIRECT | O_NOAT=
IME | \
> +	O_DENY_WRITE)
> =20
>  static int setfl(int fd, struct file * filp, unsigned int arg)
>  {
> @@ -80,8 +81,29 @@ static int setfl(int fd, struct file * filp, unsigned =
int arg)
>  			error =3D 0;
>  	}
>  	spin_lock(&filp->f_lock);
> +
> +	if (arg & O_DENY_WRITE) {
> +		/* Only regular files. */
> +		if (!S_ISREG(inode->i_mode)) {
> +			error =3D -EINVAL;
> +			goto unlock;
> +		}
> +
> +		/* Only sets once. */
> +		if (!(filp->f_flags & O_DENY_WRITE)) {
> +			error =3D exe_file_deny_write_access(filp);
> +			if (error)
> +				goto unlock;
> +		}
> +	} else {
> +		if (filp->f_flags & O_DENY_WRITE)
> +			exe_file_allow_write_access(filp);
> +	}

I appreciate the goal of making this something that can be cleared
(presumably for interpreters that mmap(MAP_PRIVATE) their scripts), but
making a security-related flag this easy to clear seems like a footgun
(any library function could mask O_DENY_WRITE or forget to copy the old
flag values).

> +
>  	filp->f_flags =3D (arg & SETFL_MASK) | (filp->f_flags & ~SETFL_MASK);
>  	filp->f_iocb_flags =3D iocb_flags(filp);
> +
> +unlock:
>  	spin_unlock(&filp->f_lock);
> =20
>   out:
> @@ -1158,7 +1180,7 @@ static int __init fcntl_init(void)
>  	 * Exceptions: O_NONBLOCK is a two bit define on parisc; O_NDELAY
>  	 * is defined as O_NONBLOCK on some platforms and not on others.
>  	 */
> -	BUILD_BUG_ON(20 - 1 /* for O_RDONLY being 0 */ !=3D
> +	BUILD_BUG_ON(21 - 1 /* for O_RDONLY being 0 */ !=3D
>  		HWEIGHT32(
>  			(VALID_OPEN_FLAGS & ~(O_NONBLOCK | O_NDELAY)) |
>  			__FMODE_EXEC));
> diff --git a/fs/file_table.c b/fs/file_table.c
> index 81c72576e548..6ba896b6a53f 100644
> --- a/fs/file_table.c
> +++ b/fs/file_table.c
> @@ -460,6 +460,8 @@ static void __fput(struct file *file)
>  	locks_remove_file(file);
> =20
>  	security_file_release(file);
> +	if (unlikely(file->f_flags & O_DENY_WRITE))
> +		exe_file_allow_write_access(file);
>  	if (unlikely(file->f_flags & FASYNC)) {
>  		if (file->f_op->fasync)
>  			file->f_op->fasync(-1, file, 0);
> diff --git a/fs/namei.c b/fs/namei.c
> index cd43ff89fbaa..366530bf937d 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -3885,6 +3885,12 @@ static int do_open(struct nameidata *nd,
>  	error =3D may_open(idmap, &nd->path, acc_mode, open_flag);
>  	if (!error && !(file->f_mode & FMODE_OPENED))
>  		error =3D vfs_open(&nd->path, file);
> +	if (!error && (open_flag & O_DENY_WRITE)) {
> +		if (S_ISREG(file_inode(file)->i_mode))
> +			error =3D exe_file_deny_write_access(file);
> +		else
> +			error =3D -EINVAL;
> +	}
>  	if (!error)
>  		error =3D security_file_post_open(file, op->acc_mode);
>  	if (!error && do_truncate)
> diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
> index a332e79b3207..dad14101686f 100644
> --- a/include/linux/fcntl.h
> +++ b/include/linux/fcntl.h
> @@ -10,7 +10,7 @@
>  	(O_RDONLY | O_WRONLY | O_RDWR | O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC |=
 \
>  	 O_APPEND | O_NDELAY | O_NONBLOCK | __O_SYNC | O_DSYNC | \
>  	 FASYNC	| O_DIRECT | O_LARGEFILE | O_DIRECTORY | O_NOFOLLOW | \
> -	 O_NOATIME | O_CLOEXEC | O_PATH | __O_TMPFILE)
> +	 O_NOATIME | O_CLOEXEC | O_PATH | __O_TMPFILE | O_DENY_WRITE)

I don't like this patch for the same reasons Christian has already said,
but in addition -- you cannot just add new open(2) flags like this.

Unlike openat2(2), classic open(2) does not verify invalid flag bits, so
any new flag must be designed so that old kernels will return an error
for that flag combination, which ensures that:

 * No old programs set those bits inadvertently, which lets us avoid
   breaking userspace in some really fun and hard-to-debug ways.
 * For security-related bits, that new programs running on old kernels
   do not think they are getting a security property that they aren't
   actually getting.

O_TMPFILE's bitflag soup is an example of how you can resolve this issue
for open(2), but I would suggest that authors of new O_* flags seriously
consider making their flags openat2(2)-only unless it's trivial to get
the above behaviour.

>  /* List of all valid flags for the how->resolve argument: */
>  #define VALID_RESOLVE_FLAGS \
> diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/=
fcntl.h
> index 613475285643..facd9136f5af 100644
> --- a/include/uapi/asm-generic/fcntl.h
> +++ b/include/uapi/asm-generic/fcntl.h
> @@ -91,6 +91,10 @@
>  /* a horrid kludge trying to make sure that this will fail on old kernel=
s */
>  #define O_TMPFILE (__O_TMPFILE | O_DIRECTORY)
> =20
> +#ifndef O_DENY_WRITE
> +#define O_DENY_WRITE	040000000
> +#endif
> +
>  #ifndef O_NDELAY
>  #define O_NDELAY	O_NONBLOCK
>  #endif

--=20
Aleksa Sarai
Senior Software Engineer (Containers)
SUSE Linux GmbH
https://www.cyphar.com/

--psrvdihhhcwoejuq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQS2TklVsp+j1GPyqQYol/rSt+lEbwUCaK7eEhsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQKJf60rfpRG9V3AEA5oOWpgL+FjTae5hN5S0u
NsO3eAJnHacwgGQQEQNbJY0A+wWEmDH7pIvldv0TNbUu37QH46/cRLEB3/OX44QK
JV8I
=c4ff
-----END PGP SIGNATURE-----

--psrvdihhhcwoejuq--
