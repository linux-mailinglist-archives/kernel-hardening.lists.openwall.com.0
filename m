Return-Path: <kernel-hardening-return-16250-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 017F556362
	for <lists+kernel-hardening@lfdr.de>; Wed, 26 Jun 2019 09:34:58 +0200 (CEST)
Received: (qmail 5651 invoked by uid 550); 26 Jun 2019 07:34:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 5619 invoked from network); 26 Jun 2019 07:34:50 -0000
Subject: Re: [PATCH bpf-next v9 02/10] bpf: Add eBPF program subtype and
 is_valid_subtype() verifier
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Aleksa Sarai <cyphar@cyphar.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Alexei Starovoitov
 <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Drysdale
 <drysdale@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        James Morris <jmorris@namei.org>, Jann Horn <jann@thejh.net>,
        John Johansen <john.johansen@canonical.com>,
        Jonathan Corbet
 <corbet@lwn.net>, Kees Cook <keescook@chromium.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mickael.salaun@ssi.gouv.fr>,
        Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>,
        "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>, Tejun Heo <tj@kernel.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Thomas Graf <tgraf@suug.ch>, Tycho Andersen <tycho@tycho.ws>,
        Will Drewry <wad@chromium.org>,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Linux API <linux-api@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
References: <20190625215239.11136-1-mic@digikod.net>
 <20190625215239.11136-3-mic@digikod.net>
 <CAADnVQ+Twio22VSi21RR5TY1Zm-1xRTGmREcXLSs5Jv-KWGTiw@mail.gmail.com>
From: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>
Openpgp: preference=signencrypt
Message-ID: <1b87e170-0779-fad0-f623-8cf677843338@digikod.net>
Date: Wed, 26 Jun 2019 09:33:35 +0200
User-Agent:
MIME-Version: 1.0
In-Reply-To: <CAADnVQ+Twio22VSi21RR5TY1Zm-1xRTGmREcXLSs5Jv-KWGTiw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Antivirus: Dr.Web (R) for Unix mail servers drweb plugin ver.6.0.2.8
X-Antivirus-Code: 0x100000



On 26/06/2019 01:02, Alexei Starovoitov wrote:
> On Tue, Jun 25, 2019 at 3:04 PM Mickaël Salaün <mic@digikod.net> wrote:
>>
>> The goal of the program subtype is to be able to have different static
>> fine-grained verifications for a unique program type.
>>
>> The struct bpf_verifier_ops gets a new optional function:
>> is_valid_subtype(). This new verifier is called at the beginning of the
>> eBPF program verification to check if the (optional) program subtype is
>> valid.
>>
>> The new helper bpf_load_program_xattr() enables to verify a program with
>> subtypes.
>>
>> For now, only Landlock eBPF programs are using a program subtype (see
>> next commits) but this could be used by other program types in the
>> future.
>>
>> Signed-off-by: Mickaël Salaün <mic@digikod.net>
>> Cc: Alexei Starovoitov <ast@kernel.org>
>> Cc: Daniel Borkmann <daniel@iogearbox.net>
>> Cc: David S. Miller <davem@davemloft.net>
>> Link: https://lkml.kernel.org/r/20160827205559.GA43880@ast-mbp.thefacebook.com
>> ---
>>
>> Changes since v8:
>> * use bpf_load_program_xattr() instead of bpf_load_program() and add
>>   bpf_verify_program_xattr() to deal with subtypes
>> * remove put_extra() since there is no more "previous" field (for now)
>>
>> Changes since v7:
>> * rename LANDLOCK_SUBTYPE_* to LANDLOCK_*
>> * move subtype in bpf_prog_aux and use only one bit for has_subtype
>>   (suggested by Alexei Starovoitov)
> 
> sorry to say, but I don't think the landlock will ever land,
> since posting huge patches once a year is missing a lot of development
> that is happening during that time.

You're right that it's been a while since the last patch set, but the
main reasons behind this was a lack of feedback (probably because of the
size of the patch set, which is now reduce to a consistent minimum), the
rework needed to address everyone's concern (Landlock modify kernel
components from different maintainers), and above all, the LSM stacking
infrastructure which was quite beefy and then took some time to land:
https://lore.kernel.org/lkml/50db058a-7dde-441b-a7f9-f6837fe8b69f@schaufler-ca.com/
This stacking infrastructure was required to have a useful version of
Landlock (which is used as a use case example), and it was released with
Linux v5.1 (last month). Now, I think everything is finally ready to
move forward.

> This 2/10 patch is an example.
> subtype concept was useful 2 years ago when v6 was posted.
> Since then bpf developers faced very similar problem in other parts
> and it was solved with 'expected_attach_type' field.
> See commit 5e43f899b03a ("bpf: Check attach type at prog load time")
> dated March 2018.

I saw this nice feature but I wasn't sure if it was the right field to
use. Indeed, I need more than a "type", but also some values (triggers)
as shown by this patch. What do you suggest?
