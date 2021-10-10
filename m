Return-Path: <kernel-hardening-return-21437-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3DB484283E6
	for <lists+kernel-hardening@lfdr.de>; Sun, 10 Oct 2021 23:48:37 +0200 (CEST)
Received: (qmail 10195 invoked by uid 550); 10 Oct 2021 21:48:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 10175 invoked from network); 10 Oct 2021 21:48:30 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1633902498;
	bh=Os1zFWJs35sbezQJoPQtAyMJ89e8Gqc+3V2HYbnUOd8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NRfM6eiDtLst84XKF8OFuyoJi7MII8++8TItsaxfRYEVT5FNTYbpW8NXcHt0FidGb
	 YGtWJZh5ox9iYKWaAMIiE4QPpu5oeZkcCuzTsWHO6N+/6BNk4c2Rd+yuNQoYKnCogV
	 BlXskGaJeY1nmrgdUi5jl4GaMkBYnbIBQe/G9XRY=
Date: Sun, 10 Oct 2021 14:48:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: =?ISO-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Aleksa Sarai <cyphar@cyphar.com>,
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Casey
 Schaufler <casey@schaufler-ca.com>, Christian Brauner
 <christian.brauner@ubuntu.com>, Christian Heimes <christian@python.org>,
 Deven Bowers <deven.desai@linux.microsoft.com>, Dmitry Vyukov
 <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>, Eric Chiang
 <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>, Geert
 Uytterhoeven <geert@linux-m68k.org>, James Morris <jmorris@namei.org>, Jan
 Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet
 <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Lakshmi
 Ramasubramanian <nramas@linux.microsoft.com>, "Madhavan T . Venkataraman"
 <madvenka@linux.microsoft.com>, Matthew Garrett <mjg59@google.com>, Matthew
 Wilcox <willy@infradead.org>, Miklos Szeredi <mszeredi@redhat.com>, Mimi
 Zohar <zohar@linux.ibm.com>, Paul Moore <paul@paul-moore.com>, Philippe
 =?ISO-8859-1?Q?Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Scott Shell
 <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>, Steve Dower
 <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, Thibaut
 Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel
 <vincent.strubel@ssi.gouv.fr>, kernel-hardening@lists.openwall.com,
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-security-module@vger.kernel.org
Subject: Re: [PATCH v14 0/3] Add trusted_for(2) (was O_MAYEXEC)
Message-Id: <20211010144814.d9fb99de6b0af65b67dc96cb@linux-foundation.org>
In-Reply-To: <20211008104840.1733385-1-mic@digikod.net>
References: <20211008104840.1733385-1-mic@digikod.net>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Fri,  8 Oct 2021 12:48:37 +0200 Micka=EBl Sala=FCn <mic@digikod.net> wro=
te:

> The final goal of this patch series is to enable the kernel to be a
> global policy manager by entrusting processes with access control at
> their level.  To reach this goal, two complementary parts are required:
> * user space needs to be able to know if it can trust some file
>   descriptor content for a specific usage;
> * and the kernel needs to make available some part of the policy
>   configured by the system administrator.

Apologies if I missed this...

It would be nice to see a description of the proposed syscall interface
in these changelogs!  Then a few questions I have will be answered...

long trusted_for(const int fd,
		 const enum trusted_for_usage usage,
		 const u32 flags)

- `usage' must be equal to TRUSTED_FOR_EXECUTION, so why does it
  exist?  Some future modes are planned?  Please expand on this.

- `flags' is unused (must be zero).  So why does it exist?  What are
  the plans here?

- what values does the syscall return and what do they mean?
