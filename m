Return-Path: <kernel-hardening-return-21875-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 6578B9D8B71
	for <lists+kernel-hardening@lfdr.de>; Mon, 25 Nov 2024 18:39:48 +0100 (CET)
Received: (qmail 11815 invoked by uid 550); 25 Nov 2024 17:39:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11789 invoked from network); 25 Nov 2024 17:39:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732556369; x=1733161169; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oouywyRvVlyFVHAI3/eMswlCXonw2bhK4cqFEEbsc1E=;
        b=Zs1ZH/C8MN3I6BnU9rXc9ALN+CnGlbzMmjWsesEWHXrgh0AKDivskWGZerUm+3uJpl
         yCyJEN3mEX4bjjlNOQO1NLbcUwW9xt8irhXmWfnDjcS/eTqR0h8VNNJ0E2hvxZPrUfRm
         yz8UGujtEnWecP3xyHnjHgL0JszsGQGru40pAcnxlDRAV2LbI17gvIK8XDTU2ax9RRKA
         ohY0B2SRB7UyTfFFq5LTdNdu3swOyz44VXzQ62pgvbZrC2h8bz7i6a843D8WwUPY5CJW
         3l5xxrdn2Xx5uuYBJ1LWg6dYDSunCvt+JZ3ZKEL6Sx6R4JVmd2DkIKuQKAZN7y3HkesA
         smEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732556369; x=1733161169;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oouywyRvVlyFVHAI3/eMswlCXonw2bhK4cqFEEbsc1E=;
        b=qyUU2JzvMOjqWc416+a3Y/ETKxnlfFkKWLyp4/YD2wi9CTe75REIskvafvkMWfMNt7
         2ZztBEiyHaHMRsP3w1pFNiygZ5eW0qEFK9rEEExp0HulN4cFiWgXOJNpjS7NM3Lh4c2I
         F3p298qnBf0mCC9uuQiSqp2YcagLwwWIa4m1SP7u8RBBjTxbvCuHnyW4Xz3miOHXuEGS
         cnNoxkMoPW/ts84W8m3oZmVAdr1+ljS5TyqjtwgbQOfhZRGN5YZ4jsHmEhvkdcqQSRPI
         dpPCn49c9YVVjLsmhJLIMB47LyKnWcQtgGfQdajeMQA6oQNFcOwhGIUJFLRg04018kE5
         M6oA==
X-Forwarded-Encrypted: i=1; AJvYcCWDpJWfxafRtKFCssUYf6APwkoydw+kOeGZtqh8razYJjQDeoSMB5eS18OfFiUrZAb7cTEqP8b/537wCy4Jvbqa@lists.openwall.com
X-Gm-Message-State: AOJu0Yy8HBG4GF55EmpzUKtoKtMaUaGh4A1lmWPISkmmJ/lPU12z+yq1
	UuHe6yVxlCI7/uTkHZiK4sZKg6/LlMqtu08PaRafdilWJxaqEn1FBWaNpSykFPiEHH3J/0naAGf
	7dnB3wxCMsEJIGnA2MVVEaMyeL4VrnZHsLywM
X-Gm-Gg: ASbGncswNU5xcYQ7wX85VXG9Wt6I1xOt6ITuA9YIUs0dqCOpmWijiAq73m3er4itHBx
	MJMk/LCSVoxZMDCWpujm57UgislphGbGpPhixBTgYfYEUiBlLj5pLE5qp8k3x
X-Google-Smtp-Source: AGHT+IGVwW4mrP/dnlD7S9hp5/+64ptTYarAo0+Y+B5Kq7y/lOOqw2XWIlkDTkEmE08Fny7+znCQemqrSOUfpeP6x7M=
X-Received: by 2002:a05:600c:4f90:b0:434:9ff3:8ffc with SMTP id
 5b1f17b1804b1-4349ff39110mr1294615e9.4.1732556368608; Mon, 25 Nov 2024
 09:39:28 -0800 (PST)
MIME-Version: 1.0
References: <20241112191858.162021-1-mic@digikod.net> <20241112191858.162021-2-mic@digikod.net>
 <CABi2SkVRJC_7qoU56mDt3Ch7U9GnVeRogUt9wc9=32OtG6aatw@mail.gmail.com>
 <20241120.Uy8ahtai5oku@digikod.net> <CABi2SkUx=7zummB4JCqEfb37p6MORR88y7S0E_YxJND_8dGaKA@mail.gmail.com>
 <20241121.uquee7ohRohn@digikod.net> <CABi2SkVHW9MBm=quZPdim_pM=BPaUD-8jRjG6G8OyQ8fQVsm0A@mail.gmail.com>
 <20241122.akooL5pie0th@digikod.net>
