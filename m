Return-Path: <kernel-hardening-return-21813-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id EFAC193753A
	for <lists+kernel-hardening@lfdr.de>; Fri, 19 Jul 2024 10:45:27 +0200 (CEST)
Received: (qmail 19468 invoked by uid 550); 19 Jul 2024 08:45:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 18418 invoked from network); 19 Jul 2024 08:45:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1721378706;
	bh=D77b+j+Z1jLOY8IPK59eCXt1xDHUtrJGP6+Y0dvzShE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EHXhfzo2I2JDYI5qE9CxmPPNE6gpt2J8KhR+cCzMHYjjH2fwMmVM+PHEN/DbNnqM9
	 mtqkTTjUwJMsBcZQuV+UjKMG0w4K31OBZzi+rBj3+YBsumqOzkhcwAX7nu2z7Qrtfd
	 XK9+OPyVWbcYEkJ/Igx9U3zHvqUfzlRRESQQyIi4=
Date: Fri, 19 Jul 2024 10:44:58 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Jeff Xu <jeffxu@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Paul Moore <paul@paul-moore.com>, Theodore Ts'o <tytso@mit.edu>, 
	Alejandro Colomar <alx@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christian Heimes <christian@python.org>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>, 
	Eric Chiang <ericchiang@google.com>, Fan Wu <wufan@linux.microsoft.com>, 
	Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	James Morris <jamorris@linux.microsoft.com>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jordan R Abrahams <ajordanr@google.com>, 
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, Luca Boccassi <bluca@debian.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, 
	Matt Bobrowski <mattbobrowski@google.com>, Matthew Garrett <mjg59@srcf.ucam.org>, 
	Matthew Wilcox <willy@infradead.org>, Miklos Szeredi <mszeredi@redhat.com>, 
	Mimi Zohar <zohar@linux.ibm.com>, Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>, 
	Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Steve Dower <steve.dower@python.org>, 
	Steve Grubb <sgrubb@redhat.com>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, 
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Xiaoming Ni <nixiaoming@huawei.com>, 
	Yin Fengwei <fengwei.yin@intel.com>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, Elliott Hughes <enh@google.com>
Subject: Re: [RFC PATCH v19 1/5] exec: Add a new AT_CHECK flag to execveat(2)
Message-ID: <20240719.shaeK6PaiSie@digikod.net>
References: <20240704190137.696169-1-mic@digikod.net>
 <20240704190137.696169-2-mic@digikod.net>
 <CALmYWFss7qcpR9D_r3pbP_Orxs55t3y3yXJsac1Wz=Hk9Di0Nw@mail.gmail.com>
 <20240717.neaB5Aiy2zah@digikod.net>
 <CALmYWFt=yXpzhS=HS9FjwVMvx6U1MoR31vK79wxNLhmJm9bBoA@mail.gmail.com>
 <20240718.kaePhei9Ahm9@digikod.net>
 <CALmYWFto4sw-Q2+J0Gc54POhnM9C8YpnJ44wMz=fd_K3_+dWmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALmYWFto4sw-Q2+J0Gc54POhnM9C8YpnJ44wMz=fd_K3_+dWmw@mail.gmail.com>
X-Infomaniak-Routing: alpha

On Thu, Jul 18, 2024 at 06:29:54PM -0700, Jeff Xu wrote:
> On Thu, Jul 18, 2024 at 5:24 AM Mickaël Salaün <mic@digikod.net> wrote:
> >
> > On Wed, Jul 17, 2024 at 07:08:17PM -0700, Jeff Xu wrote:
> > > On Wed, Jul 17, 2024 at 3:01 AM Mickaël Salaün <mic@digikod.net> wrote:
> > > >
> > > > On Tue, Jul 16, 2024 at 11:33:55PM -0700, Jeff Xu wrote:
> > > > > On Thu, Jul 4, 2024 at 12:02 PM Mickaël Salaün <mic@digikod.net> wrote:
> > > > > >
> > > > > > Add a new AT_CHECK flag to execveat(2) to check if a file would be
> > > > > > allowed for execution.  The main use case is for script interpreters and
> > > > > > dynamic linkers to check execution permission according to the kernel's
> > > > > > security policy. Another use case is to add context to access logs e.g.,
> > > > > > which script (instead of interpreter) accessed a file.  As any
> > > > > > executable code, scripts could also use this check [1].
> > > > > >
> > > > > > This is different than faccessat(2) which only checks file access
> > > > > > rights, but not the full context e.g. mount point's noexec, stack limit,
> > > > > > and all potential LSM extra checks (e.g. argv, envp, credentials).
> > > > > > Since the use of AT_CHECK follows the exact kernel semantic as for a
> > > > > > real execution, user space gets the same error codes.
> > > > > >
> > > > > So we concluded that execveat(AT_CHECK) will be used to check the
> > > > > exec, shared object, script and config file (such as seccomp config),

