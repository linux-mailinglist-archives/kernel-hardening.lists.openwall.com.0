Return-Path: <kernel-hardening-return-21225-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 1DD02370033
	for <lists+kernel-hardening@lfdr.de>; Fri, 30 Apr 2021 20:10:25 +0200 (CEST)
Received: (qmail 25755 invoked by uid 550); 30 Apr 2021 18:10:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25674 invoked from network); 30 Apr 2021 18:10:16 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: kbuild@lists.01.org,  legion@kernel.org,  LKML <linux-kernel@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux Containers <containers@lists.linux-foundation.org>,  linux-mm@kvack.org,  lkp@intel.com,  kbuild-all@lists.01.org,  Andrew Morton <akpm@linux-foundation.org>,  Christian Brauner <christian.brauner@ubuntu.com>,  Jann Horn <jannh@google.com>
References: <202104272256.9Y5ZQxrO-lkp@intel.com>
Date: Fri, 30 Apr 2021 13:09:55 -0500
In-Reply-To: <202104272256.9Y5ZQxrO-lkp@intel.com> (Dan Carpenter's message of
	"Thu, 29 Apr 2021 17:04:23 +0300")
Message-ID: <m1tunny77w.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lcXaR-00085W-UW;;;mid=<m1tunny77w.fsf@fess.ebiederm.org>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18u6Xoo8s58CoWsQdxvXXEoS28W8e953RU=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa04.xmission.com
X-Spam-Level: *
X-Spam-Status: No, score=1.0 required=8.0 tests=ALL_TRUSTED,BAYES_50,
	DCC_CHECK_NEGATIVE,LotsOfNums_01 autolearn=disabled version=3.4.2
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4226]
	*  1.2 LotsOfNums_01 BODY: Lots of long strings of numbers
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Dan Carpenter <dan.carpenter@oracle.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1699 ms - load_scoreonly_sql: 0.12 (0.0%),
	signal_user_changed: 14 (0.8%), b_tie_ro: 12 (0.7%), parse: 1.59
	(0.1%), extract_message_metadata: 25 (1.5%), get_uri_detail_list: 3.8
	(0.2%), tests_pri_-1000: 15 (0.9%), tests_pri_-950: 1.28 (0.1%),
	tests_pri_-900: 1.05 (0.1%), tests_pri_-90: 353 (20.8%), check_bayes:
	342 (20.2%), b_tokenize: 9 (0.5%), b_tok_get_all: 8 (0.5%),
	b_comp_prob: 2.6 (0.2%), b_tok_touch_all: 319 (18.8%), b_finish: 0.93
	(0.1%), tests_pri_0: 1276 (75.1%), check_dkim_signature: 0.53 (0.0%),
	check_dkim_adsp: 2.3 (0.1%), poll_dns_idle: 0.80 (0.0%), tests_pri_10:
	1.95 (0.1%), tests_pri_500: 6 (0.4%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH] ucounts: Silence warning in dec_rlimit_ucounts
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)


Dan Carpenter <dan.carpenter@oracle.com> wrote:
>
> url:    https://github.com/0day-ci/linux/commits/legion-kernel-org/Count-rlimits-in-each-user-namespace/20210427-162857
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest.git next
> config: arc-randconfig-m031-20210426 (attached as .config)
> compiler: arceb-elf-gcc (GCC) 9.3.0
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> smatch warnings:
> kernel/ucount.c:270 dec_rlimit_ucounts() error: uninitialized symbol 'new'.
>
> vim +/new +270 kernel/ucount.c
>
> 176ec2b092cc22 Alexey Gladkov 2021-04-22  260  bool dec_rlimit_ucounts(struct ucounts *ucounts, enum ucount_type type, long v)
> 176ec2b092cc22 Alexey Gladkov 2021-04-22  261  {
> 176ec2b092cc22 Alexey Gladkov 2021-04-22  262   struct ucounts *iter;
> 176ec2b092cc22 Alexey Gladkov 2021-04-22  263   long new;
>                                                 ^^^^^^^^
>
> 176ec2b092cc22 Alexey Gladkov 2021-04-22  264   for (iter = ucounts; iter; iter = iter->ns->ucounts) {
> 176ec2b092cc22 Alexey Gladkov 2021-04-22  265    long dec = atomic_long_add_return(-v, &iter->ucount[type]);
> 176ec2b092cc22 Alexey Gladkov 2021-04-22  266    WARN_ON_ONCE(dec < 0);
> 176ec2b092cc22 Alexey Gladkov 2021-04-22  267    if (iter == ucounts)
> 176ec2b092cc22 Alexey Gladkov 2021-04-22  268     new = dec;
> 176ec2b092cc22 Alexey Gladkov 2021-04-22  269   }
> 176ec2b092cc22 Alexey Gladkov 2021-04-22 @270   return (new == 0);
>                                                         ^^^^^^^^
> I don't know if this is a bug or not, but I can definitely tell why the
> static checker complains about it.
>
> 176ec2b092cc22 Alexey Gladkov 2021-04-22  271  }

In the only two cases that care about the return value of
dec_rlimit_ucounts the code first tests to see that ucounts is not
NULL.  In those cases it is guaranteed at least one iteration of the
loop will execute guaranteeing the variable new will be initialized.

Initialize new to -1 so that the return value is well defined even
when the loop does not execute and the static checker is silenced.

Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 kernel/ucount.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/ucount.c b/kernel/ucount.c
index d316bac3e520..12a48457bb86 100644
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -263,7 +263,7 @@ long inc_rlimit_ucounts(struct ucounts *ucounts, enum ucount_type type, long v)
 bool dec_rlimit_ucounts(struct ucounts *ucounts, enum ucount_type type, long v)
 {
 	struct ucounts *iter;
-	long new;
+	long new = -1; /* Silence compiler warnings */
 	for (iter = ucounts; iter; iter = iter->ns->ucounts) {
 		long dec = atomic_long_add_return(-v, &iter->ucount[type]);
 		WARN_ON_ONCE(dec < 0);
-- 
2.30.1

