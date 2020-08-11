Return-Path: <kernel-hardening-return-19602-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id F1CC824207A
	for <lists+kernel-hardening@lfdr.de>; Tue, 11 Aug 2020 21:40:35 +0200 (CEST)
Received: (qmail 11922 invoked by uid 550); 11 Aug 2020 19:40:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 11897 invoked from network); 11 Aug 2020 19:40:29 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>
Cc: linux-kernel@vger.kernel.org,  Aleksa Sarai <cyphar@cyphar.com>,  Alexei
 Starovoitov <ast@kernel.org>,  Al Viro <viro@zeniv.linux.org.uk>,  Andrew
 Morton <akpm@linux-foundation.org>,  Andy Lutomirski <luto@kernel.org>,
  Christian Brauner <christian.brauner@ubuntu.com>,  Christian Heimes
 <christian@python.org>,  Daniel Borkmann <daniel@iogearbox.net>,  Deven
 Bowers <deven.desai@linux.microsoft.com>,  Dmitry Vyukov
 <dvyukov@google.com>,  Eric Biggers <ebiggers@kernel.org>,  Eric Chiang
 <ericchiang@google.com>,  Florian Weimer <fweimer@redhat.com>,  James
 Morris <jmorris@namei.org>,  Jan Kara <jack@suse.cz>,  Jann Horn
 <jannh@google.com>,  Jonathan Corbet <corbet@lwn.net>,  Kees Cook
 <keescook@chromium.org>,  Lakshmi Ramasubramanian
 <nramas@linux.microsoft.com>,  Matthew Garrett <mjg59@google.com>,
  Matthew Wilcox <willy@infradead.org>,  Michael Kerrisk
 <mtk.manpages@gmail.com>,  Mimi Zohar <zohar@linux.ibm.com>,  Philippe
 =?utf-8?Q?Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>,  Scott Shell
 <scottsh@microsoft.com>,  Sean Christopherson
 <sean.j.christopherson@intel.com>,  Shuah Khan <shuah@kernel.org>,  Steve
 Dower <steve.dower@python.org>,  Steve Grubb <sgrubb@redhat.com>,  Tetsuo
 Handa <penguin-kernel@I-love.SAKURA.ne.jp>,  Thibaut Sautereau
 <thibaut.sautereau@clip-os.org>,  Vincent Strubel
 <vincent.strubel@ssi.gouv.fr>,  kernel-hardening@lists.openwall.com,
  linux-api@vger.kernel.org,  linux-integrity@vger.kernel.org,
  linux-security-module@vger.kernel.org,  linux-fsdevel@vger.kernel.org
References: <20200723171227.446711-1-mic@digikod.net>
	<20200723171227.446711-4-mic@digikod.net>
Date: Tue, 11 Aug 2020 14:36:38 -0500
In-Reply-To: <20200723171227.446711-4-mic@digikod.net> (=?utf-8?Q?=22Micka?=
 =?utf-8?Q?=C3=ABl_Sala=C3=BCn=22's?=
	message of "Thu, 23 Jul 2020 19:12:23 +0200")
Message-ID: <87a6z1m0u1.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-XM-SPF: eid=1k5a7w-0004Qr-Ti;;;mid=<87a6z1m0u1.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18bRw6Qx631bJvZB6GAyvN2Z5/PhB9504A=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: *
X-Spam-Status: No, score=1.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
	DCC_CHECK_NEGATIVE,LotsOfNums_01,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,
	T_TooManySym_02,T_TooManySym_03,XM_B_Unicode autolearn=disabled
	version=3.4.2
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4984]
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.0 XM_B_Unicode BODY: Testing for specific types of unicode
	*  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 0; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
