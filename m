Return-Path: <kernel-hardening-return-21764-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 3398F92AAFE
	for <lists+kernel-hardening@lfdr.de>; Mon,  8 Jul 2024 23:16:49 +0200 (CEST)
Received: (qmail 1688 invoked by uid 550); 8 Jul 2024 21:16:31 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1662 invoked from network); 8 Jul 2024 21:16:31 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1720473384; x=1721078184; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2KpIsYE0TleTo0yrVtdXZlELh9EVGU12iXRlWXjkGvo=;
        b=RECITyvcj7/nq6Wfj7SqHATxkDhjiUed8ZVjq/wNtJz2caDXep6mqZ95r0+8+Xwikj
         Gh2aoCUxVtk5+PqsnVaIJaG2623m5ExpNU+dVoz02UmlktJUoh44cUPTpT/yRv77aKt4
         Ys7b5KLPixRuJsWjwYVdUdr229ClIg4Ac0OWt+JNnBhpYw/OS++GDaA2m2txC44sY/PO
         e1GlmCLmaaG3ULQMX52f8AMFetID6+oMnG6EkaIdjrWdx7K2V1mQDpHHVUdVMp9K2ppV
         MowmPmMwZ1X+fk7WWPsZQ0qpewfUk0aFLbPMmNTze98zbBGeY7XMuV8dOlLiZBKYhwj4
         Rr5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720473384; x=1721078184;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2KpIsYE0TleTo0yrVtdXZlELh9EVGU12iXRlWXjkGvo=;
        b=U41Kc8Uy5//HP01s7CEmIV1ocWSCqpnIlOQGzBJPQhfOSV/HhY31p6fNsnck29O0Ce
         +Ej1TOxsrM541FIrhXPlouzNNJXEJQxzuZdCLa5qT/lrkmYHLlongoOPWwkD2lR97Ts4
         H4lihvmqA+27eJZ2rC0Y3hS1Vq7+h9egs3FqjqrP+gaDw7v3OzPhntpq2EzoOPy2FmFa
         tK+QGKVqHqwomp7HMOio0GovkJjBV//yhwv64+QAI6iXmKQ3da5THyFB5sKPGR51L5kR
         O0Pc0DC6smCRfda5KorMLnxYqrqqoA6yXytteBU1PRxWtjmJBZU9SojQMbgz4O+B5W/e
         6EqQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1PYMfipTN2UmPhDmfSTvlmJC/i/HktaapmEj8f+L1niVMu6Um9D3CY/xQoLci/Y1eZaN+M4OpsQBAsB1+Pqimd+chGXULXwvuO1y0n1Rg8KyrKg==
X-Gm-Message-State: AOJu0Ywlh6bmAvm4koUhqdcLwthL5jT6rrKDVD7F2AeAi3OGGT4E0Mlu
	0x00CGz+TbKiB+xkLVEjUI83JYoIZNJfSKgS6FSyfIe24vWPZNwrRBAAmwphpqnFTTBIlI9ZOun
	W1gHDxHC3B2bTkkVd2AFQmJ2b0zLod39O9qko
X-Google-Smtp-Source: AGHT+IGIbhNOycFNQM/zvKsAwdxOR5lJu+RnC4Q2RqfPBJWNKrAOZPLOqS1TPq3cJ2dEe8dfI7ztR942V4cI/hLtfXM=
X-Received: by 2002:a50:d703:0:b0:58b:93:b623 with SMTP id 4fb4d7f45d1cf-594f8aec609mr14200a12.5.1720473381700;
 Mon, 08 Jul 2024 14:16:21 -0700 (PDT)
MIME-Version: 1.0
References: <20240704190137.696169-1-mic@digikod.net> <20240704190137.696169-3-mic@digikod.net>
 <CALmYWFscz5W6xSXD-+dimzbj=TykNJEDa0m5gvBx93N-J+3nKA@mail.gmail.com>
 <CALmYWFsLUhkU5u1NKH8XWvSxbFKFOEq+A_eqLeDsN29xOEAYgg@mail.gmail.com> <20240708.quoe8aeSaeRi@digikod.net>
