Return-Path: <kernel-hardening-return-16746-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 91FFC84C4C
	for <lists+kernel-hardening@lfdr.de>; Wed,  7 Aug 2019 15:04:06 +0200 (CEST)
Received: (qmail 27765 invoked by uid 550); 7 Aug 2019 13:03:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 26592 invoked from network); 7 Aug 2019 13:03:52 -0000
From: Michael Ellerman <mpe@ellerman.id.au>
To: Jason Yan <yanaijie@huawei.com>, linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com, christophe.leroy@c-s.fr, benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com, keescook@chromium.org, kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com, yebin10@huawei.com, thunder.leizhen@huawei.com, jingxiangfeng@huawei.com, fanchengyang@huawei.com, zhaohongjiang@huawei.com, Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH v5 10/10] powerpc/fsl_booke/kaslr: dump out kernel offset information on panic
In-Reply-To: <20190807065706.11411-11-yanaijie@huawei.com>
References: <20190807065706.11411-1-yanaijie@huawei.com> <20190807065706.11411-11-yanaijie@huawei.com>
Date: Wed, 07 Aug 2019 23:03:35 +1000
Message-ID: <87zhklt9eg.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain

Jason Yan <yanaijie@huawei.com> writes:
> When kaslr is enabled, the kernel offset is different for every boot.
> This brings some difficult to debug the kernel. Dump out the kernel
> offset when panic so that we can easily debug the kernel.

Some of this is taken from the arm64 version right? Please say so when
you copy other people's code.

> diff --git a/arch/powerpc/kernel/machine_kexec.c b/arch/powerpc/kernel/machine_kexec.c
> index c4ed328a7b96..078fe3d76feb 100644
> --- a/arch/powerpc/kernel/machine_kexec.c
> +++ b/arch/powerpc/kernel/machine_kexec.c
> @@ -86,6 +86,7 @@ void arch_crash_save_vmcoreinfo(void)
>  	VMCOREINFO_STRUCT_SIZE(mmu_psize_def);
>  	VMCOREINFO_OFFSET(mmu_psize_def, shift);
>  #endif
> +	vmcoreinfo_append_str("KERNELOFFSET=%lx\n", kaslr_offset());
>  }

There's no mention of that in the commit log.

Please split it into a separate patch and describe what you're doing and
why.

> diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
> index 1f8db666468d..064075f02837 100644
> --- a/arch/powerpc/kernel/setup-common.c
> +++ b/arch/powerpc/kernel/setup-common.c
> @@ -715,12 +715,31 @@ static struct notifier_block ppc_panic_block = {
>  	.priority = INT_MIN /* may not return; must be done last */
>  };
>  
> +/*
> + * Dump out kernel offset information on panic.
> + */
> +static int dump_kernel_offset(struct notifier_block *self, unsigned long v,
> +			      void *p)
> +{
> +	pr_emerg("Kernel Offset: 0x%lx from 0x%lx\n",
> +		 kaslr_offset(), KERNELBASE);
> +
> +	return 0;
> +}
> +
> +static struct notifier_block kernel_offset_notifier = {
> +	.notifier_call = dump_kernel_offset
> +};
> +
>  void __init setup_panic(void)
>  {
>  	/* PPC64 always does a hard irq disable in its panic handler */
>  	if (!IS_ENABLED(CONFIG_PPC64) && !ppc_md.panic)
>  		return;
>  	atomic_notifier_chain_register(&panic_notifier_list, &ppc_panic_block);

> +	if (IS_ENABLED(CONFIG_RANDOMIZE_BASE) && kaslr_offset() > 0)
> +		atomic_notifier_chain_register(&panic_notifier_list,
> +					       &kernel_offset_notifier);

Don't you want to do that before the return above?

>  }

cheers
