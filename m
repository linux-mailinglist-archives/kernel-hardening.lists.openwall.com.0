Return-Path: <kernel-hardening-return-18384-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 6C18019C5F1
	for <lists+kernel-hardening@lfdr.de>; Thu,  2 Apr 2020 17:34:55 +0200 (CEST)
Received: (qmail 26424 invoked by uid 550); 2 Apr 2020 15:34:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26402 invoked from network); 2 Apr 2020 15:34:48 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux API <linux-api@vger.kernel.org>,  Linux FS Devel <linux-fsdevel@vger.kernel.org>,  Linux Security Module <linux-security-module@vger.kernel.org>,  Akinobu Mita <akinobu.mita@gmail.com>,  Alexander Viro <viro@zeniv.linux.org.uk>,  Alexey Dobriyan <adobriyan@gmail.com>,  Alexey Gladkov <legion@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  Andy Lutomirski <luto@kernel.org>,  Daniel Micay <danielmicay@gmail.com>,  Djalal Harouni <tixxdz@gmail.com>,  "Dmitry V . Levin" <ldv@altlinux.org>,  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,  Ingo Molnar <mingo@kernel.org>,  "J . Bruce Fields" <bfields@fieldses.org>,  Jeff Layton <jlayton@poochiereds.net>,  Jonathan Corbet <corbet@lwn.net>,  Kees Cook <keescook@chromium.org>,  Linus Torvalds <torvalds@linux-foundation.org>,  Oleg Nesterov <oleg@redhat.com>
References: <20200327172331.418878-1-gladkov.alexey@gmail.com>
	<20200327172331.418878-3-gladkov.alexey@gmail.com>
Date: Thu, 02 Apr 2020 10:31:48 -0500
In-Reply-To: <20200327172331.418878-3-gladkov.alexey@gmail.com> (Alexey
	Gladkov's message of "Fri, 27 Mar 2020 18:23:24 +0100")
Message-ID: <87eet5lx97.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jK1rV-0007tb-0b;;;mid=<87eet5lx97.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18bJm/P/P+XAlq1t04hxE6W/8b8KDRYe10=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
	DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMSubLong autolearn=disabled
	version=3.4.2
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4209]
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alexey Gladkov <gladkov.alexey@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 664 ms - load_scoreonly_sql: 0.35 (0.1%),
	signal_user_changed: 13 (2.0%), b_tie_ro: 11 (1.6%), parse: 1.62
	(0.2%), extract_message_metadata: 4.4 (0.7%), get_uri_detail_list:
	0.91 (0.1%), tests_pri_-1000: 7 (1.0%), tests_pri_-950: 1.60 (0.2%),
	tests_pri_-900: 1.25 (0.2%), tests_pri_-90: 366 (55.2%), check_bayes:
	364 (54.9%), b_tokenize: 10 (1.5%), b_tok_get_all: 143 (21.5%),
	b_comp_prob: 2.8 (0.4%), b_tok_touch_all: 205 (30.9%), b_finish: 1.12
	(0.2%), tests_pri_0: 198 (29.9%), check_dkim_signature: 0.66 (0.1%),
	check_dkim_adsp: 2.6 (0.4%), poll_dns_idle: 0.90 (0.1%), tests_pri_10:
	2.2 (0.3%), tests_pri_500: 57 (8.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v10 2/9] proc: allow to mount many instances of proc in one pid namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)


> diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
> index 40a7982b7285..5920a4ecd71b 100644
> --- a/include/linux/proc_fs.h
> +++ b/include/linux/proc_fs.h
> @@ -27,6 +27,17 @@ struct proc_ops {
>  	unsigned long (*proc_get_unmapped_area)(struct file *, unsigned long, unsigned long, unsigned long, unsigned long);
>  };
>  
> +struct proc_fs_info {
> +	struct pid_namespace *pid_ns;
> +	struct dentry *proc_self;        /* For /proc/self */
> +	struct dentry *proc_thread_self; /* For /proc/thread-self */
> +};

Minor nit.

I have not seen a patch where you remove proc_self and proc_thread_self
from struct pid_namepace.

Ideally it would have been in this patch.  But as it won't break
anyone's bisection can you please have a follow up patch that removes
those fields?

Thank you,
Eric



> +
> +static inline struct proc_fs_info *proc_sb_info(struct super_block *sb)
> +{
> +	return sb->s_fs_info;
> +}
> +
>  #ifdef CONFIG_PROC_FS
>  
>  typedef int (*proc_write_t)(struct file *, char *, size_t);
> @@ -161,6 +172,7 @@ int open_related_ns(struct ns_common *ns,
>  /* get the associated pid namespace for a file in procfs */
>  static inline struct pid_namespace *proc_pid_ns(const struct inode *inode)
>  {
> +	return proc_sb_info(inode->i_sb)->pid_ns;
>  	return inode->i_sb->s_fs_info;
>  }
