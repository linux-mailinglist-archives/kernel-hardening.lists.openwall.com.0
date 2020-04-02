Return-Path: <kernel-hardening-return-18381-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id BADBC19C1E5
	for <lists+kernel-hardening@lfdr.de>; Thu,  2 Apr 2020 15:15:19 +0200 (CEST)
Received: (qmail 27877 invoked by uid 550); 2 Apr 2020 13:14:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 27854 invoked from network); 2 Apr 2020 13:14:39 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jann Horn <jannh@google.com>,  Alan Stern <stern@rowland.harvard.edu>,  Andrea Parri <parri.andrea@gmail.com>,  Will Deacon <will@kernel.org>,  Peter Zijlstra <peterz@infradead.org>,  Boqun Feng <boqun.feng@gmail.com>,  Nicholas Piggin <npiggin@gmail.com>,  David Howells <dhowells@redhat.com>,  Jade Alglave <j.alglave@ucl.ac.uk>,  Luc Maranget <luc.maranget@inria.fr>,  "Paul E. McKenney" <paulmck@kernel.org>,  Akira Yokosawa <akiyks@gmail.com>,  Daniel Lustig <dlustig@nvidia.com>,  Adam Zabrocki <pi3@pi3.com.pl>,  kernel list <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Oleg Nesterov <oleg@redhat.com>,  Andy Lutomirski <luto@amacapital.net>,  Bernd Edlinger <bernd.edlinger@hotmail.de>,  Kees Cook <keescook@chromium.org>,  Andrew Morton <akpm@linux-foundation.org>,  stable <stable@vger.kernel.org>,  Marco Elver <elver@google.com>,  Dmitry Vyukov <dvyukov@google.com>,  kasan-dev <kasan-dev@googlegroups.com>
References: <20200324215049.GA3710@pi3.com.pl> <202003291528.730A329@keescook>
	<87zhbvlyq7.fsf_-_@x220.int.ebiederm.org>
	<CAG48ez3nYr7dj340Rk5-QbzhsFq0JTKPf2MvVJ1-oi1Zug1ftQ@mail.gmail.com>
	<CAHk-=wjz0LEi68oGJSQzZ--3JTFF+dX2yDaXDRKUpYxtBB=Zfw@mail.gmail.com>
	<CAHk-=wgM3qZeChs_1yFt8p8ye1pOaM_cX57BZ_0+qdEPcAiaCQ@mail.gmail.com>
	<CAG48ez1f82re_V=DzQuRHpy7wOWs1iixrah4GYYxngF1v-moZw@mail.gmail.com>
	<CAHk-=whks0iE1f=Ka0_vo2PYg774P7FA8Y30YrOdUBGRH-ch9A@mail.gmail.com>
Date: Thu, 02 Apr 2020 08:11:31 -0500
In-Reply-To: <CAHk-=whks0iE1f=Ka0_vo2PYg774P7FA8Y30YrOdUBGRH-ch9A@mail.gmail.com>
	(Linus Torvalds's message of "Wed, 1 Apr 2020 19:05:59 -0700")
Message-ID: <877dyym3r0.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jJzfj-00021V-6R;;;mid=<877dyym3r0.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/aAgD/0VF7hya1cN9dZdOTpz/w8uomdK0=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa01.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
	DCC_CHECK_NEGATIVE,NO_DNS_FOR_FROM,T_TM2_M_HEADER_IN_MSG
	autolearn=disabled version=3.4.2
X-Spam-Virus: No
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4987]
	*  0.0 NO_DNS_FOR_FROM DNS: Envelope sender has no MX or A DNS records
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 6259 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 4.6 (0.1%), b_tie_ro: 3.2 (0.1%), parse: 1.03
	(0.0%), extract_message_metadata: 11 (0.2%), get_uri_detail_list: 0.70
	(0.0%), tests_pri_-1000: 4.0 (0.1%), tests_pri_-950: 1.01 (0.0%),
	tests_pri_-900: 0.88 (0.0%), tests_pri_-90: 83 (1.3%), check_bayes: 82
	(1.3%), b_tokenize: 5 (0.1%), b_tok_get_all: 6 (0.1%), b_comp_prob:
	1.59 (0.0%), b_tok_touch_all: 66 (1.0%), b_finish: 0.79 (0.0%),
	tests_pri_0: 6143 (98.1%), check_dkim_signature: 0.51 (0.0%),
	check_dkim_adsp: 5997 (95.8%), poll_dns_idle: 5993 (95.7%),
	tests_pri_10: 1.70 (0.0%), tests_pri_500: 6 (0.1%), rewrite_mail: 0.00
	(0.0%)
Subject: Re: [PATCH] signal: Extend exec_id to 64bits
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)

Linus Torvalds <torvalds@linux-foundation.org> writes:

> tasklist_lock is aboue the hottest lock there is in all of the kernel.

Do you know code paths you see tasklist_lock being hot?

I am looking at some of the exec/signal/ptrace code paths because they
get subtle corner case wrong like a threaded exec deadlocking when
straced.

If the performance problems are in the same neighbourhood I might be
able to fix those problems while I am in the code.

Eric



