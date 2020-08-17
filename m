Return-Path: <kernel-hardening-return-19647-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 4DF9E24717D
	for <lists+kernel-hardening@lfdr.de>; Mon, 17 Aug 2020 20:28:56 +0200 (CEST)
Received: (qmail 13893 invoked by uid 550); 17 Aug 2020 18:28:43 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13821 invoked from network); 17 Aug 2020 18:28:42 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexander Popov <alex.popov@linux.com>
Cc: Kees Cook <keescook@chromium.org>,  Jann Horn <jannh@google.com>,
 Will Deacon <will@kernel.org>,
 Andrey Ryabinin <aryabinin@virtuozzo.com>,
 Alexander Potapenko <glider@google.com>,
 Dmitry Vyukov <dvyukov@google.com>,  Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>,
 David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Masahiro Yamada <masahiroy@kernel.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Krzysztof Kozlowski <krzk@kernel.org>,
 Patrick Bellasi <patrick.bellasi@arm.com>,
 David Howells <dhowells@redhat.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Laura Abbott <labbott@redhat.com>,  Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 kasan-dev@googlegroups.com,  linux-mm@kvack.org,
 kernel-hardening@lists.openwall.com,  linux-kernel@vger.kernel.org,
 notify@kernel.org, Kexec Mailing List <kexec@lists.infradead.org> 
References: <20200813151922.1093791-1-alex.popov@linux.com>
	<20200813151922.1093791-3-alex.popov@linux.com>
Date: Mon, 17 Aug 2020 13:24:37 -0500
In-Reply-To: <20200813151922.1093791-3-alex.popov@linux.com> (Alexander
	Popov's message of "Thu, 13 Aug 2020 18:19:22 +0300")
Message-ID: <87zh6t9llm.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1k7jrj-0003E9-5O;;;mid=<87zh6t9llm.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+IYzzebB5ZnTtqYaH62lkbTUMdTHJJuM0=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa03.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=0.5 required=8.0 tests=ALL_TRUSTED,BAYES_40,
	DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG,XMNoVowels autolearn=disabled
	version=3.4.2
X-Spam-Virus: No
X-Spam-Report: 
	* -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3847]
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 0; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: ; sa03 0; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alexander Popov <alex.popov@linux.com>
X-Spam-Relay-Country: 
X-Spam-Timing: total 567 ms - load_scoreonly_sql: 0.03 (0.0%),
	signal_user_changed: 3.6 (0.6%), b_tie_ro: 2.4 (0.4%), parse: 1.22
	(0.2%), extract_message_metadata: 14 (2.5%), get_uri_detail_list: 2.4
	(0.4%), tests_pri_-1000: 9 (1.5%), tests_pri_-950: 1.47 (0.3%),
	tests_pri_-900: 1.36 (0.2%), tests_pri_-90: 236 (41.6%), check_bayes:
	226 (39.9%), b_tokenize: 16 (2.7%), b_tok_get_all: 59 (10.4%),
	b_comp_prob: 3.1 (0.5%), b_tok_touch_all: 145 (25.6%), b_finish: 0.71
	(0.1%), tests_pri_0: 290 (51.1%), check_dkim_signature: 0.41 (0.1%),
	check_dkim_adsp: 2.0 (0.4%), poll_dns_idle: 0.76 (0.1%), tests_pri_10:
	1.72 (0.3%), tests_pri_500: 5.0 (0.9%), rewrite_mail: 0.00 (0.0%)
Subject: Re: [PATCH RFC 2/2] lkdtm: Add heap spraying test
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Thu, 05 May 2016 13:38:54 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)

Alexander Popov <alex.popov@linux.com> writes:

> Add a simple test for CONFIG_SLAB_QUARANTINE.
>
> It performs heap spraying that aims to reallocate the recently freed heap
> object. This technique is used for exploiting use-after-free
> vulnerabilities in the kernel code.
>
> This test shows that CONFIG_SLAB_QUARANTINE breaks heap spraying
> exploitation technique.
>
> Signed-off-by: Alexander Popov <alex.popov@linux.com>

Why put this test in the linux kernel dump test module?

