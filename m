Return-Path: <kernel-hardening-return-21879-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 50BCC9DAA8E
	for <lists+kernel-hardening@lfdr.de>; Wed, 27 Nov 2024 16:15:23 +0100 (CET)
Received: (qmail 6024 invoked by uid 550); 27 Nov 2024 15:15:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5998 invoked from network); 27 Nov 2024 15:15:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1732720503; x=1733325303; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/DZRabW3bKxLsn+AnXY/JSwYHwNwdRvBlRfkhLmPTIA=;
        b=v9x975VNca7/k12P7XCb7CmHolaJX10VGSLzOOfhZrLm8sB62ookT4XsYOcJ/Ell3o
         xopiNI6mcHZrl6BXl0P9LVZqbpgFeOQ6efyrKZWsrxdsfybE+CuYxvhvHvjXLyI5COEP
         TYUMGuAm1ejiW747p+N0S4VdKSwjgnRuWy5XtwaRg9AlcDBAw+Obu8ViZ1QBwcY4J7fB
         YRLT+DI8TZTJ29CvxTw3sUa25zrDvxCSN7w/zNuFx+d7Zgolx3XbBTbLws+ulhivaDOM
         J//6Z18WxjILDj9vaPNS/UN1k9lAlzHPt+M01rMnhvlGKX1H9Vc9djwTmPBn6YG2W99k
         im5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732720503; x=1733325303;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/DZRabW3bKxLsn+AnXY/JSwYHwNwdRvBlRfkhLmPTIA=;
        b=effhEdYHBrdN0TQHMahsHth5iPXuB6QgfxW3bDZ5oEhyJrhidhefoduQbQUUjBiRhj
         ootF8irshmtZpm2rNjBJPyq1dtIcnnQi6xKM9nQwKyGjh0lZE/78Twi/fgGR4h5145GG
         4D01IZmdTGYY62eMm179Ry1xktc+bwfEMdGl9VicYKPIgdlOpqHPSWUzgK8MMVW4xlvI
         9erIfB8WKMUoTQ6M0LiGzE4TBl3if/NS9ORBbjhVdXLaOx8TH6AAN7kUD8A2YlWRd7UE
         9oJAXxsXxu0IKS+R0SQ/rAeBXI1vcAWZuMaiKpCNATLbPlXxXhEDzJY1S+iSr4mxMe/l
         2rUw==
X-Forwarded-Encrypted: i=1; AJvYcCUFtDdj8VbLqFc2cqGHlsA3L9a4sl1dO7wVVBEn9nIIDVj8LuH4OdRZLX2C2S4CLAPrbyZd0Yc17yrM7/OSkdI/@lists.openwall.com
X-Gm-Message-State: AOJu0YynYdcgDt+61qhdCW/84am4kJRFOhD5jBmjYIQZxSmEA8WPB3k0
	MumV7YVvltY+cZx1rLCuDzTQMVfgluwloCdczohW2sZJGq6o2B3hWcH9GSaGynWOnjMiSrFzGCH
	snOxWX53KoNJWBVgWcnmUvgcvzduBpGbepH44
X-Gm-Gg: ASbGncvydZQtVUTzFM9SNhClF9WvsYH6sohAtLgPBg1JvfUaOOzjWERb5P+a2zjMZ9x
	/EurT2lqCumKG1gwk902CgJJXEQ8Ws50UUk23ZXvV2J/IfaEerYTA0Sccuzi1NA==
X-Google-Smtp-Source: AGHT+IEhPoQxFOJHG8q3TRLoNCLBrxLXcdSUtfx5DcW2rA4iEhbyIHJIGXlq2Ds39yxcVUloBsRLfG+a4Gmb5HxpXok=
X-Received: by 2002:a05:600c:4644:b0:434:9e1d:44ef with SMTP id
 5b1f17b1804b1-434aa6c1783mr1106375e9.7.1732720503218; Wed, 27 Nov 2024
 07:15:03 -0800 (PST)
