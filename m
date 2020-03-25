Return-Path: <kernel-hardening-return-18225-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7B62C1930D3
	for <lists+kernel-hardening@lfdr.de>; Wed, 25 Mar 2020 20:04:50 +0100 (CET)
Received: (qmail 13981 invoked by uid 550); 25 Mar 2020 19:04:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13961 invoked from network); 25 Mar 2020 19:04:43 -0000
Date: Wed, 25 Mar 2020 20:04:29 +0100
From: Alexey Gladkov <gladkov.alexey@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux API <linux-api@vger.kernel.org>,
	Linux FS Devel <linux-fsdevel@vger.kernel.org>,
	Linux Security Module <linux-security-module@vger.kernel.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
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
	Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH RESEND v9 3/8] proc: move hide_pid, pid_gid from
 pid_namespace to proc_fs_info
Message-ID: <20200325190429.73k52amlfjer7epa@comp-core-i7-2640m-0182e6>
References: <20200324204449.7263-1-gladkov.alexey@gmail.com>
 <20200324204449.7263-4-gladkov.alexey@gmail.com>
 <CAHk-=whXbgW7-FYL4Rkaoh8qX+CkS5saVGP2hsJPV0c+EZ6K7A@mail.gmail.com>
 <20200325180015.GA18706@avx2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200325180015.GA18706@avx2>

On Wed, Mar 25, 2020 at 09:00:15PM +0300, Alexey Dobriyan wrote:
> On Tue, Mar 24, 2020 at 02:21:59PM -0700, Linus Torvalds wrote:
> > On Tue, Mar 24, 2020 at 1:46 PM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
> > >
> > > +/* definitions for hide_pid field */
> > > +enum {
> > > +       HIDEPID_OFF       = 0,
> > > +       HIDEPID_NO_ACCESS = 1,
> > > +       HIDEPID_INVISIBLE = 2,
> > > +};
> > 
> > Should this enum be named...
> > 
> > >  struct proc_fs_info {
> > >         struct pid_namespace *pid_ns;
> > >         struct dentry *proc_self;        /* For /proc/self */
> > >         struct dentry *proc_thread_self; /* For /proc/thread-self */
> > > +       kgid_t pid_gid;
> > > +       int hide_pid;
> > >  };
> > 
> > .. and then used here instead of "int"?
> > 
> > Same goes for 'struct proc_fs_context' too, for that matter?
> > 
> > And maybe in the function declarations and definitions too? In things
> > like 'has_pid_permissions()' (the series adds some other cases later,
> > like hidepid2str() etc)
> > 
> > Yeah, enums and ints are kind of interchangeable in C, but even if it
> > wouldn't give us any more typechecking (except perhaps with sparse if
> > you mark it so), it would be documenting the use.
> > 
> > Or am I missing something?
> > 
> > Anyway, I continue to think the series looks fine, bnut would love to
> > see it in -next and perhaps comments from Al and Alexey Dobriyan..
> 
> Patches are OK, except the part where "pid" is named "pidfs" and
> the suffix doesn't convey any information.

I will fix this in the final version.

> 	mount -t proc -o subset=pid,sysctl,misc

I have not yet figured out how to implement this. I mean subset=meminfo,misc.

-- 
Rgrds, legion

