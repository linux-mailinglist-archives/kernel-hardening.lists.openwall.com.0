Return-Path: <kernel-hardening-return-17799-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7476215B0D8
	for <lists+kernel-hardening@lfdr.de>; Wed, 12 Feb 2020 20:18:57 +0100 (CET)
Received: (qmail 9810 invoked by uid 550); 12 Feb 2020 19:18:50 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9770 invoked from network); 12 Feb 2020 19:18:49 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux API <linux-api@vger.kernel.org>,  Linux FS Devel <linux-fsdevel@vger.kernel.org>,  Linux Security Module <linux-security-module@vger.kernel.org>,  Akinobu Mita <akinobu.mita@gmail.com>,  Alexander Viro <viro@zeniv.linux.org.uk>,  Alexey Dobriyan <adobriyan@gmail.com>,  Andrew Morton <akpm@linux-foundation.org>,  Andy Lutomirski <luto@kernel.org>,  Daniel Micay <danielmicay@gmail.com>,  Djalal Harouni <tixxdz@gmail.com>,  "Dmitry V . Levin" <ldv@altlinux.org>,  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,  Ingo Molnar <mingo@kernel.org>,  "J . Bruce Fields" <bfields@fieldses.org>,  Jeff Layton <jlayton@poochiereds.net>,  Jonathan Corbet <corbet@lwn.net>,  Kees Cook <keescook@chromium.org>,  Oleg Nesterov <oleg@redhat.com>,  Solar Designer <solar@openwall.com>
References: <20200210150519.538333-1-gladkov.alexey@gmail.com>
	<20200210150519.538333-8-gladkov.alexey@gmail.com>
	<87v9odlxbr.fsf@x220.int.ebiederm.org>
	<20200212144921.sykucj4mekcziicz@comp-core-i7-2640m-0182e6>
	<87tv3vkg1a.fsf@x220.int.ebiederm.org>
	<CAHk-=wg52stFtUxMOxs3afkwDWmWn1JXC7RJ7dPsTrJbnxpZVg@mail.gmail.com>
Date: Wed, 12 Feb 2020 13:16:38 -0600
In-Reply-To: <CAHk-=wg52stFtUxMOxs3afkwDWmWn1JXC7RJ7dPsTrJbnxpZVg@mail.gmail.com>
	(Linus Torvalds's message of "Wed, 12 Feb 2020 10:45:06 -0800")
Message-ID: <87v9obipk9.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j1xWq-0000bg-Ky;;;mid=<87v9obipk9.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+FpT+28WqNfECAgpxZXu0sEMmAMmxCfO0=
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
	*      [score: 0.4994]
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 286 ms - load_scoreonly_sql: 0.05 (0.0%),
	signal_user_changed: 2.8 (1.0%), b_tie_ro: 1.84 (0.6%), parse: 0.87
	(0.3%), extract_message_metadata: 14 (5.1%), get_uri_detail_list: 1.39
	(0.5%), tests_pri_-1000: 17 (5.9%), tests_pri_-950: 1.29 (0.5%),
	tests_pri_-900: 1.04 (0.4%), tests_pri_-90: 25 (8.7%), check_bayes: 23
	(8.1%), b_tokenize: 8 (2.9%), b_tok_get_all: 8 (2.6%), b_comp_prob:
	2.4 (0.8%), b_tok_touch_all: 2.9 (1.0%), b_finish: 0.65 (0.2%),
	tests_pri_0: 212 (73.9%), check_dkim_signature: 0.54 (0.2%),
	check_dkim_adsp: 10 (3.4%), poll_dns_idle: 0.42 (0.1%), tests_pri_10:
	2.0 (0.7%), tests_pri_500: 8 (2.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v8 07/11] proc: flush task dcache entries from all procfs instances
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Wed, Feb 12, 2020 at 7:01 AM Eric W. Biederman <ebiederm@xmission.com> wrote:
>>
>> Fundamentally proc_flush_task is an optimization.  Just getting rid of
>> dentries earlier.  At least at one point it was an important
>> optimization because the old process dentries would just sit around
>> doing nothing for anyone.
>
> I'm pretty sure it's still important. It's very easy to generate a
> _ton_ of dentries with /proc.
>
>> I wonder if instead of invalidating specific dentries we could instead
>> fire wake up a shrinker and point it at one or more instances of proc.
>
> It shouldn't be the dentries themselves that are a freeing problem.
> They're being RCU-free'd anyway because of lookup. It's the
> proc_mounts list that is the problem, isn't it?
>
> So it's just fs_info that needs to be rcu-delayed because it contains
> that list. Or is there something else?

The fundamental dcache thing we are playing with is:

	dentry = d_hash_and_lookup(proc_root, &name);
	if (dentry) {
		d_invalidate(dentry);
		dput(dentry);
	}

As Al pointed out upthread dput and d_invalidate can both sleep.

The dput can potentially go away if we use __d_lookup_rcu instead of
d_lookup.

The challenge is d_invalidate.

It has the fundamentally sleeping detach_mounts loop.  Even
shrink_dcache_parent has a cond_sched() in there to ensure it doesn't
live lock the system.

We could and arguabley should set DCACHE_CANT_MOUNT on the proc pid
dentries.  Which will prevent having to deal with mounts.

But I don't see an easy way of getting shrink_dcache_parent to run
without sleeping.  Ideas?


Eric