X-Spam-DCC: ; sa06 0; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: =?ISO-8859-1?Q?*;Micka=c3=abl Sala=c3=bcn <mic@digikod.net>?=
X-Spam-Relay-Country: 
X-Spam-Timing: total 506 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 11 (2.2%), b_tie_ro: 10 (1.9%), parse: 1.44
	(0.3%), extract_message_metadata: 17 (3.3%), get_uri_detail_list: 2.7
	(0.5%), tests_pri_-1000: 10 (2.0%), tests_pri_-950: 1.22 (0.2%),
	tests_pri_-900: 1.10 (0.2%), tests_pri_-90: 84 (16.6%), check_bayes:
	82 (16.3%), b_tokenize: 16 (3.1%), b_tok_get_all: 11 (2.1%),
	b_comp_prob: 2.9 (0.6%), b_tok_touch_all: 49 (9.7%), b_finish: 1.00
	(0.2%), tests_pri_0: 336 (66.4%), check_dkim_signature: 0.62 (0.1%),
	check_dkim_adsp: 3.2 (0.6%), poll_dns_idle: 26 (5.1%), tests_pri_10:
	2.2 (0.4%), tests_pri_500: 38 (7.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v7 3/7] exec: Move path_noexec() check earlier
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)

Micka=C3=ABl Sala=C3=BCn <mic@digikod.net> writes:

> From: Kees Cook <keescook@chromium.org>
>
> The path_noexec() check, like the regular file check, was happening too
> late, letting LSMs see impossible execve()s. Check it earlier as well
> in may_open() and collect the redundant fs/exec.c path_noexec() test
> under the same robustness comment as the S_ISREG() check.
>
> My notes on the call path, and related arguments, checks, etc:

A big question arises, that I think someone already asked.

Why perform this test in may_open directly instead of moving
it into inode_permission.  That way the code can be shared with
faccessat, and any other code path that wants it?

That would look to provide a more maintainable kernel.

Eric


> do_open_execat()
>     struct open_flags open_exec_flags =3D {
>         .open_flag =3D O_LARGEFILE | O_RDONLY | __FMODE_EXEC,
>         .acc_mode =3D MAY_EXEC,
>         ...
>     do_filp_open(dfd, filename, open_flags)
>         path_openat(nameidata, open_flags, flags)
>             file =3D alloc_empty_file(open_flags, current_cred());
>             do_open(nameidata, file, open_flags)
>                 may_open(path, acc_mode, open_flag)
>                     /* new location of MAY_EXEC vs path_noexec() test */
>                     inode_permission(inode, MAY_OPEN | acc_mode)
>                         security_inode_permission(inode, acc_mode)
>                 vfs_open(path, file)
>                     do_dentry_open(file, path->dentry->d_inode, open)
>                         security_file_open(f)
>                         open()
>     /* old location of path_noexec() test */
>
> Signed-off-by: Micka=C3=ABl Sala=C3=BCn <mic@digikod.net>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Link: https://lore.kernel.org/r/20200605160013.3954297-4-keescook@chromiu=
m.org
> ---
>  fs/exec.c  | 12 ++++--------
>  fs/namei.c |  4 ++++
>  2 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/fs/exec.c b/fs/exec.c
> index bdc6a6eb5dce..4eea20c27b01 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -147,10 +147,8 @@ SYSCALL_DEFINE1(uselib, const char __user *, library)
>  	 * and check again at the very end too.
>  	 */
>  	error =3D -EACCES;
> -	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode)))
> -		goto exit;
> -
> -	if (path_noexec(&file->f_path))
> +	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode) ||
> +			 path_noexec(&file->f_path)))
>  		goto exit;
>=20=20
>  	fsnotify_open(file);
> @@ -897,10 +895,8 @@ static struct file *do_open_execat(int fd, struct fi=
lename *name, int flags)
>  	 * and check again at the very end too.
>  	 */
>  	err =3D -EACCES;
> -	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode)))
> -		goto exit;
> -
> -	if (path_noexec(&file->f_path))
> +	if (WARN_ON_ONCE(!S_ISREG(file_inode(file)->i_mode) ||
> +			 path_noexec(&file->f_path)))
>  		goto exit;
>=20=20
>  	err =3D deny_write_access(file);
> diff --git a/fs/namei.c b/fs/namei.c
> index a559ad943970..ddc9b25540fe 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2863,6 +2863,10 @@ static int may_open(const struct path *path, int a=
cc_mode, int flag)
>  			return -EACCES;
>  		flag &=3D ~O_TRUNC;
>  		break;
> +	case S_IFREG:
> +		if ((acc_mode & MAY_EXEC) && path_noexec(path))
> +			return -EACCES;
> +		break;
>  	}
>=20=20
>  	error =3D inode_permission(inode, MAY_OPEN | acc_mode);
