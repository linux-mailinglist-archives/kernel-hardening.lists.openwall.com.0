Return-Path: <kernel-hardening-return-18814-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7BF3D1D48BE
	for <lists+kernel-hardening@lfdr.de>; Fri, 15 May 2020 10:44:12 +0200 (CEST)
Received: (qmail 9818 invoked by uid 550); 15 May 2020 08:44:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9792 invoked from network); 15 May 2020 08:44:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1589532233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+98viFOd9jTdpHCY3sUvt3t0b4J5Yg6795DHu7DfVIk=;
	b=fKScrmokPCuiEv3RuFPvqUqtSW4pRmkmMSR+m4lh38ZgD+He292FGbDa0d1vO+m+zQM/FS
	hZS2ZoMIm6vpaQmRVG+WTcp5H2ZGUlT6LGY28+K/tGKndmvV9ym5GKCV4EXnuQEpX8Wv68
	TnnOhRJ7AnJGXiPknOKzEniP49FHPNI=
X-MC-Unique: u_nUq3bSN8OR1tg-mmpQdg-1
From: Florian Weimer <fweimer@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,  Al Viro
 <viro@zeniv.linux.org.uk>,
  Aleksa Sarai <cyphar@cyphar.com>,  Andy Lutomirski <luto@kernel.org>,
  Mimi Zohar <zohar@linux.ibm.com>,  Stephen Smalley
 <stephen.smalley.work@gmail.com>,  Christian Heimes
 <christian@python.org>,  Deven Bowers <deven.desai@linux.microsoft.com>,
  Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,  John Johansen
 <john.johansen@canonical.com>,  Kentaro Takeda <takedakn@nttdata.co.jp>,
  "Lev R. Oshvang ." <levonshe@gmail.com>,  Alexei Starovoitov
 <ast@kernel.org>,  Daniel Borkmann <daniel@iogearbox.net>,  Eric Chiang
 <ericchiang@google.com>,  James Morris <jmorris@namei.org>,  Jan Kara
 <jack@suse.cz>,  Jann Horn <jannh@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
  Matthew Garrett <mjg59@google.com>,  Matthew Wilcox
 <willy@infradead.org>,  Michael Kerrisk <mtk.manpages@gmail.com>,
  =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
  Philippe =?utf-8?Q?Tr=C3=A9buchet?=
 <philippe.trebuchet@ssi.gouv.fr>,  Scott Shell <scottsh@microsoft.com>,
  Sean Christopherson <sean.j.christopherson@intel.com>,  Shuah Khan
 <shuah@kernel.org>,  Steve Dower <steve.dower@python.org>,  Steve Grubb
 <sgrubb@redhat.com>,  Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
  Vincent Strubel <vincent.strubel@ssi.gouv.fr>,  linux-kernel
 <linux-kernel@vger.kernel.org>,  kernel-hardening@lists.openwall.com,
  linux-api@vger.kernel.org,  linux-integrity@vger.kernel.org,  LSM List
 <linux-security-module@vger.kernel.org>,  Linux FS Devel
 <linux-fsdevel@vger.kernel.org>
Subject: Re: How about just O_EXEC? (was Re: [PATCH v5 3/6] fs: Enable to enforce noexec mounts or file exec through O_MAYEXEC)
References: <20200505153156.925111-1-mic@digikod.net>
	<20200505153156.925111-4-mic@digikod.net>
	<CAEjxPJ7y2G5hW0WTH0rSrDZrorzcJ7nrQBjfps2OWV5t1BUYHw@mail.gmail.com>
	<202005131525.D08BFB3@keescook> <202005132002.91B8B63@keescook>
	<CAEjxPJ7WjeQAz3XSCtgpYiRtH+Jx-UkSTaEcnVyz_jwXKE3dkw@mail.gmail.com>
	<202005140830.2475344F86@keescook>
	<CAEjxPJ4R_juwvRbKiCg5OGuhAi1ZuVytK4fKCDT_kT6VKc8iRg@mail.gmail.com>
	<b740d658-a2da-5773-7a10-59a0ca52ac6b@digikod.net>
	<202005142343.D580850@keescook>
Date: Fri, 15 May 2020 10:43:34 +0200
In-Reply-To: <202005142343.D580850@keescook> (Kees Cook's message of "Fri, 15
	May 2020 01:01:32 -0700")
Message-ID: <87a729wpu1.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14

* Kees Cook:

> Maybe I've missed some earlier discussion that ruled this out, but I
> couldn't find it: let's just add O_EXEC and be done with it. It actually
> makes the execve() path more like openat2() and is much cleaner after
> a little refactoring. Here are the results, though I haven't emailed it
> yet since I still want to do some more testing:
> https://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git/log/?h=kspp/o_exec/v1

I think POSIX specifies O_EXEC in such a way that it does not confer
read permissions.  This seems incompatible with what we are trying to
achieve here.

Thanks,
Florian

