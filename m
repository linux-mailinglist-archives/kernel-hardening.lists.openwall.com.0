Return-Path: <kernel-hardening-return-21786-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 7288B932A46
	for <lists+kernel-hardening@lfdr.de>; Tue, 16 Jul 2024 17:19:12 +0200 (CEST)
Received: (qmail 5863 invoked by uid 550); 16 Jul 2024 15:18:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5834 invoked from network); 16 Jul 2024 15:18:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1721143131; x=1721747931; darn=lists.openwall.com;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WWVNrxbBHDXZu/jCvfJLl2ens68sOvgHXhZ1riQlav8=;
        b=e2xp2fEvMW52BmKu0OwiTrb2lzQwbbUrSSIHC6amHIXH19SFxuJU8ysgMMluSK946Q
         NKV8FG8beiTzAvMDhWMqsr+67d5h8YZtfOaUQyV33rIm0LXog7JL9ip2cWDP+SsUNqRp
         URN85hYEqqQ/S4HOFFafKV2sgsUjjkPH1ByP5E2f1deXrjgs7F1BM7W6x1Db4vlJz8k0
         Lo7u+qjfslG7u2L5BhdP7WrD/P++xUjy348J4RM8ge7Xcyw1YbRRbzMJH2U7IzMTyejO
         b7GTS7hpaQhEzBXcpxrlxQq37tkP2mNToWVku15WM+PAFjyOIuqiXDmUIvn1mqS7HicK
         ujcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721143131; x=1721747931;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WWVNrxbBHDXZu/jCvfJLl2ens68sOvgHXhZ1riQlav8=;
        b=SL3LOXnhxCuemXudXgDiU6nLAgxlsswUuPCfj+rtPa6VO/DpaCUQXR1Kc4kOi8mJpP
         KgQATiemS0BjeMUw+kCo6CY8jQmV45tqzHKxfvvsAVkLDFMlpiI1GQHSHBHHTX1Sl+Wn
         3zU8X0bUAbTvrL0kH3qgCW6D0lTFEMXT0SrT379hxLUg/LmeEyCfAK7bs9naPzaQ01QL
         WrR7FDTaEqBnYXLBS4sWboRRJt66Wmx5y40iDNPNoI/o5R204iSezKg/YFgE9xQmufPz
         YJv0kOqHtt3qr55qz1l5KUIIqlfSiExv1cd9gOgI8/jrCMXZTyFaA2e5KETZQ7qHQ7k1
         BlSw==
X-Forwarded-Encrypted: i=1; AJvYcCVKfJ3rOrRq64OUyXsUsYR6cSSPMOMAB05JtliKwxRARWGlYLPRDpg+wjQ7IZyPgmTBQbEU4g4sZ7I2xCY/MibDsuXfUMraVGHqe0RlAF/axVOmNA==
X-Gm-Message-State: AOJu0YwG06A6i7LrVexv0UhVHQuInIyolMkpdRsOiQWNpXPa31KTuqcS
	sXSsczshfuNIuw2sOdy8mtMVxg9Q7yYm3pMFV36lAuL4zqThtDaLrv0YFsRo10xYlHUezgi3wd/
	soxMcnAQVbFoCpqcfm9CGO3oE/6BSjExA5gMa
X-Google-Smtp-Source: AGHT+IHWbKj34zsRyLKiBWqdmFyKlDq6Wr5+2Wdecg/ZG3HyZU7BuDsfvRbU1vyabej6wFPdLE9jOxxXXzqK9dZsCJU=
X-Received: by 2002:a05:622a:997:b0:444:dc22:fb1d with SMTP id
 d75a77b69052e-44f7a64c7e0mr3638781cf.12.1721143130336; Tue, 16 Jul 2024
 08:18:50 -0700 (PDT)
MIME-Version: 1.0
References: <20240708.quoe8aeSaeRi@digikod.net> <CALmYWFuVJiRZgB0ye9eR95dvBOigoOVShgS9i_ESjEre-H5pLA@mail.gmail.com>
 <ef3281ad-48a5-4316-b433-af285806540d@python.org> <CALmYWFuFE=V7sGp0_K+2Vuk6F0chzhJY88CP1CAE9jtd=rqcoQ@mail.gmail.com>
 <20240709.aech3geeMoh0@digikod.net> <CALmYWFuOXAiT05Pi2rZ1nUAKDGe9JyTH7fro2EYS1fh3zeGV5Q@mail.gmail.com>
 <20240710.eiKohpa4Phai@digikod.net> <202407100921.687BE1A6@keescook>
 <20240711.sequuGhee0th@digikod.net> <CALmYWFt7X0v8k1N9=aX6BuT2gCiC9SeWwPEBckvBk8GQtb0rqQ@mail.gmail.com>
 <20240716.Zah8Phaiphae@digikod.net>
In-Reply-To: <20240716.Zah8Phaiphae@digikod.net>
From: Jeff Xu <jeffxu@google.com>
Date: Tue, 16 Jul 2024 08:18:09 -0700
Message-ID: <CALmYWFu=kdsxZwj-U5yqCUXrhvzxWCt1YjuJv0eAAaAyGFbxFQ@mail.gmail.com>
Subject: Re: [RFC PATCH v19 2/5] security: Add new SHOULD_EXEC_CHECK and
 SHOULD_EXEC_RESTRICT securebits
