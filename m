Return-Path: <kernel-hardening-return-21050-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C85DA347D8C
	for <lists+kernel-hardening@lfdr.de>; Wed, 24 Mar 2021 17:20:50 +0100 (CET)
Received: (qmail 21548 invoked by uid 550); 24 Mar 2021 16:20:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 21525 invoked from network); 24 Mar 2021 16:20:43 -0000
Subject: Re: [PATCH v30 12/12] landlock: Add user and kernel documentation
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
To: Kees Cook <keescook@chromium.org>
Cc: James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
 "Serge E . Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@amacapital.net>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, Arnd Bergmann
 <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 David Howells <dhowells@redhat.com>, Jeff Dike <jdike@addtoit.com>,
 Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>,
 Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-security-module@vger.kernel.org,
 x86@kernel.org, =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?=
 <mic@linux.microsoft.com>
References: <20210316204252.427806-1-mic@digikod.net>
 <20210316204252.427806-13-mic@digikod.net> <202103191056.71AB0515A@keescook>
 <81c76347-9e92-244f-6f32-600984a6c5cb@digikod.net>
Message-ID: <57a2b232-f5ba-b585-da11-972845ac8067@digikod.net>
Date: Wed, 24 Mar 2021 17:21:07 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <81c76347-9e92-244f-6f32-600984a6c5cb@digikod.net>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 19/03/2021 19:54, Micka�l Sala�n wrote:
> 
> On 19/03/2021 19:03, Kees Cook wrote:
>> On Tue, Mar 16, 2021 at 09:42:52PM +0100, Micka�l Sala�n wrote:
>>> From: Micka�l Sala�n <mic@linux.microsoft.com>
[...]
>>
>>> [...]
>>> +Special filesystems
>>> +-------------------
>>> +
>>> +Access to regular files and directories can be restricted by Landlock,
>>> +according to the handled accesses of a ruleset.  However, files that do not
>>> +come from a user-visible filesystem (e.g. pipe, socket), but can still be
>>> +accessed through /proc/self/fd/, cannot currently be restricted.  Likewise,
>>> +some special kernel filesystems such as nsfs, which can be accessed through
>>> +/proc/self/ns/, cannot currently be restricted.  For now, these kind of special
>>> +paths are then always allowed.  Future Landlock evolutions will enable to
>>> +restrict such paths with dedicated ruleset flags.
>>
>> With this series, can /proc (at the top level) be blocked? (i.e. can a
>> landlock user avoid the weirdness by making /proc/$pid/ unavailable?)
> 
> /proc can be blocked, but not /proc/*/ns/* because of disconnected
> roots. I plan to address this.

It is important to note that access to sensitive /proc files such as
ns/* and fd/* are automatically restricted according to domain
hierarchies. I'll add this detail to the documentation. :)
