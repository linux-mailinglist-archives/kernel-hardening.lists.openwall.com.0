Return-Path: <kernel-hardening-return-18918-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 31E811ECDB8
	for <lists+kernel-hardening@lfdr.de>; Wed,  3 Jun 2020 12:39:18 +0200 (CEST)
Received: (qmail 24215 invoked by uid 550); 3 Jun 2020 10:39:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 9274 invoked from network); 3 Jun 2020 07:21:12 -0000
X-Virus-Scanned: Debian amavisd-new at c-s.fr
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [PATCH 5/5] powerpc: Add LKDTM test to hijack a patch mapping
To: "Christopher M. Riedl" <cmr@informatik.wtf>,
 linuxppc-dev@lists.ozlabs.org, kernel-hardening@lists.openwall.com
References: <20200603051912.23296-1-cmr@informatik.wtf>
 <20200603051912.23296-6-cmr@informatik.wtf>
From: Christophe Leroy <christophe.leroy@csgroup.eu>
Message-ID: <6fcbff8c-fe24-f35c-ec95-84fdaa3b869c@csgroup.eu>
Date: Wed, 3 Jun 2020 09:20:50 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200603051912.23296-6-cmr@informatik.wtf>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit



Le 03/06/2020 à 07:19, Christopher M. Riedl a écrit :
> When live patching with STRICT_KERNEL_RWX, the CPU doing the patching
> must use a temporary mapping which allows for writing to kernel text.
> During the entire window of time when this temporary mapping is in use,
> another CPU could write to the same mapping and maliciously alter kernel
> text. Implement a LKDTM test to attempt to exploit such a openings when
> a CPU is patching under STRICT_KERNEL_RWX. The test is only implemented
> on powerpc for now.
> 
> The LKDTM "hijack" test works as follows:
> 
> 	1. A CPU executes an infinite loop to patch an instruction.
> 	   This is the "patching" CPU.
> 	2. Another CPU attempts to write to the address of the temporary
> 	   mapping used by the "patching" CPU. This other CPU is the
> 	   "hijacker" CPU. The hijack either fails with a segfault or
> 	   succeeds, in which case some kernel text is now overwritten.
> 
> How to run the test:
> 
> 	mount -t debugfs none /sys/kernel/debug
> 	(echo HIJACK_PATCH > /sys/kernel/debug/provoke-crash/DIRECT)
> 
> Signed-off-by: Christopher M. Riedl <cmr@informatik.wtf>
> ---
>   drivers/misc/lkdtm/core.c  |   1 +
>   drivers/misc/lkdtm/lkdtm.h |   1 +
>   drivers/misc/lkdtm/perms.c | 101 +++++++++++++++++++++++++++++++++++++
>   3 files changed, 103 insertions(+)
> 
> diff --git a/drivers/misc/lkdtm/core.c b/drivers/misc/lkdtm/core.c
> index a5e344df9166..482e72f6a1e1 100644
> --- a/drivers/misc/lkdtm/core.c
> +++ b/drivers/misc/lkdtm/core.c
> @@ -145,6 +145,7 @@ static const struct crashtype crashtypes[] = {
>   	CRASHTYPE(WRITE_RO),
>   	CRASHTYPE(WRITE_RO_AFTER_INIT),
>   	CRASHTYPE(WRITE_KERN),
> +	CRASHTYPE(HIJACK_PATCH),
>   	CRASHTYPE(REFCOUNT_INC_OVERFLOW),
>   	CRASHTYPE(REFCOUNT_ADD_OVERFLOW),
>   	CRASHTYPE(REFCOUNT_INC_NOT_ZERO_OVERFLOW),
> diff --git a/drivers/misc/lkdtm/lkdtm.h b/drivers/misc/lkdtm/lkdtm.h
> index 601a2156a0d4..bfcf3542370d 100644
> --- a/drivers/misc/lkdtm/lkdtm.h
> +++ b/drivers/misc/lkdtm/lkdtm.h
> @@ -62,6 +62,7 @@ void lkdtm_EXEC_USERSPACE(void);
>   void lkdtm_EXEC_NULL(void);
>   void lkdtm_ACCESS_USERSPACE(void);
>   void lkdtm_ACCESS_NULL(void);
> +void lkdtm_HIJACK_PATCH(void);
>   
>   /* lkdtm_refcount.c */
>   void lkdtm_REFCOUNT_INC_OVERFLOW(void);
> diff --git a/drivers/misc/lkdtm/perms.c b/drivers/misc/lkdtm/perms.c
> index 62f76d506f04..8bda3b56bc78 100644
> --- a/drivers/misc/lkdtm/perms.c
> +++ b/drivers/misc/lkdtm/perms.c
> @@ -9,6 +9,7 @@
>   #include <linux/vmalloc.h>
>   #include <linux/mman.h>
>   #include <linux/uaccess.h>
> +#include <linux/kthread.h>
>   #include <asm/cacheflush.h>
>   
>   /* Whether or not to fill the target memory area with do_nothing(). */
> @@ -213,6 +214,106 @@ void lkdtm_ACCESS_NULL(void)
>   	*ptr = tmp;
>   }
>   
> +#if defined(CONFIG_PPC) && defined(CONFIG_STRICT_KERNEL_RWX)

