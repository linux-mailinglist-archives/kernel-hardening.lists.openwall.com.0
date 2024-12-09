Return-Path: <kernel-hardening-return-21896-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 878519EC4A1
	for <lists+kernel-hardening@lfdr.de>; Wed, 11 Dec 2024 07:13:01 +0100 (CET)
Received: (qmail 1264 invoked by uid 550); 11 Dec 2024 06:12:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1235 invoked from network); 11 Dec 2024 06:12:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1733897563; x=1734502363; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LrstZ9FI7oDoywTSDKrx13VheyHzF0xgj4Fa7hmhx4k=;
        b=ZBdYdcyD7t49TBWFqsQ4czjPD6Ha2n/ufC8wtm8Pl7Ej0P4TJIDgjK7M8gjzPb7KKP
         ucGP3gMHuGF0LVuQf5TScEAp0SXMcFZf1ndGdN3zMQyCDrXPI7orYGEAyZLOEUiX/qaI
         1i7phvkb+/H7HXY0YJCGEX2DclySiwbGCVHT8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733897563; x=1734502363;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LrstZ9FI7oDoywTSDKrx13VheyHzF0xgj4Fa7hmhx4k=;
        b=Sc+85zqa5O+JRntWRNxmFuMCXBfTmkwDv5hDOr3+z8jSWpJONSx8CTdG8YDIN7xj2E
         j2SvyGfdq17HWl/8z4w3hFqrE5NFRbQ62u7zs9oJ/DIP0IFEqMvBvm4rdvKUCwSisubX
         bgQIJ2i8pWYAtDuG/0kFpnOHeJbwRUdhi9/Ru59vXPeuIvs/DEM1dRfyZ4Z/EGITeAm/
         unGUsMIqj+sTfSogvnXYfyU5KuQ+lLa+H/X/B51RfmOEaJGC0peuEanqKFAkVOSbK0mO
         PP+GNQXZklr5FciNRLPT4KMii0Er65lCTTSBzt87XId68wiV/IJxlnOzGWKD3xjwq/T+
         B5sA==
X-Forwarded-Encrypted: i=1; AJvYcCWlKYzo0khTDVVcS/PvLHfCgHDs6tuOCzHg4NjX1w97ktdV0jB6AFrvc6UJ+IPOzSZHzsNi2gBL/N6+7bWhqnoD@lists.openwall.com
X-Gm-Message-State: AOJu0Yw+1BrHJNy92BkZgBCpLxdQ7EIMJ4wqx64SnUoLQ1gcWgemqYQX
	IyqsNazE+G7Av2no/q/ka5b5hAIhdQHCS7TKmacbM2gMLjBR88JRfVrb6vJs29IsjUDLg0RZk+D
	/dLRreDbVr4ZIAzDkEFIdQ0adbyiDajmPO59s
X-Gm-Gg: ASbGnctlJgxrlveEzM/9vLoTYbuQRnLQL6BtPaXgpq6Qq7W1pMf4vA96AU3+FvGRu+U
	6Oq/08zNw6p3rd9qHkKnupdPUrU3ainTY15ojrvQTWHwh+D3P8p3waniaE6MxQKJ5
X-Google-Smtp-Source: AGHT+IFjzapg7E7fLM9DyXss2TEsc/ZVX4eep97+cVt6UEkJnt1fbUvoixTfgps7XXEw1DxxiLeKZ98SLq3qa7Gdo5I=
X-Received: by 2002:a05:6870:c153:b0:295:f266:8aee with SMTP id
 586e51a60fabf-2a012db100emr341140fac.5.1733897562659; Tue, 10 Dec 2024
 22:12:42 -0800 (PST)
MIME-Version: 1.0
References: <20241205160925.230119-1-mic@digikod.net> <20241205160925.230119-3-mic@digikod.net>
 <20241210.FahfahPu5dae@digikod.net>
