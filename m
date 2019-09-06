Return-Path: <kernel-hardening-return-16850-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 142ABABF5F
	for <lists+kernel-hardening@lfdr.de>; Fri,  6 Sep 2019 20:28:03 +0200 (CEST)
Received: (qmail 20345 invoked by uid 550); 6 Sep 2019 18:27:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 20319 invoked from network); 6 Sep 2019 18:27:55 -0000
From: Florian Weimer <fweimer@redhat.com>
To: Tycho Andersen <tycho@tycho.ws>
Cc: Christian Brauner <christian.brauner@ubuntu.com>,  Aleksa Sarai
 <cyphar@cyphar.com>,  =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?=
 <mickael.salaun@ssi.gouv.fr>,
  =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>,
  linux-kernel@vger.kernel.org,  Alexei
 Starovoitov <ast@kernel.org>,  Al Viro <viro@zeniv.linux.org.uk>,  Andy
 Lutomirski <luto@kernel.org>,  Christian Heimes <christian@python.org>,
  Daniel Borkmann <daniel@iogearbox.net>,  Eric Chiang
 <ericchiang@google.com>,  James Morris <jmorris@namei.org>,  Jan Kara
 <jack@suse.cz>,  Jann Horn <jannh@google.com>,  Jonathan Corbet
 <corbet@lwn.net>,  Kees Cook <keescook@chromium.org>,  Matthew Garrett
 <mjg59@google.com>,  Matthew Wilcox <willy@infradead.org>,  Michael
 Kerrisk <mtk.manpages@gmail.com>,  Mimi Zohar <zohar@linux.ibm.com>,
  Philippe =?utf-8?Q?Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
  Scott Shell
 <scottsh@microsoft.com>,  Sean Christopherson
 <sean.j.christopherson@intel.com>,  Shuah Khan <shuah@kernel.org>,  Song
 Liu <songliubraving@fb.com>,  Steve Dower <steve.dower@python.org>,  Steve
 Grubb <sgrubb@redhat.com>,  Thibaut Sautereau
 <thibaut.sautereau@ssi.gouv.fr>,  Vincent Strubel
 <vincent.strubel@ssi.gouv.fr>,  Yves-Alexis Perez
 <yves-alexis.perez@ssi.gouv.fr>,  kernel-hardening@lists.openwall.com,
  linux-api@vger.kernel.org,  linux-security-module@vger.kernel.org,
  linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] fs: Add support for an O_MAYEXEC flag on sys_open()
References: <20190906152455.22757-1-mic@digikod.net>
	<20190906152455.22757-2-mic@digikod.net>
	<87ef0te7v3.fsf@oldenburg2.str.redhat.com>
	<75442f3b-a3d8-12db-579a-2c5983426b4d@ssi.gouv.fr>
	<20190906170739.kk3opr2phidb7ilb@yavin.dot.cyphar.com>
	<20190906172050.v44f43psd6qc6awi@wittgenstein>
	<20190906174041.GH7627@cisco>
Date: Fri, 06 Sep 2019 20:27:31 +0200
In-Reply-To: <20190906174041.GH7627@cisco> (Tycho Andersen's message of "Fri,
	6 Sep 2019 11:40:41 -0600")
Message-ID: <87v9u5cmb0.fsf@oldenburg2.str.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Fri, 06 Sep 2019 18:27:43 +0000 (UTC)

* Tycho Andersen:

> On Fri, Sep 06, 2019 at 07:20:51PM +0200, Christian Brauner wrote:
>> On Sat, Sep 07, 2019 at 03:07:39AM +1000, Aleksa Sarai wrote:
>> > On 2019-09-06, Micka=C3=ABl Sala=C3=BCn <mickael.salaun@ssi.gouv.fr> w=
rote:
>> > >=20
>> > > On 06/09/2019 17:56, Florian Weimer wrote:
>> > > > Let's assume I want to add support for this to the glibc dynamic l=
oader,
>> > > > while still being able to run on older kernels.
>> > > >
>> > > > Is it safe to try the open call first, with O_MAYEXEC, and if that=
 fails
>> > > > with EINVAL, try again without O_MAYEXEC?
>> > >=20
>> > > The kernel ignore unknown open(2) flags, so yes, it is safe even for
>> > > older kernel to use O_MAYEXEC.
>> >=20
>> > Depends on your definition of "safe" -- a security feature that you wi=
ll
>> > silently not enable on older kernels doesn't sound super safe to me.
>> > Unfortunately this is a limitation of open(2) that we cannot change --
>> > which is why the openat2(2) proposal I've been posting gives -EINVAL f=
or
>> > unknown O_* flags.
>> >=20
>> > There is a way to probe for support (though unpleasant), by creating a
>> > test O_MAYEXEC fd and then checking if the flag is present in
>> > /proc/self/fdinfo/$n.
>>=20
>> Which Florian said they can't do for various reasons.
>>=20
>> It is a major painpoint if there's no easy way for userspace to probe
>> for support. Especially if it's security related which usually means
>> that you want to know whether this feature works or not.
>
> What about just trying to violate the policy via fexecve() instead of
> looking around in /proc? Still ugly, though.

How would we do this?  This is about opening the main executable as part
of an explicit loader invocation.  Typically, an fexecve will succeed
and try to run the program, but with the wrong dynamic loader.

Thanks,
Florian
