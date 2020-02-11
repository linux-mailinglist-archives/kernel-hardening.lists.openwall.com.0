Return-Path: <kernel-hardening-return-17782-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8F06C159C70
	for <lists+kernel-hardening@lfdr.de>; Tue, 11 Feb 2020 23:46:18 +0100 (CET)
Received: (qmail 1968 invoked by uid 550); 11 Feb 2020 22:46:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1927 invoked from network); 11 Feb 2020 22:46:12 -0000
Date: Tue, 11 Feb 2020 22:45:53 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
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
	"Eric W . Biederman" <ebiederm@xmission.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@kernel.org>,
	"J . Bruce Fields" <bfields@fieldses.org>,
	Jeff Layton <jlayton@poochiereds.net>,
	Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Solar Designer <solar@openwall.com>
Subject: Re: [PATCH v8 07/11] proc: flush task dcache entries from all procfs
 instances
Message-ID: <20200211224553.GK23230@ZenIV.linux.org.uk>
References: <20200210150519.538333-1-gladkov.alexey@gmail.com>
 <20200210150519.538333-8-gladkov.alexey@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200210150519.538333-8-gladkov.alexey@gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Mon, Feb 10, 2020 at 04:05:15PM +0100, Alexey Gladkov wrote:
> This allows to flush dcache entries of a task on multiple procfs mounts
> per pid namespace.
> 
> The RCU lock is used because the number of reads at the task exit time
> is much larger than the number of procfs mounts.
> 
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Andy Lutomirski <luto@kernel.org>
> Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
> Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
> ---
>  fs/proc/base.c                | 20 +++++++++++++++-----
>  fs/proc/root.c                | 27 ++++++++++++++++++++++++++-
>  include/linux/pid_namespace.h |  2 ++
>  include/linux/proc_fs.h       |  2 ++
>  4 files changed, 45 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 4ccb280a3e79..24b7c620ded3 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -3133,7 +3133,7 @@ static const struct inode_operations proc_tgid_base_inode_operations = {
>  	.permission	= proc_pid_permission,
>  };
>  
> -static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
> +static void proc_flush_task_mnt_root(struct dentry *mnt_root, pid_t pid, pid_t tgid)
>  {
>  	struct dentry *dentry, *leader, *dir;
>  	char buf[10 + 1];
> @@ -3142,7 +3142,7 @@ static void proc_flush_task_mnt(struct vfsmount *mnt, pid_t pid, pid_t tgid)
>  	name.name = buf;
>  	name.len = snprintf(buf, sizeof(buf), "%u", pid);
>  	/* no ->d_hash() rejects on procfs */
> -	dentry = d_hash_and_lookup(mnt->mnt_root, &name);
> +	dentry = d_hash_and_lookup(mnt_root, &name);
>  	if (dentry) {
>  		d_invalidate(dentry);
... which can block
>  		dput(dentry);
... and so can this

> +		rcu_read_lock();
> +		list_for_each_entry_rcu(fs_info, &upid->ns->proc_mounts, pidns_entry) {
> +			mnt_root = fs_info->m_super->s_root;
> +			proc_flush_task_mnt_root(mnt_root, upid->nr, tgid->numbers[i].nr);

... making that more than slightly unsafe.
