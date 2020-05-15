Return-Path: <kernel-hardening-return-18810-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 1A0781D4293
	for <lists+kernel-hardening@lfdr.de>; Fri, 15 May 2020 03:00:12 +0200 (CEST)
Received: (qmail 1223 invoked by uid 550); 15 May 2020 01:00:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1203 invoked from network); 15 May 2020 01:00:02 -0000
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav106.sakura.ne.jp)
Subject: Re: [PATCH v5 3/6] fs: Enable to enforce noexec mounts or file exec
 through O_MAYEXEC
To: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>,
        Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Kees Cook <keescook@chromium.org>,
        John Johansen <john.johansen@canonical.com>,
        Kentaro Takeda <takedakn@nttdata.co.jp>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Aleksa Sarai
 <cyphar@cyphar.com>, Alexei Starovoitov <ast@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>,
        Christian Heimes <christian@python.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Deven Bowers <deven.desai@linux.microsoft.com>,
        Eric Chiang <ericchiang@google.com>,
        Florian Weimer <fweimer@redhat.com>, James Morris <jmorris@namei.org>,
        Jan Kara <jack@suse.cz>, Jann Horn <jannh@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        Matthew Garrett <mjg59@google.com>,
        Matthew Wilcox <willy@infradead.org>,
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
 <202005131525.D08BFB3@keescook> <202005132002.91B8B63@keescook>
 <CAEjxPJ7WjeQAz3XSCtgpYiRtH+Jx-UkSTaEcnVyz_jwXKE3dkw@mail.gmail.com>
 <202005140830.2475344F86@keescook>
 <CAEjxPJ4R_juwvRbKiCg5OGuhAi1ZuVytK4fKCDT_kT6VKc8iRg@mail.gmail.com>
 <b740d658-a2da-5773-7a10-59a0ca52ac6b@digikod.net>
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Message-ID: <5263f2ea-1267-7370-6463-da8c9d9145fd@i-love.sakura.ne.jp>
Date: Fri, 15 May 2020 09:58:00 +0900
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <b740d658-a2da-5773-7a10-59a0ca52ac6b@digikod.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit

On 2020/05/06 0:31, Mickaël Salaün wrote:
> The goal of this patch series is to enable to control script execution
> with interpreters help.  A new O_MAYEXEC flag, usable through
> openat2(2), is added to enable userspace script interpreter to delegate
> to the kernel (and thus the system security policy) the permission to
> interpret/execute scripts or other files containing what can be seen as
> commands.

Since TOMOYO considers that any file (even standard input which is connected
to keyboard) can provide data which can be interpreted as executable, TOMOYO
does not check traditional "execute permission". TOMOYO's execute permission
serves as a gate for replacing current process with a new file using execve()
syscall. All other calls (e.g. uselib(), open()) are simply treated as
opening a file for read/write/append etc. Therefore,

On 14/05/2020 18:10, Stephen Smalley wrote:> Just do both in build_open_flags() and be done with it? Looks like he
> was already setting FMODE_EXEC in patch 1 so we just need to teach> AppArmor/TOMOYO to check for it and perform file execute checking in> that case if !current->in_execve?
regarding TOMOYO, I don't think that TOMOYO needs to perform file execute
checking if !current->in_execve , even if O_MAYEXEC is introduced.

