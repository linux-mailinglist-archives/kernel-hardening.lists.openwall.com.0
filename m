Return-Path: <kernel-hardening-return-16744-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id CA23B84C48
	for <lists+kernel-hardening@lfdr.de>; Wed,  7 Aug 2019 15:03:48 +0200 (CEST)
Received: (qmail 24459 invoked by uid 550); 7 Aug 2019 13:03:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 24376 invoked from network); 7 Aug 2019 13:03:39 -0000
From: Michael Ellerman <mpe@ellerman.id.au>
To: Jason Yan <yanaijie@huawei.com>, linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com, christophe.leroy@c-s.fr, benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com, keescook@chromium.org, kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org, wangkefeng.wang@huawei.com, yebin10@huawei.com, thunder.leizhen@huawei.com, jingxiangfeng@huawei.com, fanchengyang@huawei.com, zhaohongjiang@huawei.com, Jason Yan <yanaijie@huawei.com>
Subject: Re: [PATCH v5 03/10] powerpc: introduce kimage_vaddr to store the kernel base
In-Reply-To: <20190807065706.11411-4-yanaijie@huawei.com>
References: <20190807065706.11411-1-yanaijie@huawei.com> <20190807065706.11411-4-yanaijie@huawei.com>
Date: Wed, 07 Aug 2019 23:03:23 +1000
Message-ID: <8736idunz8.fsf@concordia.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain

Jason Yan <yanaijie@huawei.com> writes:
> Now the kernel base is a fixed value - KERNELBASE. To support KASLR, we
> need a variable to store the kernel base.
>
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
>  arch/powerpc/include/asm/page.h | 2 ++
>  arch/powerpc/mm/init-common.c   | 2 ++
>  2 files changed, 4 insertions(+)
>
> diff --git a/arch/powerpc/include/asm/page.h b/arch/powerpc/include/asm/page.h
> index 0d52f57fca04..60a68d3a54b1 100644
> --- a/arch/powerpc/include/asm/page.h
> +++ b/arch/powerpc/include/asm/page.h
> @@ -315,6 +315,8 @@ void arch_free_page(struct page *page, int order);
>  
>  struct vm_area_struct;
>  
> +extern unsigned long kimage_vaddr;
> +
>  #include <asm-generic/memory_model.h>
>  #endif /* __ASSEMBLY__ */
>  #include <asm/slice.h>
> diff --git a/arch/powerpc/mm/init-common.c b/arch/powerpc/mm/init-common.c
> index 152ae0d21435..d4801ce48dc5 100644
> --- a/arch/powerpc/mm/init-common.c
> +++ b/arch/powerpc/mm/init-common.c
> @@ -25,6 +25,8 @@ phys_addr_t memstart_addr = (phys_addr_t)~0ull;
>  EXPORT_SYMBOL_GPL(memstart_addr);
>  phys_addr_t kernstart_addr;
>  EXPORT_SYMBOL_GPL(kernstart_addr);
> +unsigned long kimage_vaddr = KERNELBASE;
> +EXPORT_SYMBOL_GPL(kimage_vaddr);

The names of the #defines and variables we use for these values are not
very consistent already, but using kimage_vaddr makes it worse I think.

Isn't this going to have the same value as kernstart_addr, but the
virtual rather than physical address?

If so kernstart_virt_addr would seem better.

cheers