In-Reply-To: <20241122.akooL5pie0th@digikod.net>
From: Jeff Xu <jeffxu@google.com>
Date: Mon, 25 Nov 2024 09:38:51 -0800
Message-ID: <CALmYWFuYVHHz7aoxk+U=auLLT4xvJdzyOyzQ2u+E0kM3uc_rTw@mail.gmail.com>
Subject: Re: [PATCH v21 1/6] exec: Add a new AT_EXECVE_CHECK flag to execveat(2)
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Jeff Xu <jeffxu@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <serge@hallyn.com>, 
	Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, Alejandro Colomar <alx@kernel.org>, 
	Aleksa Sarai <cyphar@cyphar.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christian Heimes <christian@python.org>, 
	Dmitry Vyukov <dvyukov@google.com>, Elliott Hughes <enh@google.com>, Eric Biggers <ebiggers@kernel.org>, 
	Eric Chiang <ericchiang@google.com>, Fan Wu <wufan@linux.microsoft.com>, 
	Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	James Morris <jamorris@linux.microsoft.com>, Jan Kara <jack@suse.cz>, 
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Jordan R Abrahams <ajordanr@google.com>, Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Luca Boccassi <bluca@debian.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, 
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Matthew Garrett <mjg59@srcf.ucam.org>, Matthew Wilcox <willy@infradead.org>, 
	Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>, Scott Shell <scottsh@microsoft.com>, 
	Shuah Khan <shuah@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, 
	Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, 
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Xiaoming Ni <nixiaoming@huawei.com>, 
	Yin Fengwei <fengwei.yin@intel.com>, kernel-hardening@lists.openwall.com, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, Eric Paris <eparis@redhat.com>, 
	audit@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 22, 2024 at 6:50=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@digik=
od.net> wrote:
>
> On Thu, Nov 21, 2024 at 10:27:40AM -0800, Jeff Xu wrote:
> > On Thu, Nov 21, 2024 at 5:40=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@d=
igikod.net> wrote:
> > >
> > > On Wed, Nov 20, 2024 at 08:06:07AM -0800, Jeff Xu wrote:
> > > > On Wed, Nov 20, 2024 at 1:42=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <m=
ic@digikod.net> wrote:
> > > > >
> > > > > On Tue, Nov 19, 2024 at 05:17:00PM -0800, Jeff Xu wrote:
> > > > > > On Tue, Nov 12, 2024 at 11:22=E2=80=AFAM Micka=C3=ABl Sala=C3=
=BCn <mic@digikod.net> wrote:
> > > > > > >
> > > > > > > Add a new AT_EXECVE_CHECK flag to execveat(2) to check if a f=
ile would
> > > > > > > be allowed for execution.  The main use case is for script in=
terpreters
> > > > > > > and dynamic linkers to check execution permission according t=
o the
> > > > > > > kernel's security policy. Another use case is to add context =
to access
> > > > > > > logs e.g., which script (instead of interpreter) accessed a f=
ile.  As
> > > > > > > any executable code, scripts could also use this check [1].
> > > > > > >
> > > > > > > This is different from faccessat(2) + X_OK which only checks =
a subset of
> > > > > > > access rights (i.e. inode permission and mount options for re=
gular
> > > > > > > files), but not the full context (e.g. all LSM access checks)=
.  The main
> > > > > > > use case for access(2) is for SUID processes to (partially) c=
heck access
> > > > > > > on behalf of their caller.  The main use case for execveat(2)=
 +
> > > > > > > AT_EXECVE_CHECK is to check if a script execution would be al=
lowed,
> > > > > > > according to all the different restrictions in place.  Becaus=
e the use
> > > > > > > of AT_EXECVE_CHECK follows the exact kernel semantic as for a=
 real