In-Reply-To: <20240708.quoe8aeSaeRi@digikod.net>
From: Jeff Xu <jeffxu@google.com>
Date: Mon, 8 Jul 2024 14:15:44 -0700
Message-ID: <CALmYWFuVJiRZgB0ye9eR95dvBOigoOVShgS9i_ESjEre-H5pLA@mail.gmail.com>
Subject: Re: [RFC PATCH v19 2/5] security: Add new SHOULD_EXEC_CHECK and
 SHOULD_EXEC_RESTRICT securebits
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Paul Moore <paul@paul-moore.com>, "Theodore Ts'o" <tytso@mit.edu>, Alejandro Colomar <alx@kernel.org>, 
	Aleksa Sarai <cyphar@cyphar.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christian Heimes <christian@python.org>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>, 
	Eric Chiang <ericchiang@google.com>, Fan Wu <wufan@linux.microsoft.com>, 
	Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	James Morris <jamorris@linux.microsoft.com>, Jan Kara <jack@suse.cz>, 
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, 
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

On Mon, Jul 8, 2024 at 11:48=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@digik=
od.net> wrote:
>
> On Mon, Jul 08, 2024 at 10:53:11AM -0700, Jeff Xu wrote:
> > On Mon, Jul 8, 2024 at 9:17=E2=80=AFAM Jeff Xu <jeffxu@google.com> wrot=
e:
> > >
> > > Hi
> > >
> > > On Thu, Jul 4, 2024 at 12:02=E2=80=AFPM Micka=C3=ABl Sala=C3=BCn <mic=
@digikod.net> wrote:
> > > >
> > > > These new SECBIT_SHOULD_EXEC_CHECK, SECBIT_SHOULD_EXEC_RESTRICT, an=
d
> > > > their *_LOCKED counterparts are designed to be set by processes set=
ting
> > > > up an execution environment, such as a user session, a container, o=
r a
> > > > security sandbox.  Like seccomp filters or Landlock domains, the
> > > > securebits are inherited across proceses.
> > > >
> > > > When SECBIT_SHOULD_EXEC_CHECK is set, programs interpreting code sh=
ould
> > > > check executable resources with execveat(2) + AT_CHECK (see previou=
s
> > > > patch).
> > > >
> > > > When SECBIT_SHOULD_EXEC_RESTRICT is set, a process should only allo=
w
> > > > execution of approved resources, if any (see SECBIT_SHOULD_EXEC_CHE=
CK).
> > > >
> > > Do we need both bits ?
> > > When CHECK is set and RESTRICT is not, the "check fail" executable
> > > will still get executed, so CHECK is for logging ?
> > > Does RESTRICT imply CHECK is set, e.g. What if CHECK=3D0 and RESTRICT=
 =3D 1 ?
> > >
> > The intention might be "permissive mode"?  if so, consider reuse
> > existing selinux's concept, and still with 2 bits:
> > SECBIT_SHOULD_EXEC_RESTRICT
> > SECBIT_SHOULD_EXEC_RESTRICT_PERMISSIVE
>
> SECBIT_SHOULD_EXEC_CHECK is for user space to check with execveat+AT_CHEC=
K.
>
> SECBIT_SHOULD_EXEC_RESTRICT is for user space to restrict execution by
> default, and potentially allow some exceptions from the list of
> checked-and-allowed files, if SECBIT_SHOULD_EXEC_CHECK is set.
>
> Without SECBIT_SHOULD_EXEC_CHECK, SECBIT_SHOULD_EXEC_RESTRICT is to deny
> any kind of execution/interpretation.
>
Do you mean "deny any kinds of executable/interpretation" or just
those that failed with "AT_CHECK"  ( I assume this)?

