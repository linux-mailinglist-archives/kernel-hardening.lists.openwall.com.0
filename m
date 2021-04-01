Return-Path: <kernel-hardening-return-21115-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3A5E835171C
	for <lists+kernel-hardening@lfdr.de>; Thu,  1 Apr 2021 19:11:22 +0200 (CEST)
Received: (qmail 3701 invoked by uid 550); 1 Apr 2021 17:11:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3678 invoked from network); 1 Apr 2021 17:11:14 -0000
Subject: Re: [PATCH v31 07/12] landlock: Support filesystem access-control
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Jann Horn <jannh@google.com>, Kees Cook <keescook@chromium.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@amacapital.net>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, Arnd Bergmann
 <arnd@arndb.de>, Casey Schaufler <casey@schaufler-ca.com>,
 David Howells <dhowells@redhat.com>, Jeff Dike <jdike@addtoit.com>,
 Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>,
 Richard Weinberger <richard@nod.at>, Shuah Khan <shuah@kernel.org>,
 Vincent Dagonneau <vincent.dagonneau@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-security-module@vger.kernel.org,
 x86@kernel.org, =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?=
 <mic@linux.microsoft.com>, James Morris <jmorris@namei.org>,
 "Serge E . Hallyn" <serge@hallyn.com>
References: <20210324191520.125779-1-mic@digikod.net>
 <20210324191520.125779-8-mic@digikod.net>
 <d2764451-8970-6cbd-e2bf-254a42244ffc@digikod.net>
 <YGUslUPwp85Zrp4t@zeniv-ca.linux.org.uk>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <84e1cd29-0f09-1ed4-c680-65ca8c6988a3@digikod.net>
Date: Thu, 1 Apr 2021 19:12:05 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <YGUslUPwp85Zrp4t@zeniv-ca.linux.org.uk>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit


On 01/04/2021 04:14, Al Viro wrote:
> On Wed, Mar 31, 2021 at 07:33:50PM +0200, Micka�l Sala�n wrote:
> 
>>> +static inline u64 unmask_layers(
>>> +		const struct landlock_ruleset *const domain,
>>> +		const struct path *const path, const u32 access_request,
>>> +		u64 layer_mask)
>>> +{
>>> +	const struct landlock_rule *rule;
>>> +	const struct inode *inode;
>>> +	size_t i;
>>> +
>>> +	if (d_is_negative(path->dentry))
>>> +		/* Continues to walk while there is no mapped inode. */
> 				     ^^^^^
> Odd comment, that...

I'll replace that with something more appropriate, e.g. "Ignore
nonexistent leafs".

> 
>>> +static int check_access_path(const struct landlock_ruleset *const domain,
>>> +		const struct path *const path, u32 access_request)
>>> +{
> 
>>> +	walker_path = *path;
>>> +	path_get(&walker_path);
> 
>>> +	while (true) {
>>> +		struct dentry *parent_dentry;
>>> +
>>> +		layer_mask = unmask_layers(domain, &walker_path,
>>> +				access_request, layer_mask);
>>> +		if (layer_mask == 0) {
>>> +			/* Stops when a rule from each layer grants access. */
>>> +			allowed = true;
>>> +			break;
>>> +		}
>>> +
>>> +jump_up:
>>> +		if (walker_path.dentry == walker_path.mnt->mnt_root) {
>>> +			if (follow_up(&walker_path)) {
>>> +				/* Ignores hidden mount points. */
>>> +				goto jump_up;
>>> +			} else {
>>> +				/*
>>> +				 * Stops at the real root.  Denies access
>>> +				 * because not all layers have granted access.
>>> +				 */
>>> +				allowed = false;
>>> +				break;
>>> +			}
>>> +		}
>>> +		if (unlikely(IS_ROOT(walker_path.dentry))) {
>>> +			/*
>>> +			 * Stops at disconnected root directories.  Only allows
>>> +			 * access to internal filesystems (e.g. nsfs, which is
>>> +			 * reachable through /proc/<pid>/ns/<namespace>).
>>> +			 */
>>> +			allowed = !!(walker_path.mnt->mnt_flags & MNT_INTERNAL);
>>> +			break;
>>> +		}
>>> +		parent_dentry = dget_parent(walker_path.dentry);
>>> +		dput(walker_path.dentry);
>>> +		walker_path.dentry = parent_dentry;
>>> +	}
>>> +	path_put(&walker_path);
>>> +	return allowed ? 0 : -EACCES;
> 
> That's a whole lot of grabbing/dropping references...  I realize that it's
> an utterly tactless question, but... how costly it is?  IOW, do you have
> profiling data?

It looks like a legitimate question.

First, Landlock may not be appropriate for every workloads. The
check_access_path()'s complexity is now linear, which is a consequence
of the "unprivileged" target (i.e. multiple layers of file hierarchies).
Adding caching should help a lot to improve performance (i.e. limit the
path walking), but it will come with future improvements.

I profiled a "find" loop on the linux-5.12-rc3 source tree in a tmpfs
(and with cached entries): openat(2) calls spend ~30% of their time in
check_access_path() with a base directory of one parent (/linux) and
~45% with a base directory of ten parents (/1/2/3/4/5/6/7/8/9/linux).
Overall, the performance impact is between 3.0% (with a minimum depth of
1) and 5.4% (with a minimum depth of 10) of the full execution time of
these worse case scenarios, which are ~4800 openat(2) calls. This is not
a surprise and doesn't seem so bad without optimization.


> 
>>> +/*
>>> + * pivot_root(2), like mount(2), changes the current mount namespace.  It must
>>> + * then be forbidden for a landlocked process.
> 
> ... and cross-directory rename(2) can change the tree topology.  Do you ban that
> as well?
> 
> [snip]
> 
>>> +static int hook_path_rename(const struct path *const old_dir,
>>> +		struct dentry *const old_dentry,
>>> +		const struct path *const new_dir,
>>> +		struct dentry *const new_dentry)
>>> +{
>>> +	const struct landlock_ruleset *const dom =
>>> +		landlock_get_current_domain();
>>> +
>>> +	if (!dom)
>>> +		return 0;
>>> +	/* The mount points are the same for old and new paths, cf. EXDEV. */
>>> +	if (old_dir->dentry != new_dir->dentry)
>>> +		/* For now, forbids reparenting. */
>>> +		return -EACCES;
> 
> You do, apparently, and not in a way that would have the userland fall
> back to copy+unlink.  Lovely...  Does e.g. git survive such restriction?
> Same question for your average package build...

As explained in the documentation, there is some limitations that make
this first step not appropriate for all use cases. I'll use EXDEV to
gracefully forbid reparenting, which gives a chance to userspace to deal
with that. It may not be enough for package management though. I plan to
address such limitation with future evolutions.

Thanks for these suggestions.
