Return-Path: <kernel-hardening-return-21758-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 2683592A87A
	for <lists+kernel-hardening@lfdr.de>; Mon,  8 Jul 2024 19:54:10 +0200 (CEST)
Received: (qmail 1845 invoked by uid 550); 8 Jul 2024 17:53:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1825 invoked from network); 8 Jul 2024 17:53:58 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720461230; x=1721066030; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S3iukyGY/BvvExHHA5iKe3vA1LJWdwn37FnnTjaIVHQ=;
        b=bAe817IlPkvMPka0pwP+HHo9TKKWct43v7ocHNTLvQJTLnJSC0AMq9LrmP/QPrtcKE
         X4hER0kZmfoWzCOhW7hNI9BVmADpAyhLk8HrfVdspFoJOGVI4M+aJ5o/5Jl1qdW08MSB
         vDoNVpWF0dqHDpG2C4mHRwMWNNjbQ/6URY40Z6OX0mLNsl495BoMN8I0kXoQPSQloNoX
         HgQgay5cxvYuue5FFfK4otGM87U6/cWBpMvCYJ2AFNdDeo0sHlRqeusd/tS6WE9/nKfa
         bIgvaQTl//mnqx5p8yVr+HIwvKUjJVsytMxJbxPnE3NlAwAr+nUGgqhvtoYVJKRUvSCP
         xMbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720461230; x=1721066030;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S3iukyGY/BvvExHHA5iKe3vA1LJWdwn37FnnTjaIVHQ=;
        b=Snz/nAazuIYsLySaoE+TAhWaBir9V4/ftxoZYbcTzkJze+y1VQm/Sofj3/AQa2OFLX
         UPy+XgH6/CzXMh5OzdMXqyz7n5X2aN1TebaROsoIqNaqQLACa63h8GSvpo5wytraraFC
         pUyhNZZ1zlLqnQwbUzv7fVWVOMp1+1M1JdBnttp1n9qI1dECIwXqZsgUj/bmiETlnFB0
         DZWPS4UklqenZ9PMjvvlZ+K4Cwx/mCUFZIVSSpctImCIlhnL/K/zNagsq6xDAYE5wRwE
         ktRDK5WokNh1LIACrJ0LSPSdK9OafJbccsi056RlfyEC5SGhYmSoUo8TbWLmnjXhte25
         7KCw==
X-Forwarded-Encrypted: i=1; AJvYcCXuA42MGRRqGqjvmIoU8aWowfl+GkxfRbGQ99C02Ccr6AiKSE9F7HNN6KzpAQV+xYzti5Z3TlZjpX6lMA3V9owutfT29S4y+2gX3WT4rgL9r2CAZA==
X-Gm-Message-State: AOJu0Yw9fA+Z2klCj2pa1nlY4MUcgWb7XtiyvICwBFQ2bNFSEhNYOHEX
	gFYnLGmZJXimZsSbeR6vp0zUcDsFodABmlsIqNdNk8jJu8E7QOFDQil8+tPrrQinkFdXmnaLFue
	s/dcXlKjT7QUV6y7EChCWzKN6kVwqbAFS6gfs
X-Google-Smtp-Source: AGHT+IGCxCI8BZYpKRwfqjmfBRiI0yinmXSJ2UDS50+8jgqFrfyLYmBIj0Sr4PfXC2bn4uG4lbt5DOwFV03GrDTYrwU=
X-Received: by 2002:a05:600c:68cd:b0:424:898b:522b with SMTP id
 5b1f17b1804b1-42671c24e4fmr48555e9.1.1720461229674; Mon, 08 Jul 2024 10:53:49
 -0700 (PDT)
MIME-Version: 1.0
References: <20240704190137.696169-1-mic@digikod.net> <20240704190137.696169-3-mic@digikod.net>
 <CALmYWFscz5W6xSXD-+dimzbj=TykNJEDa0m5gvBx93N-J+3nKA@mail.gmail.com>