> > > > > I think binfmt_elf.c in the kernel needs to check the ld.so to make
> > > > > sure it passes AT_CHECK, before loading it into memory.
> > > >
> > > > All ELF dependencies are opened and checked with open_exec(), which
> > > > perform the main executability checks (with the __FMODE_EXEC flag).
> > > > Did I miss something?
> > > >
> > > I mean the ld-linux-x86-64.so.2 which is loaded by binfmt in the kernel.
> > > The app can choose its own dynamic linker path during build, (maybe
> > > even statically link one ?)  This is another reason that relying on a
> > > userspace only is not enough.
> >
> > The kernel calls open_exec() on all dependencies, including
> > ld-linux-x86-64.so.2, so these files are checked for executability too.
> >
> This might not be entirely true. iiuc, kernel  calls open_exec for
> open_exec for interpreter, but not all its dependency (e.g. libc.so.6)

Correct, the dynamic linker is in charge of that, which is why it must
be enlighten with execveat+AT_CHECK and securebits checks.

> load_elf_binary() {
>    interpreter = open_exec(elf_interpreter);
> }
> 
> libc.so.6 is opened and mapped by dynamic linker.
> so the call sequence is:
>  execve(a.out)
>   - open exec(a.out)
>   - security_bprm_creds(a.out)
>   - open the exec(ld.so)
>   - call open_exec() for interruptor (ld.so)
>   - call execveat(AT_CHECK, ld.so) <-- do we want ld.so going through
> the same check and code path as libc.so below ?

open_exec() checks are enough.  LSMs can use this information (open +
__FMODE_EXEC) if needed.  execveat+AT_CHECK is only a user space
request.

>   - transfer the control to ld.so)
>   - ld.so open (libc.so)
>   - ld.so call execveat(AT_CHECK,libc.so) <-- proposed by this patch,
> require dynamic linker change.
>   - ld.so mmap(libc.so,rx)

Explaining these steps is useful. I'll include that in the next patch
series.

> > > A detailed user case will help demonstrate the use case for dynamic
> > > linker, e.g. what kind of app will benefit from
> > > SECBIT_EXEC_RESTRICT_FILE = 1, what kind of threat model are we
> > > dealing with , what kind of attack chain we blocked as a result.
> >
> > I explained that in the patches and in the description of these new
> > securebits.  Please point which part is not clear.  The full threat
> > model is simple: the TCB includes the kernel and system's files, which
> > are integrity-protected, but we don't trust arbitrary data/scripts that
> > can be written to user-owned files or directly provided to script
> > interpreters.  As for the ptrace restrictions, the dynamic linker
> > restrictions helps to avoid trivial bypasses (e.g. with LD_PRELOAD)
> > with consistent executability checks.
> >
> On elf loading case, I'm clear after your last email. However, I'm not
> sure if everyone else follows,  I will try to summarize here:
> - Problem:  ld.so /tmp/a.out will happily pass, even /tmp/a.out is
> mounted as non-exec.
>   Solution: ld.so call execveat(AT_CHECK) for a.out before mmap a.out
> into memory.
> 
> - Problem: a poorly built application (a.out) can have a dependency on
> /tmp/a.o, when /tmp/a.o is on non-exec mount,
>   Solution: ld.so call execveat(AT_CHECK) for a.o, before mmap a.o into memory.
> 
> - Problem: application can call mmap (/tmp/a.out, rx), where /tmp is
> on non-exec mount

I'd say "malicious or non-enlightened processes" can call mmap without
execveat+AT_CHECK...

>   This is out of scope, i.e. will require enforcement on mmap(), maybe
> through LSM

Cool, I'll include that as well. Thanks.
