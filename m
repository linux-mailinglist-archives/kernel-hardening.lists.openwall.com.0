Return-Path: <kernel-hardening-return-18559-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8D6031AFB5E
	for <lists+kernel-hardening@lfdr.de>; Sun, 19 Apr 2020 16:19:38 +0200 (CEST)
Received: (qmail 14193 invoked by uid 550); 19 Apr 2020 14:19:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 14173 invoked from network); 19 Apr 2020 14:19:32 -0000
Date: Sun, 19 Apr 2020 16:19:15 +0200
From: Alexey Gladkov <gladkov.alexey@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux API <linux-api@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Linux Security Module <linux-security-module@vger.kernel.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Daniel Micay <danielmicay@gmail.com>,
	Djalal Harouni <tixxdz@gmail.com>,
	"Dmitry V . Levin" <ldv@altlinux.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@kernel.org>,
	"J . Bruce Fields" <bfields@fieldses.org>,
	Jeff Layton <jlayton@poochiereds.net>,
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>,
	David Howells <dhowells@redhat.com>
Subject: Re: [PATCH RESEND v11 7/8] proc: use human-readable values for
 hidepid
Message-ID: <20200419141915.g4bdjbwvhpre7mra@comp-core-i7-2640m-0182e6>
References: <20200409123752.1070597-1-gladkov.alexey@gmail.com>
 <20200409123752.1070597-8-gladkov.alexey@gmail.com>
 <87imhyaq5t.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87imhyaq5t.fsf@x220.int.ebiederm.org>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.1 (raptor.unsafe.ru [5.9.43.93]); Sun, 19 Apr 2020 14:19:20 +0000 (UTC)

On Fri, Apr 17, 2020 at 02:05:50PM -0500, Eric W. Biederman wrote:
> Alexey Gladkov <gladkov.alexey@gmail.com> writes:
> 
> > The hidepid parameter values are becoming more and more and it becomes
> > difficult to remember what each new magic number means.
> 
> So I relooked at the code.  And I think I was misreading things.
> However I think it is a legitimate concern.
> 
> Can you please mention in your description of this change that
> switching from fsparam_u32 to fs_param_string is safe even when
> using the new mount api because fsparam_u32 and fs_param_string
> both are sent from userspace with "fsconfig(fd, FSCONFIG_SET_STRING, ...)".

Sure.

> Or words to that effect.  Ideally you will even manually test that case
> to confirm.

I will add a selftest for this.

-- 
Rgrds, legion

