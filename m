Return-Path: <kernel-hardening-return-16635-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 9A6867A414
	for <lists+kernel-hardening@lfdr.de>; Tue, 30 Jul 2019 11:26:43 +0200 (CEST)
Received: (qmail 12165 invoked by uid 550); 30 Jul 2019 09:26:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 12133 invoked from network); 30 Jul 2019 09:26:35 -0000
Authentication-Results: localhost; dkim=pass
	reason="1024-bit key; insecure key"
	header.d=c-s.fr header.i=@c-s.fr header.b=LguhQ+mC; dkim-adsp=pass;
	dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
	t=1564478782; bh=W494YaqgUnZA2FNm31/aP5pf5NOo4mChfve8KHyIrgo=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=LguhQ+mCh1Cl3JcH0/tMBY4TpGOZyqIb++mijiTCVHZV09QnAoXuaDmUQdnmZ57bd
	 uf6sUo38sJhtq7e2HwZwA24AxJF+bkaGLEpd049BpDFMLI3hds8qFwgxi7w51ec2+X
	 +hsuVhzyeJirIeuY8ttS9wqtcP8mSTxpvyoaAOyM=
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [PATCH v2 05/10] powerpc/fsl_booke/32: introduce
 reloc_kernel_entry() helper
To: Jason Yan <yanaijie@huawei.com>, mpe@ellerman.id.au,
 linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com,
 benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com,
 keescook@chromium.org, kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com,
 yebin10@huawei.com, thunder.leizhen@huawei.com, jingxiangfeng@huawei.com,
 fanchengyang@huawei.com, zhaohongjiang@huawei.com
References: <20190730074225.39544-1-yanaijie@huawei.com>
 <20190730074225.39544-6-yanaijie@huawei.com>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <a1159f8e-ba34-5568-aef0-31f3a8b65449@c-s.fr>
Date: Tue, 30 Jul 2019 11:26:23 +0200
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190730074225.39544-6-yanaijie@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit



Le 30/07/2019 à 09:42, Jason Yan a écrit :
> Add a new helper reloc_kernel_entry() to jump back to the start of the
> new kernel. After we put the new kernel in a randomized place we can use
> this new helper to enter the kernel and begin to relocate again.
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> Cc: Diana Craciun <diana.craciun@nxp.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Kees Cook <keescook@chromium.org>

Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>

> ---
>   arch/powerpc/kernel/head_fsl_booke.S | 13 +++++++++++++
>   arch/powerpc/mm/mmu_decl.h           |  1 +
>   2 files changed, 14 insertions(+)
> 
> diff --git a/arch/powerpc/kernel/head_fsl_booke.S b/arch/powerpc/kernel/head_fsl_booke.S
> index 04d124fee17d..2083382dd662 100644
> --- a/arch/powerpc/kernel/head_fsl_booke.S
> +++ b/arch/powerpc/kernel/head_fsl_booke.S
> @@ -1143,6 +1143,19 @@ _GLOBAL(create_tlb_entry)
>   	sync
>   	blr
>   
> +/*
> + * Return to the start of the relocated kernel and run again
> + * r3 - virtual address of fdt
> + * r4 - entry of the kernel
> + */
> +_GLOBAL(reloc_kernel_entry)
> +	mfmsr	r7
> +	rlwinm	r7, r7, 0, ~(MSR_IS | MSR_DS)
> +
> +	mtspr	SPRN_SRR0,r4
> +	mtspr	SPRN_SRR1,r7
> +	rfi
> +
>   /*
>    * Create a tlb entry with the same effective and physical address as
>    * the tlb entry used by the current running code. But set the TS to 1.
> diff --git a/arch/powerpc/mm/mmu_decl.h b/arch/powerpc/mm/mmu_decl.h
> index a09f89d3aa0f..804da298beb3 100644
> --- a/arch/powerpc/mm/mmu_decl.h
> +++ b/arch/powerpc/mm/mmu_decl.h
> @@ -143,6 +143,7 @@ extern void adjust_total_lowmem(void);
>   extern int switch_to_as1(void);
>   extern void restore_to_as0(int esel, int offset, void *dt_ptr, int bootcpu);
>   void create_tlb_entry(phys_addr_t phys, unsigned long virt, int entry);
> +void reloc_kernel_entry(void *fdt, int addr);
>   #endif
>   extern void loadcam_entry(unsigned int index);
>   extern void loadcam_multi(int first_idx, int num, int tmp_idx);
> 
