Return-Path: <kernel-hardening-return-20449-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3E2292BBE3D
	for <lists+kernel-hardening@lfdr.de>; Sat, 21 Nov 2020 10:45:23 +0100 (CET)
Received: (qmail 24484 invoked by uid 550); 21 Nov 2020 09:45:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24452 invoked from network); 21 Nov 2020 09:45:15 -0000
Subject: Re: [PATCH v24 02/12] landlock: Add ruleset and domain management
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
References: <20201112205141.775752-1-mic@digikod.net>
 <20201112205141.775752-3-mic@digikod.net>
 <CAG48ez2RE6S7jKQY3iyoNRM5vV67W4S7OwJ0gmNGy+MB8F56vg@mail.gmail.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <28499c4b-d388-7bd1-046e-a775c326e156@digikod.net>
Date: Sat, 21 Nov 2020 10:45:01 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <CAG48ez2RE6S7jKQY3iyoNRM5vV67W4S7OwJ0gmNGy+MB8F56vg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 21/11/2020 08:00, Jann Horn wrote:
> On Thu, Nov 12, 2020 at 9:51 PM Mickaël Salaün <mic@digikod.net> wrote:
>> A Landlock ruleset is mainly a red-black tree with Landlock rules as
>> nodes.  This enables quick update and lookup to match a requested
>> access, e.g. to a file.  A ruleset is usable through a dedicated file
>> descriptor (cf. following commit implementing syscalls) which enables a
>> process to create and populate a ruleset with new rules.
>>
>> A domain is a ruleset tied to a set of processes.  This group of rules
>> defines the security policy enforced on these processes and their future
>> children.  A domain can transition to a new domain which is the
>> intersection of all its constraints and those of a ruleset provided by
>> the current process.  This modification only impact the current process.
>> This means that a process can only gain more constraints (i.e. lose
>> accesses) over time.
>>
>> Cc: James Morris <jmorris@namei.org>
>> Cc: Jann Horn <jannh@google.com>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Serge E. Hallyn <serge@hallyn.com>
>> Signed-off-by: Mickaël Salaün <mic@linux.microsoft.com>
>> ---
>>
>> Changes since v23:
>> * Always intersect access rights.  Following the filesystem change
>>   logic, make ruleset updates more consistent by always intersecting
>>   access rights (boolean AND) instead of combining them (boolean OR) for
>>   the same layer.
> 
> This seems wrong to me. If some software e.g. builds a policy that
> allows it to execute specific libraries and to open input files
> specified on the command line, and the user then specifies a library
> as an input file, this change will make that fail unless the software
> explicitly deduplicates the rules.
> Userspace will be forced to add extra complexity to work around this.

That's a valid use case I didn't think about. Reverting this change is
not an issue.

> 
>>   This defensive approach could also help avoid user
>>   space to inadvertently allow multiple access rights for the same
>>   object (e.g.  write and execute access on a path hierarchy) instead of
>>   dealing with such inconsistency.  This can happen when there is no
>>   deduplication of objects (e.g. paths and underlying inodes) whereas
>>   they get different access rights with landlock_add_rule(2).
> 
> I don't see why that's an issue. If userspace wants to be able to
> access the same object in different ways for different purposes, it
> should be able to do that, no?
> 
> I liked the semantics from the previous version.
> 

I agree, but the real issue is with the ruleset layers applied to the
filesystem, cf. patch 7.
