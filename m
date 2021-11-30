Return-Path: <kernel-hardening-return-21510-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5871B463F35
	for <lists+kernel-hardening@lfdr.de>; Tue, 30 Nov 2021 21:27:54 +0100 (CET)
Received: (qmail 9328 invoked by uid 550); 30 Nov 2021 20:27:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9302 invoked from network); 30 Nov 2021 20:27:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1638304056;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AcMNv7Mr+B4p3hEjaHnnJQgfgj2Zfos0EhRVXhwbDc0=;
	b=EFeJ76h22hyTp3Z7a4mqfU5/CaSTOkeyqYhzreZ2wPeegqXyfduFt77TGfa7O/3EHIS0XI
	nzMI/+hDfGXwPbMlM492iM53pg1OaDGDeIaTdlr8kkSIBZ0MbSsEn3xmvndg2sJJJGR5KG
	Cr2CuKV8moms3SyAWTs+Nf7iA33Fy8w=
X-MC-Unique: sFhFSPFrP4CIoucnQlO17Q-1
From: Florian Weimer <fweimer@redhat.com>
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>,  Andrew Morton
 <akpm@linux-foundation.org>,  Alejandro Colomar <alx.manpages@gmail.com>,
  Aleksa Sarai <cyphar@cyphar.com>,  Andy Lutomirski <luto@kernel.org>,
  Arnd Bergmann <arnd@arndb.de>,  Casey Schaufler <casey@schaufler-ca.com>,
  Christian Brauner <christian.brauner@ubuntu.com>,  Christian Heimes
 <christian@python.org>,  Deven Bowers <deven.desai@linux.microsoft.com>,
  Dmitry Vyukov <dvyukov@google.com>,  Eric Biggers <ebiggers@kernel.org>,
  Eric Chiang <ericchiang@google.com>,  Geert Uytterhoeven
 <geert@linux-m68k.org>,  James Morris <jmorris@namei.org>,  Jan Kara
 <jack@suse.cz>,  Jann Horn <jannh@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  Kees Cook <keescook@chromium.org>,  Lakshmi
 Ramasubramanian <nramas@linux.microsoft.com>,  "Madhavan T . Venkataraman"
 <madvenka@linux.microsoft.com>,  Matthew Garrett <mjg59@google.com>,
  Matthew Wilcox <willy@infradead.org>,  Miklos Szeredi
 <mszeredi@redhat.com>,  Mimi Zohar <zohar@linux.ibm.com>,  Paul Moore
 <paul@paul-moore.com>,  Philippe =?utf-8?Q?Tr=C3=A9buchet?=
 <philippe.trebuchet@ssi.gouv.fr>,  Scott Shell <scottsh@microsoft.com>,
  Shuah Khan <shuah@kernel.org>,  Steve Dower <steve.dower@python.org>,
  Steve Grubb <sgrubb@redhat.com>,  Thibaut Sautereau
 <thibaut.sautereau@ssi.gouv.fr>,  Vincent Strubel
 <vincent.strubel@ssi.gouv.fr>,  Yin Fengwei <fengwei.yin@intel.com>,
  kernel-hardening@lists.openwall.com,  linux-api@vger.kernel.org,
  linux-fsdevel@vger.kernel.org,  linux-integrity@vger.kernel.org,
  linux-kernel@vger.kernel.org,  linux-security-module@vger.kernel.org
Subject: Re: [PATCH v17 0/3] Add trusted_for(2) (was O_MAYEXEC)
References: <20211115185304.198460-1-mic@digikod.net>
Date: Tue, 30 Nov 2021 21:27:15 +0100
In-Reply-To: <20211115185304.198460-1-mic@digikod.net> (=?utf-8?Q?=22Micka?=
 =?utf-8?Q?=C3=ABl_Sala=C3=BCn=22's?=
	message of "Mon, 15 Nov 2021 19:53:01 +0100")
Message-ID: <87sfvd8k4c.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11

* Micka=C3=ABl Sala=C3=BCn:

> Primary goal of trusted_for(2)
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>
> This new syscall enables user space to ask the kernel: is this file
> descriptor's content trusted to be used for this purpose?  The set of
> usage currently only contains execution, but other may follow (e.g.
> configuration, sensitive data).  If the kernel identifies the file
> descriptor as trustworthy for this usage, user space should then take
> this information into account.  The "execution" usage means that the
> content of the file descriptor is trusted according to the system policy
> to be executed by user space, which means that it interprets the content
> or (try to) maps it as executable memory.

I sketched my ideas about =E2=80=9CIMA gadgets=E2=80=9D here:

  IMA gadgets
  <https://www.openwall.com/lists/oss-security/2021/11/30/1>

I still don't think the proposed trusted_for interface is sufficient.
The example I gave is a Perl module that does nothing (on its own) when
loaded as a Perl module (although you probably don't want to sign it
anyway, given what it implements), but triggers an unwanted action when
sourced (using .) as a shell script.

> @usage identifies the user space usage intended for @fd: only
> TRUSTED_FOR_EXECUTION for now, but trusted_for_usage could be extended
> to identify other usages (e.g. configuration, sensitive data).

We would need TRUSTED_FOR_EXECUTION_BY_BASH,
TRUSTED_FOR_EXECUTION_BY_PERL, etc.  I'm not sure that actually works.

Caller process context does not work because we have this confusion
internally between glibc's own use (for the dynamic linker
configuration), and for loading programs/shared objects (there seems to
be a corner case where you can execute arbitrary code even without
executable mappings in the ELF object), and the script interpreter
itself (the primary target for trusted_for).

But for generating auditing events, trusted_for seems is probably quite
helpful.

Thanks,
Florian

