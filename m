Return-Path: <kernel-hardening-return-17819-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8A49B15D0C3
	for <lists+kernel-hardening@lfdr.de>; Fri, 14 Feb 2020 04:51:35 +0100 (CET)
Received: (qmail 32129 invoked by uid 550); 14 Feb 2020 03:51:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 32089 invoked from network); 14 Feb 2020 03:51:28 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,  LKML <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux API <linux-api@vger.kernel.org>,  Linux FS Devel <linux-fsdevel@vger.kernel.org>,  Linux Security Module <linux-security-module@vger.kernel.org>,  Akinobu Mita <akinobu.mita@gmail.com>,  Alexey Dobriyan <adobriyan@gmail.com>,  Andrew Morton <akpm@linux-foundation.org>,  Andy Lutomirski <luto@kernel.org>,  Daniel Micay <danielmicay@gmail.com>,  Djalal Harouni <tixxdz@gmail.com>,  "Dmitry V . Levin" <ldv@altlinux.org>,  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,  Ingo Molnar <mingo@kernel.org>,  "J . Bruce Fields" <bfields@fieldses.org>,  Jeff Layton <jlayton@poochiereds.net>,  Jonathan Corbet <corbet@lwn.net>,  Kees Cook <keescook@chromium.org>,  Oleg Nesterov <oleg@redhat.com>,  Solar Designer <solar@openwall.com>
References: <20200210150519.538333-1-gladkov.alexey@gmail.com>
	<20200210150519.538333-8-gladkov.alexey@gmail.com>
	<87v9odlxbr.fsf@x220.int.ebiederm.org>
	<20200212144921.sykucj4mekcziicz@comp-core-i7-2640m-0182e6>
	<87tv3vkg1a.fsf@x220.int.ebiederm.org>
	<CAHk-=wg52stFtUxMOxs3afkwDWmWn1JXC7RJ7dPsTrJbnxpZVg@mail.gmail.com>
	<87v9obipk9.fsf@x220.int.ebiederm.org>
	<CAHk-=wgwmu4jpmOqW0+Lz0dcem1Fub=ThLHvmLobf_WqCq7bwg@mail.gmail.com>
	<20200212200335.GO23230@ZenIV.linux.org.uk>
	<CAHk-=wi+1CPShMFvJNPfnrJ8DD8uVKUOQ5TQzQUNGLUkeoahkg@mail.gmail.com>
	<20200212203833.GQ23230@ZenIV.linux.org.uk>
Date: Thu, 13 Feb 2020 21:49:20 -0600
In-Reply-To: <20200212203833.GQ23230@ZenIV.linux.org.uk> (Al Viro's message of
	"Wed, 12 Feb 2020 20:38:33 +0000")
Message-ID: <87sgjdde0v.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j2S0Z-0006vA-4D;;;mid=<87sgjdde0v.fsf@x220.int.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18hwn2iY2MOovMvLUTHlMeKjuKGlG2T5jo=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa02.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.7 required=8.0 tests=ALL_TRUSTED,BAYES_20,
	DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_XMDrugObfuBody_00,XMSubLong
	autolearn=disabled version=3.4.2
X-Spam-Virus: No
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0832]
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 T_XMDrugObfuBody_00 obfuscated drug references
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Al Viro <viro@zeniv.linux.org.uk>
X-Spam-Relay-Country: 
X-Spam-Timing: total 338 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 3.2 (1.0%), b_tie_ro: 2.3 (0.7%), parse: 1.16
	(0.3%), extract_message_metadata: 12 (3.5%), get_uri_detail_list: 1.98
	(0.6%), tests_pri_-1000: 8 (2.3%), tests_pri_-950: 1.00 (0.3%),
	tests_pri_-900: 0.85 (0.3%), tests_pri_-90: 23 (6.9%), check_bayes: 22
	(6.5%), b_tokenize: 7 (2.0%), b_tok_get_all: 8 (2.3%), b_comp_prob:
	1.93 (0.6%), b_tok_touch_all: 3.1 (0.9%), b_finish: 0.67 (0.2%),
	tests_pri_0: 275 (81.5%), check_dkim_signature: 0.38 (0.1%),
	check_dkim_adsp: 2.7 (0.8%), poll_dns_idle: 0.65 (0.2%), tests_pri_10:
	2.8 (0.8%), tests_pri_500: 7 (2.1%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v8 07/11] proc: flush task dcache entries from all procfs instances
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)

Al Viro <viro@zeniv.linux.org.uk> writes:

> On Wed, Feb 12, 2020 at 12:35:04PM -0800, Linus Torvalds wrote:
>> On Wed, Feb 12, 2020 at 12:03 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>> >
>> > What's to prevent racing with fs shutdown while you are doing the second part?
>> 
>> I was thinking that only the proc_flush_task() code would do this.
>> 
>> And that holds a ref to the vfsmount through upid->ns.
>> 
>> So I wasn't suggesting doing this in general - just splitting up the
>> implementation of d_invalidate() so that proc_flush_task_mnt() could
>> delay the complex part to after having traversed the RCU-protected
>> list.
>> 
>> But hey - I missed this part of the problem originally, so maybe I'm
>> just missing something else this time. Wouldn't be the first time.
>
> Wait, I thought the whole point of that had been to allow multiple
> procfs instances for the same userns?  Confused...

Multiple procfs instances for the same pidns.  Exactly.

Which would let people have their own set of procfs mount
options without having to worry about stomping on someone else.

The fundamental problem with multiple procfs instances per pidns
is there isn't an obvous place to put a vfs mount.


...


Which means we need some way to keep the file system from going away
while anyone in the kernel is running proc_flush_task.

One was I can see to solve this that would give us cheap readers, is to
have a percpu count of the number of processes in proc_flush_task.
That would work something like mnt_count.

Then forbid proc_kill_sb from removing any super block from the list
or otherwise making progress until the proc_flush_task_count goes
to zero.


f we wanted cheap readers and an expensive writer
kind of flag that proc_kill_sb can

Thinking out loud perhaps we have add a list_head on task_struct
and a list_head in proc_inode.  That would let us find the inodes
and by extention the dentries we care about quickly.

Then in evict_inode we could remove the proc_inode from the list.


Eric

