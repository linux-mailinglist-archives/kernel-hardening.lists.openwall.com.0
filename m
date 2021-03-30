Return-Path: <kernel-hardening-return-21083-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6C41C34F190
	for <lists+kernel-hardening@lfdr.de>; Tue, 30 Mar 2021 21:27:48 +0200 (CEST)
Received: (qmail 12246 invoked by uid 550); 30 Mar 2021 19:27:41 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 12223 invoked from network); 30 Mar 2021 19:27:40 -0000
Subject: Re: [PATCH v5 1/1] fs: Allow no_new_privs tasks to call chroot(2)
To: Casey Schaufler <casey@schaufler-ca.com>,
 Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>,
 Serge Hallyn <serge@hallyn.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>,
 Christian Brauner <christian.brauner@ubuntu.com>,
 Christoph Hellwig <hch@lst.de>, David Howells <dhowells@redhat.com>,
 Dominik Brodowski <linux@dominikbrodowski.net>,
 "Eric W . Biederman" <ebiederm@xmission.com>, Jann Horn <jannh@google.com>,
 John Johansen <john.johansen@canonical.com>,
 Kees Cook <keescook@chromium.org>, Kentaro Takeda <takedakn@nttdata.co.jp>,
 Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
 kernel-hardening@lists.openwall.com, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@linux.microsoft.com>
References: <20210316203633.424794-1-mic@digikod.net>
 <20210316203633.424794-2-mic@digikod.net>
 <fef10d28-df59-640e-ecf7-576f8348324e@digikod.net>
 <85ebb3a1-bd5e-9f12-6d02-c08d2c0acff5@schaufler-ca.com>
 <b47f73fe-1e79-ff52-b93e-d86b2927bbdc@digikod.net>
 <77ec5d18-f88e-5c7c-7450-744f69654f69@schaufler-ca.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <a8b2545f-51c7-01dc-1a14-e87beefc5419@digikod.net>
Date: Tue, 30 Mar 2021 21:28:25 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <77ec5d18-f88e-5c7c-7450-744f69654f69@schaufler-ca.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 30/03/2021 20:40, Casey Schaufler wrote:
> On 3/30/2021 11:11 AM, Mickaël Salaün wrote:
>> On 30/03/2021 19:19, Casey Schaufler wrote:
>>> On 3/30/2021 10:01 AM, Mickaël Salaün wrote:
>>>> Hi,
>>>>
>>>> Is there new comments on this patch? Could we move forward?
>>> I don't see that new comments are necessary when I don't see
>>> that you've provided compelling counters to some of the old ones.
>> Which ones? I don't buy your argument about the beauty of CAP_SYS_CHROOT.
> 
> CAP_SYS_CHROOT, namespaces. Bind mounts. The restrictions on
> "unprivileged" chroot being sufficiently onerous to make it
> unlikely to be usable.

There is multiple use cases for these features.

> 
>>> It's possible to use minimal privilege with CAP_SYS_CHROOT.
>> CAP_SYS_CHROOT can lead to privilege escalation.
> 
> Not when used in conjunction with the same set of
> restrictions you're requiring for "unprivileged" chroot. 

I'm talking about security with the principle of least privilege: when
we consider that a process may be(come) malicious but should still be
able to drop (more) accesses, e.g. with prctl(set_no_new_privs) *then*
chroot()

> 
>>> It looks like namespaces provide alternatives for all your
>>> use cases.
>> I explained in the commit message why it is not the case. In a nutshell,
>> namespaces bring complexity which may not be required.
> 
> So? I can use a Swiss Army Knife to cut a string even though it
> has a corkscrew.

Complexity leads to (security) issues. In secure systems, we want to
reduce the attack surfaces. There is some pointers here:
https://lwn.net/Articles/673597/

> 
>>  When designing a
>> secure system, we want to avoid giving access to such complexity to
>> untrusted processes (i.e. more complexity leads to more bugs).
> 
> If you're *really* designing a secure system you can design it to
> use existing mechanisms, like CAP_SYS_CHROOT!

Not always. For instance, in the case of a web browser, we don't want to
give CAP_SYS_CHROOT to every users just because their browser could
(legitimately) use it as a security sandbox mechanism. The same
principle can be applied to a lot of use cases, e.g. network services,
file parsers, etc.

> 
>>  An
>> unprivileged chroot would enable to give just the minimum feature to
>> drop some accesses. Of course it is not enough on its own, but it can be
>> combined with existing (and future) security features.
> 
> Like NO_NEW_PRIVS, namespaces and capabilities!
> You don't need anything new!

If a process is compromised before chrooting itself and dropping
CAP_SYS_CHROOT, then there is a bigger security issue than without
CAP_SYS_CHROOT.

