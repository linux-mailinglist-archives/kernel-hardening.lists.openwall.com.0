Return-Path: <kernel-hardening-return-21754-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 338F392A7D0
	for <lists+kernel-hardening@lfdr.de>; Mon,  8 Jul 2024 19:06:08 +0200 (CEST)
Received: (qmail 26565 invoked by uid 550); 8 Jul 2024 17:05:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26543 invoked from network); 8 Jul 2024 17:05:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digikod.net;
	s=20191114; t=1720458346;
	bh=rqrFtsUKnrmCy2BFEII07R6XIPCDv3T85BZjHwdXhkA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iGsmbWMwtJflXK6ehzd9F4+q9ko4rI+RsU0vRG2KJenxOv9O+37g3x9xV5rgAxw8Z
	 x1SZVivMlS1QjsFvkpzoPQZqGVHx90Rr3itkH76Jq4XlBOLzK1xxTqHrU/DZq8+AiM
	 9gy+wZVKNeUrfCRAdOIT+S6aPHFpqIfzk5yYleOI=
Date: Mon, 8 Jul 2024 19:05:39 +0200
From: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
To: Jeff Xu <jeffxu@google.com>
Cc: Florian Weimer <fweimer@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Paul Moore <paul@paul-moore.com>, Theodore Ts'o <tytso@mit.edu>, 
	Alejandro Colomar <alx@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Casey Schaufler <casey@schaufler-ca.com>, Christian Heimes <christian@python.org>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Biggers <ebiggers@kernel.org>, 
	Eric Chiang <ericchiang@google.com>, Fan Wu <wufan@linux.microsoft.com>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, James Morris <jamorris@linux.microsoft.com>, 
	Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, 
	Jordan R Abrahams <ajordanr@google.com>, Lakshmi Ramasubramanian <nramas@linux.microsoft.com>, 
	Luca Boccassi <bluca@debian.org>, Luis Chamberlain <mcgrof@kernel.org>, 
	"Madhavan T . Venkataraman" <madvenka@linux.microsoft.com>, Matt Bobrowski <mattbobrowski@google.com>, 
	Matthew Garrett <mjg59@srcf.ucam.org>, Matthew Wilcox <willy@infradead.org>, 
	Miklos Szeredi <mszeredi@redhat.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Nicolas Bouchinet <nicolas.bouchinet@ssi.gouv.fr>, Scott Shell <scottsh@microsoft.com>, 
	Shuah Khan <shuah@kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, 
	Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>, 
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, 
	Xiaoming Ni <nixiaoming@huawei.com>, Yin Fengwei <fengwei.yin@intel.com>, 
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH v19 1/5] exec: Add a new AT_CHECK flag to execveat(2)
Message-ID: <20240708.ujeeDahkee4e@digikod.net>
References: <20240704190137.696169-1-mic@digikod.net>
 <20240704190137.696169-2-mic@digikod.net>
 <87bk3bvhr1.fsf@oldenburg.str.redhat.com>
 <CALmYWFu_JFyuwYhDtEDWxEob8JHFSoyx_SCcsRVKqSYyyw30Rg@mail.gmail.com>
 <87ed83etpk.fsf@oldenburg.str.redhat.com>
 <CALmYWFvkUnevm=npBeaZVkK_PXm=A8MjgxFXkASnERxoMyhYBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALmYWFvkUnevm=npBeaZVkK_PXm=A8MjgxFXkASnERxoMyhYBg@mail.gmail.com>
X-Infomaniak-Routing: alpha

On Mon, Jul 08, 2024 at 09:40:45AM -0700, Jeff Xu wrote:
> On Mon, Jul 8, 2024 at 9:26 AM Florian Weimer <fweimer@redhat.com> wrote:
> >
> > * Jeff Xu:
> >
> > > Will dynamic linkers use the execveat(AT_CHECK) to check shared
> > > libraries too ?  or just the main executable itself.
> >
> > I expect that dynamic linkers will have to do this for everything they
> > map.

Correct, that would enable to safely handle LD_PRELOAD for instance.

> Then all the objects (.so, .sh, etc.) will go through  the check from
> execveat's main  to security_bprm_creds_for_exec(), some of them might
> be specific for the main executable ?
> e.g. ChromeOS uses security_bprm_creds_for_exec to block executable
> memfd [1], applying this means automatically extending the block to
> the .so object.

That's a good example of how this AT_CHECK check makes sense.

Landlock will probably get a similar (optional) restriction too:
https://github.com/landlock-lsm/linux/issues/37

> 
> I'm not sure if other LSMs need to be updated ?  e.g.  will  SELINUX
> check for .so with its process transaction policy ?

LSM should not need to be updated with this patch series.  However,
systems/components/containers enabling this new check should make sure
it works with their current policy.

> 
> [1] https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/3834992
> 
> -Jeff
> 
> 
> > Usually, that does not include the maim program, but this can
> > happen with explicit loader invocations (“ld.so /bin/true”).
> >
> > Thanks,
> > Florian
> >
