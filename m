Return-Path: <kernel-hardening-return-21864-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 4BDAD9D321E
	for <lists+kernel-hardening@lfdr.de>; Wed, 20 Nov 2024 03:15:34 +0100 (CET)
Received: (qmail 21908 invoked by uid 550); 20 Nov 2024 02:15:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 11278 invoked from network); 20 Nov 2024 01:17:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1732065432; x=1732670232; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f0/+ZctWYM9Y/KKM/ZDlZtGSjDKwWoe5S/p7f3rpjHA=;
        b=iB5YZS8lSzbxvejeg4FhTKAQ/7oWH+Ltu2eukQ0sTwAHFrIZtHJSLZpGjabo+6lHfn
         4Z353T5dJCHLatBA2wLmdaM/CadinOKak+4cSPmfUCXs8C3Wxyxv4a9/Yv3TlIs8iFJy
         ZK9nTWRZsSs0yURvn2wDIrTNyDg8iZxhseYdQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732065432; x=1732670232;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f0/+ZctWYM9Y/KKM/ZDlZtGSjDKwWoe5S/p7f3rpjHA=;
        b=iz0ii/oyorI8A6qfq/BDj4S3Y0G1a+ATunObFVzOzrd0CBInjM2NDT5Nlo4zGYUI1n
         XVvQCg/TDi7UUqAnhP4AN+abNsIiGbEHvyk+6zkSjF+HUMsj/FRab3t282F/6OdnxCFI
         wvFv5929oE2xNMv5eX4Agv/EK4Ju6Ug8MqvpfNlYp1zHUDe59y7RGe8wTxF4TvXEM/88
         igfvWzh6R5IYfeyVtnecVswR3XzuqOBStyP0iDFXiC6E7ANeRzl+Qv4Xad29NL0HUbWu
         9QEV9taLkyqFZRCw62X8F11+c2V7wBTBOj9ZHnr0Mjqbf2lK3xnf9k8THQU5gNmfntfz
         bitQ==
X-Forwarded-Encrypted: i=1; AJvYcCXLBzLxb1IAg8KCn/uIwzCn+FOPGGmsqtrlx5g7KvnhhHlfe3GSYEHuaNc73roNP4s7XHRwu+QPAaGY2M2X3cDp@lists.openwall.com
X-Gm-Message-State: AOJu0YxzCgfJ/BvpUsm7Qnd0zm4MUnN2mBQZwhVgBU+NEghIXcr43AVc
	wZEqB5my3b96+Q5lWLR/nd5l90jU2sSUlZPBCZJO92lzDcxkyTxalylSNxMSTvc80i5Ah0Wb/4f
	55Yo/+DmimCvGUoQvzovce+9mZz3250zapR/A
X-Gm-Gg: ASbGncsmoW9jwLUo/0ytoq6evtOyBHblCqKKp2Z4xhctvO0zEk8zCUKSpmWR7gpkj9g
	2F2ZoATScwhmVx1VL73ZMZiN5jHM/+JKKqo+qUNGD4ghYogTBuS41qQCZWj9C
X-Google-Smtp-Source: AGHT+IFNb9RyZIrtS23aIliyUQtzdQCmPEsQ7UGm3h2VzLjVaD+5N13OVrfzHyOt90pkjtv/ch3KbKkRx1emuelVyks=
X-Received: by 2002:a4a:c487:0:b0:5e1:dec2:389d with SMTP id
 006d021491bc7-5eee7ed5272mr157644eaf.0.1732065432091; Tue, 19 Nov 2024
 17:17:12 -0800 (PST)
MIME-Version: 1.0
References: <20241112191858.162021-1-mic@digikod.net> <20241112191858.162021-2-mic@digikod.net>
In-Reply-To: <20241112191858.162021-2-mic@digikod.net>
From: Jeff Xu <jeffxu@chromium.org>
Date: Tue, 19 Nov 2024 17:17:00 -0800
Message-ID: <CABi2SkVRJC_7qoU56mDt3Ch7U9GnVeRogUt9wc9=32OtG6aatw@mail.gmail.com>
Subject: Re: [PATCH v21 1/6] exec: Add a new AT_EXECVE_CHECK flag to execveat(2)
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, 
	Serge Hallyn <serge@hallyn.com>, Adhemerval Zanella Netto <adhemerval.zanella@linaro.org>, 
	Alejandro Colomar <alx@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>, 
	Christian Heimes <christian@python.org>, Dmitry Vyukov <dvyukov@google.com>, 
	Elliott Hughes <enh@google.com>, Eric Biggers <ebiggers@kernel.org>, 
	Eric Chiang <ericchiang@google.com>, Fan Wu <wufan@linux.microsoft.com>, 
	Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	James Morris <jamorris@linux.microsoft.com>, Jan Kara <jack@suse.cz>, 
	Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@google.com>, Jonathan Corbet <corbet@lwn.net>, 
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
	linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 12, 2024 at 11:22=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@digi=
