Return-Path: <kernel-hardening-return-21350-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id DA3913F56A7
	for <lists+kernel-hardening@lfdr.de>; Tue, 24 Aug 2021 05:25:41 +0200 (CEST)
Received: (qmail 23732 invoked by uid 550); 24 Aug 2021 03:25:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 23709 invoked from network); 24 Aug 2021 03:25:34 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Ma\, XinjianX" <xinjianx.ma@intel.com>
Cc: Alexey Gladkov <legion@kernel.org>,  "linux-kselftest\@vger.kernel.org" <linux-kselftest@vger.kernel.org>,  lkp <lkp@intel.com>,  "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,  "axboe\@kernel.dk" <axboe@kernel.dk>,  "christian.brauner\@ubuntu.com" <christian.brauner@ubuntu.com>,  "containers\@lists.linux-foundation.org" <containers@lists.linux-foundation.org>,  "jannh\@google.com" <jannh@google.com>,  "keescook\@chromium.org" <keescook@chromium.org>,  "kernel-hardening\@lists.openwall.com" <kernel-hardening@lists.openwall.com>,  "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,  "linux-mm\@kvack.org" <linux-mm@kvack.org>,  "oleg\@redhat.com" <oleg@redhat.com>,  "torvalds\@linux-foundation.org" <torvalds@linux-foundation.org>
In-Reply-To: <06bb27f1d79243febf9ddc4633c4e084@intel.com> (XinjianX Ma's
	message of "Tue, 24 Aug 2021 01:19:52 +0000")
References: <d650b7794e264d5f8aa107644cc9784f@intel.com>
	<87a6lgysxp.fsf@disp2133>
	<20210818131117.x7omzb2wkjq7le3s@example.org>
	<87o89ttqql.fsf@disp2133>
	<20210819172618.qwrrw4m7wt33wfmz@example.org>
	<87eeajswfc.fsf_-_@disp2133>
	<06bb27f1d79243febf9ddc4633c4e084@intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date: Mon, 23 Aug 2021 22:24:17 -0500
Message-ID: <87lf4rplsu.fsf@disp2133>
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mIN3h-008tKu-MV;;;mid=<87lf4rplsu.fsf@disp2133>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1++AiEZW5KIHsfe2U3AKqShPsf05OHNwZw=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa04.xmission.com
X-Spam-Level: *
X-Spam-Status: No, score=1.5 required=8.0 tests=ALL_TRUSTED,BAYES_50,
	DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMSubLong,XM_Body_Dirty_Words
	autolearn=disabled version=3.4.2
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4999]
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;"Ma\, XinjianX" <xinjianx.ma@intel.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 2130 ms - load_scoreonly_sql: 0.06 (0.0%),
	signal_user_changed: 13 (0.6%), b_tie_ro: 11 (0.5%), parse: 1.43
	(0.1%), extract_message_metadata: 22 (1.0%), get_uri_detail_list: 1.64
	(0.1%), tests_pri_-1000: 23 (1.1%), tests_pri_-950: 1.61 (0.1%),
	tests_pri_-900: 1.32 (0.1%), tests_pri_-90: 386 (18.1%), check_bayes:
	377 (17.7%), b_tokenize: 9 (0.4%), b_tok_get_all: 7 (0.3%),
	b_comp_prob: 2.4 (0.1%), b_tok_touch_all: 355 (16.7%), b_finish: 1.17
	(0.1%), tests_pri_0: 221 (10.4%), check_dkim_signature: 0.65 (0.0%),
	check_dkim_adsp: 4.7 (0.2%), poll_dns_idle: 1430 (67.2%),
	tests_pri_10: 4.4 (0.2%), tests_pri_500: 1451 (68.1%), rewrite_mail:
	0.00 (0.0%)
Subject: Re: [PATCH] ucounts: Fix regression preventing increasing of rlimits in init_user_ns
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)

"Ma, XinjianX" <xinjianx.ma@intel.com> writes:

>> -----Original Message-----
>> From: Eric W. Biederman <ebiederm@xmission.com>
>> ...
>> Reported-by: kernel test robot lkp@intel.com
> Sorry, but <> around email address is needed 
> Reported-by: kernel test robot <lkp@intel.com>

The change is already tested and pushed out so I really don't want to
mess with it.  Especially as I am aiming to send it to Linus on
Wednesday after it has had a chance to pass through linux-next and
whatever automated tests are there.

What does copying and pasting the Reported-by: tag as included in
your original report cause to break?

At this point I suspect that the danger of fat fingering something
far outweighs whatever benefits might be gained by surrounding the
email address with <> marks.

Eric
