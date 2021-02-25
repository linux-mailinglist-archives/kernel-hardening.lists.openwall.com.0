Return-Path: <kernel-hardening-return-20821-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 24D9C324409
	for <lists+kernel-hardening@lfdr.de>; Wed, 24 Feb 2021 19:51:01 +0100 (CET)
Received: (qmail 18282 invoked by uid 550); 24 Feb 2021 18:50:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 18258 invoked from network); 24 Feb 2021 18:50:54 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: kernel test robot <oliver.sang@intel.com>,  0day robot <lkp@intel.com>,  LKML <linux-kernel@vger.kernel.org>,  lkp@lists.01.org,  ying.huang@intel.com,  feng.tang@intel.com,  zhengjun.xing@intel.com,  io-uring@vger.kernel.org,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux Containers <containers@lists.linux-foundation.org>,  linux-mm@kvack.org,  Andrew Morton <akpm@linux-foundation.org>,  Christian Brauner <christian.brauner@ubuntu.com>,  Jann Horn <jannh@google.com>,  Jens Axboe <axboe@kernel.dk>,  Kees Cook <keescook@chromium.org>,  Linus Torvalds <torvalds@linux-foundation.org>,  Oleg Nesterov <oleg@redhat.com>
References: <20210224051845.GB6114@xsang-OptiPlex-9020>
	<m1czwpl83q.fsf@fess.ebiederm.org>
	<20210224183828.j6uut6sholeo2fzh@example.org>
Date: Wed, 24 Feb 2021 12:50:21 -0600
In-Reply-To: <20210224183828.j6uut6sholeo2fzh@example.org> (Alexey Gladkov's
	message of "Wed, 24 Feb 2021 19:38:28 +0100")
Message-ID: <m17dmxl2qa.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lEzF8-0003fV-Ej;;;mid=<m17dmxl2qa.fsf@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19uDlW3DrHDIu/oovVJEMOIV0VkW2WC9Yw=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa02.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
	DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMSubLong autolearn=disabled
	version=3.4.2
X-Spam-Virus: No
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4999]
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alexey Gladkov <gladkov.alexey@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 363 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 3.4 (0.9%), b_tie_ro: 2.3 (0.6%), parse: 0.65
	(0.2%), extract_message_metadata: 9 (2.4%), get_uri_detail_list: 1.19
	(0.3%), tests_pri_-1000: 11 (3.1%), tests_pri_-950: 0.96 (0.3%),
	tests_pri_-900: 0.86 (0.2%), tests_pri_-90: 84 (23.2%), check_bayes:
	83 (22.8%), b_tokenize: 6 (1.6%), b_tok_get_all: 8 (2.1%),
	b_comp_prob: 1.63 (0.4%), b_tok_touch_all: 65 (17.8%), b_finish: 0.74
	(0.2%), tests_pri_0: 243 (66.9%), check_dkim_signature: 0.38 (0.1%),
	check_dkim_adsp: 2.1 (0.6%), poll_dns_idle: 0.56 (0.2%), tests_pri_10:
	1.76 (0.5%), tests_pri_500: 6 (1.6%), rewrite_mail: 0.00 (0.0%)
Subject: Re: d28296d248:  stress-ng.sigsegv.ops_per_sec -82.7% regression
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)

Alexey Gladkov <gladkov.alexey@gmail.com> writes:

> On Wed, Feb 24, 2021 at 10:54:17AM -0600, Eric W. Biederman wrote:
>> kernel test robot <oliver.sang@intel.com> writes:
>> 
>> > Greeting,
>> >
>> > FYI, we noticed a -82.7% regression of stress-ng.sigsegv.ops_per_sec due to commit:
>> >
>> >
>> > commit: d28296d2484fa11e94dff65e93eb25802a443d47 ("[PATCH v7 5/7] Reimplement RLIMIT_SIGPENDING on top of ucounts")
>> > url: https://github.com/0day-ci/linux/commits/Alexey-Gladkov/Count-rlimits-in-each-user-namespace/20210222-175836
>> > base: https://git.kernel.org/cgit/linux/kernel/git/shuah/linux-kselftest.git next
>> >
>> > in testcase: stress-ng
>> > on test machine: 48 threads Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz with 112G memory
>> > with following parameters:
>> >
>> > 	nr_threads: 100%
>> > 	disk: 1HDD
>> > 	testtime: 60s
>> > 	class: interrupt
>> > 	test: sigsegv
>> > 	cpufreq_governor: performance
>> > 	ucode: 0x42e
>> >
>> >
>> > In addition to that, the commit also has significant impact on the
>> > following tests:
>> 
>> Thank you.  Now we have a sense of where we need to test the performance
>> of these changes carefully.
>
> One of the reasons for this is that I rolled back the patch that changed
> the ucounts.count type to atomic_t. Now get_ucounts() is forced to use a
> spin_lock to increase the reference count.

Which given the hickups with getting a working version seems justified.

Now we can add incremental patches on top to improve the performance.


Eric