In-Reply-To: <20241210.FahfahPu5dae@digikod.net>
From: Jeff Xu <jeffxu@chromium.org>
Date: Tue, 10 Dec 2024 22:12:31 -0800
Message-ID: <CABi2SkXMKtD-_3s-HK6W2Qp2-+GaQfckVbXwsaX5FRJGnD_irQ@mail.gmail.com>
Subject: Re: [PATCH v22 2/8] security: Add EXEC_RESTRICT_FILE and
 EXEC_DENY_INTERACTIVE securebits
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Jeff Xu <jeffxu@google.com>, Al Viro <viro@zeniv.linux.org.uk>, 
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
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>, Roberto Sassu <roberto.sassu@huawei.com>, 
	Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>, 
	Shuah Khan <skhan@linuxfoundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, 
	Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, 
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Xiaoming Ni <nixiaoming@huawei.com>, 
	Yin Fengwei <fengwei.yin@intel.com>, kernel-hardening@lists.openwall.com, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 10, 2024 at 8:48=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@digik=
od.net> wrote:
>
> On Thu, Dec 05, 2024 at 05:09:19PM +0100, Micka=C3=ABl Sala=C3=BCn wrote:
> > The new SECBIT_EXEC_RESTRICT_FILE, SECBIT_EXEC_DENY_INTERACTIVE, and
> > their *_LOCKED counterparts are designed to be set by processes setting
> > up an execution environment, such as a user session, a container, or a
> > security sandbox.  Unlike other securebits, these ones can be set by
> > unprivileged processes.  Like seccomp filters or Landlock domains, the
> > securebits are inherited across processes.
> >
> > When SECBIT_EXEC_RESTRICT_FILE is set, programs interpreting code shoul=
d
> > control executable resources according to execveat(2) + AT_EXECVE_CHECK
> > (see previous commit).
> >
> > When SECBIT_EXEC_DENY_INTERACTIVE is set, a process should deny
> > execution of user interactive commands (which excludes executable
> > regular files).
> >
> > Being able to configure each of these securebits enables system
> > administrators or owner of image containers to gradually validate the
> > related changes and to identify potential issues (e.g. with interpreter
> > or audit logs).
> >
> > It should be noted that unlike other security bits, the
> > SECBIT_EXEC_RESTRICT_FILE and SECBIT_EXEC_DENY_INTERACTIVE bits are
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
> > control (e.g. mount's noexec option, file access rights, LSM policy) an=
d
> > an enlighten ld.so checking that libraries are allowed for execution
> > e.g., to protect against illegitimate use of LD_PRELOAD.
> >
> > Ptrace restrictions according to these securebits would not make sense
> > because of the processes' trust assumption.
> >
> > Scripts may need some changes to deal with untrusted data (e.g. stdin,
> > environment variables), but that is outside the scope of the kernel.
> >
> > See chromeOS's documentation about script execution control and the
> > related threat model:
> > https://www.chromium.org/chromium-os/developer-library/guides/security/=
noexec-shell-scripts/
> >
> > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > Cc: Andy Lutomirski <luto@amacapital.net>
> > Cc: Christian Brauner <brauner@kernel.org>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Paul Moore <paul@paul-moore.com>
> > Reviewed-by: Serge Hallyn <serge@hallyn.com>
> > Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> > Link: https://lore.kernel.org/r/20241205160925.230119-3-mic@digikod.net
> > ---
> >
> > Changes since v21:
> > * Extend user documentation with exception regarding tailored execution
> >   environments (e.g. chromeOS's libc) as discussed with Jeff.
> >
> > Changes since v20:
> > * Move UAPI documentation to a dedicated RST file and format it.
> >
> > Changes since v19:
> > * Replace SECBIT_SHOULD_EXEC_CHECK and SECBIT_SHOULD_EXEC_RESTRICT with
> >   SECBIT_EXEC_RESTRICT_FILE and SECBIT_EXEC_DENY_INTERACTIVE:
> >   https://lore.kernel.org/all/20240710.eiKohpa4Phai@digikod.net/
> > * Remove the ptrace restrictions, suggested by Andy.
> > * Improve documentation according to the discussion with Jeff.
> >
> > New design since v18:
> > https://lore.kernel.org/r/20220104155024.48023-3-mic@digikod.net
> > ---
> >  Documentation/userspace-api/check_exec.rst | 107 +++++++++++++++++++++
> >  include/uapi/linux/securebits.h            |  24 ++++-
> >  security/commoncap.c                       |  29 ++++--
> >  3 files changed, 153 insertions(+), 7 deletions(-)
> >
> > diff --git a/Documentation/userspace-api/check_exec.rst b/Documentation=
/userspace-api/check_exec.rst
> > index 393dd7ca19c4..05dfe3b56f71 100644
> > --- a/Documentation/userspace-api/check_exec.rst
> > +++ b/Documentation/userspace-api/check_exec.rst
> > @@ -5,6 +5,31 @@
> >  Executability check
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > +The ``AT_EXECVE_CHECK`` :manpage:`execveat(2)` flag, and the
> > +``SECBIT_EXEC_RESTRICT_FILE`` and ``SECBIT_EXEC_DENY_INTERACTIVE`` sec=
urebits
> > +are intended for script interpreters and dynamic linkers to enforce a
> > +consistent execution security policy handled by the kernel.  See the
> > +`samples/check-exec/inc.c`_ example.
> > +
> > +Whether an interpreter should check these securebits or not depends on=
 the
> > +security risk of running malicious scripts with respect to the executi=
on
> > +environment, and whether the kernel can check if a script is trustwort=
hy or
> > +not.  For instance, Python scripts running on a server can use arbitra=
ry
> > +syscalls and access arbitrary files.  Such interpreters should then be
> > +enlighten to use these securebits and let users define their security =
policy.
> > +However, a JavaScript engine running in a web browser should already b=
e
> > +sandboxed and then should not be able to harm the user's environment.
> > +
> > +Script interpreters or dynamic linkers built for tailored execution en=
vironments
> > +(e.g. hardened Linux distributions or hermetic container images) could=
 use
> > +``AT_EXECVE_CHECK`` without checking the related securebits if backwar=
d
> > +compatibility is handled by something else (e.g. atomic update ensurin=
g that
> > +all legitimate libraries are allowed to be executed).  It is then reco=
mmended
> > +for script interpreters and dynamic linkers to check the securebits at=
 run time
> > +by default, but also to provide the ability for custom builds to behav=
e like if
> > +``SECBIT_EXEC_RESTRICT_FILE`` or ``SECBIT_EXEC_DENY_INTERACTIVE`` were=
 always
> > +set to 1 (i.e. always enforce restrictions).
>
> Jeff, does this work for you?
>
Yes. Thanks for updating this section.


> I'll update the IMA patch with a last version but otherwise it should be
> good: https://lore.kernel.org/all/20241210.Wie6ion7Aich@digikod.net/
>
> > +
> >  AT_EXECVE_CHECK
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > @@ -35,3 +60,85 @@ be executable, which also requires integrity guarant=
ees.
> >  To avoid race conditions leading to time-of-check to time-of-use issue=
s,
> >  ``AT_EXECVE_CHECK`` should be used with ``AT_EMPTY_PATH`` to check aga=
inst a
> >  file descriptor instead of a path.
> > +
> > +SECBIT_EXEC_RESTRICT_FILE and SECBIT_EXEC_DENY_INTERACTIVE
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +When ``SECBIT_EXEC_RESTRICT_FILE`` is set, a process should only inter=
pret or
> > +execute a file if a call to :manpage:`execveat(2)` with the related fi=
le
> > +descriptor and the ``AT_EXECVE_CHECK`` flag succeed.
> > +
> > +This secure bit may be set by user session managers, service managers,
> > +container runtimes, sandboxer tools...  Except for test environments, =
the
> > +related ``SECBIT_EXEC_RESTRICT_FILE_LOCKED`` bit should also be set.
> > +
> > +Programs should only enforce consistent restrictions according to the
> > +securebits but without relying on any other user-controlled configurat=
ion.
> > +Indeed, the use case for these securebits is to only trust executable =
code
> > +vetted by the system configuration (through the kernel), so we should =
be
> > +careful to not let untrusted users control this configuration.
> > +
> > +However, script interpreters may still use user configuration such as
> > +environment variables as long as it is not a way to disable the secure=
bits
> > +checks.  For instance, the ``PATH`` and ``LD_PRELOAD`` variables can b=
e set by
> > +a script's caller.  Changing these variables may lead to unintended co=
de
> > +executions, but only from vetted executable programs, which is OK.  Fo=
r this to
> > +make sense, the system should provide a consistent security policy to =
avoid
> > +arbitrary code execution e.g., by enforcing a write xor execute policy=
.
> > +
> > +When ``SECBIT_EXEC_DENY_INTERACTIVE`` is set, a process should never i=
nterpret
> > +interactive user commands (e.g. scripts).  However, if such commands a=
re passed
> > +through a file descriptor (e.g. stdin), its content should be interpre=
ted if a
> > +call to :manpage:`execveat(2)` with the related file descriptor and th=
e
> > +``AT_EXECVE_CHECK`` flag succeed.
> > +
> > +For instance, script interpreters called with a script snippet as argu=
ment
> > +should always deny such execution if ``SECBIT_EXEC_DENY_INTERACTIVE`` =
is set.
> > +
> > +This secure bit may be set by user session managers, service managers,
> > +container runtimes, sandboxer tools...  Except for test environments, =
the
> > +related ``SECBIT_EXEC_DENY_INTERACTIVE_LOCKED`` bit should also be set=
.
> > +
> > +Here is the expected behavior for a script interpreter according to co=
mbination
> > +of any exec securebits:
> > +
> > +1. ``SECBIT_EXEC_RESTRICT_FILE=3D0`` and ``SECBIT_EXEC_DENY_INTERACTIV=
E=3D0``
> > +
> > +   Always interpret scripts, and allow arbitrary user commands (defaul=
t).
> > +
> > +   No threat, everyone and everything is trusted, but we can get ahead=
 of
> > +   potential issues thanks to the call to :manpage:`execveat(2)` with
> > +   ``AT_EXECVE_CHECK`` which should always be performed but ignored by=
 the
> > +   script interpreter.  Indeed, this check is still important to enabl=
e systems
> > +   administrators to verify requests (e.g. with audit) and prepare for
> > +   migration to a secure mode.
> > +
> > +2. ``SECBIT_EXEC_RESTRICT_FILE=3D1`` and ``SECBIT_EXEC_DENY_INTERACTIV=
E=3D0``
> > +
> > +   Deny script interpretation if they are not executable, but allow
> > +   arbitrary user commands.
> > +
> > +   The threat is (potential) malicious scripts run by trusted (and not=
 fooled)
> > +   users.  That can protect against unintended script executions (e.g.=
 ``sh
> > +   /tmp/*.sh``).  This makes sense for (semi-restricted) user sessions=
.
> > +
> > +3. ``SECBIT_EXEC_RESTRICT_FILE=3D0`` and ``SECBIT_EXEC_DENY_INTERACTIV=
E=3D1``
> > +
> > +   Always interpret scripts, but deny arbitrary user commands.
> > +
> > +   This use case may be useful for secure services (i.e. without inter=
active
> > +   user session) where scripts' integrity is verified (e.g.  with IMA/=
EVM or
> > +   dm-verity/IPE) but where access rights might not be ready yet.  Ind=
eed,
> > +   arbitrary interactive commands would be much more difficult to chec=
k.
> > +
> > +4. ``SECBIT_EXEC_RESTRICT_FILE=3D1`` and ``SECBIT_EXEC_DENY_INTERACTIV=
E=3D1``
> > +
> > +   Deny script interpretation if they are not executable, and also den=
y
> > +   any arbitrary user commands.
> > +
> > +   The threat is malicious scripts run by untrusted users (but trusted=
 code).
> > +   This makes sense for system services that may only execute trusted =
scripts.
> > +
> > +.. Links
> > +.. _samples/check-exec/inc.c:
> > +   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/=
tree/samples/check-exec/inc.c
>
Reviewed-by: Jeff Xu < jeffxu@chromium.org>
Tested-by: Jeff Xu <jeffxu@chromium.org>