MIME-Version: 1.0
References: <20241112191858.162021-1-mic@digikod.net> <20241112191858.162021-2-mic@digikod.net>
 <CABi2SkVRJC_7qoU56mDt3Ch7U9GnVeRogUt9wc9=32OtG6aatw@mail.gmail.com>
 <20241120.Uy8ahtai5oku@digikod.net> <CABi2SkUx=7zummB4JCqEfb37p6MORR88y7S0E_YxJND_8dGaKA@mail.gmail.com>
 <20241121.uquee7ohRohn@digikod.net> <CABi2SkVHW9MBm=quZPdim_pM=BPaUD-8jRjG6G8OyQ8fQVsm0A@mail.gmail.com>
 <20241122.akooL5pie0th@digikod.net> <CALmYWFuYVHHz7aoxk+U=auLLT4xvJdzyOyzQ2u+E0kM3uc_rTw@mail.gmail.com>
 <20241127.aizae7eeHohn@digikod.net>
In-Reply-To: <20241127.aizae7eeHohn@digikod.net>
From: Jeff Xu <jeffxu@google.com>
Date: Wed, 27 Nov 2024 07:14:25 -0800
Message-ID: <CALmYWFscyp7xnhKsh6y8yZFHd_9kNbafDTMxS617Jno1t+Pmnw@mail.gmail.com>
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

On Wed, Nov 27, 2024 at 4:07=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@digik=
od.net> wrote:
>
> On Mon, Nov 25, 2024 at 09:38:51AM -0800, Jeff Xu wrote:
> > On Fri, Nov 22, 2024 at 6:50=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@d=
igikod.net> wrote:
> > >
> > > On Thu, Nov 21, 2024 at 10:27:40AM -0800, Jeff Xu wrote:
> > > > On Thu, Nov 21, 2024 at 5:40=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <m=
ic@digikod.net> wrote:
> > > > >
> > > > > On Wed, Nov 20, 2024 at 08:06:07AM -0800, Jeff Xu wrote:
> > > > > > On Wed, Nov 20, 2024 at 1:42=E2=80=AFAM Micka=C3=ABl Sala=C3=BC=
n <mic@digikod.net> wrote:
> > > > > > >
> > > > > > > On Tue, Nov 19, 2024 at 05:17:00PM -0800, Jeff Xu wrote:
> > > > > > > > On Tue, Nov 12, 2024 at 11:22=E2=80=AFAM Micka=C3=ABl Sala=
=C3=BCn <mic@digikod.net> wrote:
> > > > > > > > >
> > > > > > > > > Add a new AT_EXECVE_CHECK flag to execveat(2) to check if=
 a file would
> > > > > > > > > be allowed for execution.  The main use case is for scrip=
t interpreters
> > > > > > > > > and dynamic linkers to check execution permission accordi=
ng to the
> > > > > > > > > kernel's security policy. Another use case is to add cont=
ext to access
> > > > > > > > > logs e.g., which script (instead of interpreter) accessed=
 a file.  As
> > > > > > > > > any executable code, scripts could also use this check [1=
].
> > > > > > > > >
> > > > > > > > > This is different from faccessat(2) + X_OK which only che=
cks a subset of
> > > > > > > > > access rights (i.e. inode permission and mount options fo=
r regular
> > > > > > > > > files), but not the full context (e.g. all LSM access che=
cks).  The main
> > > > > > > > > use case for access(2) is for SUID processes to (partiall=
y) check access
> > > > > > > > > on behalf of their caller.  The main use case for execvea=
t(2) +
> > > > > > > > > AT_EXECVE_CHECK is to check if a script execution would b=
e allowed,
> > > > > > > > > according to all the different restrictions in place.  Be=
cause the use
> > > > > > > > > of AT_EXECVE_CHECK follows the exact kernel semantic as f=
or a real
> > > > > > > > > execution, user space gets the same error codes.
> > > > > > > > >
> > > > > > > > > An interesting point of using execveat(2) instead of open=
at2(2) is that
> > > > > > > > > it decouples the check from the enforcement.  Indeed, the=
 security check