Why only PPC ? I understood that this applies also to x86. And 
regarless, the test should be able to run on other architectures, 
allthought for sure it will fail. That's the case for other tests.

> +#include <include/asm/code-patching.h>
> +
> +extern unsigned long read_cpu_patching_addr(unsigned int cpu);

'extern' keyword is useless for functions and shall be banned.

Shouldn't this declaration be in asm/code-patching.h ?

> +
> +static struct ppc_inst * const patch_site = (struct ppc_inst *)&do_nothing;
> +
> +static int lkdtm_patching_cpu(void *data)
> +{
> +	int err = 0;
> +	struct ppc_inst insn = ppc_inst(0xdeadbeef);
> +
> +	pr_info("starting patching_cpu=%d\n", smp_processor_id());
> +	do {
> +		err = patch_instruction(patch_site, insn);
> +	} while (ppc_inst_equal(ppc_inst_read(READ_ONCE(patch_site)), insn) &&
> +			!err && !kthread_should_stop());
> +
> +	if (err)
> +		pr_warn("patch_instruction returned error: %d\n", err);
> +
> +	set_current_state(TASK_INTERRUPTIBLE);
> +	while (!kthread_should_stop()) {
> +		schedule();
> +		set_current_state(TASK_INTERRUPTIBLE);
> +	}
> +
> +	return err;
> +}
> +
> +void lkdtm_HIJACK_PATCH(void)
> +{
> +	struct task_struct *patching_kthrd;
> +	struct ppc_inst original_insn;
> +	int patching_cpu, hijacker_cpu, attempts;
> +	unsigned long addr;
> +	bool hijacked;
> +
> +	if (num_online_cpus() < 2) {
> +		pr_warn("need at least two cpus\n");
> +		return;
> +	}
> +
> +	original_insn = ppc_inst_read(READ_ONCE(patch_site));
> +
> +	hijacker_cpu = smp_processor_id();
> +	patching_cpu = cpumask_any_but(cpu_online_mask, hijacker_cpu);
> +
> +	patching_kthrd = kthread_create_on_node(&lkdtm_patching_cpu, NULL,
> +						cpu_to_node(patching_cpu),
> +						"lkdtm_patching_cpu");
> +	kthread_bind(patching_kthrd, patching_cpu);
> +	wake_up_process(patching_kthrd);
> +
> +	addr = offset_in_page(patch_site) | read_cpu_patching_addr(patching_cpu);
> +
> +	pr_info("starting hijacker_cpu=%d\n", hijacker_cpu);
> +	for (attempts = 0; attempts < 100000; ++attempts) {
> +		/* Use __put_user to catch faults without an Oops */
> +		hijacked = !__put_user(0xbad00bad, (unsigned int *)addr);
> +
> +		if (hijacked) {
> +			if (kthread_stop(patching_kthrd))
> +				goto out;
> +			break;
> +		}
> +	}
> +	pr_info("hijack attempts: %d\n", attempts);
> +
> +	if (hijacked) {
> +		if (*(unsigned int *)READ_ONCE(patch_site) == 0xbad00bad)
> +			pr_err("overwrote kernel text\n");
> +		/*
> +		 * There are window conditions where the hijacker cpu manages to
> +		 * write to the patch site but the site gets overwritten again by
> +		 * the patching cpu. We still consider that a "successful" hijack
> +		 * since the hijacker cpu did not fault on the write.
> +		 */
> +		pr_err("FAIL: wrote to another cpu's patching area\n");
> +	} else {
> +		kthread_stop(patching_kthrd);
> +	}
> +
> +out:
> +	/* Restore the original insn for any future lkdtm tests */
> +	patch_instruction(patch_site, original_insn);
> +}
> +
> +#else
> +
> +void lkdtm_HIJACK_PATCH(void)
> +{
> +	if (!IS_ENABLED(CONFIG_PPC))
> +		pr_err("XFAIL: this test is powerpc-only\n");
> +	if (!IS_ENABLED(CONFIG_STRICT_KERNEL_RWX))
> +		pr_err("XFAIL: this test requires CONFIG_STRICT_KERNEL_RWX\n");
> +}
> +
> +#endif /* CONFIG_PPC && CONFIG_STRICT_KERNEL_RWX */
> +
>   void __init lkdtm_perms_init(void)
>   {
>   	/* Make sure we can write to __ro_after_init values during __init */
> 

Christophe
