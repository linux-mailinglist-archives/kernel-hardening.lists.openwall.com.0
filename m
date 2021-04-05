Return-Path: <kernel-hardening-return-21146-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 05A523545CA
	for <lists+kernel-hardening@lfdr.de>; Mon,  5 Apr 2021 19:03:28 +0200 (CEST)
Received: (qmail 10045 invoked by uid 550); 5 Apr 2021 17:03:23 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 10020 invoked from network); 5 Apr 2021 17:03:22 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux Containers <containers@lists.linux-foundation.org>,  linux-mm@kvack.org,  Alexey Gladkov <legion@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  Christian Brauner <christian.brauner@ubuntu.com>,  Jann Horn <jannh@google.com>,  Jens Axboe <axboe@kernel.dk>,  Kees Cook <keescook@chromium.org>,  Linus Torvalds <torvalds@linux-foundation.org>,  Oleg Nesterov <oleg@redhat.com>
References: <cover.1616533074.git.gladkov.alexey@gmail.com>
Date: Mon, 05 Apr 2021 12:03:05 -0500
In-Reply-To: <cover.1616533074.git.gladkov.alexey@gmail.com> (Alexey Gladkov's
	message of "Tue, 23 Mar 2021 21:59:09 +0100")
Message-ID: <m17dlgll4m.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lTSd2-0000VS-UE;;;mid=<m17dlgll4m.fsf@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18auhi4AyUcfdr4Byj9mZr34hCEOOzN8aw=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa01.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
	DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG autolearn=disabled
	version=3.4.2
X-Spam-Virus: No
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alexey Gladkov <gladkov.alexey@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 705 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 3.5 (0.5%), b_tie_ro: 2.4 (0.3%), parse: 1.17
	(0.2%), extract_message_metadata: 15 (2.1%), get_uri_detail_list: 3.9
	(0.5%), tests_pri_-1000: 14 (1.9%), tests_pri_-950: 1.55 (0.2%),
	tests_pri_-900: 1.19 (0.2%), tests_pri_-90: 258 (36.6%), check_bayes:
	256 (36.2%), b_tokenize: 15 (2.1%), b_tok_get_all: 11 (1.6%),
	b_comp_prob: 3.5 (0.5%), b_tok_touch_all: 223 (31.6%), b_finish: 0.72
	(0.1%), tests_pri_0: 400 (56.8%), check_dkim_signature: 0.48 (0.1%),
	check_dkim_adsp: 2.3 (0.3%), poll_dns_idle: 0.78 (0.1%), tests_pri_10:
	1.67 (0.2%), tests_pri_500: 5 (0.8%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v9 0/8] Count rlimits in each user namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)

Alexey Gladkov <gladkov.alexey@gmail.com> writes:

> Preface
> -------
> These patches are for binding the rlimit counters to a user in user namespace.
> This patch set can be applied on top of:
>
> git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git v5.12-rc4
>
> Problem
> -------
> The RLIMIT_NPROC, RLIMIT_MEMLOCK, RLIMIT_SIGPENDING, RLIMIT_MSGQUEUE rlimits
> implementation places the counters in user_struct [1]. These limits are global
> between processes and persists for the lifetime of the process, even if
> processes are in different user namespaces.
>
> To illustrate the impact of rlimits, let's say there is a program that does not
> fork. Some service-A wants to run this program as user X in multiple containers.
> Since the program never fork the service wants to set RLIMIT_NPROC=1.
>
> service-A
>  \- program (uid=1000, container1, rlimit_nproc=1)
>  \- program (uid=1000, container2, rlimit_nproc=1)
>
> The service-A sets RLIMIT_NPROC=1 and runs the program in container1. When the
> service-A tries to run a program with RLIMIT_NPROC=1 in container2 it fails
> since user X already has one running process.
>
> The problem is not that the limit from container1 affects container2. The
> problem is that limit is verified against the global counter that reflects
> the number of processes in all containers.
>
> This problem can be worked around by using different users for each container
> but in this case we face a different problem of uid mapping when transferring
> files from one container to another.
>
> Eric W. Biederman mentioned this issue [2][3].
>
> Introduced changes
> ------------------
> To address the problem, we bind rlimit counters to user namespace. Each counter
> reflects the number of processes in a given uid in a given user namespace. The
> result is a tree of rlimit counters with the biggest value at the root (aka
> init_user_ns). The limit is considered exceeded if it's exceeded up in the tree.
>
> [1]: https://lore.kernel.org/containers/87imd2incs.fsf@x220.int.ebiederm.org/
> [2]: https://lists.linuxfoundation.org/pipermail/containers/2020-August/042096.html
> [3]: https://lists.linuxfoundation.org/pipermail/containers/2020-October/042524.html
>
> Changelog
> ---------
> v9:
> * Used a negative value to check that the ucounts->count is close to overflow.
> * Rebased onto v5.12-rc4.
>
> v8:
> * Used atomic_t for ucounts reference counting. Also added counter overflow
>   check (thanks to Linus Torvalds for the idea).
> * Fixed other issues found by lkp-tests project in the patch that Reimplements
>   RLIMIT_MEMLOCK on top of ucounts.
>
> v7:
> * Fixed issues found by lkp-tests project in the patch that Reimplements
>   RLIMIT_MEMLOCK on top of ucounts.
>
> v6:
> * Fixed issues found by lkp-tests project.
> * Rebased onto v5.11.
>
> v5:
> * Split the first commit into two commits: change ucounts.count type to atomic_long_t
>   and add ucounts to cred. These commits were merged by mistake during the rebase.
> * The __get_ucounts() renamed to alloc_ucounts().
> * The cred.ucounts update has been moved from commit_creds() as it did not allow
>   to handle errors.
> * Added error handling of set_cred_ucounts().
>
> v4:
> * Reverted the type change of ucounts.count to refcount_t.
> * Fixed typo in the kernel/cred.c
>
> v3:
> * Added get_ucounts() function to increase the reference count. The existing
>   get_counts() function renamed to __get_ucounts().
> * The type of ucounts.count changed from atomic_t to refcount_t.
> * Dropped 'const' from set_cred_ucounts() arguments.
> * Fixed a bug with freeing the cred structure after calling cred_alloc_blank().
> * Commit messages have been updated.
> * Added selftest.
>
> v2:
> * RLIMIT_MEMLOCK, RLIMIT_SIGPENDING and RLIMIT_MSGQUEUE are migrated to ucounts.
> * Added ucounts for pair uid and user namespace into cred.
> * Added the ability to increase ucount by more than 1.
>
> v1:
> * After discussion with Eric W. Biederman, I increased the size of ucounts to
>   atomic_long_t.
> * Added ucount_max to avoid the fork bomb.
>
> --
>
> Alexey Gladkov (8):
>   Increase size of ucounts to atomic_long_t
>   Add a reference to ucounts for each cred
>   Use atomic_t for ucounts reference counting
>   Reimplement RLIMIT_NPROC on top of ucounts
>   Reimplement RLIMIT_MSGQUEUE on top of ucounts
>   Reimplement RLIMIT_SIGPENDING on top of ucounts
>   Reimplement RLIMIT_MEMLOCK on top of ucounts
>   kselftests: Add test to check for rlimit changes in different user namespaces
>

Overall this looks good, and it is a very good sign that the automatic
testing bots have not found anything.  I found a few little nits.
But thing are looking very good.

Eric

