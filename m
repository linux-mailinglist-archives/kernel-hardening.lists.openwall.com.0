Return-Path: <kernel-hardening-return-18393-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9663F19C78F
	for <lists+kernel-hardening@lfdr.de>; Thu,  2 Apr 2020 19:03:48 +0200 (CEST)
Received: (qmail 14090 invoked by uid 550); 2 Apr 2020 17:03:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 14049 invoked from network); 2 Apr 2020 17:03:34 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux API <linux-api@vger.kernel.org>,  Linux FS Devel <linux-fsdevel@vger.kernel.org>,  Linux Security Module <linux-security-module@vger.kernel.org>,  Akinobu Mita <akinobu.mita@gmail.com>,  Alexander Viro <viro@zeniv.linux.org.uk>,  Alexey Dobriyan <adobriyan@gmail.com>,  Alexey Gladkov <legion@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  Andy Lutomirski <luto@kernel.org>,  Daniel Micay <danielmicay@gmail.com>,  Djalal Harouni <tixxdz@gmail.com>,  "Dmitry V . Levin" <ldv@altlinux.org>,  Greg Kroah-Hartman <gregkh@linuxfoundation.org>,  Ingo Molnar <mingo@kernel.org>,  "J . Bruce Fields" <bfields@fieldses.org>,  Jeff Layton <jlayton@poochiereds.net>,  Jonathan Corbet <corbet@lwn.net>,  Kees Cook <keescook@chromium.org>,  Linus Torvalds <torvalds@linux-foundation.org>,  Oleg Nesterov <oleg@redhat.com>
References: <20200327172331.418878-1-gladkov.alexey@gmail.com>
Date: Thu, 02 Apr 2020 12:00:37 -0500
In-Reply-To: <20200327172331.418878-1-gladkov.alexey@gmail.com> (Alexey
	Gladkov's message of "Fri, 27 Mar 2020 18:23:22 +0100")
Message-ID: <87y2rdj00a.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1jK3FR-0006aV-1o;;;mid=<87y2rdj00a.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18hSAi2LI9PMt3LObPzV1UKL1s8s/+J7FI=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa07.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=8.0 tests=ALL_TRUSTED,BAYES_20,
	DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMSubLong autolearn=disabled
	version=3.4.2
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0857]
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alexey Gladkov <gladkov.alexey@gmail.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 316 ms - load_scoreonly_sql: 0.05 (0.0%),
	signal_user_changed: 12 (3.7%), b_tie_ro: 10 (3.3%), parse: 1.22
	(0.4%), extract_message_metadata: 3.2 (1.0%), get_uri_detail_list:
	0.56 (0.2%), tests_pri_-1000: 8 (2.6%), tests_pri_-950: 1.92 (0.6%),
	tests_pri_-900: 1.60 (0.5%), tests_pri_-90: 93 (29.6%), check_bayes:
	91 (28.8%), b_tokenize: 11 (3.4%), b_tok_get_all: 6 (1.9%),
	b_comp_prob: 2.6 (0.8%), b_tok_touch_all: 68 (21.6%), b_finish: 1.05
	(0.3%), tests_pri_0: 171 (54.1%), check_dkim_signature: 0.65 (0.2%),
	check_dkim_adsp: 2.5 (0.8%), poll_dns_idle: 0.32 (0.1%), tests_pri_10:
	2.3 (0.7%), tests_pri_500: 9 (2.7%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH v10 0/9] proc: modernize proc to support multiple private instances
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)


Overall this patchset looks good.

I have found a couple of nits.  The biggest is the potential ABI change.
I would be surprised if someone is using the new mount ABI so changing
that may not be a regression.  But it is worth a close look.

One way or another I will ensure we get this in linux-next after the
merge window closes.

Eric
