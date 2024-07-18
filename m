Return-Path: <kernel-hardening-return-21800-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 9DE97934D17
	for <lists+kernel-hardening@lfdr.de>; Thu, 18 Jul 2024 14:23:18 +0200 (CEST)
Received: (qmail 20102 invoked by uid 550); 18 Jul 2024 12:23:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 20076 invoked from network); 18 Jul 2024 12:23:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1721305376;
	bh=UuxN7bN/Fuu2OQEszjkAFQVZQifPWKBjgSrPir4Ebkw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q+/V9E/enLZnrkKrttf8y9hOgi20C0C4HhYlV1nFcKgT0ABn2mTbB01bIrXEdykV+
	 3k6/zk6VwUdg4v8pkHW46XXJ82C//bDuJflvichEl0FOm0Pfi+x1UId3Kn6shCj6Nc
	 20PvlnlYXxM0iXovWqaAI5pmmzDtbEaTo4i6+oa4=
Date: Thu, 18 Jul 2024 14:22:49 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Steve Dower <steve.dower@python.org>, Jeff Xu <jeffxu@google.com>, 
	Al Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Paul Moore <paul@paul-moore.com>, Theodore Ts'o <tytso@mit.edu>, 
	Alejandro Colomar <alx@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christian Heimes <christian@python.org>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>, 
	Eric Chiang <ericchiang@google.com>, Fan Wu <wufan@linux.microsoft.com>, 
	Florian Weimer <fweimer@redhat.com>, Geert Uytterhoeven <geert@linux-m68k.org>, 
	James Morris <jamorris@linux.microsoft.com>, Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Jordan R Abrahams <ajordanr@google.com>, 
	Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, Luca Boccassi <bluca@debian.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, "Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, 
	Matt Bobrowski <mattbobrowski@google.com>, Matthew Garrett <mjg59@srcf.ucam.org>, 
	Matthew Wilcox <willy@infradead.org>, Miklos Szeredi <mszeredi@redhat.com>, 
	Mimi Zohar <zohar@linux.ibm.com>, Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>, 
	Scott Shell <scottsh@microsoft.com>, Shuah Khan <shuah@kernel.org>, 
	Stephen Rothwell <sfr@canb.auug.org.au>, Steve Grubb <sgrubb@redhat.com>, 
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, 
	Xiaoming Ni <nixiaoming@huawei.com>, Yin Fengwei <fengwei.yin@intel.com>, 
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org, Elliott Hughes <enh@google.com>
Subject: Re: [RFC PATCH v19 1/5] exec: Add a new AT_CHECK flag to execveat(2)
Message-ID: <20240718.Niexoo0ahch0@digikod.net>
References: <20240704190137.696169-1-mic@digikod.net>
 <20240704190137.696169-2-mic@digikod.net>
 <CALmYWFss7qcpR9D_r3pbP_Orxs55t3y3yXJsac1Wz=Hk9Di0Nw@mail.gmail.com>
 <a0da7702-dabe-49e4-87f4-5d6111f023a8@python.org>
 <20240717.AGh2shahc9ee@digikod.net>
 <CALCETrUcr3p_APNazMro7Y9FX1zLAiQESvKZ5BDgd8X3PoCdFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALCETrUcr3p_APNazMro7Y9FX1zLAiQESvKZ5BDgd8X3PoCdFw@mail.gmail.com>
X-Infomaniak-Routing: alpha

On Thu, Jul 18, 2024 at 09:02:56AM +0800, Andy Lutomirski wrote:
> > On Jul 17, 2024, at 6:01 PM, Mickaël Salaün <mic@digikod.net> wrote:
> >
> > On Wed, Jul 17, 2024 at 09:26:22AM +0100, Steve Dower wrote:
> >>> On 17/07/2024 07:33, Jeff Xu wrote:
> >>> Consider those cases: I think:
> >>> a> relying purely on userspace for enforcement does't seem to be
> >>> effective,  e.g. it is trivial  to call open(), then mmap() it into
> >>> executable memory.
> >>
> >> If there's a way to do this without running executable code that had to pass
> >> a previous execveat() check, then yeah, it's not effective (e.g. a Python
> >> interpreter that *doesn't* enforce execveat() is a trivial way to do it).
> >>
> >> Once arbitrary code is running, all bets are off. So long as all arbitrary
> >> code is being checked itself, it's allowed to do things that would bypass
> >> later checks (and it's up to whoever audited it in the first place to
> >> prevent this by not giving it the special mark that allows it to pass the
> >> check).
> >
> > Exactly.  As explained in the patches, one crucial prerequisite is that
> > the executable code is trusted, and the system must provide integrity
> > guarantees.  We cannot do anything without that.  This patches series is
> > a building block to fix a blind spot on Linux systems to be able to
> > fully control executability.
> 
> Circling back to my previous comment (did that ever get noticed?), I

Yes, I replied to your comments.  Did I miss something?

> don’t think this is quite right:
> 
> https://lore.kernel.org/all/CALCETrWYu=PYJSgyJ-vaa+3BGAry8Jo8xErZLiGR3U5h6+U0tA@mail.gmail.com/
> 
> On a basic system configuration, a given path either may or may not be
> executed. And maybe that path has some integrity check (dm-verity,
> etc).  So the kernel should tell the interpreter/loader whether the
> target may be executed. All fine.
> 
>  But I think the more complex cases are more interesting, and the
> “execute a program” process IS NOT BINARY.  An attempt to execute can
> be rejected outright, or it can be allowed *with a change to creds or
> security context*.  It would be entirely reasonable to have a policy
> that allows execution of non-integrity-checked files but in a very
> locked down context only.

I guess you mean to transition to a sandbox when executing an untrusted
file.  This is a good idea.  I talked about role transition in the
patch's description:

With the information that a script interpreter is about to interpret a
script, an LSM security policy can adjust caller's access rights or log
execution request as for native script execution (e.g. role transition).
This is possible thanks to the call to security_bprm_creds_for_exec().

> 
> So… shouldn’t a patch series to this effect actually support this?
> 

This patch series brings the minimal building blocks to have a
consistent execution environment.  Role transitions for script execution
are left to LSMs.  For instance, we could extend Landlock to
automatically sandbox untrusted scripts.
