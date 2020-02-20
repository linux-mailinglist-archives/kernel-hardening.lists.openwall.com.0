Return-Path: <kernel-hardening-return-17857-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 646FD165F2C
	for <lists+kernel-hardening@lfdr.de>; Thu, 20 Feb 2020 14:50:02 +0100 (CET)
Received: (qmail 7908 invoked by uid 550); 20 Feb 2020 13:49:57 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7871 invoked from network); 20 Feb 2020 13:49:57 -0000
Authentication-Results: localhost; dkim=pass
	reason="1024-bit key; insecure key"
	header.d=c-s.fr header.i=@c-s.fr header.b=Mlu6cmGM; dkim-adsp=pass;
	dkim-atps=neutral
X-Virus-Scanned: Debian amavisd-new at c-s.fr
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=c-s.fr; s=mail;
	t=1582206584; bh=BNmen+R0A95fKF9yP5dTxuzGe+sL7dAQ7ChpuSoUS5c=;
	h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
	b=Mlu6cmGMba4L0sYZwxMEPfQwvJ+HCjrFncFIsGGZhNyFJqdvp9qEWWiTgnEWpp9RL
	 pciPb9n1ehAPK8yK4dlvakvdTx+sF/pfbSYPOROhLft3wEXG7RqrGpunAuYLHnv2JL
	 o4VjCgVlhpSuA13ZUihgB11Y+lLOuB4UgA0nkJHE=
X-Virus-Scanned: amavisd-new at c-s.fr
Subject: Re: [PATCH v3 5/6] powerpc/fsl_booke/64: clear the original kernel if
 randomized
To: Jason Yan <yanaijie@huawei.com>, mpe@ellerman.id.au,
 linuxppc-dev@lists.ozlabs.org, diana.craciun@nxp.com,
 benh@kernel.crashing.org, paulus@samba.org, npiggin@gmail.com,
 keescook@chromium.org, kernel-hardening@lists.openwall.com, oss@buserror.net
Cc: linux-kernel@vger.kernel.org, zhaohongjiang@huawei.com
References: <20200206025825.22934-1-yanaijie@huawei.com>
 <20200206025825.22934-6-yanaijie@huawei.com>
From: Christophe Leroy <christophe.leroy@c-s.fr>
Message-ID: <0f778e1c-5e29-e600-1cf0-aeb3e1a6fe08@c-s.fr>
Date: Thu, 20 Feb 2020 14:49:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200206025825.22934-6-yanaijie@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: fr
Content-Transfer-Encoding: 8bit



Le 06/02/2020 à 03:58, Jason Yan a écrit :
> The original kernel still exists in the memory, clear it now.

No such problem with PPC32 ? Or is that common ?

Christophe

> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> Cc: Scott Wood <oss@buserror.net>
> Cc: Diana Craciun <diana.craciun@nxp.com>
> Cc: Michael Ellerman <mpe@ellerman.id.au>
> Cc: Christophe Leroy <christophe.leroy@c-s.fr>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Nicholas Piggin <npiggin@gmail.com>
> Cc: Kees Cook <keescook@chromium.org>
> ---
>   arch/powerpc/mm/nohash/kaslr_booke.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/powerpc/mm/nohash/kaslr_booke.c b/arch/powerpc/mm/nohash/kaslr_booke.c
> index c6f5c1db1394..ed1277059368 100644
> --- a/arch/powerpc/mm/nohash/kaslr_booke.c
> +++ b/arch/powerpc/mm/nohash/kaslr_booke.c
> @@ -378,8 +378,10 @@ notrace void __init kaslr_early_init(void *dt_ptr, phys_addr_t size)
>   	unsigned int *__kaslr_offset = (unsigned int *)(KERNELBASE + 0x58);
>   	unsigned int *__run_at_load = (unsigned int *)(KERNELBASE + 0x5c);
>   
> -	if (*__run_at_load == 1)
> +	if (*__run_at_load == 1) {
> +		kaslr_late_init();
>   		return;
> +	}
>   
>   	/* Setup flat device-tree pointer */
>   	initial_boot_params = dt_ptr;
> 