In-Reply-To: <CALmYWFscz5W6xSXD-+dimzbj=TykNJEDa0m5gvBx93N-J+3nKA@mail.gmail.com>
From: Jeff Xu <jeffxu@google.com>
Date: Mon, 8 Jul 2024 10:53:11 -0700
Message-ID: <CALmYWFsLUhkU5u1NKH8XWvSxbFKFOEq+A_eqLeDsN29xOEAYgg@mail.gmail.com>
Subject: Re: [RFC PATCH v19 2/5] security: Add new SHOULD_EXEC_CHECK and
 SHOULD_EXEC_RESTRICT securebits
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Paul Moore <paul@paul-moore.com>, "Theodore Ts'o" <tytso@mit.edu>, 
	Alejandro Colomar <alx.manpages@gmail.com>, Aleksa Sarai <cyphar@cyphar.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, 
	Christian Heimes <christian@python.org>, Dmitry Vyukov <dvyukov@google.com>, 
	Eric Biggers <ebiggers@kernel.org>, Eric Chiang <ericchiang@google.com>, 
	Fan Wu <wufan@linux.microsoft.com>, Florian Weimer <fweimer@redhat.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, James Morris <jamorris@linux.microsoft.com>, 
	Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Jordan R Abrahams <ajordanr@google.com>, Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, 
	Luca Boccassi <bluca@debian.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Matthew Garrett <mjg59@srcf.ucam.org>, Matthew Wilcox <willy@infradead.org>, 
	Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>, Scott Shell <scottsh@microsoft.com>, 
	Shuah Khan <shuah@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, 
	Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, 
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, 
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Xiaoming Ni <nixiaoming@huawei.com>, 
	Yin Fengwei <fengwei.yin@intel.com>, kernel-hardening@lists.openwall.com, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 8, 2024 at 9:17=E2=80=AFAM Jeff Xu <jeffxu@google.com> wrote:
>
> Hi
>
> On Thu, Jul 4, 2024 at 12:02=E2=80=AFPM Micka=C3=ABl Sala=C3=BCn <mic@dig=
ikod.net> wrote:
> >
> > These new SECBIT_SHOULD_EXEC_CHECK, SECBIT_SHOULD_EXEC_RESTRICT, and
> > their *_LOCKED counterparts are designed to be set by processes setting
> > up an execution environment, such as a user session, a container, or a
> > security sandbox.  Like seccomp filters or Landlock domains, the
> > securebits are inherited across proceses.
> >
> > When SECBIT_SHOULD_EXEC_CHECK is set, programs interpreting code should
> > check executable resources with execveat(2) + AT_CHECK (see previous
> > patch).
> >
> > When SECBIT_SHOULD_EXEC_RESTRICT is set, a process should only allow
> > execution of approved resources, if any (see SECBIT_SHOULD_EXEC_CHECK).
> >
> Do we need both bits ?
> When CHECK is set and RESTRICT is not, the "check fail" executable
> will still get executed, so CHECK is for logging ?
> Does RESTRICT imply CHECK is set, e.g. What if CHECK=3D0 and RESTRICT =3D=
 1 ?
>
The intention might be "permissive mode"?  if so, consider reuse
existing selinux's concept, and still with 2 bits:
SECBIT_SHOULD_EXEC_RESTRICT
SECBIT_SHOULD_EXEC_RESTRICT_PERMISSIVE


-Jeff




