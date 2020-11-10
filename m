Return-Path: <kernel-hardening-return-20376-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 95D9D2AD123
	for <lists+kernel-hardening@lfdr.de>; Tue, 10 Nov 2020 09:17:57 +0100 (CET)
Received: (qmail 15377 invoked by uid 550); 10 Nov 2020 08:17:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 14321 invoked from network); 10 Nov 2020 08:17:50 -0000
Subject: Re: [PATCH v23 00/12] Landlock LSM
To: James Morris <jmorris@namei.org>
Cc: "Serge E . Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>,
 Andy Lutomirski <luto@amacapital.net>,
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
 x86@kernel.org
References: <20201103182109.1014179-1-mic@digikod.net>
 <alpine.LRH.2.21.2011101745100.9130@namei.org>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <421e49f4-d3ec-fd17-be42-7c73448b99a1@digikod.net>
Date: Tue, 10 Nov 2020 09:16:47 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.2011101745100.9130@namei.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 10/11/2020 07:47, James Morris wrote:
> On Tue, 3 Nov 2020, Mickaël Salaün wrote:
> 
>> Hi,
>>
>> Can you please consider to merge this into the tree?
>>
> 
> I've added this to my tree:
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git landlock_lsm
> 
> and merged into next-testing (which is pulled into linux-next).
> 
> 
> Please make any further changes against the branch in my tree.

Great, thanks!
