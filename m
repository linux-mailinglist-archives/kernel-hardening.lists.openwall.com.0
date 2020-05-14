Return-Path: <kernel-hardening-return-18808-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 11D1B1D3D54
	for <lists+kernel-hardening@lfdr.de>; Thu, 14 May 2020 21:21:41 +0200 (CEST)
Received: (qmail 20470 invoked by uid 550); 14 May 2020 19:21:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 20450 invoked from network); 14 May 2020 19:21:35 -0000
Subject: Re: [PATCH v5 3/6] fs: Enable to enforce noexec mounts or file exec
 through O_MAYEXEC
To: Kees Cook <keescook@chromium.org>,
 Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
 Aleksa Sarai <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>,
 Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>,
 Christian Heimes <christian@python.org>,
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
 linux-integrity@vger.kernel.org,
 LSM List <linux-security-module@vger.kernel.org>,
 Linux FS Devel <linux-fsdevel@vger.kernel.org>
References: <20200505153156.925111-1-mic@digikod.net>
 <20200505153156.925111-4-mic@digikod.net>
 <CAEjxPJ7y2G5hW0WTH0rSrDZrorzcJ7nrQBjfps2OWV5t1BUYHw@mail.gmail.com>
 <202005131525.D08BFB3@keescook>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Message-ID: <0e654c90-bec5-6ba1-771e-648da94ef547@digikod.net>
Date: Thu, 14 May 2020 21:21:21 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <202005131525.D08BFB3@keescook>
Content-Type: text/plain; charset=iso-8859-15
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000



On 14/05/2020 01:27, Kees Cook wrote:
> On Wed, May 13, 2020 at 11:37:16AM -0400, Stephen Smalley wrote:
>> On Tue, May 5, 2020 at 11:33 AM Micka�l Sala�n <mic@digikod.net> wrote:
>>>
>>> Enable to forbid access to files open with O_MAYEXEC.  Thanks to the
>>> noexec option from the underlying VFS mount, or to the file execute
>>> permission, userspace can enforce these execution policies.  This may
>>> allow script interpreters to check execution permission before reading
>>> commands from a file, or dynamic linkers to allow shared object loading.
>>>
>>> Add a new sysctl fs.open_mayexec_enforce to enable system administrators
>>> to enforce two complementary security policies according to the
>>> installed system: enforce the noexec mount option, and enforce
>>> executable file permission.  Indeed, because of compatibility with
>>> installed systems, only system administrators are able to check that
>>> this new enforcement is in line with the system mount points and file
>>> permissions.  A following patch adds documentation.
>>>
>>> For tailored Linux distributions, it is possible to enforce such
>>> restriction at build time thanks to the CONFIG_OMAYEXEC_STATIC option.
>>> The policy can then be configured with CONFIG_OMAYEXEC_ENFORCE_MOUNT and
>>> CONFIG_OMAYEXEC_ENFORCE_FILE.
>>>
>>> Being able to restrict execution also enables to protect the kernel by
>>> restricting arbitrary syscalls that an attacker could perform with a
>>> crafted binary or certain script languages.  It also improves multilevel
>>> isolation by reducing the ability of an attacker to use side channels
>>> with specific code.  These restrictions can natively be enforced for ELF
>>> binaries (with the noexec mount option) but require this kernel
>>> extension to properly handle scripts (e.g., Python, Perl).  To get a
>>> consistent execution policy, additional memory restrictions should also
>>> be enforced (e.g. thanks to SELinux).
>>>
>>> Signed-off-by: Micka�l Sala�n <mic@digikod.net>
>>> Reviewed-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
>>> Cc: Aleksa Sarai <cyphar@cyphar.com>
>>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>>> Cc: Kees Cook <keescook@chromium.org>
>>> ---
>>
>>> diff --git a/fs/namei.c b/fs/namei.c
>>> index 33b6d372e74a..70f179f6bc6c 100644
>>> --- a/fs/namei.c
>>> +++ b/fs/namei.c
>>> @@ -411,10 +412,90 @@ static int sb_permission(struct super_block *sb, struct inode *inode, int mask)
>> <snip>
>>> +#if defined(CONFIG_SYSCTL) && !defined(CONFIG_OMAYEXEC_STATIC)
>>> +int proc_omayexec(struct ctl_table *table, int write, void __user *buffer,
>>> +               size_t *lenp, loff_t *ppos)
>>> +{
>>> +       int error;
>>> +
>>> +       if (write) {
>>> +               struct ctl_table table_copy;
>>> +               int tmp_mayexec_enforce;
>>> +
>>> +               if (!capable(CAP_MAC_ADMIN))
>>> +                       return -EPERM;
>>
>> Not fond of using CAP_MAC_ADMIN here (or elsewhere outside of security
>> modules).  The ability to set this sysctl is not equivalent to being
>> able to load a MAC policy, set arbitrary MAC labels on
>> processes/files, etc.
> 
> That's fair. In that case, perhaps this could just use the existing
> _sysadmin helper? (Though I should note that these perm checks actually
> need to be in the open, not the read/write ... I thought there was a
> series to fix that, but I can't find it now. Regardless, that's
> orthogonal to this series.)

OK, I'll switch to CAP_SYS_ADMIN with proc_dointvec_minmax_sysadmin().
