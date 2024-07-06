Return-Path: <kernel-hardening-return-21745-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 178DF929496
	for <lists+kernel-hardening@lfdr.de>; Sat,  6 Jul 2024 17:33:06 +0200 (CEST)
Received: (qmail 10082 invoked by uid 550); 6 Jul 2024 15:32:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 10048 invoked from network); 6 Jul 2024 15:32:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1720279966;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oBRFKUriB/1HZETMXeJgCSmmjgsoAHSm5ov/S8Qilac=;
	b=WXOaq3Y0yvfR8nUSbAmcUJJ1KUS+ktc0BTfTEpw8h+GR5oozA0H1XvyOBC2xgN5wHSOkh4
	35sJgqVIQuiLX6LhL8vlH6tLXihpTwX1+NO5fIvMgvhXGzOfestgDDnMSoREn9JZHE8rJv
	27LjgATT7pfzxpU54ye8GG/Mcw8ozCE=
X-MC-Unique: QvlzTIlEODCCaBeRXTNIIQ-1
From: Florian Weimer <fweimer@redhat.com>
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>,  Christian Brauner
 <brauner@kernel.org>,  Kees Cook <keescook@chromium.org>,  Linus Torvalds
 <torvalds@linux-foundation.org>,  Paul Moore <paul@paul-moore.com>,
  Theodore Ts'o <tytso@mit.edu>,  Alejandro Colomar <alx@kernel.org>,
  Aleksa Sarai <cyphar@cyphar.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Andy Lutomirski <luto@kernel.org>,  Arnd
 Bergmann <arnd@arndb.de>,  Casey Schaufler <casey@schaufler-ca.com>,
  Christian Heimes <christian@python.org>,  Dmitry Vyukov
 <dvyukov@google.com>,  Eric Biggers <ebiggers@kernel.org>,  Eric Chiang
 <ericchiang@google.com>,  Fan Wu <wufan@linux.microsoft.com>,  Geert
 Uytterhoeven <geert@linux-m68k.org>,  James Morris
 <jamorris@linux.microsoft.com>,  Jan Kara <jack@suse.cz>,  Jann Horn
 <jannh@google.com>,  Jeff Xu <jeffxu@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  Jordan R Abrahams <ajordanr@google.com>,  Lakshmi
 Ramasubramanian <nramas@linux.microsoft.com>,  Luca Boccassi
 <bluca@debian.org>,  Luis Chamberlain <mcgrof@kernel.org>,  "Madhavan T .
 Venkataraman" <madvenka@linux.microsoft.com>,  Matt Bobrowski
 <mattbobrowski@google.com>,  Matthew Garrett <mjg59@srcf.ucam.org>,
  Matthew Wilcox <willy@infradead.org>,  Miklos Szeredi
 <mszeredi@redhat.com>,  Mimi Zohar <zohar@linux.ibm.com>,  Nicolas
 Bouchinet <nicolas.bouchinet@ssi.gouv.fr>,  Scott Shell
 <scottsh@microsoft.com>,  Shuah Khan <shuah@kernel.org>,  Stephen Rothwell
 <sfr@canb.auug.org.au>,  Steve Dower <steve.dower@python.org>,  Steve
 Grubb <sgrubb@redhat.com>,  Thibaut Sautereau
 <thibaut.sautereau@ssi.gouv.fr>,  Vincent Strubel
 <vincent.strubel@ssi.gouv.fr>,  Xiaoming Ni <nixiaoming@huawei.com>,  Yin
 Fengwei <fengwei.yin@intel.com>,  kernel-hardening@lists.openwall.com,
  linux-api@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
  linux-integrity@vger.kernel.org,  linux-kernel@vger.kernel.org,
  linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH v19 1/5] exec: Add a new AT_CHECK flag to execveat(2)
In-Reply-To: <20240706.poo9ahd3La9b@digikod.net> (=?utf-8?Q?=22Micka=C3=AB?=
 =?utf-8?Q?l_Sala=C3=BCn=22's?= message
	of "Sat, 6 Jul 2024 16:55:51 +0200")
References: <20240704190137.696169-1-mic@digikod.net>
	<20240704190137.696169-2-mic@digikod.net>
	<87bk3bvhr1.fsf@oldenburg.str.redhat.com>
	<20240706.poo9ahd3La9b@digikod.net>
Date: Sat, 06 Jul 2024 17:32:12 +0200
Message-ID: <871q46bkoz.fsf@oldenburg.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

* Micka=C3=ABl Sala=C3=BCn:

> On Fri, Jul 05, 2024 at 08:03:14PM +0200, Florian Weimer wrote:
>> * Micka=C3=ABl Sala=C3=BCn:
>>=20
>> > Add a new AT_CHECK flag to execveat(2) to check if a file would be
>> > allowed for execution.  The main use case is for script interpreters a=
nd
>> > dynamic linkers to check execution permission according to the kernel's
>> > security policy. Another use case is to add context to access logs e.g=
.,
>> > which script (instead of interpreter) accessed a file.  As any
>> > executable code, scripts could also use this check [1].
>>=20
>> Some distributions no longer set executable bits on most shared objects,
>> which I assume would interfere with AT_CHECK probing for shared objects.
>
> A file without the execute permission is not considered as executable by
> the kernel.  The AT_CHECK flag doesn't change this semantic.  Please
> note that this is just a check, not a restriction.  See the next patch
> for the optional policy enforcement.
>
> Anyway, we need to define the policy, and for Linux this is done with
> the file permission bits.  So for systems willing to have a consistent
> execution policy, we need to rely on the same bits.

Yes, that makes complete sense.  I just wanted to point out the odd
interaction with the old binutils bug and the (sadly still current)
kernel bug.

>> Removing the executable bit is attractive because of a combination of
>> two bugs: a binutils wart which until recently always set the entry
>> point address in the ELF header to zero, and the kernel not checking for
>> a zero entry point (maybe in combination with an absent program
>> interpreter) and failing the execve with ELIBEXEC, instead of doing the
>> execve and then faulting at virtual address zero.  Removing the
>> executable bit is currently the only way to avoid these confusing
>> crashes, so I understand the temptation.
>
> Interesting.  Can you please point to the bug report and the fix?  I
> don't see any ELIBEXEC in the kernel.

The kernel hasn't been fixed yet.  I do think this should be fixed, so
that distributions can bring back the executable bit.

Thanks,
Florian

