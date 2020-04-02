Return-Path: <kernel-hardening-return-18394-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8652319C7A2
	for <lists+kernel-hardening@lfdr.de>; Thu,  2 Apr 2020 19:07:51 +0200 (CEST)
Received: (qmail 17639 invoked by uid 550); 2 Apr 2020 17:07:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17617 invoked from network); 2 Apr 2020 17:07:45 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux API <linux-api@vger.kernel.org>,  Linux FS Devel <linux-fsdevel@vger.kernel.org>,  Linux Security Module <linux-security-module@vger.kernel.org>,  Akinobu Mita <akinobu.mita@gmail.com>,  Alexander Viro <viro@zeniv.linux.org.uk>,  Alexey Dobriyan <adobriyan@gmail.com>,  Andrew Morton <akpm@linux-foundation.org>,  Andy Lutomirski <luto@kernel.org>,  Daniel Micay <danielmicay@gmail.com>,  Djalal Harouni <tixxdz@gmail.com>,  "Dmitry V . Levin" <ldv@altlinux.org>,  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,  Ingo Molnar <mingo@kernel.org>,  "J . Bruce Fields" <bfields@fieldses.org>,  Jeff Layton <jlayton@poochiereds.net>,  Jonathan Corbet <corbet@lwn.net>,  Kees Cook <keescook@chromium.org>,  Linus Torvalds <torvalds@linux-foundation.org>,  Oleg Nesterov <oleg@redhat.com>,  David Howells <dhowells@redhat.com>
References: <20200327172331.418878-1-gladkov.alexey@gmail.com>
	<20200327172331.418878-9-gladkov.alexey@gmail.com>
	<87d08pkh4u.fsf@x220.int.ebiederm.org>
	<20200402165156.4mzenof4upvtd3lv@comp-core-i7-2640m-0182e6>
Date: Thu, 02 Apr 2020 12:04:44 -0500
In-Reply-To: <20200402165156.4mzenof4upvtd3lv@comp-core-i7-2640m-0182e6>
	(Alexey Gladkov's message of "Thu, 2 Apr 2020 18:51:56 +0200")
Message-ID: <87r1x5iztf.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-XM-SPF: eid=1jK3JQ-0007EN-Ov;;;mid=<87r1x5iztf.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19JB6md/ag4gch1HCHlHqnPcaDKiSdq078=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa02.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=8.0 tests=ALL_TRUSTED,BAYES_20,
	DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMSubLong,
	XM_B_Unicode autolearn=disabled version=3.4.2
X-Spam-Virus: No
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1284]
	*  0.7 XMSubLong Long Subject
	*  0.0 XM_B_Unicode BODY: Testing for specific types of unicode
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alexey Gladkov <gladkov.alexey@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 293 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 3.6 (1.2%), b_tie_ro: 2.6 (0.9%), parse: 0.70
	(0.2%), extract_message_metadata: 2.5 (0.9%), get_uri_detail_list:
	1.02 (0.3%), tests_pri_-1000: 3.8 (1.3%), tests_pri_-950: 0.99 (0.3%),
	tests_pri_-900: 0.89 (0.3%), tests_pri_-90: 60 (20.6%), check_bayes:
	59 (20.2%), b_tokenize: 7 (2.3%), b_tok_get_all: 7 (2.5%),
	b_comp_prob: 1.62 (0.6%), b_tok_touch_all: 41 (13.9%), b_finish: 0.73
	(0.2%), tests_pri_0: 207 (70.7%), check_dkim_signature: 0.38 (0.1%),
	check_dkim_adsp: 2.4 (0.8%), poll_dns_idle: 0.98 (0.3%), tests_pri_10:
	1.63 (0.6%), tests_pri_500: 5 (1.9%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v10 8/9] proc: use human-readable values for hidehid
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)

Alexey Gladkov <gladkov.alexey@gmail.com> writes:

> On Thu, Apr 02, 2020 at 11:05:21AM -0500, Eric W. Biederman wrote:
>> Alexey Gladkov <gladkov.alexey@gmail.com> writes:
>>=20
>> > The hidepid parameter values are becoming more and more and it becomes
>> > difficult to remember what each new magic number means.
>>=20
>> In principle I like this change.  In practice I think you have just
>> broken ABI compatiblity with the new mount ABI.
>>=20
>> In particular the following line seems broken.
>>=20
>> > diff --git a/fs/proc/root.c b/fs/proc/root.c
>> > index dbcd96f07c7a..ba782d6e6197 100644
>> > --- a/fs/proc/root.c
>> > +++ b/fs/proc/root.c
>> > @@ -45,7 +45,7 @@ enum proc_param {
>> >=20=20
>> >  static const struct fs_parameter_spec proc_fs_parameters[] =3D {
>> >  	fsparam_u32("gid",	Opt_gid),
>> > -	fsparam_u32("hidepid",	Opt_hidepid),
>> > +	fsparam_string("hidepid",	Opt_hidepid),
>> >  	fsparam_string("subset",	Opt_subset),
>> >  	{}
>> >  };
>>=20
>> As I read fs_parser.c fs_param_is_u32 handles string inputs and turns th=
em
>> into numbers, and it handles binary numbers.  However fs_param_is_string
>> appears to only handle strings.  It appears to have not capacity to turn
>> raw binary numbers into strings.
>
> I use result only with hidepid_u32_spec and nobody modifies param->string.
> I do not use internal functions here.
>
> I don=E2=80=99t follow how a raw number can get here ?

I may be wrong but last I looked you can input raw numbers using the new
mount api.   I have most of the details paged out at the moment,
but I believe that is why when you set a parameter in the new mount api
it takes a type.

>> So I think we probably need to fix fs_param_is_string to raw binary
>> numbers before we can safely make this change to fs/proc/root.c
>>=20
>> David am I reading the fs_parser.c code correctly?  If I am are you ok
>> with a change like the above?

Eric