> 
>>> The constraints required to make this work are quite
>>> limiting. Where is the real value add?
>> As explain in the commit message, it is useful when hardening
>> applications (e.g. network services, browsers, parsers, etc.). We don't
>> want an untrusted (or compromised) application to have CAP_SYS_CHROOT
>> nor (complex) namespace access.
> 
> If you can ensure that an unprivileged application is
> always run with NO_NEW_PRIVS you could also ensure that
> it runs with only CAP_SYS_CHROOT or in an appropriate
> namespace. I believe that it would be easier for your
> particular use case. I don't believe that is sufficient.

You can't always have this assertion, e.g. because a user may require to
run (legitimate) SETUID binaries…

For everyone following a defense in depth approach (i.e. multiple layers
of security), an unprivileged chroot is valuable.

> 
>>>> Regards,
>>>>  Mickaël
>>>>
>>>>
>>>> On 16/03/2021 21:36, Mickaël Salaün wrote:
>>>>> From: Mickaël Salaün <mic@linux.microsoft.com>
>>>>>
>>>>> Being able to easily change root directories enables to ease some
>>>>> development workflow and can be used as a tool to strengthen
>>>>> unprivileged security sandboxes.  chroot(2) is not an access-control
>>>>> mechanism per se, but it can be used to limit the absolute view of the
>>>>> filesystem, and then limit ways to access data and kernel interfaces
>>>>> (e.g. /proc, /sys, /dev, etc.).
>>>>>
>>>>> Users may not wish to expose namespace complexity to potentially
>>>>> malicious processes, or limit their use because of limited resources.
>>>>> The chroot feature is much more simple (and limited) than the mount
>>>>> namespace, but can still be useful.  As for containers, users of
>>>>> chroot(2) should take care of file descriptors or data accessible by
>>>>> other means (e.g. current working directory, leaked FDs, passed FDs,
>>>>> devices, mount points, etc.).  There is a lot of literature that discuss
>>>>> the limitations of chroot, and users of this feature should be aware 
> of
>>>>> the multiple ways to bypass it.  Using chroot(2) for security purposes
>>>>> can make sense if it is combined with other features (e.g. dedicated
>>>>> user, seccomp, LSM access-controls, etc.).
>>>>>
>>>>> One could argue that chroot(2) is useless without a properly populated
>>>>> root hierarchy (i.e. without /dev and /proc).  However, there are
>>>>> multiple use cases that don't require the chrooting process to create
>>>>> file hierarchies with special files nor mount points, e.g.:
>>>>> * A process sandboxing itself, once all its libraries are loaded, may
>>>>>   not need files other than regular files, or even no file at all.
>>>>> * Some pre-populated root hierarchies could be used to chroot into,
>>>>>   provided for instance by development environments or tailored
>>>>>   distributions.
>>>>> * Processes executed in a chroot may not require access to these special
>>>>>   files (e.g. with minimal runtimes, or by emulating some special files
>>>>>   with a LD_PRELOADed library or seccomp).
>>>>>
>>>>> Allowing a task to change its own root directory is not a threat to the
>>>>> system if we can prevent confused deputy attacks, which could be
>>>>> performed through execution of SUID-like binaries.  This can be
>>>>> prevented if the calling task sets PR_SET_NO_NEW_PRIVS on itself with
>>>>> prctl(2).  To only affect this task, its filesystem information must 
> not
>>>>> be shared with other tasks, which can be achieved by not passing
>>>>> CLONE_FS to clone(2).  A similar no_new_privs check is already used by
>>>>> seccomp to avoid the same kind of security issues.  Furthermore, because
>>>>> of its security use and to avoid giving a new way for attackers to get
>>>>> out of a chroot (e.g. using /proc/<pid>/root, or chroot/chdir), an
>>>>> unprivileged chroot is only allowed if the calling process is not
>>>>> already chrooted.  This limitation is the same as for creating user
>>>>> namespaces.
>>>>>
>>>>> This change may not impact systems relying on other permission models
>>>>> than POSIX capabilities (e.g. Tomoyo).  Being able to use chroot(2) on
>>>>> such systems may require to update their security policies.
>>>>>
>>>>> Only the chroot system call is relaxed with this no_new_privs check; 
> the
>>>>> init_chroot() helper doesn't require such change.
>>>>>
>>>>> Allowing unprivileged users to use chroot(2) is one of the initial
>>>>> objectives of no_new_privs:
>>>>> https://www.kernel.org/doc/html/latest/userspace-api/no_new_privs.html
>>>>> This patch is a follow-up of a previous one sent by Andy Lutomirski:
>>>>> https://lore.kernel.org/lkml/0e2f0f54e19bff53a3739ecfddb4ffa9a6dbde4d.1327858005.git.luto@amacapital.net/
>>>>>
>>>>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>>>>> Cc: Andy Lutomirski <luto@amacapital.net>
>>>>> Cc: Christian Brauner <christian.brauner@ubuntu.com>
>>>>> Cc: Christoph Hellwig <hch@lst.de>
>>>>> Cc: David Howells <dhowells@redhat.com>
>>>>> Cc: Dominik Brodowski <linux@dominikbrodowski.net>
>>>>> Cc: Eric W. Biederman <ebiederm@xmission.com>
>>>>> Cc: James Morris <jmorris@namei.org>
>>>>> Cc: Jann Horn <jannh@google.com>
>>>>> Cc: John Johansen <john.johansen@canonical.com>
>>>>> Cc: Kentaro Takeda <takedakn@nttdata.co.jp>
>>>>> Cc: Serge Hallyn <serge@hallyn.com>
>>>>> Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
>>>>> Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
>>>>> Reviewed-by: Kees Cook <keescook@chromium.org>
>>>>> Link: https://lore.kernel.org/r/20210316203633.424794-2-mic@digikod.net
>>>>> ---
>>>>>
>>>>> Changes since v4:
>>>>> * Use READ_ONCE(current->fs->users) (found by Jann Horn).
>>>>> * Remove ambiguous example in commit description.
>>>>> * Add Reviewed-by Kees Cook.
>>>>>
>>>>> Changes since v3:
>>>>> * Move the new permission checks to a dedicated helper
>>>>>   current_chroot_allowed() to make the code easier to read and align
>>>>>   with user_path_at(), path_permission() and security_path_chroot()
>>>>>   calls (suggested by Kees Cook).
>>>>> * Remove now useless included file.
>>>>> * Extend commit description.
>>>>> * Rebase on v5.12-rc3 .
>>>>>
>>>>> Changes since v2:
>>>>> * Replace path_is_under() check with current_chrooted() to gain the same
>>>>>   protection as create_user_ns() (suggested by Jann Horn). See commit
>>>>>   3151527ee007 ("userns:  Don't allow creation if the user is chrooted")
>>>>>
>>>>> Changes since v1:
>>>>> * Replace custom is_path_beneath() with existing path_is_under().
>>>>> ---
>>>>>  fs/open.c | 23 +++++++++++++++++++++--
>>>>>  1 file changed, 21 insertions(+), 2 deletions(-)
>>>>>
>>>>> diff --git a/fs/open.c b/fs/open.c
>>>>> index e53af13b5835..480010a551b2 100644
>>>>> --- a/fs/open.c
>>>>> +++ b/fs/open.c
>>>>> @@ -532,6 +532,24 @@ SYSCALL_DEFINE1(fchdir, unsigned int, fd)
>>>>>  	return error;
>>>>>  }
>>>>>  
>>>>> +static inline int current_chroot_allowed(void)
>>>>> +{
>>>>> +	/*
>>>>> +	 * Changing the root directory for the calling task (and its future
>>>>> +	 * children) requires that this task has CAP_SYS_CHROOT in its
>>>>> +	 * namespace, or be running with no_new_privs and not sharing its
>>>>> +	 * fs_struct and not escaping its current root (cf. create_user_ns()).
>>>>> +	 * As for seccomp, checking no_new_privs avoids scenarios where
>>>>> +	 * unprivileged tasks can affect the behavior of privileged children.
>>>>> +	 */
>>>>> +	if (task_no_new_privs(current) && READ_ONCE(current->fs->users) == 
>>> 1 &&
>>>>> +			!current_chrooted())
>>>>> +		return 0;
>>>>> +	if (ns_capable(current_user_ns(), CAP_SYS_CHROOT))
>>>>> +		return 0;
>>>>> +	return -EPERM;
>>>>> +}
>>>>> +
>>>>>  SYSCALL_DEFINE1(chroot, const char __user *, filename)
>>>>>  {
>>>>>  	struct path path;
>>>>> @@ -546,9 +564,10 @@ SYSCALL_DEFINE1(chroot, const char __user *, filename)
>>>>>  	if (error)
>>>>>  		goto dput_and_out;
>>>>>  
>>>>> -	error = -EPERM;
>>>>> -	if (!ns_capable(current_user_ns(), CAP_SYS_CHROOT))
>>>>> +	error = current_chroot_allowed();
>>>>> +	if (error)
>>>>>  		goto dput_and_out;
>>>>> +
>>>>>  	error = security_path_chroot(&path);
>>>>>  	if (error)
>>>>>  		goto dput_and_out;
>>>>>
> 
