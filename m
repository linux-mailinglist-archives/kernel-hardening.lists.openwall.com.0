Return-Path: <kernel-hardening-return-21275-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8AEB73994AC
	for <lists+kernel-hardening@lfdr.de>; Wed,  2 Jun 2021 22:38:03 +0200 (CEST)
Received: (qmail 1057 invoked by uid 550); 2 Jun 2021 20:37:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1037 invoked from network); 2 Jun 2021 20:37:55 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: legion@kernel.org,  LKML <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux Containers <containers@lists.linux-foundation.org>,  linux-mm@kvack.org,  Christian Brauner <christian.brauner@ubuntu.com>,  Jann Horn <jannh@google.com>,  Jens Axboe <axboe@kernel.dk>,  Kees Cook <keescook@chromium.org>,  Linus Torvalds <torvalds@linux-foundation.org>,  Oleg Nesterov <oleg@redhat.com>
References: <cover.1619094428.git.legion@kernel.org>
	<20210509181205.f0ce806919858efa0e0e0d20@linux-foundation.org>
Date: Wed, 02 Jun 2021 15:37:32 -0500
In-Reply-To: <20210509181205.f0ce806919858efa0e0e0d20@linux-foundation.org>
	(Andrew Morton's message of "Sun, 9 May 2021 18:12:05 -0700")
Message-ID: <87o8coq9yr.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1loXcR-00Efry-DT;;;mid=<87o8coq9yr.fsf@disp2133>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX181tofntvStz1+pRqA2mAhl7FTynzngIXM=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
	DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG autolearn=disabled
	version=3.4.2
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4962]
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 496 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 10 (2.1%), b_tie_ro: 9 (1.9%), parse: 1.14 (0.2%),
	 extract_message_metadata: 17 (3.4%), get_uri_detail_list: 1.16 (0.2%),
	 tests_pri_-1000: 8 (1.6%), tests_pri_-950: 1.65 (0.3%),
	tests_pri_-900: 1.41 (0.3%), tests_pri_-90: 161 (32.5%), check_bayes:
	145 (29.2%), b_tokenize: 9 (1.9%), b_tok_get_all: 6 (1.2%),
	b_comp_prob: 2.6 (0.5%), b_tok_touch_all: 120 (24.1%), b_finish: 4.6
	(0.9%), tests_pri_0: 278 (56.1%), check_dkim_signature: 0.89 (0.2%),
	check_dkim_adsp: 4.0 (0.8%), poll_dns_idle: 1.22 (0.2%), tests_pri_10:
	2.3 (0.5%), tests_pri_500: 10 (2.0%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v11 0/9] Count rlimits in each user namespace
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)

Andrew Morton <akpm@linux-foundation.org> writes:

> On Thu, 22 Apr 2021 14:27:07 +0200 legion@kernel.org wrote:
>
>> These patches are for binding the rlimit counters to a user in user namespace.
>
> It's at v11 and no there has been no acking or reviewing activity?  Or
> have you not been tracking these?

Most of the reviews were noticing things that needed to be changed.

For the ack/review by tags I am the one reviewing it and merging the
change so I guess I didn't give Alex any Acked-by or Reviewed-by
tags.

Regardless the changes are sitting in linux-next now and seem to be
doing fine.

Eric
