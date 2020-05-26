Return-Path: <kernel-hardening-return-18801-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 194611D3962
	for <lists+kernel-hardening@lfdr.de>; Thu, 14 May 2020 20:49:50 +0200 (CEST)
Received: (qmail 17896 invoked by uid 550); 14 May 2020 18:49:44 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17859 invoked from network); 14 May 2020 18:49:44 -0000
Subject: Re: [PATCH v17 05/10] fs,landlock: Support filesystem access-control
To: James Morris <jmorris@namei.org>
Cc: Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
 Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@amacapital.net>,
 Arnd Bergmann <arnd@arndb.de>, Jann Horn <jannh@google.com>,
 Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
 "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-security-module@vger.kernel.org, x86@kernel.org
References: <20200511192156.1618284-1-mic@digikod.net>
 <20200511192156.1618284-6-mic@digikod.net>
 <alpine.LRH.2.21.2005141335280.30052@namei.org>
 <c159d845-6108-4b67-6527-405589fa5382@digikod.net>
 <alpine.LRH.2.21.2005150329580.26489@namei.org>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <2561827e-020c-9a76-98ae-9514904c69f9@digikod.net>
Date: Thu, 14 May 2020 20:49:31 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.2005150329580.26489@namei.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000


On 14/05/2020 19:31, James Morris wrote:
> On Thu, 14 May 2020, Mickaël Salaün wrote:
> 
>>> This needs to be converted to the LSM API via superblock blob stacking.
>>>
>>> See Casey's old patch: 
>>> https://lore.kernel.org/linux-security-module/20190829232935.7099-2-casey@schaufler-ca.com/
>>
>> s_landlock_inode_refs is quite similar to s_fsnotify_inode_refs, but I
>> can do it once the superblock security blob patch is upstream. Is it a
>> blocker for now? What is the current status of lbs_superblock?
> 
> Yes it is a blocker. Landlock should not be adding its own functions in 
> core code, it should be using the LSM API (and extending that as needed).

OK, I'll use that in the next series.

> 
>> Anyway, we also need to have a call to landlock_release_inodes() in
>> generic_shutdown_super(), which does not fit the LSM framework, and I
>> think it is not an issue. Landlock handling of inodes is quite similar
>> to fsnotify.
> 
> fsnotify is not an LSM.

Yes, so I'll need to add a new LSM hook for this (release) call, right?