> > For a secure environment, we might also want
> > SECBIT_SHOULD_EXEC_CHECK_LOCKED and SECBIT_SHOULD_EXEC_RESTRICT_LOCKED
> > to be set.  For a test environment (e.g. testing on a fleet to identify
> > potential issues), only the SECBIT_SHOULD_EXEC_CHECK* bits can be set t=
o
> > still be able to identify potential issues (e.g. with interpreters logs
> > or LSMs audit entries).
> >
> > It should be noted that unlike other security bits, the
> > SECBIT_SHOULD_EXEC_CHECK and SECBIT_SHOULD_EXEC_RESTRICT bits are
> > dedicated to user space willing to restrict itself.  Because of that,
> > they only make sense in the context of a trusted environment (e.g.
> > sandbox, container, user session, full system) where the process
> > changing its behavior (according to these bits) and all its parent
> > processes are trusted.  Otherwise, any parent process could just execut=
e
> > its own malicious code (interpreting a script or not), or even enforce =
a
> > seccomp filter to mask these bits.
> >
> > Such a secure environment can be achieved with an appropriate access
> > control policy (e.g. mount's noexec option, file access rights, LSM
> > configuration) and an enlighten ld.so checking that libraries are
> > allowed for execution e.g., to protect against illegitimate use of
> > LD_PRELOAD.
> >
> > Scripts may need some changes to deal with untrusted data (e.g. stdin,
> > environment variables), but that is outside the scope of the kernel.
> >
> > The only restriction enforced by the kernel is the right to ptrace
> > another process.  Processes are denied to ptrace less restricted ones,
> > unless the tracer has CAP_SYS_PTRACE.  This is mainly a safeguard to
> > avoid trivial privilege escalations e.g., by a debugging process being
> > abused with a confused deputy attack.
> >
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Christian Brauner <brauner@kernel.org>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Paul Moore <paul@paul-moore.com>
> > Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> > Link: https://lore.kernel.org/r/20240704190137.696169-3-mic@digikod.net
> > ---
> >
> > New design since v18:
> > https://lore.kernel.org/r/20220104155024.48023-3-mic@digikod.net
> > ---
> >  include/uapi/linux/securebits.h | 56 ++++++++++++++++++++++++++++-
> >  security/commoncap.c            | 63 ++++++++++++++++++++++++++++-----
> >  2 files changed, 110 insertions(+), 9 deletions(-)
> >
> > diff --git a/include/uapi/linux/securebits.h b/include/uapi/linux/secur=
ebits.h
> > index d6d98877ff1a..3fdb0382718b 100644
> > --- a/include/uapi/linux/securebits.h
> > +++ b/include/uapi/linux/securebits.h
> > @@ -52,10 +52,64 @@
> >  #define SECBIT_NO_CAP_AMBIENT_RAISE_LOCKED \
> >                         (issecure_mask(SECURE_NO_CAP_AMBIENT_RAISE_LOCK=
ED))
> >
> > +/*
> > + * When SECBIT_SHOULD_EXEC_CHECK is set, a process should check all ex=
ecutable
> > + * files with execveat(2) + AT_CHECK.  However, such check should only=
 be
> > + * performed if all to-be-executed code only comes from regular files.=
  For
> > + * instance, if a script interpreter is called with both a script snip=
ped as
> > + * argument and a regular file, the interpreter should not check any f=
ile.
> > + * Doing otherwise would mislead the kernel to think that only the scr=
ipt file
> > + * is being executed, which could for instance lead to unexpected perm=
ission
> > + * change and break current use cases.
> > + *
> > + * This secure bit may be set by user session managers, service manage=
rs,
> > + * container runtimes, sandboxer tools...  Except for test environment=
s, the
> > + * related SECBIT_SHOULD_EXEC_CHECK_LOCKED bit should also be set.
> > + *
> > + * Ptracing another process is deny if the tracer has SECBIT_SHOULD_EX=
EC_CHECK
> > + * but not the tracee.  SECBIT_SHOULD_EXEC_CHECK_LOCKED also checked.
> > + */
> > +#define SECURE_SHOULD_EXEC_CHECK               8
> > +#define SECURE_SHOULD_EXEC_CHECK_LOCKED                9  /* make bit-=
8 immutable */
> > +
> > +#define SECBIT_SHOULD_EXEC_CHECK (issecure_mask(SECURE_SHOULD_EXEC_CHE=
CK))
> > +#define SECBIT_SHOULD_EXEC_CHECK_LOCKED \
> > +                       (issecure_mask(SECURE_SHOULD_EXEC_CHECK_LOCKED)=
)
> > +
> > +/*
> > + * When SECBIT_SHOULD_EXEC_RESTRICT is set, a process should only allo=
w
> > + * execution of approved files, if any (see SECBIT_SHOULD_EXEC_CHECK).=
  For
> > + * instance, script interpreters called with a script snippet as argum=
ent
> > + * should always deny such execution if SECBIT_SHOULD_EXEC_RESTRICT is=
 set.
> > + * However, if a script interpreter is called with both
> > + * SECBIT_SHOULD_EXEC_CHECK and SECBIT_SHOULD_EXEC_RESTRICT, they shou=
ld
> > + * interpret the provided script files if no unchecked code is also pr=
ovided
> > + * (e.g. directly as argument).
> > + *
> > + * This secure bit may be set by user session managers, service manage=
rs,
> > + * container runtimes, sandboxer tools...  Except for test environment=
s, the
> > + * related SECBIT_SHOULD_EXEC_RESTRICT_LOCKED bit should also be set.
> > + *
> > + * Ptracing another process is deny if the tracer has
> > + * SECBIT_SHOULD_EXEC_RESTRICT but not the tracee.
> > + * SECBIT_SHOULD_EXEC_RESTRICT_LOCKED is also checked.
> > + */
> > +#define SECURE_SHOULD_EXEC_RESTRICT            10
> > +#define SECURE_SHOULD_EXEC_RESTRICT_LOCKED     11  /* make bit-8 immut=
able */
> > +
> > +#define SECBIT_SHOULD_EXEC_RESTRICT (issecure_mask(SECURE_SHOULD_EXEC_=
RESTRICT))
> > +#define SECBIT_SHOULD_EXEC_RESTRICT_LOCKED \
> > +                       (issecure_mask(SECURE_SHOULD_EXEC_RESTRICT_LOCK=
ED))
> > +
> >  #define SECURE_ALL_BITS                (issecure_mask(SECURE_NOROOT) |=
 \
