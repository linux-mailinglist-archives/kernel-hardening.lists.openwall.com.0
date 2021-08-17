Return-Path: <kernel-hardening-return-21343-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id B21843EEF67
	for <lists+kernel-hardening@lfdr.de>; Tue, 17 Aug 2021 17:48:28 +0200 (CEST)
Received: (qmail 1611 invoked by uid 550); 17 Aug 2021 15:48:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 1591 invoked from network); 17 Aug 2021 15:48:21 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Ma\, XinjianX" <xinjianx.ma@intel.com>
Cc: "legion\@kernel.org" <legion@kernel.org>,  "linux-kselftest\@vger.kernel.org" <linux-kselftest@vger.kernel.org>,  lkp <lkp@intel.com>,  "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,  "axboe\@kernel.dk" <axboe@kernel.dk>,  "christian.brauner\@ubuntu.com" <christian.brauner@ubuntu.com>,  "containers\@lists.linux-foundation.org" <containers@lists.linux-foundation.org>,  "jannh\@google.com" <jannh@google.com>,  "keescook\@chromium.org" <keescook@chromium.org>,  "kernel-hardening\@lists.openwall.com" <kernel-hardening@lists.openwall.com>,  "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,  "linux-mm\@kvack.org" <linux-mm@kvack.org>,  "oleg\@redhat.com" <oleg@redhat.com>,  "torvalds\@linux-foundation.org" <torvalds@linux-foundation.org>
References: <d650b7794e264d5f8aa107644cc9784f@intel.com>
Date: Tue, 17 Aug 2021 10:47:14 -0500
In-Reply-To: <d650b7794e264d5f8aa107644cc9784f@intel.com> (XinjianX Ma's
	message of "Tue, 17 Aug 2021 04:03:50 +0000")
Message-ID: <87a6lgysxp.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mG1Jq-008gTq-AD;;;mid=<87a6lgysxp.fsf@disp2133>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+YR/Sxbe0UH84qAcIuO7Yi3l0O0ew6ZBk=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
	DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,T_TooManySym_01,XMSubLong
	autolearn=disabled version=3.4.2
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4993]
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Ma\, XinjianX" <xinjianx.ma@intel.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1933 ms - load_scoreonly_sql: 0.04 (0.0%),
	signal_user_changed: 10 (0.5%), b_tie_ro: 9 (0.5%), parse: 0.95 (0.0%),
	 extract_message_metadata: 12 (0.6%), get_uri_detail_list: 1.36 (0.1%),
	 tests_pri_-1000: 6 (0.3%), tests_pri_-950: 1.25 (0.1%),
	tests_pri_-900: 1.02 (0.1%), tests_pri_-90: 78 (4.0%), check_bayes: 76
	(3.9%), b_tokenize: 8 (0.4%), b_tok_get_all: 8 (0.4%), b_comp_prob:
	4.3 (0.2%), b_tok_touch_all: 51 (2.6%), b_finish: 1.01 (0.1%),
	tests_pri_0: 448 (23.2%), check_dkim_signature: 0.57 (0.0%),
	check_dkim_adsp: 3.6 (0.2%), poll_dns_idle: 1361 (70.4%),
	tests_pri_10: 2.0 (0.1%), tests_pri_500: 1371 (70.9%), rewrite_mail:
	0.00 (0.0%)
Subject: Re: [PATCH v11 5/9] Reimplement RLIMIT_MSGQUEUE on top of ucounts
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)

"Ma, XinjianX" <xinjianx.ma@intel.com> writes:

> Hi Alexey,
>
> When lkp team run kernel selftests, we found after these series of patches, testcase mqueue: mq_perf_tests
> in kselftest failed with following message.

Which kernel was this run against?

Where can the mq_perf_tests that you ran and had problems with be found?

During your run were you using user namespaces as part of your test
environment?

The error message too many files corresponds to the error code EMFILES
which is the error code that is returned when the rlimit is reached.

One possibility is that your test environment was run in a user
namespace and so you wound up limited by rlimit of the user who created
the user namespace at the point of user namespace creation. 

At this point if you can give us enough information to look into this
and attempt to reproduce it that would be appreciated.

> If you confirm and fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot lkp@intel.com
>
> ```
> # selftests: mqueue: mq_perf_tests
> #
> # Initial system state:
> #       Using queue path:                       /mq_perf_tests
> #       RLIMIT_MSGQUEUE(soft):                  819200
> #       RLIMIT_MSGQUEUE(hard):                  819200
> #       Maximum Message Size:                   8192
> #       Maximum Queue Size:                     10
> #       Nice value:                             0
> #
> # Adjusted system state for testing:
> #       RLIMIT_MSGQUEUE(soft):                  (unlimited)
> #       RLIMIT_MSGQUEUE(hard):                  (unlimited)
> #       Maximum Message Size:                   16777216
> #       Maximum Queue Size:                     65530
> #       Nice value:                             -20
> #       Continuous mode:                        (disabled)
> #       CPUs to pin:                            3
> # ./mq_perf_tests: mq_open() at 296: Too many open files
> not ok 2 selftests: mqueue: mq_perf_tests # exit=1
> ```    
>
> Test env:
> rootfs: debian-10
> gcc version: 9
>
> ------
> Thanks 
> Ma Xinjian

Eric
