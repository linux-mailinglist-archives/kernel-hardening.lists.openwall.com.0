Return-Path: <kernel-hardening-return-19588-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F1ED424187D
	for <lists+kernel-hardening@lfdr.de>; Tue, 11 Aug 2020 10:49:42 +0200 (CEST)
Received: (qmail 27726 invoked by uid 550); 11 Aug 2020 08:49:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 27706 invoked from network); 11 Aug 2020 08:49:37 -0000
Subject: Re: [PATCH v7 0/7] Add support for O_MAYEXEC
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>,
 Andy Lutomirski <luto@kernel.org>,
 Christian Brauner <christian.brauner@ubuntu.com>,
 Christian Heimes <christian@python.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Deven Bowers <deven.desai@linux.microsoft.com>,
 Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>,
 Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>,
 James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
 Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
 Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
 Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>, Mimi Zohar <zohar@linux.ibm.com>,
 =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
 Steve Grubb <sgrubb@redhat.com>,
 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
 Thibaut Sautereau <thibaut.sautereau@clip-os.org>,
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20200723171227.446711-1-mic@digikod.net>
 <202007241205.751EBE7@keescook>
 <0733fbed-cc73-027b-13c7-c368c2d67fb3@digikod.net>
 <20200810202123.GC1236603@ZenIV.linux.org.uk>
 <917bb071-8b1a-3ba4-dc16-f8d7b4cc849f@digikod.net>
 <20200810230521.GG1236603@ZenIV.linux.org.uk>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <c34e72c1-e7ef-7538-886e-c156ab278081@digikod.net>
Date: Tue, 11 Aug 2020 10:49:24 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <20200810230521.GG1236603@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000


On 11/08/2020 01:05, Al Viro wrote:
> On Tue, Aug 11, 2020 at 12:43:52AM +0200, Mickaël Salaün wrote:
> 
>> Hooking on open is a simple design that enables processes to check files
>> they intend to open, before they open them.
> 
> Which is a good thing, because...?
> 
>> From an API point of view,
>> this series extends openat2(2) with one simple flag: O_MAYEXEC. The
>> enforcement is then subject to the system policy (e.g. mount points,
>> file access rights, IMA, etc.).
> 
> That's what "unspecified" means - as far as the kernel concerned, it's
> "something completely opaque, will let these hooks to play, semantics is
> entirely up to them".

I see it as an access controls mechanism; access may be granted or
denied, as for O_RDONLY, O_WRONLY or (non-Linux) O_EXEC. Even for common
access controls, there are capabilities to bypass them (i.e.
CAP_DAC_OVERRIDE), but multiple layers may enforce different
complementary policies.

>  
>> Checking on open enables to not open a file if it does not meet some
>> requirements, the same way as if the path doesn't exist or (for whatever
>> reasons, including execution permission) if access is denied. It is a
>> good practice to check as soon as possible such properties, and it may
>> enables to avoid (user space) time-of-check to time-of-use (TOCTOU)
>> attacks (i.e. misuse of already open resources).
> 
> ?????  You explicitly assume a cooperating caller.

As said in the below (removed) reply, no, quite the contrary.

>  If it can't be trusted
> to issue the check between open and use, or can be manipulated (ptraced,
> etc.) into not doing so, how can you rely upon the flag having been passed
> in the first place?  And TOCTOU window is definitely not wider that way.

OK, I guess it would be considered a bug in the application (e.g. buggy
resource management between threads).

> 
> If you want to have it done immediately after open(), bloody well do it
> immediately after open.  If attacker has subverted your control flow to the
> extent that allows them to hit descriptor table in the interval between
> these two syscalls, you have already lost - they'll simply prevent that
> flag from being passed.
> 
> What's the point of burying it inside openat2()?  A convenient multiplexor
> to hook into?  We already have one - it's called do_syscall_...
> 

To check as soon as possible without opening something that should not
be opened in the first place.

Isn't a dedicated syscall a bit too much for this feature? What about
adding a new command/flag to fcntl(2)?
