Return-Path: <kernel-hardening-return-16856-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 09C70ABF96
	for <lists+kernel-hardening@lfdr.de>; Fri,  6 Sep 2019 20:45:42 +0200 (CEST)
Received: (qmail 6070 invoked by uid 550); 6 Sep 2019 18:45:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 16332 invoked from network); 6 Sep 2019 17:21:36 -0000
Date: Fri, 6 Sep 2019 19:20:51 +0200
From: Christian Brauner <christian.brauner@ubuntu.com>
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>,
	Florian Weimer <fweimer@redhat.com>,
	=?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
	linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@kernel.org>,
	Christian Heimes <christian@python.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eric Chiang <ericchiang@google.com>,
	James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
	Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
	Kees Cook <keescook@chromium.org>,
	Matthew Garrett <mjg59@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Philippe =?utf-8?Q?Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
	Scott Shell <scottsh@microsoft.com>,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Shuah Khan <shuah@kernel.org>, Song Liu <songliubraving@fb.com>,
	Steve Dower <steve.dower@python.org>,
	Steve Grubb <sgrubb@redhat.com>,
	Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
	Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
	Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] fs: Add support for an O_MAYEXEC flag on
 sys_open()
Message-ID: <20190906172050.v44f43psd6qc6awi@wittgenstein>
References: <20190906152455.22757-1-mic@digikod.net>
 <20190906152455.22757-2-mic@digikod.net>
 <87ef0te7v3.fsf@oldenburg2.str.redhat.com>
 <75442f3b-a3d8-12db-579a-2c5983426b4d@ssi.gouv.fr>
 <20190906170739.kk3opr2phidb7ilb@yavin.dot.cyphar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190906170739.kk3opr2phidb7ilb@yavin.dot.cyphar.com>
User-Agent: NeoMutt/20180716

On Sat, Sep 07, 2019 at 03:07:39AM +1000, Aleksa Sarai wrote:
> On 2019-09-06, Mickaël Salaün <mickael.salaun@ssi.gouv.fr> wrote:
> > 
> > On 06/09/2019 17:56, Florian Weimer wrote:
> > > Let's assume I want to add support for this to the glibc dynamic loader,
> > > while still being able to run on older kernels.
> > >
> > > Is it safe to try the open call first, with O_MAYEXEC, and if that fails
> > > with EINVAL, try again without O_MAYEXEC?
> > 
> > The kernel ignore unknown open(2) flags, so yes, it is safe even for
> > older kernel to use O_MAYEXEC.
> 
> Depends on your definition of "safe" -- a security feature that you will
> silently not enable on older kernels doesn't sound super safe to me.
> Unfortunately this is a limitation of open(2) that we cannot change --
> which is why the openat2(2) proposal I've been posting gives -EINVAL for
> unknown O_* flags.
> 
> There is a way to probe for support (though unpleasant), by creating a
> test O_MAYEXEC fd and then checking if the flag is present in
> /proc/self/fdinfo/$n.

Which Florian said they can't do for various reasons.

It is a major painpoint if there's no easy way for userspace to probe
for support. Especially if it's security related which usually means
that you want to know whether this feature works or not.

Christian
