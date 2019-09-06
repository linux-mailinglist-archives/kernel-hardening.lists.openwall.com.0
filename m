Return-Path: <kernel-hardening-return-16861-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 90B1CAC01F
	for <lists+kernel-hardening@lfdr.de>; Fri,  6 Sep 2019 21:04:37 +0200 (CEST)
Received: (qmail 3209 invoked by uid 550); 6 Sep 2019 19:04:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 3186 invoked from network); 6 Sep 2019 19:04:31 -0000
Date: Fri, 6 Sep 2019 12:03:26 -0700 (PDT)
From: James Morris <jmorris@namei.org>
To: Jeff Layton <jlayton@kernel.org>
cc: =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mickael.salaun@ssi.gouv.fr>,
        Florian Weimer <fweimer@redhat.com>,
        =?ISO-8859-15?Q?Micka=EBl_Sala=FCn?= <mic@digikod.net>,
        linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
        Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@kernel.org>,
        Christian Heimes <christian@python.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Chiang <ericchiang@google.com>, Jan Kara <jack@suse.cz>,
        Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
        Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>,
        Matthew Wilcox <willy@infradead.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        =?ISO-8859-15?Q?Philippe_Tr=E9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
        Scott Shell <scottsh@microsoft.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Shuah Khan <shuah@kernel.org>, Song Liu <songliubraving@fb.com>,
        Steve Dower <steve.dower@python.org>, Steve Grubb <sgrubb@redhat.com>,
        Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
        Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
        Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>,
        kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] fs: Add support for an O_MAYEXEC flag on
 sys_open()
In-Reply-To: <5a59b309f9d0603d8481a483e16b5d12ecb77540.camel@kernel.org>
Message-ID: <alpine.LRH.2.21.1909061202070.18660@namei.org>
References: <20190906152455.22757-1-mic@digikod.net>  <20190906152455.22757-2-mic@digikod.net>  <87ef0te7v3.fsf@oldenburg2.str.redhat.com>  <75442f3b-a3d8-12db-579a-2c5983426b4d@ssi.gouv.fr>  <f53ec45fd253e96d1c8d0ea6f9cca7f68afa51e3.camel@kernel.org> 
 <1fbf54f6-7597-3633-a76c-11c4b2481add@ssi.gouv.fr> <5a59b309f9d0603d8481a483e16b5d12ecb77540.camel@kernel.org>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Fri, 6 Sep 2019, Jeff Layton wrote:

> The fact that open and openat didn't vet unknown flags is really a bug.
> 
> Too late to fix it now, of course, and as Aleksa points out, we've
> worked around that in the past. Now though, we have a new openat2
> syscall on the horizon. There's little need to continue these sorts of
> hacks.
> 
> New open flags really have no place in the old syscalls, IMO.

Agree here. It's unfortunate but a reality and Linus will reject any such 
changes which break existing userspace.


-- 
James Morris
<jmorris@namei.org>

