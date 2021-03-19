Return-Path: <kernel-hardening-return-20985-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4EA2F342132
	for <lists+kernel-hardening@lfdr.de>; Fri, 19 Mar 2021 16:52:09 +0100 (CET)
Received: (qmail 5919 invoked by uid 550); 19 Mar 2021 15:52:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5896 invoked from network); 19 Mar 2021 15:52:01 -0000
Subject: Re: [PATCH v30 00/12] Landlock LSM
To: James Morris <jmorris@namei.org>
Cc: Jann Horn <jannh@google.com>, "Serge E . Hallyn" <serge@hallyn.com>,
 Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton
 <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, Arnd Bergmann
 <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 David Howells <dhowells@redhat.com>, Jeff Dike <jdike@addtoit.com>,
 Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>, Richard Weinberger
 <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-security-module@vger.kernel.org,
 x86@kernel.org, Dmitry Vyukov <dvyukov@google.com>
References: <20210316204252.427806-1-mic@digikod.net>
 <651a1034-c59f-1085-d3f6-c5a41f6fbbb@namei.org>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <39a58eb2-7cd8-9cc9-cbf1-829b6ee59f6b@digikod.net>
Date: Fri, 19 Mar 2021 16:52:02 +0100
User-Agent:
MIME-Version: 1.0
In-Reply-To: <651a1034-c59f-1085-d3f6-c5a41f6fbbb@namei.org>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 7bit


On 19/03/2021 00:26, James Morris wrote:
> I've queued this patchset here:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git landlock_lsm
> 
> and pulled it into next-testing, which will get it coverage in linux-next.
> 
> All going well, I'll aim to push this to Linus in the next merge window. 
> More review and testing during that time will be helpful.

Good, thanks! The syzkaller changes are now merged and up-to-date with
linux-next:
https://github.com/google/syzkaller/commits/3d01c4de549b4e4bddba6102715c212bbcff2fbb