> >                                  issecure_mask(SECURE_NO_SETUID_FIXUP) =
| \
> >                                  issecure_mask(SECURE_KEEP_CAPS) | \
> > -                                issecure_mask(SECURE_NO_CAP_AMBIENT_RA=
ISE))
> > +                                issecure_mask(SECURE_NO_CAP_AMBIENT_RA=
ISE) | \
> > +                                issecure_mask(SECURE_SHOULD_EXEC_CHECK=
) | \
> > +                                issecure_mask(SECURE_SHOULD_EXEC_RESTR=
ICT))
> >  #define SECURE_ALL_LOCKS       (SECURE_ALL_BITS << 1)
> >
> > +#define SECURE_ALL_UNPRIVILEGED (issecure_mask(SECURE_SHOULD_EXEC_CHEC=
K) | \
> > +                                issecure_mask(SECURE_SHOULD_EXEC_RESTR=
ICT))
> > +
> >  #endif /* _UAPI_LINUX_SECUREBITS_H */
> > diff --git a/security/commoncap.c b/security/commoncap.c
> > index 162d96b3a676..34b4493e2a69 100644
> > --- a/security/commoncap.c
> > +++ b/security/commoncap.c
> > @@ -117,6 +117,33 @@ int cap_settime(const struct timespec64 *ts, const=
 struct timezone *tz)
