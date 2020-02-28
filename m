Return-Path: <kernel-hardening-return-18018-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8C6911741BF
	for <lists+kernel-hardening@lfdr.de>; Fri, 28 Feb 2020 22:59:46 +0100 (CET)
Received: (qmail 24092 invoked by uid 550); 28 Feb 2020 21:59:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24069 invoked from network); 28 Feb 2020 21:59:41 -0000
Date: Fri, 28 Feb 2020 22:59:20 +0100
From: Christian Brauner <christian.brauner@ubuntu.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
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
	Alexey Gladkov <gladkov.alexey@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>
Subject: Re: [PATCH 2/3] uml: Create a private mount of proc for mconsole
Message-ID: <20200228215920.tlw74xzhl5qkvt4p@wittgenstein>
References: <CAHk-=wi5FOGV_3tALK3n6E2fK3Oa_yCYkYQtCSaXLSEm2DUCKg@mail.gmail.com>
 <87lfp7h422.fsf@x220.int.ebiederm.org>
 <CAHk-=wgmn9Qds0VznyphouSZW6e42GWDT5H1dpZg8pyGDGN+=w@mail.gmail.com>
 <87pnejf6fz.fsf@x220.int.ebiederm.org>
 <871rqpaswu.fsf_-_@x220.int.ebiederm.org>
 <871rqk2brn.fsf_-_@x220.int.ebiederm.org>
 <878skmsbyy.fsf_-_@x220.int.ebiederm.org>
 <87wo86qxcs.fsf_-_@x220.int.ebiederm.org>
 <20200228203058.jcnqeyvmqhfslcym@wittgenstein>
 <87zhd2pfjd.fsf@x220.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87zhd2pfjd.fsf@x220.int.ebiederm.org>

On Fri, Feb 28, 2020 at 03:28:54PM -0600, Eric W. Biederman wrote:
> Christian Brauner <christian.brauner@ubuntu.com> writes:
> 
> > On Fri, Feb 28, 2020 at 02:18:43PM -0600, Eric W. Biederman wrote:
> >> 
> >> The mconsole code only ever accesses proc for the initial pid
> >> namespace.  Instead of depending upon the proc_mnt which is
> >> for proc_flush_task have uml create it's own mount of proc
> >> instead.
> >> 
> >> This allows proc_flush_task to evolve and remove the
> >> need for having a proc_mnt to do it's job.
> >> 
> >> Cc: Jeff Dike <jdike@addtoit.com>
> >> Cc: Richard Weinberger <richard@nod.at>
> >> Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> >> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> >> ---
> >>  arch/um/drivers/mconsole_kern.c | 28 +++++++++++++++++++++++++++-
> >>  1 file changed, 27 insertions(+), 1 deletion(-)
> >> 
> >> diff --git a/arch/um/drivers/mconsole_kern.c b/arch/um/drivers/mconsole_kern.c
> >> index e8f5c81c2c6c..30575bd92975 100644
> >> --- a/arch/um/drivers/mconsole_kern.c
> >> +++ b/arch/um/drivers/mconsole_kern.c
> >> @@ -36,6 +36,8 @@
> >>  #include "mconsole_kern.h"
> >>  #include <os.h>
> >>  
> >> +static struct vfsmount *proc_mnt = NULL;
> >> +
> >>  static int do_unlink_socket(struct notifier_block *notifier,
> >>  			    unsigned long what, void *data)
> >>  {
> >> @@ -123,7 +125,7 @@ void mconsole_log(struct mc_request *req)
> >>  
> >>  void mconsole_proc(struct mc_request *req)
> >>  {
> >> -	struct vfsmount *mnt = init_pid_ns.proc_mnt;
> >> +	struct vfsmount *mnt = proc_mnt;
> >>  	char *buf;
> >>  	int len;
> >>  	struct file *file;
> >> @@ -134,6 +136,10 @@ void mconsole_proc(struct mc_request *req)
> >>  	ptr += strlen("proc");
> >>  	ptr = skip_spaces(ptr);
> >>  
> >> +	if (!mnt) {
> >> +		mconsole_reply(req, "Proc not available", 1, 0);
> >> +		goto out;
> >> +	}
> >>  	file = file_open_root(mnt->mnt_root, mnt, ptr, O_RDONLY, 0);
> >>  	if (IS_ERR(file)) {
> >>  		mconsole_reply(req, "Failed to open file", 1, 0);
> >> @@ -683,6 +689,24 @@ void mconsole_stack(struct mc_request *req)
> >>  	with_console(req, stack_proc, to);
> >>  }
> >>  
> >> +static int __init mount_proc(void)
> >> +{
> >> +	struct file_system_type *proc_fs_type;
> >> +	struct vfsmount *mnt;
> >> +
> >> +	proc_fs_type = get_fs_type("proc");
> >> +	if (!proc_fs_type)
> >> +		return -ENODEV;
> >> +
> >> +	mnt = kern_mount(proc_fs_type);
> >> +	put_filesystem(proc_fs_type);
> >> +	if (IS_ERR(mnt))
> >> +		return PTR_ERR(mnt);
> >> +
> >> +	proc_mnt = mnt;
> >> +	return 0;
> >> +}
> >> +
> >>  /*
> >>   * Changed by mconsole_setup, which is __setup, and called before SMP is
> >>   * active.
> >> @@ -696,6 +720,8 @@ static int __init mconsole_init(void)
> >>  	int err;
> >>  	char file[UNIX_PATH_MAX];
> >>  
> >> +	mount_proc();
> >
> > Hm, either check the return value or make the mount_proc() void?
> > Probably worth logging something but moving on without proc.
> 
> I modified mconsole_proc (the only place that cares to see if
> it has a valid proc_mnt).
> 
> So the code already does the moving on without mounting proc
> and continues to work.

Ok, but then make mount_proc()

static void __init mount_proc(void)

and not

static int __init mount_proc(void)

like you have now. That was what I was getting it. Unless there's
another reason for this.

Christian
