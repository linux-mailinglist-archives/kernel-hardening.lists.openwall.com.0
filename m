Return-Path: <kernel-hardening-return-18777-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 23BB51D0F79
	for <lists+kernel-hardening@lfdr.de>; Wed, 13 May 2020 12:14:07 +0200 (CEST)
Received: (qmail 11826 invoked by uid 550); 13 May 2020 10:14:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11806 invoked from network); 13 May 2020 10:13:59 -0000
Subject: Re: [PATCH v5 1/6] fs: Add support for an O_MAYEXEC flag on
 openat2(2)
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
 Alexei Starovoitov <ast@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
 Andy Lutomirski <luto@kernel.org>, Christian Heimes <christian@python.org>,
 Daniel Borkmann <daniel@iogearbox.net>,
 Deven Bowers <deven.desai@linux.microsoft.com>,
 Eric Chiang <ericchiang@google.com>, Florian Weimer <fweimer@redhat.com>,
 James Morris <jmorris@namei.org>, Jan Kara <jack@suse.cz>,
 Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>,
 Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
 Matthew Garrett <mjg59@google.com>, Matthew Wilcox <willy@infradead.org>,
 Michael Kerrisk <mtk.manpages@gmail.com>,
 =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
 Mimi Zohar <zohar@linux.ibm.com>,
 =?UTF-8?Q?Philippe_Tr=c3=a9buchet?= <philippe.trebuchet@ssi.gouv.fr>,
 Scott Shell <scottsh@microsoft.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 Shuah Khan <shuah@kernel.org>, Steve Dower <steve.dower@python.org>,
 Steve Grubb <sgrubb@redhat.com>,
 Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>,
 Vincent Strubel <vincent.strubel@ssi.gouv.fr>,
 kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20200505153156.925111-1-mic@digikod.net>
 <20200505153156.925111-2-mic@digikod.net> <202005121258.4213DC8A2@keescook>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <39141f3e-0a4a-6a0f-a86e-7c769fe06ffd@digikod.net>
Date: Wed, 13 May 2020 12:13:36 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <202005121258.4213DC8A2@keescook>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000


On 12/05/2020 23:05, Kees Cook wrote:
> On Tue, May 05, 2020 at 05:31:51PM +0200, Micka�l Sala�n wrote:
>> When the O_MAYEXEC flag is passed, openat2(2) may be subject to
>> additional restrictions depending on a security policy managed by the
>> kernel through a sysctl or implemented by an LSM thanks to the
>> inode_permission hook.  This new flag is ignored by open(2) and
>> openat(2).
>>
>> The underlying idea is to be able to restrict scripts interpretation
>> according to a policy defined by the system administrator.  For this to
>> be possible, script interpreters must use the O_MAYEXEC flag
>> appropriately.  To be fully effective, these interpreters also need to
>> handle the other ways to execute code: command line parameters (e.g.,
>> option -e for Perl), module loading (e.g., option -m for Python), stdin,
>> file sourcing, environment variables, configuration files, etc.
>> According to the threat model, it may be acceptable to allow some script
>> interpreters (e.g. Bash) to interpret commands from stdin, may it be a
>> TTY or a pipe, because it may not be enough to (directly) perform
>> syscalls.  Further documentation can be found in a following patch.
> 
> You touch on this lightly in the cover letter, but it seems there are
> plans for Python to restrict stdin parsing? Are there patches pending
> anywhere for other interpreters? (e.g. does CLIP OS have such patches?)

There is some example from CLIP OS 4 here :
https://github.com/clipos-archive/clipos4_portage-overlay/search?q=O_MAYEXEC
If you take a look at the whole pointed patches there is more than the
O_MAYEXEC changes (which matches this search) e.g., to prevent Python
interactive execution. There is patches for Bash, Wine, Java (Icedtea),
Busybox's ash, Perl and Python. There is also some related patches which
do not directly rely on O_MAYEXEC but which restrict the use of browser
plugins and extensions, which may be seen as scripts too:
https://github.com/clipos-archive/clipos4_portage-overlay/tree/master/www-client

> 
> There's always a push-back against adding features that have external
> dependencies, and then those external dependencies can't happen without
> the kernel first adding a feature. :) I like getting these catch-22s
> broken, and I think the kernel is the right place to start, especially
> since the threat model (and implementation) is already proven out in
> CLIP OS, and now with IMA. So, while the interpreter side of this is
> still under development, this gives them the tool they need to get it
> done on the kernel side. So showing those pieces (as you've done) is
> great, and I think finding a little bit more detail here would be even
> better.

OK, I can add my previous comment in the next cover letter.

> 
>> A simple security policy implementation, configured through a dedicated
>> sysctl, is available in a following patch.
>>
>> This is an updated subset of the patch initially written by Vincent
>> Strubel for CLIP OS 4:
>> https://github.com/clipos-archive/src_platform_clip-patches/blob/f5cb330d6b684752e403b4e41b39f7004d88e561/1901_open_mayexec.patch
>> This patch has been used for more than 11 years with customized script
>> interpreters.  Some examples (with the original name O_MAYEXEC) can be
>> found here:
>> https://github.com/clipos-archive/clipos4_portage-overlay/search?q=O_MAYEXEC
>>
>> Signed-off-by: Micka�l Sala�n <mic@digikod.net>
>> Signed-off-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
>> Signed-off-by: Vincent Strubel <vincent.strubel@ssi.gouv.fr>
> 
> nit: this needs to be reordered. It's expected that the final SoB
> matches the sender.

OK, I just sorted the list alphabetically.

> If you're trying to show co-authorship, please
> see:
> 
> https://www.kernel.org/doc/html/latest/process/submitting-patches.html#when-to-use-acked-by-cc-and-co-developed-by
> 
> Based on what I've inferred about author ordering, I think you want:
> 
> Co-developed-by: Vincent Strubel <vincent.strubel@ssi.gouv.fr>
> Signed-off-by: Vincent Strubel <vincent.strubel@ssi.gouv.fr>
> Co-developed-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
> Signed-off-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
> Co-developed-by: Micka�l Sala�n <mic@digikod.net>
> Signed-off-by: Micka�l Sala�n <mic@digikod.net>

OK, according to the doc I'll remove myself as Co-developped-by because
I'm already in the From, though.

> 
>> Reviewed-by: Deven Bowers <deven.desai@linux.microsoft.com>
>> Cc: Aleksa Sarai <cyphar@cyphar.com>
>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>> Cc: Kees Cook <keescook@chromium.org>
> 
> Everything else appears good to me, but Al and Aleksa know VFS internals
> way better. :)
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 

Thanks!