To: =?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>
Cc: Kees Cook <kees@kernel.org>, Steve Dower <steve.dower@python.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Paul Moore <paul@paul-moore.com>, 
	"Theodore Ts'o" <tytso@mit.edu>, Alejandro Colomar <alx@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, 
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
	Shuah Khan <shuah@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Steve Grubb <sgrubb@redhat.com>, 
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, 
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Xiaoming Ni <nixiaoming@huawei.com>, 
	Yin Fengwei <fengwei.yin@intel.com>, kernel-hardening@lists.openwall.com, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 16, 2024 at 8:15=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@digik=
od.net> wrote:
>
> On Tue, Jul 16, 2024 at 08:02:37AM -0700, Jeff Xu wrote:
> > On Thu, Jul 11, 2024 at 1:57=E2=80=AFAM Micka=C3=ABl Sala=C3=BCn <mic@d=
igikod.net> wrote:
> > >
> > > On Wed, Jul 10, 2024 at 09:26:14AM -0700, Kees Cook wrote:
> > > > On Wed, Jul 10, 2024 at 11:58:25AM +0200, Micka=C3=ABl Sala=C3=BCn =
wrote:
> > > > > Here is another proposal:
> > > > >
> > > > > We can change a bit the semantic by making it the norm to always =
check
> > > > > file executability with AT_CHECK, and using the securebits to res=
trict
> > > > > file interpretation and/or command injection (e.g. user supplied =
shell
> > > > > commands).  Non-executable checked files can be reported/logged a=
t the
> > > > > kernel level, with audit, configured by sysadmins.
> > > > >
> > > > > New securebits (feel free to propose better names):
> > > > >
> > > > > - SECBIT_EXEC_RESTRICT_FILE: requires AT_CHECK to pass.
> > > >
> > > > Would you want the enforcement of this bit done by userspace or the
> > > > kernel?
> > > >
> > > > IIUC, userspace would always perform AT_CHECK regardless of
> > > > SECBIT_EXEC_RESTRICT_FILE, and then which would happen?
> > > >
> > > > 1) userspace would ignore errors from AT_CHECK when
> > > >    SECBIT_EXEC_RESTRICT_FILE is unset
> > >
> > > Yes, that's the idea.
> > >
> > > >
> > > > or
> > > >
> > > > 2) kernel would allow all AT_CHECK when SECBIT_EXEC_RESTRICT_FILE i=
s
> > > >    unset
> > > >
> > > > I suspect 1 is best and what you intend, given that
> > > > SECBIT_EXEC_DENY_INTERACTIVE can only be enforced by userspace.
> > >
> > > Indeed. We don't want AT_CHECK's behavior to change according to
> > > securebits.
> > >
> > One bit is good.
> >
> > > >
> > > > > - SECBIT_EXEC_DENY_INTERACTIVE: deny any command injection via
> > > > >   command line arguments, environment variables, or configuration=
 files.
> > > > >   This should be ignored by dynamic linkers.  We could also have =
an
> > > > >   allow-list of shells for which this bit is not set, managed by =
an
> > > > >   LSM's policy, if the native securebits scoping approach is not =
enough.
> > > > >
> > > > > Different modes for script interpreters:
> > > > >
> > > > > 1. RESTRICT_FILE=3D0 DENY_INTERACTIVE=3D0 (default)
> > > > >    Always interpret scripts, and allow arbitrary user commands.
> > > > >    =3D> No threat, everyone and everything is trusted, but we can=
 get
> > > > >    ahead of potential issues with logs to prepare for a migration=
 to a
> > > > >    restrictive mode.
> > > > >
> > > > > 2. RESTRICT_FILE=3D1 DENY_INTERACTIVE=3D0
> > > > >    Deny script interpretation if they are not executable, and all=
ow
> > > > >    arbitrary user commands.
> > > > >    =3D> Threat: (potential) malicious scripts run by trusted (and=
 not
> > > > >       fooled) users.  That could protect against unintended scrip=
t
> > > > >       executions (e.g. sh /tmp/*.sh).
> > > > >    =3D=3D> Makes sense for (semi-restricted) user sessions.
> > > > >
> > > > > 3. RESTRICT_FILE=3D1 DENY_INTERACTIVE=3D1
> > > > >    Deny script interpretation if they are not executable, and als=
o deny
> > > > >    any arbitrary user commands.
> > > > >    =3D> Threat: malicious scripts run by untrusted users.
> > > > >    =3D=3D> Makes sense for system services executing scripts.
> > > > >
> > > > > 4. RESTRICT_FILE=3D0 DENY_INTERACTIVE=3D1
> > > > >    Always interpret scripts, but deny arbitrary user commands.
> > > > >    =3D> Goal: monitor/measure/assess script content (e.g. with IM=
A/EVM) in
> > > > >       a system where the access rights are not (yet) ready.  Arbi=
trary
> > > > >       user commands would be much more difficult to monitor.
> > > > >    =3D=3D> First step of restricting system services that should =
not
> > > > >        directly pass arbitrary commands to shells.
> > > >
> > > > I like these bits!
> > >
> > > Good! Jeff, Steve, Florian, Matt, others, what do you think?
> >
> > For below two cases: will they be restricted by one (or some) mode abov=
e ?
> >
> > 1> cat /tmp/a.sh | sh
> >
> > 2> sh -c "$(cat /tmp/a.sh)"
>
> Yes, DENY_INTERACTIVE=3D1 is to deny both of these cases (i.e. arbitrary
> user command).
>
> These other examples should be allowed with AT_CHECK and RESTRICT_FILE=3D=
1
> if a.sh is executable though:
> * sh /tmp/a.sh
> * sh < /tmp/a.sh
That looks good. Thanks for clarifying.
