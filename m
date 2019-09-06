Return-Path: <kernel-hardening-return-16860-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 99728ABFF7
	for <lists+kernel-hardening@lfdr.de>; Fri,  6 Sep 2019 20:57:27 +0200 (CEST)
Received: (qmail 26065 invoked by uid 550); 6 Sep 2019 18:57:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26037 invoked from network); 6 Sep 2019 18:57:21 -0000
From: Florian Weimer <fweimer@redhat.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
  linux-kernel@vger.kernel.org,  Aleksa
 Sarai <cyphar@cyphar.com>,  Alexei Starovoitov <ast@kernel.org>,  Al Viro
 <viro@zeniv.linux.org.uk>,  Andy Lutomirski <luto@kernel.org>,  Christian
 Heimes <christian@python.org>,  Daniel Borkmann <daniel@iogearbox.net>,
  Eric Chiang <ericchiang@google.com>,  James Morris <jmorris@namei.org>,
  Jan Kara <jack@suse.cz>,  Jann Horn <jannh@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  Kees Cook <keescook@chromium.org>,  Matthew Garrett
 <mjg59@google.com>,  Matthew Wilcox <willy@infradead.org>,  Michael
 Kerrisk <mtk.manpages@gmail.com>,  =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=
 <mickael.salaun@ssi.gouv.fr>,  Mimi Zohar <zohar@linux.ibm.com>,  Philippe
 =?utf-8?Q?Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>,  Scott Shell
 <scottsh@microsoft.com>,  Sean Christopherson
 <sean.j.christopherson@intel.com>,  Shuah Khan <shuah@kernel.org>,  Song
 Liu <songliubraving@fb.com>,  Steve Dower <steve.dower@python.org>,
  Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,  Vincent Strubel
 <vincent.strubel@ssi.gouv.fr>,  Yves-Alexis Perez
 <yves-alexis.perez@ssi.gouv.fr>,  kernel-hardening@lists.openwall.com,
  linux-api@vger.kernel.org,  linux-security-module@vger.kernel.org,
  linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] Add support for O_MAYEXEC
References: <20190906152455.22757-1-mic@digikod.net> <2989749.1YmIBkDdQn@x2>
Date: Fri, 06 Sep 2019 20:57:00 +0200
In-Reply-To: <2989749.1YmIBkDdQn@x2> (Steve Grubb's message of "Fri, 06 Sep
	2019 14:50:02 -0400")
Message-ID: <87mufhckxv.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.66]); Fri, 06 Sep 2019 18:57:10 +0000 (UTC)

* Steve Grubb:

> Now with LD_AUDIT
> $ LD_AUDIT=/home/sgrubb/test/openflags/strip-flags.so.0 strace ./test 2>&1 | grep passwd
> openat(3, "passwd", O_RDONLY)           = 4
>
> No O_CLOEXEC flag.

I think you need to explain in detail why you consider this a problem.

With LD_PRELOAD and LD_AUDIT, you can already do anything, including
scanning other loaded objects for a system call instruction and jumping
to that (in case a security module in the kernel performs a PC check to
confer additional privileges).

Thanks,
Florian