kod.net> wrote:
>
> Add a new AT_EXECVE_CHECK flag to execveat(2) to check if a file would
> be allowed for execution.  The main use case is for script interpreters
> and dynamic linkers to check execution permission according to the
> kernel's security policy. Another use case is to add context to access
> logs e.g., which script (instead of interpreter) accessed a file.  As
> any executable code, scripts could also use this check [1].
>
> This is different from faccessat(2) + X_OK which only checks a subset of
> access rights (i.e. inode permission and mount options for regular
> files), but not the full context (e.g. all LSM access checks).  The main
> use case for access(2) is for SUID processes to (partially) check access
> on behalf of their caller.  The main use case for execveat(2) +
> AT_EXECVE_CHECK is to check if a script execution would be allowed,
> according to all the different restrictions in place.  Because the use
> of AT_EXECVE_CHECK follows the exact kernel semantic as for a real
> execution, user space gets the same error codes.
>
> An interesting point of using execveat(2) instead of openat2(2) is that
> it decouples the check from the enforcement.  Indeed, the security check
> can be logged (e.g. with audit) without blocking an execution
> environment not yet ready to enforce a strict security policy.
>
> LSMs can control or log execution requests with
> security_bprm_creds_for_exec().  However, to enforce a consistent and
> complete access control (e.g. on binary's dependencies) LSMs should
> restrict file executability, or mesure executed files, with
> security_file_open() by checking file->f_flags & __FMODE_EXEC.
>
> Because AT_EXECVE_CHECK is dedicated to user space interpreters, it
> doesn't make sense for the kernel to parse the checked files, look for
> interpreters known to the kernel (e.g. ELF, shebang), and return ENOEXEC
> if the format is unknown.  Because of that, security_bprm_check() is
> never called when AT_EXECVE_CHECK is used.
>
> It should be noted that script interpreters cannot directly use
> execveat(2) (without this new AT_EXECVE_CHECK flag) because this could
> lead to unexpected behaviors e.g., `python script.sh` could lead to Bash
> being executed to interpret the script.  Unlike the kernel, script
> interpreters may just interpret the shebang as a simple comment, which
> should not change for backward compatibility reasons.
>
> Because scripts or libraries files might not currently have the
> executable permission set, or because we might want specific users to be
> allowed to run arbitrary scripts, the following patch provides a dynamic
> configuration mechanism with the SECBIT_EXEC_RESTRICT_FILE and
> SECBIT_EXEC_DENY_INTERACTIVE securebits.
>
> This is a redesign of the CLIP OS 4's O_MAYEXEC:
> https://github.com/clipos-archive/src_platform_clip-patches/blob/f5cb330d=
6b684752e403b4e41b39f7004d88e561/1901_open_mayexec.patch
> This patch has been used for more than a decade with customized script
> interpreters.  Some examples can be found here:
> https://github.com/clipos-archive/clipos4_portage-overlay/search?q=3DO_MA=
YEXEC
>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Paul Moore <paul@paul-moore.com>
> Reviewed-by: Serge Hallyn <serge@hallyn.com>
> Link: https://docs.python.org/3/library/io.html#io.open_code [1]
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> Link: https://lore.kernel.org/r/20241112191858.162021-2-mic@digikod.net
> ---
>
> Changes since v20:
> * Rename AT_CHECK to AT_EXECVE_CHECK, requested by Amir Goldstein and
>   Serge Hallyn.
> * Move the UAPI documentation to a dedicated RST file.
> * Add Reviewed-by: Serge Hallyn
>
> Changes since v19:
> * Remove mention of "role transition" as suggested by Andy.
> * Highlight the difference between security_bprm_creds_for_exec() and
>   the __FMODE_EXEC check for LSMs (in commit message and LSM's hooks) as
>   discussed with Jeff.
> * Improve documentation both in UAPI comments and kernel comments
>   (requested by Kees).
>
> New design since v18:
> https://lore.kernel.org/r/20220104155024.48023-3-mic@digikod.net
> ---
>  Documentation/userspace-api/check_exec.rst | 34 ++++++++++++++++++++++
>  Documentation/userspace-api/index.rst      |  1 +
>  fs/exec.c                                  | 20 +++++++++++--
>  include/linux/binfmts.h                    |  7 ++++-
>  include/uapi/linux/fcntl.h                 |  4 +++
>  kernel/audit.h                             |  1 +
>  kernel/auditsc.c                           |  1 +
>  security/security.c                        | 10 +++++++
>  8 files changed, 75 insertions(+), 3 deletions(-)
>  create mode 100644 Documentation/userspace-api/check_exec.rst
>
> diff --git a/Documentation/userspace-api/check_exec.rst b/Documentation/u=
serspace-api/check_exec.rst
> new file mode 100644
> index 000000000000..ad1aeaa5f6c0
> --- /dev/null
> +++ b/Documentation/userspace-api/check_exec.rst
> @@ -0,0 +1,34 @@
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +Executability check
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +AT_EXECVE_CHECK
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +Passing the ``AT_EXECVE_CHECK`` flag to :manpage:`execveat(2)` only perf=
orms a
> +check on a regular file and returns 0 if execution of this file would be
> +allowed, ignoring the file format and then the related interpreter depen=
dencies
> +(e.g. ELF libraries, script's shebang).
> +
> +Programs should always perform this check to apply kernel-level checks a=
gainst
> +files that are not directly executed by the kernel but passed to a user =
space
> +interpreter instead.  All files that contain executable code, from the p=
oint of
> +view of the interpreter, should be checked.  However the result of this =
check
> +should only be enforced according to ``SECBIT_EXEC_RESTRICT_FILE`` or
> +``SECBIT_EXEC_DENY_INTERACTIVE.``.
Regarding "should only"
Userspace (e.g. libc) could decide to enforce even when
SECBIT_EXEC_RESTRICT_FILE=3D0), i.e. if it determines not-enforcing
doesn't make sense.
When SECBIT_EXEC_RESTRICT_FILE=3D1,  userspace is bound to enforce.

> +
> +The main purpose of this flag is to improve the security and consistency=
 of an
> +execution environment to ensure that direct file execution (e.g.
> +``./script.sh``) and indirect file execution (e.g. ``sh script.sh``) lea=
d to
> +the same result.  For instance, this can be used to check if a file is
> +trustworthy according to the caller's environment.
> +
> +In a secure environment, libraries and any executable dependencies shoul=
d also
> +be checked.  For instance, dynamic linking should make sure that all lib=
raries
> +are allowed for execution to avoid trivial bypass (e.g. using ``LD_PRELO=
AD``).
> +For such secure execution environment to make sense, only trusted code s=
hould
> +be executable, which also requires integrity guarantees.
> +
> +To avoid race conditions leading to time-of-check to time-of-use issues,
> +``AT_EXECVE_CHECK`` should be used with ``AT_EMPTY_PATH`` to check again=
st a
> +file descriptor instead of a path.
> diff --git a/Documentation/userspace-api/index.rst b/Documentation/usersp=
ace-api/index.rst
> index 274cc7546efc..6272bcf11296 100644
> --- a/Documentation/userspace-api/index.rst
> +++ b/Documentation/userspace-api/index.rst
> @@ -35,6 +35,7 @@ Security-related interfaces
>     mfd_noexec
>     spec_ctrl
>     tee
> +   check_exec
>
>  Devices and I/O
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/fs/exec.c b/fs/exec.c
> index 6c53920795c2..bb83b6a39530 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -891,7 +891,8 @@ static struct file *do_open_execat(int fd, struct fil=
ename *name, int flags)
>                 .lookup_flags =3D LOOKUP_FOLLOW,
>         };
>
> -       if ((flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) !=3D 0)
> +       if ((flags &
> +            ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH | AT_EXECVE_CHECK)) !=
=3D 0)
>                 return ERR_PTR(-EINVAL);
>         if (flags & AT_SYMLINK_NOFOLLOW)
>                 open_exec_flags.lookup_flags &=3D ~LOOKUP_FOLLOW;
> @@ -1545,6 +1546,21 @@ static struct linux_binprm *alloc_bprm(int fd, str=
uct filename *filename, int fl
>         }
>         bprm->interp =3D bprm->filename;
>
> +       /*
> +        * At this point, security_file_open() has already been called (w=
ith
> +        * __FMODE_EXEC) and access control checks for AT_EXECVE_CHECK wi=
ll
> +        * stop just after the security_bprm_creds_for_exec() call in
> +        * bprm_execve().  Indeed, the kernel should not try to parse the
> +        * content of the file with exec_binprm() nor change the calling
> +        * thread, which means that the following security functions will=
 be
> +        * not called:
> +        * - security_bprm_check()
> +        * - security_bprm_creds_from_file()
> +        * - security_bprm_committing_creds()
> +        * - security_bprm_committed_creds()
> +        */
> +       bprm->is_check =3D !!(flags & AT_EXECVE_CHECK);
> +
>         retval =3D bprm_mm_init(bprm);
>         if (!retval)
>                 return bprm;
> @@ -1839,7 +1855,7 @@ static int bprm_execve(struct linux_binprm *bprm)
>
>         /* Set the unchanging part of bprm->cred */
>         retval =3D security_bprm_creds_for_exec(bprm);
> -       if (retval)
> +       if (retval || bprm->is_check)
>                 goto out;
>
>         retval =3D exec_binprm(bprm);
> diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
> index e6c00e860951..8ff0eb3644a1 100644
> --- a/include/linux/binfmts.h
> +++ b/include/linux/binfmts.h
> @@ -42,7 +42,12 @@ struct linux_binprm {
>                  * Set when errors can no longer be returned to the
>                  * original userspace.
>                  */
> -               point_of_no_return:1;
> +               point_of_no_return:1,
> +               /*
> +                * Set by user space to check executability according to =
the
> +                * caller's environment.
> +                */
> +               is_check:1;
>         struct file *executable; /* Executable to pass to the interpreter=
 */
>         struct file *interpreter;
>         struct file *file;
> diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
> index 87e2dec79fea..2e87f2e3a79f 100644
> --- a/include/uapi/linux/fcntl.h
> +++ b/include/uapi/linux/fcntl.h
> @@ -154,6 +154,10 @@
>                                            usable with open_by_handle_at(=
2). */
>  #define AT_HANDLE_MNT_ID_UNIQUE        0x001   /* Return the u64 unique =
mount ID. */
>
> +/* Flags for execveat2(2). */
> +#define AT_EXECVE_CHECK                0x10000 /* Only perform a check i=
f execution
> +                                          would be allowed. */
> +
>  #if defined(__KERNEL__)
>  #define AT_GETATTR_NOSEC       0x80000000
>  #endif
> diff --git a/kernel/audit.h b/kernel/audit.h
> index a60d2840559e..8ebdabd2ab81 100644
> --- a/kernel/audit.h
> +++ b/kernel/audit.h
> @@ -197,6 +197,7 @@ struct audit_context {
>                 struct open_how openat2;
>                 struct {
>                         int                     argc;
> +                       bool                    is_check;
>                 } execve;
>                 struct {
>                         char                    *name;
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index cd57053b4a69..8d9ba5600cf2 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -2662,6 +2662,7 @@ void __audit_bprm(struct linux_binprm *bprm)
>
>         context->type =3D AUDIT_EXECVE;
>         context->execve.argc =3D bprm->argc;
> +       context->execve.is_check =3D bprm->is_check;
Where is execve.is_check used ?


>  }
>
>
> diff --git a/security/security.c b/security/security.c
> index c5981e558bc2..456361ec249d 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -1249,6 +1249,12 @@ int security_vm_enough_memory_mm(struct mm_struct =
*mm, long pages)
>   * to 1 if AT_SECURE should be set to request libc enable secure mode.  =
@bprm
>   * contains the linux_binprm structure.
>   *
> + * If execveat(2) is called with the AT_EXECVE_CHECK flag, bprm->is_chec=
k is
> + * set.  The result must be the same as without this flag even if the ex=
ecution
> + * will never really happen and @bprm will always be dropped.
> + *
> + * This hook must not change current->cred, only @bprm->cred.
> + *
>   * Return: Returns 0 if the hook is successful and permission is granted=
.
>   */
>  int security_bprm_creds_for_exec(struct linux_binprm *bprm)
> @@ -3100,6 +3106,10 @@ int security_file_receive(struct file *file)
>   * Save open-time permission checking state for later use upon file_perm=
ission,
>   * and recheck access if anything has changed since inode_permission.
>   *
> + * We can check if a file is opened for execution (e.g. execve(2) call),=
 either
> + * directly or indirectly (e.g. ELF's ld.so) by checking file->f_flags &
> + * __FMODE_EXEC .
> + *
>   * Return: Returns 0 if permission is granted.
>   */
>  int security_file_open(struct file *file)
> --
> 2.47.0
>
>
