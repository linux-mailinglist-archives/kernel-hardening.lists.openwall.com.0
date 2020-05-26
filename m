Return-Path: <kernel-hardening-return-18715-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C2B5B1C5A3A
	for <lists+kernel-hardening@lfdr.de>; Tue,  5 May 2020 16:57:58 +0200 (CEST)
Received: (qmail 3433 invoked by uid 550); 5 May 2020 14:57:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3407 invoked from network); 5 May 2020 14:57:51 -0000
Subject: Re: [PATCH v3 0/5] Add support for RESOLVE_MAYEXEC
To: Christian Heimes <christian@python.org>, Jann Horn <jannh@google.com>,
 Florian Weimer <fw@deneb.enyo.de>
Cc: kernel list <linux-kernel@vger.kernel.org>,
 Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Deven Bowers <deven.desai@linux.microsoft.com>,
 Eric Chiang <ericchiang@google.com>, James Morris <jmorris@namei.org>,
 Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>,
 Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>,
 Matthew Wilcox <willy@infradead.org>,
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
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Linux API <linux-api@vger.kernel.org>,
 linux-security-module <linux-security-module@vger.kernel.org>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <20200428175129.634352-1-mic@digikod.net>
 <CAG48ez1bKzh1YvbD_Lcg0AbMCH_cdZmrRRumU7UCJL=qPwNFpQ@mail.gmail.com>
 <87blnb48a3.fsf@mid.deneb.enyo.de>
 <CAG48ez2TphTj-VdDaSjvnr0Q8BhNmT3n86xYz4bF3wRJmAMsMw@mail.gmail.com>
 <b78d2d0d-04cf-c0a9-bd88-20c6ec6705fd@python.org>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <8d47dfe6-1ff7-e5fe-d4d0-c2493db3fd63@digikod.net>
Date: Tue, 5 May 2020 16:57:36 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <b78d2d0d-04cf-c0a9-bd88-20c6ec6705fd@python.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000


On 01/05/2020 13:47, Christian Heimes wrote:
> On 29/04/2020 00.01, Jann Horn wrote:
>> On Tue, Apr 28, 2020 at 11:21 PM Florian Weimer <fw@deneb.enyo.de> wrote:
>>> * Jann Horn:
>>>
>>>> Just as a comment: You'd probably also have to use RESOLVE_MAYEXEC in
>>>> the dynamic linker.
>>>
>>> Absolutely.  In typical configurations, the kernel does not enforce
>>> that executable mappings must be backed by files which are executable.
>>> It's most obvious with using an explicit loader invocation to run
>>> executables on noexec mounts.  RESOLVE_MAYEXEC is much more useful
>>> than trying to reimplement the kernel permission checks (or what some
>>> believe they should be) in userspace.
>>
>> Oh, good point.
>>
>> That actually seems like something Mickaël could add to his series? If
>> someone turns on that knob for "When an interpreter wants to execute
>> something, enforce that we have execute access to it", they probably
>> also don't want it to be possible to just map files as executable? So
>> perhaps when that flag is on, the kernel should either refuse to map
>> anything as executable if it wasn't opened with RESOLVE_MAYEXEC or
>> (less strict) if RESOLVE_MAYEXEC wasn't used, print a warning, then
>> check whether the file is executable and bail out if not?
>>
>> A configuration where interpreters verify that scripts are executable,
>> but other things can just mmap executable pages, seems kinda
>> inconsistent...
> 
> +1
> 
> I worked with Steve Downer on Python PEP 578 [1] that added audit hooks
> and PyFile_OpenCode() to CPython. A PyFile_OpenCode() implementation
> with RESOLVE_MAYEXEC will hep to secure loading of Python code. But
> Python also includes a wrapper of libffi. ctypes or cffi can load native
> code from either shared libraries with dlopen() or execute native code
> from mmap() regions. For example SnakeEater [2] is a clever attack that
> abused memfd_create syscall and proc filesystem to execute code.
> 
> A consistent security policy must also ensure that mmap() PROT_EXEC
> enforces the same restrictions as RESOLVE_MAYEXEC. The restriction
> doesn't have be part of this patch, though.
> 
> Christian
> 
> [1] https://www.python.org/dev/peps/pep-0578/
> [2] https://github.com/nullbites/SnakeEater/blob/master/SnakeEater2.py

To be consistent, a "noexec" policy must indeed also restricts features
such as mprotect(2) and mmap(2) which may enable to set arbitrary memory
as executable. This can be restricted with SELinux (i.e. execmem,
execmod,execheap and execstack permissions), PaX MPROTECT [1] or SARA [2].

[1] https://pax.grsecurity.net/docs/mprotect.txt
[2]
https://lore.kernel.org/lkml/1562410493-8661-1-git-send-email-s.mesoraca16@gmail.com/
