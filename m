Return-Path: <kernel-hardening-return-20263-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B8C902981EB
	for <lists+kernel-hardening@lfdr.de>; Sun, 25 Oct 2020 14:43:24 +0100 (CET)
Received: (qmail 20170 invoked by uid 550); 25 Oct 2020 13:43:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 20138 invoked from network); 25 Oct 2020 13:43:15 -0000
Date: Sun, 25 Oct 2020 13:42:57 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.ch;
	s=protonmail; t=1603633383;
	bh=RztYREdZbMudtChMjooBjWJtc3ZFeXsHMYskl+O762c=;
	h=Date:To:From:Cc:Reply-To:Subject:In-Reply-To:References:From;
	b=sj0R0QHA8mqAXANRDKgYvjZhWMKMupZnQj4pVghO9waIHM0GZdAfuLoNKs8vyjMSR
	 ihE/K6adlqkG3V5FlMGaysO/RHAjnG81d/8IKEt8QqJEw717G5vzYGzUsc7HLvQy+a
	 JbQVwXnf3kpaeSfaQVe3QqKYJ4ub6Ae87GXO1U3g=
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>
From: Jordan Glover <Golden_Miller83@protonmail.ch>
Cc: Topi Miettinen <toiwoton@gmail.com>, Kees Cook <keescook@chromium.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Jeremy Linton <jeremy.linton@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>, "systemd-devel@lists.freedesktop.org" <systemd-devel@lists.freedesktop.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mark Rutland <mark.rutland@arm.com>, Mark Brown <broonie@kernel.org>, Dave Martin <dave.martin@arm.com>, Catalin Marinas <Catalin.Marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: Re: BTI interaction between seccomp filters in systemd and glibc mprotect calls, causing service failures
Message-ID: <_2cdGtwD1Z9iBKSrB4v55wrfcso1gpABXQas61V7fdAD2SqYF8RyG_ggCXGigvJ4jkMr7OlVLP484_SPsjP01JFeoI2_lP8PM4IOGZAlRBk=@protonmail.ch>
In-Reply-To: <CAJHCu1JskXZTvSsspQD-wk4L59FxesvVJdjMSX=jiHg-R2zCuQ@mail.gmail.com>
References: <8584c14f-5c28-9d70-c054-7c78127d84ea@arm.com> <20201022075447.GO3819@arm.com> <78464155-f459-773f-d0ee-c5bdbeb39e5d@gmail.com> <202010221256.A4F95FD11@keescook> <180cd894-d42d-2bdb-093c-b5360b0ecb1e@gmail.com> <CAJHCu1Jrtx=OVEiTVwPJg7CxRkV83tS=HsYeLoAGRf_tgYq_iQ@mail.gmail.com> <3cb894d4-049f-aa25-4450-d1df36a1b92e@gmail.com> <CAJHCu1JskXZTvSsspQD-wk4L59FxesvVJdjMSX=jiHg-R2zCuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.7 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT shortcircuit=no
	autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
	mailout.protonmail.ch

On Saturday, October 24, 2020 2:12 PM, Salvatore Mesoraca <s.mesoraca16@gma=
il.com> wrote:

> On Sat, 24 Oct 2020 at 12:34, Topi Miettinen toiwoton@gmail.com wrote:
>
> > On 23.10.2020 20.52, Salvatore Mesoraca wrote:
> >
> > > Hi,
> > > On Thu, 22 Oct 2020 at 23:24, Topi Miettinen toiwoton@gmail.com wrote=
:
> > >
> > > > SARA looks interesting. What is missing is a prctl() to enable all =
W^X
> > > > protections irrevocably for the current process, then systemd could
> > > > enable it for services with MemoryDenyWriteExecute=3Dyes.
> > >
> > > SARA actually has a procattr[0] interface to do just that.
> > > There is also a library[1] to help using it.
> >
> > That means that /proc has to be available and writable at that point, s=
o
> > setting up procattrs has to be done before mount namespaces are set up.
> > In general, it would be nice for sandboxing facilities in kernel if
> > there would be a way to start enforcing restrictions only at next
> > execve(), like setexeccon() for SELinux and aa_change_onexec() for
> > AppArmor. Otherwise the exact order of setting up various sandboxing
> > options can be very tricky to arrange correctly, since each option may
> > have a subtle effect to the sandboxing features enabled later. In case
> > of SARA, the operations done between shuffling the mount namespace and
> > before execve() shouldn't be affected so it isn't important. Even if it
> > did (a new sandboxing feature in the future would need trampolines or
> > JIT code generation), maybe the procattr file could be opened early but
> > it could be written closer to execve().
>
> A new "apply on exec" procattr file seems reasonable and relatively easy =
to add.
> As Kees pointed out, the main obstacle here is the fact that SARA is
> not upstream :(
>
> Salvatore

Is there a chance we will see new SARA iteration soon on lkml? :)

Jordan
