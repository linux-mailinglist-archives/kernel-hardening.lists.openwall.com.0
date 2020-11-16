Return-Path: <kernel-hardening-return-20404-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 562672B53DB
	for <lists+kernel-hardening@lfdr.de>; Mon, 16 Nov 2020 22:36:38 +0100 (CET)
Received: (qmail 7334 invoked by uid 550); 16 Nov 2020 21:36:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7302 invoked from network); 16 Nov 2020 21:36:31 -0000
Subject: Re: [PATCH v22 01/12] landlock: Add object management
To: Pavel Machek <pavel@ucw.cz>
Cc: James Morris <jmorris@namei.org>, "Serge E . Hallyn" <serge@hallyn.com>,
 Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, Arnd Bergmann
 <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 Jann Horn <jannh@google.com>, Jeff Dike <jdike@addtoit.com>,
 Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>, Richard Weinberger
 <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-security-module@vger.kernel.org,
 x86@kernel.org, =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?=
 <mic@linux.microsoft.com>
References: <20201027200358.557003-1-mic@digikod.net>
 <20201027200358.557003-2-mic@digikod.net> <20201116212609.GA13063@amd>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <523d2141-e6f9-354d-d102-ae8345c84686@digikod.net>
Date: Mon, 16 Nov 2020 22:36:17 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <20201116212609.GA13063@amd>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit


On 16/11/2020 22:26, Pavel Machek wrote:
> Hi!
> 
>> A Landlock object enables to identify a kernel object (e.g. an inode).
>> A Landlock rule is a set of access rights allowed on an object.  Rules
>> are grouped in rulesets that may be tied to a set of processes (i.e.
>> subjects) to enforce a scoped access-control (i.e. a domain).
>>
>> Because Landlock's goal is to empower any process (especially
>> unprivileged ones) to sandbox themselves, we cannot rely on a
>> system-wide object identification such as file extended attributes.
> 
> 
>> +config SECURITY_LANDLOCK
>> +	bool "Landlock support"
>> +	depends on SECURITY
>> +	select SECURITY_PATH
>> +	help
>> +	  Landlock is a safe sandboxing mechanism which enables processes to
>> +	  restrict themselves (and their future children) by gradually
>> +	  enforcing tailored access control policies.  A security policy is a
>> +	  set of access rights (e.g. open a file in read-only, make a
>> +	  directory, etc.) tied to a file hierarchy.  Such policy can be configured
>> +	  and enforced by any processes for themselves thanks to dedicated system
>> +	  calls: landlock_create_ruleset(), landlock_add_rule(), and
>> +	  landlock_enforce_ruleset_current().
> 
> How does it interact with setuid binaries? Being able to exec passwd
> in a sandbox sounds like ... fun way to get root? :-).

It works like seccomp: if you run with CAP_SYS_ADMIN in the current
namespace, then SUID binaries may be allowed, otherwise if you use
PR_SET_NO_NEW_PRIVS, then executing a SUID binary is denied.

The 24th version is here:
https://lore.kernel.org/lkml/20201112205141.775752-1-mic@digikod.net/

> 
> Best regards,
> 								Pavel
> 								
> 