> With only SECBIT_SHOULD_EXEC_CHECK, user space should just check and log
> any denied access, but ignore them.  So yes, it is similar to the
> SELinux's permissive mode.
>
IIUC:
CHECK=3D0, RESTRICT=3D0: do nothing, current behavior
CHECK=3D1, RESTRICT=3D0: permissive mode - ignore AT_CHECK results.
CHECK=3D0, RESTRICT=3D1: call AT_CHECK, deny if AT_CHECK failed, no excepti=
on.
CHECK=3D1, RESTRICT=3D1: call AT_CHECK, deny if AT_CHECK failed, except
those in the "checked-and-allowed" list.

So CHECK is basically trying to form a allowlist?
If there is a need for a allowlist, that is the task of "interruptor
or dynamic linker" to maintain this list, and the list is known in
advance, i.e. not something from execveat(AT_CHECK), and kernel
shouldn't have the knowledge of this allowlist.
Secondly, the concept of allow-list  seems to be an attack factor for
me, I would rather it be fully enforced, or permissive mode.
And Check=3D1 and RESTRICT=3D1 is less secure than CHECK=3D0, RESTRICT=3D1,
this might also be not obvious to dev.

Unless I understood the CHECK wrong.

> This is explained in the next patch as comments.
>
The next patch is a selftest patch, it is better to define them in the
current commit and in the securebits.h.

> The *_LOCKED variants are useful and part of the securebits concept.
>
The locked state is easy to understand.

Thanks
Best regards
-Jeff

> >
> >
> > -Jeff
> >
> >
> >
> >
> > > > For a secure environment, we might also want
> > > > SECBIT_SHOULD_EXEC_CHECK_LOCKED and SECBIT_SHOULD_EXEC_RESTRICT_LOC=
KED
> > > > to be set.  For a test environment (e.g. testing on a fleet to iden=
tify
> > > > potential issues), only the SECBIT_SHOULD_EXEC_CHECK* bits can be s=
et to
> > > > still be able to identify potential issues (e.g. with interpreters =
logs
> > > > or LSMs audit entries).
> > > >
> > > > It should be noted that unlike other security bits, the
> > > > SECBIT_SHOULD_EXEC_CHECK and SECBIT_SHOULD_EXEC_RESTRICT bits are
> > > > dedicated to user space willing to restrict itself.  Because of tha=
t,
> > > > they only make sense in the context of a trusted environment (e.g.
> > > > sandbox, container, user session, full system) where the process
> > > > changing its behavior (according to these bits) and all its parent
> > > > processes are trusted.  Otherwise, any parent process could just ex=
ecute
> > > > its own malicious code (interpreting a script or not), or even enfo=
rce a
> > > > seccomp filter to mask these bits.
> > > >
> > > > Such a secure environment can be achieved with an appropriate acces=
s
> > > > control policy (e.g. mount's noexec option, file access rights, LSM
> > > > configuration) and an enlighten ld.so checking that libraries are
> > > > allowed for execution e.g., to protect against illegitimate use of
> > > > LD_PRELOAD.
> > > >
> > > > Scripts may need some changes to deal with untrusted data (e.g. std=
in,
> > > > environment variables), but that is outside the scope of the kernel=
.
> > > >
> > > > The only restriction enforced by the kernel is the right to ptrace
> > > > another process.  Processes are denied to ptrace less restricted on=
es,
> > > > unless the tracer has CAP_SYS_PTRACE.  This is mainly a safeguard t=
o
> > > > avoid trivial privilege escalations e.g., by a debugging process be=
ing
> > > > abused with a confused deputy attack.
> > > >
> > > > Cc: Al Viro <viro@zeniv.linux.org.uk>
> > > > Cc: Christian Brauner <brauner@kernel.org>
> > > > Cc: Kees Cook <keescook@chromium.org>
> > > > Cc: Paul Moore <paul@paul-moore.com>
> > > > Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> > > > Link: https://lore.kernel.org/r/20240704190137.696169-3-mic@digikod=
.net
> > > > ---
