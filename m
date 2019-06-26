Return-Path: <kernel-hardening-return-16267-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 356CA56F6F
	for <lists+kernel-hardening@lfdr.de>; Wed, 26 Jun 2019 19:15:22 +0200 (CEST)
Received: (qmail 13979 invoked by uid 550); 26 Jun 2019 17:15:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13961 invoked from network); 26 Jun 2019 17:15:15 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1561569304;
	bh=GE5SXf7lw3shhBSYk8KjPopSBeCwZnmq+2rMkr9xiGM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=SHUff+K1HYfEiRaZLc9Vfgz5Qk6ja0OQR7gCqAhpbfepYXfmsqZIsWHfjyPOc5RO7
	 Cfxw8+257H6Df2JbW+sK/SIVBwuopPGZb8kL59Qy9TF8CckTWf0RGhz0WCf+hS9zkK
	 9rzEToTucTjtc1RpBcNWyHimlD49rBrp+qQ4f6EY=
X-Gm-Message-State: APjAAAXE+hECzf6MuK/APCkdlrHA4OleclRg5cAaNrnNj9mpnxQwRLm5
	U1ffWhEgMovsOK0t7zQcg5kgWWcviIDFMBGth0pvyA==
X-Google-Smtp-Source: APXvYqwnsSMuYURJ/vLMXM0zQY/0PQL1B/Cpf+WP8mDEtEchm4+UOBd50TquhvHxYQAE4+Y2hgfYyu0uQHg9M4vz/MM=
X-Received: by 2002:adf:cc85:: with SMTP id p5mr4233362wrj.47.1561569302442;
 Wed, 26 Jun 2019 10:15:02 -0700 (PDT)
MIME-Version: 1.0
References: <87v9wty9v4.fsf@oldenburg2.str.redhat.com> <alpine.DEB.2.21.1906251824500.32342@nanos.tec.linutronix.de>
 <87lfxpy614.fsf@oldenburg2.str.redhat.com> <CALCETrVh1f5wJNMbMoVqY=bq-7G=uQ84BUkepf5RksA3vUopNQ@mail.gmail.com>
 <87a7e5v1d9.fsf@oldenburg2.str.redhat.com> <CALCETrUDt4v3=FqD+vseGTKTuG=qY+1LwRPrOrU8C7vCVbo=uA@mail.gmail.com>
 <87o92kmtp5.fsf@oldenburg2.str.redhat.com> <CA96B819-30A9-43D3-9FE3-2D551D35369E@amacapital.net>
 <87r27gjss3.fsf@oldenburg2.str.redhat.com> <534B9F63-E949-4CF5-ACAC-71381190846F@amacapital.net>
 <87a7e4jr4s.fsf@oldenburg2.str.redhat.com> <6CECE9DE-51AB-4A21-A257-8B85C4C94EB0@amacapital.net>
 <87sgrw1ejv.fsf@oldenburg2.str.redhat.com> <CALCETrUG9yHf4D_fDEj054Bgo4zXpmK5UzME9mKNqD70U7vy5Q@mail.gmail.com>
 <87ef3g1do3.fsf@oldenburg2.str.redhat.com>
In-Reply-To: <87ef3g1do3.fsf@oldenburg2.str.redhat.com>
From: Andy Lutomirski <luto@kernel.org>
Date: Wed, 26 Jun 2019 10:14:50 -0700
X-Gmail-Original-Message-ID: <CALCETrXM_W0oHEWiDJh4xrroPjg_B5VZCxkKyR6jH=gnYJ=ZNA@mail.gmail.com>
Message-ID: <CALCETrXM_W0oHEWiDJh4xrroPjg_B5VZCxkKyR6jH=gnYJ=ZNA@mail.gmail.com>
Subject: Re: Detecting the availability of VSYSCALL
To: Florian Weimer <fweimer@redhat.com>
Cc: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Linux API <linux-api@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-x86_64@vger.kernel.org, 
	linux-arch <linux-arch@vger.kernel.org>, Kees Cook <keescook@chromium.org>, 
	"Carlos O'Donell" <carlos@redhat.com>, X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 26, 2019 at 10:04 AM Florian Weimer <fweimer@redhat.com> wrote:
>
> * Andy Lutomirski:
>
> > On Wed, Jun 26, 2019 at 9:45 AM Florian Weimer <fweimer@redhat.com> wro=
te:
> >>
> >> * Andy Lutomirski:
> >>
> >> > Can=E2=80=99t an ELF note be done with some more or less ordinary as=
m such
> >> > that any link editor will insert it correctly?
> >>
> >> We've just been over this for the CET enablement.  ELF PT_NOTE parsing
> >> was rejected there.
> >
> > No one told me this.  Unless I missed something, the latest kernel
> > patches still had PT_NOTE parsing.  Can you point me at an
> > enlightening thread or explain what happened?
>
> The ABI was changed rather late, and PT_GNU_PROPERTY has been added.
> But this is okay because the kernel only looks at the dynamic loader,
> which we can update fairly easily.

Ugh.  I replied there.  I don't consider any of that to have much
bearing on what we do for vsyscalls.  That being said, the
PT_GNU_PROPERTY thing sounds like maybe we could use it for a bit
saying "no vsyscalls needed".

>
> The thread is:
>
> Subject: Re: [PATCH v7 22/27] binfmt_elf: Extract .note.gnu.property from=
 an ELF file
>
> <87blyu7ubf.fsf@oldenburg2.str.redhat.com> is a message reference in it.
>
> >> > The problem with a personality flag is that it needs to have some ki=
nd
> >> > of sensible behavior for setuid programs, and getting that right in =
a
> >> > way that doesn=E2=80=99t scream =E2=80=9Cexploit me=E2=80=9D while p=
reserving useful
> >> > compatibility may be tricky.
> >>
> >> Are restrictive personality flags still a problem with user namespaces=
?
> >> I think it would be fine to restrict this one to CAP_SYS_ADMIN.
> >
> > We could possibly get away with this, but now we're introducing a
> > whole new mechanism.  I'd rather just add proper per-namespace
> > sysctls, but this is a pretty big hammer.
>
> Oh, I wasn't aware of that.  I thought that this already existed in some
> form, e.g. prctl with PR_SET_SECCOMP requiring CAP_SYS_ADMIN unless
> PR_SET_NO_NEW_PRIVS was active as well.

We do have that, but I don't think we have it for personality.  The
whole personality mechanism scares me a bit due to a lack of this type
of thing, and I'd want to review it carefully before adding a new
personality bit.


--Andy