> >         return 0;
> >  }
> >
> > +static bool ptrace_secbits_allowed(const struct cred *tracer,
> > +                                  const struct cred *tracee)
> > +{
> > +       const unsigned long tracer_secbits =3D SECURE_ALL_UNPRIVILEGED =
&
> > +                                            tracer->securebits;
> > +       const unsigned long tracee_secbits =3D SECURE_ALL_UNPRIVILEGED =
&
> > +                                            tracee->securebits;
> > +       /* Ignores locking of unset secure bits (cf. SECURE_ALL_LOCKS).=
 */
> > +       const unsigned long tracer_locked =3D (tracer_secbits << 1) &
> > +                                           tracer->securebits;
> > +       const unsigned long tracee_locked =3D (tracee_secbits << 1) &
> > +                                           tracee->securebits;
> > +
> > +       /* The tracee must not have less constraints than the tracer. *=
/
> > +       if ((tracer_secbits | tracee_secbits) !=3D tracee_secbits)
> > +               return false;
> > +
> > +       /*
> > +        * Makes sure that the tracer's locks for restrictions are the =
same for
> > +        * the tracee.
> > +        */
> > +       if ((tracer_locked | tracee_locked) !=3D tracee_locked)
> > +               return false;
> > +
> > +       return true;
> > +}
> > +
> >  /**
> >   * cap_ptrace_access_check - Determine whether the current process may=
 access
> >   *                        another
> > @@ -146,7 +173,8 @@ int cap_ptrace_access_check(struct task_struct *chi=
ld, unsigned int mode)
> >         else
> >                 caller_caps =3D &cred->cap_permitted;
> >         if (cred->user_ns =3D=3D child_cred->user_ns &&
> > -           cap_issubset(child_cred->cap_permitted, *caller_caps))
> > +           cap_issubset(child_cred->cap_permitted, *caller_caps) &&
> > +           ptrace_secbits_allowed(cred, child_cred))
> >                 goto out;
> >         if (ns_capable(child_cred->user_ns, CAP_SYS_PTRACE))
> >                 goto out;
> > @@ -178,7 +206,8 @@ int cap_ptrace_traceme(struct task_struct *parent)
> >         cred =3D __task_cred(parent);
> >         child_cred =3D current_cred();
> >         if (cred->user_ns =3D=3D child_cred->user_ns &&
> > -           cap_issubset(child_cred->cap_permitted, cred->cap_permitted=
))
> > +           cap_issubset(child_cred->cap_permitted, cred->cap_permitted=
) &&
> > +           ptrace_secbits_allowed(cred, child_cred))
> >                 goto out;
> >         if (has_ns_capability(parent, child_cred->user_ns, CAP_SYS_PTRA=
CE))
> >                 goto out;
> > @@ -1302,21 +1331,39 @@ int cap_task_prctl(int option, unsigned long ar=
g2, unsigned long arg3,
> >                      & (old->securebits ^ arg2))                       =
 /*[1]*/
> >                     || ((old->securebits & SECURE_ALL_LOCKS & ~arg2))  =
 /*[2]*/
> >                     || (arg2 & ~(SECURE_ALL_LOCKS | SECURE_ALL_BITS))  =
 /*[3]*/
> > -                   || (cap_capable(current_cred(),
> > -                                   current_cred()->user_ns,
> > -                                   CAP_SETPCAP,
> > -                                   CAP_OPT_NONE) !=3D 0)              =
   /*[4]*/
> >                         /*
> >                          * [1] no changing of bits that are locked
> >                          * [2] no unlocking of locks
> >                          * [3] no setting of unsupported bits
> > -                        * [4] doing anything requires privilege (go re=
ad about
> > -                        *     the "sendmail capabilities bug")
> >                          */
> >                     )
> >                         /* cannot change a locked bit */
> >                         return -EPERM;
> >
> > +               /*
> > +                * Doing anything requires privilege (go read about the
> > +                * "sendmail capabilities bug"), except for unprivilege=
d bits.
> > +                * Indeed, the SECURE_ALL_UNPRIVILEGED bits are not
> > +                * restrictions enforced by the kernel but by user spac=
e on
> > +                * itself.  The kernel is only in charge of protecting =
against
> > +                * privilege escalation with ptrace protections.
> > +                */
> > +               if (cap_capable(current_cred(), current_cred()->user_ns=
,
> > +                               CAP_SETPCAP, CAP_OPT_NONE) !=3D 0) {
> > +                       const unsigned long unpriv_and_locks =3D
> > +                               SECURE_ALL_UNPRIVILEGED |
> > +                               SECURE_ALL_UNPRIVILEGED << 1;
> > +                       const unsigned long changed =3D old->securebits=
 ^ arg2;
> > +
> > +                       /* For legacy reason, denies non-change. */
> > +                       if (!changed)
> > +                               return -EPERM;
> > +
> > +                       /* Denies privileged changes. */
> > +                       if (changed & ~unpriv_and_locks)
> > +                               return -EPERM;
> > +               }
> > +
> >                 new =3D prepare_creds();
> >                 if (!new)
> >                         return -ENOMEM;
> > --
> > 2.45.2
> >
