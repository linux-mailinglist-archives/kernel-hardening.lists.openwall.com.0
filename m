Return-Path: <kernel-hardening-return-16845-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BE2C7ABD13
	for <lists+kernel-hardening@lfdr.de>; Fri,  6 Sep 2019 17:56:58 +0200 (CEST)
Received: (qmail 24547 invoked by uid 550); 6 Sep 2019 15:56:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24524 invoked from network); 6 Sep 2019 15:56:52 -0000
From: Florian Weimer <fweimer@redhat.com>
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org,  Aleksa Sarai <cyphar@cyphar.com>,  Alexei
 Starovoitov <ast@kernel.org>,  Al Viro <viro@zeniv.linux.org.uk>,  Andy
 Lutomirski <luto@kernel.org>,  Christian Heimes <christian@python.org>,
  Daniel Borkmann <daniel@iogearbox.net>,  Eric Chiang
 <ericchiang@google.com>,  James Morris <jmorris@namei.org>,  Jan Kara
 <jack@suse.cz>,  Jann Horn <jannh@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  Kees Cook <keescook@chromium.org>,  Matthew Garrett
 <mjg59@google.com>,  Matthew Wilcox <willy@infradead.org>,  Michael
 Kerrisk <mtk.manpages@gmail.com>,  =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=
 <mickael.salaun@ssi.gouv.fr>,  Mimi Zohar <zohar@linux.ibm.com>,  Philippe
 =?utf-8?Q?Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>,  Scott Shell
 <scottsh@microsoft.com>,  Sean Christopherson
 <sean.j.christopherson@intel.com>,  Shuah Khan <shuah@kernel.org>,  Song
 Liu <songliubraving@fb.com>,  Steve Dower <steve.dower@python.org>,  Steve
 Grubb <sgrubb@redhat.com>,  Thibaut Sautereau
 <thibaut.sautereau@ssi.gouv.fr>,  Vincent Strubel
 <vincent.strubel@ssi.gouv.fr>,  Yves-Alexis Perez
 <yves-alexis.perez@ssi.gouv.fr>,  kernel-hardening@lists.openwall.com,
  linux-api@vger.kernel.org,  linux-security-module@vger.kernel.org,
  linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] fs: Add support for an O_MAYEXEC flag on sys_open()
References: <20190906152455.22757-1-mic@digikod.net>
	<20190906152455.22757-2-mic@digikod.net>
Date: Fri, 06 Sep 2019 17:56:32 +0200
In-Reply-To: <20190906152455.22757-2-mic@digikod.net> (=?utf-8?Q?=22Micka?=
 =?utf-8?Q?=C3=ABl_Sala=C3=BCn=22's?=
	message of "Fri, 6 Sep 2019 17:24:51 +0200")
Message-ID: <87ef0te7v3.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Fri, 06 Sep 2019 15:56:40 +0000 (UTC)

Let's assume I want to add support for this to the glibc dynamic loader,
while still being able to run on older kernels.

Is it safe to try the open call first, with O_MAYEXEC, and if that fails
with EINVAL, try again without O_MAYEXEC?

Or do I risk disabling this security feature if I do that?

Do we need a different way for recognizing kernel support.  (Note that
we cannot probe paths in /proc for various reasons.)

Thanks,
Florian
