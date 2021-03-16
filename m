Return-Path: <kernel-hardening-return-20953-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4462433DD67
	for <lists+kernel-hardening@lfdr.de>; Tue, 16 Mar 2021 20:26:00 +0100 (CET)
Received: (qmail 28084 invoked by uid 550); 16 Mar 2021 19:25:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 28064 invoked from network); 16 Mar 2021 19:25:54 -0000
Subject: Re: [PATCH v4 1/1] fs: Allow no_new_privs tasks to call chroot(2)
To: Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
 Serge Hallyn <serge@hallyn.com>, Andy Lutomirski <luto@amacapital.net>,
 Casey Schaufler <casey@schaufler-ca.com>,
 Christian Brauner <christian.brauner@ubuntu.com>,
 Christoph Hellwig <hch@lst.de>, David Howells <dhowells@redhat.com>,
 Dominik Brodowski <linux@dominikbrodowski.net>,
 "Eric W . Biederman" <ebiederm@xmission.com>,
 John Johansen <john.johansen@canonical.com>,
 Kentaro Takeda <takedakn@nttdata.co.jp>,
 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 kernel list <linux-kernel@vger.kernel.org>,
 linux-security-module <linux-security-module@vger.kernel.org>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@linux.microsoft.com>
References: <20210316170135.226381-1-mic@digikod.net>
 <20210316170135.226381-2-mic@digikod.net>
 <CAG48ez3=M-5WT73HqmFJr6UHwO0+2FJXxcAgRzp6wcd0P3TN=Q@mail.gmail.com>
 <202103161221.8291CC3E6@keescook>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <ba40f88c-b7bb-8c2d-3282-8912209710e0@digikod.net>
Date: Tue, 16 Mar 2021 20:25:38 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <202103161221.8291CC3E6@keescook>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 16/03/2021 20:24, Kees Cook wrote:
> On Tue, Mar 16, 2021 at 08:04:09PM +0100, Jann Horn wrote:
>> On Tue, Mar 16, 2021 at 6:02 PM Mickaël Salaün <mic@digikod.net> wrote:
>>> One could argue that chroot(2) is useless without a properly populated
>>> root hierarchy (i.e. without /dev and /proc).  However, there are
>>> multiple use cases that don't require the chrooting process to create
>>> file hierarchies with special files nor mount points, e.g.:
>>> * A process sandboxing itself, once all its libraries are loaded, may
>>>   not need files other than regular files, or even no file at all.
>>> * Some pre-populated root hierarchies could be used to chroot into,
>>>   provided for instance by development environments or tailored
>>>   distributions.
>>> * Processes executed in a chroot may not require access to these special
>>>   files (e.g. with minimal runtimes, or by emulating some special files
>>>   with a LD_PRELOADed library or seccomp).
>>>
>>> Unprivileged chroot is especially interesting for userspace developers
>>> wishing to harden their applications.  For instance, chroot(2) and Yama
>>> enable to build a capability-based security (i.e. remove filesystem
>>> ambient accesses) by calling chroot/chdir with an empty directory and
>>> accessing data through dedicated file descriptors obtained with
>>> openat2(2) and RESOLVE_BENEATH/RESOLVE_IN_ROOT/RESOLVE_NO_MAGICLINKS.
>>
>> I don't entirely understand. Are you writing this with the assumption
>> that a future change will make it possible to set these RESOLVE flags
>> process-wide, or something like that?
> 
> I thought it meant "open all out-of-chroot dirs as fds using RESOLVE_...
> flags then chroot". As in, there's no way to then escape "up" for the
> old opens, and the new opens stay in the chroot.

Yes, that was the idea.

> 
>> [...]
>>> diff --git a/fs/open.c b/fs/open.c
>> [...]
>>> +static inline int current_chroot_allowed(void)
>>> +{
>>> +       /*
>>> +        * Changing the root directory for the calling task (and its future
>>> +        * children) requires that this task has CAP_SYS_CHROOT in its
>>> +        * namespace, or be running with no_new_privs and not sharing its
>>> +        * fs_struct and not escaping its current root (cf. create_user_ns()).
>>> +        * As for seccomp, checking no_new_privs avoids scenarios where
>>> +        * unprivileged tasks can affect the behavior of privileged children.
>>> +        */
>>> +       if (task_no_new_privs(current) && current->fs->users == 1 &&
>>
>> this read of current->fs->users should be using READ_ONCE()
> 
> Ah yeah, good call. I should remember this when I think "can this race?"
> :P
> 
