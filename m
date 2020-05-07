Return-Path: <kernel-hardening-return-18734-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 004231C85D0
	for <lists+kernel-hardening@lfdr.de>; Thu,  7 May 2020 11:30:23 +0200 (CEST)
Received: (qmail 1124 invoked by uid 550); 7 May 2020 09:30:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1104 invoked from network); 7 May 2020 09:30:17 -0000
Subject: Re: [PATCH v5 0/6] Add support for O_MAYEXEC
To: David Laight <David.Laight@ACULAB.COM>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>,
 Christian Heimes <christian@python.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Deven Bowers <deven.desai@linux.microsoft.com>,
 Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>,
 James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
 Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
 Kees Cook <keescook@chromium.org>,
 Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
 Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
 Mimi Zohar <zohar@linux.ibm.com>,
 =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
 Steve Grubb <sgrubb@redhat.com>,
 Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
 "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
 "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
 "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
 "linux-security-module@vger.kernel.org"
 <linux-security-module@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <20200505153156.925111-1-mic@digikod.net>
 <20b24b9ca0a64afb9389722845738ec8@AcuMS.aculab.com>
 <907109c8-9b19-528a-726f-92c3f61c1563@digikod.net>
 <ad28ab5fe7854b41a575656e95b4da17@AcuMS.aculab.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <64426377-7fc4-6f37-7371-2e2a584e3032@digikod.net>
Date: Thu, 7 May 2020 11:30:02 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <ad28ab5fe7854b41a575656e95b4da17@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000


On 07/05/2020 11:00, David Laight wrote:
> From: Mickaël Salaün
>> Sent: 07 May 2020 09:37
> ...
>>> None of that description actually says what the patch actually does.
>>
>> "Add support for O_MAYEXEC" "to enable to control script execution".
>> What is not clear here? This seems well understood by other commenters.
>> The documentation patch and the talks can also help.
> 
> I'm guessing that passing O_MAYEXEC to open() requests the kernel
> check for execute 'x' permissions (as well as read).

Yes, but only with openat2().

> 
> Then kernel policy determines whether 'read' access is actually enough,
> or whether 'x' access (possibly masked by mount permissions) is needed.
> 
> If that is true, two lines say what is does.

The "A simple system-wide security policy" paragraph introduce that, but
I'll highlight it in the next cover letter. The most important point is
to understand why it is required, before getting to how it will be
implemented.

> 
> Have you ever set a shell script permissions to --x--s--x ?
> Ends up being executable by everyone except the owner!

In this case the script is indeed executable but it can't be executed
because the interpreter (i.e. the user) needs to be able to read the
file. Of course, if the user has CAP_DAC_OVERRIDE (like the root user),
read is still allowed.

> Having the kernel pass all '#!' files to their interpreters
> through an open fd might help security.

This is interesting but it doesn't address the current issue: being able
to have a consistent (script) executability system policy. Maybe its
this point of view which wasn't clear enough?

> In that case the user doesn't need read access to the file
> in order to get an interpreter to process it.

Yes, but this brings security issues, because the interpreter (i.e. the
user) would then be able to read files without read permission.

> (You'd need to stop strace showing the contents to actually
> hide them.)

It doesn't matter if the process is traced or not, the kernel handles
impersonation scopes thanks to ptrace_may_access().
