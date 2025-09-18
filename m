Return-Path: <kernel-hardening-return-21966-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 3D570B32F37
	for <lists+kernel-hardening@lfdr.de>; Sun, 24 Aug 2025 13:03:36 +0200 (CEST)
Received: (qmail 23767 invoked by uid 550); 24 Aug 2025 11:03:26 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23741 invoked from network); 24 Aug 2025 11:03:26 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1756033396;
	bh=npswCwX0a24vJxWw7gY+qI0TbgVywqqUB4cDV+3jp+w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=1WXDHzqg/P9JB/nnDxxpueGJBM3RmJ6uqsbQWCIbvmI2W8btShCyr99j6/RnOTwsd
	 zvp2JBaO4ueW7lSCf6nU1zM8s2cg1npfkPPbhf5gTLdumHsaPBFkmqP8jj9SHE39CQ
	 MxIho8S6SakTYtQbqpej882GLb/vs7g55Ho0kuzI=
Date: Sun, 24 Aug 2025 13:03:09 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Jann Horn <jannh@google.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Paul Moore <paul@paul-moore.com>, Serge Hallyn <serge@hallyn.com>, 
	Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Christian Heimes <christian@python.org>, Dmitry Vyukov <dvyukov@google.com>, 
	Elliott Hughes <enh@google.com>, Fan Wu <wufan@linux.microsoft.com>, 
	Florian Weimer <fweimer@redhat.com>, Jeff Xu <jeffxu@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Jordan R Abrahams <ajordanr@google.com>, Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, 
	Luca Boccassi <bluca@debian.org>, Matt Bobrowski <mattbobrowski@google.com>, 
	Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Nicolas Bouchinet <nicolas.bouchinet@oss.cyber.gouv.fr>, Robert Waite <rowait@microsoft.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Scott Shell <scottsh@microsoft.com>, 
	Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, 
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, 
	Jeff Xu <jeffxu@chromium.org>
Subject: Re: [RFC PATCH v1 1/2] fs: Add O_DENY_WRITE
Message-ID: <20250824.Ujoh8unahy5a@digikod.net>
References: <20250822170800.2116980-1-mic@digikod.net>
 <20250822170800.2116980-2-mic@digikod.net>
 <CAG48ez1XjUdcFztc_pF2qcoLi7xvfpJ224Ypc=FoGi-Px-qyZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG48ez1XjUdcFztc_pF2qcoLi7xvfpJ224Ypc=FoGi-Px-qyZw@mail.gmail.com>
X-Infomaniak-Routing: alpha

On Fri, Aug 22, 2025 at 09:45:32PM +0200, Jann Horn wrote:
> On Fri, Aug 22, 2025 at 7:08 PM Mickaël Salaün <mic@digikod.net> wrote:
> > Add a new O_DENY_WRITE flag usable at open time and on opened file (e.g.
> > passed file descriptors).  This changes the state of the opened file by
> > making it read-only until it is closed.  The main use case is for script
> > interpreters to get the guarantee that script' content cannot be altered
> > while being read and interpreted.  This is useful for generic distros
> > that may not have a write-xor-execute policy.  See commit a5874fde3c08
> > ("exec: Add a new AT_EXECVE_CHECK flag to execveat(2)")
> >
> > Both execve(2) and the IOCTL to enable fsverity can already set this
> > property on files with deny_write_access().  This new O_DENY_WRITE make
> 
> The kernel actually tried to get rid of this behavior on execve() in
> commit 2a010c41285345da60cece35575b4e0af7e7bf44.; but sadly that had
> to be reverted in commit 3b832035387ff508fdcf0fba66701afc78f79e3d
> because it broke userspace assumptions.

Oh, good to know.

> 
> > it widely available.  This is similar to what other OSs may provide
> > e.g., opening a file with only FILE_SHARE_READ on Windows.
> 
> We used to have the analogous mmap() flag MAP_DENYWRITE, and that was
> removed for security reasons; as
> https://man7.org/linux/man-pages/man2/mmap.2.html says:
> 
> |        MAP_DENYWRITE
> |               This flag is ignored.  (Long ago—Linux 2.0 and earlier—it
> |               signaled that attempts to write to the underlying file
> |               should fail with ETXTBSY.  But this was a source of denial-
> |               of-service attacks.)"
> 
> It seems to me that the same issue applies to your patch - it would
> allow unprivileged processes to essentially lock files such that other
> processes can't write to them anymore. This might allow unprivileged
> users to prevent root from updating config files or stuff like that if
> they're updated in-place.

Yes, I agree, but since it is the case for executed files I though it
was worth starting a discussion on this topic.  This new flag could be
restricted to executable files, but we should avoid system-wide locks
like this.  I'm not sure how Windows handle these issues though.

Anyway, we should rely on the access control policy to control write and
execute access in a consistent way (e.g. write-xor-execute).  Thanks for
the references and the background!
