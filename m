Return-Path: <kernel-hardening-return-17820-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2458615D938
	for <lists+kernel-hardening@lfdr.de>; Fri, 14 Feb 2020 15:17:34 +0100 (CET)
Received: (qmail 23732 invoked by uid 550); 14 Feb 2020 14:17:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23688 invoked from network); 14 Feb 2020 14:17:27 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,  LKML <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux API <linux-api@vger.kernel.org>,  Linux FS Devel <linux-fsdevel@vger.kernel.org>,  Linux Security Module <linux-security-module@vger.kernel.org>,  Akinobu Mita <akinobu.mita@gmail.com>,  Alexey Dobriyan <adobriyan@gmail.com>,  Andrew Morton <akpm@linux-foundation.org>,  Andy Lutomirski <luto@kernel.org>,  Daniel Micay <danielmicay@gmail.com>,  Djalal Harouni <tixxdz@gmail.com>,  "Dmitry V . Levin" <ldv@altlinux.org>,  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,  Ingo Molnar <mingo@kernel.org>,  "J . Bruce Fields" <bfields@fieldses.org>,  Jeff Layton <jlayton@poochiereds.net>,  Jonathan Corbet <corbet@lwn.net>,  Kees Cook <keescook@chromium.org>,  Oleg Nesterov <oleg@redhat.com>,  Solar Designer <solar@openwall.com>
References: <20200212200335.GO23230@ZenIV.linux.org.uk>
	<CAHk-=wi+1CPShMFvJNPfnrJ8DD8uVKUOQ5TQzQUNGLUkeoahkg@mail.gmail.com>
	<20200212203833.GQ23230@ZenIV.linux.org.uk>
	<20200212204124.GR23230@ZenIV.linux.org.uk>
	<CAHk-=wi5FOGV_3tALK3n6E2fK3Oa_yCYkYQtCSaXLSEm2DUCKg@mail.gmail.com>
	<87lfp7h422.fsf@x220.int.ebiederm.org>
	<CAHk-=wgmn9Qds0VznyphouSZW6e42GWDT5H1dpZg8pyGDGN+=w@mail.gmail.com>
	<87pnejf6fz.fsf@x220.int.ebiederm.org>
	<20200213055527.GS23230@ZenIV.linux.org.uk>
	<CAHk-=wgQnNHYxV7-SyRP=g9vTHyNAK9g1juLLB=eho4=DHVZEQ@mail.gmail.com>
	<20200213222350.GU23230@ZenIV.linux.org.uk>
	<CAHk-=wjePLiQqUfQGCrNb0wp+EtgRddQbcK-pHH=6rxbdYNNOA@mail.gmail.com>
Date: Fri, 14 Feb 2020 08:15:16 -0600
In-Reply-To: <CAHk-=wjePLiQqUfQGCrNb0wp+EtgRddQbcK-pHH=6rxbdYNNOA@mail.gmail.com>
	(Linus Torvalds's message of "Thu, 13 Feb 2020 14:47:48 -0800")
Message-ID: <87wo8pb6h7.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1j2bmJ-0004QP-SP;;;mid=<87wo8pb6h7.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18c96o3FroerQ43pTuS8ANjCZtZB2o8mLY=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa03.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
	DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMSubLong autolearn=disabled
	version=3.4.2
X-Spam-Virus: No
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4663]
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 399 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 2.3 (0.6%), b_tie_ro: 1.64 (0.4%), parse: 0.67
	(0.2%), extract_message_metadata: 12 (3.0%), get_uri_detail_list: 1.12
	(0.3%), tests_pri_-1000: 13 (3.3%), tests_pri_-950: 1.09 (0.3%),
	tests_pri_-900: 0.85 (0.2%), tests_pri_-90: 26 (6.5%), check_bayes: 25
	(6.2%), b_tokenize: 7 (1.8%), b_tok_get_all: 10 (2.6%), b_comp_prob:
	1.97 (0.5%), b_tok_touch_all: 3.2 (0.8%), b_finish: 0.64 (0.2%),
	tests_pri_0: 244 (61.1%), check_dkim_signature: 0.40 (0.1%),
	check_dkim_adsp: 2.6 (0.7%), poll_dns_idle: 78 (19.6%), tests_pri_10:
	2.6 (0.6%), tests_pri_500: 94 (23.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v8 07/11] proc: flush task dcache entries from all procfs instances
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)

Linus Torvalds <torvalds@linux-foundation.org> writes:

> I guess a lot of readdir users end up doing a stat on it immediately
> afterwards. I think right now we do it to get the inode number, and
> maybe that is a basic requirement (even if I don't think it's really
> stable - an inode could be evicted and then the ino changes, no?)

All I know is proc_fill_cache seemed like a good idea at the time.
I may have been to clever.

While I think proc_fill_cache probably exacerbates the issue
it isn't the reason we have the flushing logic.  The proc
flushing logic was introduced in around 2.5.9 much earlier
than the other proc things.

commit 0030633355db2bba32d97655df73b04215018ab9
Author: Alexander Viro <viro@math.psu.edu>
Date:   Sun Apr 21 23:03:37 2002 -0700

    [PATCH] (3/5) sane procfs/dcache interaction
    
     - sane dentry retention.  Namely, we don't kill /proc/<pid> dentries at the
       first opportunity (as the current tree does).  Instead we do the following:
            * ->d_delete() kills it only if process is already dead.
            * all ->lookup() in proc/base.c end with checking if process is still
              alive and unhash if it isn't.
            * proc_pid_lookup() (lookup for /proc/<pid>) caches reference to dentry
              in task_struct.  It's _not_ counted in ->d_count.
            * ->d_iput() resets said reference to NULL.
            * release_task() (burying a zombie) checks if there is a cached
              reference and if there is - shrinks the subtree.
            * tasklist_lock is used for exclusion.
       That way we are guaranteed that after release_task() all dentries in
       /proc/<pid> will go away as soon as possible; OTOH, before release_task()
       we have normal retention policy - they go away under memory pressure with
       the same rules as for dentries on any other fs.

Tracking down when this logic was introduced I also see that this code
has broken again and again any time proc changes (like now).  So it is
definitely subtle and fragile.

Eric