> > > > > > > execution, user space gets the same error codes.
> > > > > > >
> > > > > > > An interesting point of using execveat(2) instead of openat2(=
2) is that
> > > > > > > it decouples the check from the enforcement.  Indeed, the sec=
urity check
> > > > > > > can be logged (e.g. with audit) without blocking an execution
> > > > > > > environment not yet ready to enforce a strict security policy=
.
> > > > > > >
> > > > > > > LSMs can control or log execution requests with
> > > > > > > security_bprm_creds_for_exec().  However, to enforce a consis=
tent and
> > > > > > > complete access control (e.g. on binary's dependencies) LSMs =
should
> > > > > > > restrict file executability, or mesure executed files, with
> > > > > > > security_file_open() by checking file->f_flags & __FMODE_EXEC=
.
> > > > > > >
> > > > > > > Because AT_EXECVE_CHECK is dedicated to user space interprete=
rs, it
> > > > > > > doesn't make sense for the kernel to parse the checked files,=
 look for
> > > > > > > interpreters known to the kernel (e.g. ELF, shebang), and ret=
urn ENOEXEC
> > > > > > > if the format is unknown.  Because of that, security_bprm_che=
ck() is
> > > > > > > never called when AT_EXECVE_CHECK is used.
> > > > > > >
> > > > > > > It should be noted that script interpreters cannot directly u=
se
> > > > > > > execveat(2) (without this new AT_EXECVE_CHECK flag) because t=
his could
> > > > > > > lead to unexpected behaviors e.g., `python script.sh` could l=
ead to Bash
> > > > > > > being executed to interpret the script.  Unlike the kernel, s=
cript
> > > > > > > interpreters may just interpret the shebang as a simple comme=
nt, which
> > > > > > > should not change for backward compatibility reasons.
> > > > > > >
> > > > > > > Because scripts or libraries files might not currently have t=
he
> > > > > > > executable permission set, or because we might want specific =
users to be
> > > > > > > allowed to run arbitrary scripts, the following patch provide=
s a dynamic
> > > > > > > configuration mechanism with the SECBIT_EXEC_RESTRICT_FILE an=
d
> > > > > > > SECBIT_EXEC_DENY_INTERACTIVE securebits.
> > > > > > >
> > > > > > > This is a redesign of the CLIP OS 4's O_MAYEXEC:
> > > > > > > https://github.com/clipos-archive/src_platform_clip-patches/b=
lob/f5cb330d6b684752e403b4e41b39f7004d88e561/1901_open_mayexec.patch
> > > > > > > This patch has been used for more than a decade with customiz=
ed script
> > > > > > > interpreters.  Some examples can be found here:
> > > > > > > https://github.com/clipos-archive/clipos4_portage-overlay/sea=
rch?q=3DO_MAYEXEC
> > > > > > >
> > > > > > > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > > > > > > Cc: Christian Brauner <brauner@kernel.org>
> > > > > > > Cc: Kees Cook <keescook@chromium.org>
> > > > > > > Cc: Paul Moore <paul@paul-moore.com>
> > > > > > > Reviewed-by: Serge Hallyn <serge@hallyn.com>
> > > > > > > Link: https://docs.python.org/3/library/io.html#io.open_code =
[1]
> > > > > > > Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> > > > > > > Link: https://lore.kernel.org/r/20241112191858.162021-2-mic@d=
igikod.net
> > > > > > > ---
> > > > > > >
> > > > > > > Changes since v20:
> > > > > > > * Rename AT_CHECK to AT_EXECVE_CHECK, requested by Amir Golds=
tein and
> > > > > > >   Serge Hallyn.
> > > > > > > * Move the UAPI documentation to a dedicated RST file.
> > > > > > > * Add Reviewed-by: Serge Hallyn
> > > > > > >
> > > > > > > Changes since v19:
> > > > > > > * Remove mention of "role transition" as suggested by Andy.
> > > > > > > * Highlight the difference between security_bprm_creds_for_ex=
ec() and
> > > > > > >   the __FMODE_EXEC check for LSMs (in commit message and LSM'=
s hooks) as
> > > > > > >   discussed with Jeff.
> > > > > > > * Improve documentation both in UAPI comments and kernel comm=
ents
> > > > > > >   (requested by Kees).
> > > > > > >
> > > > > > > New design since v18:
> > > > > > > https://lore.kernel.org/r/20220104155024.48023-3-mic@digikod.=
net
> > > > > > > ---
> > > > > > >  Documentation/userspace-api/check_exec.rst | 34 ++++++++++++=
++++++++++
> > > > > > >  Documentation/userspace-api/index.rst      |  1 +
> > > > > > >  fs/exec.c                                  | 20 +++++++++++-=
-
> > > > > > >  include/linux/binfmts.h                    |  7 ++++-
> > > > > > >  include/uapi/linux/fcntl.h                 |  4 +++
> > > > > > >  kernel/audit.h                             |  1 +
> > > > > > >  kernel/auditsc.c                           |  1 +
> > > > > > >  security/security.c                        | 10 +++++++
> > > > > > >  8 files changed, 75 insertions(+), 3 deletions(-)
> > > > > > >  create mode 100644 Documentation/userspace-api/check_exec.rs=
t
> > > > > > >
> > > > > > > diff --git a/Documentation/userspace-api/check_exec.rst b/Doc=
umentation/userspace-api/check_exec.rst
> > > > > > > new file mode 100644
> > > > > > > index 000000000000..ad1aeaa5f6c0
> > > > > > > --- /dev/null
> > > > > > > +++ b/Documentation/userspace-api/check_exec.rst
> > > > > > > @@ -0,0 +1,34 @@
> > > > > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > > > +Executability check
> > > > > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > > > +
> > > > > > > +AT_EXECVE_CHECK
> > > > > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > > > +
> > > > > > > +Passing the ``AT_EXECVE_CHECK`` flag to :manpage:`execveat(2=
)` only performs a
> > > > > > > +check on a regular file and returns 0 if execution of this f=
ile would be
> > > > > > > +allowed, ignoring the file format and then the related inter=
preter dependencies
> > > > > > > +(e.g. ELF libraries, script's shebang).
> > > > > > > +
> > > > > > > +Programs should always perform this check to apply kernel-le=
vel checks against
> > > > > > > +files that are not directly executed by the kernel but passe=
d to a user space
> > > > > > > +interpreter instead.  All files that contain executable code=
, from the point of
> > > > > > > +view of the interpreter, should be checked.  However the res=
ult of this check
> > > > > > > +should only be enforced according to ``SECBIT_EXEC_RESTRICT_=
FILE`` or
> > > > > > > +``SECBIT_EXEC_DENY_INTERACTIVE.``.
> > > > > > Regarding "should only"
> > > > > > Userspace (e.g. libc) could decide to enforce even when
> > > > > > SECBIT_EXEC_RESTRICT_FILE=3D0), i.e. if it determines not-enfor=
cing
> > > > > > doesn't make sense.
> > > > >
> > > > > User space is always in control, but I don't think it would be wi=
se to
> > > > > not follow the configuration securebits (in a generic system) bec=
ause
> > > > > this could result to unattended behaviors (I don't have a specifi=
c one
> > > > > in mind but...).  That being said, configuration and checks are
> > > > > standalones and specific/tailored systems are free to do the chec=
ks they
> > > > > want.
> > > > >
> > > > In the case of dynamic linker, we can always enforce honoring the
> > > > execveat(AT_EXECVE_CHECK) result, right ? I can't think of a case n=
ot
> > > > to,  the dynamic linker doesn't need to check the
> > > > SECBIT_EXEC_RESTRICT_FILE bit.
> > >
> > > If the library file is not allowed to be executed by *all* access
> > > control systems (not just mount and file permission, but all LSMs), t=
hen
> > > the AT_EXECVE_CHECK will fail, which is OK as long as it is not a har=
d
> > > requirement.
> > Yes. specifically for the library loading case, I can't think of a
> > case where we need to by-pass LSMs.  (letting user space to by-pass
> > LSM check seems questionable in concept, and should only be used when
> > there aren't other solutions). In the context of SELINUX enforcing
> > mode,  we will want to enforce it. In the context of process level LSM
> > such as landlock,  the process can already decide for itself by
> > selecting the policy for its own domain, it is unnecessary to use
> > another opt-out solution.
>
> My answer wasn't clear.  The execveat(AT_EXECVE_CHECK) can and should
> always be done, but user space should only enforce restrictions
> according to the securebits.
>
I knew this part (AT_EXESCVE_CHECK is called always)
Since the securebits are enforced by userspace, setting it to 0 is
equivalent to opt-out enforcement, that is what I meant by opt-out.

> It doesn't make sense to talk about user space "bypassing" kernel
> checks.  This patch series provides a feature to enable user space to
> enforce (at its level) the same checks as the kernel.
>
> There is no opt-out solution, but compatibility configuration bits
> through securebits (which can also be set by LSMs).
>
> To answer your question about the dynamic linker, there should be no
> difference of behavior with a script interpreter.  Both should check
> executability but only enforce restriction according to the securebits
> (as explained in the documentation).  Doing otherwise on a generic
> distro could lead to unexpected behaviors (e.g. if a user enforced a
> specific SELinux policy that doesn't allow execution of library files).
>
> >
> > There is one case where I see a difference:
> > ld.so a.out (when a.out is on non-exec mount)
> >
> > If the dynamic linker doesn't read SECBIT_EXEC_RESTRICT_FILE setting,
> > above will always fail. But that is more of a bugfix.
>
> No, the dynamic linker should only enforce restrictions according to the
> securebits, otherwise a user space update (e.g. with a new dynamic
> linker ignoring the securebits) could break an existing system.
>
OK. upgrade is a valid concern. Previously, I was just thinking about
a new LSM based on this check, not existing LSM policies.
Do you happen to know which SELinux policy/LSM could break ? i.e. it
will be applied to libraries once we add AT_EXESCVE_CHECK in the
dynamic linker.
We could give heads up and prepare for that.

> >
> > >Relying on the securebits to know if this is a hard
> > > requirement or not enables system administrator and distros to contro=
l
> > > this potential behavior change.
> > >
> > I think, for the dynamic linker, it can be a hard requirement.
>
> Not on a generic distro.
>
Ok. Maybe this can be done through a configuration option for the
dynamic linker.

The consideration I have is: securebits is currently designed to
control both dynamic linker and shell scripts.
The case for dynamic linker is simpler than scripts cases, (non-exec
mount, and perhaps some LSM policies for libraries) and distributions
such as ChromeOS can enforce the dynamic linker case ahead of scripts
interrupter cases, i.e. without waiting for python/shell being
upgraded, that can take sometimes.

> >
> > For scripts, the cases are more complicated and we can't just enforce
> > it,  therefore have to rely on security bits to give a pre-process
> > level control.
> >
> > > >
> > > > script interpreters need to check this though,  because the apps mi=
ght
> > > > need to adjust/test the scripts they are calling, so
> > > > SECBIT_EXEC_RESTRICT_FILE can be used to opt-out the enforcement.
> > > >
> > > > > > When SECBIT_EXEC_RESTRICT_FILE=3D1,  userspace is bound to enfo=
rce.
> > > > > >
> > > > > > > +
> > > > > > > +The main purpose of this flag is to improve the security and=
 consistency of an
> > > > > > > +execution environment to ensure that direct file execution (=
e.g.
> > > > > > > +``./script.sh``) and indirect file execution (e.g. ``sh scri=
pt.sh``) lead to
> > > > > > > +the same result.  For instance, this can be used to check if=
 a file is
> > > > > > > +trustworthy according to the caller's environment.
> > > > > > > +
> > > > > > > +In a secure environment, libraries and any executable depend=
encies should also
> > > > > > > +be checked.  For instance, dynamic linking should make sure =
that all libraries
> > > > > > > +are allowed for execution to avoid trivial bypass (e.g. usin=
g ``LD_PRELOAD``).
> > > > > > > +For such secure execution environment to make sense, only tr=
usted code should
> > > > > > > +be executable, which also requires integrity guarantees.
> > > > > > > +
> > > > > > > +To avoid race conditions leading to time-of-check to time-of=
-use issues,
> > > > > > > +``AT_EXECVE_CHECK`` should be used with ``AT_EMPTY_PATH`` to=
 check against a
> > > > > > > +file descriptor instead of a path.
> > > > > > > diff --git a/Documentation/userspace-api/index.rst b/Document=
ation/userspace-api/index.rst
> > > > > > > index 274cc7546efc..6272bcf11296 100644
> > > > > > > --- a/Documentation/userspace-api/index.rst
> > > > > > > +++ b/Documentation/userspace-api/index.rst
> > > > > > > @@ -35,6 +35,7 @@ Security-related interfaces
> > > > > > >     mfd_noexec
> > > > > > >     spec_ctrl
> > > > > > >     tee
> > > > > > > +   check_exec
> > > > > > >
> > > > > > >  Devices and I/O
> > > > > > >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > > > diff --git a/fs/exec.c b/fs/exec.c
> > > > > > > index 6c53920795c2..bb83b6a39530 100644
> > > > > > > --- a/fs/exec.c
> > > > > > > +++ b/fs/exec.c
> > > > > > > @@ -891,7 +891,8 @@ static struct file *do_open_execat(int fd=
, struct filename *name, int flags)
> > > > > > >                 .lookup_flags =3D LOOKUP_FOLLOW,
> > > > > > >         };
> > > > > > >
> > > > > > > -       if ((flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) =
!=3D 0)
> > > > > > > +       if ((flags &
> > > > > > > +            ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH | AT_EXECV=
E_CHECK)) !=3D 0)
> > > > > > >                 return ERR_PTR(-EINVAL);
> > > > > > >         if (flags & AT_SYMLINK_NOFOLLOW)
> > > > > > >                 open_exec_flags.lookup_flags &=3D ~LOOKUP_FOL=
LOW;
> > > > > > > @@ -1545,6 +1546,21 @@ static struct linux_binprm *alloc_bprm=
(int fd, struct filename *filename, int fl
> > > > > > >         }
> > > > > > >         bprm->interp =3D bprm->filename;
> > > > > > >
> > > > > > > +       /*
> > > > > > > +        * At this point, security_file_open() has already be=
en called (with
> > > > > > > +        * __FMODE_EXEC) and access control checks for AT_EXE=
CVE_CHECK will
> > > > > > > +        * stop just after the security_bprm_creds_for_exec()=
 call in
> > > > > > > +        * bprm_execve().  Indeed, the kernel should not try =
to parse the
> > > > > > > +        * content of the file with exec_binprm() nor change =
the calling
> > > > > > > +        * thread, which means that the following security fu=
nctions will be
> > > > > > > +        * not called:
> > > > > > > +        * - security_bprm_check()
> > > > > > > +        * - security_bprm_creds_from_file()
> > > > > > > +        * - security_bprm_committing_creds()
> > > > > > > +        * - security_bprm_committed_creds()
> > > > > > > +        */
> > > > > > > +       bprm->is_check =3D !!(flags & AT_EXECVE_CHECK);
> > > > > > > +
> > > > > > >         retval =3D bprm_mm_init(bprm);
> > > > > > >         if (!retval)
> > > > > > >                 return bprm;
> > > > > > > @@ -1839,7 +1855,7 @@ static int bprm_execve(struct linux_bin=
prm *bprm)
> > > > > > >
> > > > > > >         /* Set the unchanging part of bprm->cred */
> > > > > > >         retval =3D security_bprm_creds_for_exec(bprm);
> > > > > > > -       if (retval)
> > > > > > > +       if (retval || bprm->is_check)
> > > > > > >                 goto out;
> > > > > > >
> > > > > > >         retval =3D exec_binprm(bprm);
> > > > > > > diff --git a/include/linux/binfmts.h b/include/linux/binfmts.=
h
> > > > > > > index e6c00e860951..8ff0eb3644a1 100644
> > > > > > > --- a/include/linux/binfmts.h
> > > > > > > +++ b/include/linux/binfmts.h
> > > > > > > @@ -42,7 +42,12 @@ struct linux_binprm {
> > > > > > >                  * Set when errors can no longer be returned =
to the
> > > > > > >                  * original userspace.
> > > > > > >                  */
> > > > > > > -               point_of_no_return:1;
> > > > > > > +               point_of_no_return:1,
> > > > > > > +               /*
> > > > > > > +                * Set by user space to check executability a=
ccording to the
> > > > > > > +                * caller's environment.
> > > > > > > +                */
> > > > > > > +               is_check:1;
> > > > > > >         struct file *executable; /* Executable to pass to the=
 interpreter */
> > > > > > >         struct file *interpreter;
> > > > > > >         struct file *file;
> > > > > > > diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/=
fcntl.h
> > > > > > > index 87e2dec79fea..2e87f2e3a79f 100644
> > > > > > > --- a/include/uapi/linux/fcntl.h
> > > > > > > +++ b/include/uapi/linux/fcntl.h
> > > > > > > @@ -154,6 +154,10 @@
> > > > > > >                                            usable with open_b=
y_handle_at(2). */
> > > > > > >  #define AT_HANDLE_MNT_ID_UNIQUE        0x001   /* Return the=
 u64 unique mount ID. */
> > > > > > >
> > > > > > > +/* Flags for execveat2(2). */
> > > > > > > +#define AT_EXECVE_CHECK                0x10000 /* Only perfo=
rm a check if execution
> > > > > > > +                                          would be allowed. =
*/
> > > > > > > +
> > > > > > >  #if defined(__KERNEL__)
> > > > > > >  #define AT_GETATTR_NOSEC       0x80000000
> > > > > > >  #endif
> > > > > > > diff --git a/kernel/audit.h b/kernel/audit.h
> > > > > > > index a60d2840559e..8ebdabd2ab81 100644
> > > > > > > --- a/kernel/audit.h
> > > > > > > +++ b/kernel/audit.h
> > > > > > > @@ -197,6 +197,7 @@ struct audit_context {
> > > > > > >                 struct open_how openat2;
> > > > > > >                 struct {
> > > > > > >                         int                     argc;
> > > > > > > +                       bool                    is_check;
> > > > > > >                 } execve;
> > > > > > >                 struct {
> > > > > > >                         char                    *name;
> > > > > > > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > > > > > > index cd57053b4a69..8d9ba5600cf2 100644
> > > > > > > --- a/kernel/auditsc.c
> > > > > > > +++ b/kernel/auditsc.c
> > > > > > > @@ -2662,6 +2662,7 @@ void __audit_bprm(struct linux_binprm *=
bprm)
> > > > > > >
> > > > > > >         context->type =3D AUDIT_EXECVE;
> > > > > > >         context->execve.argc =3D bprm->argc;
> > > > > > > +       context->execve.is_check =3D bprm->is_check;
> > > > > > Where is execve.is_check used ?
> > > > >
> > > > > It is used in bprm_execve(), exposed to the audit framework, and
> > > > > potentially used by LSMs.
> > > > >
> > > > bprm_execve() uses bprm->is_check, not  the context->execve.is_chec=
k.
> > >
> > > Correct, this is only for audit but not used yet.
> > >
> > > Paul, Eric, do you want me to remove this field, leave it, or extend
> > > this patch like this?
> > >
> > > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > > index 8d9ba5600cf2..12cf89fa224a 100644
> > > --- a/kernel/auditsc.c
> > > +++ b/kernel/auditsc.c
> > > @@ -1290,6 +1290,8 @@ static void audit_log_execve_info(struct audit_=
context *context,
> > >                 }
> > >         } while (arg < context->execve.argc);
> > >
> > > +       audit_log_format(*ab, " check=3D%d", context->execve.is_check=
);
> > > +
> > >         /* NOTE: the caller handles the final audit_log_end() call */
> > >
> > >  out:
> > >
> > > >
> > > >
> > > > > >
> > > > > >
> > > > > > >  }
> > > > > > >
> > > > > > >
> > > > > > > diff --git a/security/security.c b/security/security.c
> > > > > > > index c5981e558bc2..456361ec249d 100644
> > > > > > > --- a/security/security.c
> > > > > > > +++ b/security/security.c
> > > > > > > @@ -1249,6 +1249,12 @@ int security_vm_enough_memory_mm(struc=
t mm_struct *mm, long pages)
> > > > > > >   * to 1 if AT_SECURE should be set to request libc enable se=
cure mode.  @bprm
> > > > > > >   * contains the linux_binprm structure.
> > > > > > >   *
> > > > > > > + * If execveat(2) is called with the AT_EXECVE_CHECK flag, b=
prm->is_check is
> > > > > > > + * set.  The result must be the same as without this flag ev=
en if the execution
> > > > > > > + * will never really happen and @bprm will always be dropped=
.
> > > > > > > + *
> > > > > > > + * This hook must not change current->cred, only @bprm->cred=
.
> > > > > > > + *
> > > > > > >   * Return: Returns 0 if the hook is successful and permissio=
n is granted.
> > > > > > >   */
> > > > > > >  int security_bprm_creds_for_exec(struct linux_binprm *bprm)
> > > > > > > @@ -3100,6 +3106,10 @@ int security_file_receive(struct file =
*file)
> > > > > > >   * Save open-time permission checking state for later use up=
on file_permission,
> > > > > > >   * and recheck access if anything has changed since inode_pe=
rmission.
> > > > > > >   *
> > > > > > > + * We can check if a file is opened for execution (e.g. exec=
ve(2) call), either
> > > > > > > + * directly or indirectly (e.g. ELF's ld.so) by checking fil=
e->f_flags &
> > > > > > > + * __FMODE_EXEC .
> > > > > > > + *
> > > > > > >   * Return: Returns 0 if permission is granted.
> > > > > > >   */
> > > > > > >  int security_file_open(struct file *file)
> > > > > > > --
> > > > > > > 2.47.0
> > > > > > >
> > > > > > >
> > > >
