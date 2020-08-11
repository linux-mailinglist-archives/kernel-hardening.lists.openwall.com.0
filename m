Return-Path: <kernel-hardening-return-19587-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 5ED45241872
	for <lists+kernel-hardening@lfdr.de>; Tue, 11 Aug 2020 10:48:59 +0200 (CEST)
Received: (qmail 25872 invoked by uid 550); 11 Aug 2020 08:48:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25848 invoked from network); 11 Aug 2020 08:48:52 -0000
Subject: Re: [PATCH v7 0/7] Add support for O_MAYEXEC
To: Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
 Deven Bowers <deven.desai@linux.microsoft.com>,
 Mimi Zohar <zohar@linux.ibm.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>,
 kernel list <linux-kernel@vger.kernel.org>, Aleksa Sarai
 <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>,
 Andy Lutomirski <luto@kernel.org>,
 Christian Brauner <christian.brauner@ubuntu.com>,
 Christian Heimes <christian@python.org>,
 Daniel Borkmann <daniel@iogearbox.net>, Dmitry Vyukov <dvyukov@google.com>,
 Eric Biggers <ebiggers@kernel.org>, Eric Chiang <ericchiang@google.com>,
 Florian Weimer <fweimer@redhat.com>, James Morris <jmorris@namei.org>,
 Jan Kara <jack@suse.cz>, Jonathan Corbet <corbet@lwn.net>,
 Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
 Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>,
 =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
 Steve Grubb <sgrubb@redhat.com>,
 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
 Thibaut Sautereau <thibaut.sautereau@clip-os.org>,
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Linux API <linux-api@vger.kernel.org>, linux-integrity@vger.kernel.org,
 linux-security-module <linux-security-module@vger.kernel.org>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>
References: <20200723171227.446711-1-mic@digikod.net>
 <202007241205.751EBE7@keescook>
 <0733fbed-cc73-027b-13c7-c368c2d67fb3@digikod.net>
 <20200810202123.GC1236603@ZenIV.linux.org.uk>
 <917bb071-8b1a-3ba4-dc16-f8d7b4cc849f@digikod.net>
 <CAG48ez0NAV5gPgmbDaSjo=zzE=FgnYz=-OHuXwu0Vts=B5gesA@mail.gmail.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <0cc94c91-afd3-27cd-b831-8ea16ca8ca93@digikod.net>
Date: Tue, 11 Aug 2020 10:48:37 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <CAG48ez0NAV5gPgmbDaSjo=zzE=FgnYz=-OHuXwu0Vts=B5gesA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000


On 11/08/2020 01:03, Jann Horn wrote:
> On Tue, Aug 11, 2020 at 12:43 AM Mickaël Salaün <mic@digikod.net> wrote:
>> On 10/08/2020 22:21, Al Viro wrote:
>>> On Mon, Aug 10, 2020 at 10:11:53PM +0200, Mickaël Salaün wrote:
>>>> It seems that there is no more complains nor questions. Do you want me
>>>> to send another series to fix the order of the S-o-b in patch 7?
>>>
>>> There is a major question regarding the API design and the choice of
>>> hooking that stuff on open().  And I have not heard anything resembling
>>> a coherent answer.
>>
>> Hooking on open is a simple design that enables processes to check files
>> they intend to open, before they open them. From an API point of view,
>> this series extends openat2(2) with one simple flag: O_MAYEXEC. The
>> enforcement is then subject to the system policy (e.g. mount points,
>> file access rights, IMA, etc.).
>>
>> Checking on open enables to not open a file if it does not meet some
>> requirements, the same way as if the path doesn't exist or (for whatever
>> reasons, including execution permission) if access is denied.
> 
> You can do exactly the same thing if you do the check in a separate
> syscall though.
> 
> And it provides a greater degree of flexibility; for example, you can
> use it in combination with fopen() without having to modify the
> internals of fopen() or having to use fdopen().
> 
>> It is a
>> good practice to check as soon as possible such properties, and it may
>> enables to avoid (user space) time-of-check to time-of-use (TOCTOU)
>> attacks (i.e. misuse of already open resources).
> 
> The assumption that security checks should happen as early as possible
> can actually cause security problems. For example, because seccomp was
> designed to do its checks as early as possible, including before
> ptrace, we had an issue for a long time where the ptrace API could be
> abused to bypass seccomp filters.
> 
> Please don't decide that a check must be ordered first _just_ because
> it is a security check. While that can be good for limiting attack
> surface, it can also create issues when the idea is applied too
> broadly.

I'd be interested with such security issue examples.

I hope that delaying checks will not be an issue for mechanisms such as
IMA or IPE:
https://lore.kernel.org/lkml/1544699060.6703.11.camel@linux.ibm.com/

Any though Mimi, Deven, Chrome OS folks?

> 
> I don't see how TOCTOU issues are relevant in any way here. If someone
> can turn a script that is considered a trusted file into an untrusted
> file and then maliciously change its contents, you're going to have
> issues either way because the modifications could still happen after
> openat(); if this was possible, the whole thing would kind of fall
> apart. And if that isn't possible, I don't see any TOCTOU.

Sure, and if the scripts are not protected in some way there is no point
to check anything.

> 
>> It is important to keep
>> in mind that the use cases we are addressing consider that the (user
>> space) script interpreters (or linkers) are trusted and unaltered (i.e.
>> integrity/authenticity checked). These are similar sought defensive
>> properties as for SUID/SGID binaries: attackers can still launch them
>> with malicious inputs (e.g. file paths, file descriptors, environment
>> variables, etc.), but the binaries can then have a way to check if they
>> can extend their trust to some file paths.
>>
>> Checking file descriptors may help in some use cases, but not the ones
>> motivating this series.
> 
> It actually provides a superset of the functionality that your
> existing patches provide.

It also brings new issues with multiple file descriptor origins (e.g.
memfd_create).

> 
>> Checking (already) opened resources could be a
>> *complementary* way to check execute permission, but it is not in the
>> scope of this series.
