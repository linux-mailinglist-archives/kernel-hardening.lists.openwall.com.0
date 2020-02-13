Return-Path: <kernel-hardening-return-17812-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 21E7615B940
	for <lists+kernel-hardening@lfdr.de>; Thu, 13 Feb 2020 06:55:55 +0100 (CET)
Received: (qmail 24560 invoked by uid 550); 13 Feb 2020 05:55:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24523 invoked from network); 13 Feb 2020 05:55:48 -0000
Date: Thu, 13 Feb 2020 05:55:27 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux API <linux-api@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Linux Security Module <linux-security-module@vger.kernel.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
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
	Oleg Nesterov <oleg@redhat.com>,
	Solar Designer <solar@openwall.com>
Subject: Re: [PATCH v8 07/11] proc: flush task dcache entries from all procfs
 instances
Message-ID: <20200213055527.GS23230@ZenIV.linux.org.uk>
References: <87v9obipk9.fsf@x220.int.ebiederm.org>
 <CAHk-=wgwmu4jpmOqW0+Lz0dcem1Fub=ThLHvmLobf_WqCq7bwg@mail.gmail.com>
 <20200212200335.GO23230@ZenIV.linux.org.uk>
 <CAHk-=wi+1CPShMFvJNPfnrJ8DD8uVKUOQ5TQzQUNGLUkeoahkg@mail.gmail.com>
 <20200212203833.GQ23230@ZenIV.linux.org.uk>
 <20200212204124.GR23230@ZenIV.linux.org.uk>
 <CAHk-=wi5FOGV_3tALK3n6E2fK3Oa_yCYkYQtCSaXLSEm2DUCKg@mail.gmail.com>
 <87lfp7h422.fsf@x220.int.ebiederm.org>
 <CAHk-=wgmn9Qds0VznyphouSZW6e42GWDT5H1dpZg8pyGDGN+=w@mail.gmail.com>
 <87pnejf6fz.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pnejf6fz.fsf@x220.int.ebiederm.org>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Wed, Feb 12, 2020 at 10:37:52PM -0600, Eric W. Biederman wrote:

> I think I have an alternate idea that could work.  Add some extra code
> into proc_task_readdir, that would look for dentries that no longer
> point to tasks and d_invalidate them.  With the same logic probably
> being called from a few more places as well like proc_pid_readdir,
> proc_task_lookup, and proc_pid_lookup.
> 
> We could even optimize it and have a process died flag we set in the
> superblock.
> 
> That would would batch up the freeing work until the next time someone
> reads from proc in a way that would create more dentries.  So it would
> prevent dentries from reaped zombies from growing without bound.
> 
> Hmm.  Given the existence of proc_fill_cache it would really be a good
> idea if readdir and lookup performed some of the freeing work as well.
> As on readdir we always populate the dcache for all of the directory
> entries.

First of all, that won't do a damn thing when nobody is accessing
given superblock.  What's more, readdir in root of that procfs instance
is not enough - you need it in task/ of group leader.

What I don't understand is the insistence on getting those dentries
via dcache lookups.  _IF_ we are willing to live with cacheline
contention (on ->d_lock of root dentry, if nothing else), why not
do the following:
	* put all dentries of such directories ([0-9]* and [0-9]*/task/*)
into a list anchored in task_struct; have non-counting reference to
task_struct stored in them (might simplify part of get_proc_task() users,
BTW - avoids pid-to-task_struct lookups if we have a dentry and not just
the inode; many callers do)
	* have ->d_release() remove from it (protecting per-task_struct lock
nested outside of all ->d_lock)
	* on exit:
	lock the (per-task_struct) list
	while list is non-empty
		pick the first dentry
		remove from the list
		sb = dentry->d_sb
		try to bump sb->s_active (if non-zero, that is).
		if failed
			continue // move on to the next one - nothing to do here
		grab ->d_lock
		res = handle_it(dentry, &temp_list)
		drop ->d_lock
		unlock the list
		if (!list_empty(&temp_list))
			shrink_dentry_list(&temp_list)
		if (res)
			d_invalidate(dentry)
			dput(dentry)
		deactivate_super(sb)
		lock the list
	unlock the list

handle_it(dentry, temp_list) // ->d_lock held; that one should be in dcache.c
	if ->d_count is negative // unlikely
		return 0;
	if ->d_count is positive,
		increment ->d_count
		return 1;
	// OK, it's still alive, but ->d_count is 0
	__d_drop	// equivalent of d_invalidate in this case
	if not on a shrink list // otherwise it's not our headache
		if on lru list
			d_lru_del
		d_shrink_add dentry to temp_list
	return 0;

And yeah, that'll dirty ->s_active for each procfs superblock that
has dentry for our process present in dcache.  On exit()...
