Return-Path: <kernel-hardening-return-20811-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 22895322560
	for <lists+kernel-hardening@lfdr.de>; Tue, 23 Feb 2021 06:31:10 +0100 (CET)
Received: (qmail 14026 invoked by uid 550); 23 Feb 2021 05:31:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 14004 invoked from network); 23 Feb 2021 05:31:02 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexey Gladkov <gladkov.alexey@gmail.com>,  LKML <linux-kernel@vger.kernel.org>,  io-uring <io-uring@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux Containers <containers@lists.linux-foundation.org>,  Linux-MM <linux-mm@kvack.org>,  Alexey Gladkov <legion@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  Christian Brauner <christian.brauner@ubuntu.com>,  Jann Horn <jannh@google.com>,  Jens Axboe <axboe@kernel.dk>,  Kees Cook <keescook@chromium.org>,  Oleg Nesterov <oleg@redhat.com>
References: <cover.1613392826.git.gladkov.alexey@gmail.com>
	<CAHk-=wjsmAXyYZs+QQFQtY=w-pOOSWoi-ukvoBVVjBnb+v3q7A@mail.gmail.com>
Date: Mon, 22 Feb 2021 23:30:26 -0600
In-Reply-To: <CAHk-=wjsmAXyYZs+QQFQtY=w-pOOSWoi-ukvoBVVjBnb+v3q7A@mail.gmail.com>
	(Linus Torvalds's message of "Sun, 21 Feb 2021 14:20:00 -0800")
Message-ID: <m1im6jl5al.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lEQHU-0002ip-7f;;;mid=<m1im6jl5al.fsf@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/DYsNs7fzMb4RYxpfKS0P+rI9c6VJVdTw=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa02.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
	DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG autolearn=disabled
	version=3.4.2
X-Spam-Virus: No
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4991]
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 363 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 4.7 (1.3%), b_tie_ro: 3.3 (0.9%), parse: 1.03
	(0.3%), extract_message_metadata: 11 (3.0%), get_uri_detail_list: 1.26
	(0.3%), tests_pri_-1000: 4.5 (1.3%), tests_pri_-950: 1.05 (0.3%),
	tests_pri_-900: 0.91 (0.3%), tests_pri_-90: 124 (34.3%), check_bayes:
	121 (33.4%), b_tokenize: 4.6 (1.3%), b_tok_get_all: 7 (1.8%),
	b_comp_prob: 1.65 (0.5%), b_tok_touch_all: 105 (29.0%), b_finish: 0.78
	(0.2%), tests_pri_0: 203 (55.9%), check_dkim_signature: 0.36 (0.1%),
	check_dkim_adsp: 8 (2.1%), poll_dns_idle: 0.21 (0.1%), tests_pri_10:
	2.6 (0.7%), tests_pri_500: 7 (2.0%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v6 0/7] Count rlimits in each user namespace
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Mon, Feb 15, 2021 at 4:42 AM Alexey Gladkov <gladkov.alexey@gmail.com> wrote:
>>
>> These patches are for binding the rlimit counters to a user in user namespace.
>
> So this is now version 6, but I think the kernel test robot keeps
> complaining about them causing KASAN issues.
>
> The complaints seem to change, so I'm hoping they get fixed, but it
> does seem like every version there's a new one. Hmm?

I have been keeping an eye on this as well, and yes the issues are
getting fixed.

My current plan is to aim at getting v7 rebased onto -rc1 into a branch.
Review the changes very closely.  Get some performance testing and some
other testing against it.  Then to get this code into linux-next.

If everything goes smoothly I will send you a pull request next merge
window.  I have no intention of shipping this (or sending you a pull
request) before it is ready.

Eric
