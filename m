Return-Path: <kernel-hardening-return-19260-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id CE19C218F2B
	for <lists+kernel-hardening@lfdr.de>; Wed,  8 Jul 2020 19:50:29 +0200 (CEST)
Received: (qmail 5798 invoked by uid 550); 8 Jul 2020 17:50:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5763 invoked from network); 8 Jul 2020 17:50:22 -0000
Subject: Re: [PATCH v19 08/12] landlock: Add syscall implementation
To: Arnd Bergmann <arnd@arndb.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Casey Schaufler <casey@schaufler-ca.com>, James Morris <jmorris@namei.org>,
 Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>,
 Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
 Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>,
 Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Linux API <linux-api@vger.kernel.org>,
 linux-arch <linux-arch@vger.kernel.org>,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 Linux FS-devel Mailing List <linux-fsdevel@vger.kernel.org>,
 "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
 LSM List <linux-security-module@vger.kernel.org>,
 the arch/x86 maintainers <x86@kernel.org>
References: <20200707180955.53024-1-mic@digikod.net>
 <20200707180955.53024-9-mic@digikod.net>
 <CAK8P3a0FkoxFtcQJ2jSqyLbDCOp3R8-1JoY8CWAgbSZ9hH9wdQ@mail.gmail.com>
 <7f407b67-d470-25fd-1287-f4f55f18e74a@digikod.net>
 <CAK8P3a1ehWZErD2a0iBqn37s-LTAtW0AbV_gt32iX3cQkXbpOQ@mail.gmail.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <ec79f6ad-1c11-d69f-724b-622baa28f19f@digikod.net>
Date: Wed, 8 Jul 2020 19:50:03 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <CAK8P3a1ehWZErD2a0iBqn37s-LTAtW0AbV_gt32iX3cQkXbpOQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000


On 08/07/2020 15:49, Arnd Bergmann wrote:
> On Wed, Jul 8, 2020 at 3:04 PM Mickaël Salaün <mic@digikod.net> wrote:
>> On 08/07/2020 10:57, Arnd Bergmann wrote:
>>> On Tue, Jul 7, 2020 at 8:10 PM Mickaël Salaün <mic@digikod.net> wrote:
>>>
>>> It looks like all you need here today is a single argument bit, plus
>>> possibly some room for extensibility. I would suggest removing all
>>> the extra bits and using a syscall like
>>>
>>> SYSCALL_DEFINE1(landlock_create_ruleset, u32, flags);
>>>
>>> I don't really see how this needs any variable-length arguments,
>>> it really doesn't do much.
>>
>> We need the attr_ptr/attr_size pattern because the number of ruleset
>> properties will increase (e.g. network access mask).
> 
> But how many bits do you think you will *actually* need in total that
> this needs to be a two-dimensional set of flags? At the moment you
> only have a single bit that you interpret.

I think there is a misunderstanding. For this syscall I wasn't talking
about the "options" field but about the "handled_access_fs" field which
has 14 bits dedicated to control access to the file system:
https://landlock.io/linux-doc/landlock-v19/security/landlock/user.html#filesystem-flags
The idea is to add other handled_access_* fields for other kernel object
types (e.g. network, process, etc.).

The "options" field is fine as a raw __u32 syscall argument.

> 
>>> To be on the safe side, you might split up the flags into either the
>>> upper/lower 16 bits or two u32 arguments, to allow both compatible
>>> (ignored by older kernels if flag is set) and incompatible (return error
>>> when an unknown flag is set) bits.
>>
>> This may be a good idea in general, but in the case of Landlock, because
>> this kind of (discretionary) sandboxing should be a best-effort security
>> feature, we should avoid incompatible behavior. In practice, every
>> unknown bit returns an error because userland can probe for available
>> bits thanks to the get_features command. This kind of (in)compatibility
>> can then be handled by userland.
> 
> If there are not going to be incompatible extensions, then just ignore
> all unknown bits and never return an error but get rid of the user
> space probing that just complicates the interface.

