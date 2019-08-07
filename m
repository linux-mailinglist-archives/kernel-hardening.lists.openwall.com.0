Return-Path: <kernel-hardening-return-16750-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 0498284C93
	for <lists+kernel-hardening@lfdr.de>; Wed,  7 Aug 2019 15:13:37 +0200 (CEST)
Received: (qmail 17533 invoked by uid 550); 7 Aug 2019 13:13:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17497 invoked from network); 7 Aug 2019 13:13:31 -0000
From: Michael Ellerman <mpe@ellerman.id.au>
To: Jason Yan <yanaijie@huawei.com>, linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com, christophe.leroy@c-s.fr, benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com, keescook@chromium.org, kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com, yebin10@huawei.com, thunder.leizhen@huawei.com, jingxiangfeng@huawei.com, fanchengyang@huawei.com, zhaohongjiang@huawei.com, Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH v5 01/10] powerpc: unify definition of M_IF_NEEDED
In-Reply-To: <20190807065706.11411-2-yanaijie@huawei.com>
References: <20190807065706.11411-1-yanaijie@huawei.com> <20190807065706.11411-2-yanaijie@huawei.com>
Date: Wed, 07 Aug 2019 23:13:15 +1000
Message-ID: <87sgqdt8yc.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain

Jason Yan <yanaijie@huawei.com> writes:
> M_IF_NEEDED is defined too many times. Move it to a common place.

The name is not great, can you call it MAS2_M_IF_NEEDED, which at least
gives a clue what it's for?

cheers

> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> Cc: Diana Craciun <diana.craciun@nxp.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Kees Cook <keescook@chromium.org>
> Reviewed-by: Christophe Leroy <christophe.leroy@c-s.fr>
> Reviewed-by: Diana Craciun <diana.craciun@nxp.com>
> Tested-by: Diana Craciun <diana.craciun@nxp.com>
> ---
>  arch/powerpc/include/asm/nohash/mmu-book3e.h  | 10 ++++++++++
>  arch/powerpc/kernel/exceptions-64e.S          | 10 ----------
>  arch/powerpc/kernel/fsl_booke_entry_mapping.S | 10 ----------
>  arch/powerpc/kernel/misc_64.S                 |  5 -----
>  4 files changed, 10 insertions(+), 25 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/nohash/mmu-book3e.h b/arch/powerpc/include/asm/nohash/mmu-book3e.h
> index 4c9777d256fb..0877362e48fa 100644
> --- a/arch/powerpc/include/asm/nohash/mmu-book3e.h
> +++ b/arch/powerpc/include/asm/nohash/mmu-book3e.h
> @@ -221,6 +221,16 @@
>  #define TLBILX_T_CLASS2			6
>  #define TLBILX_T_CLASS3			7
>  
> +/*
> + * The mapping only needs to be cache-coherent on SMP, except on
> + * Freescale e500mc derivatives where it's also needed for coherent DMA.
> + */
> +#if defined(CONFIG_SMP) || defined(CONFIG_PPC_E500MC)
> +#define M_IF_NEEDED	MAS2_M
> +#else
> +#define M_IF_NEEDED	0
> +#endif
> +
>  #ifndef __ASSEMBLY__
>  #include <asm/bug.h>
>  
> diff --git a/arch/powerpc/kernel/exceptions-64e.S b/arch/powerpc/kernel/exceptions-64e.S
> index 1cfb3da4a84a..fd49ec07ce4a 100644
> --- a/arch/powerpc/kernel/exceptions-64e.S
> +++ b/arch/powerpc/kernel/exceptions-64e.S
> @@ -1342,16 +1342,6 @@ skpinv:	addi	r6,r6,1				/* Increment */
>  	sync
>  	isync
>  
> -/*
> - * The mapping only needs to be cache-coherent on SMP, except on
> - * Freescale e500mc derivatives where it's also needed for coherent DMA.
> - */
> -#if defined(CONFIG_SMP) || defined(CONFIG_PPC_E500MC)
> -#define M_IF_NEEDED	MAS2_M
> -#else
> -#define M_IF_NEEDED	0
> -#endif
> -
>  /* 6. Setup KERNELBASE mapping in TLB[0]
>   *
>   * r3 = MAS0 w/TLBSEL & ESEL for the entry we started in
> diff --git a/arch/powerpc/kernel/fsl_booke_entry_mapping.S b/arch/powerpc/kernel/fsl_booke_entry_mapping.S
> index ea065282b303..de0980945510 100644
> --- a/arch/powerpc/kernel/fsl_booke_entry_mapping.S
> +++ b/arch/powerpc/kernel/fsl_booke_entry_mapping.S
> @@ -153,16 +153,6 @@ skpinv:	addi	r6,r6,1				/* Increment */
>  	tlbivax 0,r9
>  	TLBSYNC
>  
> -/*
> - * The mapping only needs to be cache-coherent on SMP, except on
> - * Freescale e500mc derivatives where it's also needed for coherent DMA.
> - */
> -#if defined(CONFIG_SMP) || defined(CONFIG_PPC_E500MC)
> -#define M_IF_NEEDED	MAS2_M
> -#else
> -#define M_IF_NEEDED	0
> -#endif
> -
>  #if defined(ENTRY_MAPPING_BOOT_SETUP)
>  
>  /* 6. Setup KERNELBASE mapping in TLB1[0] */
> diff --git a/arch/powerpc/kernel/misc_64.S b/arch/powerpc/kernel/misc_64.S
> index b55a7b4cb543..26074f92d4bc 100644
> --- a/arch/powerpc/kernel/misc_64.S
> +++ b/arch/powerpc/kernel/misc_64.S
> @@ -432,11 +432,6 @@ kexec_create_tlb:
>  	rlwimi	r9,r10,16,4,15		/* Setup MAS0 = TLBSEL | ESEL(r9) */
>  
>  /* Set up a temp identity mapping v:0 to p:0 and return to it. */
> -#if defined(CONFIG_SMP) || defined(CONFIG_PPC_E500MC)
> -#define M_IF_NEEDED	MAS2_M
> -#else
> -#define M_IF_NEEDED	0
> -#endif
>  	mtspr	SPRN_MAS0,r9
>  
>  	lis	r9,(MAS1_VALID|MAS1_IPROT)@h
> -- 
> 2.17.2
