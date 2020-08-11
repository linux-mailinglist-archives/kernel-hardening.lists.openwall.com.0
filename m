Return-Path: <kernel-hardening-return-19589-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A4E21241883
	for <lists+kernel-hardening@lfdr.de>; Tue, 11 Aug 2020 10:51:12 +0200 (CEST)
Received: (qmail 29736 invoked by uid 550); 11 Aug 2020 08:51:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 29716 invoked from network); 11 Aug 2020 08:51:07 -0000
Subject: Re: [PATCH v7 0/7] Add support for O_MAYEXEC
To: David Laight <David.Laight@aculab.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Kees Cook <keescook@chromium.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
 "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
 "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
 "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
 "linux-security-module@vger.kernel.org"
 <linux-security-module@vger.kernel.org>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <20200723171227.446711-1-mic@digikod.net>
 <202007241205.751EBE7@keescook>
 <0733fbed-cc73-027b-13c7-c368c2d67fb3@digikod.net>
 <20200810202123.GC1236603@ZenIV.linux.org.uk>
 <30b8c003f49d4280be5215f634ca2c06@AcuMS.aculab.com>
 <20200810222838.GF1236603@ZenIV.linux.org.uk>
 <2531a0e8-5122-867c-ba06-5d2e623a3834@digikod.net>
 <26a4a8378f3b4ad28eaa476853092716@AcuMS.aculab.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <c0224c08-f669-168e-3bb4-35eceec96a8b@digikod.net>
Date: Tue, 11 Aug 2020 10:50:53 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <26a4a8378f3b4ad28eaa476853092716@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000


On 11/08/2020 10:09, David Laight wrote:
>> On 11/08/2020 00:28, Al Viro wrote:
>>> On Mon, Aug 10, 2020 at 10:09:09PM +0000, David Laight wrote:
>>>>> On Mon, Aug 10, 2020 at 10:11:53PM +0200, Mickaël Salaün wrote:
>>>>>> It seems that there is no more complains nor questions. Do you want me
>>>>>> to send another series to fix the order of the S-o-b in patch 7?
>>>>>
>>>>> There is a major question regarding the API design and the choice of
>>>>> hooking that stuff on open().  And I have not heard anything resembling
>>>>> a coherent answer.
>>>>
>>>> To me O_MAYEXEC is just the wrong name.
>>>> The bit would be (something like) O_INTERPRET to indicate
>>>> what you want to do with the contents.
>>
>> The properties is "execute permission". This can then be checked by
>> interpreters or other applications, then the generic O_MAYEXEC name.
> 
> The english sense of MAYEXEC is just wrong for what you are trying
> to check.

We think it reflects exactly what it's purpose is.

> 
>>> ... which does not answer the question - name of constant is the least of
>>> the worries here.  Why the hell is "apply some unspecified checks to
>>> file" combined with opening it, rather than being an independent primitive
>>> you apply to an already opened file?  Just in case - "'cuz that's how we'd
>>> done it" does not make a good answer...
> 
> Maybe an access_ok() that acts on an open fd would be more
> appropriate.
> Which might end up being an fcntrl() action.
> That would give you a full 32bit mask of options.

I previously talk about fcntl(2):
https://lore.kernel.org/lkml/eaf5bc42-e086-740b-a90c-93e67c535eee@digikod.net/