> > > > > > > > > can be logged (e.g. with audit) without blocking an execu=
tion
> > > > > > > > > environment not yet ready to enforce a strict security po=
licy.
> > > > > > > > >
> > > > > > > > > LSMs can control or log execution requests with
> > > > > > > > > security_bprm_creds_for_exec().  However, to enforce a co=
nsistent and
> > > > > > > > > complete access control (e.g. on binary's dependencies) L=
SMs should
> > > > > > > > > restrict file executability, or mesure executed files, wi=
th
> > > > > > > > > security_file_open() by checking file->f_flags & __FMODE_=
EXEC.
> > > > > > > > >
> > > > > > > > > Because AT_EXECVE_CHECK is dedicated to user space interp=
reters, it
> > > > > > > > > doesn't make sense for the kernel to parse the checked fi=
les, look for
> > > > > > > > > interpreters known to the kernel (e.g. ELF, shebang), and=
 return ENOEXEC
> > > > > > > > > if the format is unknown.  Because of that, security_bprm=
_check() is
> > > > > > > > > never called when AT_EXECVE_CHECK is used.
> > > > > > > > >
> > > > > > > > > It should be noted that script interpreters cannot direct=
ly use
> > > > > > > > > execveat(2) (without this new AT_EXECVE_CHECK flag) becau=
se this could
> > > > > > > > > lead to unexpected behaviors e.g., `python script.sh` cou=
ld lead to Bash
> > > > > > > > > being executed to interpret the script.  Unlike the kerne=
l, script
> > > > > > > > > interpreters may just interpret the shebang as a simple c=
omment, which
> > > > > > > > > should not change for backward compatibility reasons.
> > > > > > > > >
> > > > > > > > > Because scripts or libraries files might not currently ha=
ve the
> > > > > > > > > executable permission set, or because we might want speci=
fic users to be
> > > > > > > > > allowed to run arbitrary scripts, the following patch pro=
vides a dynamic
> > > > > > > > > configuration mechanism with the SECBIT_EXEC_RESTRICT_FIL=
E and
> > > > > > > > > SECBIT_EXEC_DENY_INTERACTIVE securebits.
> > > > > > > > >
> > > > > > > > > This is a redesign of the CLIP OS 4's O_MAYEXEC:
> > > > > > > > > https://github.com/clipos-archive/src_platform_clip-patch=
es/blob/f5cb330d6b684752e403b4e41b39f7004d88e561/1901_open_mayexec.patch
> > > > > > > > > This patch has been used for more than a decade with cust=
omized script
> > > > > > > > > interpreters.  Some examples can be found here:
> > > > > > > > > https://github.com/clipos-archive/clipos4_portage-overlay=
/search?q=3DO_MAYEXEC
> > > > > > > > >
> > > > > > > > > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > > > > > > > > Cc: Christian Brauner <brauner@kernel.org>
> > > > > > > > > Cc: Kees Cook <keescook@chromium.org>
> > > > > > > > > Cc: Paul Moore <paul@paul-moore.com>
> > > > > > > > > Reviewed-by: Serge Hallyn <serge@hallyn.com>
> > > > > > > > > Link: https://docs.python.org/3/library/io.html#io.open_c=
ode [1]
> > > > > > > > > Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> > > > > > > > > Link: https://lore.kernel.org/r/20241112191858.162021-2-m=
ic@digikod.net
> > > > > > > > > ---
> > > > > > > > >
> > > > > > > > > Changes since v20:
> > > > > > > > > * Rename AT_CHECK to AT_EXECVE_CHECK, requested by Amir G=
oldstein and
> > > > > > > > >   Serge Hallyn.
> > > > > > > > > * Move the UAPI documentation to a dedicated RST file.
> > > > > > > > > * Add Reviewed-by: Serge Hallyn
> > > > > > > > >
> > > > > > > > > Changes since v19:
> > > > > > > > > * Remove mention of "role transition" as suggested by And=
y.
> > > > > > > > > * Highlight the difference between security_bprm_creds_fo=
r_exec() and
> > > > > > > > >   the __FMODE_EXEC check for LSMs (in commit message and =
LSM's hooks) as
> > > > > > > > >   discussed with Jeff.
> > > > > > > > > * Improve documentation both in UAPI comments and kernel =
comments
> > > > > > > > >   (requested by Kees).
> > > > > > > > >
> > > > > > > > > New design since v18:
> > > > > > > > > https://lore.kernel.org/r/20220104155024.48023-3-mic@digi=
kod.net
> > > > > > > > > ---
> > > > > > > > >  Documentation/userspace-api/check_exec.rst | 34 ++++++++=
++++++++++++++
> > > > > > > > >  Documentation/userspace-api/index.rst      |  1 +
> > > > > > > > >  fs/exec.c                                  | 20 ++++++++=
+++--
> > > > > > > > >  include/linux/binfmts.h                    |  7 ++++-
> > > > > > > > >  include/uapi/linux/fcntl.h                 |  4 +++
> > > > > > > > >  kernel/audit.h                             |  1 +
> > > > > > > > >  kernel/auditsc.c                           |  1 +
> > > > > > > > >  security/security.c                        | 10 +++++++
> > > > > > > > >  8 files changed, 75 insertions(+), 3 deletions(-)
> > > > > > > > >  create mode 100644 Documentation/userspace-api/check_exe=
c.rst
> > > > > > > > >
> > > > > > > > > diff --git a/Documentation/userspace-api/check_exec.rst b=
/Documentation/userspace-api/check_exec.rst
> > > > > > > > > new file mode 100644
> > > > > > > > > index 000000000000..ad1aeaa5f6c0
> > > > > > > > > --- /dev/null
> > > > > > > > > +++ b/Documentation/userspace-api/check_exec.rst
> > > > > > > > > @@ -0,0 +1,34 @@
> > > > > > > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> > > > > > > > > +Executability check
> > > > > > > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> > > > > > > > > +
> > > > > > > > > +AT_EXECVE_CHECK
> > > > > > > > > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > > > > > > > > +
> > > > > > > > > +Passing the ``AT_EXECVE_CHECK`` flag to :manpage:`execve=
at(2)` only performs a
> > > > > > > > > +check on a regular file and returns 0 if execution of th=
is file would be
> > > > > > > > > +allowed, ignoring the file format and then the related i=
nterpreter dependencies
> > > > > > > > > +(e.g. ELF libraries, script's shebang).
> > > > > > > > > +
> > > > > > > > > +Programs should always perform this check to apply kerne=
l-level checks against
> > > > > > > > > +files that are not directly executed by the kernel but p=
assed to a user space
> > > > > > > > > +interpreter instead.  All files that contain executable =
code, from the point of
> > > > > > > > > +view of the interpreter, should be checked.  However the=
 result of this check
> > > > > > > > > +should only be enforced according to ``SECBIT_EXEC_RESTR=
ICT_FILE`` or
> > > > > > > > > +``SECBIT_EXEC_DENY_INTERACTIVE.``.
> > > > > > > > Regarding "should only"
> > > > > > > > Userspace (e.g. libc) could decide to enforce even when
> > > > > > > > SECBIT_EXEC_RESTRICT_FILE=3D0), i.e. if it determines not-e=
nforcing
> > > > > > > > doesn't make sense.
> > > > > > >
> > > > > > > User space is always in control, but I don't think it would b=
e wise to
> > > > > > > not follow the configuration securebits (in a generic system)=
 because
> > > > > > > this could result to unattended behaviors (I don't have a spe=
cific one
> > > > > > > in mind but...).  That being said, configuration and checks a=
re
> > > > > > > standalones and specific/tailored systems are free to do the =
checks they
> > > > > > > want.
> > > > > > >
> > > > > > In the case of dynamic linker, we can always enforce honoring t=
he
> > > > > > execveat(AT_EXECVE_CHECK) result, right ? I can't think of a ca=
se not
> > > > > > to,  the dynamic linker doesn't need to check the
> > > > > > SECBIT_EXEC_RESTRICT_FILE bit.
> > > > >
> > > > > If the library file is not allowed to be executed by *all* access
> > > > > control systems (not just mount and file permission, but all LSMs=
), then
> > > > > the AT_EXECVE_CHECK will fail, which is OK as long as it is not a=
 hard
> > > > > requirement.
> > > > Yes. specifically for the library loading case, I can't think of a
> > > > case where we need to by-pass LSMs.  (letting user space to by-pass
> > > > LSM check seems questionable in concept, and should only be used wh=
en
> > > > there aren't other solutions). In the context of SELINUX enforcing
> > > > mode,  we will want to enforce it. In the context of process level =
LSM
> > > > such as landlock,  the process can already decide for itself by
> > > > selecting the policy for its own domain, it is unnecessary to use
> > > > another opt-out solution.
> > >
> > > My answer wasn't clear.  The execveat(AT_EXECVE_CHECK) can and should
> > > always be done, but user space should only enforce restrictions
> > > according to the securebits.
> > >
> > I knew this part (AT_EXESCVE_CHECK is called always)
> > Since the securebits are enforced by userspace, setting it to 0 is
> > equivalent to opt-out enforcement, that is what I meant by opt-out.
>
> OK, that was confusing because these bits are set to 0 by default (for
> compatibility reasons).
>
> >
> > > It doesn't make sense to talk about user space "bypassing" kernel
> > > checks.  This patch series provides a feature to enable user space to
> > > enforce (at its level) the same checks as the kernel.
> > >
> > > There is no opt-out solution, but compatibility configuration bits
> > > through securebits (which can also be set by LSMs).
> > >
> > > To answer your question about the dynamic linker, there should be no
> > > difference of behavior with a script interpreter.  Both should check
> > > executability but only enforce restriction according to the securebit=
s
> > > (as explained in the documentation).  Doing otherwise on a generic
> > > distro could lead to unexpected behaviors (e.g. if a user enforced a
> > > specific SELinux policy that doesn't allow execution of library files=
).
> > >
> > > >
> > > > There is one case where I see a difference:
> > > > ld.so a.out (when a.out is on non-exec mount)
> > > >
> > > > If the dynamic linker doesn't read SECBIT_EXEC_RESTRICT_FILE settin=
g,
> > > > above will always fail. But that is more of a bugfix.
> > >
> > > No, the dynamic linker should only enforce restrictions according to =
the
> > > securebits, otherwise a user space update (e.g. with a new dynamic
> > > linker ignoring the securebits) could break an existing system.
> > >
> > OK. upgrade is a valid concern. Previously, I was just thinking about
> > a new LSM based on this check, not existing LSM policies.
> > Do you happen to know which SELinux policy/LSM could break ? i.e. it
> > will be applied to libraries once we add AT_EXESCVE_CHECK in the
> > dynamic linker.
>
> We cannot assume anything about LSM policies because of custom and
> private ones.
>
That is a good point.

> > We could give heads up and prepare for that.
> >
> > > >
> > > > >Relying on the securebits to know if this is a hard
> > > > > requirement or not enables system administrator and distros to co=
ntrol
> > > > > this potential behavior change.
> > > > >
> > > > I think, for the dynamic linker, it can be a hard requirement.
> > >
> > > Not on a generic distro.
> > >
> > Ok. Maybe this can be done through a configuration option for the
> > dynamic linker.
>
> Yes, we could have a built-time option (disabled by default) for the
> dynamic linker to enforce that.
>
> >
> > The consideration I have is: securebits is currently designed to
> > control both dynamic linker and shell scripts.
> > The case for dynamic linker is simpler than scripts cases, (non-exec
> > mount, and perhaps some LSM policies for libraries) and distributions
> > such as ChromeOS can enforce the dynamic linker case ahead of scripts
> > interrupter cases, i.e. without waiting for python/shell being
> > upgraded, that can take sometimes.
>
> For secure systems, the end goal is to always enforce such restrictions,
> so once interpretation/execution of a set of file types (e.g. ELF
> libraries) are tested enough in such a system, we can remove the
> securebits checks for the related library/executable (e.g. ld.so) and
> consider that they are always set, independently of the current
> user/credentials.
Great! I agree with that.

Thanks.
