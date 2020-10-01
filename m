Return-Path: <kernel-hardening-return-20083-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4C489280868
	for <lists+kernel-hardening@lfdr.de>; Thu,  1 Oct 2020 22:24:22 +0200 (CEST)
Received: (qmail 11499 invoked by uid 550); 1 Oct 2020 20:24:16 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11464 invoked from network); 1 Oct 2020 20:24:15 -0000
Subject: Re: [PATCH v11 2/3] arch: Wire up trusted_for(2)
To: Tycho Andersen <tycho@tycho.pizza>, Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>, James Morris <jmorris@namei.org>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>,
 Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>,
 Andy Lutomirski <luto@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>,
 Christian Brauner <christian.brauner@ubuntu.com>,
 Christian Heimes <christian@python.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Deven Bowers <deven.desai@linux.microsoft.com>,
 Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>,
 Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>,
 Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>,
 Kees Cook <keescook@chromium.org>,
 Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
 "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>,
 Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>,
 Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>,
 =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>,
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Thibaut Sautereau <thibaut.sautereau@clip-os.org>,
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@linux.microsoft.com>,
 Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
References: <20201001170232.522331-1-mic@digikod.net>
 <20201001170232.522331-3-mic@digikod.net> <20201001193306.GE1260245@cisco>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <7ccdf4b0-8158-fb82-fb4f-ad78518dbc30@digikod.net>
Date: Thu, 1 Oct 2020 22:23:54 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <20201001193306.GE1260245@cisco>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 01/10/2020 21:33, Tycho Andersen wrote:
> On Thu, Oct 01, 2020 at 07:02:31PM +0200, Micka�l Sala�n wrote:
>> --- a/include/uapi/asm-generic/unistd.h
>> +++ b/include/uapi/asm-generic/unistd.h
>> @@ -859,9 +859,11 @@ __SYSCALL(__NR_openat2, sys_openat2)
>>  __SYSCALL(__NR_pidfd_getfd, sys_pidfd_getfd)
>>  #define __NR_faccessat2 439
>>  __SYSCALL(__NR_faccessat2, sys_faccessat2)
>> +#define __NR_trusted_for 443
>> +__SYSCALL(__NR_trusted_for, sys_trusted_for)
>>  
>>  #undef __NR_syscalls
>> -#define __NR_syscalls 440
>> +#define __NR_syscalls 444
> 
> Looks like a rebase problem here?

No, it is a synchronization with the -next tree (cf. changelog) as asked
(and acked for a previous version) by Arnd.
