Return-Path: <kernel-hardening-return-19816-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id AB9B82613B5
	for <lists+kernel-hardening@lfdr.de>; Tue,  8 Sep 2020 17:44:40 +0200 (CEST)
Received: (qmail 13683 invoked by uid 550); 8 Sep 2020 15:44:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13663 invoked from network); 8 Sep 2020 15:44:34 -0000
Subject: Re: [RFC PATCH v8 1/3] fs: Introduce AT_INTERPRETED flag for
 faccessat2(2)
To: Mimi Zohar <zohar@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc: Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton
 <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>,
 Christian Brauner <christian.brauner@ubuntu.com>,
 Christian Heimes <christian@python.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Deven Bowers <deven.desai@linux.microsoft.com>,
 Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>,
 Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>,
 James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
 Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
 Kees Cook <keescook@chromium.org>,
 Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
 Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>,
 Miklos Szeredi <mszeredi@redhat.com>,
 =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
 Steve Grubb <sgrubb@redhat.com>,
 Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
 Thibaut Sautereau <thibaut.sautereau@clip-os.org>,
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,
 Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@linux.microsoft.com>,
 Stephen Smalley <stephen.smalley.work@gmail.com>,
 John Johansen <john.johansen@canonical.com>
References: <20200908075956.1069018-1-mic@digikod.net>
 <20200908075956.1069018-2-mic@digikod.net>
 <d216615b48c093ebe9349a9dab3830b646575391.camel@linux.ibm.com>
 <75451684-58f3-b946-dca4-4760fa0d7440@digikod.net>
 <01c23b2607a7dbf734722399931473c053d9b362.camel@linux.ibm.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <ed832b7f-dc47-fe54-468b-41de3b64fd83@digikod.net>
Date: Tue, 8 Sep 2020 17:44:19 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <01c23b2607a7dbf734722399931473c053d9b362.camel@linux.ibm.com>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 08/09/2020 17:24, Mimi Zohar wrote:
> On Tue, 2020-09-08 at 14:43 +0200, Micka�l Sala�n wrote:
>> On 08/09/2020 14:28, Mimi Zohar wrote:
>>> Hi Mickael,
>>>
>>> On Tue, 2020-09-08 at 09:59 +0200, Micka�l Sala�n wrote:
>>>> diff --git a/fs/open.c b/fs/open.c
>>>> index 9af548fb841b..879bdfbdc6fa 100644
>>>> --- a/fs/open.c
>>>> +++ b/fs/open.c
>>>> @@ -405,9 +405,13 @@ static long do_faccessat(int dfd, const char __user *filename, int mode, int fla
>>>>  	if (mode & ~S_IRWXO)	/* where's F_OK, X_OK, W_OK, R_OK? */
>>>>  		return -EINVAL;
>>>>  
>>>> -	if (flags & ~(AT_EACCESS | AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH))
>>>> +	if (flags & ~(AT_EACCESS | AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH |
>>>> +				AT_INTERPRETED))
>>>>  		return -EINVAL;
>>>>  
>>>> +	/* Only allows X_OK with AT_INTERPRETED for now. */
>>>> +	if ((flags & AT_INTERPRETED) && !(mode & S_IXOTH))
>>>> +		return -EINVAL;
>>>>  	if (flags & AT_SYMLINK_NOFOLLOW)
>>>>  		lookup_flags &= ~LOOKUP_FOLLOW;
>>>>  	if (flags & AT_EMPTY_PATH)
>>>> @@ -426,7 +430,30 @@ static long do_faccessat(int dfd, const char __user *filename, int mode, int fla
>>>>  
>>>>  	inode = d_backing_inode(path.dentry);
>>>>  
>>>> -	if ((mode & MAY_EXEC) && S_ISREG(inode->i_mode)) {
>>>> +	if ((flags & AT_INTERPRETED)) {
>>>> +		/*
>>>> +		 * For compatibility reasons, without a defined security policy
>>>> +		 * (via sysctl or LSM), using AT_INTERPRETED must map the
>>>> +		 * execute permission to the read permission.  Indeed, from
>>>> +		 * user space point of view, being able to execute data (e.g.
>>>> +		 * scripts) implies to be able to read this data.
>>>> +		 *
>>>> +		 * The MAY_INTERPRETED_EXEC bit is set to enable LSMs to add
>>>> +		 * custom checks, while being compatible with current policies.
>>>> +		 */
>>>> +		if ((mode & MAY_EXEC)) {
>>>
>>> Why is the ISREG() test being dropped?   Without dropping it, there
>>> would be no reason for making the existing test an "else" clause.
>>
>> The ISREG() is not dropped, it is just moved below with the rest of the
>> original code. The corresponding code (with the path_noexec call) for
>> AT_INTERPRETED is added with the next commit, and it relies on the
>> sysctl configuration for compatibility reasons.
> 
> Dropping the S_ISREG() check here without an explanation is wrong and
> probably unsafe, as it is only re-added in the subsequent patch and
> only for the "sysctl_interpreted_access" case.  Adding this new test
> after the existing test is probably safer.  If the original test fails,
> it returns the same value as this test -EACCES.

The original S_ISREG() is ANDed with a MAY_EXEC check and with
path_noexec(). The goal of this patch is indeed to have a different
behavior than the original faccessat2(2) thanks to the AT_INTERPRETED
flag. This can't work if we add the sysctl check after the current
path_noexec() check. Moreover, in this patch an exec check is translated
to a read check. This new behavior is harmless because using
AT_INTERPRETED with the current faccessat2(2) would return -EINVAL. The
current vanilla behavior is then unchanged.

The whole point of this patch series is to have a policy which do not
break current systems and is easy to configure by the sysadmin through
sysctl. This patch series also enable LSMs to take advantage of it
without the current faccess* limitations. For instance, it is then
possible for an LSM to implement more complex policies which may allow
execution of data from pipes or sockets, while verifying the source of
this data. Enforcing S_ISREG() in this patch would forbid such policies
to be implemented. In the case of IMA, you may want to add the same
S_ISREG() check.

> 
> Mimi
> 
>>
>>>
>>>> +			mode |= MAY_INTERPRETED_EXEC;
>>>> +			/*
>>>> +			 * For compatibility reasons, if the system-wide policy
>>>> +			 * doesn't enforce file permission checks, then
>>>> +			 * replaces the execute permission request with a read
>>>> +			 * permission request.
>>>> +			 */
>>>> +			mode &= ~MAY_EXEC;
>>>> +			/* To be executed *by* user space, files must be readable. */
>>>> +			mode |= MAY_READ;
> 
> 