I have no problem with tests, and I may be wrong but this
does not look like you are testing to see if heap corruption
triggers a crash dump.  Which is what the rest of the tests
in lkdtm are about.  Seeing if the test triggers successfully
triggers a crash dump.

Eric

> ---
>  drivers/misc/lkdtm/core.c  |  1 +
>  drivers/misc/lkdtm/heap.c  | 40 ++++++++++++++++++++++++++++++++++++++
>  drivers/misc/lkdtm/lkdtm.h |  1 +
>  3 files changed, 42 insertions(+)
>
> diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
> index a5e344df9166..78b7669c35eb 100644
> --- a/drivers/misc/lkdtm/core.c
> +++ b/drivers/misc/lkdtm/core.c
> @@ -126,6 +126,7 @@ static const struct crashtype crashtypes[] = {
>  	CRASHTYPE(SLAB_FREE_DOUBLE),
>  	CRASHTYPE(SLAB_FREE_CROSS),
>  	CRASHTYPE(SLAB_FREE_PAGE),
> +	CRASHTYPE(HEAP_SPRAY),
>  	CRASHTYPE(SOFTLOCKUP),
>  	CRASHTYPE(HARDLOCKUP),
>  	CRASHTYPE(SPINLOCKUP),
> diff --git a/drivers/misc/lkdtm/heap.c b/drivers/misc/lkdtm/heap.c
> index 1323bc16f113..a72a241e314a 100644
> --- a/drivers/misc/lkdtm/heap.c
> +++ b/drivers/misc/lkdtm/heap.c
> @@ -205,6 +205,46 @@ static void ctor_a(void *region)
>  static void ctor_b(void *region)
>  { }
>  
> +#define HEAP_SPRAY_SIZE 128
> +
> +void lkdtm_HEAP_SPRAY(void)
> +{
> +	int *addr;
> +	int *spray_addrs[HEAP_SPRAY_SIZE] = { 0 };
> +	unsigned long i = 0;
> +
> +	addr = kmem_cache_alloc(a_cache, GFP_KERNEL);
> +	if (!addr) {
> +		pr_info("Unable to allocate memory in lkdtm-heap-a cache\n");
> +		return;
> +	}
> +
> +	*addr = 0x31337;
> +	kmem_cache_free(a_cache, addr);
> +
> +	pr_info("Performing heap spraying...\n");
> +	for (i = 0; i < HEAP_SPRAY_SIZE; i++) {
> +		spray_addrs[i] = kmem_cache_alloc(a_cache, GFP_KERNEL);
> +		*spray_addrs[i] = 0x31337;
> +		pr_info("attempt %lu: spray alloc addr %p vs freed addr %p\n",
> +						i, spray_addrs[i], addr);
> +		if (spray_addrs[i] == addr) {
> +			pr_info("freed addr is reallocated!\n");
> +			break;
> +		}
> +	}
> +
> +	if (i < HEAP_SPRAY_SIZE)
> +		pr_info("FAIL! Heap spraying succeed :(\n");
> +	else
> +		pr_info("OK! Heap spraying hasn't succeed :)\n");
> +
> +	for (i = 0; i < HEAP_SPRAY_SIZE; i++) {
> +		if (spray_addrs[i])
> +			kmem_cache_free(a_cache, spray_addrs[i]);
> +	}
> +}
> +
>  void __init lkdtm_heap_init(void)
>  {
>  	double_free_cache = kmem_cache_create("lkdtm-heap-double_free",
> diff --git a/drivers/misc/lkdtm/lkdtm.h b/drivers/misc/lkdtm/lkdtm.h
> index 8878538b2c13..dfafb4ae6f3a 100644
> --- a/drivers/misc/lkdtm/lkdtm.h
> +++ b/drivers/misc/lkdtm/lkdtm.h
> @@ -45,6 +45,7 @@ void lkdtm_READ_BUDDY_AFTER_FREE(void);
>  void lkdtm_SLAB_FREE_DOUBLE(void);
>  void lkdtm_SLAB_FREE_CROSS(void);
>  void lkdtm_SLAB_FREE_PAGE(void);
> +void lkdtm_HEAP_SPRAY(void);
>  
>  /* lkdtm_perms.c */
>  void __init lkdtm_perms_init(void);
