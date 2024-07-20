Return-Path: <kernel-hardening-return-21821-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 44677937EB6
	for <lists+kernel-hardening@lfdr.de>; Sat, 20 Jul 2024 04:07:06 +0200 (CEST)
Received: (qmail 9573 invoked by uid 550); 20 Jul 2024 02:06:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9528 invoked from network); 20 Jul 2024 02:06:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1721441202;
	bh=RciFmK44iR676vaABoiPoYwcBAbrdfd3PEX82KG4l8U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QrsCedGTVxe+iDnPUWk6xAelt9mFI7vKqsz/GR1LA6lHCDCCWygaLcgk9VvepJx9o
	 xyKNOXO4dXXavZPvfYnY5c35UP39m8axcv0gN3TgfZdNg8MhF3MyGhMGznvIwp3QjD
	 N7GrHzIokrbvdkvokFMbDkFEWaPVlRAsztsgXtW/YC2AusqVrH+SkWAq69Sl3ykUML
	 olNG5BMMVJ5COXN9ThPbCIK6MSBUaloskcE5hbX44zlWa+cYB78KnOT3hVbArIbxPt
	 9G0mVzs1bTMlcWAdXDGYBYhLpF71P1teKw6PIG/hX8cPF+Hi9M5Wf9fjTt5BuMlq0I
	 Mi5o93qhSS/Gg==
X-Forwarded-Encrypted: i=1; AJvYcCXLqBgYuOOi0eEnVnAusMLdiyw7RZ9bNOVOolImKS3ucBhRj9kpbE/TFg8Zhk2SAD+O8D+MNTZGH+qKsff1q2qur4ZwaMLc1X01BdLKzvyHPTGQWA==
X-Gm-Message-State: AOJu0YxD7qdHoBHQZTO/ezKY9yghUiXn2TWTgXEEmWzAZfT88sTE6Iaa
	x6TvFTUwSlvsGE+UrBxR6xJgp35p/rH2SQ6cwQUd8dYYCa94ImFszk02947A/Ij34WETJZEDFIO
	B6IzB/MXOPjqINgugOIAcBi4XTxqWBoqxR6Hn
X-Google-Smtp-Source: AGHT+IHgzEfq9gWNLivtDbIs32oK+ER2ycN/f4x58j48rMybvJMw2/ovcOqVDJx4CrlD3KPoqQiFRAIqqcnsvk1G7w4=
X-Received: by 2002:a2e:a7d6:0:b0:2ee:7b7d:66df with SMTP id
 38308e7fff4ca-2ef16738291mr9561611fa.9.1721441200032; Fri, 19 Jul 2024
 19:06:40 -0700 (PDT)
MIME-Version: 1.0
References: <20240704190137.696169-1-mic@digikod.net> <20240704190137.696169-3-mic@digikod.net>
In-Reply-To: <20240704190137.696169-3-mic@digikod.net>
From: Andy Lutomirski <luto@kernel.org>
Date: Sat, 20 Jul 2024 10:06:28 +0800
X-Gmail-Original-Message-ID: <CALCETrWpk5Es9GPoAdDD=m_vgSePm=cA16zCor_aJV0EPXBw1A@mail.gmail.com>
Message-ID: <CALCETrWpk5Es9GPoAdDD=m_vgSePm=cA16zCor_aJV0EPXBw1A@mail.gmail.com>
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
	Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jordan R Abrahams <ajordanr@google.com>, 
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, Luca Boccassi <bluca@debian.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, 
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

On Fri, Jul 5, 2024 at 3:02=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@digiko=
d.net> wrote:
>
> These new SECBIT_SHOULD_EXEC_CHECK, SECBIT_SHOULD_EXEC_RESTRICT, and
> their *_LOCKED counterparts are designed to be set by processes setting
> up an execution environment, such as a user session, a container, or a
> security sandbox.  Like seccomp filters or Landlock domains, the
> securebits are inherited across proceses.
>
> When SECBIT_SHOULD_EXEC_CHECK is set, programs interpreting code should
> check executable resources with execveat(2) + AT_CHECK (see previous
> patch).
>
> When SECBIT_SHOULD_EXEC_RESTRICT is set, a process should only allow
> execution of approved resources, if any (see SECBIT_SHOULD_EXEC_CHECK).

I read this twice, slept on it, read them again, and I *still* can't
understand it.  See below...

> The only restriction enforced by the kernel is the right to ptrace
> another process.  Processes are denied to ptrace less restricted ones,
> unless the tracer has CAP_SYS_PTRACE.  This is mainly a safeguard to
> avoid trivial privilege escalations e.g., by a debugging process being
> abused with a confused deputy attack.

What's the actual issue?  And why can't I, as root, do, in a carefully
checked, CHECK'd and RESTRICT'd environment, # gdb -p <pid>?  Adding
weird restrictions to ptrace can substantially *weaken* security
because it forces people to do utterly daft things to work around the
restrictions.

...

> +/*
> + * When SECBIT_SHOULD_EXEC_CHECK is set, a process should check all exec=
utable
> + * files with execveat(2) + AT_CHECK.  However, such check should only b=
e
> + * performed if all to-be-executed code only comes from regular files.  =
For
> + * instance, if a script interpreter is called with both a script snippe=
d as

s/snipped/snippet/

> + * argument and a regular file, the interpreter should not check any fil=
e.
> + * Doing otherwise would mislead the kernel to think that only the scrip=
t file
> + * is being executed, which could for instance lead to unexpected permis=
sion
> + * change and break current use cases.

This is IMO not nearly clear enough to result in multiple user
implementations and a kernel implementation and multiple LSM
implementations and LSM policy authors actually agreeing as to what
this means.

I also think it's wrong to give user code instructions about what
kernel checks it should do.  Have the user code call the kernel and
have the kernel implement the policy.

> +/*
> + * When SECBIT_SHOULD_EXEC_RESTRICT is set, a process should only allow
> + * execution of approved files, if any (see SECBIT_SHOULD_EXEC_CHECK).  =
For
> + * instance, script interpreters called with a script snippet as argumen=
t
> + * should always deny such execution if SECBIT_SHOULD_EXEC_RESTRICT is s=
et.
> + * However, if a script interpreter is called with both
> + * SECBIT_SHOULD_EXEC_CHECK and SECBIT_SHOULD_EXEC_RESTRICT, they should
> + * interpret the provided script files if no unchecked code is also prov=
ided
> + * (e.g. directly as argument).

I think you're trying to say that this is like (the inverse of)
Content-Security-Policy: unsafe-inline.  In other words, you're saying
that, if RESTRICT is set, then programs should not execute code-like
text that didn't come from a file.  Is that right?

I feel like it would be worth looking at the state of the art of
Content-Security-Policy and all the lessons people have learned from
it.  Whatever the result is should be at least as comprehensible and
at least as carefully engineered as Content-Security-Policy.

--Andy
