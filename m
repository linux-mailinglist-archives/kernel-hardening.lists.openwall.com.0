Return-Path: <kernel-hardening-return-20307-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 48E2F29EAC8
	for <lists+kernel-hardening@lfdr.de>; Thu, 29 Oct 2020 12:38:47 +0100 (CET)
Received: (qmail 26133 invoked by uid 550); 29 Oct 2020 11:38:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26101 invoked from network); 29 Oct 2020 11:38:40 -0000
Subject: Re: [PATCH v22 12/12] landlock: Add user and kernel documentation
To: Jann Horn <jannh@google.com>
Cc: James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>,
 Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, Arnd Bergmann
 <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 Jeff Dike <jdike@addtoit.com>, Jonathan Corbet <corbet@lwn.net>,
 Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk.manpages@gmail.com>,
 Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 Linux API <linux-api@vger.kernel.org>,
 linux-arch <linux-arch@vger.kernel.org>,
 "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
 linux-fsdevel <linux-fsdevel@vger.kernel.org>,
 kernel list <linux-kernel@vger.kernel.org>,
 "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>,
 linux-security-module <linux-security-module@vger.kernel.org>,
 the arch/x86 maintainers <x86@kernel.org>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@linux.microsoft.com>
References: <20201027200358.557003-1-mic@digikod.net>
 <20201027200358.557003-13-mic@digikod.net>
 <CAG48ez07p+BtCRo4D75S3xsr76Kj_9Aipv3pBHsc4zyNjEiEmQ@mail.gmail.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <de1a6799-1545-b9d9-915a-2d5184db001e@digikod.net>
Date: Thu, 29 Oct 2020 12:38:26 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <CAG48ez07p+BtCRo4D75S3xsr76Kj_9Aipv3pBHsc4zyNjEiEmQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 29/10/2020 02:07, Jann Horn wrote:
> On Tue, Oct 27, 2020 at 9:04 PM Mickaël Salaün <mic@digikod.net> wrote:
>> This documentation can be built with the Sphinx framework.
>>
>> Cc: James Morris <jmorris@namei.org>
>> Cc: Jann Horn <jannh@google.com>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Serge E. Hallyn <serge@hallyn.com>
>> Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
>> Reviewed-by: Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>
> [...]
>> diff --git a/Documentation/userspace-api/landlock.rst b/Documentation/userspace-api/landlock.rst
> [...]
>> +Landlock rules
>> +==============
>> +
>> +A Landlock rule enables to describe an action on an object.  An object is
> 
> s/enables to describe/describes/

OK.

> 
>> +currently a file hierarchy, and the related filesystem actions are defined in
>> +`Access rights`_.  A set of rules is aggregated in a ruleset, which can then
>> +restrict the thread enforcing it, and its future children.
>> +
>> +Defining and enforcing a security policy
>> +----------------------------------------
>> +
>> +We first need to create the ruleset that will contain our rules.  For this
>> +example, the ruleset will contain rules which only allow read actions, but
>> +write actions will be denied.  The ruleset then needs to handle both of these
>> +kind of actions.  To have a backward compatibility, these actions should be
>> +ANDed with the supported ones.
> 
> This sounds as if there is a way for userspace to discover which
> actions are supported by the running kernel; but we don't have
> anything like that, right?

Right, it dates from the landlock_get_features(2), which is now gone but
may be replaced by something else in the future. I'll remove that.

> 
> If we want to make that possible, we could maybe change
> sys_landlock_create_ruleset() so that if
> ruleset_attr.handled_access_fs contains bits we don't know, we clear
> those bits and then copy the struct back to userspace? And then
> userspace can retry the syscall with the cleared bits? Or something
> along those lines?

Yes, but I would prefer clear syscall which don't read and write from/to
the same argument. I'm working on a more generic solution. It should not
be an issue for now.

> 
> [...]
>> +We can now add a new rule to this ruleset thanks to the returned file
>> +descriptor referring to this ruleset.  The rule will only enable to read the
> 
> s/enable to read/allow reading/

OK.

> 
>> +file hierarchy ``/usr``.  Without another rule, write actions would then be
>> +denied by the ruleset.  To add ``/usr`` to the ruleset, we open it with the
>> +``O_PATH`` flag and fill the &struct landlock_path_beneath_attr with this file
>> +descriptor.
> [...]
>> +Inheritance
>> +-----------
>> +
>> +Every new thread resulting from a :manpage:`clone(2)` inherits Landlock domain
>> +restrictions from its parent.  This is similar to the seccomp inheritance (cf.
>> +:doc:`/userspace-api/seccomp_filter`) or any other LSM dealing with task's
>> +:manpage:`credentials(7)`.  For instance, one process's thread may apply
>> +Landlock rules to itself, but they will not be automatically applied to other
>> +sibling threads (unlike POSIX thread credential changes, cf.
>> +:manpage:`nptl(7)`).
>> +
>> +When a thread sandbox itself, we have the grantee that the related security
> 
> s/sandbox/sandboxes/
> s/grantee/guarantee/

OK.

> 
>> +policy will stay enforced on all this thread's descendants.  This enables to
>> +create standalone and modular security policies per application, which will
> 
> s/enables to create/allows creating/

OK.

> 
> 
>> +automatically be composed between themselves according to their runtime parent
>> +policies.