There was multiple discussions about ABI compatibility, especially
inspired by open(2) vs. openat2(2), and ignoring flags seems to be a bad
idea. In the "sandboxer" example, we first probe the supported features
and then mask unknown bits (i.e. access rights) at run time in userland.
This strategy is quite straightforward, backward compatible and
future-proof.

What does the linux-api folks think about this?

> 
> In general, it's hard to rely on user space to first ask the kernel
> what it can do, the way this normally works is that user space
> asks the kernel for something and it either does it or not, but gives
> an indication of whether it worked.

Right, but this is a special case (i.e. best-effort security, not a
required feature to run an application properly). As previously
discussed, this kind of security feature should be used as much as
possible by userland, but it may run on a system without Landlock. To
encourage a wide use of this kind of security sandboxing by userland
developers we should avoid the case when all the sandboxing is disabled
because not all sandboxing features are supported by the running kernel.

> 
>> I suggest this syscall signature:
>> SYSCALL_DEFINE3(landlock_create_ruleset, __u32, options, const struct
>> landlock_attr_ruleset __user *, ruleset_ptr, size_t, ruleset_size);
> 
> The other problem here is that indirect variable-size structured arguments
> are a pain to instrument with things like strace or seccomp, so you
> should first try to use a fixed argument list, and fall back to a fixed
> structure if that fails.

I agree that it is not perfect with the current tools but this kind of
extensible structs are becoming common and well defined (e.g. openat2).
Moreover there is some work going on for seccomp to support "extensible
argument" syscalls: https://lwn.net/Articles/822256/

> 
>>>> +static int syscall_add_rule_path_beneath(const void __user *const attr_ptr,
>>>> +               const size_t attr_size)
>>>> +{
>>>> +       struct landlock_attr_path_beneath attr_path_beneath;
>>>> +       struct path path;
>>>> +       struct landlock_ruleset *ruleset;
>>>> +       int err;
>>>
>>> Similarly, it looks like this wants to be
>>>
>>> SYSCALL_DEFINE3(landlock_add_rule_path_beneath, int, ruleset, int,
>>> path, __u32, flags)
>>>
>>> I don't see any need to extend this in a way that wouldn't already
>>> be served better by adding another system call. You might argue
>>> that 'flags' and 'allowed_access' could be separate, with the latter
>>> being an indirect in/out argument here, like
>>>
>>> SYSCALL_DEFINE4(landlock_add_rule_path_beneath, int, ruleset, int, path,
>>>                            __u64 *, allowed_acces, __u32, flags)
>>
>> To avoid adding a new syscall for each new rule type (e.g. path_beneath,
>> path_range, net_ipv4_range, etc.), I think it would be better to keep
>> the attr_ptr/attr_size pattern and to explicitely set a dedicated option
>> flag to specify the attr type.
>>
>> This would look like this:
>> SYSCALL_DEFINE4(landlock_add_rule, __u32, options, int, ruleset, const
>> void __user *, rule_ptr, size_t, rule_size);
>>
>> The rule_ptr could then point to multiple types like struct
>> landlock_attr_path_beneath (without the current ruleset_fd field).
> 
> This again introduces variable-sized structured data. How many different
> kinds of rule types do you think there will be (most likely, and maybe an
> upper bound)?

I don't know how many rule types will come, but right now I think it may
be less than 10.

> 
> Could (some of) these be generalized to use the same data structure?

I don't think so, file path and network addresses are an example of very
different types.

> 
>>>> +static int syscall_enforce_ruleset(const void __user *const attr_ptr,
>>>> +               const size_t attr_size)
>>>
>>> Here it seems like you just need to pass the file descriptor, or maybe
>>>
>>> SYSCALL_DEFINE2(landlock_enforce, int, ruleset, __u32 flags);
>>>
>>> if you need flags for extensibility.
>>
>> Right, but for consistency I prefer to change the arguments like this:
>> SYSCALL_DEFINE2(landlock_enforce, __u32 options, int, ruleset);
> 
> Most system calls pass the object they work on as the first argument,
> in this case this would be the ruleset file descriptor.

OK, makes sense, I'll try to follow this as much as possible then.
