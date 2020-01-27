Return-Path: <kernel-hardening-return-17617-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F298D14AC97
	for <lists+kernel-hardening@lfdr.de>; Tue, 28 Jan 2020 00:24:15 +0100 (CET)
Received: (qmail 29875 invoked by uid 550); 27 Jan 2020 23:24:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 29849 invoked from network); 27 Jan 2020 23:24:10 -0000
Date: Tue, 28 Jan 2020 00:23:53 +0100
From: Alexey Gladkov <gladkov.alexey@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
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
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@kernel.org>,
	"J . Bruce Fields" <bfields@fieldses.org>,
	Jeff Layton <jlayton@poochiereds.net>,
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Solar Designer <solar@openwall.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v7 07/11] proc: flush task dcache entries from all procfs
 instances
Message-ID: <20200127232352.s3mvvfkrta3i5h7w@comp-core-i7-2640m-0182e6>
Mail-Followup-To: Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
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
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@kernel.org>,
	"J . Bruce Fields" <bfields@fieldses.org>,
	Jeff Layton <jlayton@poochiereds.net>,
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Solar Designer <solar@openwall.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>
References: <20200125130541.450409-1-gladkov.alexey@gmail.com>
 <20200125130541.450409-8-gladkov.alexey@gmail.com>
 <CAHk-=wiGNSQCA8TYa1Akp0_GRpe=ELKDPkDX5nzM5R=oDy1U+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAHk-=wiGNSQCA8TYa1Akp0_GRpe=ELKDPkDX5nzM5R=oDy1U+Q@mail.gmail.com>

On Sat, Jan 25, 2020 at 10:45:25AM -0800, Linus Torvalds wrote:
> On Sat, Jan 25, 2020 at 5:06 AM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
> >
> > This allows to flush dcache entries of a task on multiple procfs mounts
> > per pid namespace.
> 
> From a quick read-through, this is the only one I really react negatively to.
> 
> The locking looks odd. It only seems to protect the new proc_mounts
> list, but then it's a whole big rwsem, and it's taken over all of
> proc_flush_task_mnt(), and the locking is exported to all over as a
> result of that - including the dummy functions for "there is no proc"
> case.
> 
> And proc_flush_task_mnt() itself should need no locking over any of
> it, so it's all just for the silly looping over the list.

Thank you, I will rework this part.

> So
> 
>  (a) this looks fishy and feels wrong - I get a very strong feeling
> that the locking is wrong to begin with, and could/should have been
> done differently
> 
>  (b) all the locking should have been internal to /proc, and those
> wrappers shouldn't exist in a common header file (and certainly not
> for the non-proc case).
> 
> Yes, (a) is just a feeling, and I don't have any great suggestions.
> Maybe make it an RCU list and use a spinlock for updating it?

I’m thinking, is it possible to get rid of proc_flush_task at all ?
Maybe we can try to flush dcache during readdir for example.

> But (b) is pretty much a non-starter in this form. Those wrappers
> shouldn't be in a globally exported core header file. No way.
> 
>                Linus
> 

-- 
Rgrds, legion

